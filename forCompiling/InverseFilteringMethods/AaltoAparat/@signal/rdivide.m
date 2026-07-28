function c = rdivide(a,b)

% overloading of operator ./

% $Id: rdivide.m 83 2005-08-19 11:05:34Z mairas $


if isa(a,'signal') & isa(b,'signal')
  if a.fs ~= b.fs
    error('sampling frequencies do not match');
  elseif abs(a.time.begin-b.time.begin)>1e-7 | a.time.num~=b.time.num | ...
	a.time.fs~=b.time.fs
    error('Time instants do not match');
  end
  c = signal(a.s ./ b.s,a.time);
elseif isa(a,'signal') & ~isa(b,'signal')
  c = signal(a.s ./ b, a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  c = signal(a ./ b.s, b.time);
end
