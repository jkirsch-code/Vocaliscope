function B=subsref(A,S)

% $Id: subsref.m 93 2005-10-24 13:54:45Z bassus $

switch S(1).type
 case '.'
  switch S(1).subs
   case 't'
    if length(S)>1
      B=subsref(A.time.t,S(2:end));
    else
      B = A.time.t;
    end
   case 'time'
    if length(S)>1
      B=subsref(A.time,S(2:end));
    else
      B = A.time;
    end
   case 's'
    if length(S)>1
      B=subsref(A.s,S(2:end));
    else
      B = A.s;
    end
   case 'fs'
    B = A.time.fs;
   case 'valid'
    B = A.valid;
   case 'at'
    subs{1}=at(A.time,S(2).subs{1});
    B=subsref(A.s,struct('type','()','subs',{subs}));
  end
 case '()'
  % FIXME - This makes quite bold assumptions about the continuity of the
  % input vector
  if strcmp(S(1).subs, ':')
          B = A;
  else
          s = A.s;
          t = A.time;
          s = s(S.subs{1});
          t = t(S.subs{1});
          tim = time(struct('beg',t(1),'num',length(t),'fs',A.time.fs));
          B = signal(s,tim);
  end
end
