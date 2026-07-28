function c=eq(a,b)

% overloading of operator ==

% $Id: eq.m 47 2004-09-09 08:01:57Z mairas $

if ~(isa(a,'time') & isa(b,'time'))
  error('Both operands must be time objects');
end

try
  c = (a.beg==b.beg & a.num==b.num & a.fs==b.fs);
catch
  c=0;
end
