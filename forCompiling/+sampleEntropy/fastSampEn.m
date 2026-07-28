function [SaEn ,Phi, Phi1] = fastSampEn(sig,dim,stdPercentage)

%  Filippo (2014). Fast Sample Entropy - saenkd(dim ,r ,sig ) (https://www.mathworks.com/matlabcentral/fileexchange/48574-fast-sample-entropy-saenkd-dim-r-sig), MATLAB Central File Exchange. Abgerufen 4. Juni 2025. 
%
% [SaEn, Phi, Phi1] = saen_range(dim,r,sig)
%
%
% SAMPLE ENTROPY
% computed with the kdtree method.
%
% This code creates and uses a kdtree to solve an orthogonal range
% problem, as proposed by [*1] and [*2].
% The kdtree is the default search method when the number of
% columns of the space matirx X, is not greater than 10.
% Otherwise, the default is 'exhaustive', that is:
% the distances from all points to each point are
% computed to find nearest neighbors.
%
% INPUTS :
%
% dim : is equal to m. Entropy will be compute for dim and
% dim + 1 (or m and m + 1, embedded dimenions)
% r : tolerance in the search for matches*, typically set as :
%     0.2*std(sig)
% sig: signal of which one wants to compute the Entropy value.
%
% OUTPUTS :
%
% SaEn: Sample Entropy.
% Phi: matches count vector for dim (also known as n_i_m), the number
% of points inside the i-th box, in the m space
% Phi1: matches count vector for dim+1 (also known as n_i_m+1),
% the number of points in the m+1 space
%
% REFERENCES :
%
% [1] : "COMPUTING MULTISCALE ENTROPY WITH ORTHOGONAL RANGE SEARCH" -
% Yu-Hsiang Pan et al., 2011
%
% [2] : "Fast computation of sample entropy and approximate entropy in
% biomedicine" - Yu-Hsiang Pan et al.,2011
if (dim+1)<=10
   method = 'kdtree';
else
    method = 'exhaustive';
end

r=stdPercentage*std(sig);
    
N = length(sig);
Phi = ones(1,N-dim+1);
Phi1 = zeros(1,N-dim+2);
if size(sig,1)==1
    sig=sig';
end
%MAIN
    for m = dim : dim + 1
            X = zeros( N - m + 1 , m );
            for i = 1 : m
                ids = i : N  - m + i;
                X( : , i ) = ids;
            end
            sig_X = sig( X ); %catch the elements in the signal
            Phi_m = rangesearch( sig_X, sig_X, r, 'NSMethod', method, 'Distance', 'chebychev');
            for i = 1 : N - m + 1
                C_s = numel( Phi_m{ i } ) - 1; %substract self-match
                switch m
                    case dim
                        Phi( i ) = C_s;
                    case dim + 1
                        Phi1( i ) = C_s;
                end  
            end            
    end
    
    phiSum=sum(Phi);
    phi1Sum=sum(Phi1);

    if phiSum == 0 || phi1Sum == 0
        SaEn=0;
    else
        SaEn = log( phiSum / phi1Sum );
    end
end