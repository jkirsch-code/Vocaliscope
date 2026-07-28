function [pitchHz, pitchTime, pitchStrength] = extractPitch(y, fs, methodName, opts)
%%% changed for Vocaliscope project 20260720 %%%
%EXTRACTPITCH Shared pitch extraction for vibrato analysis
%   [PITCHHZ, PITCHTIME, PITCHSTRENGTH] = EXTRACTPITCH(Y, FS, METHODNAME, OPTS)
%   extracts a pitch contour from audio Y at sample rate FS using the
%   specified METHODNAME.
%
%   Supported methods:
%     'NCF'         — Normalized Correlation Function (MATLAB pitch)
%     'PEF'         — Pitch Estimation Filter (MATLAB pitch)
%     'CEP'         — Cepstrum Pitch Determination (MATLAB pitch)
%     'LHS'         — Log-Harmonic Summation (MATLAB pitch)
%     'SRH'         — Summation of Residual Harmonics (MATLAB pitch)
%     'SWIPE'''     — SWIPE' autocorrelation-based pitch tracker
%     'SHR'         — Subharmonic-to-Harmonic Ratio (+SHRP)
%     'YIN'         — YIN algorithm (adapted from AaltoAparat)
%     'BF0NLS'      — Bayesian fast F0 NLS (Shi et al. 2019, GPL v2)
%     'YAAPT'       — Yet Another Algorithm for Pitch Tracking (Zahorian/Hu 2008)
%                       Note: YAAPT tracks at half-F0 for signals with strong
%                       harmonics above ~400 Hz. The SHC (Spectral Harmonics
%                       Correlation) picks up the half-frequency harmonic as
%                       strongest candidate. Not recommended for F0 > 400 Hz.
%     'Praat'       — Praat pitch analysis (via praatMEX)
%     'CREPE'       — Deep neural network (requires Audio Toolbox + .mat files)
%
%   OPTS (optional struct) with fields:
%     f0_min          — minimum F0 (Hz), default 60
%     f0_max          — maximum F0 (Hz), default 500
%     windowLength_s  — analysis window length (s), default 0.04
%     overlapFrac     — overlap fraction (0-1), default 0.5
%     praatSubMethod  — Praat sub-method string (default 'filtered_ac')
%     crepeCapacity   — CREPE model capacity string (default 'medium')
%     minConfidence   — minimum YIN periodicity to accept (default 0.1);
%                       filters low-confidence boundary frames
%
%   Output format (all column vectors, NaN = unvoiced):
%     pitchHz       — pitch in Hz
%     pitchTime     — time stamps in seconds
%     pitchStrength — strength/confidence (0-1)
% %%% end changed %%%

    if nargin < 3 || isempty(methodName)
        methodName = 'SWIPE''';
    end
    if nargin < 4, opts = struct(); end

    f0_min = getOpt(opts, 'f0_min', 60);
    f0_max = getOpt(opts, 'f0_max', 1000);
    winLen_s = getOpt(opts, 'windowLength_s', 0.04);
    overlapFrac = getOpt(opts, 'overlapFrac', 0.5);
    minConfidence = getOpt(opts, 'minConfidence', 0.1);

    y = y(:);  % column vector

    try
        switch methodName
            case {'NCF', 'PEF', 'CEP', 'LHS', 'SRH'}
                [pitchHz, pitchTime, pitchStrength] = extractPitchMATLAB(y, fs, methodName, f0_min, f0_max, winLen_s, overlapFrac);

            case 'SWIPE'''
                [pitchHz, pitchTime, pitchStrength] = PitchTracker.SWIPEP.swipep(y, fs, [f0_min, f0_max], 0.01);

            case 'SHR'
                [pitchHz, pitchTime, pitchStrength] = extractPitchSHR(y, fs, f0_min, f0_max, winLen_s, overlapFrac);

            case 'YIN'
                [pitchHz, pitchTime, pitchStrength] = extractPitchYIN(y, fs, f0_min, f0_max, winLen_s, overlapFrac, minConfidence);

            case 'BF0NLS'
                [pitchHz, pitchTime, pitchStrength] = extractPitchBF0NLS(y, fs, f0_min, f0_max, winLen_s, overlapFrac);

            case 'YAAPT'
                [pitchHz, pitchTime, pitchStrength] = extractPitchYAAPT(y, fs, f0_min, f0_max, winLen_s, overlapFrac);

            case 'Praat'
                praatSubMethod = getOpt(opts, 'praatSubMethod', 'filtered_ac');
                [pitchHz, pitchTime, pitchStrength] = extractPitchPraat(y, fs, f0_min, f0_max, winLen_s, overlapFrac, praatSubMethod);

            case 'CREPE'
                crepeCapacity = getOpt(opts, 'crepeCapacity', 'medium');
                [pitchHz, pitchTime, pitchStrength] = extractPitchCREPE(y, fs, crepeCapacity, overlapFrac);

            otherwise
                error('VibratoAnalysis:extractPitch:unknownMethod', ...
                    'Unknown pitch tracker "%s".', methodName);
        end
    catch ME
        warning('VibratoAnalysis:extractPitch:failed', ...
            'Pitch extraction with "%s" failed: %s', methodName, ME.message);
        pitchHz = [];
        pitchTime = [];
        pitchStrength = [];
        return;
    end

    % Ensure column vectors
    pitchHz = pitchHz(:);
    pitchTime = pitchTime(:);
    pitchStrength = pitchStrength(:);

    % Remove any non-finite values from pitchHz (mark as unvoiced)
    pitchHz(~isfinite(pitchHz)) = NaN;
