function A = gtoarea(g)

% compute area function
A(1) = 1;
for k=1:length(g)
    A(1+k) = A(k)*(1+g(k))/(1-g(k));
end
