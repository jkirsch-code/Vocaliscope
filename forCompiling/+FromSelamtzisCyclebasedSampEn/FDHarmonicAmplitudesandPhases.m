

function [HarmAmp,HarmPhas,SmallCyclesToExclude,HigherContent]=FDHarmonicAmplitudesandPhases(NumberOfHarmonics,fdspectrum,cycletime,time,signal,fs,p)

%cf{1} is the DC and then harmonics 1, 2, ...
%This function plots the amplitudes and phases of the first n Fourier Descriptor harmonics
%given the FD spectral magnitudes and phases for each cycle of a cycle-separated signal.
%
%Usage:
%[HarmonicAmplitudes,HarmonicPhases]=plotposfdescr(NumberOfHarmonics, FDMagnitude,FDPhase,CycleTime,Time)
%CycleTime is a variable that is computed by the CycleDetection function in order to transform cycles into seconds.
%If the Time variable is 's' then time in the plots is displayed in seconds, otherwise in cycles.
%noh is the number of harmonics to be plotted.

%% Calculate the FD evolution with time
fdmagnitude=cellfun(@abs,(fdspectrum),'UniformOutput',0);
fdphase=cellfun(@angle,(fdspectrum),'UniformOutput',0);

NumberofCycles=length(fdmagnitude);  %The number of cycles

A=[];

B=[];


[c{1:NumberOfHarmonics}]=deal([]);  %Initialization of the c cell that has the F descriptors
[cph{1:NumberOfHarmonics}]=deal([]);

SmallCyclesToExclude=[];

for m=1:NumberofCycles                          %Loop running for all cycles
    
    C=[];
    
    

    if length(fdmagnitude{m}) > NumberOfHarmonics
        
        bb=[1:NumberOfHarmonics];               %The harmonics to select from the total DFT
        
        %One can also normalize to the first harmonic
        %A=[kanon(fdmagnitude{m}(bb))];
        
        A=[(fdmagnitude{m}(bb))];
        Aph=[(fdphase{m}(bb))];
        %New snippet of code 08/03/2016 to include the higher frequency
        %content of the EGG up to 7000 Hz 
        UpperLimit=ceil(7000/(fs/length(fdmagnitude{m})));
        HC(m)=sqrt(sum(fdmagnitude{m}(2:UpperLimit).^2)-sum(fdmagnitude{m}(2:NumberOfHarmonics).^2))./fdmagnitude{m}(2); %normalized to the fundamental
        
        
        C=[A];
        Cph=[Aph];
        
        for n=1:length(C)             %Make a vector for the amplitude of the harmonic, of each cycle
            c{n}=[c{n} C(n)];         %n is the harmonic index and we concatenate the amplitudes, for each cycle.
            cph{n}=[cph{n} Cph(n)];
        end
        
        
    else
        SmallCyclesToExclude=[SmallCyclesToExclude m];
    end
    
end



cycx=1:length(c{1});                %The increasing number of cycle

length(cycx);

basl=[1:NumberOfHarmonics];                         %A baseline

%ratios=10*log10(c{2}./c{4});    %Second over first - Remember that c{1} is the DC!

if time=='s'
    cycx=cycletime(:,2);
end

HarmAmp=c;
HarmPhas=cph;
HigherContent=HC;

%% Figure generation
if p=='y'    
    
    % Figure for the magnitudes
    figure
    
    set(gcf,'Position',[200 200 2*560 2*420]) ; clf
    
    subplot(3,2,1) ;  aspect(signal,fs,0.03,2^10,0.95,'n') ;  ylim([0 5000]) ;
    title('Spectrogram')
    subplot(3,2,2) ; title('Magnitudes')
%      sub_pos = get(gca,'position'); % get subplot axis position
%  set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height

    col=colormap(hsv(NumberOfHarmonics));  %Just making a color series for each harmonic %col = get(0,'DefaultAxesColorOrder');
    
    hold on
    leg=[];
    
    for m=2:NumberOfHarmonics
        figure(gcf)
        plot(cycx,10*log10(abs((c{m}))),'color',col(m-1,:),'linewidth',2)
        leg{m-1}=[num2str(bb(m-1))];
    end
    
    set(gca,'Ydir','normal')
    clear legh objh outh outm
    [legh,objh,outh,outm] = legend(leg,'Location','Southeast');
    set(objh,'LineWidth',2)
    
    ylabel('dB')
    hold off
    
    %% Figure for the phases
    subplot(3,2,4)
%      sub_pos = get(gca,'position'); % get subplot axis position
%  set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height

    title('Phases unwrapped')
    hold on
    leg=[];
    
    for m=2:NumberOfHarmonics
        figure(gcf)
        
        %Apparently this strph is just for the plotting purposes... The
        %extracted phase, is just the angle! No unwrapping or anything.
        
        %strph=cph{m};
        
        strph=detrend(unwrap(cph{m}));
        %strph(strph>0)=mod(strph(strph>0),2*pi);
        %strph(strph<0)=mod(strph(strph<0),-2*pi);
        
        %strph=unwrap(cph{m});
        %strph(strph<-2*pi)=strph(strph<-2*pi)+2*pi
        
        %Somehow compressing the variation...
        %strph=mod(unwrap(strph),2*pi);         %The last used thing
        %strph=pi*strph/max(abs(strph));
        %strph=mod(strph,2*pi);
        
        plot(cycx,strph,'marker','.','markersize',2,'color',col(m-1,:),'linestyle','none')
        leg{m-1}=[num2str(bb(m-1))];
    end
    
    %% Figure parameters
    set(gca,'Ydir','normal')  
    clear legh objh outh outm
    [legh,objh,outh,outm] = legend(leg,'Location','Southeast');
    set(objh,'LineWidth',2)
    ylabel('Radians')
    %ylim([-pi pi])
    if time=='s'
        xlabel('Time (sec)')
    end
    
    hold off
    
    ax= flipud(findall(gcf,'type','axes'));
    
    if time=='s'
        linkaxes(ax(1:end),'x')
    end
    
end


% for m=1:length(cph)
%     cphf{m}=unwrap(cphf{m});
% end

%Log of changes 29/1/2013:

%Removed the baseline from the plot of magnitudes and phases of the FDs
%Introduced a dB scale
%The question of unwrapping remains: whether a stable state that seems
%different in the phases could be the same if we do modulo pi.

% sub_pos = get(gca,'position'); % get subplot axis position
% set(gca,'position',sub_pos.*[1 1 1.2 1.2]) % stretch its width and height