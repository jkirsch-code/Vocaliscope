function d = dur(x)
% DUR  Duration of the signal, in time-units

% $Id: dur.m 53 2005-01-05 11:17:56Z mairas $

for i=1:length(x)
  d(i) = len(x(i))/x(i).time.fs;
end
