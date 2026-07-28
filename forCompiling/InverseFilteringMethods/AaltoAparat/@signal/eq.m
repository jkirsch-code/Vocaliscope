function c=eq(a,b)

% overloading of operator ==

% $Id: eq.m 31 2004-07-28 10:46:46Z mairas $

if ~(isa(a,'signal') & isa(b,'signal'))
  error('Both operands must be signal objects');
end

try
  c = (a.s==b.s & a.time==b.time & a.valid==b.valid);
catch
  c=0;
end
