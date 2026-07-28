function y = deriv(x,n,l,varargin)
% DERIV(X) Calculate the approximate derivative of the signal.
% DERIV(X,N) n'th order approximation (default N=1)
% DERIV(X,N,L) l'th derivative (default L=1)

% $Id: deriv.m 120 2007-01-02 12:21:49Z mairas $

if nargin < 3
    if nargin < 2
        n = 1;
    end
    l = 1;
elseif length(n) == 0
    n = 1;
end

k = n/2;
s = dsinc(-k:k).*hanning(k*2+1)';
s = -s./(s*(0:n)');

y = conv(s,x.s);
y = y(1+ceil(n):floor(length(y)-n));
t = x.time;
t = set(t,'num', length(y), 'begin', t.begin+(k-floor(k))/t.fs);
y = signal(y,t);
y = y*y.time.fs;

if l > 1 % derivative recursion - not neat but it works
    y = deriv(y,n,l-1);
end


% Old version 
%y = diff(x,varargin{:});
%y = y*y.time.fs;




function y = dsinc(x)
% function y = dsinc(x)
% The sinc function derivative

i=find(x==0);
x(i)= 1;      
y = cos(pi*x)./(pi*x) - sin(pi*x)./((pi*x).^2);
y(i) = 0;
        
        

