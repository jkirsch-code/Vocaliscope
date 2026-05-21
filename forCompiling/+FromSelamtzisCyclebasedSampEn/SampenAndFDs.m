
function [Sampentot,HarmAmp,HarmPhas,SampenTimeVector,SmallCycles,HigherContent]=SampenAndFDs(trial,howmany,sampenhowmany,fdspectrum,cycles,cyctime,signal,fs,plo,sex) %,breaktimes,breaktimes2)
import FromSelamtzisCyclebasedSampEn.*
%The function outputs the total SampEn, the FD harmonic amplitudes, FD harmonic phases and the SampEn time vector.
%It's designed for the transition database, thus it needs as input the
%following cells: Fourier Descriptor magnitudes, Fourier Descriptor phases, The EGG cycles, the CycleTime which contain the
%relevant information for all the transitions in the database. Look at
%Corpus_v.mat for the structure of these variables.

Sampentot=0;
decay=0.99;
averaging=1;
%w=1/averaging*ones(1,averaging);
w=1/averaging*blackman(averaging);

%Note: the version before 25/2/2013 2.49 was the one I did the corpus
%with.

%Note: 31/8/2013 - I'm deleting the code of the old histogram method from this file.
%This exists in NewHistoLoopDiY_old.m

%Make sure to have a common range for the phases of the harmonics.
%Think about the ranges of the magnitudes too.


%close all

M=trial;        %Number of the database trial that is to be plotted
t{M}=linspace(0,length(signal{M})/fs,length(signal{M}));


%signal=signal{M};
%sound(transVOICE{M},16000);

%This calculates the first 'howmany' Fourier Descriptors per period of the
%signal:

[HarmAmp HarmPhas SmallCycles HigherContent]=FDHarmonicAmplitudesandPhases(howmany+1,fdspectrum{M},cyctime{M},'s',signal{M},fs,plo);


%For tracking transitions it's much better to use just two harmonics,
%while for state detection it's probably more efficient to use more.

for N=1:sampenhowmany %1 to 'howmany'th harmonic or maybe just to 2 so that you check only based on the two first harmonics
    
    for p=1:2;  %One time for the amps and one for the phases
        
        yam=(HarmAmp{N+1}); %c{1} is the DC and {2} is the First harmonic
        
        % It's always a question what to do with the phase. Maybe a polar plot
        % would be better
        %yph=detrend(HarmPhas{N+1});
        %yph=unwrap(HarmPhas{N+1});
        %yph=yph/max(abs(yph));
        %yph=pi*yph;
        
        %     Think it's right
        yph=HarmPhas{N+1}/(N)/(2*pi);  %Dividing with the overtone number and with 2*pi
        %     yph(yph>0)=mod(yph(yph>0),2*pi);
        %     yph(yph<0)=mod(yph(yph<0),-2*pi);
        %
        y=[yam ; yph];          %yam=y(1,:) and yph=y(2,:)
        
        
    end
    
    %This is where the sensitivity for the FD Sampen analysis is adjusted.
    %The last argument of the function LookAtSampen is most critical for
    %how sensitive the entropy algorithm will be.
    %The values should depend on how many FDs you choose to use for the calculation of SampEn (since
    %higher harmonics have more variation - especially their phases)
    
    if strcmp(sex,'male')
        numberOfCycles=10;
    else
        numberOfCycles=20;
    end
    [td,SampenMag{N}]=LookAtSampen(numberOfCycles,(kanon((yam))),numberOfCycles-1,0.1);   %0.1/0.2 magni     %For females perhaps 20 cycles and 19 overlap
    [td,SampenPhas{N}]=LookAtSampen(numberOfCycles,yph,numberOfCycles-1,0.4);       %0.5  phases %4 fem
    
    %Be careful taking kanon, it might affect the entropy
    %calculation. It actually does, the amplitude range of the signal is
    %important in the sense that the matching tollerance scales with it.
    %so LookAtSampen(a,y,b,x)=LookAtSampen(a,y/M,b,x/M)
    
    %Separate normalization constants for phases and magnitudes
    PhasNormConst=fliplr(unique(sort(SampenPhas{N})));
    PhasNormConst=[PhasNormConst PhasNormConst];
    PhasNormConst=PhasNormConst(2);
    if PhasNormConst==0 | PhasNormConst==Inf
        PhasNormConst=1;
    end
    MagNormConst=fliplr(unique(sort(SampenMag{N})));
    MagNormConst=[MagNormConst MagNormConst];
    MagNormConst=MagNormConst(2);
    if MagNormConst==0 | MagNormConst==Inf
        MagNormConst=1;
    end
    
    Sampentot=Sampentot+(SampenPhas{N})./PhasNormConst+(SampenMag{N})/MagNormConst;
    
