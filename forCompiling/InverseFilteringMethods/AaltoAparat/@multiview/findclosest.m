function par = findclosest(c,pt)

m=1e9;
midx=0;
x=pt(1);
y=pt(2);
for i=1:length(c.data)
  d=abs(y-c.data{i}.at(x));
  if d<m
    m=d;
    midx=i;
  end
end

par = c.param(midx);

destroy(deref(get(c,'this')));
