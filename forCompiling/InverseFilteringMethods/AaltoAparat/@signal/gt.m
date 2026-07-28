function c = gt(a,b)

% overloading of operator >

% $Id: gt.m 50 2004-12-10 12:42:40Z mairas $

if isa(a,'signal') & ~isa(b,'signal')
  c = a.s > b;
elseif ~isa(a,'signal') & isa(b,'signal')
  c = a > b.s;
elseif isa(a,'signal') & isa(b,'signal')

  if a.fs ~= b.fs
    error('Sampling frequencies do not match.');
  end
  df = a.time.t(2)-a.time.t(1);
  if mod(b.time.t(1),df)-mod(a.time.t(1),df)>1e-7
    error('Sampling instants do not match.');
  end
  
  c = a.s>b.s;
end

