function c=eq(a,b)

% overloading of operator ==

% $Id: eq.m 31 2004-07-28 10:46:46Z mairas $

if ~(isa(a,'spectrum') & isa(b,'spectrum'))
  error('Both operands must be spectrum objects');
end

try
  c = (a.s==b.s & a.frequency==b.frequency);
catch
  c=0;
end
