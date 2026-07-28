function r = ne(a,b)

if isa(a,'ref') && isa(b,'ref')
  r = a.hnd ~= b.hnd;
elseif iscell(a) && isa(b,'ref')
  for i=1:length(a)
    r(i) = a{i}.hnd ~= b.hnd;
  end
else
  r = false;
end
