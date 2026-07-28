function B=subsref(A,S)

% $Id: subsref.m 119 2006-09-26 12:28:25Z mairas $

% if frequency is a vector, fix it
% what is this needed for - can't ever happen!
%if length(A.vec)
%  A = frequency(A.vec);
%end

switch S(1).type
case '.'
 switch S(1).subs
  case 'f'
   if length(S)>1
     %B_ = A.begin+A.fs/A.num*(0:A.num-1);
     %B = subsref(B_,S(2:end));
     B = A.begin+A.fs/A.num*(S(2:end).subs{:}-1);
   else
     B = A.begin+A.fs/A.num*(0:A.num-1);
   end
  case 'fs'
   B = A.fs;
  case 'begin'
   B = A.begin;
  case 'num'
   B = A.num;
  otherwise
   error(['Invalid property.'])
 end
case '()'
 k=S.subs{1};
 B = A.fs/A.num*(k-1);
end
