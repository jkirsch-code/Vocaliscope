function y = trim(x,varargin)
% TRIM  Trim the signal to a defined time range.
%
%    Y = TRIM(X,T1,T2)  Trim signal X to the time range defined by T1 and T2.
%    Y = TRIM(X,S)      Trim signal X to the time range defined by  signal S.

% $Id: trim.m 99 2005-12-05 13:10:14Z mairas $

if nargin==2
  s=varargin{1};
  t1=s.time.begin;
  t2=s.time.end;
else
  t1=varargin{1};
  t2=varargin{2};
end

idx = at(x.time,[t1 t2]);
s=x.s(idx(1):idx(2));

t=trim(x.time,t1,t2);

y=signal(s,t);

