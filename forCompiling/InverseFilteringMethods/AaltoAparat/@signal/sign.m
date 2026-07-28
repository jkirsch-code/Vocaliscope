function c = sign(a)

% overloading of the unary operator -

% $Id: sign.m 57 2005-01-05 11:21:32Z mairas $

c = set(a,'s',sign(a.s));
