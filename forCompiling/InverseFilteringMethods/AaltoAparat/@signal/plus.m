function c = plus(a,b)

% overloading of operator +

% $Id: plus.m 53 2005-01-05 11:17:56Z mairas $

if isa(a,'signal') & ~isa(b,'signal')
  c = signal(a.s + b, a.time);
elseif ~isa(a,'signal') & isa(b,'signal')
  c = signal(a + b.s, b.time);
elseif isa(a,'signal') & isa(b,'signal')

  if a.time.fs ~= b.time.fs
    error('Sampling frequencies do not match.');
  end
  df = a.time.t(2)-a.time.t(1);
  if mod(b.time.t(1),df)-mod(a.time.t(1),df)>1e-7
    error('Sampling instants do not match.');
  end
  
  % arrange the signals so that b always begins later than a
  
  if b.time.begin<a.time.begin
    d = a;
    a = b;
    b = d;
  end
  
  % new time object
  t = time(a.time.begin,round((max(a.time.end,b.time.end)-a.time.begin)*a.time.fs+1),a.time.fs);
  
  if a.time.end>=b.time.begin
    % overlapping
    t2=b.time.begin;
    t3=min(a.time.end,b.time.end);
    c1=a.s(1:(at(a,t2)-1));
    c2=a.s(at(a,t2):at(a,t3)) ... 
       + b.s(at(b,t2):at(b,t3));
    if b.time.end>a.time.end
      c3=b.s((at(b,t3)+1):end);
    else
      c3=a.s((at(a,t3)+1):end);
    end
    c = signal([c1 c2 c3],t);
  else
    % not overlapping
    c1=a.s;
    c2=zeros(1,(b.time.begin-a.time.end)/df-1);
    c3=b.s;
    c = signal([c1 c2 c3],t);
  end
  
end

