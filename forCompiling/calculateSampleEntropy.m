function sampEn = calculateSampleEntropy(signal, templateLength, stdPercentage)
% maybe we should use https://github.com/BYO-UPM/AVCA-ByO/blob/master/src/Complexity/CalculateRegularity.m

%             sampEn=physionet_sampen(signal,templateLength,stdPercentage);
%             sampEn=sampEn(end);
%             return;

if isempty(signal) || stdPercentage==0
    sampEn=NaN;
else
    sampEn=fastSampEn(signal,templateLength,stdPercentage);
end



% return;
%
% r=stdPercentage*std(signal);
% N = length(signal);
%
%
% % Construct embedding matrix for m-length segments:
% X_m = zeros(N-templateLength+1, templateLength);
% for i = 1:(N-templateLength+1)
%     X_m(i,:) = signal(i:i+templateLength-1);
% end
%
% % Compute the Chebyshev (maximum) norm between all template pairs:
% dists_m = pdist(X_m, @(xi,xj)  max(abs(xi - xj), [], 2));
% D_m = squareform(dists_m);
%
% % Count the number of matches (exclude the self-match on the diagonal)
% % Note that D_m is symmetric, so we count the entries below (or above) the diagonal.
% B = sum(sum(tril(D_m < r, -1)));
%
% % Now construct the embedding matrix for m+1-length segments:
% X_m1 = zeros(N-templateLength, templateLength+1);
% for i = 1:(N-templateLength)
%     X_m1(i,:) = signal(i:i+templateLength);
% end
%
% % Compute distances for (m+1)-length segments
% dists_m1 = pdist(X_m1, @(xi,xj) max(abs(xi - xj), [], 2));
% D_m1 = squareform(dists_m1);
%
% A = sum(sum(tril(D_m1 < r, -1)));
%
% % Avoid division by zero. If no matches are found, return Inf.
%
%
% if B == 0 || A == 0
%     sampEn = 0;
% else
%     sampEn = -log(A / B);
% end
end
