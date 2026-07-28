function c = mtimes(a,b)

% overloading of operator *

% $Id: mtimes.m 31 2004-07-28 10:46:46Z mairas $

if isa(a,'signal') & isa(b,'signal')
  error('Matrix multiplication of two signals not supported.');
elseif isa(a,'signal') & ~isa(b,'signal')
  if max(size(b))>1
    error('Only scalar multipliers are allowed.');
  end
  c = signal(a.s * b, a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  if max(size(a))>1
    error('Only scalar multipliers are allowed.');
  end
  c = signal(a * b.s, b.time);
else
  error('Invalid operands in multiplication.');
end