end

%Averaging. Currently w=[1] so this doesn't do anything
Sampentot=conv(Sampentot,w,'same');

%The limits 10:end-10 is to try to discard the starting and ending as we're not interested in these spikes
Sampentot(1:numberOfCycles)=0;
Sampentot(end-numberOfCycles+1:end)=0;

%Normalizing the total SampEn
TotNormConst=max(Sampentot(find(Sampentot~=Inf)));
if TotNormConst==0 | TotNormConst==Inf
    TotNormConst=1;
end
Sampentot=Sampentot/TotNormConst;

%To find the time correspondences between the cycletime and
%the time vector per 8cycle window.

tdisc=cyctime{M}(:,2); %This is the time correspondence between cycles and actual time

SampenTimeVector=tdisc(td);  %This selects the points of the windows

if plo=='y'
    figure(1)
    subplot(3,2,3)
    hold on
    
    %plot(cyctime{M}(:,2).',trydover,'k')
    
    %This bit is for plotting the annotations of Sten and Laura as well
    % stem(breaktimes{M},max(trydover)*ones(1,length(breaktimes{M})),'r')
    % hold on
    % stem(breaktimes2{M},max(trydover)*ones(1,length(breaktimes2{M})),'b')
    
    xlim([0 max(cyctime{M}(:,2))]);
    
    plot(t{M},0.2*signal{M}/max(signal{M})-1)
    
    %plot(t{M},mean(trydover)*ones(1,length(t{M})))
    
    %ylim([(mean(trydover)) 1.2*max(trydover)])
    % title(['FD ' foo ' ' num2str(N) ' and Differencegram'])
    title('Total SampEn, sum of all entropies of first four FD phases and magnitudes')
    
    figure(1)
    subplot(3,2,5)
    % sub_pos = get(gca,'position'); % get subplot axis position
    % set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height
    
    hold on
    col=colormap(hsv(howmany+1));  %Just making a color series for each harmonic
    leg=[];
    
    for m=1:sampenhowmany
        plot(tdisc(td),m-SampenMag{m}(1:length(td)),'color',col(m,:),'LineWidth',2)
        leg{m}=[num2str(m)];
    end
    clear legh objh outh outm
    [legh,objh,outh,outm] = legend(leg,'Location','Southeast');
    set(gca,'ydir','reverse')
    title('SampEn for the Magnitudes')
    
    subplot(3,2,6)
    %  sub_pos = get(gca,'position'); % get subplot axis position
    %  set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height
    hold on
    col=colormap(hsv(howmany+1));  %Just making a color series for each harmonic
    leg=[];
    
    for m=1:sampenhowmany
        plot(tdisc(td),m-SampenPhas{m}(1:length(td)),'color',col(m,:),'LineWidth',2)
        
        leg{m}=[num2str(m)];
    end
    clear legh objh outh outm
    [legh,objh,outh,outm] = legend(leg,'Location','Southeast');
    set(gca,'ydir','reverse')
    
    title('SampEn for the Phases')
    ax= flipud(findall(gcf,'type','axes'));
    linkaxes(ax(1:end),'x')
    
    subplot(3,2,1)
    %  sub_pos = get(gca,'position'); % get subplot axis position
    %  set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height
    
    colormap('default')
    
    subplot(3,2,3)
    
    hold on
    
    %[tt,samp]=LookAtSampen(500,signal{M},250,1);
    
    plot(SampenTimeVector,abs(Sampentot(1:length(SampenTimeVector))),'r')
    % sub_pos = get(gca,'position'); % get subplot axis position
    %  set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height
    figure(1)
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    ylim([-1.5 1.1])
    
end

% subplot(3,2,3)
% plot(t{M}(tt),abs([kanon(diff(samp)) 0]),'--c','LineWidth',2)
% samp