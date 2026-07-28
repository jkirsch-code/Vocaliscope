function cycleParams = computeCycleParameters(tValid, rawCents, extents, allIdx)
%COMPUTECYCLEPARAMETERS Compute per-cycle vibrato parameters
%   Rewritten from Python: core.py compute_cycle_parameters()
%   For each half-cycle: center time, period, half extent, center pitch.

    nCycles = numel(extents);
    cycleParams = cell(nCycles, 1);

    for i = 1:nCycles
        idx1 = allIdx(i);
        idx2 = allIdx(i + 1);

        t1 = tValid(idx1);
        t2 = tValid(idx2);

        centerTime = (t1 + t2) / 2.0;
        centerCents = (rawCents(idx1) + rawCents(idx2)) / 2.0;
        centerPitch = 2^(centerCents / 1200) * 440;

        cycleParams{i} = struct( ...
            'center_time_s', centerTime, ...
            'cycle_time', t2 - t1, ...
            'half_extent_cents', extents(i), ...
            'center_pitch', centerPitch);
    end
end
