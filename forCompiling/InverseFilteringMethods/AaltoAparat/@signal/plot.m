function varargout = plot(varargin)
% PLOT   Linear plot.
%    PLOT(X) plots X versus time.
%
%    SIGNAL/PLOT works in a similar manner to basic PLOT, except
%    that only one argument for each vector to be plotted is
%    allowed. See PLOT for more details.

% $Id: plot.m 3 2004-02-04 12:57:04Z mairas $

args = {};
while length(varargin)
  first = varargin{1};
  varargin = varargin(2:end);
  if isa(first,'signal')
    args = {args{:} first.time.t first.s};
  else
    args = {args{:} first};
  end
end

h = plot(args{:});

if nargout
  varargout{1} = h;
end
