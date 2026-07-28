function t = teager(x,n)
% function t = teager(x,n)
% The Teager-Kaiser energy operator n'th order approximation. Omission of n
% sets n=0

if nargin == 1
    n = 0;
end

if n == 0
    if isobject(x)
        t = x.s(2:end-1).^2 - x.s(1:end-2).*x.s(3:end);
        tim = x.time;
        tim = set(tim, 'num', tim.num-2, 'begin', tim.begin+(1./tim.fs));
        t = signal(t,tim);
    else
        t = diff(x(2:end)).^2 - diff(diff(x)).*x(2:end-1);
    end
elseif 2*floor(n/2) == n
    xd = deriv(x,1,n);
    xdd = deriv(xd,1,n);
    t = xd.s((1+n/2):end-n/2).^2 - xdd.*x.s((1+n):end-n);
%    t = xd.s^2 - xdd.*x.s;
else
    error('Odd orders other than n=1 not currently supported');
end