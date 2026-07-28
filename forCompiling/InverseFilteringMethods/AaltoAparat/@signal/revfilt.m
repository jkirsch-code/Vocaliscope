function [y,zf] = revfilt(b,a,X,varargin)
% REVFILT One-dimensional reverse digital filter.
%    REVFILT works exactly like filter except that the filtering is performed
%    on a reversed signal.

% $Id: filter.m 112 2006-03-22 15:14:07Z bassus $

rX = set(X,'s',fliplr(X.s));
rX = set(rX,'time',set(rX.time,'begin',-rX.time.begin));
[ry,rzf] = filter(b,a,rX,varargin{1:end});
y = set(ry,'s',fliplr(ry.s));
y = set(y,'time',set(y.time,'begin',-y.time.begin));
zf = fliplr(rzf);
