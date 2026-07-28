function [y,ym] = rceps(x)

% $Id: rceps.m 46 2004-08-26 11:48:36Z mairas $

[y_,ym_] = rceps(x.s);

t = time(struct('begin',0,'num',length(y_),'fs',x.fs));

y = signal(y_,t);
ym = signal(ym_,t);

