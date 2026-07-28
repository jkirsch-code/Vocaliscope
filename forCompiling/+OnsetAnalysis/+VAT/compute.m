function results = compute(y, fs, params, eggSignal)
%COMPUTE Computes Vocal Attack Time (VAT) from audio and (optional) EGG
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes VAT using synthetic EGG.
%   RESULTS = COMPUTE(Y, FS, PARAMS, EGGSIGNAL) uses real EGG signal.
%
%   Inputs:
%     y         - Audio signal (column vector, double)
%     fs        - Sample rate (Hz)
%     params    - Struct with fields matching descriptor().params defaults
%     eggSignal - Optional EGG signal (column vector). When empty or
%                 omitted, a synthetic EGG is generated internally.
%
%   Outputs:
%     results - Struct with fields:
%       .vat_s            - Vocal Attack Time (s); positive = SP leads EGG (soft onset)
%       .fom             - Figure of Merit (Pearson r at optimal lag)
%       .optLag_s        - Optimal cross-correlation lag (s)
%       .f0_Hz           - Estimated fundamental frequency (Hz)
%       .audioEnvelope   - Smoothed Hilbert envelope of SP (same length as y)
%       .eggEnvelope     - Smoothed Hilbert envelope of EGG
%       .onsetIdx        - Sample index of detected onset
%       .onsetTime_s     - Time of onset (s)
%       .windowStartIdx  - Start of analysis window (sample index)
%       .windowEndIdx    - End of analysis window (sample index)
%       .lags_s          - Cross-correlation lags (s)
%       .xcorr           - Cross-correlation values at each lag
%       .success         - Boolean, true if VAT was computed

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
    eggSignal (:,1) double = []
end

defaults = struct(...
    'f0BandpassLowScale', 0.6, ...
    'f0BandpassHighScale', 1.4, ...
    'smoothPeriods', 2.0, ...
    'diffLagPeriods', 2.0, ...
    'maxLag_s', 0.02, ...
    'fomThreshold', 0.75, ...
    'maxWindow_s', 0.3);
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

if numel(y) < 100
    results = struct('vat_s',NaN,'fom',NaN,'optLag_s',NaN, ...
        'f0_Hz',NaN, ...
        'audioEnvelope',[],'eggEnvelope',[],'eggSignal',[], ...
        'onsetIdx',[],'onsetTime_s',NaN, ...
        'windowStartIdx',[],'windowEndIdx',[], ...
        'lags_s',[],'xcorr',[],'success',false);
    return;
end

% 1. Obtain EGG signal (provided or synthetic)
if ~isempty(eggSignal) && numel(eggSignal) == numel(y)
    egg = eggSignal(:);
else
    egg = OnsetAnalysis.syntheticEGG(y, fs);
end

% ====== PASS 1: Wide-bandwidth onset detection ======
lowPass1 = 50;
highPass1 = 500;
if lowPass1 >= highPass1
    lowPass1 = 0.9 * highPass1;
end
dfPass1 = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', lowPass1, 'HalfPowerFrequency2', highPass1, ...
    'SampleRate', fs, 'DesignMethod', 'butter');
audioFilt1 = filtfilt(dfPass1, y);
audioEnv1 = abs(hilbert(audioFilt1));
smoothSamples1 = max(round(0.005 * fs), 1);
if mod(smoothSamples1, 2) == 0
    smoothSamples1 = smoothSamples1 + 1;
end
gWin1 = gausswin(smoothSamples1, 3);
gWin1 = gWin1 / sum(gWin1);
audioEnv1 = conv(audioEnv1, gWin1, 'same');

% Onset detection from pass-1 envelope
noiseLen = min(round(0.05 * fs), numel(audioEnv1));
noiseFloor = 3 * median(audioEnv1(1:noiseLen));
minOnsetDur = max(round(0.01 * fs), 5);
aboveNoise = audioEnv1 > noiseFloor;
d = diff([0; aboveNoise; 0]);
runsStart = find(d == 1);
runsEnd = find(d == -1) - 1;
runLens = runsEnd - runsStart + 1;
validRun = find(runLens >= minOnsetDur, 1, 'first');
if isempty(validRun)
    onsetIdx = round(0.1 * numel(audioEnv1));
else
    onsetIdx = runsStart(validRun);
end

% ====== F0 estimation from stable phonation ======
f0SegStart = min(numel(egg), onsetIdx + round(0.050 * fs));
f0SegEnd = min(numel(egg), onsetIdx + round(params.maxWindow_s * fs));
if f0SegEnd - f0SegStart < round(0.050 * fs)
    f0SegStart = 1;
    f0SegEnd = min(numel(egg), round(0.200 * fs));
end
eggSeg = egg(f0SegStart:f0SegEnd);

% Remove DC
eggSeg = eggSeg - mean(eggSeg);

% Autocorrelation
[r, lags] = xcorr(eggSeg, 'normalized');
r = r(lags >= 0);
lags = lags(lags >= 0);

