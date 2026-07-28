function I = at(x,f)
% AT  Return element index corresponding to a frequency value.
%
% I = AT(X,T)  Return element index I at frequency location f in spectrum
% object X.

% $Id: at.m 119 2006-09-26 12:28:25Z mairas $

%I = at(x.frequency.f,f);
I = round(x.frequency.num/x.frequency.fs*(f-x.frequency.begin))+1;