function results = compute(y, fs, params)
%COMPUTE Computes Phonation Onset Time (POT) using Mergell growth function fit
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes POT via Hilbert envelope
%   and Mergell growth function grid search (Patel 2017, Mergell 1998).
%
%   Inputs:
%     y     - Signal (column vector, double). Works on Audio, EGG, Airflow, GAW
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
%       .envelope         - Gaussian-smoothed Hilbert envelope (full length)
%       .fitCurve         - Fitted Mergell growth function (NaN outside crop)
%       .onsetIdx         - Sample index of onset start (crop start)
%       .steadyIdx        - Sample index of steady-state start (crop end)
%       .idx32            - Sample index of 32.2% crossing
%       .idx67            - Sample index of 67.8% crossing
%       .onsetTime_32pct_s - Time of 32.2% amplitude crossing (s)
%       .onsetTime_67pct_s - Time of 67.8% amplitude crossing (s)
%       .envPeaks         - Envelope peak values for intermediate plot
%       .envPeakTimes     - Envelope peak times for intermediate plot
%       .success          - Boolean, true if POT was computed

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
end

defaults = struct('smoothWindow_s', 0.02, 'maxWindow_s', 0.3);
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

if numel(y) < 10
    results = struct('pot_s',NaN,'potDirect_s',NaN,'r0',[],'rf',[],'a',[], ...
        'envelope',[],'fitCurve',[],'onsetIdx',[],'steadyIdx',[], ...
        'idx32',[],'idx67',[], ...
        'onsetTime_32pct_s',NaN,'onsetTime_67pct_s',NaN, ...
        'envPeaks',[],'envPeakTimes',[],'success',false);
    return;
end

% Remove low-frequency drift (essential for EGG signals)
[zb, za] = butter(4, 50/(fs/2), 'high');
y = filtfilt(zb, za, y);

t = (0:numel(y)-1)' / fs;

% 1. Hilbert envelope
env = abs(hilbert(y));

% 2. Gaussian smoothing
smoothSamples = round(params.smoothWindow_s * fs);
if smoothSamples > 0
    if mod(smoothSamples, 2) == 0
        smoothSamples = smoothSamples + 1;
    end
    gWin = gausswin(smoothSamples, 3);
    gWin = gWin / sum(gWin);
    env = conv(env, gWin, 'same');
end

% 3. Detect onset: first sustained envelope rise above noise floor
% Use median of first 50ms as noise estimate
noiseLen = min(round(0.05 * fs), numel(env));
noiseFloor = 3 * median(env(1:noiseLen));
% Require at least 10 ms of consecutive above-threshold samples
minOnsetDur = max(round(0.01 * fs), 5);
aboveNoise = env > noiseFloor;
d = diff([0; aboveNoise; 0]);
runsStart = find(d == 1);
runsEnd = find(d == -1) - 1;
runLens = runsEnd - runsStart + 1;
validRun = find(runLens >= minOnsetDur, 1, 'first');
if isempty(validRun)
    onsetIdx = round(0.1 * numel(env));
else
    onsetIdx = runsStart(validRun);
end

% 4. Detect steady-state: find where envelope first reaches 95% of its
% post-onset maximum, then extend into the plateau
windowEnd = min(onsetIdx + round(params.maxWindow_s * fs), numel(env));
postOnset = env(onsetIdx:windowEnd);
% Use 95th percentile of post-onset envelope as robust rf estimate
% (avoids spurious peaks from Hilbert ripples)
rfEst = prctile(postOnset, 95);
if rfEst <= 0
    [~, steadyIdx] = max(postOnset);
    steadyIdx = steadyIdx + onsetIdx;
