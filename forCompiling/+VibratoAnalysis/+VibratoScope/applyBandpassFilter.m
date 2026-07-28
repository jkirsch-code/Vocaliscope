function filtered = applyBandpassFilter(signal, fs, lowHz, highHz, order)
%APPLYBANDPASSFILTER Butterworth bandpass filter
%   Rewritten from Python: filters.py apply_bandpass_filter()
%   Uses filtfilt for zero-phase filtering.

    if nargin < 5
        order = 4;
    end

    nyq = 0.5 * fs;
    low = lowHz / nyq;
    high = highHz / nyq;

    % Clamp to valid range
    low = max(low, 0.001);
    high = min(high, 0.999);

    [b, a] = butter(order, [low high], 'band');
    filtered = filtfilt(b, a, signal(:));
end
