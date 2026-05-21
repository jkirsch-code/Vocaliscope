function [formants, heights, index] = formantid_XT(Sin,f,numformants,F0);
%formantid_XT.m
%B. Story
%02.28.15
%This function takes a magnitude spectrum and finds formant peaks
%Assumption is that Sin is some estimate of a freq response function
%f = frequency vector
%numformants = number of formants to find.

%Senv = 10.^(Sin/20);
Senv = Sin;



if(isempty(F0)==1)
    
    %--Find the peaks in the spectrum
    [tmpks, pks, index] = FindPeaksRaw(Senv,f,8);
else
    
    [ic,jc] = min(abs(f(:)-F0));
    jc = jc+15; %try to push it above the F0;
    [tmpks, pks, index] = FormantEstimation.STORYnBUNTON.ES_functions.FindPeaksRaw(Senv(jc:end),f(jc:end),8);
    index = index + jc;
end

%--Sort out the peaks to find the formants----
if(isempty(pks)==0)
    [i,j] = sort(pks(:),'descend');
    
    %--Add some protection for spectra with too few peaks--
    if(length(pks)>=numformants)
        fmts = tmpks(j(1:numformants));
        hts = pks(j(1:numformants));
    else
        fmts = tmpks(j);
        fmts(length(j)+1:numformants) = tmpks(end)+100;
        hts = pks(j);
        hts(length(j)+1:numformants) = pks(end);
    end
    %--Sort fmts from low to high frequency--
    [fmts,k] = sort(fmts,'ascend');
    formants = fmts;
    heights = hts(k);
else
    formants(1:numformants) = 0;
    heights(1:numformants) = 0;
end


