function c = conv(u,v)
% function c = conv(u,v)

c = conv(u.s,v.s);
c = signal(c,u.time.fs);
t = c.time;
t = set(t,'begin', u.time.begin+v.time.begin, 'num', length(u.s)+length(v.s)-1);
c.time = t;