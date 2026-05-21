
function [FourierDescriptorSpectrum,Cycle,CycleV,CycleTime,CycleIndices,index]=CycleDetection(dataegg,datavoice,fs,p,freqrange);
DurPrev=0;
%An algorithm to separate a periodic signal in 2*pi cycles (not necessarily true periods (e.g. in diplophonias this just gives half of the vibration cycle)).
%Usage [FDspectraPhase,FDspectraMag,Cycles,CycleTime]=CycleDetection(data,datavoice,fs,p)
%
%Inputs: (DataEGG,DataVoice,Fs,Plotting variable)
%
%Outputs:  (Fourier Descriptor Spectra Phase, FD Spetra Magnitude, Cycles, CyclesVoice, CycleTime)
%
%Where p is 'y' or 'n' for plotting -in the making- each Cycle and its Fourier Descriptor spectrum.
%Cycles is a cell containing all the Cycles, and CycleTime the variable that transforms Cycle into seconds.



%% Taking the analytic signal ( so as y+i*HilbertTransform(y) ) which defines a complex number for each point of the signal
[b,a]=butter(3,[80/(fs/2) 5000/(fs/2)],'bandpass');

dataegglowpassed=filtfilt(b,a,dataegg); %If I do the cycle detection on the lowpassed version it seems I get better results (no doubt)
%dataegglowpassed=dataegg;  %but in order to get the phase better I keep the max deriv point in the beginning (which doesn't really work so well with the lowpassed)

L=length(dataegg);

CycleIndex=1;                   %Total cycle index

AnalyticSignal=hilbert(dataegg);

AnalyticSignalLowpassed=hilbert(dataegglowpassed); %[FFT based] Hilbert transform of the total sequence
%AnalyticSignalLowpassed=AnalyticSignal;


%Set the range of F0 that you expect in the signal
% maxfreq=480;
% minfreq=80;

maxfreq=freqrange(2);
minfreq=freqrange(1);

%% Test Plot 1
%That plot would show all the points of the analytic signal on a scatter plot

% figure(1)
% plot(z,'.') ; axis([-1 1 -1 1]*1.5) ; axis square
% pause
% drawnow

%Some peak detection... No use for it yet!
%[peak,loc]=findpeaks(data,'minpeakdistance',16,'minpeakheight',0); %1st choice
%loc=zerocrossings(data);           %2nd choice -> loc(1)

%[val,mzc]=min(data(loc(1:10))); %the minimum zero crossing
ddata=diff(dataegg);
%[peak,loc]=findpeaks(ddata,'minpeakdistance',50,'minpeakheight',0.05); %The 0.05 is a value that gives the closing peaks as needed

%minheight=max(abs(ddata(1:floor(fs*1))));

minheight=max(abs(ddata(1:floor(end/2))));
warning('off','all');
[peak,loc]=findpeaks(ddata,'minpeakdistance',20,'minpeakheight',minheight); %The 0.05 is a value that gives the closing peaks as needed
warning('on','all');
if isempty(peak)
    [peak,loc]=findpeaks(ddata,'minpeakdistance',20,'minpeakheight',0.5*minheight); %The 0.05 is a value that gives the closing peaks as needed
end
[~,sortloc]=sort(peak);

%sortloc=sortloc(end); %FOR REVERT


%z1=AnalyticSignal(1);     %Taking the first point as a reference
%theta1=angle(z1);           %The angle of the reference point
%plot(angle(AnalyticSignal(loc)))

%theta1=(angle(AnalyticSignal(sortloc))); %FOR REVERT

theta1=median(angle(AnalyticSignalLowpassed(loc)));

%Figure to check for degg peaks
% figure
% aspect(ddata,fs,0.03,2^11,0.90,'n'); ylim([0 5000])
% %Plots to check that the dEGG peaks chosen are the needed ones (the ones
% %that signify the closing moment)
% figure
% subplot(2,1,1)
% plot(data); hold on; plot(loc,data(loc),'.g');
% subplot(2,1,2)
% plot(ddata) ; hold on ; plot(loc,ddata(loc),'.g');
% pause
% figure
% plot(loc,angle(AnalyticSignal(loc)),'.g')
%hold on
%plot(angle(AnalyticSignal))

if fs>88200
    TOL=pi/30;
elseif fs<=20000
    TOL=pi/16;
else
    TOL=pi/20;  %The tolerance for searching a complete revolution around the first point, default pi/3 (For fs=16000, for fs=44100 it can work with pi/15)
end
%Find the points of the signal that are within a TOL range from theta1
index=find(abs(angle(AnalyticSignalLowpassed)-theta1)<TOL);
index=[index];
%Take the difference index(m+1)-index(m)
di=diff(index);
%and find all the values of index that are separated by less than 5 samples, so they cannot really be a cycle... (max freq ~ 339 Hz)
%falseind=find(di<=5);
falseind=find(di<=floor(fs*1/maxfreq) | di>=floor(fs*1/minfreq));
%remove these values from index
index(falseind)=[];
di=diff(index);
di2=diff(di);
%[di2indsusp]=find(di2>=50)

m=1;
indexnew(1)=index(1);

diff(index);

%% Test Plot 2
% That plot would show all the points as blue, and the first (green), second (red), and all
% the indexed (beginnings and ends of each cycle) points as red circles.
% figure ; plot(data);
% hold on
% plot(index,data(index),'ro');
%  figure ; clf(gcf) ;
%  subplot(1,2,1) ; plot(z,'.')
%  hold on
%  plot(z(1),'g*') ; plot(z(2),'r*','markersize',10) ; plot(z(index),'or') ; axis([-1 1 -1 1]) ; axis square
%  subplot(1,2,2) ; plot(z,'.') ; hold on ; plot(z(1),'g*') ; plot(z(2),'r*','markersize',10) ; plot(z(index),'or') ; axis([-1 1 -1 1]) ; axis square

DurDisp=0;
Duration=index(1)/fs; %The initial starting point of time is not zero but the index(1)/fs, since we start cycles from the point index(1) of the signal
CycleTime=[];
skip=1;


for m=1:skip:length(index)-1
    
    CycleIndices{CycleIndex}=(index(m):index(m+1)-1);
    
    Cycle{CycleIndex}=AnalyticSignal(index(m):index(m+1)-1); %A cell containing all the EGG Cycles, not from the lowpassed but the original signal!
    CycleV{CycleIndex}=datavoice(index(m):index(m+1)-1); %A cell containing all the Voice cycles
    
    %      %%%Test for the phases%%%
    %      rfdspec=[real(Cycle{CycleIndex}) real(Cycle{CycleIndex}(1))];
    %      egd=diff(rfdspec);
    %      [maxder,N1]=max(egd);
    %      if N1~=1
    %     Cycle{CycleIndex}=([Cycle{CycleIndex}(N1:end) Cycle{CycleIndex}(1:N1-1)]);
    %     CycleV{CycleIndex}=([CycleV{CycleIndex}(N1:end) CycleV{CycleIndex}(1:N1-1)]);
    %     end
    %     difagain=diff(real(Cycle{CycleIndex}));
    %     [peak,loc]=findpeaks(difagain(1:end),'minpeakheight',0.5*difagain(1));
    %     if isempty(loc)==0 && isempty(find(loc<length(Cycle{CycleIndex}/2)))==0 && isempty(find(loc==1)) && isempty(find(loc==length(difagain)))
    %         N1=loc;
    %         Cycle{CycleIndex}=([Cycle{CycleIndex}(N1:end) Cycle{CycleIndex}(1:N1-1)]);
    %     CycleV{CycleIndex}=([CycleV{CycleIndex}(N1:end) CycleV{CycleIndex}(1:N1-1)]);
    %     end
    %
    
    %Cycle{CycleIndex}(1:3)
    
    %Taking the DFT with the proper resolution
    
    nc=length(Cycle{CycleIndex});
    
    fz=fft(Cycle{CycleIndex},nc)/(nc/2);
    
    fzshifted=fftshift(fz);
    
    %Making of the DFT axis
    
    if mod(nc,2)==0
        ff=[-nc/2:nc/2-1];
    else
        ff=[-floor(nc/2):floor(nc/2)];
    end
    
    fznorm=0.7*exp(i*angle(fz));    %A phasor with the phase of the FD spectra
    
    colors = get(0,'DefaultAxesColorOrder');
    
    %FirstHarmonicIndex is 2 since 1 is the DC
    CompassMatrixX=[(real(fznorm(2:5)))];
    CompassMatrixY=[(imag(fznorm(2:5)))];
    
    %The variable containing each Cycle's Fourier Descriptor spectrum
    %FourierDescriptorSpectraMagnitude{CycleIndex}=[abs(fz)];
    %FourierDescriptorSpectraPhase{CycleIndex}=[angle(fz)];
    FourierDescriptorSpectrum{CycleIndex}=fz;
    
    % Extra bit added for the phases: Taking as reference point of
    % the cycle the moment of maximum derivative: Gives a smoother
    % phase curve for the first harmonics (almost no need to unwrap).
    %I keep the originally extracted cycles based on the reference point, I
    %only change the order of the points for the FFT analysis.
    % rfdspec=real(Cycle{CycleIndex});
    % egd=diff(rfdspec);
    % [maxder,N]=max(egd);
    % FourierDescriptorSpectrum{CycleIndex}=fft([Cycle{CycleIndex}(N+1:end) Cycle{CycleIndex}(1:N)]);
    
    %Plot of each individual cycle, in the making together with the respective
    %Fourier Descriptor spectrum.
    
    if p=='y'
        
        %Figure with the FD magnitude, the State Space Plot and the FD phases
        
        col=colormap(hsv(4+1));  %Just making a color series for each harmonic
        
        figure(3) ; clf
        subplot(1,3,1) ; stem(ff,fftshift(abs(fz)))
        xlim([-25 25]) ; ylim([0 5])
        subplot(1,3,2) ; plot(Cycle{CycleIndex},'k')
        CyclePlot=title('Test');
        hold on
        plot(Cycle{CycleIndex}([1,end]),'.r')
        set(3,'Position', [40 60 1100 300]) ; axis([min(dataegglowpassed) max(dataegglowpassed) 2*min(dataegglowpassed) 2*max(dataegglowpassed)])
        subplot(1,3,3) ; ComPlot=compass(CompassMatrixX,CompassMatrixY);
        
        DurDisp=[DurDisp+length(Cycle{CycleIndex})/fs];
        set(CyclePlot,'String',[sprintf('Number of cycle and time in s: '),[num2str(CycleIndex),'   ',num2str(DurDisp)]]);
        
        for co=1:length(ComPlot)
            %set(ComPlot(co),'color',colors(mod(co-1,length(colors))+1,:));
            set(ComPlot(co),'color',col(co,:));
        end
        
    end
    
%     DurPrev(CycleIndex+1)=Duration;
%     if CycleIndex==1
%         Duration=Duration;
%     else
%         
%     Duration=DurPrev(CycleIndex-1)-length(Cycle{CycleIndex})/fs/2;
%     end
    
    CycleTime=[CycleTime ; CycleIndex Duration];
    
    Duration=[Duration+length(Cycle{CycleIndex})/fs];
    
    CycleIndex=CycleIndex+skip;
    
end

%F0cyc=cellfun(@length,

% Howmany contains the number of cycles found in a given signal chunk,
% in the nth loop
% because index is the indices of the cycles
% howmany=length(index)-1;
% Maxdif is the maximum separation distance between index (cycle length).
% It gives the maximum length of cycle that occured in one n loop. For
% a signal with one F0 such as a sin or a harmonic series the histogram
% of maxdiff should be centered on the number of samples correspoonding
% to one cycle. Sometimes though there might be some spread and the
% algorithm might take more cycles as one. Ofcourse the less the noise,
% the better the performance.
% maxdif=max(diff(index));
% figure
% [c,b]=hist(maxdif,unique(maxdif));
% bar(b,c)
% title('Samples per cycle')
%
% [cm,bm]=hist(howmany,unique(howmany));
% figure
% bar(bm,cm)
% title('Number of cycles')


%%Code discarded 31/1/2013 1.25 pm
% for n=1:length(index)
% peak=(abs(data(index(n))-data(index)))
% end

%nogoofind=find(abs(AnalyticSignal(index(n+1))-AnalyticSignal(index(n)))>=0.101*(abs(AnalyticSignal(index(1))-AnalyticSignal(1)))) %1.2 works for small samples
%nogood(n)=nogoofind(1);
%nogood=find(abs(AnalyticSignal(index)-AnalyticSignal(1))>=2*(abs(AnalyticSignal(index(1))-AnalyticSignal(1)))) %1.2 works for small samples

%index(nogood)=[]
