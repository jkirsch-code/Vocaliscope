function y = real(x)

% $Id: real.m 3 2004-02-04 12:57:04Z mairas $

y = spectrum(real(x.s),x.frequency);
