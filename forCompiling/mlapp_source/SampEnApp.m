
classdef SampEnApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        MinpeakvalueHilbertrelativetodatamximum90Slider  matlab.ui.control.Slider
        MinpeakvalueHilbertrelativetodatamximum90SliderLabel  matlab.ui.control.Label
        uselogarithmicyscaleCheckBox    matlab.ui.control.CheckBox
        AlsoexportcyclefrequencyCheckBox  matlab.ui.control.CheckBox
        usethisasnewdataandcloseButton  matlab.ui.control.Button
        Panel                           matlab.ui.container.Panel
        numberofcyclesperSampEncalculationEditField  matlab.ui.control.NumericEditField
        numberofcyclesperSampEncalculationEditFieldLabel  matlab.ui.control.Label
        PhasethresholdEditField         matlab.ui.control.NumericEditField
        PhasethresholdEditFieldLabel    matlab.ui.control.Label
        MagnitudethresholdEditField     matlab.ui.control.NumericEditField
        MagnitudethresholdEditFieldLabel  matlab.ui.control.Label
        MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider  matlab.ui.control.Slider
        Minpeakprominencerelativetorangeofthetadistance80Label  matlab.ui.control.Label
        Minpeakvaluerelativetodatamaximum20Slider  matlab.ui.control.Slider
        MinpeakvaluerelativetodatamaximumLabel  matlab.ui.control.Label
        Minpeakprominecerelativetoinputdatarange10Slider  matlab.ui.control.Slider
        MinpeakpromincerelativetodatarangeLabel  matlab.ui.control.Label
        MaximumFrequencyEditField       matlab.ui.control.NumericEditField
        MaximumFrequencyEditFieldLabel  matlab.ui.control.Label
        MinimumFrequencyEditField       matlab.ui.control.NumericEditField
        MinimumFrequencyEditFieldLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        FourierDescriptorSpectrum % Description
        Cycle % Description
        CycleTime % Description
        signal % Description
        fs % Description
        Sampentot % Description
        SampenTimeVector % Description
        UIAxes1 % Description
        UIAxes2
        UIAxes3
        UIAxes4
        UIAxes5
        eggHandle % Description
        eggBordersHandle
        deggHandle
        deggPeaksHandle
        distanceFromThetaHandle
        distanceFromThetaPeaksHandle
        cycleFreqHandle
        sampEnHandle

    end
    
    properties (Access = public)
        finalSampEn % Description
        finalSampEnTime
        dataApplied=0; % Description
        finalCycleFreq; % Description
        finalCycleFreqTime;
    end
    
    methods (Access = private)
        
        function refreshSampEn(app)

            


            tmp=app.signal(:);
            
            egg=app.kanon(tmp');
            %egg=app.hpfiltegg(egg,app.fs);
           
            
            %Concatenates amplitudes and phases per cycle, calculates SampEn
            [app.Sampentot,HarmAmp,HarmPhas,app.SampenTimeVector,~,~]=app.SampenAndFDs(1,3,2,{app.FourierDescriptorSpectrum},{app.Cycle},{app.CycleTime},{egg},app.fs,'n',0);
            
                
            
            

            if isempty(app.sampEnHandle) || ~isvalid(app.sampEnHandle)
                hold(app.UIAxes5,"on");
                app.sampEnHandle=plot(app.UIAxes5,app.SampenTimeVector(:),app.Sampentot(:),'LineWidth',2,'Color','r');
                hold(app.UIAxes5,"off");
            else
                set(app.sampEnHandle,'XData',app.SampenTimeVector(:),'YData',app.Sampentot(:));
            end
                    
            
            
        
            
            
            
            
            
            
        end
        
        
        function [FourierDescriptorSpectrum,Cycle,CycleV,CycleTime,CycleIndices,index]=CycleDetection(app,dataegg,datavoice,fs)
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


            maxfreq=app.MaximumFrequencyEditField.Value;
            minfreq=app.MinimumFrequencyEditField.Value;


            ddata=diff(dataegg);
            %[peak,loc]=findpeaks(ddata,'minpeakdistance',50,'minpeakheight',0.05); %The 0.05 is a value that gives the closing peaks as needed

            %minheight=max(abs(ddata(1:floor(fs*1))));

            minheight=max(abs(ddata(1:floor(end/2))));
            warning('off','all');
            %[peak,loc]=findpeaks(ddata,'minpeakdistance',20,'minpeakheight',minheight); %The 0.05 is a value that gives the closing peaks as needed

            minDistance=round(fs/maxfreq);
            [peak,deggPeaksLoc]=findpeaks(ddata,'MinPeakProminence',app.Minpeakprominecerelativetoinputdatarange10Slider.Value/100*range(ddata),'MinPeakDistance',minDistance,'MinPeakHeight',app.Minpeakvaluerelativetodatamaximum20Slider.Value/100*range(ddata)+min(ddata));

            tvals=app.taxis(ddata,app.fs);

            if isempty(app.deggHandle) || ~isvalid(app.deggHandle)
                hold(app.UIAxes2,"on");
                app.deggHandle=plot(app.UIAxes2,tvals,ddata,'Color','b'); app.deggPeaksHandle=line(app.UIAxes2,tvals(deggPeaksLoc),ddata(deggPeaksLoc),'Color','r','LineStyle','none','Marker','v');
                hold(app.UIAxes5,"off");
            else
                set(app.deggHandle,'XData',tvals,'YData',ddata);
                set(app.deggPeaksHandle,'XData',tvals(deggPeaksLoc),'YData',ddata(deggPeaksLoc));
            end

            

            warning('on','all');
            if isempty(peak)
                [peak,deggPeaksLoc]=findpeaks(ddata,'minpeakdistance',20,'minpeakheight',0.5*minheight); %The 0.05 is a value that gives the closing peaks as needed
            end
            [~,sortloc]=sort(peak);

            %sortloc=sortloc(end); %FOR REVERT


            %z1=AnalyticSignal(1);     %Taking the first point as a reference
            %theta1=angle(z1);           %The angle of the reference point
            %plot(angle(AnalyticSignal(loc)))

            %theta1=(angle(AnalyticSignal(sortloc))); %FOR REVERT

            theta1=median(angle(AnalyticSignalLowpassed(deggPeaksLoc)));

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

            % if fs>88200
            %     TOL=pi/30;
            % elseif fs<=20000
            %     TOL=pi/16;
            % else
            %     TOL=pi/20;  %The tolerance for searching a complete revolution around the first point, default pi/3 (For fs=16000, for fs=44100 it can work with pi/15)
            % end
            %Find the points of the signal that are within a TOL range from theta1
            % index=find(abs(angle(AnalyticSignalLowpassed)-theta1)<TOL);
            % index=[index];


            distanceFromTheta=-abs(angle(AnalyticSignalLowpassed)-theta1);
            [~,index]=findpeaks(distanceFromTheta,'MinPeakDistance',minDistance,'MinPeakProminence',app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Value/100*range(distanceFromTheta),'MinPeakHeight',app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value/100*range(distanceFromTheta)+min(distanceFromTheta));

            %[~,index]=findpeaks(distanceFromTheta,'MinPeakProminence',app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Value/100*range(distanceFromTheta),'MinPeakHeight',app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value/100*range(distanceFromTheta)+min(distanceFromTheta));

            % while any(diff(index)<=0.9*floor(fs*1/maxfreq))
            %     index(find(diff(index)<=0.9*floor(fs*1/maxfreq))+1)=[];
            % end

            %% post process
            partDistance=floor(0.7*minDistance);


            % Ergänzend: Suche um jeden deggPeak herum nach lokalem Peak
            additionalPeaks = [];

            for peakNr = 1:numel(deggPeaksLoc)
                center = deggPeaksLoc(peakNr);
                excerptIdx = (center - partDistance):(center + partDistance);
                excerptIdx(excerptIdx < 1 | excerptIdx > numel(distanceFromTheta)) = [];
                excerpt = distanceFromTheta(excerptIdx);

                [~, currlocs] = findpeaks(excerpt, ...
                    'MinPeakHeight', app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value / 100 * range(distanceFromTheta) + min(distanceFromTheta), ...
                    'MinPeakProminence', app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value / 100 * range(distanceFromTheta));

                if numel(currlocs) < 2
                    [~, currlocs] = findpeaks(excerpt, ...
                        'MinPeakHeight', app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value / 100 * range(distanceFromTheta) + min(distanceFromTheta));
                end

                if isempty(currlocs)
                    continue;
                end

                candidateAbsLocs = excerptIdx(currlocs);
                [~, bestIdx] = min(abs(candidateAbsLocs - center));
                additionalPeaks(end+1) = candidateAbsLocs(bestIdx);
            end

            % Kombinieren und doppelte entfernen
            index = unique([index, additionalPeaks]);


            % jetzt jeden peak durch gehen und den nächsten bzgl degg
            % nehmen

            
            for indexNr=1:numel(index)
                deggPeakCandidates=deggPeaksLoc(deggPeaksLoc<=(index(indexNr)+partDistance) & deggPeaksLoc>=(index(indexNr)-partDistance));
                if isempty(deggPeakCandidates)
                    continue;
                end
                excerptIdx=(index(indexNr)-partDistance):(index(indexNr)+partDistance);
                excerptIdx(excerptIdx<1 | excerptIdx>numel(distanceFromTheta))=[];
                excerpt=distanceFromTheta(excerptIdx);

                [~,currlocs]=findpeaks(excerpt,'MinPeakHeight',app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value/100*range(distanceFromTheta)+min(distanceFromTheta),'MinPeakProminence',app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value/100*range(distanceFromTheta));

                if numel(currlocs)<2
                    [~,currlocs]=findpeaks(excerpt,'MinPeakHeight',app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value/100*range(distanceFromTheta)+min(distanceFromTheta));
                end
                    
                if numel(currlocs)<2
                    continue;
                end

                % Lokale Kandidaten in absolute Indizes umrechnen
                candidateAbsLocs = excerptIdx(currlocs);
            
                % Für jeden Kandidaten den kürzesten Abstand zu den deggPeaks bestimmen
                [~,bestIdx] = min(arrayfun(@(c) min(abs(deggPeaksLoc - c)), candidateAbsLocs));
            
                % Den Peak auf diesen besten Kandidaten setzen
                index(indexNr) = candidateAbsLocs(bestIdx);

                

            end

            index=unique(index); % somtimes there are double idx


            

            % now look into pairs where the frequency is too high
           diffs = find(diff(index) < minDistance);

           toRemove = false(size(index)); % Markiere, welche Indizes entfernt werden sollen

           for diffNr = 1:numel(diffs)
               idx1 = diffs(diffNr);
               idx2 = idx1 + 1;

               % Sicherheitscheck, ob idx2 im gültigen Bereich liegt
               if idx2 > numel(index)
                   continue;
               end

               dist1 = min(abs(index(idx1) - deggPeaksLoc));
               dist2 = min(abs(index(idx2) - deggPeaksLoc));

               if dist1 < dist2
                   toRemove(idx2) = true;
               else
                   toRemove(idx1) = true;
               end
           end

           index(toRemove) = []; % Entferne die markierten Indizes

            tvals=app.taxis(distanceFromTheta,app.fs);


            if isempty(app.distanceFromThetaHandle) || ~isvalid(app.distanceFromThetaHandle)
                hold(app.UIAxes3,"on");
                app.distanceFromThetaHandle=plot(app.UIAxes3,tvals,distanceFromTheta,'Color','b');
                app.distanceFromThetaPeaksHandle=line(app.UIAxes3,tvals(index),distanceFromTheta(index),'Color','r','LineStyle','none','Marker','v');
            else
                set(app.distanceFromThetaHandle,'XData',tvals,'YData',distanceFromTheta);
                set(app.distanceFromThetaPeaksHandle,'XData',tvals(index),'YData',distanceFromTheta(index));
            end

            %Take the difference index(m+1)-index(m)
            di=diff(index);
            %and find all the values of index that are separated by less than 5 samples, so they cannot really be a cycle... (max freq ~ 339 Hz)
            %falseind=find(di<=5);
            %falseind=find(di<=floor(fs*1/maxfreq) | di>=floor(fs*1/minfreq));
            %falseind=di<floor(fs*1/maxfreq);
            %remove these values from index
            %index(falseind)=[];
            di=diff(index);
            di2=diff(di);
            %[di2indsusp]=find(di2>=50)

            m=1;
            indexnew(1)=index(1);

            diff(index);


            DurDisp=0;
            Duration=index(1)/fs; %The initial starting point of time is not zero but the index(1)/fs, since we start cycles from the point index(1) of the signal
            CycleTime=[];
            skip=1;


            for m=1:skip:length(index)-1

                CycleIndices{CycleIndex}=(index(m):index(m+1)-1);

                Cycle{CycleIndex}=AnalyticSignal(index(m):index(m+1)-1); %A cell containing all the EGG Cycles, not from the lowpassed but the original signal!
                CycleV{CycleIndex}=datavoice(index(m):index(m+1)-1); %A cell containing all the Voice cycles

               

                %Taking the DFT with the proper resolution

                nc=length(Cycle{CycleIndex});

                fz=fft(Cycle{CycleIndex},nc)/(nc/2);





                %The variable containing each Cycle's Fourier Descriptor spectrum
                %FourierDescriptorSpectraMagnitude{CycleIndex}=[abs(fz)];
                %FourierDescriptorSpectraPhase{CycleIndex}=[angle(fz)];
                FourierDescriptorSpectrum{CycleIndex}=fz;



                CycleTime=[CycleTime ; CycleIndex Duration];

                Duration=[Duration+length(Cycle{CycleIndex})/fs];

                CycleIndex=CycleIndex+skip;

            end



        end
        
        
        function [Sampentot,HarmAmp,HarmPhas,SampenTimeVector,SmallCycles,HigherContent]=SampenAndFDs(app,trial,howmany,sampenhowmany,fdspectrum,cycles,cyctime,signal,fs,plo,doNormalizeOutput) %,breaktimes,breaktimes2)
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

            [HarmAmp HarmPhas SmallCycles HigherContent]=app.FDHarmonicAmplitudesandPhases(howmany+1,fdspectrum{M},cyctime{M},'s',signal{M},fs);


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

                
                numberOfCycles=app.numberofcyclesperSampEncalculationEditField.Value;
                MagThreshold=app.MagnitudethresholdEditField.Value/100;
                PhaseThreshold=app.PhasethresholdEditField.Value/100;
               
               
                [td,SampenMag{N}]=app.LookAtSampen(numberOfCycles,(app.kanon((yam))),numberOfCycles-1,MagThreshold);   %0.1/0.2 magni     %For females perhaps 20 cycles and 19 overlap
                [td,SampenPhas{N}]=app.LookAtSampen(numberOfCycles,yph,numberOfCycles-1,PhaseThreshold);       %0.5  phases %4 fem

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
            TotNormConst=max(Sampentot(Sampentot~=Inf));
            if TotNormConst==0 || TotNormConst==Inf
                TotNormConst=1;
            end

            if doNormalizeOutput
                Sampentot=Sampentot/TotNormConst;
            end

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

        end
        
        
        function egg=hpfiltegg(~,egg,fs)
            [b,a]=butter(3,[80/(fs/2) 7000/(fs/2)]);
            egg=filtfilt(b,a,egg);
        end

        function ynorm=kanon(~,y)
            ynorm=y/max(abs(y(y~=Inf)));
        end


        function [t,dene]=LookAtSampen(app,wsize,signal,overlap,r)
            %This function calculates the Sample Entropy of a signal given the window
            %size, the signal, the amount of overlap between windows and the
            %matching tolerance r.
            %Usage:
            %[t,SampleEntropy]=LookAtSampen(WindowSize,Signal,Overlap);

            enestim=[];

            [~,t,Nwin]=app.sliwind(signal,wsize,1,overlap);

            %an=1;
            m=1;

            Nwin=length(t);

            for m=1:Nwin
                [an,t]=app.sliwind(signal,wsize,m,overlap);
                [enestim(:,m),A,B]=app.sampenc(an,1,r);   %r is the matching tolerance
                %yenestim(:,m)=sampen2(1,r,an,1);
                %enestim(:,m)=sampleEntropy(an,1,r,1);
            end

            dene=enestim;
        end

        
        

        function [HarmAmp,HarmPhas,SmallCyclesToExclude,HigherContent]=FDHarmonicAmplitudesandPhases(app,NumberOfHarmonics,fdspectrum,cycletime,time,signal,fs)

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

        end

        function [e,A,B]=sampenc(~,y,M,r)
            %function [e,A,B]=sampenc(y,M,r);
            %
            %Input
            %
            %y input data
            %M maximum template length
            %r matching tolerance
            %
            %Output
            %
            %e sample entropy estimates for m=0,1,...,M-1
            %A number of matches for m=1,...,M
            %B number of matches for m=0,...,M-1 excluding last point

            n=length(y);

            lastrun=zeros(1,n);

            run=zeros(1,n);

            A=zeros(M,1);

            B=zeros(M,1);

            p=zeros(M,1);

            e=zeros(M,1);

            for i=1:(n-1)
                nj=n-i;
                y1=y(i);

                for jj=1:nj
                    j=jj+i;
                    if abs(y(j)-y1)<r
                        run(jj)=lastrun(jj)+1;
                        M1=min(M,run(jj));
                        for m=1:M1
                            A(m)=A(m)+1;
                            if j<n
                                B(m)=B(m)+1;
                            end
                        end
                    else
                        run(jj)=0;
                    end
                end

                for j=1:nj
                    lastrun(j)=run(j);
                end

            end
            N=n*(n-1)/2;
            B=[N;B(1:(M-1))];
            p=A./B;
            e=-log(p);
        end
        
        function [sl,time,N,Llastwin,indecesofcurrentwindow]=sliwind(~,y,winsize,n,over)
            %A function to make a sliding window
            %Usage [wind,timeind,howmany,lastwinlength]=sliwind(Signal,WindowSize,WindowNumber,Overlap)
            %n takes values between length(y)

            L=length(y);

            Nnover=length(1:winsize:L);

            N=length(1:(winsize-over):L);

            time=1:(winsize-over):L;

            time=time(1:end)+floor(winsize/2);

            time=time(time<=L);

            Llastwin=length(y((N-1)*winsize+1-(N-1)*over:end));

            % if mod(Llastwin,2)==0
            %     time(end+1)=length(y)-floor(Llastwin/2)+1;
            % else
            %     time(end+1)=length(y)-floor(Llastwin/2);
            % end

            if n==1
                sl=y(1:winsize);
                indecesofcurrentwindow=1:winsize;

            elseif n>1 & (n-1)*winsize+winsize-(n-1)*over<=L

                sl=y( (n-1)*winsize+1-(n-1)*over : (n-1)*winsize+winsize-(n-1)*over );
                indecesofcurrentwindow=(n-1)*winsize+1-(n-1)*over : (n-1)*winsize+winsize-(n-1)*over;

            elseif (n-1 )*winsize+winsize-(n-1)*over>L & (n-1)*winsize+1-(n-1)*over<L

                sl=y((n-1)*winsize+1-(n-1)*over:end);
                indecesofcurrentwindow=(n-1)*winsize+1-(n-1)*over:L;

            else

                disp(['Warning: only ' num2str(N-1) ' full windows of this size fit to the signal and a last window of ' num2str(Llastwin) ' points.'])
                sl=[];

            end
        end
        
        function t=taxis(~,signal,fs)

        t=(0:length(signal)-1)/fs;
        
        end
        
        function refreshCycleDetection(app)

                tmp=app.signal(:);
                
                egg=app.kanon(tmp');
                %egg=app.hpfiltegg(egg,app.fs);
                t=app.taxis(egg,app.fs);
                
                
                %Detects the cycles and calculates the DFT per Cycle
                [app.FourierDescriptorSpectrum,app.Cycle,CycleV,app.CycleTime,CycleIndices,cycleBorderIdx]=app.CycleDetection(egg,egg,app.fs); 
                %usage: CycleDetection(egg,voice,fs,'n'); but in this case there was no voice signal
    

               
    
                
    
    
                minY=min(egg); maxY=max(egg); rangeY=maxY-minY;
                plotMin=minY-0.1*rangeY;
                plotMax=maxY+0.1*rangeY;
    
                xvals=repelem(t(cycleBorderIdx),3); xvals(3:3:end)=NaN;
                yvals=repmat([plotMin plotMax NaN],[1 numel(t(cycleBorderIdx))]);
    
                

                if isempty(app.eggHandle) || ~isvalid(app.eggHandle)
                    hold(app.UIAxes1,"on");
                    app.eggHandle=plot(app.UIAxes1,t,egg,'Color','b');
                    app.eggBordersHandle=plot(app.UIAxes1,xvals,yvals,'k-');
                    hold(app.UIAxes1,'off');
                    uistack(app.eggBordersHandle,'bottom');

                    hold(app.UIAxes4,'on');
                    app.cycleFreqHandle=plot(app.UIAxes4,movmean(t(cycleBorderIdx),2,"Endpoints","discard"),app.fs./diff(cycleBorderIdx),'Color','b');

                    
                else
                    
                    set(app.eggHandle,'XData',t,'YData',egg);
                    set(app.eggBordersHandle,'XData',xvals,'YData',yvals);
                    set(app.cycleFreqHandle,'XData',movmean(t(cycleBorderIdx),2,"Endpoints","discard"),'YData',app.fs./diff(cycleBorderIdx));
                end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, varargin)
            app.UIFigure.Visible='off';
            drawnow;

            if numel(varargin)==0
                [app.signal,app.fs]=audioread("anotherEGGtest.wav");
            else
                app.signal=varargin{1};
                app.fs=varargin{2};

                % if app.fs<1e6 % interpolate up to 100kHz
                %     factor=ceil(1e6/app.fs);
                %     app.signal=interp1(app.signal,1:1/factor:numel(app.signal),'makima');
                %     app.fs=app.fs*factor;
                % end
            end

            

            titlearray={'EGG' 'dEGG peaks' ["Peaks of hilbert phase in reference" "to dEGG peaks' median phase"] 'Resulting cycle frequency' 'Sample Entropy'};
            tl=tiledlayout(app.Panel,5,1,'Padding','tight','TileSpacing','tight');
            for axNr=1:5
                currAx=nexttile(tl,axNr);
                
                app.(['UIAxes' num2str(axNr)])=currAx;
                xlabel(currAx,'');
                title(currAx,titlearray{axNr});

                if axNr==4
                    currAx.YScale='log';
                end
                

            end

            %allAx=findall(app.UIFigure,'type','axes');
            linkaxes(tl.Children,'x');

            

            movegui(app.UIFigure,'center');

            app.refreshCycleDetection();
            app.refreshSampEn();

            drawnow;
            axtoolbar(tl,{'zoomin' 'zoomout' 'restoreview'});

            %arrayfun(@(in) disableDefaultInteractivity(in),tl.Children);

            enableLegacyExplorationModes(app.UIFigure);

            z=zoom(app.UIFigure);

            z.Motion='horizontal';
            z.RightClickAction='InverseZoom';


            z.actionPostCallback=@(~,~) ylim(tl.Children,'padded');

            z.Enable='on';
            

            set(tl.Children,'Interactions',[panInteraction dataTipInteraction])

            ylim(tl.Children,'padded');
            xlim(tl.Children,'tight');

            app.UIFigure.Visible='on';

            drawnow;

            xlim(tl.Children,'manual');

        end

        % Value changed function: MagnitudethresholdEditField, 
        % ...and 8 other components
        function generalCycleRefreshCallback(app, event)
            dlg=uiprogressdlg(app.UIFigure,"Indeterminate","on",'Message','Calculating cycles');
            app.refreshCycleDetection();

            dlg.Message='Calculating SampEn';
            app.refreshSampEn();

            delete(dlg);
        end

        % Value changing function: 
        % Minpeakprominecerelativetoinputdatarange10Slider
        function Minpeakprominecerelativetoinputdatarange10SliderValueChanging(app, event)
            changingValue = event.Value;

            app.MinpeakpromincerelativetodatarangeLabel.Text=['Min peak promince, relative to input data range: ' num2str(changingValue) '%'];
            

        end

        % Value changing function: 
        % Minpeakvaluerelativetodatamaximum20Slider
        function Minpeakvaluerelativetodatamaximum20SliderValueChanging(app, event)
            changingValue = event.Value;

            app.MinpeakvaluerelativetodatamaximumLabel.Text=['Min peak value, relative to data maximum: ' num2str(changingValue) '%'];
            
        end

        % Value changing function: 
        % MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider
        function MinpeakprominenceHilbertrelativetorangeofthetadistanceSliderValueChanging(app, event)
            changingValue = event.Value;

            app.Minpeakprominencerelativetorangeofthetadistance80Label.Text=['Min peak prominence, relative to range of theta distance: ' num2str(changingValue) '%'];
            


            
        end

        % Button pushed function: usethisasnewdataandcloseButton
        function usethisasnewdataandcloseButtonPushed(app, event)
            app.finalSampEn=app.Sampentot;
            app.finalSampEnTime=app.SampenTimeVector;

            if app.AlsoexportcyclefrequencyCheckBox.Value==1
                app.finalCycleFreq=app.cycleFreqHandle.YData;
                app.finalCycleFreqTime=app.cycleFreqHandle.XData;
            end
            app.dataApplied=1;
        end

        % Value changed function: uselogarithmicyscaleCheckBox
        function uselogarithmicyscaleCheckBoxValueChanged(app, event)
            value = app.uselogarithmicyscaleCheckBox.Value;
            
            if value==1
                app.UIAxes4.YScale='log';
            else
                app.UIAxes4.YScale='lin';
            end
        end

        % Value changing function: 
        % MinpeakvalueHilbertrelativetodatamximum90Slider
        function MinpeakvalueHilbertrelativetodatamximum90SliderValueChanging(app, event)
            changingValue = event.Value;
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.Text=['Min peak value, relative to data mximum: ' num2str(changingValue) '%'];
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 928 598];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'2x', '2x', '1x', 'fit', '1x', 'fit', '1x', 'fit', '1x', 'fit', '4x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [1 1 1 1];

            % Create MinimumFrequencyEditFieldLabel
            app.MinimumFrequencyEditFieldLabel = uilabel(app.GridLayout);
            app.MinimumFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumFrequencyEditFieldLabel.FontWeight = 'bold';
            app.MinimumFrequencyEditFieldLabel.Layout.Row = 1;
            app.MinimumFrequencyEditFieldLabel.Layout.Column = 3;
            app.MinimumFrequencyEditFieldLabel.Text = 'Minimum Frequency';

            % Create MinimumFrequencyEditField
            app.MinimumFrequencyEditField = uieditfield(app.GridLayout, 'numeric');
            app.MinimumFrequencyEditField.Limits = [50 2999];
            app.MinimumFrequencyEditField.RoundFractionalValues = 'on';
            app.MinimumFrequencyEditField.ValueDisplayFormat = '%4i';
            app.MinimumFrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.MinimumFrequencyEditField.Layout.Row = 1;
            app.MinimumFrequencyEditField.Layout.Column = 4;
            app.MinimumFrequencyEditField.Value = 50;

            % Create MaximumFrequencyEditFieldLabel
            app.MaximumFrequencyEditFieldLabel = uilabel(app.GridLayout);
            app.MaximumFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumFrequencyEditFieldLabel.FontWeight = 'bold';
            app.MaximumFrequencyEditFieldLabel.Layout.Row = 2;
            app.MaximumFrequencyEditFieldLabel.Layout.Column = 3;
            app.MaximumFrequencyEditFieldLabel.Text = 'Maximum Frequency';

            % Create MaximumFrequencyEditField
            app.MaximumFrequencyEditField = uieditfield(app.GridLayout, 'numeric');
            app.MaximumFrequencyEditField.Limits = [51 3000];
            app.MaximumFrequencyEditField.RoundFractionalValues = 'on';
            app.MaximumFrequencyEditField.ValueDisplayFormat = '%4i';
            app.MaximumFrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.MaximumFrequencyEditField.Layout.Row = 2;
            app.MaximumFrequencyEditField.Layout.Column = 4;
            app.MaximumFrequencyEditField.Value = 1000;

            % Create MinpeakpromincerelativetodatarangeLabel
            app.MinpeakpromincerelativetodatarangeLabel = uilabel(app.GridLayout);
            app.MinpeakpromincerelativetodatarangeLabel.HorizontalAlignment = 'center';
            app.MinpeakpromincerelativetodatarangeLabel.WordWrap = 'on';
            app.MinpeakpromincerelativetodatarangeLabel.FontWeight = 'bold';
            app.MinpeakpromincerelativetodatarangeLabel.Tooltip = {'You don''t have to catch all peaks in the dEGG, it is enough to catch most of them or typical ones since we use only the phase of the hilbert transform of the EGG at the locations of the dEGG peaks'};
            app.MinpeakpromincerelativetodatarangeLabel.Layout.Row = 3;
            app.MinpeakpromincerelativetodatarangeLabel.Layout.Column = [3 4];
            app.MinpeakpromincerelativetodatarangeLabel.Text = 'Min peak prominece, relative to input data range: 10%';

            % Create Minpeakprominecerelativetoinputdatarange10Slider
            app.Minpeakprominecerelativetoinputdatarange10Slider = uislider(app.GridLayout);
            app.Minpeakprominecerelativetoinputdatarange10Slider.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.Minpeakprominecerelativetoinputdatarange10Slider.ValueChangingFcn = createCallbackFcn(app, @Minpeakprominecerelativetoinputdatarange10SliderValueChanging, true);
            app.Minpeakprominecerelativetoinputdatarange10Slider.Step = 1;
            app.Minpeakprominecerelativetoinputdatarange10Slider.Tooltip = {'You don''t have to catch all peaks in the dEGG, it is enough to catch most of them or typical ones since we use only the phase of the hilbert transform of the EGG at the locations of the dEGG peaks'};
            app.Minpeakprominecerelativetoinputdatarange10Slider.Layout.Row = 4;
            app.Minpeakprominecerelativetoinputdatarange10Slider.Layout.Column = [3 4];
            app.Minpeakprominecerelativetoinputdatarange10Slider.Value = 10;

            % Create MinpeakvaluerelativetodatamaximumLabel
            app.MinpeakvaluerelativetodatamaximumLabel = uilabel(app.GridLayout);
            app.MinpeakvaluerelativetodatamaximumLabel.HorizontalAlignment = 'center';
            app.MinpeakvaluerelativetodatamaximumLabel.WordWrap = 'on';
            app.MinpeakvaluerelativetodatamaximumLabel.FontWeight = 'bold';
            app.MinpeakvaluerelativetodatamaximumLabel.Tooltip = {'You don''t have to catch all peaks in the dEGG, it is enough to catch most of them or typical ones since we use only the phase of the hilbert transform of the EGG at the locations of the dEGG peaks'};
            app.MinpeakvaluerelativetodatamaximumLabel.Layout.Row = 5;
            app.MinpeakvaluerelativetodatamaximumLabel.Layout.Column = [3 4];
            app.MinpeakvaluerelativetodatamaximumLabel.Text = 'Min peak value, relative to data maximum: 20%';

            % Create Minpeakvaluerelativetodatamaximum20Slider
            app.Minpeakvaluerelativetodatamaximum20Slider = uislider(app.GridLayout);
            app.Minpeakvaluerelativetodatamaximum20Slider.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.Minpeakvaluerelativetodatamaximum20Slider.ValueChangingFcn = createCallbackFcn(app, @Minpeakvaluerelativetodatamaximum20SliderValueChanging, true);
            app.Minpeakvaluerelativetodatamaximum20Slider.Tooltip = {'You don''t have to catch all peaks in the dEGG, it is enough to catch most of them or typical ones since we use only the phase of the hilbert transform of the EGG at the locations of the dEGG peaks'};
            app.Minpeakvaluerelativetodatamaximum20Slider.Layout.Row = 6;
            app.Minpeakvaluerelativetodatamaximum20Slider.Layout.Column = [3 4];
            app.Minpeakvaluerelativetodatamaximum20Slider.Value = 20;

            % Create Minpeakprominencerelativetorangeofthetadistance80Label
            app.Minpeakprominencerelativetorangeofthetadistance80Label = uilabel(app.GridLayout);
            app.Minpeakprominencerelativetorangeofthetadistance80Label.HorizontalAlignment = 'center';
            app.Minpeakprominencerelativetorangeofthetadistance80Label.WordWrap = 'on';
            app.Minpeakprominencerelativetorangeofthetadistance80Label.FontWeight = 'bold';
            app.Minpeakprominencerelativetorangeofthetadistance80Label.Tooltip = {'On the left, the negative distance to the dEGG peaks phase is displayed. The higher we set the prominence, the nearer must be the phase of the EGG to the median of the dEGG peak phases. The peaks found here correspond to the cycle borders in the EGG signal. '};
            app.Minpeakprominencerelativetorangeofthetadistance80Label.Layout.Row = 7;
            app.Minpeakprominencerelativetorangeofthetadistance80Label.Layout.Column = [3 4];
            app.Minpeakprominencerelativetorangeofthetadistance80Label.Text = 'Min peak prominence, relative to range of theta distance: 10%';

            % Create MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider = uislider(app.GridLayout);
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Limits = [0 95];
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.ValueChangingFcn = createCallbackFcn(app, @MinpeakprominenceHilbertrelativetorangeofthetadistanceSliderValueChanging, true);
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Tooltip = {'On the left, the negative distance to the dEGG peaks phase is displayed. The higher we set the prominence, the nearer must be the phase of the EGG to the median of the dEGG peak phases. The peaks found here correspond to the cycle borders in the EGG signal. '};
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Layout.Row = 8;
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Layout.Column = [3 4];
            app.MinpeakprominenceHilbertrelativetorangeofthetadistanceSlider.Value = 10;

            % Create MagnitudethresholdEditFieldLabel
            app.MagnitudethresholdEditFieldLabel = uilabel(app.GridLayout);
            app.MagnitudethresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.MagnitudethresholdEditFieldLabel.FontWeight = 'bold';
            app.MagnitudethresholdEditFieldLabel.Layout.Row = 12;
            app.MagnitudethresholdEditFieldLabel.Layout.Column = 3;
            app.MagnitudethresholdEditFieldLabel.Text = 'Magnitude threshold';

            % Create MagnitudethresholdEditField
            app.MagnitudethresholdEditField = uieditfield(app.GridLayout, 'numeric');
            app.MagnitudethresholdEditField.Limits = [10 90];
            app.MagnitudethresholdEditField.RoundFractionalValues = 'on';
            app.MagnitudethresholdEditField.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.MagnitudethresholdEditField.Layout.Row = 12;
            app.MagnitudethresholdEditField.Layout.Column = 4;
            app.MagnitudethresholdEditField.Value = 20;

            % Create PhasethresholdEditFieldLabel
            app.PhasethresholdEditFieldLabel = uilabel(app.GridLayout);
            app.PhasethresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.PhasethresholdEditFieldLabel.FontWeight = 'bold';
            app.PhasethresholdEditFieldLabel.Layout.Row = 13;
            app.PhasethresholdEditFieldLabel.Layout.Column = 3;
            app.PhasethresholdEditFieldLabel.Text = 'Phase threshold';

            % Create PhasethresholdEditField
            app.PhasethresholdEditField = uieditfield(app.GridLayout, 'numeric');
            app.PhasethresholdEditField.Limits = [10 90];
            app.PhasethresholdEditField.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.PhasethresholdEditField.Layout.Row = 13;
            app.PhasethresholdEditField.Layout.Column = 4;
            app.PhasethresholdEditField.Value = 40;

            % Create numberofcyclesperSampEncalculationEditFieldLabel
            app.numberofcyclesperSampEncalculationEditFieldLabel = uilabel(app.GridLayout);
            app.numberofcyclesperSampEncalculationEditFieldLabel.HorizontalAlignment = 'right';
            app.numberofcyclesperSampEncalculationEditFieldLabel.WordWrap = 'on';
            app.numberofcyclesperSampEncalculationEditFieldLabel.FontWeight = 'bold';
            app.numberofcyclesperSampEncalculationEditFieldLabel.Tooltip = {'for men 10, for women 20. overlap is n-1'};
            app.numberofcyclesperSampEncalculationEditFieldLabel.Layout.Row = 14;
            app.numberofcyclesperSampEncalculationEditFieldLabel.Layout.Column = 3;
            app.numberofcyclesperSampEncalculationEditFieldLabel.Text = 'number of cycles per SampEn calculation';

            % Create numberofcyclesperSampEncalculationEditField
            app.numberofcyclesperSampEncalculationEditField = uieditfield(app.GridLayout, 'numeric');
            app.numberofcyclesperSampEncalculationEditField.Limits = [5 100];
            app.numberofcyclesperSampEncalculationEditField.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.numberofcyclesperSampEncalculationEditField.Tooltip = {'for men 10, for women 20. overlap is n-1'};
            app.numberofcyclesperSampEncalculationEditField.Layout.Row = 14;
            app.numberofcyclesperSampEncalculationEditField.Layout.Column = 4;
            app.numberofcyclesperSampEncalculationEditField.Value = 10;

            % Create Panel
            app.Panel = uipanel(app.GridLayout);
            app.Panel.BorderType = 'none';
            app.Panel.Layout.Row = [1 15];
            app.Panel.Layout.Column = [1 2];

            % Create usethisasnewdataandcloseButton
            app.usethisasnewdataandcloseButton = uibutton(app.GridLayout, 'push');
            app.usethisasnewdataandcloseButton.ButtonPushedFcn = createCallbackFcn(app, @usethisasnewdataandcloseButtonPushed, true);
            app.usethisasnewdataandcloseButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.usethisasnewdataandcloseButton.Layout.Row = 15;
            app.usethisasnewdataandcloseButton.Layout.Column = 4;
            app.usethisasnewdataandcloseButton.Text = 'use this as new data and close';

            % Create AlsoexportcyclefrequencyCheckBox
            app.AlsoexportcyclefrequencyCheckBox = uicheckbox(app.GridLayout);
            app.AlsoexportcyclefrequencyCheckBox.Text = 'Also export cycle frequency';
            app.AlsoexportcyclefrequencyCheckBox.Layout.Row = 15;
            app.AlsoexportcyclefrequencyCheckBox.Layout.Column = 3;
            app.AlsoexportcyclefrequencyCheckBox.Value = true;

            % Create uselogarithmicyscaleCheckBox
            app.uselogarithmicyscaleCheckBox = uicheckbox(app.GridLayout);
            app.uselogarithmicyscaleCheckBox.ValueChangedFcn = createCallbackFcn(app, @uselogarithmicyscaleCheckBoxValueChanged, true);
            app.uselogarithmicyscaleCheckBox.Text = 'use logarithmic y scale';
            app.uselogarithmicyscaleCheckBox.Layout.Row = 11;
            app.uselogarithmicyscaleCheckBox.Layout.Column = 3;
            app.uselogarithmicyscaleCheckBox.Value = true;

            % Create MinpeakvalueHilbertrelativetodatamximum90SliderLabel
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel = uilabel(app.GridLayout);
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.HorizontalAlignment = 'center';
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.WordWrap = 'on';
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.FontWeight = 'bold';
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.Layout.Row = 9;
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.Layout.Column = [3 4];
            app.MinpeakvalueHilbertrelativetodatamximum90SliderLabel.Text = 'Min peak value, relative to data mximum: 90%';

            % Create MinpeakvalueHilbertrelativetodatamximum90Slider
            app.MinpeakvalueHilbertrelativetodatamximum90Slider = uislider(app.GridLayout);
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.Limits = [0 95];
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.ValueChangedFcn = createCallbackFcn(app, @generalCycleRefreshCallback, true);
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.ValueChangingFcn = createCallbackFcn(app, @MinpeakvalueHilbertrelativetodatamximum90SliderValueChanging, true);
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.Layout.Row = 10;
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.Layout.Column = [3 4];
            app.MinpeakvalueHilbertrelativetodatamximum90Slider.Value = 90;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SampEnApp(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