else
    ssTarget = 0.95 * rfEst;
    steadyRel = find(postOnset >= ssTarget, 1, 'first');
    if isempty(steadyRel)
        [~, steadyRel] = max(postOnset);
    end
    % Extend 100ms beyond 95% crossing for plateau data; cap total crop at maxWindow_s
    maxCrop = round(params.maxWindow_s * fs);
    steadyRel = min(steadyRel + round(fs * 0.10), numel(postOnset));
    steadyRel = min(steadyRel, maxCrop);
    steadyIdx = steadyRel + onsetIdx - 1;
end
steadyIdx = min(steadyIdx, numel(env));

% Ensure region is valid: at least 10 samples, onset before steady
if steadyIdx - onsetIdx + 1 < 10
    steadyIdx = min(onsetIdx + 10, numel(env));
end

% 5. Crop envelope to onset region
envCrop = env(onsetIdx:steadyIdx);
tCrop = t(onsetIdx:steadyIdx) - t(onsetIdx); % rebase to 0

% 6. Subsample for fitting efficiency
nFit = min(500, numel(envCrop));
fitIdx = round(linspace(1, numel(envCrop), nFit));
envFit = envCrop(fitIdx);
tFit = tCrop(fitIdx);

% 7. Grid search for growth rate a (rf fixed to plateau estimate)
% r(t) = r0 * ((1 - (r0/rf)^2) * exp(-2*a*t) + (r0/rf)^2)^(-1/2)
% rf is the steady-state amplitude from the 95th percentile of envelope
r0 = max(envFit(1), eps);
rfOut = rfEst;
xi = (r0 / rfOut)^2;
if xi >= 1
    xi = 0.99;
end

bestMse = inf;
bestA = 20;
aValues = 1:500;

for aVal = aValues
    rModel = r0 * ((1 - xi) * exp(-2 * aVal * tFit) + xi).^(-0.5);
    mse = mean((rModel - envFit).^2);
    if mse < bestMse
        bestMse = mse;
        bestA = aVal;
    end
end

a = bestA;
pot = 1 / a;

% 8. Full fit curve: NaN before onset, fit curve within crop, rf after steady
fitCrop = r0 * ((1 - xi) * exp(-2 * a * tCrop) + xi).^(-0.5);
rFull = nan(numel(y), 1);
rFull(onsetIdx:steadyIdx) = fitCrop;
rFull(steadyIdx+1:end) = rfOut;

% 9. 32.2% and 67.8% crossing times from fit
r32 = r0 + 0.322 * (rfOut - r0);
r67 = r0 + 0.678 * (rfOut - r0);
% Find crossings within the crop region
idx32 = find(fitCrop >= r32, 1, 'first');
idx67 = find(fitCrop >= r67, 1, 'first');
if isempty(idx32), idx32 = numel(fitCrop); end
if isempty(idx67), idx67 = numel(fitCrop); end
% Convert to global indices
idx32Global = idx32 + onsetIdx - 1;
idx67Global = idx67 + onsetIdx - 1;
t32 = t(idx32Global);
t67 = t(idx67Global);
potDirect = t67 - t32;

% 10. Envelope peaks for visualization
d = diff(env);
peakMask = [false; d(1:end-1) > 0 & d(2:end) < 0; false];
peakIdx = find(peakMask);

% Filter: at least 2 ms between peaks
minDist = round(fs * 0.002);
if ~isempty(peakIdx)
    keep = [true; diff(peakIdx) >= minDist];
    peakIdx = peakIdx(keep);
end

results = struct(...
    'pot_s', pot, ...
    'potDirect_s', potDirect, ...
    'r0', r0, ...
    'rf', rfOut, ...
    'a', a, ...
    'envelope', env, ...
    'fitCurve', rFull, ...
    'onsetIdx', onsetIdx, ...
    'steadyIdx', steadyIdx, ...
    'idx32', idx32Global, ...
    'idx67', idx67Global, ...
    'onsetTime_32pct_s', t32, ...
    'onsetTime_67pct_s', t67, ...
    'envPeaks', env(peakIdx), ...
    'envPeakTimes', t(peakIdx), ...
    'success', true);

end
