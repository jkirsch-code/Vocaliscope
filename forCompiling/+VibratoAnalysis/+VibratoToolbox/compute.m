function results = compute(y, fs, params)
%COMPUTE Computes vibrato metrics using Hilbert AM/FM analysis
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes vibrato parameters using
%   the VibratoToolbox method.
%
%   Inputs:
%     y      - Audio signal (column vector, double)
%     fs     - Sample rate (Hz)
%     params - Parameter struct from descriptor.params defaults
%
%   Outputs:
%     results - Struct with fields:
%       .success          - Boolean, true if computation succeeded
%       .method           - Method identifier ('VAT')
%       .inputType        - 'Audio'
%       .vibratos         - Individual vibrato events (struct array)
%       .rate_Hz          - Mean vibrato rate (Hz)
%       .extent_semitone  - Mean vibrato extent (semitones)
%       .extent_cents     - Mean vibrato extent (cents)
%       .time_s           - Time axis (seconds)
%       .pitchHz          - Estimated F0 (Hz)
%       .intermediates    - Intermediate results for visualization
%       .warnings         - Cell array of any warnings

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
end

% --- Default parameters ---
defaults = struct(...
    'bpLowScale', 0.6, ...
    'bpHighScale', 1.4, ...
    'smoothWindow_s', 0.05, ...
    'minModIndex', 0.01);
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

% Initialize outputs
results = struct();
results.method = 'VAT';
results.inputType = 'Audio';
results.warnings = {};
results.time_s = (0:numel(y)-1)' / fs;

% --- Check if signal has enough energy ---
if max(abs(y)) < 1e-10
    results.success = false;
    results.warnings = {'Signal amplitude is too low'};
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.pitchHz = NaN;
    results.vibratos = struct();
    results.intermediates = struct();
    return;
end

% --- Estimate F0 ---
pitchMethod = 'SWIPE''';
if isfield(params, 'pitchTracker'), pitchMethod = params.pitchTracker; end
pitchOpts = struct();
if isfield(params, 'pitchOpts'), pitchOpts = params.pitchOpts; end
try
    [pitchHz, pitchTime, pitchStrength] = VibratoAnalysis.extractPitch(y, fs, pitchMethod, pitchOpts);
    pitchHz(pitchStrength < 0.3) = NaN;
    validP = pitchHz > 0 & ~isnan(pitchHz);
    if sum(validP) >= 5
        f0 = median(pitchHz(validP));
    else
        f0 = estimateF0Simple(y, fs);
    end
catch
    f0 = estimateF0Simple(y, fs);
end
results.pitchHz = f0;

% --- Run Hilbert AM/FM analysis ---
try
    [amIndex, fmIndex, amEnvelope, fmRaw, delay, phase] = ...
        VibratoAnalysis.VibratoToolbox.amfmhilbertsmooth(y, fs, params);
catch ME
    results.success = false;
    results.warnings = {['Hilbert analysis failed: ' ME.message]};
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.vibratos = struct();
    results.intermediates = struct();
    return;
end

% --- Bandpass filter FM trajectory to isolate vibrato frequency range ---
% Typical vibrato is 4-8 Hz, so use 2-12 Hz bandpass
vibratoLowHz = 2;
vibratoHighHz = 12;

% Replace NaN/Inf in raw FM trajectory with linear interpolation
fmRawClean = fmRaw;
nanIdx = ~isfinite(fmRawClean);
if any(nanIdx) && ~all(nanIdx)
    validIdx = find(~nanIdx);
    if numel(validIdx) >= 2
        fmRawClean(nanIdx) = interp1(validIdx, fmRawClean(validIdx), find(nanIdx), 'linear', 'extrap');
    else
        fmRawClean(nanIdx) = 0;
    end
elseif all(nanIdx)
    fmRawClean = zeros(size(fmRaw));
end

% Ensure signal is long enough for filtering
minFilterLen = round(4 * fs / vibratoLowHz);
if length(fmRawClean) > minFilterLen
    % Use 2nd order to avoid numerical issues
    [bVib, aVib] = butter(2, [vibratoLowHz, vibratoHighHz] / (fs/2), 'bandpass');
    fmTrajectory = filtfilt(bVib, aVib, fmRawClean);
