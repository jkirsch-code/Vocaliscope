function y = win(x,winfhandle,varargin)
% WIN  Window a signal using a given window.
%   WIN(X,FHND,VARARGIN) returns signal X windowed using the window
%   function given in handle FHND. Excess arguments are given to
%   the function handle.

% $Id: win.m 3 2004-02-04 12:57:04Z mairas $

w = feval(winfhandle,len(x),varargin{:});

y = w.*x;
