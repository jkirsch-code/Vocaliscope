
%A simple function that normalizes its input
function ynorm=kanon(y);
%if isempty(find(abs(y)>1))==0
ynorm=y/max(abs(y(find(y~=Inf))));
%else
   % ynorm=y;
%end