else
    fmTrajectory = fmRawClean;
end

% --- Detect vibrato cycles from FM trajectory ---
vibratos = detectVibratoCycles(fmTrajectory, fs, f0, params);

% --- Compute summary metrics ---
if isempty(vibratos) || ~isstruct(vibratos) || numel(vibratos) == 0
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
else
    % Rate: use zero-crossing analysis for more robust estimate
    fmCentered = fmTrajectory - mean(fmTrajectory);
    crossings = find(fmCentered(1:end-1) .* fmCentered(2:end) < 0);
    
    if numel(crossings) >= 2
        crossingsTime = crossings / fs;
        periods = diff(crossingsTime);
        % Filter out very short periods (noise)
        validPeriods = periods(periods > 0.05);  % At least 50ms (max 20 Hz)
        if ~isempty(validPeriods)
            results.rate_Hz = 1 / (2 * mean(validPeriods));
        else
            % Fallback: use cycle count
            duration_s = numel(y) / fs;
            results.rate_Hz = numel(vibratos) / duration_s;
        end
    else
        % Fallback: use cycle count
        duration_s = numel(y) / fs;
        results.rate_Hz = numel(vibratos) / duration_s;
    end
    
    % Vocaliscope convention: half-extent (±) in semitones
    if isstruct(vibratos) && ~isempty(vibratos) && isfield(vibratos, 'extent_semitone')
        extents_semitone = [vibratos.extent_semitone];
        results.extent_semitone = mean(extents_semitone);
    else
        results.extent_semitone = NaN;
    end
    results.extent_cents = results.extent_semitone * 100;
end

