function centsCentered = removeMeanOrMedian(cents, useMedian)
%REMOVEMEANORMEDIAN Center pitch contour by removing mean or median
%   Rewritten from Python: utils.py remove_mean_or_median()

    if nargin < 2
        useMedian = true;
    end

    centsCentered = cents(:);
    valid = ~isnan(centsCentered);

    if ~any(valid)
        return;
    end

    if useMedian
        centerValue = median(centsCentered(valid));
    else
        centerValue = mean(centsCentered(valid));
    end

    centsCentered(valid) = centsCentered(valid) - centerValue;
end
