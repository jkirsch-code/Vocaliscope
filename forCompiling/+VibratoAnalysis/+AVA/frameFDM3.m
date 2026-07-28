function [fk, d] = frameFDM3(c0, Fs, f_min, f_max, k_max)
%FRAMEFDM3 Frequency estimation via Matrix Pencil Method
%   [FK, D] = FRAMEFDM3(C0, FS, F_MIN, F_MAX, K_MAX) estimates the
%   frequencies and complex amplitudes of sinusoidal components in signal C0.
%
%   Uses the Matrix Pencil Method (Hua & Sarkar, 1990) which solves a
%   generalized eigenvalue problem on Hankel-structured matrices built from
%   the signal's autocorrelation. This is mathematically equivalent to FDM
%   (Yang, Rajab & Chew, 2017) but numerically more stable.
%
%   Inputs:
%     c0    - Real-valued signal frame (column vector, DC-removed)
%     Fs    - Sampling rate (Hz) of the input signal
%     f_min - Minimum frequency search bound (Hz)
%     f_max - Maximum frequency search bound (Hz)
%     k_max - Pencil parameter L controls resolution vs noise (default: 6,
%             interpreted as fraction of N: L = round(N/k_max))
%
%   Outputs:
%     fk - Complex frequencies in Hz (real part = frequency, imag part = damping)
%     d  - Complex amplitudes (magnitude = half-peak amplitude, angle = phase)

    if nargin < 5
        k_max = 6;
    end

    N = numel(c0);
    tau = 1 / Fs;

    fk = [];
    d = [];

    if N < 10
        return;
    end

    c0 = c0(:);

    % Pencil parameter: L controls the trade-off between resolution and
    % noise robustness. Typical choice: N/3 <= L <= N/2.
    L = max(3, round(N / k_max));
    L = min(L, floor(N / 2));

    % Build data matrix from the signal using the Hankel structure
    % X0: rows = L+1, cols = N-L
    % Column j contains c0(j:j+L), so X0 has L+1 rows
    M = N - L;
    X0 = zeros(L + 1, M);
    for j = 1:M
        X0(:, j) = c0(j:j + L);
    end

    % Split into X0 (rows 1..L) and X1 (rows 2..L+1)
    Y0 = X0(1:L, :);
    Y1 = X0(2:L+1, :);

    % SVD for noise subspace reduction
    [U, S, ~] = svd(Y0, 'econ');
    s = diag(S);

    % Keep singular values above threshold (1% of max, or minimum 1)
    threshold = max(s) * 1e-2;
    r = sum(s > threshold);
    r = max(r, 1);

    U1 = U(:, 1:r);
    S1 = S(1:r, 1:r);
    [~, ~, Vfull] = svd(Y0, 'econ');
    V1 = Vfull(:, 1:r);

    % Project into r-dimensional signal subspace (square matrices)
    Y0_r = S1 \ (U1' * Y0 * V1);
    Y1_r = S1 \ (U1' * Y1 * V1);

    % Generalized eigenvalues: z = eig(Y1_r, Y0_r)
    try
        z = eig(Y1_r, Y0_r);
    catch
        return;
    end

    % Convert eigenvalues to frequencies
    % z = exp(j * omega * tau), so omega = angle(z) / tau, f = angle(z) / (2*pi*tau)
    absZ = abs(z);
    angleZ = angle(z);
    freqEst = angleZ / (2 * pi * tau);

    % Filter: eigenvalues must be on or near unit circle (undamped sinusoids)
    % and frequency must be within search bounds
    validMask = absZ > 0.1 & absZ < 2.0 & ...
                freqEst >= f_min & freqEst <= f_max;

    if ~any(validMask)
        return;
    end

    z = z(validMask);
    freqEst = freqEst(validMask);

    % Remove duplicates (keep unique frequencies)
    [~, sortIdx] = sort(real(freqEst));
    z = z(sortIdx);
    freqEst = freqEst(sortIdx);

    keep = true(numel(freqEst), 1);
    for j = 2:numel(freqEst)
        if abs(freqEst(j) - freqEst(j-1)) < 0.1
            keep(j) = false;
        end
    end
    z = z(keep);
    freqEst = freqEst(keep);

    % Estimate amplitudes via least-squares fit using real basis functions
    % For each frequency f_k, use [cos(2*pi*f_k*t), sin(2*pi*f_k*t)] as basis
    t = (0:N-1).' * tau;
    A = zeros(N, 2 * numel(z));
    for j = 1:numel(z)
        freq = real(freqEst(j));
        A(:, 2*j-1) = cos(2 * pi * freq * t);
        A(:, 2*j) = sin(2 * pi * freq * t);
    end

    coeffs = A \ c0;

    % Convert real coefficients to complex amplitude: d_k = (a_k - j*b_k)/2
    % where signal = sum_k a_k*cos(w_k*t) + b_k*sin(w_k*t)
    amplitudes = zeros(numel(z), 1);
    for j = 1:numel(z)
        a_k = coeffs(2*j-1);
        b_k = coeffs(2*j);
        amplitudes(j) = sqrt(a_k^2 + b_k^2);  % Peak amplitude of sinusoid
    end

    % Keep components where the fit is reasonable
    fitted = A * coeffs;
    residual = norm(c0 - fitted) / sqrt(N);
    sigStd = std(c0);

    if sigStd > 1e-10
        relResidual = residual / sigStd;
        % Keep if residual captures less than 80% of signal variance
        goodMask = relResidual < 0.8;
    else
        goodMask = true(numel(amplitudes), 1);
    end

    if ~any(goodMask)
        % Keep all components as fallback
        goodMask = true(size(amplitudes));
    end

    fk = freqEst(goodMask);
    d = amplitudes(goodMask);
end
