function c=eq(a,b)

% overloading of operator ==

% $Id: eq.m 31 2004-07-28 10:46:46Z mairas $

if ~(isa(a,'frequency') & isa(b,'frequency'))
  error('Both operands must be frequency objects');
end

try
  c = (a.num==b.num & a.fs==b.fs);
catch
  c=0;
end
