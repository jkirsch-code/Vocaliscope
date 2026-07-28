function c = mrdivide(a,b)

% overloading of operator /

if isa(a,'signal') & isa(b,'signal')
  error('Matrix division of two signals not supported.');
elseif isa(a,'signal') & ~isa(b,'signal')
  if max(size(b))>1
    error('Only scalar multipliers are allowed.');
  end
  c = signal(a.s ./ b, a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  if max(size(a))>1
    error('Only scalar divisors are allowed.');
  end
  c = signal(a ./ b.s, b.time);
else
  error('Invalid operands in division.');
end
