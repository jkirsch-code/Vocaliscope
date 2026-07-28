function tf = islinphase(b,a)
% ISLINPHASE  True for a linear phase filter.
%
% ISLINPHASE(B,A) may be used to test whether B,A form a linear
% phase filter.

% $Id: islinphase.m 3 2004-02-04 12:57:04Z mairas $

tf = 0;

% IIR filters are never linear phase
if length(a)==1
  B = reshape(b,[],1);
  if all(B == flipud(B)) || all(B == -flipud(B))
    tf = 1;
  end
end
