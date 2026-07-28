function results = compute(y, fs, params)
%COMPUTE Computes Phonation Onset Time (POT) using Petermann cycle-peak fit
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes POT via narrow-bandpass
%   filtering at F0, cycle peak detection, and Mergell growth function
%   fit to discrete peak amplitudes (Petermann 2016, VOAT 2024).
%
%   Inputs:
%     y     - Signal (column vector, double). Works on any signal type
%     fs    - Sample rate (Hz)
%     params - Struct with fields matching descriptor().params defaults
%
%   Outputs:
%     results - Struct with fields:
%       .pot_s            - POT = 1/a (time constant from 32.2% to 67.8% rise)
%       .potDirect_s      - Direct 32.2%-67.8% crossing time from fitted curve
%       .r0               - Initial amplitude at onset start
%       .rf               - Saturation amplitude (steady-state)
%       .a                - Growth rate decay constant
%       .f0_Hz            - Estimated fundamental frequency (Hz)
%       .bpFilt           - Narrow bandpass filtered signal
%       .peakAmps         - Detected cycle peak amplitudes
%       .peakTimes        - Detected cycle peak times (s)
%       .fitCurve         - Fitted Mergell growth function (NaN outside crop)
%       .onsetIdx         - Sample index of onset start (crop start)
%       .steadyIdx        - Sample index of steady-state start (crop end)
%       .idx32            - Sample index of 32.2% crossing
%       .idx67            - Sample index of 67.8% crossing
%       .onsetTime_32pct_s - Time of 32.2% amplitude crossing (s)
%       .onsetTime_67pct_s - Time of 67.8% amplitude crossing (s)
%       .success          - Boolean, true if POT was computed

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
end

defaults = struct('bpLowScale', 0.9, 'bpHighScale', 1.1, 'maxWindow_s', 0.3);
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

if numel(y) < 100
    results = struct('pot_s',NaN,'potDirect_s',NaN,'r0',[],'rf',[],'a',[], ...
        'f0_Hz',NaN,'bpFilt',[],'peakAmps',[],'peakTimes',[], ...
        'fitCurve',[],'onsetIdx',[],'steadyIdx',[], ...
        'idx32',[],'idx67',[], ...
        'onsetTime_32pct_s',NaN,'onsetTime_67pct_s',NaN,'success',false);
    return;
end

t = (0:numel(y)-1)' / fs;

% Remove low-frequency drift
[zb, za] = butter(4, 50/(fs/2), 'high');
yHp = filtfilt(zb, za, y);

% ====== F0 estimation from stable phonation segment ======
% Wide-bandpass for envelope-based onset detection (same as VAT pass 1)
lowPass1 = 50;
highPass1 = 500;
if lowPass1 >= highPass1
    lowPass1 = 0.9 * highPass1;
end
dfWide = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', lowPass1, 'HalfPowerFrequency2', highPass1, ...
    'SampleRate', fs, 'DesignMethod', 'butter');
yWide = filtfilt(dfWide, y);

% Hilbert envelope of wide-band signal for onset detection
envWide = abs(hilbert(yWide));
smoothSamples = max(round(0.005 * fs), 1);
if mod(smoothSamples, 2) == 0
    smoothSamples = smoothSamples + 1;
end
gWin = gausswin(smoothSamples, 3);
gWin = gWin / sum(gWin);
envWide = conv(envWide, gWin, 'same');

% Onset detection
noiseLen = min(round(0.05 * fs), numel(envWide));
noiseFloor = 3 * median(envWide(1:noiseLen));
minOnsetDur = max(round(0.01 * fs), 5);
aboveNoise = envWide > noiseFloor;
d = diff([0; aboveNoise; 0]);
runsStart = find(d == 1);
runsEnd = find(d == -1) - 1;
runLens = runsEnd - runsStart + 1;
validRun = find(runLens >= minOnsetDur, 1, 'first');
if isempty(validRun)
    onsetIdx = round(0.1 * numel(y));
else
    onsetIdx = runsStart(validRun);
end

