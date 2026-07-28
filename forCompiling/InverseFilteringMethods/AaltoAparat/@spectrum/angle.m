function y = angle(x)

% $Id: angle.m 88 2005-09-16 08:44:32Z mairas $

y = spectrum(angle(x.s),x.frequency);
