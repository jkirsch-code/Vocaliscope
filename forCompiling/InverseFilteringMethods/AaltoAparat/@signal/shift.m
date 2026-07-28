function y=shift(x,t)
% SHIFT Shift the signal on the time axis.
%
% Y=SHIFT(X,T) shifts the time of signal X by time T. In essence,
% the beginning instant of the signal X is increased by time T.

% $Id: shift.m 64 2005-01-17 09:52:58Z mairas $

xt=x.time;
xt=set(xt,'begin',xt.begin+t);
y=set(x,'time',xt);
