function results = compute(y, fs, params)
%COMPUTE VibratoScope cycle-based vibrato analysis
%   RESULTS = COMPUTE(Y, FS, PARAMS) analyzes audio signal Y at sample rate FS
%   using VibratoScope parameters PARAMS.
%
%   Rewritten from Python reference: tiagolbc/vibratoscope (MIT License)
%   Reference: Cruz, T. L. B. (2025). Zenodo. DOI: 10.5281/zenodo.15519845

    if nargin < 3
        params = struct();
    end

    % --- Set defaults for missing params ---
    defaults = VibratoAnalysis.VibratoScope.descriptor();
    fnames = fieldnames(defaults.params);
    for k = 1:numel(fnames)
        if ~isfield(params, fnames{k})
            params.(fnames{k}) = defaults.params.(fnames{k}).default;
        end
    end

    % --- Initialize outputs ---
    results.success = false;
    results.warnings = {};
    results.pitchHz = NaN;
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.meanRate_Hz = NaN;
    results.medianRate_Hz = NaN;
    results.meanExtent_cents = NaN;
    results.medianExtent_cents = NaN;
    results.jitter = NaN;
    results.cvRate = NaN;
    results.cvExtent = NaN;
    results.sampEn = NaN;
    results.nCycles = 0;
    results.cycles = struct();
    results.intermediates = struct();

    % --- Step 1: Pitch extraction ---
    pitchMethod = 'SWIPE''';
    if isfield(params, 'pitchTracker'), pitchMethod = params.pitchTracker; end
    pitchOpts = struct();
    if isfield(params, 'pitchOpts'), pitchOpts = params.pitchOpts; end
    try
        [pitchHz, pitchTime, pitchStrength] = VibratoAnalysis.extractPitch(y, fs, pitchMethod, pitchOpts);
    catch ME
        results.warnings{end+1} = ['Pitch extraction failed: ' ME.message];
        return;
    end

    % Remove low-confidence pitch estimates
    pitchHz(pitchStrength < 0.3) = NaN;

    % Remove pitch outliers using MAD (from filters.py: filter_pitch_outliers)
    pitchHz = VibratoAnalysis.VibratoScope.filterPitchOutliers(pitchHz, params.outlierThreshold);

    validPitch = ~isnan(pitchHz) & pitchHz > 0;
    if sum(validPitch) < 10
        results.warnings{end+1} = 'Too few valid pitch points for analysis';
        return;
    end

    results.pitchHz = mean(pitchHz(validPitch), 'omitnan');

    % --- Step 2: Convert to cents (from utils.py: convert_to_cents) ---
    cents = VibratoAnalysis.VibratoScope.convertToCents(pitchHz, 440);

    % --- Step 3: Remove median (from utils.py: remove_mean_or_median) ---
    centsCentered = VibratoAnalysis.VibratoScope.removeMeanOrMedian(cents, true);

    % --- Step 4: Resample to uniform time grid (from utils.py: resample_to_uniform_time) ---
    [tUniform, centsUniform] = VibratoAnalysis.VibratoScope.resampleToUniformTime(pitchTime, centsCentered, params.resampleFs);

    if isempty(tUniform) || numel(tUniform) < 20
        results.warnings{end+1} = 'Insufficient data after resampling';
        return;
    end

    results.intermediates.pitchHz = pitchHz;
    results.intermediates.pitchTime = pitchTime;
    results.intermediates.tUniform = tUniform;
    results.intermediates.centsUniform = centsUniform;

    % --- Step 5: Bandpass filter (from filters.py: apply_bandpass_filter) ---
    try
        centsFiltered = VibratoAnalysis.VibratoScope.applyBandpassFilter(centsUniform, params.resampleFs, ...
            params.bpLowHz, params.bpHighHz, params.bpOrder);
    catch ME
        results.warnings{end+1} = ['Bandpass filter failed: ' ME.message];
        return;
    end

    results.intermediates.centsFiltered = centsFiltered;

    % --- Step 6: Detect vibrato cycles (from core.py: detect_vibrato_cycles) ---
    [peaks, troughs, cycleTimes, cycleHalfExtents, tValid, rawCents, allIdx] = ...
        VibratoAnalysis.VibratoScope.detectVibratoCycles(tUniform, centsUniform, centsFiltered, ...
            params.peakProminence, params.peakDistance);

    if isempty(cycleTimes)
        results.warnings{end+1} = 'No vibrato cycles detected';
        results.nCycles = 0;
        results.success = true;
        return;
    end

    % --- Step 7: Compute per-cycle parameters (from core.py: compute_cycle_parameters) ---
    cycleParams = VibratoAnalysis.VibratoScope.computeCycleParameters(tValid, rawCents, cycleHalfExtents, allIdx);

    % --- Step 8: Filter cycles by extent (from core.py: filter_vibrato_cycles) ---
    cycleParams = VibratoAnalysis.VibratoScope.filterVibratoCycles(cycleParams, params.minHalfExtent, params.maxHalfExtent);

    if isempty(cycleParams)
        results.warnings{end+1} = 'No cycles survived extent filtering';
        results.nCycles = 0;
        results.success = true;
        return;
    end

    results.nCycles = numel(cycleParams);
    results.cycles = cycleParams;

    % --- Step 9: Compute summary statistics (from core.py: analyze_vibrato) ---
    cyclePeriods = cellfun(@(c) c.cycle_time, cycleParams);
    cycleExtents = cellfun(@(c) c.half_extent_cents, cycleParams);
    vibratoRates = 1 ./ (2 * cyclePeriods);

    results.meanRate_Hz = mean(vibratoRates, 'omitnan');
    results.medianRate_Hz = median(vibratoRates, 'omitnan');
    results.meanExtent_cents = mean(cycleExtents, 'omitnan');
    results.medianExtent_cents = median(cycleExtents, 'omitnan');
    results.rate_Hz = results.meanRate_Hz;
    results.extent_cents = results.meanExtent_cents;  % Vocaliscope convention: half-extent (±)
    results.extent_semitone = results.extent_cents / 100;

    % --- Step 10: Compute jitter metrics (from core.py: compute_jitter_metrics) ---
    jitterMetrics = VibratoAnalysis.VibratoScope.computeJitterMetrics(cyclePeriods);
    results.jitter = jitterMetrics.jitter_local_percent / 100;  % Store as fraction

    % --- Step 11: Compute CV (from core.py: compute_cv) ---
    [results.cvRate, results.cvExtent] = VibratoAnalysis.VibratoScope.computeCV(cyclePeriods, cycleExtents);

    % --- Step 12: Compute Sample Entropy (from utils.py: sample_entropy) ---
    if numel(cyclePeriods) >= 5
        if params.sampEnR > 0
            rVal = params.sampEnR * std(cyclePeriods);
        else
            rVal = 0.2 * std(cyclePeriods);  % Auto: Python default
        end
        results.sampEn = VibratoAnalysis.VibratoScope.sampleEntropy(cyclePeriods, params.sampEnM, rVal);
    end

    results.success = true;
    results.intermediates.peaks = peaks;
    results.intermediates.troughs = troughs;
    results.intermediates.vibratoRates = vibratoRates;
    results.intermediates.cyclePeriods = cyclePeriods;
    results.intermediates.cycleExtents = cycleExtents;

    % --- Package time series (per-cycle) ---
    cycleCenters = cellfun(@(c) c.center_time_s, cycleParams);
    results.rate_Hz_ts = vibratoRates(:)';
    results.extent_cents_ts = cycleExtents(:)';
    results.time_s = cycleCenters(:)';
end
