function y=extend(x)
% EXTEND Extend a spectrum object to cover the whole frequency range.

% $Id: extend.m 46 2004-08-26 11:48:36Z mairas $


% find out where the current spectrum points lie on the unit circle

begf = x.frequency.begin;
endf = x.frequency.f(len(x.frequency));

df = x.frequency.f(2)-x.frequency.f(1);

fn = x.fs/2;

loc=[];
if begf<fn
  loc(1)=1;
end
if endf>fn
  loc(2)=1;
end

% extend to zero

numdown = begf/df;

f=x.frequency;
s=x.s;
if ~loc(2)
  s=[zeros(1,numdown) s];
elseif loc(1) & loc(2)
%  f2beg = x.fs-begf+df;
%  nummir = (endf-f2beg+1)/df;
%  numzero = (x.fs-endf)/df;
%  s=[zeros(1,numzero) fliplr(conj(s((f2beg/df):(f2beg/df+nummir-1))))];
end


% NOT COMPLETED!!!