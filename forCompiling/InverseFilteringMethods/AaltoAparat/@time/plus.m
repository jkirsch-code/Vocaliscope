function c = plus(a,b)

% sum a time vector with a scalar time

% $Id: plus.m 47 2004-09-09 08:01:57Z mairas $

if (isa(a,'time'))
  c = a;
  t = b;
else
  c = b;
  t = a;
end
 
c.beg = c.beg+t;
