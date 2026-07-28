function [f0, time_s, periodicity] = yaapt(y, fs, opts)
%%% Vocaliscope wrapper for YAAPT Pitch Tracking %%%
% YAAPT  Yet Another Algorithm for Pitch Tracking.
%
%    [F0, TIME_S, PERIODICITY] = YAAPT(Y, FS)
%    [F0, TIME_S, PERIODICITY] = YAAPT(Y, FS, OPTS)
%
%    Estimates pitch contour from audio signal Y at sampling rate FS using
%    the YAAPT spectral/temporal pitch tracking algorithm.
%
%    Inputs:
%       y    - audio signal (column or row vector, double)
%       fs   - sampling rate (Hz)
%       opts - struct with optional fields:
%           f0_min          - minimum F0 (Hz), default 60
%           f0_max          - maximum F0 (Hz), default 400
%           frame_length    - frame length (ms), default 25
%           frame_space     - frame spacing (ms), default 10
%           fft_length      - FFT length, default 8192
%           voiced_unvoiced - voiced/unvoiced decision (logical), default true
%           corrections     - apply pitch corrections (logical), default false
%           octave_correction - apply post-DP octave correction (logical),
%                               default true. Uses autocorrelation to detect
%                               and fix half-F0 / double-F0 errors.
%
%    Outputs:
%       f0          - pitch contour (1 x N_frames, Hz), NaN where unvoiced
%       time_s      - frame center times (1 x N_frames, seconds)
%       periodicity - voicing decision (1 x N_frames), 1=voiced, 0=unvoiced
%
%    Reference:
%      S. A. Zahorian and H. Hu, "A spectral/temporal method for robust
%      fundamental frequency tracking," J. Acoust. Soc. Am., 123(6),
%      4559-4571, June 2008.
%
%    Original code by Hongbing Hu and Stephen A. Zahorian,
%    Speech Communication Laboratory, SUNY Binghamton.
%    Source: https://www.ws.binghamton.edu/zahorian/yaapt.htm
%
%    License: Distributed as free software. See LICENSE.

    if nargin < 3, opts = struct(); end
    f0_min          = getOpt(opts, 'f0_min',          60);
    f0_max          = getOpt(opts, 'f0_max',          400);
    frame_length    = getOpt(opts, 'frame_length',    25);
    frame_space     = getOpt(opts, 'frame_space',     10);
    fft_length      = getOpt(opts, 'fft_length',      8192);
    voiced_unvoiced = getOpt(opts, 'voiced_unvoiced', true);
    apply_corrections = getOpt(opts, 'corrections',   false);
    octave_correction = getOpt(opts, 'octave_correction', true);

    y = y(:);

    % Build extra parameters struct
    ExtrPrm = struct( ...
        'f0_min',      f0_min, ...
        'f0_max',      f0_max, ...
        'frame_length', frame_length, ...
        'frame_space',  frame_space, ...
        'fft_length',   fft_length);

    % VU flag: 1 = with voicing decisions, 0 = all voiced
    if voiced_unvoiced
        VU = 1;
    else
        VU = 0;
    end

    % Call YAAPT core (no plotting)
    [Pitch, numfrms, frmrate] = PitchTracker.YAAPT.yaapt_core(y, fs, VU, ExtrPrm, 0);

    % Apply pitch corrections if requested (all-voiced mode)
    if apply_corrections && ~voiced_unvoiced
        Pitch = PitchTracker.YAAPT.ptch_fix(Pitch);
    end

    % Apply octave correction to fix half-F0 / double-F0 errors
    % This is NOT part of the original YAAPT code — see yaapt_octave_correct.m
    if octave_correction
        frame_period_s = frmrate / 1000;
        time_s_tmp = ((0:numfrms-1) * frame_period_s) + (frame_length/2/1000);
        Pitch = PitchTracker.YAAPT.yaapt_octave_correct(y, fs, Pitch, time_s_tmp, frame_length/1000, f0_min, f0_max);
    end

    % Convert YAAPT output to Vocaliscope format
    % Pitch: Hz values, 0 = unvoiced
    frame_period_s = frmrate / 1000;  % frmrate is in ms
    time_s = ((0:numfrms-1) * frame_period_s) + (frame_length/2/1000);

    f0 = Pitch(:).';
    f0(f0 < 1) = NaN;  % unvoiced frames (0 Hz) become NaN

    periodicity = double(Pitch(:).' > 0);
end

function v = getOpt(opts, field, default)
    if isfield(opts, field)
        v = opts.(field);
    else
        v = default;
    end
end
