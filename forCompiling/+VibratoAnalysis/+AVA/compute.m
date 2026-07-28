function results = compute(y, fs, params)
%COMPUTE Computes vibrato metrics using Filter Diagonalisation Method (FDM)
%   RESULTS = COMPUTE(Y, FS, PARAMS) computes vibrato parameters using
%   the AVA FDM method (Yang et al. 2016, 2017).
%
%   Inputs:
%     y      - Audio signal (column vector, double)
%     fs     - Sample rate (Hz)
%     params - Parameter struct from descriptor.params defaults
%
%   Outputs:
%     results - Struct with fields:
%       .success          - Boolean
%       .method           - 'AVA'
%       .inputType        - 'Audio'
%       .vibratos         - Individual vibrato events (struct array)
%       .rate_Hz          - Mean vibrato rate (Hz)
%       .extent_semitone  - Mean vibrato extent (semitones)
%       .extent_cents     - Mean vibrato extent (cents)
%       .sinusoidalSimilarity - Sinusoidal shape quality (0-1)
%       .pitchHz          - Estimated F0 (Hz)
%       .time_s           - Time axis
%       .intermediates    - Intermediate results
%       .warnings         - Cell array of warnings

arguments
    y (:,1) double
    fs (1,1) double
    params (1,1) struct
end

% --- Default parameters ---
defaults = struct(...
    'fMin', 2, ...
    'fMax', 12, ...
    'amplitudeMin', 0.0001, ...
    'frameLength_s', 1.0, ...
    'frameOverlap', 0.5, ...
    'kMax', 6, ...
    'minVibratoFrames', 2, ...
    'classificationMethod', 'DT');
for fn = fieldnames(defaults)'
    if ~isfield(params, fn{1}) || isempty(params.(fn{1}))
        params.(fn{1}) = defaults.(fn{1});
    end
end

% Initialize outputs
results = struct();
results.method = 'AVA';
results.inputType = 'Audio';
results.warnings = {};
results.time_s = (0:numel(y)-1)' / fs;

% --- Check signal energy ---
if max(abs(y)) < 1e-10
    results.success = false;
    results.warnings = {'Signal amplitude is too low'};
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.sinusoidalSimilarity = NaN;
    results.pitchHz = NaN;
    results.vibratos = struct();
    results.intermediates = struct();
    return;
end

% --- Step 1: Pitch detection ---
pitchMethod = 'SWIPE''';
if isfield(params, 'pitchTracker'), pitchMethod = params.pitchTracker; end
pitchOpts = struct();
if isfield(params, 'pitchOpts'), pitchOpts = params.pitchOpts; end
try
    [pitchHz, pitchTime, pitchStrength] = VibratoAnalysis.extractPitch(y, fs, pitchMethod, pitchOpts);
    % Remove low-strength estimates
    pitchHz(pitchStrength < 0.3) = NaN;
catch ME
    % Fallback to simple autocorrelation
    try
        [pitchHz, pitchTime] = autocorrPitchDetect(y, fs);
    catch ME2
        results.success = false;
        results.warnings = {['Pitch detection failed: ' ME.message '; ' ME2.message]};
        results.rate_Hz = NaN;
        results.extent_semitone = NaN;
        results.extent_cents = NaN;
        results.sinusoidalSimilarity = NaN;
        results.pitchHz = NaN;
        results.vibratos = struct();
        results.intermediates = struct();
        return;
    end
end

% Use median pitch as reference
validPitch = pitchHz(pitchHz > 0);
if isempty(validPitch)
    results.success = false;
    results.warnings = {'No valid pitch detected'};
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.sinusoidalSimilarity = NaN;
    results.pitchHz = NaN;
    results.vibratos = struct();
    results.intermediates = struct();
    return;
end
results.pitchHz = median(validPitch);

% --- Step 2: Convert to MIDI and smooth ---
midiPitch = 69 + 12 * log2(pitchHz / 440);
midiPitch(isnan(pitchHz)) = NaN;

