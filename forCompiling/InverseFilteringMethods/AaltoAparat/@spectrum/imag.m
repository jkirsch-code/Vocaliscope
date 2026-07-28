function y = imag(x)

% $Id: imag.m 31 2004-07-28 10:46:46Z mairas $

y = spectrum(imag(x.s),x.frequency);
