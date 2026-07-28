function B=subsref(A,S)

% $Id: subsref.m 31 2004-07-28 10:46:46Z mairas $

switch S(1).type
  case '.'
    switch S(1).subs
      case 'f'
        if length(S)>1
          B=subsref(A.frequency.f,S(2:end));
        else
          B = A.frequency.f;
        end
      case 'frequency'
       if length(S)>1
	 B=subsref(A.frequency,S(2:end));
       else
	 B = A.frequency;
       end
      case 's'
        if length(S)>1
          B=subsref(A.s,S(2:end));
        else
          B = A.s;
        end
      case 'fs'
        B = A.fs;
      case 'at'
        subs{1}=at(A.frequency,S(2).subs{1});
        B=subsref(A.s,struct('type','()','subs',{subs}));
    end
  case '()'
    s = A.s;
    f = A.frequency;
    s = s(S.subs{1});
    f = f(S.subs{1});
    B = spectrum(s,f);
end

