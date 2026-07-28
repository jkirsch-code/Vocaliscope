function xhat = cceps(x,varargin)
% CCEPS  Complex cepstral analysis
%
%    xhat = cceps(x)
%    xhat = cceps(x,n)
%
%    Calculate complex cepstrum of a signal. See CCEPS for more
%    information.

% $Id: cceps.m 46 2004-08-26 11:48:36Z mairas $

xhat_ = cceps(x.s,varargin{:});

t = time(struct('begin',0,'num',length(xhat_),'fs',x.fs));

xhat = signal(xhat_,t);
