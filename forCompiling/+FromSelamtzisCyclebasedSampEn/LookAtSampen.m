
function [t,dene]=LookAtSampen(wsize,signal,overlap,r);
%This function calculates the Sample Entropy of a signal given the window
%size, the signal, the amount of overlap between windows and the
%matching tolerance r.
%Usage:
%[t,SampleEntropy]=LookAtSampen(WindowSize,Signal,Overlap);

import FromSelamtzisCyclebasedSampEn.*
enestim=[];

[~,t,Nwin]=sliwind(signal,wsize,1,overlap);

%an=1;
m=1;

Nwin=length(t);
    
for m=1:Nwin
    [an,t]=sliwind(signal,wsize,m,overlap);
    [enestim(:,m),A,B]=sampenc(an,1,r);   %r is the matching tolerance
    %yenestim(:,m)=sampen2(1,r,an,1);
    %enestim(:,m)=sampleEntropy(an,1,r,1);
end

dene=enestim;