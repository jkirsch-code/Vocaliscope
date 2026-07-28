function metrics = computeJitterMetrics(periods)
%COMPUTEJITTERMETRICS Compute jitter metrics from cycle periods
%   Rewritten from Python: core.py compute_jitter_metrics()
%   Computes: jitter_local_percent, jitter_local_abs_ms, jitter_rap_percent,
%   jitter_ppq5_percent, jitter_ddp_percent.

    N = numel(periods);

    metrics = struct( ...
        'jitter_local_percent', NaN, ...
        'jitter_local_abs_ms', NaN, ...
        'jitter_rap_percent', NaN, ...
        'jitter_ppq5_percent', NaN, ...
        'jitter_ddp_percent', NaN);

    if N < 2
        return;
    end

    meanPeriod = mean(periods, 'omitnan');
    diffs = abs(diff(periods));

    % Jitter local (percent)
    metrics.jitter_local_percent = mean(diffs, 'omitnan') / meanPeriod * 100;
    metrics.jitter_local_abs_ms = mean(diffs, 'omitnan') * 1000;

    % Jitter RAP (3-point)
    if N >= 3
        rapDiffs = zeros(N-2, 1);
        for i = 2:N-1
            avgThree = mean(periods(i-1:i+1));
            rapDiffs(i-1) = abs(periods(i) - avgThree);
        end
        metrics.jitter_rap_percent = mean(rapDiffs) / meanPeriod * 100;
    end

    % Jitter PPQ5 (5-point)
    if N >= 5
        ppq5Diffs = zeros(N-4, 1);
        for i = 3:N-2
            avgFive = mean(periods(i-2:i+2));
            ppq5Diffs(i-2) = abs(periods(i) - avgFive);
        end
        metrics.jitter_ppq5_percent = mean(ppq5Diffs) / meanPeriod * 100;
    end

    % Jitter DDP
    if N >= 3
        ddpDiffs = zeros(N-2, 1);
        for i = 2:N-1
            diff1 = periods(i) - periods(i-1);
            diff2 = periods(i+1) - periods(i);
            ddpDiffs(i-1) = abs(diff1 - diff2);
        end
        metrics.jitter_ddp_percent = mean(ddpDiffs) / meanPeriod * 100;
    end
end
