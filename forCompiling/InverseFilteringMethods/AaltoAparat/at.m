function [idx] = at(y,xs)
% [idx] = at(y,xs)  Return elements of y nearest to xs
% AT is the inverse of the indexing paren operator. Ie,
%
% xs=y(idx) <=> idx=at(y,xs)
%
% AT can for instance be used to get the corresponding indexes from a
% time vector:
%
% t=(0:fs-1)/fs;
% idx=at(t,[0.5 0.6]);

% $Id: at.m 3 2004-02-04 12:57:04Z mairas $

idx=zeros(size(xs));

for i=1:length(xs)
  x=xs(i);
  [C,idx(i)] = min(abs(y-x));
end

