function c = ldivide(a,b)

% overloading of operator .\

% $Id: ldivide.m 111 2006-03-14 10:30:29Z bassus $


if isa(a,'signal') & isa(b,'signal')
  if a.fs ~= b.fs
    error('sampling frequencies do not match');
  elseif abs(a.time.begin-b.time.begin)>1e-7 | a.time.num~=b.time.num | ...
	a.time.fs~=b.time.fs
    error('Time instants do not match');
  end
  c = signal(a.s .\ b.s,a.time);
elseif isa(a,'signal') & ~isa(b,'signal')
  c = signal(a.s .\ b, a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  c = signal(a .\ b.s, b.time);
end
