function y=scale(x,xmin,xmax)
% SCALE  Scale a signal to a given amplitude range
%
%   Y=SCALE(X,XMIN,XMAX) 
%
%   Scale X so that the signal values are between XMIN and XMAX.

% $Id: scale.m 3 2004-02-04 12:57:04Z mairas $

minx = min(x);
maxx = max(x);
ampl = maxx-minx;

y = (xmax-xmin)/ampl .* (x-minx) +xmin;
