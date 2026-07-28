function [an,e] = mvdr(x,m,varargin)
% MVDR Minimum Variance Distortionless Response model
% A = MVDR(X,P) finds the coefficients, A=[ 1 A(2) ... A(P+1) ],
% of an Nth order MVDR all-pole model filter
%
%    Xp(n) = -A(2)*X(n-1) - A(3)*X(n-2) - ... - A(P+1)*X(n-P)
%

% TB 13.8.2004
R = xcorr(x,m);
R = R.s;

Rm = toeplitz(R(1+m+(0:m)));
iRm = inv(Rm);

N = 2^10;
w = (0:(N-1))/N;
for k = 1:length(w)
    V(:,k) = exp(i*w(k)*pi*(0:m))';
end
for k = 1:length(w)
    P(k) = 1./(V(:,k)'*iRm*V(:,k));
end

R2 = real(fft([P fliplr(P(2:end))]));
Rm2 = toeplitz(R2(1+(0:m)));
iRm2 = inv(Rm2);
an = [1 zeros(1,m)]*iRm2;
an = an/an(1);
e = an*Rm2*an';