% F0 estimation from post-onset segment
f0SegStart = min(numel(yHp), onsetIdx + round(0.050 * fs));
f0SegEnd = min(numel(yHp), onsetIdx + round(0.500 * fs));
if f0SegEnd - f0SegStart < round(0.050 * fs)
    f0SegStart = 1;
    f0SegEnd = min(numel(yHp), round(0.200 * fs));
end
seg = yHp(f0SegStart:f0SegEnd);
seg = seg - mean(seg);

[r, lags] = xcorr(seg, 'normalized');
r = r(lags >= 0);
lags = lags(lags >= 0);
minLag = max(round(fs / 400), 1);
maxLag = min(round(fs / 50), numel(lags));
rTrim = r(lags >= minLag & lags <= maxLag);
lagTrim = lags(lags >= minLag & lags <= maxLag);
if isempty(rTrim) || max(rTrim) < 0.1
    f0 = 200;
else
    [~, maxIdx] = max(rTrim);
    f0Lag = lagTrim(maxIdx);
    if maxIdx > 1 && maxIdx < numel(rTrim)
        x0 = lagTrim(maxIdx);
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

% ====== Narrow bandpass at F0 ======
lowHz = max(round(f0 * params.bpLowScale), 10);
highHz = min(round(f0 * params.bpHighScale), round(fs * 0.45));
if lowHz >= highHz
    lowHz = 0.9 * highHz;
end
dfNarrow = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', lowHz, 'HalfPowerFrequency2', highHz, ...
    'SampleRate', fs, 'DesignMethod', 'butter');
yFilt = filtfilt(dfNarrow, yHp);

% ====== Detect cycle peaks ======
minDist = max(round(fs / f0 * 0.5), 2);
[~, locs] = findpeaks(yFilt, 'MinPeakDistance', minDist);

if isempty(locs)
    results = struct('pot_s',NaN,'potDirect_s',NaN,'r0',[],'rf',[],'a',[], ...
        'f0_Hz',f0,'bpFilt',yFilt,'peakAmps',[],'peakTimes',[], ...
        'fitCurve',[],'onsetIdx',[],'steadyIdx',[], ...
        'idx32',[],'idx67',[], ...
        'onsetTime_32pct_s',NaN,'onsetTime_67pct_s',NaN,'success',false);
    return;
end

peakAmps = yFilt(locs);
peakTimes = t(locs);

% Limit to maxWindow_s window: exclude pre-onset peaks (filter ringing)
% and limit analysis to window after envelope-detected onset
maxStartTime = t(onsetIdx);
maxEndTime = maxStartTime + params.maxWindow_s;
keepIdx = peakTimes >= maxStartTime & peakTimes <= maxEndTime;
peakAmps = peakAmps(keepIdx);
peakTimes = peakTimes(keepIdx);
locs = locs(keepIdx);

% ====== Onset detection from cycle peaks ======
% Find first peak that exceeds noise floor and is part of sustained growth
noiseFloorPeak = 3 * median(peakAmps(1:min(5, numel(peakAmps))));
abovePeakNoise = peakAmps > noiseFloorPeak;
dPeak = diff([0; abovePeakNoise; 0]);
peakRunsStart = find(dPeak == 1);
peakRunsEnd = find(dPeak == -1) - 1;
peakRunLens = peakRunsEnd - peakRunsStart + 1;
validPeakRun = find(peakRunLens >= 3, 1, 'first');
if isempty(validPeakRun)
    peakOnsetIdx = 1;
else
    peakOnsetIdx = peakRunsStart(validPeakRun);
end

if peakOnsetIdx > numel(peakAmps)
    peakOnsetIdx = 1;
end

% Steady-state: 95th percentile of post-onset peak amplitudes
postPeaks = peakAmps(peakOnsetIdx:end);
if numel(postPeaks) < 3
    rfEst = max(peakAmps);
else
    rfEst = prctile(postPeaks, 95);
end

if rfEst <= noiseFloorPeak
    rfEst = max(peakAmps);
end

