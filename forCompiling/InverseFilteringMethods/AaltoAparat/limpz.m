function l = limpz(b,a,varargin);
% LIMPZ  Calculate the effective length of the impulse response.
%
% L = LIMPZ(B,A)
% L = LIMPZ(B,A,P)  where P is the required ratio of energy to pass
% L = LIMPZ(B,A,P,N)  where N is the number of FFT bins in total
% energy calculation
%
% For FIR filters, LIMPZ always returns length(B)-1

% $Id: limpz.m 3 2004-02-04 12:57:04Z mairas $

if nargin>2
  p=varargin{1};
else
  p=0.98;
end
if nargin>3
  n=varargin{2};
else
  n=256;
end

if length(a)==1
  l = length(b)-1;
  return
end

h = freqz(b,a,n,'whole');

Etot = sum(abs(h).^2)/n;

if Etot==Inf
  l=Inf;
  return
end

imp_head = zeros(1,20); imp_head(1)=1;
imp_tail = zeros(1,20);

[y,zf] = filter(b,a,imp_head);

Eprev=-1;
E=0;
l = 0;
done=0;

while ~done
  for i=1:length(y)
    l=l+1;
    Eprev=E;
    E=E+y(i).^2;
    if E>p*Etot
      done = 1;
      break;
    end
  end
  if l>10000
    done = 1;
  end
  [y,zf] = filter(b,a,imp_tail,zf);
end
