function corrected_pitch = yaapt_octave_correct(y, fs, raw_pitch, time_s, frame_length_s, f0_min, f0_max)
%%% NOT PART OF ORIGINAL YAAPT CODE — Vocaliscope addition (2026) %%%
%YAAPT_OCTAVE_CORRECT  Post-DP octave correction for YAAPT pitch contour
%
%   CORRECTED_PITCH = YAAPT_OCTAVE_CORRECT(Y, FS, RAW_PITCH, TIME_S,
%       FRAME_LENGTH_S, F0_MIN, F0_MAX)
%
%   Corrects octave errors in a YAAPT pitch contour by comparing the
%   spectral energy at the detected F0 versus at 2×F0 and F0/2.
%
%   WHY THIS IS NEEDED:
%   YAAPT's spectral tracker (SHC) picks half the true F0 for signals
%   where the half-F0 candidate captures more harmonic energy. The
%   temporal tracker (NCCF) and DP path follow this error. For a true F0
%   of 500 Hz, YAAPT may lock onto 250 Hz.
%
%   ALGORITHM:
%   For each voiced frame, compute the short-time FFT and compare the
%   spectral magnitude summed in a narrow band around the detected F0
%   versus around 2×F0 and F0/2:
%
%     - If E(2×F0) / E(F0) > threshold → correct to 2×F0
%       (detected F0 is half the true F0)
%     - If E(F0/2) / E(F0) > threshold → correct to F0/2
%       (detected F0 is double the true F0)
%
%   Spectral energy comparison is more reliable than autocorrelation
%   peak comparison for harmonic-rich signals, because the fundamental
%   frequency always has a strong spectral peak when it is the true F0,
%   even in the presence of strong harmonics.
%
%   This correction is direction-agnostic: it handles both upward and
%   downward octave errors independently per frame.
%
%   NOTE: This function is NOT part of the original YAAPT code from the
%   Speech Communication Laboratory, SUNY Binghamton. It was added by the
%   Vocaliscope project to address octave tracking errors.
%
%   Inputs:
%       y              - audio signal (column vector, double)
%       fs             - sampling rate (Hz)
%       raw_pitch      - raw YAAPT pitch contour (1 x N_frames, Hz, 0=unvoiced)
%       time_s         - frame center times (1 x N_frames, seconds)
%       frame_length_s - analysis frame length (seconds)
%       f0_min         - minimum F0 (Hz)
%       f0_max         - maximum F0 (Hz)
%
%   Output:
%       corrected_pitch - corrected pitch contour (1 x N_frames, Hz)
%
%   See also: yaapt, yaapt_core, crs_corr

    corrected_pitch = raw_pitch;
    N = length(y);
    frame_samples = round(frame_length_s * fs);

    % Minimum spectral energy ratio to trigger correction
    energy_ratio_threshold = 3.0;

    % Bandwidth around each candidate frequency (Hz)
    % Must be wide enough to capture at least one FFT bin. With 25ms frames
    % at 20kHz, frequency resolution is ~40 Hz/bin. Use half the frame
    % frequency resolution to ensure at least one bin is captured.
    bw = max(40, fs / frame_samples / 2 + 10);

    voiced_idx = find(raw_pitch > 0);

    for k = 1:length(voiced_idx)
        i = voiced_idx(k);
        detected_f0 = raw_pitch(i);

        % Extract frame
        center_sample = round(time_s(i) * fs);
        half_frame = floor(frame_samples / 2);
        start_samp = max(1, center_sample - half_frame);
        end_samp = min(N, center_sample + half_frame);
        frame = y(start_samp:end_samp);

        if length(frame) < 16
            continue;
        end

        % Window and FFT
        win = hanning(length(frame));
        Y = fft(frame .* win);
        mag = abs(Y(1:floor(length(frame)/2)));
        freq_axis = (0:length(mag)-1)' * fs / length(frame);

        % Energy at detected F0
        idx_f0 = freq_axis >= (detected_f0 - bw) & freq_axis <= (detected_f0 + bw);
        e_f0 = sum(mag(idx_f0));

        if e_f0 < eps
            continue;
        end

        % Check: is true F0 at 2× detected? (half-F0 error)
        f0_double = detected_f0 * 2;
        if f0_double <= f0_max && f0_double < fs/2
            idx_2f0 = freq_axis >= (f0_double - bw) & freq_axis <= (f0_double + bw);
            e_2f0 = sum(mag(idx_2f0));
            if e_2f0 / e_f0 > energy_ratio_threshold
                corrected_pitch(i) = f0_double;
                continue;
            end
        end

        % Check: is true F0 at F0/2? (double-F0 error)
        f0_half = detected_f0 / 2;
        if f0_half >= f0_min
            idx_half = freq_axis >= (f0_half - bw) & freq_axis <= (f0_half + bw);
            e_half = sum(mag(idx_half));
            if e_half / e_f0 > energy_ratio_threshold
                corrected_pitch(i) = f0_half;
            end
        end
    end
end
