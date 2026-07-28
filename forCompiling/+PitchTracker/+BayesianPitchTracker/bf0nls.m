function [f0, time_s, periodicity, result] = bf0nls(y, fs, opts)
%%% Vocaliscope wrapper for Bayesian Pitch Tracking Using Harmonic Model %%%
% BF0NLS  Bayesian fundamental frequency estimation via NLS with harmonic
%         model and HMM smoothing (BF0NLS algorithm).
%
%    [F0, TIME_S, PERIODICITY] = BF0NLS(Y, FS)
%    [F0, TIME_S, PERIODICITY] = BF0NLS(Y, FS, OPTS)
%
%    Estimates pitch contour from audio signal Y at sampling rate FS using
%    the Bayesian fast F0 NLS algorithm with Hidden Markov Model smoothing.
%
%    Inputs:
%       y    - audio signal (column or row vector, double)
%       fs   - sampling rate (Hz)
%       opts - struct with optional fields:
%           f0_min          - minimum F0 (Hz), default 70
%           f0_max          - maximum F0 (Hz), default 400
%           frameLength_s   - frame length (s), default 0.03
%           hopLength_s     - hop length (s), default 0.01
%           voicingThresh   - voicing threshold (0-1), default 0.5
%           prewhitening    - enable prewhitening (logical), default false
%           maxHarmonics    - maximum harmonic order, default 10 (30 if prew)
%
%    Outputs:
%       f0          - pitch contour (1 x N_frames, Hz), NaN where unvoiced
%       time_s      - frame center times (1 x N_frames, seconds)
%       periodicity - voicing probability (1 x N_frames, 0-1)
%       result      - struct with full algorithm output (tt, ff, oo, vv,
%                     best_ff, best_order)
%
%    Algorithm resamples signal to 16 kHz internally. Parameters are tuned
%    for this sampling rate. The output f0 values are converted back to the
%    original sampling rate frequency scale.
%
%    Reference:
%      L. Shi, J.K. Jensen, J.J. Carsell, A.M. Strong, M.G. Christensen,
%      "A Bayesian Approach for Automatic and Robust Pitch Tracking,"
%      IEEE/ACM Trans. Audio, Speech, Language Process., 2019.
%
%    Original code: https://github.com/MalcomX/2DBarcodeDetection
%    (BF0NLS_MATLAB by Liming Shi, Aalborg University, 2019)
%
%    License: GNU General Public License v2 (see LICENSE)

    if nargin < 3, opts = struct(); end
    f0_min        = getOpt(opts, 'f0_min',        70);
    f0_max        = getOpt(opts, 'f0_max',        400);
    frameLength_s = getOpt(opts, 'frameLength_s', 0.03);
    hopLength_s   = getOpt(opts, 'hopLength_s',   0.01);
    voicingThresh = getOpt(opts, 'voicingThresh',  0.5);
    prewhitening  = getOpt(opts, 'prewhitening',  false);
    maxHarmonics  = getOpt(opts, 'maxHarmonics',  10);

    y = y(:);

    % Resample to 16 kHz (algorithm is tuned for this rate)
    fs_target = 16000;
    if fs ~= fs_target
        y_rs = resample(y, fs_target, fs);
    else
        y_rs = y;
    end

    % Normalize to -45 dB loudness level (as in original BF0NLS.m)
    sumE = sqrt(y_rs' * y_rs / length(y_rs));
    scale = sqrt(3.1623e-5) / sumE;
    y_rs = y_rs * scale;

    nData = length(y_rs);

    % Set up frame parameters
    segmentLength = round(frameLength_s * fs_target / 2) * 2;
    nShift = round(hopLength_s * fs_target);
    nSegments = floor((nData + segmentLength/2 - segmentLength) / nShift) + 1;

    % Set up pitch bounds (cycles/sample)
    f0Bounds = [f0_min, f0_max] / fs_target;

    % Standard deviation for pitch transition (scales with hop size)
    std_pitch = max(2 / 10 * hopLength_s * 1000, 0.5);

    % Adjust max harmonics for prewhitening
    if prewhitening
        maxNoHarmonics = 30;
    else
        maxNoHarmonics = maxHarmonics;
    end

    % Create estimator
    f0Estimator = PitchTracker.BayesianPitchTracker.BayesianfastF0NLS( ...
        segmentLength, maxNoHarmonics, f0Bounds, ...
        std_pitch / fs_target, 0.7);

    % Pad signal for framing
    speechSignal_padded = [zeros(segmentLength/2, 1); y_rs];

    % Process frames
    idx = 1:segmentLength;
    f0Estimates  = nan(nSegments, 1);
    order        = nan(nSegments, 1);
    voicing_prob = nan(nSegments, 1);

    if prewhitening
        for ii = 1:nSegments
            speechSegment = speechSignal_padded(idx);
            [f0Estimates(ii), order(ii), voicing_prob(ii)] = ...
                f0Estimator.estimate(speechSegment, 1, hopLength_s);
            idx = idx + nShift;
        end
    else
        for ii = 1:nSegments
            speechSegment = speechSignal_padded(idx);
            [f0Estimates(ii), order(ii), voicing_prob(ii)] = ...
                f0Estimator.estimate(speechSegment, 0);
            idx = idx + nShift;
        end
    end

    % Time vector (in resampled time)
    timeVector = (0:nSegments-1)' * hopLength_s;

    % Apply voicing threshold
    unvoiced = voicing_prob < voicingThresh;
    f0_voiced = f0Estimates;
    f0_voiced(unvoiced) = nan;

    % Convert from cycles/sample to Hz, then to original sample rate scale
    f0_hz = f0_voiced * fs_target;

    % Build output
    f0 = f0_hz.';           % 1 x N_frames
    time_s = timeVector.';  % 1 x N_frames
    periodicity = voicing_prob.';  % 1 x N_frames

    % Full result struct (if requested)
    if nargout >= 4
        result.tt         = timeVector;
        result.ff         = f0Estimates * fs_target;
        result.oo         = order;
        result.vv         = voicing_prob;
        result.best_ff    = f0_voiced * fs_target;
        result.best_order = order;
        result.best_order(unvoiced) = nan;
    end
end

function v = getOpt(opts, field, default)
    if isfield(opts, field)
        v = opts.(field);
    else
        v = default;
    end
end
