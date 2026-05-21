function [Sampentot,SampenTimeVector] = sampeEnFDaLaSelamtzis(signal,fs,freqrange,sex,doPlot)

import FromSelamtzisCyclebasedSampEn.*
signal=signal(:);

egg=kanon(signal');
egg=hpfiltegg(egg,fs);
t=taxis(egg,fs);


%Detects the cycles and calculates the DFT per Cycle
[FourierDescriptorSpectrum,Cycle,CycleV,CycleTime,CycleIndices,cycleBorderIdx]=CycleDetection(egg,egg,fs,'n',freqrange); 
%usage: CycleDetection(egg,voice,fs,'n'); but in this case there was no voice signal

%Concatenates amplitudes and phases per cycle, calculates SampEn
[Sampentot,HarmAmp,HarmPhas,SampenTimeVector,~,~]=SampenAndFDs(1,3,2,{FourierDescriptorSpectrum},{Cycle},{CycleTime},{egg},fs,'n',sex);

if doPlot
    figure;
    plot(t,egg,'r');
    hold on;
    plot(SampenTimeVector,Sampentot,'linewidth',2,'Color','b');
    xline(t(cycleBorderIdx),'k');
    legend('source signal','Sample Entropy','Cycle borders');
end






end