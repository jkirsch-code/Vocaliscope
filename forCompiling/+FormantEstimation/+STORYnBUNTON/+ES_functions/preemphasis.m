function b = preemphasis(a);

for n=1:length(a)-1
    b(n) = a(n+1)-0.97*a(n);
end

b = b(:);