% Interpolate NaNs (fill edges with nearest)
nanIdx = isnan(midiPitch);
if any(nanIdx) && ~all(nanIdx)
    validIdx = find(~nanIdx);
    midiPitch(nanIdx) = interp1(validIdx, midiPitch(validIdx), find(nanIdx), 'linear');
    % Fill edge NaNs with nearest valid value
    if isnan(midiPitch(1))
        firstValid = find(~isnan(midiPitch), 1, 'first');
        midiPitch(1:firstValid-1) = midiPitch(firstValid);
    end
    if isnan(midiPitch(end))
        lastValid = find(~isnan(midiPitch), 1, 'last');
        midiPitch(lastValid:end) = midiPitch(lastValid);
    end
end

% Light smoothing (preserve vibrato modulation)
pitchFs = 1 / (pitchTime(2) - pitchTime(1));  % ~100 Hz
smoothWin = max(3, round(0.02 * pitchFs));  % 20ms window at pitch contour rate
midiSmoothed = movmedian(midiPitch, smoothWin);

% --- Step 3: Frame-wise FDM analysis ---
% FDM needs a longer window - use params.frameLength_s for duration
frameLength = round(params.frameLength_s * pitchFs);
hopLength = round(frameLength * params.frameOverlap);
nFrames = floor((numel(midiSmoothed) - frameLength) / hopLength) + 1;

% FDM output per frame
fdmFreq = NaN(nFrames, 1);   % Vibrato rate estimate per frame
fdmAmp = NaN(nFrames, 1);    % Vibrato extent estimate per frame
timeF = NaN(nFrames, 1);     % Frame center times

for i = 1:nFrames
    startIdx = (i-1) * hopLength + 1;
    endIdx = startIdx + frameLength - 1;
    if endIdx > numel(midiSmoothed)
        break;
    end
    
    frame = midiSmoothed(startIdx:endIdx);
    frameTime = pitchTime(startIdx:endIdx);
    
    % Remove DC
    frame = frame - mean(frame);
    
    % Skip if frame is too flat
    if std(frame) < 0.001
        continue;
    end
    
    % Run FDM - use pitch contour sampling rate
    try
        [fk, d] = VibratoAnalysis.AVA.frameFDM3(frame, pitchFs, params.fMin, params.fMax, params.kMax);
        
        % Keep real frequencies in valid range
        realFreq = real(fk);
        validMask = realFreq >= params.fMin & realFreq <= params.fMax & realFreq > 0;
        
        if any(validMask)
            validFreq = realFreq(validMask);
            validAmp = abs(d(validMask));
            
            % Select dominant resonance (max amplitude)
            [maxAmp, maxIdx] = max(validAmp);
            fdmFreq(i) = validFreq(maxIdx);
            fdmAmp(i) = maxAmp;
        end
    catch
        % FDM failed for this frame, leave as NaN
    end
    
    timeF(i) = mean(frameTime);
end

% Remove frames with no detection
validFrames = ~isnan(fdmFreq) & ~isnan(fdmAmp);
fdmFreq = fdmFreq(validFrames);
fdmAmp = fdmAmp(validFrames);
timeF = timeF(validFrames);

if isempty(fdmFreq)
    results.success = false;
    results.warnings = {'FDM analysis yielded no valid frames'};
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.sinusoidalSimilarity = NaN;
    results.vibratos = struct();
    results.intermediates = struct();
    return;
end

% --- Step 4: Classification ---
if strcmp(params.classificationMethod, 'DT')
    % Decision Tree: simple threshold
    vibratoIndicate = fdmFreq >= params.fMin & fdmFreq <= params.fMax & fdmAmp >= params.amplitudeMin;
else
    % Bayes Rule (simplified: use amplitude threshold as fallback)
    vibratoIndicate = fdmAmp >= params.amplitudeMin;
end

