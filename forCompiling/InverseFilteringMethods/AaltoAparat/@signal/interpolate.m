function y = interpolate(x,t)
% INTERPOLATE Return the linearily interpolated element value
% corresponding to a time value.
%
% Y = INTERPOLATE(X,T)  Return element value Y at time location T in signal
% object X.

% $Id: interpolate.m 63 2005-01-10 14:20:08Z mairas $

I = ceil((t-x.time.begin)*x.time.fs+1);

y=zeros(1,length(I));
for i=1:length(I)
  imin=I(i)-1;
  imax=I(i);
  if imin<1
    imin=1;
    imax=2;
  end
  ts=x.time.t(imin:imax);
  ys=x.s(imin:imax);
  tinv=[-1 1;1 0];
  p=ys*tinv;
  y(i)=polyval(p,x.time.fs*(t(i)-ts(1)));
end
