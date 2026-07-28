function B=subsref(A,S)

% $Id: subsref.m 47 2004-09-09 08:01:57Z mairas $

% launder time vectors
if length(A.vec)
  A = time(A.vec);
end

switch S(1).type
case '.'
 switch S(1).subs
  case 't'
   if length(S)>1
     B_ = A.beg+(0:A.num-1)/A.fs;
     B = subsref(B_,S(2:end));
   else
     B = A.beg+(0:A.num-1)/A.fs;
   end
  case 'fs'
   B = A.fs;
  case 'begin'
   B = A.beg;
  case 'end'
   B = A.beg+(A.num-1)/A.fs;
  case 'num'
   B = A.num;
  otherwise
   error(['Invalid property.'])
 end
case '()'
 k=S.subs{1};
 B = A.beg+(k-1)/A.fs;
end

