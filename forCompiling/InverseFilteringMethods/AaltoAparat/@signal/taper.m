function y = taper(x,t,varargin)
% TAPER   Taper off the ends of a signal using half-hanning windows
%
%    Y=TAPER(X,T)
%
%    Taper signal X using a half-hanning window of length T. That
%    is, the T first and last seconds of the signal are windowed
%    using a half-hanning window, while the remaining portion of
%    the signal is kept intact.
%
%    Y=TAPER(X,T,'begin')
%    Y=TAPER(X,T,'end')
%
%    Taper only the beginning or end of the signal, respectively.

% $Id: taper.m 53 2005-01-05 11:17:56Z mairas $

ends = 'both';

if length(varargin)>0
  ends = varargin{1};
end

y = x;

han = hanning(floor(2*t*x.time.fs));

if strcmp(ends,'both') || strcmp(ends,'begin')
  taperbeg = han(1:ceil(end/2))';
  y.s(1:length(taperbeg)) = y.s(1:length(taperbeg)) .* taperbeg;
end

if strcmp(ends,'both') || strcmp(ends,'end')
  taperend = han(floor(end/2+1):end)';
  y.s(end-length(taperend)+1:end) = y.s(end-length(taperend)+1:end).*taperend;
end
