function [tUniform, vUniform] = resampleToUniformTime(times, values, newFs)
%RESAMPLETOUNIFORMTIME Interpolate values to uniform time grid
%   Rewritten from Python: utils.py resample_to_uniform_time()
%   Cubic interpolation to uniform spacing.

    if nargin < 3
        newFs = 100;
    end

    tUniform = [];
    vUniform = [];

    valid = ~isnan(values) & ~isnan(times);
    if sum(valid) < 2
        return;
    end

    tValid = times(valid);
    vValid = values(valid);

    tMin = min(tValid);
    tMax = max(tValid);
    numSamples = ceil((tMax - tMin) * newFs);

    if numSamples < 2
        return;
    end

    tUniform = linspace(tMin, tMax, numSamples).';
    vUniform = interp1(tValid, vValid, tUniform, 'pchip', NaN);
end
