function c = rdivide(a,b)

% overloading of operator ./

% $Id: times.m 3 2004-02-04 12:57:04Z mairas $

if isa(a,'spectrum') & isa(b,'spectrum') & a.frequency==b.frequency
  c = spectrum(a.s ./ b.s,a.frequency);
elseif isa(a,'spectrum') & ~isa(b,'spectrum')
  c = spectrum(a.s ./ b(:)', a.frequency);
elseif ~isa(a,'spectrum') & isa(b,'spectrum')
  c = spectrum(a(:)' ./ b.s, b.frequency);
else
  error('Invalid operands in division.');
end
