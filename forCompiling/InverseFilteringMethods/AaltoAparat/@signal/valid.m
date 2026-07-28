function s_v = valid(s)
% VALID  Return the valid part of the signal.
%
% S_V = VALID(S)
%
% VALID returns the part of the signal that is valid, i.e. that is
% not affected by initial transients.

% $Id: valid.m 3 2004-02-04 12:57:04Z mairas $

s_ = s.s;
t_ = s.time;
if s.valid(1)==Inf
  warning('Region of validity not defined.');
  s_v = s;
else
  t1 = s.time(s.valid(1));
  if length(s.valid)>1
    t2 = s.time(s.valid(2));
  else
    t2 = s.time(end);
  end
  s_v = trim(s,t1,t2);
end
