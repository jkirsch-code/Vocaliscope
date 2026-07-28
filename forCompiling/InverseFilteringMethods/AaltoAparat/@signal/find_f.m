function [f]=find_f(x,varargin)
% FIND_F  Find fundamental frequency and harmonics
%
%    F=FIND_F(X)
%
%    Find fundamental frequency and harmonics.

% $Id: find_f.m 106 2006-02-13 12:32:11Z mairas $

f0 = -1;
if nargin > 2
    if strcmp(varargin{1},'F0')
        f0 = varargin{2};
    end
end

lx = len(x);
fftsize = 2^(floor(log(lx)/log(2))+1);

% get frequency response 

X=fft(x,fftsize);
Xabs=abs(X);

% get f0

if f0 == -1
    f0 = find_f0(x);
end

% check F0
if f0 == 0
    % no F0 found - return with null
    f = [];
    return
end

% get N (vector of harmonics to get)

N = 1:floor((x.time.fs/2)/f0);

% find local peaks

f_N=N;  % initialise to the final size
for i=N
  f_N(i) = localmax(Xabs,f0,i);
end

f=[f_N x.time.fs-fliplr(f_N)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=localmax(Xabs,f0,N)
% LOCALMAX Find a largest spectral peak around N*f0
%   F=LOCALMAX(XABS,FX,F0,N) returns the frequency, at which XABS
%   gains its largest value. XABS is the absolute magnitude
%   spectrum, FX are the corresponding frequency points, F0 is the
%   assumed fundamental frequency and N is the order of harmonics.

fmin=(N-0.5)*f0;
fmax=(N+0.5)*f0;

Imin=at(Xabs,fmin);
Imax=at(Xabs,fmax);

[foo,I]=max(Xabs(Imin:Imax));

f = Xabs.frequency.f(Imin-1+I);
