function [glf,a]=makearfit(gs)

q = glottaltimeparams(gs);

for j=1:length(q)-1

    g = trim(gs,q(j).t_min,q(j+1).t_min);
    s = g.s(:);
    m = min(s);
    s = s-m;
    
    a{j} = real(lpc(s,3));
    
    x = filter(a{j},1,g);

    [foo, ix] = max(x(10:end));
    ix = ix+9;

    y = zeros(size(x.s(:)));
    y(ix) = x.s(ix);

    glf{j} = x;
    glf{j}.s = flipud(filter(1,a{j},flipud(y)));
    
    c = (max(g.s)-m)/max(glf{j}.s);
    
    glf{j} = m+(glf{j}*c);
    
end
