function c = plus(a,b)

% overloading of operator +

% $Id: plus.m 39 2004-08-06 09:05:50Z mairas $

if isa(a,'spectrum') & isnumeric(b)
  c = spectrum(a.s + b, a.frequency);
elseif isnumeric(a) & isa(b,'spectrum')
  c = spectrum(a + b.s, b.frequency);
elseif isa(a,'spectrum') & isa(b,'spectrum')
  if not(a.frequency==b.frequency)
    error('Frequency vectors do not match.');
  end
  c = spectrum(a.s+b.s,a.frequency);
end
