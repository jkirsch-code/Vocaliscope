function R = xcorr(A,varargin)

if isa(A,'signal') & (nargin==1 | ~isa(varargin{1},'signal'))
  fs = A.time.fs;
  [r,lags] = xcorr(A.s,varargin{:});
elseif ~isa(A,'signal') & isa(varargin{1},'signal')
  fs = varargin{1}.time.fs;
  [r,lags] = xcorr(A,varargin{1}.s,varargin{2:end});
else
  if A.fs ~= varargin{1}.time.fs
    error('Sampling frequencies do not match.');
  end
  fs = A.time.fs;
  [r,lags] = xcorr(A.s,varargin{1}.s,varargin{2:end});
end

R = signal(r,lags/fs);
