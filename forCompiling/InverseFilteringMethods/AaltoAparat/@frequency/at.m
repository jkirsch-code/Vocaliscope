function I = at(x,f)
% AT  Return element index corresponding to a frequency value.
%
% I = AT(X,F)  Return element index I at frequency location F in frequency
% object X.

% $Id: at.m 3 2004-02-04 12:57:04Z mairas $

if length(x.vec)>0
  I = at(x.vec,f);
else
  I = zeros(size(f));
  for i=1:length(f)
    I(i) = mod(round(x.num/x.fs*f(i)),x.num)+1;
  end
end
