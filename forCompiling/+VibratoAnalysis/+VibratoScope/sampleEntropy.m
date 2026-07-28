function sampEn = sampleEntropy(timeSeries, m, r)
%SAMPLEENTROPY Compute Sample Entropy (SampEn)
%   Rewritten from Python: utils.py sample_entropy()
%   SampEn = -ln(A(m+1) / A(m)) where A(m) is the proportion of
%   matching vector pairs of length m within tolerance r.

    if nargin < 3
        r = 0.2 * std(timeSeries);
    end
    if nargin < 2
        m = 2;
    end

    timeSeries = timeSeries(:);
    N = numel(timeSeries);

    sampEn = NaN;

    if m < 1 || N < m + 1 || r <= 0
        return;
    end

    phiM = computePhi(timeSeries, m, N, r);
    phiM1 = computePhi(timeSeries, m + 1, N, r);

    if phiM == 0 || phiM1 == 0
        sampEn = Inf;
        return;
    end

    % Bias correction (Lake et al., 2002)
    correction = (m + 1) / (N - m);
    rawSampEn = -log(phiM1 / phiM);
    sampEn = rawSampEn * correction;
end

function phi = computePhi(ts, m, N, r)
    nPatterns = N - m + 1;
    count = 0;

    for i = 1:nPatterns
        pat_i = ts(i:i+m-1);
        for j = 1:nPatterns
            if i == j
                continue;
            end
            pat_j = ts(j:j+m-1);
            if max(abs(pat_i - pat_j)) <= r
                count = count + 1;
            end
        end
    end

    denom = nPatterns * (nPatterns - 1);
    if denom > 0
        phi = count / denom;
    else
        phi = 0;
    end
end
