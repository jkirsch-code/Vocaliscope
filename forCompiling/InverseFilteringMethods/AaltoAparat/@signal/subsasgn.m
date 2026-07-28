function A = subsasgn(A,S,B)

% subscript assignment:
%
% A(S)=B

% $Id: subsasgn.m 80 2005-08-16 10:23:06Z mairas $

switch S(1).type
 case '.'
  switch S(1).subs
   case 't'
    if length(S)>1
      error('Individual time index manipulation not supported.');
    end
    tim = time(B);
    A=set(A,'time',tim);
   case 'time'
    if length(S)>1
      error('Individual time index manipulation not supported.');
    end
    A=set(A,'time',B);
   case 's'
    if length(S)>1
      s = A.s;
      s(S(2).subs{:})=B;
      A.s=s;
    else
      A.s=B;
    end
   case 'fs'
    A=set(A,'fs',B);
  end
 case '()'
  s = A.s;
  s(S(1).subs{:})=B;
  if length(s)>A.time.num
    t=set(A.time,'num',length(s));
    A=set(A,'time',t);
  end
  A.s=s;
end