% --- Package time series (per-cycle) ---
if ~isempty(vibratos) && isstruct(vibratos) && numel(vibratos) > 0 && isfield(vibratos, 'rate_Hz')
    cycleRates = [vibratos.rate_Hz];
    cycleExtentsHz = [vibratos.extent_Hz];
    cycleMidTimes = ([vibratos.startTime_s] + [vibratos.endTime_s]) / 2;
    % Half-extent in Hz → cents: 1200*log2(1 + df/f0)
    results.rate_Hz_ts = cycleRates(:)';
    results.extent_cents_ts = 1200 * log2(1 + cycleExtentsHz(:)' / f0);
    results.time_s = cycleMidTimes(:)';
else
    results.rate_Hz_ts = [];
    results.extent_cents_ts = [];
    results.time_s = [];
end

% --- Package intermediates for visualization ---
results.intermediates = struct();
results.intermediates.pitchHz = pitchHz;
results.intermediates.pitchTime = pitchTime;
results.intermediates.amEnvelope = amEnvelope;
results.intermediates.fmTrajectory = fmTrajectory;
results.intermediates.amIndex = amIndex;
results.intermediates.fmIndex = fmIndex;
results.intermediates.delay = delay;
results.intermediates.phase = phase;
results.intermediates.f0 = f0;

% --- Store vibrato events ---
results.vibratos = vibratos;

% --- Success ---
results.success = true;

end

function f0 = estimateF0Simple(y, fs)
    % Framed autocorrelation-based F0 estimation (robust for long signals)
    % Divides signal into 2s frames with 1s overlap, estimates F0 per frame,
    % returns median across frames.
    frameLen = round(2 * fs);   % 2 seconds
    hopLen   = round(1 * fs);   % 1 second overlap
    minLag = round(fs / 500);   % Max 500 Hz
    maxLag = round(fs / 80);    % Min 80 Hz

    nSamples = numel(y);
    if nSamples < frameLen
        % Too short for framing — use whole signal
        f0 = autocorrF0(y, fs, minLag, maxLag);
        return;
    end

    nFrames = floor((nSamples - frameLen) / hopLen) + 1;
    f0PerFrame = nan(1, nFrames);
    for i = 1:nFrames
        startIdx = (i-1) * hopLen + 1;
        frame = y(startIdx : startIdx + frameLen - 1);
        f0PerFrame(i) = autocorrF0(frame, fs, minLag, maxLag);
    end

    % Use median — robust against outlier frames (e.g., silence, noise)
    validF0 = f0PerFrame(f0PerFrame > 0 & ~isnan(f0PerFrame));
    if ~isempty(validF0)
        f0 = median(validF0);
    else
        f0 = 200;  % ultimate fallback
    end
end

function f0 = autocorrF0(frame, fs, minLag, maxLag)
    % Single-frame autocorrelation F0 estimate
    r = xcorr(frame, 'coeff');
    r = r(numel(frame):end);
    if maxLag > length(r)
        maxLag = length(r);
    end
    if minLag >= maxLag || minLag < 1
        f0 = NaN;
        return;
    end
    rSearch = r(minLag:maxLag);
    [~, maxIdx] = max(rSearch);
    f0 = fs / (minLag + maxIdx - 1);
end

function vibratos = detectVibratoCycles(fmTrajectory, fs, f0, ~)
    % Detect vibrato cycles from FM trajectory
    % A vibrato cycle is defined as one complete oscillation (peak to peak)
    
    vibratos = struct();
    
    % Apply additional smoothing to reduce noise in FM trajectory
    smoothLen = round(0.02 * fs);  % 20ms smoothing
    if smoothLen > 1
        h = hann(smoothLen, 'periodic');
        h = h / sum(h);
        fmSmoothed = conv(fmTrajectory, h, 'same');
    else
        fmSmoothed = fmTrajectory;
    end
    
    % Find peaks and troughs in smoothed FM trajectory
    % Typical vibrato is 4-8 Hz, so minimum distance should be ~50-125ms
    % Use 80ms minimum (12.5 Hz max) to be safe
    minPeakDistance = round(0.08 * fs);  % At least 80ms between peaks (max ~12.5 Hz)
    minPeakProminence = 0.005 * f0;  % At least 0.5% of F0 as prominence
    
    [pks, locs] = findpeaks(fmSmoothed, 'MinPeakDistance', minPeakDistance, ...
                            'MinPeakProminence', minPeakProminence);
    [trs, trLocs] = findpeaks(-fmSmoothed, 'MinPeakDistance', minPeakDistance, ...
                               'MinPeakProminence', minPeakProminence);
    trs = -trs;  % Convert back to actual values
    
    % Match peaks with following troughs to define cycles
    nCycles = 0;
    for i = 1:numel(locs)
        % Find next trough after this peak
        trIdx = find(trLocs > locs(i), 1, 'first');
        if isempty(trIdx)
            continue;
        end
        
        % Compute cycle parameters
        cycleStart = locs(i);
        cycleEnd = trLocs(trIdx);
        cycleTime_s = (cycleEnd - cycleStart) / fs;
        cycleRate_Hz = 1 / (2 * cycleTime_s);
        
        % Vocaliscope convention: half-extent (±) = amplitude of modulation.
        % Original peak-to-peak halved to match ± extent definition.
        peakFreq = f0 + pks(i);
        troughFreq = f0 + trs(trIdx);
        extent_Hz = abs(peakFreq - troughFreq) / 2;
        
        % Convert to semitones: 6 * log2(f2/f1) for half-extent
        if troughFreq > 0 && peakFreq > 0
            extent_semitone = 6 * log2(peakFreq / troughFreq);
        else
            extent_semitone = NaN;
        end
        
        % Store cycle
        nCycles = nCycles + 1;
        vibratos(nCycles).startTime_s = cycleStart / fs;
        vibratos(nCycles).endTime_s = cycleEnd / fs;
        vibratos(nCycles).duration_s = cycleTime_s;
        vibratos(nCycles).rate_Hz = cycleRate_Hz;
        vibratos(nCycles).extent_Hz = extent_Hz;
        vibratos(nCycles).extent_semitone = extent_semitone;
        vibratos(nCycles).peakFreq_Hz = peakFreq;
        vibratos(nCycles).troughFreq_Hz = troughFreq;
    end
end