end

%% --- Helper: get struct field with default ---
function v = getOpt(s, field, default)
    if isfield(s, field)
        v = s.(field);
    else
        v = default;
    end
end

%% --- MATLAB pitch() methods: NCF, PEF, CEP, LHS, SRH ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchMATLAB(y, fs, method, f0_min, f0_max, winLen_s, overlapFrac)
    winSamples = round(winLen_s * fs);
    overlapSamples = round(overlapFrac * winSamples);

    [f0, loc] = pitch(y, fs, ...
        'Method', method, ...
        'Range', [f0_min, f0_max], ...
        'WindowLength', winSamples, ...
        'OverlapLength', overlapSamples);

    pitchHz = f0(:);
    pitchTime = loc(:) / fs;

    % pitch() returns 0 for unvoiced — convert to NaN
    isVoiced = pitchHz > 0 & ~isnan(pitchHz);
    pitchHz(~isVoiced) = NaN;
    pitchStrength = double(isVoiced);
end

%% --- SHR pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchSHR(y, fs, f0_min, f0_max, winLen_s, overlapFrac)
    % SHR: Subharmonic-to-Harmonic Ratio (Sun, 2002)
    % shrp returns: f0_time (ms), f0_value, SHR ratio, f0_candidates
    winLen_ms = winLen_s * 1000;
    hop_ms = (1 - overlapFrac) * winLen_ms;
    maxCandidates = min(fs/2, f0_max * 5);  % per Herbst 2019: 5x highest f0

    [f0_time, f0_value, shrRatio] = SHRP.shrp(y, fs, ...
        [f0_min, f0_max], winLen_ms, hop_ms, maxCandidates, ...
        1250, 0, 0);

    pitchHz = f0_value(:);
    pitchTime = f0_time(:) / 1000;  % Convert ms to seconds

    % SHR ratio is 0-1; higher = more confident harmonic (not subharmonic)
    pitchStrength = 1 - shrRatio(:);
    pitchStrength(isnan(pitchStrength) | pitchStrength < 0) = 0;
end

%% --- YIN pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchYIN(y, fs, f0_min, f0_max, winLen_s, overlapFrac, minConfidence)
    opts = struct();
    opts.f0_min = f0_min;
    opts.f0_max = f0_max;
    opts.frameLength_s = winLen_s;
    opts.hopLength_s = (1 - overlapFrac) * winLen_s;
    opts.minConfidence = minConfidence;

    [pitchHz, pitchTime, pitchStrength] = PitchTracker.YIN.yin(y, fs, opts);
end

%% --- BF0NLS pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchBF0NLS(y, fs, f0_min, f0_max, winLen_s, overlapFrac)
    opts = struct();
    opts.f0_min = f0_min;
    opts.f0_max = f0_max;
    opts.frameLength_s = winLen_s;
    opts.hopLength_s = (1 - overlapFrac) * winLen_s;

    [pitchHz, pitchTime, pitchStrength] = PitchTracker.BayesianPitchTracker.bf0nls(y, fs, opts);
