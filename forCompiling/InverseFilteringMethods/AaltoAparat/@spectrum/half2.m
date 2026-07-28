function y = half2(x)

% $Id: half2.m 3 2004-02-04 12:57:04Z mairas $

fn = x.fs/2;
In = at(x.frequency,fn);

y = subsref(x,struct('type','()','subs',{{In+1:length(x.frequency.f)}}));
