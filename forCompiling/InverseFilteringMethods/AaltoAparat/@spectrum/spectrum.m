function y = spectrum(s,fdef)

% $Id: spectrum.m 31 2004-07-28 10:46:46Z mairas $

y.frequency = [];
y.s = s(:).'; % make the signal always a row vector
y.fs = [];

if isa(fdef,'frequency')
  y.frequency = fdef;
  y.fs = y.frequency.fs;
elseif length(fdef)>1
  y.frequency = frequency(fdef);
  y.fs = y.frequency.fs;
else
  y.fs = fdef;
  y.frequency = frequency(0,length(y.s),y.fs);
end

y = class(y,'spectrum');
