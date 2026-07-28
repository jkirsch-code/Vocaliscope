function results = compute(y, fs, params)
%COMPUTE CWT-of-f0 vibrato analysis using fCWT library
%   RESULTS = COMPUTE(Y, FS, PARAMS) analyzes audio signal Y at sample rate FS
%   using CWT-of-f0 method parameters PARAMS.
%
%   Uses FCWT.fCWT for fast Continuous Wavelet Transform of the F0 contour.
%   The F0 contour is extracted via SWIPE' pitch tracker.
%   CWT is used for rate detection (peak frequency at each time step).
%   Extent is computed from the F0 contour directly (bandpass + Hilbert
%   envelope), not from CWT amplitude, because the CWT coefficient magnitude
%   depends on wavelet normalization and does not reliably map to Hz.

    if nargin < 3
        params = struct();
    end

    % --- Set defaults from descriptor ---
    defaults = VibratoAnalysis.CWTf0.descriptor();
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
    results.rate_Hz_ts = [];
    results.extent_cents_ts = [];
    results.extent_Hz = [];
    results.time_s = [];
    results.cwtMatrix = [];
    results.cwtFreqs = [];
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

    validPitch = ~isnan(pitchHz) & pitchHz > 0;
    if sum(validPitch) < 10
        results.warnings{end+1} = 'Too few valid pitch points for analysis';
        return;
    end

    results.pitchHz = mean(pitchHz(validPitch), 'omitnan');

    % --- Step 2: Interpolate to uniform time grid ---
    fs_f0 = 1 / median(diff(pitchTime));
    dt = 1 / fs_f0;
    tUniform = pitchTime(1):dt:pitchTime(end);

    f0Interp = interp1(pitchTime, pitchHz, tUniform, 'linear', NaN);

    % --- Step 3: Handle NaN segments ---
    voicedMask = ~isnan(f0Interp) & f0Interp > 0;
    maxSeg = ceil(numel(voicedMask) / 2);
    segStarts = zeros(1, maxSeg);
    segEnds = zeros(1, maxSeg);
    nSeg = 0;
    inSegment = false;
    for i = 1:numel(voicedMask)
        if voicedMask(i) && ~inSegment
            nSeg = nSeg + 1;
            segStarts(nSeg) = i;
            inSegment = true;
        elseif ~voicedMask(i) && inSegment
            segEnds(nSeg) = i - 1;
            inSegment = false;
        end
    end
    if inSegment
        segEnds(nSeg) = numel(voicedMask);
    end
    segStarts = segStarts(1:nSeg);
    segEnds = segEnds(1:nSeg);

    if isempty(segStarts)
        results.warnings{end+1} = 'No voiced segments found in pitch contour';
        return;
    end

    % Sort segments by length
    segLens = segEnds - segStarts + 1;
    [~, sortIdx] = sort(segLens, 'descend');
    segStarts = segStarts(sortIdx);
    segEnds = segEnds(sortIdx);

    % --- Step 4: Compute CWT for rate detection ---
    f0_fMin = params.fMin;
    f0_fMax = params.fMax;
    c0 = params.c0;
    voicesPerOctave = params.voicesPerOctave;
    fn = round(log2(f0_fMax / f0_fMin) * voicesPerOctave);

    allSpeed_Hz = zeros(numel(tUniform), 1);
    allTime_s = zeros(numel(tUniform), 1);
    nTotal = 0;
    cwtMatrixFull = [];
    cwtFreqsFull = [];

    for s = 1:numel(segStarts)
        idx = segStarts(s):segEnds(s);
        segLen = numel(idx);
        if segLen < 20
            continue;
        end

        f0Seg = f0Interp(idx);
        tSeg = tUniform(idx);

        % Center F0 segment
        f0SegCentered = f0Seg - mean(f0Seg, 'omitnan');

        % Compute CWT (rate detection only)
        % fCWT requires row vector input, returns [time x freq] complex matrix
        try
            warning('off', 'fcwt:nothreads');
            [cwtCoeffs, fcwtFreqs] = FCWT.fCWT(single(f0SegCentered(:)'), c0, fs_f0, f0_fMin, f0_fMax, fn, 1);
            warning('on', 'fcwt:nothreads');
        catch ME
            results.warnings{end+1} = ['fCWT failed for segment ' num2str(s) ': ' ME.message];
            continue;
        end

        cwtAbs = abs(cwtCoeffs);
        % fCWT output is always [time x freq] — max along freq dim (dim 2)
        [~, peakIdx] = max(cwtAbs, [], 2);
        peakFreq = fcwtFreqs(peakIdx);
        nNew = numel(peakFreq);

        % fCWT may zero-pad — create time vector matching CWT output length
        cwtDt = tSeg(2) - tSeg(1);
        cwtTime = tSeg(1) + (0:nNew-1)' * cwtDt;
        if nNew > numel(tSeg)
            cwtTime = cwtTime(1:numel(tSeg));
            peakFreq = peakFreq(1:numel(tSeg));
            nNew = numel(tSeg);
        end

        allSpeed_Hz(nTotal+1:nTotal+nNew) = peakFreq(1:nNew);
        allTime_s(nTotal+1:nTotal+nNew) = cwtTime(1:nNew);
        nTotal = nTotal + nNew;

        % Store first segment's CWT for visualization — fCWT always returns [time x freq]
        if isempty(cwtMatrixFull)
            cwtMatrixFull = cwtAbs;
            cwtFreqsFull = fcwtFreqs;
        end
    end

    allSpeed_Hz = allSpeed_Hz(1:nTotal);
    allTime_s = allTime_s(1:nTotal);

    if nTotal == 0
        results.warnings{end+1} = 'No valid CWT segments computed';
        return;
    end

    % --- Step 5: Extent from F0 contour (bandpass + Hilbert envelope) ---
    % Convert F0 to cents relative to median
    f0_ref = median(f0Interp, 'omitnan');
    if f0_ref <= 0
        results.warnings{end+1} = 'Invalid reference pitch';
        return;
    end
    centsContour = 1200 * log2(f0Interp / f0_ref);
    centsContour(~voicedMask) = 0;

    % Bandpass filter cents contour at vibrato range
    vibLow = params.minSpeedHz;
    vibHigh = params.maxSpeedHz;
    nyqF0 = fs_f0 / 2;
    if vibLow / nyqF0 >= 1 || vibHigh / nyqF0 >= 1
        results.warnings{end+1} = 'Vibrato frequency range exceeds Nyquist of F0 contour';
        return;
    end
    [b, a] = butter(2, [vibLow vibHigh] / nyqF0, 'bandpass');

    % Filter each voiced segment separately to avoid edge artifacts
    centsFiltered = zeros(size(centsContour));
    for s = 1:numel(segStarts)
        idx = segStarts(s):segEnds(s);
        seg = centsContour(idx);
        if numel(seg) >= 3 * length(b)  % enough samples for filter
            centsFiltered(idx) = filtfilt(b, a, seg);
        end
    end

    % Hilbert envelope gives instantaneous amplitude (half-extent in cents)
    % Only within voiced regions
    extent_ts = zeros(size(centsFiltered));
    for s = 1:numel(segStarts)
        idx = segStarts(s):segEnds(s);
        seg = centsFiltered(idx);
        if numel(seg) >= 20
            analytic = hilbert(seg);
            extent_ts(idx) = abs(analytic);
        end
    end

    % Set non-voiced to NaN
    extent_ts(~voicedMask) = NaN;

    % --- Step 6: Filter by speed and extent thresholds ---
    validMask = allSpeed_Hz >= params.minSpeedHz & ...
                allSpeed_Hz <= params.maxSpeedHz;

    % Interpolate extent to CWT time points
    extentAtCWT = interp1(tUniform, extent_ts, allTime_s, 'linear', NaN);

    % Also filter by minimum extent
    validMask = validMask & ~isnan(extentAtCWT) & extentAtCWT >= params.minExtent_cents;

    if ~any(validMask)
        results.warnings{end+1} = 'No vibrato candidates passed speed/extent filters';
        return;
    end

    speed_Hz = allSpeed_Hz(validMask);
    extent_cents_final = extentAtCWT(validMask);
    time_s_final = allTime_s(validMask);

    % --- Step 7: Summary metrics ---
    results.rate_Hz = mean(speed_Hz, 'omitnan');
    results.extent_cents = mean(extent_cents_final, 'omitnan');
    results.extent_semitone = results.extent_cents / 100;

    % Store time-series results
    results.rate_Hz_ts = speed_Hz;
    results.extent_cents_ts = extent_cents_final;
    results.extent_Hz = extent_cents_final * f0_ref / 1200;  % Convert cents back to Hz
    results.time_s = time_s_final;

    % Store CWT matrix for visualization
    results.cwtMatrix = cwtMatrixFull;
    results.cwtFreqs = cwtFreqsFull;

    % Store intermediates
    results.intermediates.pitchHz = pitchHz;
    results.intermediates.pitchTime = pitchTime;
    results.intermediates.f0Interp = f0Interp;
    results.intermediates.tUniform = tUniform;
    results.intermediates.fs_f0 = fs_f0;
    results.intermediates.centsContour = centsContour;
    results.intermediates.centsFiltered = centsFiltered;
    results.intermediates.extent_ts = extent_ts;
    results.intermediates.allSpeed_Hz = allSpeed_Hz;
    results.intermediates.allTime_s = allTime_s;

    results.success = true;
end
