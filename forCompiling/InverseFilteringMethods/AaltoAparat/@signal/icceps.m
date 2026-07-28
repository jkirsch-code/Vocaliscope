function x = icceps(xhat,nd)
% ICCEPS  Inverse complex cepstrum
%
%    x = icceps(xhat,nd) returns the inverse complex cepstrum of
%    the (assumed real) sequence xhat, removing nd samples of
%    delay.

% $Id: icceps.m 46 2004-08-26 11:48:36Z mairas $


x_ = icceps(xhat.s,nd);

t = time(struct('begin',xhat.time.t(1+nd),'num',length(x_),'fs',xhat.fs));

x = signal(x_,t);
