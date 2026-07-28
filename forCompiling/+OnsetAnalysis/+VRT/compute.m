function results = compute(y, fs, params)
%COMPUTE Computes Vocal Rise Time (VRT) from audio signal
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes VRT and related measures.
%
%   Inputs:
%     y     - Audio signal (column vector, double)
%     fs    - Sample rate (Hz)
%     params - Struct with fields matching descriptor().params defaults
%
%   Outputs:
%     results - Struct with fields:
%       .onsetTime_s      - Time of detected onset (s)
%       .vrt_s            - Vocal Rise Time (s)
%       .steadyStateAmp   - Steady-state amplitude (RMS)
%       .threshold        - Detection threshold (RMS)
%       .noiseFloor       - Estimated noise floor (RMS)
%       .rmsEnvelope      - RMS envelope (same length as y)
%       .vad              - Voice activity detection mask (logical)
%       .onsetIdx         - Sample index of onset
%       .endIdx           - Sample index of VRT endpoint (steady-state fraction)
%       .steadyStartIdx   - Sample index of steady-state estimation start (post-onset)
%       .steadyEndIdx     - Sample index of steady-state estimation end (VAD segment end)
%       .success          - Boolean, true if VRT could be computed

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
end

% --- Default parameters ---
defaults = struct(...
    'rmsWindow_s', 0.01, ...
    'noiseFloor_s', 0.05, ...
    'thresholdFactor', 3, ...
    'steadyStateFrac', 0.9, ...
    'maxWindow_s', 0.3);
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

% --- 1. Remove DC offset and low-frequency drift, then compute RMS envelope ---
y = y - mean(y);
[zb, za] = butter(4, 50/(fs/2), 'high');
y = filtfilt(zb, za, y);
winLen = round(params.rmsWindow_s * fs);
if winLen < 1, winLen = 1; end
winLen = 2*floor(winLen/2)+1;
hannWin = hann(winLen, 'periodic');
hannWin = hannWin / sum(hannWin);
y2 = y.^2;
rmsEnv = sqrt(conv(y2, hannWin, 'same'));

% --- 2. Energy-based VAD for onset detection ---
nNoise = round(params.noiseFloor_s * fs);
nNoise = min(nNoise, numel(y));
noiseFloor = median(rmsEnv(1:nNoise));
threshold = noiseFloor * params.thresholdFactor;
vad = rmsEnv >= threshold;

% Post-process VAD: remove very short voiced segments (< 20 ms)
minDur = round(0.02 * fs);
if any(vad)
    d = diff([0; vad; 0]);
    starts = find(d == 1);
    ends = find(d == -1) - 1;
    for k = 1:numel(starts)
        if ends(k) - starts(k) + 1 < minDur
            vad(starts(k):ends(k)) = false;
        end
    end
end

% --- 3. Find first onset ---
onsetIdx = find(vad, 1, 'first');
if isempty(onsetIdx)
    results = struct(...
        'onsetTime_s', NaN, ...
        'vrt_s', NaN, ...
        'steadyStateAmp', NaN, ...
        'threshold', threshold, ...
        'noiseFloor', noiseFloor, ...
        'rmsEnvelope', rmsEnv, ...
        'vad', vad, ...
        'onsetIdx', [], ...
        'endIdx', [], ...
        'steadyStartIdx', [], ...
        'steadyEndIdx', [], ...
        'success', false);
    return;
end

% --- 4. Estimate steady-state amplitude from VAD segment (limited to maxWindow_s) ---
maxEndIdx = min(numel(rmsEnv), onsetIdx + round(params.maxWindow_s * fs));
postOnsetStart = onsetIdx + round(0.05 * fs);
% Find end of the VAD segment containing onset
postOnsetVAD = vad(onsetIdx:end);
gapIdx = find(~postOnsetVAD, 1, 'first');
if isempty(gapIdx)
    steadyEndIdx = maxEndIdx;
else
    steadyEndIdx = min(onsetIdx + gapIdx - 2, maxEndIdx);
end
steadyEndIdx = min(steadyEndIdx, numel(rmsEnv));
if steadyEndIdx <= postOnsetStart
    steadyEndIdx = maxEndIdx;
end
steadyStateAmp = median(rmsEnv(postOnsetStart:steadyEndIdx));

% --- 5. Find VRT endpoint (time when envelope reaches steadyStateFrac of steady-state) ---
targetAmp = params.steadyStateFrac * steadyStateAmp;
% Search forward from onset
searchRegion = rmsEnv(onsetIdx:end);
relativeIdx = find(searchRegion >= targetAmp, 1, 'first');
if isempty(relativeIdx)
    % Fallback: use 80% of total rise if steady-state not clearly reached
    maxAmp = max(searchRegion);
    targetAmp = 0.8 * maxAmp;
    relativeIdx = find(searchRegion >= targetAmp, 1, 'first');
end
if isempty(relativeIdx)
    results = struct(...
        'onsetTime_s', (onsetIdx-1)/fs, ...
        'vrt_s', NaN, ...
        'steadyStateAmp', steadyStateAmp, ...
        'threshold', threshold, ...
        'noiseFloor', noiseFloor, ...
        'rmsEnvelope', rmsEnv, ...
        'vad', vad, ...
        'onsetIdx', onsetIdx, ...
        'endIdx', [], ...
        'steadyStartIdx', postOnsetStart, ...
        'steadyEndIdx', steadyEndIdx, ...
        'success', false);
    return;
end

endIdx = onsetIdx + relativeIdx - 1;
vrt_s = (endIdx - onsetIdx) / fs;

% --- 6. Package results ---
results = struct(...
    'onsetTime_s', (onsetIdx-1)/fs, ...
    'vrt_s', vrt_s, ...
    'steadyStateAmp', steadyStateAmp, ...
    'threshold', threshold, ...
    'noiseFloor', noiseFloor, ...
    'rmsEnvelope', rmsEnv, ...
    'vad', vad, ...
    'onsetIdx', onsetIdx, ...
    'endIdx', endIdx, ...
    'steadyStartIdx', postOnsetStart, ...
    'steadyEndIdx', steadyEndIdx, ...
    'success', true);

end
