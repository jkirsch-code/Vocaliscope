function l = len(x)

% $Id: len.m 31 2004-07-28 10:46:46Z mairas $

for i=1:length(x)
  l(i) = length(x(i).s);
end
