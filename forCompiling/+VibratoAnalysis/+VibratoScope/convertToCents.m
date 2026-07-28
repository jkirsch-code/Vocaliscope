function cents = convertToCents(pitchHz, refHz)
%CONVERTTOCENTS Convert frequency in Hz to cents relative to reference
%   Rewritten from Python: utils.py convert_to_cents()
%   CENTS = 1200 * log2(F / FREF)

    if nargin < 2
        refHz = 440.0;
    end

    pitchHz = pitchHz(:);
    cents = nan(size(pitchHz));
    valid = ~isnan(pitchHz) & pitchHz > 0;
    cents(valid) = 1200 * log2(pitchHz(valid) / refHz);
end
