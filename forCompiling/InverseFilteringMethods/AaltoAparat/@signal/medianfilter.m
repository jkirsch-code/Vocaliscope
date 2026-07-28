function f = medianfilter(s,n)
% function f = medianfilter(s,n)

lobelen = ceil((n-1)/2);
len = length(s.s);

% initial part
for k = 1:lobelen
    f(k) = median(s.s(1:k));
end

% main part
for k=(1+lobelen):(len-lobelen-1)
    f(k) = median(s.s(k+(-lobelen:lobelen)));
end

% back part
for k = len-(lobelen:1)
    f(k) = median(s.s(k:end));
end

f = signal(f,s.fs);