% --- Step 5: Outlier removal ---
vibratoIndicate = removeOutliers(vibratoIndicate);

% --- Step 6: Segment vibrato regions ---
vibratoRegions = segmentVibrato(vibratoIndicate, timeF, params.minVibratoFrames);

% --- Step 7: Extract parameters per region ---
vibratos = struct();
nVibrato = 0;
for i = 1:size(vibratoRegions, 1)
    regionStart = vibratoRegions(i, 1);
    regionEnd = vibratoRegions(i, 2);
    
    % Find frames in this region
    inRegion = timeF >= regionStart & timeF <= regionEnd;
    regionFreq = fdmFreq(inRegion);
    regionAmp = fdmAmp(inRegion);
    
    if isempty(regionFreq)
        continue;
    end
    
    % Rate: mean FDM frequency
    rate = mean(regionFreq);
    
    % Vocaliscope convention: half-extent (±) = mean FDM amplitude (semitones)
    % Original peak-to-peak (2*) removed to match ± extent definition.
    extent_semitone = mean(regionAmp);
    extent_cents = extent_semitone * 100;
    
    % Store vibrato event
    nVibrato = nVibrato + 1;
    vibratos(nVibrato).startTime_s = regionStart;
    vibratos(nVibrato).endTime_s = regionEnd;
    vibratos(nVibrato).duration_s = regionEnd - regionStart;
    vibratos(nVibrato).rate_Hz = rate;
    vibratos(nVibrato).extent_semitone = extent_semitone;
    vibratos(nVibrato).extent_cents = extent_cents;
end

% --- Step 8: Compute sinusoidal similarity ---
sinSim = computeSinusoidalSimilarity(midiSmoothed, pitchTime, vibratoRegions);

% --- Step 9: Compute summary metrics ---
if nVibrato == 0
    results.rate_Hz = NaN;
    results.extent_semitone = NaN;
    results.extent_cents = NaN;
    results.sinusoidalSimilarity = NaN;
else
    rates = [vibratos.rate_Hz];
    extents = [vibratos.extent_semitone];
    results.rate_Hz = mean(rates);
    results.extent_semitone = mean(extents);
    results.extent_cents = results.extent_semitone * 100;
    results.sinusoidalSimilarity = sinSim;
end

% --- Package intermediates ---
results.intermediates = struct();
results.intermediates.fdmFreq = fdmFreq;
results.intermediates.fdmAmp = fdmAmp;
results.intermediates.timeF = timeF;
results.intermediates.vibratoIndicate = vibratoIndicate;
results.intermediates.pitchHz = pitchHz;
results.intermediates.pitchTime = pitchTime;
results.intermediates.midiSmoothed = midiSmoothed;

% --- Package time series (per-frame FDM) ---
results.rate_Hz_ts = fdmFreq(:)';
results.extent_cents_ts = fdmAmp(:)' * 100;  % semitones to cents
results.time_s = timeF(:)';

% --- Store results ---
results.vibratos = vibratos;
results.success = true;

end

% ===== Local Functions =====

