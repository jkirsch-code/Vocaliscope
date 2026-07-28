function t=crossings(x,lvl,dir)
% CROSSINGS Time instants of signal level crossings.
%    T=CROSSINGS(X,LVL,DIR)
%    T=CROSSINGS(X,LVL)
%    T=CROSSINGS(X)
%    CROSSINGS returns the time instants when signal X
%    crosses level LVL (by default, zero). If DIR is set to 1, look
%    for positive zero crossings. If DIR is -1, negative zero
%    crossings are sought for. DIR value of zero returns either.

% This function was inspired by a one-liner zero-crossing detection
% statement by Tom Bäckström.

% $Id: crossings.m 79 2005-08-15 10:33:39Z mairas $

if nargin==1
  lvl=0;
  dir=0;
elseif nargin==2
  dir=0;
end

idx = crossing_idx(x.s,lvl,dir);

% interpolate between the adjacent samples to get a more precise
% time estimate
t=inv_interpolate(x,lvl,idx);



%%%%
function t_i=inv_interpolate(x,lvl,idx)

I = idx;

t_i=zeros(1,length(idx));
for i=1:length(idx)
  imin=I(i)-1;
  imax=I(i);
  if imin<1
    imin=1;
    imax=2;
  end
  ts=x.time.t(imin:imax);
  ys=x.s(imin:imax);
  t_i(i)=(lvl-ys(1))*(ts(2)-ts(1))/(ys(2)-ys(1))+ts(1);
end


function idx=crossing_idx(x,lvl,dir)

if dir>0
  idx=find(diff((x-lvl)>0)>0)+1;
elseif dir<0
  idx=find(diff((x-lvl)>=0)<0)+1;
else
  idx=unique([ find(diff((x-lvl)>0)>0)+1 ...
               find(diff((x-lvl)>=0)<0)+1 ]);
end

