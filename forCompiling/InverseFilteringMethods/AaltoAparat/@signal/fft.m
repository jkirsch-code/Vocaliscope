function Y = fft(X,varargin)

% $Id: fft.m 53 2005-01-05 11:17:56Z mairas $

y = fft(X.s,varargin{:});

Y = spectrum(y,X.time.fs);

%warning('time data discarded');
