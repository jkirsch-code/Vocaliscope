function [cvRate, cvExtent] = computeCV(cycleTimes, cycleExtents)
%COMPUTECV Coefficient of variation for vibrato rate and extent
%   Rewritten from Python: core.py compute_cv()
%   CV = (std / mean) * 100, using sample std (ddof=1).

    cvRate = NaN;
    cvExtent = NaN;

    % Rate CV
    validTimes = ~isnan(cycleTimes) & cycleTimes > 0;
    if sum(validTimes) >= 2
        vibratoRates = 1 ./ (2 * cycleTimes(validTimes));
        cvRate = (std(vibratoRates) / mean(vibratoRates)) * 100;
    end

    % Extent CV
    validExtents = ~isnan(cycleExtents) & cycleExtents > 0;
    if sum(validExtents) >= 2
        cvExtent = (std(cycleExtents(validExtents)) / mean(cycleExtents(validExtents))) * 100;
    end
end
