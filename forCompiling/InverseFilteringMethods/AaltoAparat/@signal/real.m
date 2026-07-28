function y = real(x)
% REAL Complex real part.

% $Id: real.m 3 2004-02-04 12:57:04Z mairas $

y = x;
y.s = real(y.s);