end

%% --- YAAPT pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchYAAPT(y, fs, f0_min, f0_max, winLen_s, overlapFrac)
    % YAAPT uses its own frame parameters internally (25 ms frame, 10 ms spacing).
    % Overriding frame_space to extractPitch's default (20 ms) causes severe
    % smoothing of the pitch contour and underestimates vibrato extent by ~50%.
    % Only override f0_min/f0_max; let YAAPT use its native frame settings.
    opts = struct();
    opts.f0_min = f0_min;
    opts.f0_max = f0_max;
    opts.voiced_unvoiced = true;

    [pitchHz, pitchTime, pitchStrength] = PitchTracker.YAAPT.yaapt(y, fs, opts);
end

%% --- Praat pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchPraat(y, fs, f0_min, f0_max, winLen_s, overlapFrac, praatSubMethod)
    % Normalize audio to [-1,1] for praatMEX
    yNorm = y(:);
    maxAmp = max(abs(yNorm));
    if maxAmp > 0
        yNorm = yNorm / maxAmp;
    end

    % Map old method names to new praatMEX names
    methodMap = containers.Map(...
        {'filtered_autocorrelation', 'raw_autocorrelation', 'raw_cross_correlation', ...
         'filtered_cross_correlation', 'shs', 'SPINET'}, ...
        {'filtered_ac', 'ac', 'cc', 'filtered_cc', 'shs', 'spinet'});
    if isKey(methodMap, praatSubMethod)
        praatSubMethod = methodMap(praatSubMethod);
    end

    % Time step = hop size
    tStep = overlapFrac * winLen_s;

    % SHS/SPINET require timeStep > 0
    if ismember(praatSubMethod, {'shs', 'spinet'}) && tStep == 0
        tStep = 0.01;
    end

    % Run praatMEX pitch analysis
    result = praatMEX.praatmex('pitch', yNorm, fs, ...
        'pitchMethod', praatSubMethod, ...
        'timeStep', tStep, ...
        'pitchFloor', f0_min, ...
        'pitchCeiling', f0_max, ...
        'maxnCandidates', 15, ...
        'veryAccurate', false, ...
        'silenceThreshold', 0.03, ...
        'voicingThreshold', 0.45, ...
        'octaveCost', 0.01, ...
        'octaveJumpCost', 0.35, ...
        'voicedUnvoicedCost', 0.14);

    if ~isfield(result, 'time') || isempty(result.time)
        error('VibratoAnalysis:extractPitch:praatFailed', ...
            'praatMEX pitch analysis returned no pitch data.');
    end

    pitchTime = result.time(:)';
    pitchHz = result.freq(:)';

    % Mark undefined (0) as unvoiced
    isVoiced = pitchHz > 0;
    pitchStrength = double(isVoiced);
    pitchHz(~isVoiced) = NaN;
end

%% --- CREPE pitch extraction ---
function [pitchHz, pitchTime, pitchStrength] = extractPitchCREPE(y, fs, capacity, overlapFrac)
    % Check for CREPE .mat files
    crepeMatFiles = {'crepefulldlnet.mat', 'crepelargedlnet.mat', 'crepemediumdlnet.mat', ...
        'CREPENetfull.mat', 'CREPENetlarge.mat', 'CREPENetmedium.mat', ...
        'CREPENetsmall.mat', 'CREPENettiny.mat', 'crepesmalldlnet.mat', 'crepetinydlnet.mat'};
    if ~any(isfile(crepeMatFiles))
        error('VibratoAnalysis:extractPitch:crepeFilesMissing', ...
            'CREPE .mat files not found. Run downloadCrepeIfNonExistent first.');
    end

    [pitchHz, pitchTime] = pitchnn(y, fs, ...
        'OverlapPercentage', overlapFrac * 100, ...
        'ModelCapacity', capacity, ...
        'ConfidenceThreshold', 0);

    % pitchnn may return 0 for unvoiced
    isVoiced = pitchHz > 0 & ~isnan(pitchHz);
    pitchHz(~isVoiced) = NaN;
    pitchStrength = double(isVoiced);
end
