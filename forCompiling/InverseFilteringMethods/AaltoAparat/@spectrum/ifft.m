function y = ifft(X,varargin)

% $Id: ifft.m 121 2007-04-11 12:09:24Z mairas $

S = X.s;
f = X.frequency;

df=f.f(2)-f.f(1);
if f.begin~=0 | abs(f.f(len(f))-(X.fs-df))>1e-9
  error('Spectrum not defined at all points between 0 and fs.');
end

y_ = ifft(X.s,varargin{:});

y = signal(y_,X.fs);
