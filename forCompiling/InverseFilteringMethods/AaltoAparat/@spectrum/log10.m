function y = log10(x)

% $Id: log10.m 3 2004-02-04 12:57:04Z mairas $

y = spectrum(log10(x.s),x.frequency);