% Restrict to plausible F0 range (50-400 Hz)
minLag = max(round(fs / 400), 1);
maxLag = min(round(fs / 50), numel(lags));
rTrim = r(lags >= minLag & lags <= maxLag);
lagTrim = lags(lags >= minLag & lags <= maxLag);
if isempty(rTrim) || max(rTrim) < 0.1
    f0 = 200;
else
    [~, maxIdx] = max(rTrim);

    f0Lag = lagTrim(maxIdx);
    % Parabolic sub-sample refinement
    if maxIdx > 1 && maxIdx < numel(rTrim)
        x0 = lagTrim(maxIdx);
        x1 = lagTrim(maxIdx - 1);
        x2 = lagTrim(maxIdx + 1);
        y0 = rTrim(maxIdx);
        y1 = rTrim(maxIdx - 1);
        y2 = rTrim(maxIdx + 1);
        h = x2 - x0;
        denom = 2 * (2 * y0 - y1 - y2);
        if abs(denom) > eps
            f0Lag = x0 + h * (y1 - y2) / denom;
        end
    end
    f0 = fs / f0Lag;
    f0 = max(50, min(400, f0));
end

% ====== PASS 2: F0-adaptive analysis ======
lowHz = max(round(f0 * params.f0BandpassLowScale), 10);
highHz = min(round(f0 * params.f0BandpassHighScale), round(fs * 0.45));
if lowHz >= highHz
    lowHz = 0.9 * highHz;
end

dfF0 = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', lowHz, 'HalfPowerFrequency2', highHz, ...
    'SampleRate', fs, 'DesignMethod', 'butter');
audioFilt = filtfilt(dfF0, y);
eggFilt = filtfilt(dfF0, egg);

% Hilbert envelope (analytic signal magnitude)
audioEnv = abs(hilbert(audioFilt));
eggEnv = abs(hilbert(eggFilt));

% F0-adaptive Gaussian smoothing
smoothSamples = max(round(fs * params.smoothPeriods / f0), 1);
if mod(smoothSamples, 2) == 0
    smoothSamples = smoothSamples + 1;
end
gWin = gausswin(smoothSamples, 3);
gWin = gWin / sum(gWin);
audioEnv = conv(audioEnv, gWin, 'same');
eggEnv = conv(eggEnv, gWin, 'same');

% Analysis window: ±150 ms around onset (from pass 1)
winHalf = round(0.150 * fs);
windowStartIdx = max(1, onsetIdx - winHalf);
windowEndIdx = min(numel(audioEnv), onsetIdx + winHalf);

audioWin = audioEnv(windowStartIdx:windowEndIdx);
eggWin = eggEnv(windowStartIdx:windowEndIdx);

% F0-adaptive difference function (N pitch periods, Roark 2012)
diffLagSamples = min(round(fs * params.diffLagPeriods / f0), numel(audioWin) - 1);
diffLagSamples = max(diffLagSamples, 1);
audioDiff = audioWin - [zeros(diffLagSamples, 1); audioWin(1:end-diffLagSamples)];
eggDiff = eggWin - [zeros(diffLagSamples, 1); eggWin(1:end-diffLagSamples)];

% Normalize difference functions
audioDiff = audioDiff / (std(audioDiff) + eps);
eggDiff = eggDiff / (std(eggDiff) + eps);

% Cross-correlation of difference functions
maxLagSamples = round(params.maxLag_s * fs);
[xcorrVals, lags] = xcorr(audioDiff, eggDiff, maxLagSamples, 'coeff');

% Find optimal lag with parabolic sub-sample interpolation
[rawPeak, rawIdx] = max(xcorrVals);
lagSamples = lags(rawIdx);

if rawIdx > 1 && rawIdx < numel(xcorrVals)
    x0 = lags(rawIdx);
    x1 = lags(rawIdx - 1);
    x2 = lags(rawIdx + 1);
    y0 = xcorrVals(rawIdx);
    y1 = xcorrVals(rawIdx - 1);
    y2 = xcorrVals(rawIdx + 1);
    h = x2 - x0;
    denom = 2 * (2 * y0 - y1 - y2);
    if abs(denom) > eps
        lagSamples = x0 + h * (y1 - y2) / denom;
    end
end

optLag_s = lagSamples / fs;
fom = rawPeak;

% VAT = optLag (positive = SP leads EGG)
vat_s = optLag_s;

% Package results
results = struct(...
    'vat_s', vat_s, ...
    'fom', fom, ...
    'optLag_s', optLag_s, ...
    'f0_Hz', f0, ...
    'audioEnvelope', audioEnv, ...
    'eggEnvelope', eggEnv, ...
    'audioFilt', audioFilt, ...
    'eggFilt', eggFilt, ...
    'eggSignal', egg, ...
    'onsetIdx', onsetIdx, ...
    'onsetTime_s', (onsetIdx - 1) / fs, ...
    'windowStartIdx', windowStartIdx, ...
    'windowEndIdx', windowEndIdx, ...
    'lags_s', lags / fs, ...
    'xcorr', xcorrVals, ...
    'success', true);

end