% Find which peaks are within crop region
nPeaksTotal = numel(peakAmps);
cropStart = peakOnsetIdx;

% Determine steady-state peak: first peak at 95% of rfEst
ssTarget = 0.95 * rfEst;
steadyRel = find(peakAmps(cropStart:end) >= ssTarget, 1, 'first');
if isempty(steadyRel)
    steadyRel = max(1, numel(postPeaks) - 2);
end
cropEnd = min(cropStart + steadyRel, nPeaksTotal);
% Add some margin
cropEnd = min(cropEnd + 2, nPeaksTotal);
if cropEnd - cropStart < 3
    cropEnd = min(cropStart + 3, nPeaksTotal);
end

cropPeakAmps = peakAmps(cropStart:cropEnd);
cropPeakTimes = peakTimes(cropStart:cropEnd);

% Convert to time-rebased (crop start = 0)
tCropPeaks = cropPeakTimes - cropPeakTimes(1);

% ====== Grid search Mergell fit to discrete peak amplitudes ======
r0 = max(cropPeakAmps(1), eps);
rfOut = rfEst;
xi = (r0 / rfOut)^2;
if xi >= 1
    xi = 0.99;
end

bestMse = inf;
bestA = 20;
aValues = 1:500;

for aVal = aValues
    rModel = r0 * ((1 - xi) * exp(-2 * aVal * tCropPeaks) + xi).^(-0.5);
    mse = mean((rModel - cropPeakAmps).^2);
    if mse < bestMse
        bestMse = mse;
        bestA = aVal;
    end
end

a = bestA;
pot = 1 / a;

% ====== Fit curve at fine time resolution for crossing detection ======
tFine = linspace(0, cropPeakTimes(end) - cropPeakTimes(1), 1000)';
fitFine = r0 * ((1 - xi) * exp(-2 * a * tFine) + xi).^(-0.5);
tFineAbs = tFine + cropPeakTimes(1);

% ====== 32.2% and 67.8% crossing times from fit ======
r32 = r0 + 0.322 * (rfOut - r0);
r67 = r0 + 0.678 * (rfOut - r0);
idx32 = find(fitFine >= r32, 1, 'first');
idx67 = find(fitFine >= r67, 1, 'first');
if isempty(idx32), idx32 = numel(fitFine); end
if isempty(idx67), idx67 = numel(fitFine); end
t32 = tFineAbs(idx32);
t67 = tFineAbs(idx67);
potDirect = t67 - t32;

% Full-length fit curve (NaN outside crop, fit values at peak times, rf after)
rFull = nan(numel(y), 1);
for k = cropStart:cropEnd
    pkIdx = k - cropStart + 1;
    rFull(locs(k)) = r0 * ((1 - xi) * exp(-2 * a * tCropPeaks(pkIdx)) + xi).^(-0.5);
end
for k = cropEnd+1:nPeaksTotal
    rFull(locs(k)) = rfOut;
end

% OnsetIdx in samples (global)
onsetSample = locs(cropStart);
steadySample = locs(cropEnd);

results = struct(...
    'pot_s', pot, ...
    'potDirect_s', potDirect, ...
    'r0', r0, ...
    'rf', rfOut, ...
    'a', a, ...
    'f0_Hz', f0, ...
    'bpFilt', yFilt, ...
    'peakAmps', peakAmps, ...
    'peakTimes', peakTimes, ...
    'fitCurve', rFull, ...
    'onsetIdx', onsetSample, ...
    'steadyIdx', steadySample, ...
    'idx32', locs(cropStart) + round(idx32 / numel(fitFine) * (cropEnd - cropStart)), ...
    'idx67', locs(cropStart) + round(idx67 / numel(fitFine) * (cropEnd - cropStart)), ...
    'onsetTime_32pct_s', t32, ...
    'onsetTime_67pct_s', t67, ...
    'cropPeakAmps', cropPeakAmps, ...
    'cropPeakTimes', cropPeakTimes, ...
    'fitFine', fitFine, ...
    'fitFineTimes', tFineAbs, ...
    'success', true);

end
