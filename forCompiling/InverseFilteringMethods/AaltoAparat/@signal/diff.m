function y = diff(x,varargin)

% $Id: diff.m 48 2004-09-16 12:07:24Z mairas $

y = x;
y.s = diff(x.s,varargin{:});
n = length(x.s)-length(y.s);

t = x.time;
% should there be a half sample time shift in diff?
% answer: no, think of the definition of differentiation
% revised answer, with help of Tom: yes, there should, as it
% makes more sense. :-)
t = set(t,'begin', t.begin+(n/t.fs)/2, 'num', t.num-n);
%t = set(t,'num', t.num-n);
y=set(y,'time',t);
