function [f0, time_s, periodicity] = yin(y, fs, opts)
%%% changed for Vocaliscope project 20260720 %%%
% YIN  YIN pitch tracker wrapper with frame-by-frame loop.
%
%    [F0, TIME_S, PERIODICITY] = YIN(Y, FS, OPTS)
%
%    Extract pitch contour from audio signal Y using the YIN algorithm,
%    computing per-frame estimates.
%
%    Inputs:
%       y    - audio signal (column or row vector, double)
%       fs   - sampling rate (Hz)
%       opts - struct with optional fields:
%           f0_min          - minimum F0 (Hz), default 60
%           f0_max          - maximum F0 (Hz), default 2000
%           threshold       - YIN threshold (0-1), default 0.1
%           frameLength_s   - frame length (s), default 0.04 (40 ms)
%           hopLength_s     - hop length (s), default 0.01 (10 ms)
%
%    Outputs:
%       f0          - pitch contour (1 x N_frames, Hz), NaN where unvoiced
%       time_s      - frame center times (1 x N_frames, seconds)
%       periodicity - YIN confidence (1 x N_frames, 0-1)
% %%% end changed %%%

    if nargin < 3, opts = struct(); end
    f0_min          = getOpt(opts, 'f0_min',          60);
    f0_max          = getOpt(opts, 'f0_max',          2000);
    threshold       = getOpt(opts, 'threshold',       0.1);
    frameLength_s   = getOpt(opts, 'frameLength_s',   0.04);
    hopLength_s     = getOpt(opts, 'hopLength_s',     0.01);
    minConfidence   = getOpt(opts, 'minConfidence',   0.0);

    y = y(:).';
    N = length(y);

    frameLen = round(frameLength_s * fs);
    hopLen   = round(hopLength_s * fs);

    if frameLen > N
        % Signal shorter than one frame — analyse whole signal
        [f0, periodicity] = PitchTracker.YIN.find_f0_yin_core(y, fs, f0_min, f0_max, threshold);
        time_s = 0.5 * N / fs;
        f0 = f0; periodicity = periodicity;
        return;
    end

    % Number of frames
    nFrames = floor((N - frameLen) / hopLen) + 1;
    f0          = NaN(1, nFrames);
    time_s      = zeros(1, nFrames);
    periodicity = NaN(1, nFrames);

    for k = 1:nFrames
        startIdx = (k - 1) * hopLen + 1;
        endIdx   = startIdx + frameLen - 1;
        frame    = y(startIdx:endIdx);

        midSample = round((startIdx + endIdx) / 2);
        time_s(k) = (midSample - 1) / fs;

        [f0(k), periodicity(k)] = PitchTracker.YIN.find_f0_yin_core(frame, fs, f0_min, f0_max, threshold);
    end

    % Filter low-confidence frames (boundary artifacts, noise)
    lowConf = periodicity < minConfidence;
    f0(lowConf) = NaN;
    periodicity(lowConf) = NaN;
end

function v = getOpt(opts, field, default)
    if isfield(opts, field)
        v = opts.(field);
    else
        v = default;
    end
end
