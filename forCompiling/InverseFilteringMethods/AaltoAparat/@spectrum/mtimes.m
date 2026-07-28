function c = mtimes(a,b)

% overloading of operator *

% $Id: mtimes.m 3 2004-02-04 12:57:04Z mairas $

if isa(a,'spectrum') & isa(b,'spectrum')
  error('Matrix multiplication of two spectra not supported.');
elseif isa(a,'spectrum') & ~isa(b,'spectrum')
  c = spectrum(a.s * b(:)', a.frequency);
elseif ~isa(a,'spectrum') & isa(b,'spectrum')
  c = spectrum(a(:)' * b.s, b.frequency);
else
  error('Invalid operands in multiplication.');
end
