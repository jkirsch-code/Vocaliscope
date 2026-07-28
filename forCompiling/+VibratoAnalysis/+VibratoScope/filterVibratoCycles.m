function filteredParams = filterVibratoCycles(cycleParams, minHalfExtent, maxHalfExtent)
%FILTERVIBRATOCYCLES Filter cycles by extent range
%   Rewritten from Python: core.py filter_vibrato_cycles()
%   Keeps cycles where half_extent_cents is within [min, max].

    filteredParams = {};
    for i = 1:numel(cycleParams)
        cp = cycleParams{i};
        if cp.half_extent_cents >= minHalfExtent && cp.half_extent_cents <= maxHalfExtent
            filteredParams{end+1} = cp; %#ok<AGROW>
        end
    end
end
