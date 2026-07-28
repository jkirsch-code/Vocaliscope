function b = cumsum(a)
% CUMSUM  Cumulative sum of signal elements
%    B = CUMSUM(A)  returns the cumulative sum of signal elements.

% $Id: cumsum.m 100 2005-12-14 15:04:56Z bassus $

b = signal(cumsum(a.s), a.time);
b.valid = a.valid;