function [peaks, troughs, cycleTimes, cycleHalfExtents, tValid, rawCents, allIdx] = ...
    detectVibratoCycles(tUniform, centsRaw, centsFiltered, prominence, minDistance)
%DETECTVIBRATOCYCLES Find peaks and troughs in filtered pitch contour
%   Rewritten from Python: core.py detect_vibrato_cycles()
%   Detects extrema, pairs consecutive ones into half-cycles.

    if nargin < 5
        minDistance = 5;
    end
    if nargin < 4
        prominence = 5;
    end

    % Work with valid (non-NaN) data only
    valid = ~isnan(centsFiltered);
    tValid = tUniform(valid);
    filt = centsFiltered(valid);
    rawCents = centsRaw(valid);

    if numel(filt) < 2 * minDistance
        peaks = [];
        troughs = [];
        cycleTimes = [];
        cycleHalfExtents = [];
        rawCents = [];
        allIdx = [];
        return;
    end

    % Find peaks (positive extrema)
    [~, peakLocs] = findpeaks(filt, 'MinPeakProminence', prominence, 'MinPeakDistance', minDistance);

    % Find troughs (negative extrema)
    [~, troughLocs] = findpeaks(-filt, 'MinPeakProminence', prominence, 'MinPeakDistance', minDistance);

    peaks = peakLocs;
    troughs = troughLocs;

    % Merge and sort all extrema
    allIdx = sort([peakLocs; troughLocs]);

    % Compute cycle times and half-extents from consecutive extrema
    nCycles = numel(allIdx) - 1;
    cycleTimes = zeros(nCycles, 1);
    cycleHalfExtents = zeros(nCycles, 1);

    for i = 1:nCycles
        i1 = allIdx(i);
        i2 = allIdx(i + 1);
        dt = tValid(i2) - tValid(i1);
        fullAmp = abs(filt(i2) - filt(i1));
        halfAmp = fullAmp / 2.0;
        cycleTimes(i) = dt;
        cycleHalfExtents(i) = halfAmp;
    end
end
