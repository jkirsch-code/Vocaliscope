function y = flip(x)
% FLIP  Flip signal
%    Y = FLIP(X) returns the signal X backwards at the same position in
%    time

% $Id: flip.m 101 2005-12-15 16:19:29Z bassus $

y = signal(fliplr(x.s),x.time);
