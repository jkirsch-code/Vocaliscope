function pitchFiltered = filterPitchOutliers(pitchHz, threshold)
%FILTERPITCHOUTLIERS Remove pitch outliers using MAD
%   Rewritten from Python: filters.py filter_pitch_outliers()
%   Values deviating more than threshold * MAD from median are set to NaN.
%   Non-valid values (NaN, zero, negative) are also set to NaN.

    pitchFiltered = pitchHz(:);
    valid = ~isnan(pitchFiltered) & pitchFiltered > 0;

    % Set non-valid values to NaN (matches Python np.where behavior)
    pitchFiltered(~valid) = NaN;

    if sum(valid) < 5
        return;
    end

    medianVal = median(pitchFiltered(valid));
    mad = median(abs(pitchFiltered(valid) - medianVal));

    if mad == 0
        return;
    end

    lowerBound = medianVal - threshold * mad;
    upperBound = medianVal + threshold * mad;

    outlierMask = pitchFiltered(:) > 0 & (pitchFiltered < lowerBound | pitchFiltered > upperBound);
    pitchFiltered(outlierMask) = NaN;
end
