function c = times(a,b)

% overloading of operator .*

% $Id: times.m 3 2004-02-04 12:57:04Z mairas $

if isa(a,'signal') & isa(b,'signal') & a.time==b.time
  c = signal(a.s .* b.s,a.time);
elseif isa(a,'signal') & ~isa(b,'signal')
  c = signal(a.s .* b(:)', a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  c = signal(a(:)' .* b.s, b.time);
else
  error('Invalid operands in multiplication.');
end
