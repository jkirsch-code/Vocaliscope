function [amIndex, fmIndex, amEnvelope, fmTrajectory, delay, phase] = amfmhilbertsmooth(y, fs, params)
%AMFMHILBERTSMOOTH Hilbert transform-based AM/FM extraction
%   [AMINDEX, FMINDEX, AMENVELOPE, FMTRAJECTORY, DELAY, PHASE] = 
%   AMFMHILBERTSMOOTH(Y, FS, PARAMS) extracts amplitude modulation (AM)
%   and frequency modulation (FM) from audio signal using Hilbert transform.
%
%   Inputs:
%     y      - Audio signal (column vector, double)
%     fs     - Sample rate (Hz)
%     params - Struct with fields from descriptor().params
%
%   Outputs:
%     amIndex    - AM modulation index (vibrato depth in amplitude)
%     fmIndex    - FM modulation index (vibrato depth in frequency)
%     amEnvelope - Smoothed AM envelope (same length as y)
%     fmTrajectory - Instantaneous frequency trajectory (same length as y)
%     delay      - Time delay between AM and FM peaks (seconds)
%     phase      - Phase relationship between AM and FM (radians)
%
%   Algorithm (Zhang et al. 2017):
%     1. High-pass filter to remove DC offset and low-frequency drift
%     2. Hilbert transform to obtain analytic signal
%     3. Extract instantaneous amplitude (AM envelope)
%     4. Extract instantaneous frequency (FM trajectory)
%     5. Smooth AM and FM with moving average filter
%     6. Compute modulation indices (peak-to-peak / mean)
%     7. Estimate AM/FM phase relationship via cross-correlation
%     8. Compute time delay between AM and FM peaks

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

% --- 1. Remove DC offset and low-frequency drift ---
y = y - mean(y);
[zb, za] = butter(2, 50/(fs/2), 'high');
y = filtfilt(zb, za, y);

% --- 2. Bandpass filter around estimated F0 ---
% Estimate F0 using autocorrelation
f0 = estimateF0(y, fs);

% Use moderate bandpass filter to isolate the fundamental region
% Half-power bandwidth of ~40% below to ~60% above F0
f0Low = max(f0 * 0.6, 50);
f0High = min(f0 * 1.6, fs/2 - 100);

% Ensure valid filter
if f0High <= f0Low + 10
    f0Low = max(f0 - 40, 50);
    f0High = min(f0 + 40, fs/2 - 100);
end

% Use 4th order Butterworth for good selectivity
[b, a] = butter(4, [f0Low, f0High] / (fs/2), 'bandpass');
yFiltered = filtfilt(b, a, y);

% --- 3. Hilbert transform to obtain analytic signal ---
analyticSignal = hilbert(yFiltered);

% --- 4. Extract instantaneous amplitude (AM envelope) ---
amEnvelopeRaw = abs(analyticSignal);

% --- 5. Extract instantaneous frequency (FM trajectory) ---
% Instantaneous frequency is the derivative of the unwrapped phase
phaseRaw = unwrap(angle(analyticSignal));
fmTrajectoryRaw = (fs / (2*pi)) * diff([phaseRaw(1); phaseRaw]);

% Convert to Hz relative to F0 (deviation from center frequency)
fmTrajectoryRaw = fmTrajectoryRaw - f0;

% --- 6. Smooth AM and FM ---
smoothSamples = round(params.smoothWindow_s * fs);
smoothSamples = max(smoothSamples, 3);
if mod(smoothSamples, 2) == 0
    smoothSamples = smoothSamples + 1;  % Make odd for symmetric window
end
hannWin = hann(smoothSamples, 'periodic');
hannWin = hannWin / sum(hannWin);

amEnvelope = conv(amEnvelopeRaw, hannWin, 'same');
fmTrajectory = conv(fmTrajectoryRaw, hannWin, 'same');

% --- 7. Compute modulation indices ---
% AM modulation index: (peak-to-peak) / (2 * mean)
amMean = mean(amEnvelope);
amPeakToPeak = max(amEnvelope) - min(amEnvelope);
if amMean > 0
    amIndex = amPeakToPeak / (2 * amMean);
else
    amIndex = 0;
end

% FM modulation index: (peak-to-peak deviation) / (mean frequency)
fmMean = mean(abs(fmTrajectory));
fmPeakToPeak = max(fmTrajectory) - min(fmTrajectory);
if f0 > 0
    fmIndex = fmPeakToPeak / f0;  % Relative to center frequency
else
    fmIndex = 0;
end

% --- 8. Estimate AM/FM phase relationship ---
% Cross-correlate AM and FM to find time delay
[xcf, lags] = xcorr(amEnvelope - mean(amEnvelope), ...
                     fmTrajectory - mean(fmTrajectory), ...
                     'coeff');
[~, maxIdx] = max(abs(xcf));
delay = lags(maxIdx) / fs;  % Time delay in seconds

% Phase relationship (circular correlation at zero lag)
amNorm = (amEnvelope - mean(amEnvelope)) / (std(amEnvelope) + eps);
fmNorm = (fmTrajectory - mean(fmTrajectory)) / (std(fmTrajectory) + eps);
phase = mean(amNorm .* fmNorm);

end

function f0 = estimateF0(y, fs)
    % Simple autocorrelation-based F0 estimation
    minLag = round(fs / 500);  % Max 500 Hz
    maxLag = round(fs / 80);   % Min 80 Hz
    
    % Autocorrelation
    r = xcorr(y, 'coeff');
    r = r(length(y):end);  % Take positive lags only
    
    % Find peak in valid range
    rSearch = r(minLag:maxLag);
    [~, maxIdx] = max(rSearch);
    f0 = fs / (minLag + maxIdx - 1);
end