function [pitchHz, pitchTime] = autocorrPitchDetect(y, fs)
%AUTOCORRPITCHDETECT Simple autocorrelation-based pitch detection
%   Returns pitch in Hz and corresponding times
    
    % Parameters
    hopSize = round(0.01 * fs);  % 10ms hop
    frameSize = round(0.04 * fs);  % 40ms frame
    
    % Ensure y is column
    if size(y, 2) > 1
        y = y(:, 1);
    end
    
    nFrames = floor((numel(y) - frameSize) / hopSize) + 1;
    pitchHz = NaN(nFrames, 1);
    pitchTime = ((0:nFrames-1)' * hopSize + frameSize/2) / fs;
    
    minLag = round(fs / 500);  % Max 500 Hz
    maxLag = round(fs / 60);   % Min 60 Hz
    
    for i = 1:nFrames
        startIdx = (i-1) * hopSize + 1;
        endIdx = startIdx + frameSize - 1;
        if endIdx > numel(y)
            break;
        end
        
        frame = y(startIdx:endIdx);
        
        % Skip silent frames
        if rms(frame) < 0.005  % Skip silent/noisy frames
            continue;
        end
        
        % Autocorrelation via FFT
        nfft = 2^nextpow2(2 * frameSize - 1);
        F = fft(frame, nfft);
        acf = real(ifft(F .* conj(F)));
        acf = acf(1:frameSize);
        
        % Normalize
        acf = acf / acf(1);
        
        % Search for peak in valid lag range
        if maxLag > length(acf)
            maxLag = length(acf);
        end
        searchRange = acf(minLag:maxLag);
        [peakVal, peakIdx] = max(searchRange);
        
        if peakVal > 0.3  % Minimum autocorrelation threshold
            bestLag = minLag + peakIdx - 1;
            pitchHz(i) = fs / bestLag;
        end
    end
end

function out = removeOutliers(indicate)
%REMOVEOUTLIERS Remove isolated single-frame detections
    out = indicate;
    n = numel(out);
    for i = 2:n-1
        if out(i) && ~out(i-1) && ~out(i+1)
            out(i) = false;
        end
    end
end

function regions = segmentVibrato(indicate, timeF, minFrames)
%SEGMENTVIBRATO Group consecutive vibrato frames into regions
%   Returns Nx2 matrix of [startTime, endTime]
    
    regions = [];
    inVibrato = false;
    startIdx = 1;
    
    for i = 1:numel(indicate)
        if indicate(i) && ~inVibrato
            startIdx = i;
            inVibrato = true;
        elseif ~indicate(i) && inVibrato
            if i - startIdx >= minFrames
                regions = [regions; timeF(startIdx), timeF(i-1)]; %#ok<AGROW>
            end
            inVibrato = false;
        end
    end
    
    % Handle case where vibrato extends to end
    if inVibrato && numel(indicate) - startIdx >= minFrames
        regions = [regions; timeF(startIdx), timeF(end)];
    end
end

function sinSim = computeSinusoidalSimilarity(midiSmoothed, pitchTime, vibratoRegions)
%COMPUTESINUSOIDALSIMILARITY Measure vibrato shape quality (0-1)
    
    sinSim = NaN;
    
    if isempty(vibratoRegions) || size(vibratoRegions, 1) == 0
        return;
    end
    
    % Concatenate all vibrato regions
    allVibPitch = [];
    allVibTime = [];
    for i = 1:size(vibratoRegions, 1)
        inRegion = pitchTime >= vibratoRegions(i, 1) & pitchTime <= vibratoRegions(i, 2);
        allVibPitch = [allVibPitch; midiSmoothed(inRegion)]; %#ok<AGROW>
        allVibTime = [allVibTime; pitchTime(inRegion)]; %#ok<AGROW>
    end
    
    if numel(allVibPitch) < 20
        return;
    end
    
    % Remove DC trend
    p = polyfit(allVibTime, allVibPitch, 1);
    residual = allVibPitch - polyval(p, allVibTime);
    
    % FFT to get dominant vibrato frequency
    n = numel(residual);
    fftRes = abs(fft(residual));
    freqAxis = (0:n-1)' * (1 / (allVibTime(2) - allVibTime(1))) / n;
    
    % Find peak in vibrato range (2-20 Hz)
    vibRange = freqAxis >= 2 & freqAxis <= 20;
    [~, maxIdx] = max(fftRes(vibRange));
    vibFreq = freqAxis(vibRange);
    dominantFreq = vibFreq(maxIdx);
    
    % Generate matching sine wave
    sineRef = sin(2 * pi * dominantFreq * allVibTime);
    
    % Normalized cross-correlation
    corrCoeff = corrcoef(residual, sineRef);
    sinSim = abs(corrCoeff(1, 2));
end
