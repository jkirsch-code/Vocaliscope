function y = abs(x)
% ABS  Absolute value and complex magnitude
%    Y = abs(X)  returns a signal Y such that each element of Y is
%    the absolute value of the corresponding element of X.

% $Id: abs.m 3 2004-02-04 12:57:04Z mairas $

y = signal(abs(x.s),x.time);
