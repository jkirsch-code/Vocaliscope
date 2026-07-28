function y = medfilt1(x,n,varargin)
% MEDFILT1   One-dimensional median filtering
%
%    y=medfilt1(x,n)
%
%    Apply an order n one-dimensional median filter to the signal x.

% $Id: medfilt1.m 50 2004-12-10 12:42:40Z mairas $

Y = medfilt1(x.s,n,varargin);
y = signal(Y,x.time);
