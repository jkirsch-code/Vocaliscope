function I = at(x,t)
% AT  Return element index corresponding to a time value.
%
% I = AT(X,T)  Return element index I at time location t in time object X.

% $Id: at.m 65 2005-05-16 07:06:26Z mairas $

I=round((t-x.beg)*x.fs+1);
idx=find(I<1);
I(idx)=1;
idx=find(I>x.num);
I(idx)=x.num;
