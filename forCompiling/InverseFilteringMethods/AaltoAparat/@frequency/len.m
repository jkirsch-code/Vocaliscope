function l = len(x)
% LEN  Length of the frequency vector

% $Id: len.m 31 2004-07-28 10:46:46Z mairas $

for i=1:length(x)
  l(i) = x(i).num;
end
