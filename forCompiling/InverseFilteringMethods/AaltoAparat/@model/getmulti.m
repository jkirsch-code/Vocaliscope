function d=getmulti(m,param,values)
%
%
% $Id$

origifopts = m.ifopts;

d = {};
for k=1:length(values)
  m.ifopts.(param) = values(k);
  m = ifsignal(m,1);
  d{end+1} = m.glottal_flow;
end

m.ifopts = origifopts;
