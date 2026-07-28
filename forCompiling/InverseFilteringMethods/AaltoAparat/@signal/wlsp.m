function [a] = wlsp(s,m,L)
% function [a] = wlsp(s,m,L)
%
%    Weighted-Sum Line Spectrum Pair (WLSP) filter generation.
%
%    Input variables:
%       s    - signal
%       m    - model order
%       L    - number of autocorrelation values (above m) to use 
%              in model matching (default: 2*m)
%    Output variable:
%       a    - filter coefficients for WLSP
%
%    This function is an appendix to the article "All-pole Modeling 
%    Technique Based on the Weighted Sum of the LSP Polynomials",
%    presented at ICASSP'02. 
%
%    See also: LSPFIT, LSP, LSPX

% Tom Bäckström / 11.10.2001
% copied to matsig by Tom Bäckström 29.6.2005

% check optional input variables
if nargin < 3
  L = 2*m;
end;

% calculate LPC coefficients for model order m-1

al = real(lpc(s,m-1));


% calculate WLSP coefficients for model order m

a = lspfit(al,s.s(:),L);


return

function [ax,lambda] = lspfit(a,wa,varargin)
% function [ax,lambda] = lspfit(a,wa,args)
%    Expand filter 'a' through interpolation of the symmetric and 
%    antisymmetric LSP polynomials with optimal weighting 'lambda',
%    that is, optimise 'lambda' (in function 'lspx') through golden
%    section -search, by iterative comparisons of absolute difference 
%    of autocorrelations of the original signal and the impulse 
%    response of the expanded predictor.
%    Function returns the optimal LSP expanded filter 'ax' and the 
%    optimal 'lambda'.
%
%    This function is an appendix to the article "All-pole Modeling 
%    Technique Based on the Weighted Sum of the LSP Polynomials",
%    presented at ICASSP'02. However, the golden section -search
%    was not discussed in that paper, but more information is
%    available in
%       Bazaraa, Sherali and Shetty, "Nonlinear Programming - Theory
%       and Algorithms", Wiley, 1993.
%
%    See also: WLSP, LSP, LSPX

% Tom Bäckström / 11.10.2001
% copied to matsig by Tom Bäckström 29.6.2005

% check optinal input variables

args = varargin;
argix = 1;

tresh = 0.00001;
L = 2*length(a);

L = args{argix};
argix = argix + 1;
  
while(length(args)-argix > 0)
  switch args{argix}
    case 'threshold',	
      tresh = args{argix+1};
      argix = argix + 2;
    otherwise	
      error(sprintf('Unknown argument ''%s''',args{argix}));
  end  
end


% golden section ratio

gold = sqrt(5/4)-0.5;


% autocorrelation vector

R = xcorr(wa,L+length(a)+1,'coeff');
R = R(1+L+length(a)+(0:L+length(a)+1));


% construct the four points required for golden section
% search (left edge, left middle, right middle and right edge), 
% and set initial values

S = struct('value',0,'lambda',0);
ledge = S;
redge = S;
lmid = S;
rmid = S;
ledge.lambda = 0;
ledge.value = lspdiff(lspx(a,0),R,L);
redge.lambda = 1;
redge.value = lspdiff(lspx(a,1),R,L);
rmid.lambda = gold;
rmid.value = lspdiff(lspx(a,rmid.lambda),R,L);
lmid.lambda = 1-gold;
lmid.value = lspdiff(lspx(a,lmid.lambda),R,L);



% perform actual golden section -search

while(1)
  
  % check if left triplet (left edge, left mid and right mid)
  % contains minimum
  
  if lmid.value < rmid.value
    
    % reset three of the four points to left triplet, and
    % calculate new value for the missing point
    
    redge.value = rmid.value; 
    redge.lambda = rmid.lambda;
    
    rmid.value = lmid.value; 
    rmid.lambda = lmid.lambda;
    
    lmid.lambda = redge.lambda - gold*(redge.lambda - ledge.lambda);
    lmid.value = lspdiff(lspx(a,lmid.lambda),R,L);

  else
    
    % reset three of the four points to right triplet, and
    % calculate new value for the missing point

    ledge.value = lmid.value; 
    ledge.lambda = lmid.lambda;
    
    lmid.value = rmid.value; 
    lmid.lambda = rmid.lambda;
    
    rmid.lambda = ledge.lambda + gold*(redge.lambda - ledge.lambda);
    rmid.value = lspdiff(lspx(a,rmid.lambda),R,L);
    
  end

  % check for end conditions
  
  if rmid.lambda - lmid.lambda < tresh
    
    % value of sufficient accuracy has been found -> exit
    
    %disp('Accuracy threshold limit reached');
    break;
    
  elseif (redge.value < rmid.value) | (ledge.value < lmid.value)
    
    % objective function seems to be non-convex (this sometimes
    % happens due to noise in autocorrelation vector)
    
    %disp('Noise level reached'); 
    break;
  end
end

% choose minimum of mid-points as global minimum
% and return associated lambda and coefficient vector

if lmid.value < rmid.value
  lambda = lmid.lambda;
  ax = lspx(a,lambda);
else  
  lambda = rmid.lambda;
  ax = lspx(a,lambda);
end;


function ax = lspx(a,lambda)
% function ax = lspx(a,lambda)
%    Expand filter 'a' through interpolation of the symmetric and 
%    antisymmetric LSP polynomials with weighting 'lambda', that is,
%    ax = lambda * pa + (1-lambda) * qa, where 'pa' and 'qa' are the
%    symmetric and antisymmetric LSP polynomials, respectively.
%    Range of lambda is 0 < lambda < 1, which produce stable filters
%    (assuming original filter is stable), both limit values produce
%    filters with zeros on the unit circle, lambda values outside
%    range produce unstable filters and lambda at either infinity
%    produces the inverse filter.
%
%    This function is an appendix to the article "All-pole Modeling 
%    Technique Based on the Weighted Sum of the LSP Polynomials",
%    presented at ICASSP'02. 
%
%    See also: LSPFIT, LSP, LSPX

% Tom Bäckström / 11.10.2001
% copied to matsig by Tom Bäckström 29.6.2005

% Caluculate LSP polynomials
pa = [a(:); 0] + flipud([a(:); 0]);
qa = [a(:); 0] - flipud([a(:); 0]);

% Calculate the extended, or interpolated polynomial
ax = lambda*pa' + (1-lambda)*qa';

return


function e = lspdiff(a,R,N)

Ra = xcorr(impz(1,a,10000),N+length(a),'coeff');
Ra = Ra(1+N+length(a)+(0:N+length(a)));

e = sum(abs(R(length(a):N+1+length(a))-Ra(length(a):N+1+length(a))));

