function gamma=atog(a)
% function gamma=gtoa(a)
% from Hayes, gamma is the reflection coefficent vector, a the corresponding
% LPC filter

a=a(:);
p=length(a);
if p < 2
    gamma = [];
    return;
end
a=a(2:p)/a(1);
gamma(p-1)=a(p-1);
for j=p-1:-1:2;
  a=(a(1:j-1)-gamma(j)*flipud(conj(a(1:j-1)))) ./ (1-abs(gamma(j)).^2);
  gamma(j-1)=a(j-1);
end;
