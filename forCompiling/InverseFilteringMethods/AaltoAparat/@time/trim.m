function y = trim(x,t1,t2)

% $Id: trim.m 47 2004-09-09 08:01:57Z mairas $

beg = x.beg+(at(x,t1)-1)/x.fs;
fs = x.fs;
num = at(x,t2) - at(x,t1) +1;
y = time(beg,num,fs);
