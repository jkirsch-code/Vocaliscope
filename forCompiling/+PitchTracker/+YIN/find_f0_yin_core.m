function [f0, periodicity] = find_f0_yin_core(s, fs, f0_min, f0_max, threshold)
%%% changed for Vocaliscope project 20260720 %%%
% FIND_F0_YIN_CORE  Find fundamental frequency using the YIN method
%
%    Adapted from AaltoAparat (M. Airas, 2005) for Vocaliscope.
%
%    [F0, PERIODICITY] = FIND_F0_YIN_CORE(S, FS, F0_MIN, F0_MAX, THRESHOLD)
%
%    Estimate the fundamental frequency of signal S (1-D double vector)
%    sampled at FS Hz, using the YIN algorithm (de Cheveigne & Kawahara).
%
%    Inputs:
%       s         - audio signal samples (column or row vector)
%       fs        - sampling rate (Hz)
%       f0_min    - minimum F0 to consider (Hz), default 60
%       f0_max    - maximum F0 to consider (Hz), default 2000
%       threshold - absolute threshold for step 4 (default 0.1)
%
%    Outputs:
%       f0        - estimated fundamental frequency (Hz), scalar
%       periodicity - confidence measure (0-1), lower = more periodic
%                     (minimum value of the normalized difference function)
% %%% end changed %%%

    if nargin < 3 || isempty(f0_min),    f0_min = 60;        end
    if nargin < 4 || isempty(f0_max),    f0_max = 2000;      end
    if nargin < 5 || isempty(threshold), threshold = 0.1;    end

    s = s(:).';  % ensure row vector

    tau_min = floor(fs / f0_max);
    tau_max = ceil(fs / f0_min);

    N = length(s);
    W = N - tau_max;
    if W < 1
        f0 = NaN;
        periodicity = NaN;
        return;
    end

    % Step 2: Difference function
    d = zeros(1, tau_max);
    for tau = 1:tau_max
        d(tau) = sum((s(1:W) - s((1:W) + tau)).^2);
    end

    % Step 3: Cumulative mean normalized difference function
    cumd = cumsum(d);
    dn = d ./ (cumd ./ (1:tau_max));

    % Step 4: Absolute threshold — find first dip below threshold
    diff_dn = diff(dn);
    if tau_min >= 2
        diff1 = diff_dn(max(tau_min - 1, 1):end - 1);
        diff2 = diff_dn(max(tau_min, 2):end);
        dn_range = dn(max(tau_min, 1):end - 1);
        minima = (diff1 <= 0) & (diff2 > 0) & (dn_range <= threshold);
    else
        diff1 = diff_dn(1:end - 1);
        diff2 = diff_dn(2:end);
        dn_range = dn(1:end - 1);
        minima = (diff1 <= 0) & (diff2 > 0) & (dn_range <= threshold);
    end

    [~, idx] = max(minima);
    if isempty(idx) || idx == 0
        % No threshold crossing — use global minimum
        dn_search = dn(tau_min:end);
        [~, min_idx] = min(dn_search);
        min_idx = min_idx + tau_min - 1;
        periodicity = dn(min_idx);
    else
        min_idx = idx + tau_min - 1;
        periodicity = dn(min_idx);
    end

    % Step 5: Parabolic interpolation
    if min_idx >= 2 && min_idx < length(dn)
        three = dn((min_idx - 1):(min_idx + 1));
        a = 0.5 * three(1) - three(2) + 0.5 * three(3);
        b = -0.5 * three(1) + 0.5 * three(3);
        x0 = -b / (2 * a);
        f0 = fs / (min_idx + x0);
    else
        f0 = fs / min_idx;
    end

    % Invert: low dn_min = high periodicity confidence
    % Scale: dn=0 -> periodicity=1, dn=threshold -> periodicity=0.5, dn=1 -> periodicity=0
    periodicity = 1 - min(periodicity, 1);

    % Sanity check
    if f0 < f0_min || f0 > f0_max
        f0 = NaN;
        periodicity = NaN;
    end
end
