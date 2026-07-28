function egg = syntheticEGG(y, fs)
%SYNTHETICEGG Generate a synthetic EGG-like signal from audio
%   EGG = SYNTHETICEGG(Y, FS) creates a stylized electroglottographic signal
%   from the acoustic waveform Y (column vector, sample rate FS).
%
%   The method estimates the fundamental frequency, generates a pulse train
%   at F0, and gates it with a sharp step. The EGG remains near zero for
%   several glottal cycles after the acoustic onset, then switches abruptly
%   to full amplitude. This simulates the delayed vocal fold closure of
%   soft phonation onset, producing a step-like envelope that differs
%   fundamentally from the gradual SP envelope rise.

arguments
    y (:,1) double
    fs (1,1) double
end

% 1. Band-pass filter at F0 range (60-400 Hz)
df = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', 60, 'HalfPowerFrequency2', 400, ...
    'SampleRate', fs, 'DesignMethod', 'butter');
yFilt = filtfilt(df, y);

% 2. Estimate F0 from autocorrelation
nSamp = min(round(0.5 * fs), numel(yFilt));
env = abs(hilbert(yFilt));
noiseFloor = 3 * median(env(1:min(round(0.05*fs), numel(env))));
onsetIdx = find(env(round(0.1*fs):end) > noiseFloor, 1, 'first');
if isempty(onsetIdx)
    onsetIdx = round(0.1 * numel(yFilt));
else
    onsetIdx = onsetIdx + round(0.1*fs) - 1;
end
f0Seg = yFilt(onsetIdx:min(onsetIdx + nSamp - 1, numel(yFilt)));
ac = xcorr(f0Seg, f0Seg);
ac = ac(numel(f0Seg):end);
minLag = round(fs / 400);
maxLag = round(fs / 60);
ac(1:minLag) = 0;
[~, peakLag] = max(ac(1:minLag+maxLag));
if peakLag < minLag || peakLag > maxLag
    peakLag = round(fs / 200);
end

% 3. Generate pulse train at F0
pulseLen = round(0.002 * fs);
if mod(pulseLen, 2) == 0, pulseLen = pulseLen + 1; end
tPulse = (-(pulseLen-1)/2:(pulseLen-1)/2)' / pulseLen;
pulseShape = exp(-(tPulse * 4).^2);
pulseShape = pulseShape / max(pulseShape);

impulseTrain = zeros(numel(yFilt), 1);
firstPulse = max(onsetIdx - mod(onsetIdx, peakLag), 1);
pulsePositions = firstPulse:peakLag:numel(yFilt);
impulseTrain(pulsePositions) = 1;
eggTrain = conv(impulseTrain, pulseShape, 'same');

% 4. Gate with sharp step: EGG stays near zero for 3 cycles after onset
% then abruptly switches to full amplitude
delayCycles = 1;
gateSamples = delayCycles * peakLag;
gateOnset = min(onsetIdx + gateSamples, numel(yFilt));
% Sharp step (1 ms transition)
transSamples = round(0.001 * fs);
transSamples = max(transSamples, 1);
gate = zeros(numel(yFilt), 1);
gate(gateOnset:min(gateOnset+transSamples, numel(yFilt))) = ...
    linspace(0, 1, min(gateOnset+transSamples, numel(yFilt)) - gateOnset + 1)';
gate(gateOnset+transSamples+1:end) = 1;

% 5. EGG = gated pulse train (constant amplitude, not modulated by SP)
egg = eggTrain .* gate;

% 6. Normalize to unit max absolute (matches audio normalization)
if max(abs(egg)) > 0
    egg = egg / max(abs(egg));
end

% 7. Shift EGG left by ~0.7 ms to simulate acoustic delay from vocal folds
% to microphone in synchronous EGG+audio recordings
delaySamples = round(0.0007 * fs);
if delaySamples > 0 && delaySamples < numel(egg)
    egg = [egg(delaySamples+1:end); zeros(delaySamples, 1)];
end

end
