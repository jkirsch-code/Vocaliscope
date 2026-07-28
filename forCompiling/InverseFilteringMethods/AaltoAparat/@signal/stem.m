function varargout = stem(varargin)
% STEM   Plot discrete sequence data.
%    PLOT(X) plots X versus time, in discrete steps.
%
%    SIGNAL/STEM works in a similar manner to basic STEM, except
%    that only one argument for each vector to be plotted is
%    allowed. See STEM for more details.

% $Id: stem.m 60 2005-01-07 08:29:38Z mairas $

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

h = stem(args{:});

if nargout
  varargout{1} = h;
end
