
clear all

%[signal,fs]=audioread('Wagner_Fal_i_aaEGG.wav');
%[signal,fs]=audioread('Export_pathubSlowGLissPatHub_E4_langsam_cr[1-79502].wav');
[signal,fs]=audioread('anotherEGGtest.wav');
%voice=kanon(signal(:,1))';
egg=kanon(signal');
egg=hpfiltegg(egg,fs);
t=taxis(egg,fs);


%Detects the cycles and calculates the DFT per Cycle
[FourierDescriptorSpectrum,Cycle,CycleV,CycleTime,CycleIndices]=CycleDetection(egg,egg,fs,'n'); 
%usage: CycleDetection(egg,voice,fs,'n'); but in this case there was no voice signal

%Concatenates amplitudes and phases per cycle, calculates SampEn
[Sampentot,HarmAmp,HarmPhas,SampenTimeVector,~,~]=SampenAndFDs(1,3,2,{FourierDescriptorSpectrum},{Cycle},{CycleTime},{egg},fs,'n');
figure;
plot(t,egg,'r')
hold on
plot(SampenTimeVector,Sampentot,'linewidth',2,'Color','b')

