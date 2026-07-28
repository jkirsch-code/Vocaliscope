function f0 = find_f0_acorr(x)
% FIND_F0_ACORR  Find fundamental frequency using autocorrelation method
%
%    F0 = FIND_F0_ACORR(X)
%
%    Find the fundamental frequency of signal X using the
%    autocorrelation method.

% $Id: find_f0_acorr.m 3 2004-02-04 12:57:04Z mairas $


% maximum amplitude of the first minimum compared to r(0)
relmin=0.5;

% interpolation ratio
irat=16;

r=xcorr(x.s);
r_=r((length(r)+1)/2:length(r));
xr_=0:length(r_)-1;
r_i=interp(r_,irat);
xr_i=interp(xr_,irat);

% find the first local minimum
i=1;
% if the relmin condition was not used, an autocorrelation
% curve with small 'high-frequency ripple' would break the
% zero-lobe ignoring algorithm
while i<length(r_i) & (r_i(i)>r_i(i+1) || r_i(i)>relmin*r_i(1))
  i=i+1;
end
if i==length(r_i)
  i=i-1;
end

% find the maximum and calculate corresponding f0

[r0,C]=max(r_i(i:end));
t=xr_i(i+C-1);

f0=x.fs/t;
