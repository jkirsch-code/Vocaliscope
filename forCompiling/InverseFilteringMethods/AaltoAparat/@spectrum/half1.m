function y = half1(x)

% $Id: half1.m 3 2004-02-04 12:57:04Z mairas $

fn = x.fs/2;
In = at(x.frequency,fn);

y = subsref(x,struct('type','()','subs',{{1:In}}));
