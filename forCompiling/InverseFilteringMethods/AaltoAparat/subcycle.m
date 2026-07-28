function A = subcycle_new(flow, dflow, f0, fs)
% function A = subcycle_new(flow, dflow, f0, fs)
% Brute-force sub-cycle search

% f0 cycle length
T = round(fs/f0);

% max sub-cycle length
T2 = round(fs*.5/f0);

% calculate slope at each point
slopelist = diff(dflow)./diff(flow);

% search through all points
pp = [];
for k=1:length(flow)-2
    % set window ahead
    ix = (k+2):(min([k+T2; length(flow)-1]));
    
    % search for crossing in window ahead
    crossings_flow = (dflow(ix)-dflow(k)+slopelist(k)*flow(k)-slopelist(ix).*flow(ix))./(slopelist(k)-slopelist(ix));
    
    % find crossings that are between our points
    cix1 = find(crossings_flow < max(flow(k+(0:1))));
    cix2 = cix1(find(crossings_flow(cix1) > min(flow(k+(0:1)))));
    cix3 = cix2(find(crossings_flow(cix2)-max([flow(ix(cix2)); flow(ix(cix2)+1)]) < 0));
    cix4 = cix3(find(crossings_flow(cix3)-min([flow(ix(cix3)); flow(ix(cix3)+1)]) > 0));
    
    % store result
    pp = [pp; k*ones(length(cix4(:)),1) ix(cix4(:))'];
    
end

% calculate distances between consecutive points on trajectory
distvec = sqrt(sum(diff([flow', dflow']).^2')');

% calculate circumference for each point
A = []; % make sure we return at least an empty vector
for k=1:size(pp,1)
    % the sum of the length of each step in subcycle is the circumference
    % length
    A(k) = sum(distvec(pp(k,1):pp(k,2)));
end

% normalise with length of F0 cycle
meancirc = sum(distvec)*T/length(distvec);
A = A/meancirc;

