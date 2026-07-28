function varargout = semilogx(s,varargin)

% note that the implementation of plot is VERY incomplete.

% $Id: semilogx.m 3 2004-02-04 12:57:04Z mairas $

h = semilogx(s.frequency.f,s.s,varargin{:});
if nargout
  varargout{1} = h;
end
