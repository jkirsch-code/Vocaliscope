function t = maxtime(A)
% MAXTIME  Find the time location of the maximum value of the  signal.
%
%    T = MAXTIME(A)
%
%    T is the position, in which signal A gains its maximum value.

% $Id: maxtime.m 31 2004-07-28 10:46:46Z mairas $


t = A.time.t(len(A));
