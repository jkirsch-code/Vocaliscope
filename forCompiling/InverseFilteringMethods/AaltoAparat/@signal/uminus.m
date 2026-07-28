function c = uminus(a)

% overloading of the unary operator -

% $Id: uminus.m 3 2004-02-04 12:57:04Z mairas $

c = set(a,'s',-a.s);
