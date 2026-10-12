
classdef interactiveFiltering < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        currentStateLamp                matlab.ui.control.Lamp
        currentStateLampLabel           matlab.ui.control.Label
        TabGroup2                       matlab.ui.container.TabGroup
        timedomainTab                   matlab.ui.container.Tab
        GridLayout12                    matlab.ui.container.GridLayout
        timeDataPlotAxis                matlab.ui.control.UIAxes
        spectrumTab                     matlab.ui.container.Tab
        GridLayout13                    matlab.ui.container.GridLayout
        spectrumPlotAxis                matlab.ui.control.UIAxes
        GridLayout2                     matlab.ui.container.GridLayout
        NonspectralsmoothingPanel       matlab.ui.container.Panel
        GridLayout14                    matlab.ui.container.GridLayout
        leavenonoutliersuntouchedCheckBox  matlab.ui.control.CheckBox
        WindowlengthEditField           matlab.ui.control.NumericEditField
        WindowlengthLabel               matlab.ui.control.Label
        MethodDropDown                  matlab.ui.control.DropDown
        MethodDropDownLabel             matlab.ui.control.Label
        activatewindowedsmoothingCheckBox  matlab.ui.control.CheckBox
        FilterunspecificoptionsPanel    matlab.ui.container.Panel
        GridLayout9                     matlab.ui.container.GridLayout
        Preserve0valuesandclipbelowCheckBox  matlab.ui.control.CheckBox
        listentofiltereddataButton      matlab.ui.control.StateButton
        listentooriginaldataButton      matlab.ui.control.StateButton
        UsecurrentresultsandcloseButton  matlab.ui.control.Button
        PaddingmethodDropDown           matlab.ui.control.DropDown
        PaddingmethodLabel              matlab.ui.control.Label
        filterforwardandbackwardCheckBox  matlab.ui.control.CheckBox
        MagnitudespecificationsdBPanel  matlab.ui.container.Panel
        GridLayout8                     matlab.ui.container.GridLayout
        A_stop2EditField                matlab.ui.control.NumericEditField
        A_stop2EditFieldLabel           matlab.ui.control.Label
        A_pass2EditField                matlab.ui.control.NumericEditField
        A_pass2EditFieldLabel           matlab.ui.control.Label
        A_stop1EditField                matlab.ui.control.NumericEditField
        A_stop1EditFieldLabel           matlab.ui.control.Label
        A_pass1EditField                matlab.ui.control.NumericEditField
        A_pass1EditFieldLabel           matlab.ui.control.Label
        FrequencyspecificationsHzPanel  matlab.ui.container.Panel
        GridLayout7                     matlab.ui.container.GridLayout
        matchexactlyDropDown            matlab.ui.control.DropDown
        matchexactlyLabel               matlab.ui.control.Label
        f_stop2EditField                matlab.ui.control.NumericEditField
        f_stop2EditFieldLabel           matlab.ui.control.Label
        f_pass2EditField                matlab.ui.control.NumericEditField
        f_pass2EditFieldLabel           matlab.ui.control.Label
        f_stop1EditField                matlab.ui.control.NumericEditField
        f_stop1EditFieldLabel           matlab.ui.control.Label
        f_pass1EditField                matlab.ui.control.NumericEditField
        f_pass1EditFieldLabel           matlab.ui.control.Label
        GridLayout6                     matlab.ui.container.GridLayout
        DesignMethodButtonGroup         matlab.ui.container.ButtonGroup
        DesignMethodDropDown            matlab.ui.control.DropDown
        IIRButton                       matlab.ui.control.RadioButton
        ResponseTypeButtonGroup         matlab.ui.container.ButtonGroup
        bandstopButton                  matlab.ui.control.RadioButton
        bandpassButton                  matlab.ui.control.RadioButton
        highpassButton                  matlab.ui.control.RadioButton
        lowpassButton                   matlab.ui.control.RadioButton
        combButton                      matlab.ui.control.RadioButton
        TabGroup                        matlab.ui.container.TabGroup
        spectralmagnitudeTab            matlab.ui.container.Tab
        GridLayout5                     matlab.ui.container.GridLayout
        FilterAmplitudePlotAxis         matlab.ui.control.UIAxes
        phasedelayTab                   matlab.ui.container.Tab
        GridLayout10                    matlab.ui.container.GridLayout
        FilterPhaseDelayPlotAxis        matlab.ui.control.UIAxes
        groupdelayTab                   matlab.ui.container.Tab
        GridLayout11                    matlab.ui.container.GridLayout
        FilterGroupDelayPlotAxis        matlab.ui.control.UIAxes
        FilterinformationPanel          matlab.ui.container.Panel
        GridLayout3                     matlab.ui.container.GridLayout
        FilterInformationTable          matlab.ui.control.Table
        InteractiveFilteringLabel       matlab.ui.control.Label
    end

    
    properties (Access = public)
        originalData = sin(2*pi*1*(0:1/20000:0.7))+0.1*sin(2*pi*1000*(0:1/20000:0.7)); % Description
        originalFs = 20000; % Description
        filteredData = [];
%         filteredComplementaryData = [];
        finalOutputData = []; % Description
    end
    
    properties (Access = private)
        filterObj = []; % Description
        originalTimeDataHandle = gobjects(1); % Description
        filteredTimeDataHandle= gobjects(1);
        removedTimeDataHandle = gobjects(1);

        originalSpectrumHandle = gobjects(1);
        filteredSpectrumHandle = gobjects(1);

        lastSuccessfullFilter=[]; % Description
        calledFromButton = 0; % Description
        axesErrorText = gobjects(0); % Description
%         lastSuccessfullComplementaryFilter = [];% Description
    end
    
    methods (Access = public)
        
        function createFilter(app)

            match=app.matchexactlyDropDown.Value;

            if app.filterforwardandbackwardCheckBox.Value==1
                factor=0.5;
            else
                factor=1;
            end


            if app.bandpassButton.Value==1
                app.lastSuccessfullFilter=designfilt('bandpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
                    'MatchExactly',match,'SampleRate',app.originalFs,...
                    'StopbandFrequency1',app.f_stop1EditField.Value,...
                    'PassbandFrequency1',app.f_pass1EditField.Value,...
                    'PassbandFrequency2',app.f_pass2EditField.Value,...
                    'StopbandFrequency2',app.f_stop2EditField.Value,...
                    'StopbandAttenuation1',factor*app.A_stop1EditField.Value,...
                    'PassbandRipple',factor*app.A_pass1EditField.Value,...
                    'StopbandAttenuation2',factor*app.A_stop2EditField.Value);
%                 att=factor*[app.A_stop1EditField.Value app.A_pass1EditField.Value app.A_stop2EditField.Value];
%                 app.lastSuccessfullComplementaryFilter=designfilt('bandstopiir','DesignMethod',app.DesignMethodDropDown.Value,...
%                     'MatchExactly',match,'SampleRate',app.originalFs,...
%                     'StopbandFrequency1',app.f_pass1EditField.Value,...
%                     'PassbandFrequency1',app.f_stop1EditField.Value,...
%                     'PassbandFrequency2',app.f_stop2EditField.Value,...
%                     'StopbandFrequency2',app.f_pass2EditField.Value,...
%                     'PassbandRipple1',max(att)-att(1)+1,...
%                     'StopbandAttenuation',max(att)-att(2)+1,...
%                     'PassbandRipple2',max(att)-att(3)+1);
            elseif app.lowpassButton.Value==1
                app.lastSuccessfullFilter=designfilt('lowpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
                    'MatchExactly',match,'SampleRate',app.originalFs,...
                    'PassbandFrequency',app.f_pass1EditField.Value,...
                    'StopbandFrequency',app.f_stop1EditField.Value,...
                    'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
                    'PassbandRipple',factor*app.A_pass1EditField.Value);
%                 app.lastSuccessfullComplementaryFilter=designfilt('highpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
%                     'MatchExactly',match,'SampleRate',app.originalFs,...
%                     'StopbandFrequency',app.f_pass1EditField.Value,...
%                     'PassbandFrequency',app.f_stop1EditField.Value,...
%                     'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
%                     'PassbandRipple',factor*app.A_pass1EditField.Value);

            elseif app.highpassButton.Value==1
                app.lastSuccessfullFilter=designfilt('highpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
                    'MatchExactly',match,'SampleRate',app.originalFs,...
                    'StopbandFrequency',app.f_stop1EditField.Value,...
                    'PassbandFrequency',app.f_pass1EditField.Value,...
                    'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
                    'PassbandRipple',factor*app.A_pass1EditField.Value);
%                 app.lastSuccessfullComplementaryFilter=designfilt('lowpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
%                     'MatchExactly',match,'SampleRate',app.originalFs,...
%                     'PassbandFrequency',app.f_stop1EditField.Value,...
%                     'StopbandFrequency',app.f_pass1EditField.Value,...
%                     'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
%                     'PassbandRipple',factor*app.A_pass1EditField.Value);

            elseif app.bandstopButton.Value==1
                app.lastSuccessfullFilter=designfilt('bandstopiir','DesignMethod',app.DesignMethodDropDown.Value,...
                    'MatchExactly',match,'SampleRate',app.originalFs,...
                    'PassbandFrequency1',app.f_pass1EditField.Value,...
                    'StopbandFrequency1',app.f_stop1EditField.Value,...
                    'StopbandFrequency2',app.f_stop2EditField.Value,...
                    'PassbandFrequency2',app.f_pass2EditField.Value,...
                    'PassbandRipple1',factor*app.A_pass1EditField.Value,...
                    'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
                    'PassbandRipple2',factor*app.A_pass2EditField.Value);
%                 att=factor*[app.A_pass1EditField.Value app.A_stop1EditField.Value app.A_pass2EditField.Value];
%                 app.lastSuccessfullComplementaryFilter=designfilt('bandpassiir','DesignMethod',app.DesignMethodDropDown.Value,...
%                     'MatchExactly',match,'SampleRate',app.originalFs,...
%                     'StopbandFrequency1',app.f_pass1EditField.Value,...
%                     'PassbandFrequency1',app.f_stop1EditField.Value,...
%                     'PassbandFrequency2',app.f_stop2EditField.Value,...
%                     'StopbandFrequency2',app.f_pass2EditField.Value,...
%                     'StopbandAttenuation1',max(att)-att(1)+1,...
%                     'PassbandRipple',max(att)-att(2)+1,...
%                     'StopbandAttenuation2',max(att)-att(3)+1);
            elseif app.combButton.Value==1
                % Parameters from UI
                Fs = app.originalFs;
                f0 = app.f_stop1EditField.Value;            % fundamental frequency in Hz
                BW_Hz = app.f_pass1EditField.Value;       % bandwidth in Hz (per notch)
                BW_Gain_dB = factor*-3;% dB where BW is measured (e.g. -3)
            
               
                % number of notches so highest harmonic <= Nyquist
                numNotches = floor((Fs/2) / f0)*2;
                
                shelvingFilterOrder=1;
            
                % designfilt notchiir expects Bandwidth as normalized (or Hz if SampleRate used)
                % use BandwidthUnits = 'Hz' by providing Bandwidth in Hz and SampleRate
                % app.lastSuccessfullFilter = designfilt('notchiir', ...
                %     'NotchLocations', 'Harmonic', ...
                %     'NumNotches', numNotches, ...
                %     'Bandwidth', BW_Hz, ...
                %     'BandwidthGain', BW_Gain_dB, ...
                %     'SampleRate', Fs, ...
                %     'ShelvingFilterOrder',shelvingFilterOrder,...
                %     'SystemObject', true);  % set true if you prefer System object
                % app.lastSuccessfullFilter=sos(app.lastSuccessfullFilter);

                app.lastSuccessfullFilter = designfilt('notchiir', ...
                    'NotchLocations', 'Specify', ...
                    'CenterFrequency', f0:f0:Fs/2, ...
                    'Bandwidth', BW_Hz, ...
                    'PassbandRipple', factor*app.A_pass1EditField.Value, ...
                    'SampleRate', Fs, ...
                    'StopbandAttenuation',factor*app.A_stop1EditField.Value,...
                    'FilterOrder',2,...
                    'SystemObject', true);  % set true if you prefer System object


                

            end            

            if app.combButton.Value~=1
                app.FilterInformationTable.Data{3,2}=num2str(app.lastSuccessfullFilter.SampleRate);
                app.FilterInformationTable.Data{2,2}=num2str(size(app.lastSuccessfullFilter.Coefficients,1));
                app.FilterInformationTable.Data{1,2}=num2str(1/factor*2*size(app.lastSuccessfullFilter.Coefficients,1));
            else
                app.FilterInformationTable.Data{3,2}=num2str(Fs);
                app.FilterInformationTable.Data{2,2}=num2str(numel(app.lastSuccessfullFilter.Numerator));
                app.FilterInformationTable.Data{1,2}=num2str(1/factor*2*numel(app.lastSuccessfullFilter.Numerator));
            end
        end
        
        function refreshDataPlot(app)

            app.currentStateLamp.Color=[1 0 0];
            app.currentStateLampLabel.Text='updating data plot...';

            t=(0:numel(app.originalData)-1)/app.originalFs;
            delete(app.originalTimeDataHandle);
            delete(app.filteredTimeDataHandle);

            delete(app.originalSpectrumHandle);
            delete(app.filteredSpectrumHandle);
            %delete(app.removedDataHandle);

            app.originalTimeDataHandle=line(app.timeDataPlotAxis,t,app.originalData,'LineWidth',1,'Color','b','DisplayName','original data');

            [originalDataFFT,f]=spectrogram(app.originalData,numel(app.originalData),0,numel(app.originalData),app.originalFs);
            app.originalSpectrumHandle=line(app.spectrumPlotAxis,f,20*log10(abs(originalDataFFT)),'LineWidth',1,'Color','b','DisplayName','original');

            if ~isempty(app.filteredData)
                app.filteredTimeDataHandle=line(app.timeDataPlotAxis,t(:),app.filteredData(:),'LineWidth',1,'Color','r','LineStyle','-','DisplayName','filtered data');
                %app.removedDataHandle= line(app.timeDataPlotAxis,t,app.filteredComplementaryData,'LineWidth',1,'Color','g','LineStyle','-','DisplayName','removed data');

                [filteredDataFFT,f]=spectrogram(app.filteredData,numel(app.filteredData),0,numel(app.filteredData),app.originalFs);
                app.filteredSpectrumHandle=line(app.spectrumPlotAxis,f(:),20*log10(abs(filteredDataFFT(:))),'LineWidth',1,'Color','r','LineStyle','-','DisplayName','filtered');
            end



            legend(app.timeDataPlotAxis,'Orientation','horizontal');
            legend(app.spectrumPlotAxis,'Orientation','horizontal');

            
            
            drawnow;

            app.currentStateLamp.Color=[0 1 0];
            app.currentStateLampLabel.Text='Plots are up to date';
        end
        
        function setFreqMaxValues(app)
            app.f_pass1EditField.Limits(2)=app.originalFs/2-1;
            app.f_pass2EditField.Limits(2)=app.originalFs/2-1;
            app.f_stop1EditField.Limits(2)=app.originalFs/2-1;
            app.f_stop2EditField.Limits(2)=app.originalFs/2-1;
        end

        
        function refreshFilterPlot(app)

            app.currentStateLamp.Color=[1 0 0];
            app.currentStateLampLabel.Text='updating filter plot...';

            try
                app.createFilter();
            catch ME
                app.filteredData=[];
%                 app.filteredComplementaryData=[];
                app.UsecurrentresultsandcloseButton.Enable='off';
                delete(app.filteredTimeDataHandle);
                delete(app.FilterAmplitudePlotAxis.Children);
                delete(app.FilterPhaseDelayPlotAxis.Children);
                delete(app.FilterGroupDelayPlotAxis.Children);
                disp('error while creating new filter');
                disp(ME.getReport);

                app.addTextToAxes(ME.message);
                
                return;
            end
            app.UsecurrentresultsandcloseButton.Enable='on';

            if ~isempty(app.lastSuccessfullFilter)

                nPoints=app.originalFs/2;

                %nPoints=1024;

                %% frequency magnitude response
                [h,f] = freqz(app.lastSuccessfullFilter,nPoints,app.originalFs);

                mag=20*log10(abs(h));

                if app.filterforwardandbackwardCheckBox.Value==1
                    mag=2*mag;
                end

                semilogx(app.FilterAmplitudePlotAxis,f,mag,'LineWidth',1);
                
                if ~app.combButton.Value
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_pass1EditField.Value,'k','f_{pass}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom','HitTest','off');
                    uistack(xl,"bottom");
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_stop1EditField.Value,'k','f_{stop}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','top','HitTest','off');
                    uistack(xl,"bottom");
                else
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_stop1EditField.Value+ 0.5*[-1 1]*app.f_pass1EditField.Value,'k','BW','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom','HitTest','off');
                    arrayfun(@(in) uistack(in,"bottom"),xl);
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_stop1EditField.Value,'k','f_{stop}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','top','HitTest','off');
                    uistack(xl,"bottom");



                end


                if app.bandpassButton.Value || app.bandstopButton.Value    % strcmp(app.f_pass2EditField.Visible,'on') % bandpass or bandstop
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_pass2EditField.Value,'k','f_{pass2}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom','HitTest','off');
                    uistack(xl,"bottom");
                    xl=xline(app.FilterAmplitudePlotAxis,app.f_stop2EditField.Value,'k','f_{stop2}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','top','HitTest','off');
                    uistack(xl,"bottom");

                %% organize xlims
                    if app.bandpassButton.Value % bandpass
                        lowXBorder=f(find(mag>-app.f_stop1EditField.Value,1,'first'));
                        highXBorder=f(find(mag>-app.A_stop2EditField.Value,1,'last'));
                    else % bandstop
                        lowXBorder=f(find(mag<-app.f_pass1EditField.Value,1,'first'));
                        highXBorder=f(find(mag<-app.A_pass2EditField.Value,1,'last'));
                    end
                    minimumStop=min(app.A_stop1EditField.Value,app.A_stop2EditField.Value);
                    
                else
                    if app.lowpassButton.Value % lowpass
                        lowXBorder=f(find(mag<-1,1));
                        highXBorder=f(find(mag<-app.A_stop1EditField.Value,1));
                    elseif app.highpassButton.Value % highpass
                        lowXBorder=f(find(mag>-app.A_stop1EditField.Value,1));
                        highXBorder=f(find(mag>-1,1));
                    elseif app.combButton.Value % comb
                        lowXBorder=app.f_stop1EditField.Value-0.5*app.f_pass1EditField.Value;
                        highXBorder=2*app.f_stop1EditField.Value+0.5*app.f_pass1EditField.Value;
                    end
                    minimumStop=app.A_stop1EditField.Value;
                end

                %newXLims=[lowXBorder highXBorder]+[-1.1 1.1]*(highXBorder-lowXBorder);

                newXLims=[lowXBorder highXBorder].*[0.9 1.1];
                newXLims(1)=max(0,newXLims(1));
                newXLims(2)=min(app.originalFs/2,newXLims(2));
                allAxes=[app.FilterAmplitudePlotAxis app.FilterGroupDelayPlotAxis app.FilterPhaseDelayPlotAxis];
                xlim(allAxes,newXLims);
                ylim(app.FilterAmplitudePlotAxis,[-minimumStop 0]+[-0.2 0.1]*minimumStop);

                drawnow;

                

                %% frequency phase delay
                if ~app.filterforwardandbackwardCheckBox.Value
                    [delay,f] = phasedelay(app.lastSuccessfullFilter,nPoints,app.originalFs);
    
                    delay=delay/app.originalFs;
                    delay=delay*1000; % to ms

                else

                    
                    f=1:app.originalFs/2;
                    delay=zeros(size(f));
                

                % if app.filterforwardandbackwardCheckBox.Value==1
                %     delay=delay-delay;
                end

                semilogx(app.FilterPhaseDelayPlotAxis,f,delay,'LineWidth',1);
                
                xl=xline(app.FilterPhaseDelayPlotAxis,app.f_pass1EditField.Value,'k','f_{pass}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom','HitTest','off');
                uistack(xl,"bottom");
                xl=xline(app.FilterPhaseDelayPlotAxis,app.f_stop1EditField.Value,'k','f_{stop}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','top','HitTest','off');
                uistack(xl,"bottom");

                if strcmp(app.f_pass2EditField.Visible,'on')
                    xl=xline(app.FilterPhaseDelayPlotAxis,app.f_pass2EditField.Value,'k','f_{pass2}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom','HitTest','off');
                    uistack(xl,"bottom");
                    xl=xline(app.FilterPhaseDelayPlotAxis,app.f_stop2EditField.Value,'k','f_{stop2}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','top','HitTest','off');
                    uistack(xl,"bottom");
                end

                %% frequency group delay
                               
                if app.filterforwardandbackwardCheckBox.Value~=1
                    [delay,f] = grpdelay(app.lastSuccessfullFilter,nPoints,app.originalFs);
    
                    delay=delay/app.originalFs;
                    delay=delay*1000; % to ms

                else
                    f=1:app.originalFs/2;
                    delay=zeros(size(f));
                

                % if app.filterforwardandbackwardCheckBox.Value==1
                %     delay=delay-delay;
                end

                semilogx(app.FilterGroupDelayPlotAxis,f,delay,'LineWidth',1);
                
                xl=xline(app.FilterGroupDelayPlotAxis,[app.f_pass1EditField.Value app.f_stop1EditField.Value],'k',{'f_{pass}','f_{stop}'},'LineWidth',1,'LabelHorizontalAlignment','center');
                uistack(xl,"bottom");

                if strcmp(app.f_pass2EditField.Visible,'on')
                    xl=xline(app.FilterGroupDelayPlotAxis,[app.f_pass2EditField.Value app.f_stop2EditField.Value],'k',{'f_{pass2}' 'f_{stop2}'},'LineWidth',1,'LabelHorizontalAlignment','center');
                    uistack(xl,"bottom");
                end

                %% window based filtering
                if app.activatewindowedsmoothingCheckBox.Value==1
                    if ~app.leavenonoutliersuntouchedCheckBox.Value
                        windowbasedFilteredData=smoothdata(app.originalData(:),app.MethodDropDown.Value,app.WindowlengthEditField.Value);
                    else
                        windowbasedFilteredData=filloutliers(app.originalData(:),"pchip",app.MethodDropDown.Value,app.WindowlengthEditField.Value);
                    end
                else
                    windowbasedFilteredData=app.originalData;
                end

                %% data padding and spectral filtering

                if ~strcmp(app.PaddingmethodDropDown.Value,'no padding')
                    padAmount=10*str2double(app.FilterInformationTable.Data{1,2});
                    %padAmount=numel(app.originalData);
                    paddedData=padarray(windowbasedFilteredData(:),[padAmount 0],app.PaddingmethodDropDown.Value,"both");
                    dataWasPadded=1;
                else
                    paddedData=windowbasedFilteredData;
                    dataWasPadded=0;
                end

                if app.filterforwardandbackwardCheckBox.Value==1

                    if ~isa(app.lastSuccessfullFilter,'dsp.SOSFilter') % if not comb
                        paddedAndFilteredData=filtfilt(app.lastSuccessfullFilter,paddedData);
                    else
                        sosMat = [app.lastSuccessfullFilter.Numerator, app.lastSuccessfullFilter.Denominator]; g=app.lastSuccessfullFilter.ScaleValues;
                        paddedAndFilteredData=filtfilt(sosMat,g,paddedData);

                        %paddedAndFilteredData=filtfilt(app.lastSuccessfullFilter.Numerator,app.lastSuccessfullFilter.Denominator,paddedData);
                    end


%                     paddedAndFilteredComplementaryData=filtfilt(app.lastSuccessfullComplementaryFilter,paddedData);
                else
                    if ~isa(app.lastSuccessfullFilter,'dsp.SOSFilter') % if not comb
                        paddedAndFilteredData=filter(app.lastSuccessfullFilter,paddedData);
                    else
                        paddedAndFilteredData=app.lastSuccessfullFilter(paddedData);
                    end

%                     paddedAndFilteredComplementaryData=filter(app.lastSuccessfullComplementaryFilter,paddedData);
                end

                if app.Preserve0valuesandclipbelowCheckBox.Value==1
                    paddedAndFilteredData(paddedData==0)=0;
                    paddedAndFilteredData(paddedAndFilteredData<0)=0;
                end


                if dataWasPadded==1
                    app.filteredData=paddedAndFilteredData(padAmount+1:end-padAmount);
%                     app.filteredComplementaryData=paddedAndFilteredComplementaryData(paddedLength/3+1:paddedLength*2/3);
                else
                    app.filteredData=paddedAndFilteredData;
%                     app.filteredComplementaryData=paddedAndFilteredComplementaryData;
                end

                % figure; tiledlayout(3,1); nexttile(1); plot(app.originalData); nexttile(2); plot(app.filteredData); nexttile(3); plot(app.filteredComplementaryData)
            end
            
        end
    end
    
    methods (Access = private)
        
        function addTextToAxes(app,msg)
            wrappedText = autoWrapText(msg, 30);


            listOfAxes=findobj(app.TabGroup,'type','axes');
            
            for axNr=1:numel(listOfAxes)
                % Get the position of the current axes
                text(listOfAxes(axNr), 0.5, 0.5, sprintf(wrappedText), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle', ...
                    'Units', 'normalized', ...
                    'FontSize', 14,'Interpreter','none');



            end

            %% nested function
            function wrappedText = autoWrapText(text, maxCharsPerLine)
                % Break text into lines based on maxCharsPerLine
                words = strsplit(text, ' ');
                wrappedText = "";
                currentLine = "";
                
                for i = 1:length(words)
                    if strlength(currentLine) + strlength(words{i}) + 1 <= maxCharsPerLine
                        % Add word to current line
                        currentLine = currentLine + " " + words{i};
                    else
                        % Start a new line
                        wrappedText = wrappedText + currentLine + "\n";
                        currentLine = words{i};
                    end
                end
                % Add remaining text
                wrappedText = wrappedText + currentLine;
            end
            
        end
        
        function generalRefreshFcn(app)
            progDiag=uiprogressdlg(app.UIFigure,'Title','Processing...','Message','refreshing filter...');
            app.refreshFilterPlot();
            progDiag.Message='refreshing data plot...';
            app.refreshDataPlot();
            delete(progDiag);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.UIFigure.Visible="off";
            drawnow;
            app.FilterInformationTable.Data={'Order'     ,'NaN';
                                            'Sections'  ,'NaN' 
                                            'Fs'        ,'NaN'};

            app.DesignMethodDropDown.ItemsData={'butter','cheby1','cheby2','ellip'};

            linkaxes([app.FilterAmplitudePlotAxis app.FilterGroupDelayPlotAxis app.FilterPhaseDelayPlotAxis],'x');

            set([app.timeDataPlotAxis app.spectrumPlotAxis],'Interactions',[panInteraction zoomInteraction('Dimensions','x')]);
            app.timeDataPlotAxis.YLimitMethod="padded";

            addlistener(app.timeDataPlotAxis,'XLim','PostSet',@(~,~) maxYlim(app.timeDataPlotAxis));
            addlistener(app.spectrumPlotAxis,'XLim','PostSet',@(~,~) maxYlim(app.spectrumPlotAxis));

            function maxYlim(ax)
                ylim(ax,'padded');
                pause(0.1);
                %drawnow limitrate;

            end

            %% when we start that part of the app only, it us useful
            movegui(app.UIFigure,'center');

            drawnow;
            figure(app.UIFigure);
            app.UIFigure.Visible="on";
        end

        % Value changed function: DesignMethodDropDown
        function DesignMethodDropDownValueChanged(app, event)
            value = app.DesignMethodDropDown.Value;
            if strcmp(value,'ellip')
                app.matchexactlyDropDown.Items={'passband','stopband','both'};
                app.matchexactlyDropDown.Value='both';
            elseif strcmp(value,'cheby1')
                app.matchexactlyDropDown.Items={'passband','stopband'};
                app.matchexactlyDropDown.Value='passband';
            else
                app.matchexactlyDropDown.Items={'passband','stopband'};
                app.matchexactlyDropDown.Value='stopband';
            end

            app.generalRefreshFcn();

        end

        % Selection changed function: ResponseTypeButtonGroup
        function ResponseTypeButtonGroupSelectionChanged(app, event)
            
            if app.lowpassButton.Value==1
                app.f_pass1EditFieldLabel.Text='$f_{pass1}$';
                app.DesignMethodDropDown.Visible='on';
                app.matchexactlyDropDown.Visible='on';

                app.A_pass1EditField.Visible='on';
                app.A_pass1EditFieldLabel.Visible='on';
                app.A_stop1EditField.Visible='on';
                app.A_stop1EditFieldLabel.Visible='on';
                app.A_pass1EditField.Layout.Row=1;
                app.A_pass1EditFieldLabel.Layout.Row=1;
                app.A_stop1EditField.Layout.Row=2;
                app.A_stop1EditFieldLabel.Layout.Row=2;


                app.A_pass2EditField.Visible="off";
                app.A_pass2EditFieldLabel.Visible='off';
                app.A_stop2EditField.Visible="off";
                app.A_stop2EditFieldLabel.Visible='off';

                app.f_pass2EditField.Visible='off';
                app.f_pass2EditFieldLabel.Visible='off';
                app.f_stop2EditField.Visible='off';
                app.f_stop2EditFieldLabel.Visible='off';

                app.f_pass1EditField.Layout.Row=1;
                app.f_pass1EditFieldLabel.Layout.Row=1;
                app.f_stop1EditField.Layout.Row=2;
                app.f_stop1EditFieldLabel.Layout.Row=2;
            elseif app.highpassButton.Value==1
                app.f_pass1EditFieldLabel.Text='$f_{pass1}$';
                app.DesignMethodDropDown.Visible='on';
                app.matchexactlyDropDown.Visible='on';

                app.A_pass1EditField.Visible='on';
                app.A_pass1EditFieldLabel.Visible='on';
                app.A_stop1EditField.Visible='on';
                app.A_stop1EditFieldLabel.Visible='on';
                app.A_pass2EditField.Visible="off";
                app.A_pass2EditFieldLabel.Visible='off';
                app.A_stop2EditField.Visible="off";
                app.A_stop2EditFieldLabel.Visible='off';

                app.A_pass1EditField.Layout.Row=2;
                app.A_pass1EditFieldLabel.Layout.Row=2;
                app.A_stop1EditField.Layout.Row=1;
                app.A_stop1EditFieldLabel.Layout.Row=1;

                app.f_pass2EditField.Visible='off';
                app.f_pass2EditFieldLabel.Visible='off';
                app.f_stop2EditField.Visible='off';
                app.f_stop2EditFieldLabel.Visible='off';

                app.f_pass1EditField.Layout.Row=2;
                app.f_pass1EditFieldLabel.Layout.Row=2;
                app.f_stop1EditField.Layout.Row=1;
                app.f_stop1EditFieldLabel.Layout.Row=1;
            elseif app.bandstopButton.Value==1
                app.f_pass1EditFieldLabel.Text='$f_{pass1}$';
                app.DesignMethodDropDown.Visible='on';
                app.matchexactlyDropDown.Visible='on';

                app.A_pass1EditField.Visible='on';
                app.A_pass1EditFieldLabel.Visible='on';
                app.A_stop1EditField.Visible='on';
                app.A_stop1EditFieldLabel.Visible='on';
                app.A_pass2EditField.Visible="on";
                app.A_pass2EditFieldLabel.Visible='on';
                app.A_stop2EditField.Visible="off";
                app.A_stop2EditFieldLabel.Visible='off';

                app.A_pass1EditField.Layout.Row=1;
                app.A_pass1EditFieldLabel.Layout.Row=1;
                app.A_stop1EditField.Layout.Row=2;
                app.A_stop1EditFieldLabel.Layout.Row=2;
                app.A_pass2EditField.Layout.Row=3;
                app.A_pass2EditFieldLabel.Layout.Row=3;

                app.f_pass2EditField.Visible='on';
                app.f_pass2EditFieldLabel.Visible='on';
                app.f_stop2EditField.Visible='on';
                app.f_stop2EditFieldLabel.Visible='on';

                app.f_pass1EditField.Layout.Row=1;
                app.f_pass1EditFieldLabel.Layout.Row=1;
                app.f_stop1EditField.Layout.Row=2;
                app.f_stop1EditFieldLabel.Layout.Row=2;
                app.f_pass2EditField.Layout.Row=4;
                app.f_pass2EditFieldLabel.Layout.Row=4;
                app.f_stop2EditField.Layout.Row=3;
                app.f_stop2EditFieldLabel.Layout.Row=3;
            elseif app.bandpassButton.Value==1
                app.f_pass1EditFieldLabel.Text='$f_{pass1}$';
                app.DesignMethodDropDown.Visible='on';
                app.matchexactlyDropDown.Visible='on';

                app.A_pass1EditField.Visible='on';
                app.A_pass1EditFieldLabel.Visible='on';
                app.A_stop1EditField.Visible='on';
                app.A_stop1EditFieldLabel.Visible='on';
                app.A_pass2EditField.Visible="off";
                app.A_pass2EditFieldLabel.Visible='off';
                app.A_stop2EditField.Visible="on";
                app.A_stop2EditFieldLabel.Visible='on';

                app.A_stop1EditField.Layout.Row=1;
                app.A_stop1EditFieldLabel.Layout.Row=1;
                app.A_pass1EditField.Layout.Row=2;
                app.A_pass1EditFieldLabel.Layout.Row=2;
                app.A_stop2EditField.Layout.Row=3;
                app.A_stop2EditFieldLabel.Layout.Row=3;

                app.f_pass2EditField.Visible='on';
                app.f_pass2EditFieldLabel.Visible='on';
                app.f_stop2EditField.Visible='on';
                app.f_stop2EditFieldLabel.Visible='on';

                app.f_pass1EditField.Layout.Row=2;
                app.f_pass1EditFieldLabel.Layout.Row=2;
                app.f_stop1EditField.Layout.Row=1;
                app.f_stop1EditFieldLabel.Layout.Row=1;
                app.f_pass2EditField.Layout.Row=3;
                app.f_pass2EditFieldLabel.Layout.Row=3;
                app.f_stop2EditField.Layout.Row=4;
                app.f_stop2EditFieldLabel.Layout.Row=4;
            else % comb filter
                app.f_pass1EditFieldLabel.Text='comb bandwidth';
                app.DesignMethodDropDown.Visible='off';
                app.matchexactlyDropDown.Visible='off';

                app.A_pass1EditField.Visible='on';
                app.A_pass1EditFieldLabel.Visible='on';
                app.A_stop1EditField.Visible='on';
                app.A_stop1EditFieldLabel.Visible='on';
                app.A_pass1EditField.Layout.Row=1;
                app.A_pass1EditFieldLabel.Layout.Row=1;
                app.A_stop1EditField.Layout.Row=2;
                app.A_stop1EditFieldLabel.Layout.Row=2;


                app.A_pass2EditField.Visible="off";
                app.A_pass2EditFieldLabel.Visible='off';
                app.A_stop2EditField.Visible="off";
                app.A_stop2EditFieldLabel.Visible='off';

                app.f_pass2EditField.Visible='off';
                app.f_pass2EditFieldLabel.Visible='off';
                app.f_stop2EditField.Visible='off';
                app.f_stop2EditFieldLabel.Visible='off';

                app.f_pass1EditField.Layout.Row=1;
                app.f_pass1EditFieldLabel.Layout.Row=1;
                app.f_stop1EditField.Layout.Row=2;
                app.f_stop1EditFieldLabel.Layout.Row=2;

            end

            app.generalRefreshFcn();

        end

        % Button pushed function: UsecurrentresultsandcloseButton
        function UsecurrentresultsandcloseButtonPushed(app, event)
            app.finalOutputData=app.filteredData;
        end

        % Value changed function: listentooriginaldataButton
        function listentooriginaldataButtonValueChanged(app, event)
            value = app.listentooriginaldataButton.Value;
            
            persistent audioPlayerObj

            if isempty(audioPlayerObj) || value==1
                audioPlayerObj=audioplayer(rescale(app.originalData,-1,1),app.originalFs);
                audioPlayerObj.StopFcn=@(~,~) set(app.listentooriginaldataButton,'Value',0);
            end

            if value==1
                %set([app.listentofiltereddataButton app.listentoremoveddataButton],'Value',0)
                set([app.listentofiltereddataButton],'Value',0);
                if isplaying(audioPlayerObj)
                    stop(audioPlayerObj);
                end
                play(audioPlayerObj);
            else
                stop(audioPlayerObj);
            end
        end

        % Value changed function: listentofiltereddataButton
        function listentofiltereddataButtonValueChanged(app, event)
            value = app.listentofiltereddataButton.Value;

            if ~isvalid(app.filteredTimeDataHandle)
                app.listentofiltereddataButton.Value=0;
                return;
            end

            persistent audioPlayerObj

            if isempty(audioPlayerObj) || value==1
                dataToPlay=app.filteredData;
                %audioPlayerObj=audioplayer((range(dataToPlay)/range(app.originalData))*rescale(dataToPlay,-1,1),app.originalFs);
                audioPlayerObj=audioplayer(rescale(dataToPlay,-1,1),app.originalFs);
                audioPlayerObj.StopFcn=@(~,~) set(app.listentofiltereddataButton,'Value',0);
            end

            if value==1
                %set([app.listentooriginaldataButton app.listentoremoveddataButton],'Value',0)
                set([app.listentooriginaldataButton],'Value',0)
                if isplaying(audioPlayerObj)
                    stop(audioPlayerObj);
                end
                play(audioPlayerObj);
            else
                stop(audioPlayerObj);
            end
            
            
        end

        % Value changed function: A_pass1EditField, A_pass2EditField, 
        % ...and 12 other components
        function generalRefreshCallback(app, event)
            app.generalRefreshFcn();
        end

        % Value changed function: leavenonoutliersuntouchedCheckBox
        function leavenonoutliersuntouchedCheckBoxValueChanged(app, event)
            value = app.leavenonoutliersuntouchedCheckBox.Value;
            
            if value==1
                set(app.MethodDropDown,'Items',{'moving mean', 'moving median'},...
                    'ItemsData',{'movmean', 'movmedian'});
            else
                set(app.MethodDropDown,'Items',{'moving mean', 'moving median', 'gaussian weighting', 'windowed linear regression', 'windowed quadratic regression', 'windowed linear regression (robust)', 'windowed quadratic regression (robust)', 'Savitzky-Golay'},...
                    'ItemsData',{'movmean', 'movmedian', 'gaussian', 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'});
            end
            app.generalRefreshFcn();

        end

        % Value changed function: activatewindowedsmoothingCheckBox
        function activatewindowedsmoothingCheckBoxValueChanged(app, event)
            value = app.activatewindowedsmoothingCheckBox.Value;
            
            group=[app.leavenonoutliersuntouchedCheckBox app.MethodDropDown app.WindowlengthEditField];
            if value==1
                set(group,'Enable','on');
            else
                set(group,'Enable','off');
            end
            app.generalRefreshFcn();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 809 774];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Theme = 'light';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', 'fit', 'fit'};
            app.GridLayout.RowHeight = {'fit', '2x', '1x'};
            app.GridLayout.ColumnSpacing = 2;
            app.GridLayout.Padding = [0 0 0 0];

            % Create InteractiveFilteringLabel
            app.InteractiveFilteringLabel = uilabel(app.GridLayout);
            app.InteractiveFilteringLabel.FontSize = 16;
            app.InteractiveFilteringLabel.FontWeight = 'bold';
            app.InteractiveFilteringLabel.Layout.Row = 1;
            app.InteractiveFilteringLabel.Layout.Column = 1;
            app.InteractiveFilteringLabel.Text = 'Interactive Filtering';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.ColumnWidth = {'1x', 'fit', '1x', '1x'};
            app.GridLayout2.RowHeight = {'2x', '2x', '3x'};
            app.GridLayout2.ColumnSpacing = 0;
            app.GridLayout2.RowSpacing = 0;
            app.GridLayout2.Padding = [0 0 0 0];
            app.GridLayout2.Layout.Row = 2;
            app.GridLayout2.Layout.Column = [1 3];

            % Create FilterinformationPanel
            app.FilterinformationPanel = uipanel(app.GridLayout2);
            app.FilterinformationPanel.Title = 'Filter information';
            app.FilterinformationPanel.Layout.Row = 1;
            app.FilterinformationPanel.Layout.Column = 1;

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.FilterinformationPanel);
            app.GridLayout3.ColumnWidth = {'1x'};
            app.GridLayout3.RowHeight = {'1x'};
            app.GridLayout3.Padding = [0 0 0 0];

            % Create FilterInformationTable
            app.FilterInformationTable = uitable(app.GridLayout3);
            app.FilterInformationTable.ColumnName = '';
            app.FilterInformationTable.RowName = {};
            app.FilterInformationTable.RowStriping = 'off';
            app.FilterInformationTable.Layout.Row = 1;
            app.FilterInformationTable.Layout.Column = 1;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout2);
            app.TabGroup.Layout.Row = [1 2];
            app.TabGroup.Layout.Column = [2 4];

            % Create spectralmagnitudeTab
            app.spectralmagnitudeTab = uitab(app.TabGroup);
            app.spectralmagnitudeTab.Title = 'spectral magnitude';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.spectralmagnitudeTab);
            app.GridLayout5.ColumnWidth = {'1x'};
            app.GridLayout5.RowHeight = {'1x'};
            app.GridLayout5.ColumnSpacing = 0;
            app.GridLayout5.RowSpacing = 0;
            app.GridLayout5.Padding = [0 0 0 0];

            % Create FilterAmplitudePlotAxis
            app.FilterAmplitudePlotAxis = uiaxes(app.GridLayout5);
            title(app.FilterAmplitudePlotAxis, 'filter magnitude response')
            xlabel(app.FilterAmplitudePlotAxis, 'f (Hz)')
            ylabel(app.FilterAmplitudePlotAxis, 'Amplitude (dB)')
            zlabel(app.FilterAmplitudePlotAxis, 'Z')
            app.FilterAmplitudePlotAxis.Toolbar.Visible = 'off';
            app.FilterAmplitudePlotAxis.XLimitMethod = 'tight';
            app.FilterAmplitudePlotAxis.YLimitMethod = 'padded';
            app.FilterAmplitudePlotAxis.XGrid = 'on';
            app.FilterAmplitudePlotAxis.YGrid = 'on';
            app.FilterAmplitudePlotAxis.Layout.Row = 1;
            app.FilterAmplitudePlotAxis.Layout.Column = 1;

            % Create phasedelayTab
            app.phasedelayTab = uitab(app.TabGroup);
            app.phasedelayTab.Title = 'phase delay';

            % Create GridLayout10
            app.GridLayout10 = uigridlayout(app.phasedelayTab);
            app.GridLayout10.ColumnWidth = {'1x'};
            app.GridLayout10.RowHeight = {'1x'};
            app.GridLayout10.ColumnSpacing = 0;
            app.GridLayout10.RowSpacing = 0;
            app.GridLayout10.Padding = [0 0 0 0];

            % Create FilterPhaseDelayPlotAxis
            app.FilterPhaseDelayPlotAxis = uiaxes(app.GridLayout10);
            title(app.FilterPhaseDelayPlotAxis, 'filter phase delay')
            xlabel(app.FilterPhaseDelayPlotAxis, 'f (Hz)')
            ylabel(app.FilterPhaseDelayPlotAxis, 'Phase delay (ms)')
            zlabel(app.FilterPhaseDelayPlotAxis, 'Z')
            app.FilterPhaseDelayPlotAxis.Toolbar.Visible = 'off';
            app.FilterPhaseDelayPlotAxis.XLimitMethod = 'tight';
            app.FilterPhaseDelayPlotAxis.YLimitMethod = 'padded';
            app.FilterPhaseDelayPlotAxis.XGrid = 'on';
            app.FilterPhaseDelayPlotAxis.YGrid = 'on';
            app.FilterPhaseDelayPlotAxis.Layout.Row = 1;
            app.FilterPhaseDelayPlotAxis.Layout.Column = 1;

            % Create groupdelayTab
            app.groupdelayTab = uitab(app.TabGroup);
            app.groupdelayTab.Title = 'group delay';

            % Create GridLayout11
            app.GridLayout11 = uigridlayout(app.groupdelayTab);
            app.GridLayout11.ColumnWidth = {'1x'};
            app.GridLayout11.RowHeight = {'1x'};
            app.GridLayout11.ColumnSpacing = 0;
            app.GridLayout11.RowSpacing = 0;
            app.GridLayout11.Padding = [0 0 0 0];

            % Create FilterGroupDelayPlotAxis
            app.FilterGroupDelayPlotAxis = uiaxes(app.GridLayout11);
            title(app.FilterGroupDelayPlotAxis, 'filter group delay')
            xlabel(app.FilterGroupDelayPlotAxis, 'f (Hz)')
            ylabel(app.FilterGroupDelayPlotAxis, 'Group delay (ms)')
            zlabel(app.FilterGroupDelayPlotAxis, 'Z')
            app.FilterGroupDelayPlotAxis.Toolbar.Visible = 'off';
            app.FilterGroupDelayPlotAxis.XLimitMethod = 'tight';
            app.FilterGroupDelayPlotAxis.YLimitMethod = 'padded';
            app.FilterGroupDelayPlotAxis.XGrid = 'on';
            app.FilterGroupDelayPlotAxis.YGrid = 'on';
            app.FilterGroupDelayPlotAxis.Layout.Row = 1;
            app.FilterGroupDelayPlotAxis.Layout.Column = 1;

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.GridLayout2);
            app.GridLayout6.ColumnWidth = {'1x'};
            app.GridLayout6.ColumnSpacing = 0;
            app.GridLayout6.RowSpacing = 0;
            app.GridLayout6.Padding = [0 0 0 0];
            app.GridLayout6.Layout.Row = 3;
            app.GridLayout6.Layout.Column = 1;

            % Create ResponseTypeButtonGroup
            app.ResponseTypeButtonGroup = uibuttongroup(app.GridLayout6);
            app.ResponseTypeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ResponseTypeButtonGroupSelectionChanged, true);
            app.ResponseTypeButtonGroup.Title = 'Response Type';
            app.ResponseTypeButtonGroup.Layout.Row = [1 2];
            app.ResponseTypeButtonGroup.Layout.Column = 1;

            % Create combButton
            app.combButton = uiradiobutton(app.ResponseTypeButtonGroup);
            app.combButton.Text = 'comb';
            app.combButton.Position = [8 108 66 22];

            % Create lowpassButton
            app.lowpassButton = uiradiobutton(app.ResponseTypeButtonGroup);
            app.lowpassButton.Text = 'lowpass';
            app.lowpassButton.Position = [8 166 66 22];
            app.lowpassButton.Value = true;

            % Create highpassButton
            app.highpassButton = uiradiobutton(app.ResponseTypeButtonGroup);
            app.highpassButton.Text = 'highpass';
            app.highpassButton.Position = [8 135 70 22];

            % Create bandpassButton
            app.bandpassButton = uiradiobutton(app.ResponseTypeButtonGroup);
            app.bandpassButton.Text = 'bandpass';
            app.bandpassButton.Position = [90 135 74 22];

            % Create bandstopButton
            app.bandstopButton = uiradiobutton(app.ResponseTypeButtonGroup);
            app.bandstopButton.Text = 'bandstop';
            app.bandstopButton.Position = [90 166 71 22];

            % Create DesignMethodButtonGroup
            app.DesignMethodButtonGroup = uibuttongroup(app.GridLayout6);
            app.DesignMethodButtonGroup.Title = 'Design Method';
            app.DesignMethodButtonGroup.Layout.Row = 2;
            app.DesignMethodButtonGroup.Layout.Column = 1;

            % Create IIRButton
            app.IIRButton = uiradiobutton(app.DesignMethodButtonGroup);
            app.IIRButton.Text = 'IIR';
            app.IIRButton.Position = [5 58 42 22];
            app.IIRButton.Value = true;

            % Create DesignMethodDropDown
            app.DesignMethodDropDown = uidropdown(app.DesignMethodButtonGroup);
            app.DesignMethodDropDown.Items = {'Butterworth', 'Chebyshev Type I', 'Chebyshev Type II', 'Elliptic'};
            app.DesignMethodDropDown.ValueChangedFcn = createCallbackFcn(app, @DesignMethodDropDownValueChanged, true);
            app.DesignMethodDropDown.Position = [54 56 143 24];
            app.DesignMethodDropDown.Value = 'Butterworth';

            % Create FrequencyspecificationsHzPanel
            app.FrequencyspecificationsHzPanel = uipanel(app.GridLayout2);
            app.FrequencyspecificationsHzPanel.Title = 'Frequency specifications (Hz)';
            app.FrequencyspecificationsHzPanel.Layout.Row = 3;
            app.FrequencyspecificationsHzPanel.Layout.Column = 2;

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.FrequencyspecificationsHzPanel);
            app.GridLayout7.ColumnWidth = {'1x', '2x'};
            app.GridLayout7.RowHeight = {'1x', '1x', '1x', '1x', '1x'};
            app.GridLayout7.ColumnSpacing = 0;
            app.GridLayout7.RowSpacing = 1;
            app.GridLayout7.Padding = [0 0 0 0];

            % Create f_pass1EditFieldLabel
            app.f_pass1EditFieldLabel = uilabel(app.GridLayout7);
            app.f_pass1EditFieldLabel.HorizontalAlignment = 'right';
            app.f_pass1EditFieldLabel.WordWrap = 'on';
            app.f_pass1EditFieldLabel.Layout.Row = 1;
            app.f_pass1EditFieldLabel.Layout.Column = 1;
            app.f_pass1EditFieldLabel.Interpreter = 'latex';
            app.f_pass1EditFieldLabel.Text = '$f_{pass1}$';

            % Create f_pass1EditField
            app.f_pass1EditField = uieditfield(app.GridLayout7, 'numeric');
            app.f_pass1EditField.Limits = [1 Inf];
            app.f_pass1EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.f_pass1EditField.Layout.Row = 1;
            app.f_pass1EditField.Layout.Column = 2;
            app.f_pass1EditField.Value = 3000;

            % Create f_stop1EditFieldLabel
            app.f_stop1EditFieldLabel = uilabel(app.GridLayout7);
            app.f_stop1EditFieldLabel.HorizontalAlignment = 'right';
            app.f_stop1EditFieldLabel.WordWrap = 'on';
            app.f_stop1EditFieldLabel.Layout.Row = 2;
            app.f_stop1EditFieldLabel.Layout.Column = 1;
            app.f_stop1EditFieldLabel.Interpreter = 'latex';
            app.f_stop1EditFieldLabel.Text = '$f_{stop1}$';

            % Create f_stop1EditField
            app.f_stop1EditField = uieditfield(app.GridLayout7, 'numeric');
            app.f_stop1EditField.Limits = [1 Inf];
            app.f_stop1EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.f_stop1EditField.Layout.Row = 2;
            app.f_stop1EditField.Layout.Column = 2;
            app.f_stop1EditField.Value = 4000;

            % Create f_pass2EditFieldLabel
            app.f_pass2EditFieldLabel = uilabel(app.GridLayout7);
            app.f_pass2EditFieldLabel.HorizontalAlignment = 'right';
            app.f_pass2EditFieldLabel.WordWrap = 'on';
            app.f_pass2EditFieldLabel.Visible = 'off';
            app.f_pass2EditFieldLabel.Layout.Row = 4;
            app.f_pass2EditFieldLabel.Layout.Column = 1;
            app.f_pass2EditFieldLabel.Interpreter = 'latex';
            app.f_pass2EditFieldLabel.Text = '$f_{pass2}$';

            % Create f_pass2EditField
            app.f_pass2EditField = uieditfield(app.GridLayout7, 'numeric');
            app.f_pass2EditField.Limits = [1 Inf];
            app.f_pass2EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.f_pass2EditField.Visible = 'off';
            app.f_pass2EditField.Layout.Row = 4;
            app.f_pass2EditField.Layout.Column = 2;
            app.f_pass2EditField.Value = 4000;

            % Create f_stop2EditFieldLabel
            app.f_stop2EditFieldLabel = uilabel(app.GridLayout7);
            app.f_stop2EditFieldLabel.HorizontalAlignment = 'right';
            app.f_stop2EditFieldLabel.WordWrap = 'on';
            app.f_stop2EditFieldLabel.Visible = 'off';
            app.f_stop2EditFieldLabel.Layout.Row = 3;
            app.f_stop2EditFieldLabel.Layout.Column = 1;
            app.f_stop2EditFieldLabel.Interpreter = 'latex';
            app.f_stop2EditFieldLabel.Text = '$f_{stop2}$';

            % Create f_stop2EditField
            app.f_stop2EditField = uieditfield(app.GridLayout7, 'numeric');
            app.f_stop2EditField.Limits = [1 Inf];
            app.f_stop2EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.f_stop2EditField.Visible = 'off';
            app.f_stop2EditField.Layout.Row = 3;
            app.f_stop2EditField.Layout.Column = 2;
            app.f_stop2EditField.Value = 3000;

            % Create matchexactlyLabel
            app.matchexactlyLabel = uilabel(app.GridLayout7);
            app.matchexactlyLabel.HorizontalAlignment = 'right';
            app.matchexactlyLabel.WordWrap = 'on';
            app.matchexactlyLabel.FontSize = 10;
            app.matchexactlyLabel.Layout.Row = 5;
            app.matchexactlyLabel.Layout.Column = 1;
            app.matchexactlyLabel.Interpreter = 'latex';
            app.matchexactlyLabel.Text = {'match'; 'exactly'};

            % Create matchexactlyDropDown
            app.matchexactlyDropDown = uidropdown(app.GridLayout7);
            app.matchexactlyDropDown.Items = {'passband', 'stopband'};
            app.matchexactlyDropDown.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.matchexactlyDropDown.Layout.Row = 5;
            app.matchexactlyDropDown.Layout.Column = 2;
            app.matchexactlyDropDown.Value = 'passband';

            % Create MagnitudespecificationsdBPanel
            app.MagnitudespecificationsdBPanel = uipanel(app.GridLayout2);
            app.MagnitudespecificationsdBPanel.Title = 'Magnitude specifications (dB)';
            app.MagnitudespecificationsdBPanel.Layout.Row = 3;
            app.MagnitudespecificationsdBPanel.Layout.Column = 3;

            % Create GridLayout8
            app.GridLayout8 = uigridlayout(app.MagnitudespecificationsdBPanel);
            app.GridLayout8.ColumnWidth = {'1x', '2x'};
            app.GridLayout8.RowHeight = {'1x', '1x', '1x', '1x'};
            app.GridLayout8.ColumnSpacing = 0;
            app.GridLayout8.RowSpacing = 1;
            app.GridLayout8.Padding = [0 0 0 0];

            % Create A_pass1EditFieldLabel
            app.A_pass1EditFieldLabel = uilabel(app.GridLayout8);
            app.A_pass1EditFieldLabel.HorizontalAlignment = 'right';
            app.A_pass1EditFieldLabel.WordWrap = 'on';
            app.A_pass1EditFieldLabel.Layout.Row = 1;
            app.A_pass1EditFieldLabel.Layout.Column = 1;
            app.A_pass1EditFieldLabel.Interpreter = 'latex';
            app.A_pass1EditFieldLabel.Text = '$A_{pass1}$';

            % Create A_pass1EditField
            app.A_pass1EditField = uieditfield(app.GridLayout8, 'numeric');
            app.A_pass1EditField.Limits = [1 Inf];
            app.A_pass1EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.A_pass1EditField.Layout.Row = 1;
            app.A_pass1EditField.Layout.Column = 2;
            app.A_pass1EditField.Value = 1;

            % Create A_stop1EditFieldLabel
            app.A_stop1EditFieldLabel = uilabel(app.GridLayout8);
            app.A_stop1EditFieldLabel.HorizontalAlignment = 'right';
            app.A_stop1EditFieldLabel.WordWrap = 'on';
            app.A_stop1EditFieldLabel.Layout.Row = 2;
            app.A_stop1EditFieldLabel.Layout.Column = 1;
            app.A_stop1EditFieldLabel.Interpreter = 'latex';
            app.A_stop1EditFieldLabel.Text = '$A_{stop1}$';

            % Create A_stop1EditField
            app.A_stop1EditField = uieditfield(app.GridLayout8, 'numeric');
            app.A_stop1EditField.Limits = [1 Inf];
            app.A_stop1EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.A_stop1EditField.Layout.Row = 2;
            app.A_stop1EditField.Layout.Column = 2;
            app.A_stop1EditField.Value = 60;

            % Create A_pass2EditFieldLabel
            app.A_pass2EditFieldLabel = uilabel(app.GridLayout8);
            app.A_pass2EditFieldLabel.HorizontalAlignment = 'right';
            app.A_pass2EditFieldLabel.WordWrap = 'on';
            app.A_pass2EditFieldLabel.Visible = 'off';
            app.A_pass2EditFieldLabel.Layout.Row = 4;
            app.A_pass2EditFieldLabel.Layout.Column = 1;
            app.A_pass2EditFieldLabel.Interpreter = 'latex';
            app.A_pass2EditFieldLabel.Text = '$A_{pass2}$';

            % Create A_pass2EditField
            app.A_pass2EditField = uieditfield(app.GridLayout8, 'numeric');
            app.A_pass2EditField.Limits = [1 Inf];
            app.A_pass2EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.A_pass2EditField.Visible = 'off';
            app.A_pass2EditField.Layout.Row = 4;
            app.A_pass2EditField.Layout.Column = 2;
            app.A_pass2EditField.Value = 1;

            % Create A_stop2EditFieldLabel
            app.A_stop2EditFieldLabel = uilabel(app.GridLayout8);
            app.A_stop2EditFieldLabel.HorizontalAlignment = 'right';
            app.A_stop2EditFieldLabel.WordWrap = 'on';
            app.A_stop2EditFieldLabel.Visible = 'off';
            app.A_stop2EditFieldLabel.Layout.Row = 3;
            app.A_stop2EditFieldLabel.Layout.Column = 1;
            app.A_stop2EditFieldLabel.Interpreter = 'latex';
            app.A_stop2EditFieldLabel.Text = '$A_{stop2}$';

            % Create A_stop2EditField
            app.A_stop2EditField = uieditfield(app.GridLayout8, 'numeric');
            app.A_stop2EditField.Limits = [1 Inf];
            app.A_stop2EditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.A_stop2EditField.Visible = 'off';
            app.A_stop2EditField.Layout.Row = 3;
            app.A_stop2EditField.Layout.Column = 2;
            app.A_stop2EditField.Value = 60;

            % Create FilterunspecificoptionsPanel
            app.FilterunspecificoptionsPanel = uipanel(app.GridLayout2);
            app.FilterunspecificoptionsPanel.Title = 'Filter unspecific options';
            app.FilterunspecificoptionsPanel.Layout.Row = 3;
            app.FilterunspecificoptionsPanel.Layout.Column = 4;

            % Create GridLayout9
            app.GridLayout9 = uigridlayout(app.FilterunspecificoptionsPanel);
            app.GridLayout9.RowHeight = {'1x', '1x', '1x', '1x', '1x'};
            app.GridLayout9.ColumnSpacing = 1;
            app.GridLayout9.RowSpacing = 1;
            app.GridLayout9.Padding = [2 2 2 2];

            % Create filterforwardandbackwardCheckBox
            app.filterforwardandbackwardCheckBox = uicheckbox(app.GridLayout9);
            app.filterforwardandbackwardCheckBox.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.filterforwardandbackwardCheckBox.Tooltip = {'Enabling this removes any phase shifts and distortion! The given target attenuations then refer to the final (twice applied) filter effect'};
            app.filterforwardandbackwardCheckBox.Text = 'filter forward and backward';
            app.filterforwardandbackwardCheckBox.WordWrap = 'on';
            app.filterforwardandbackwardCheckBox.Layout.Row = 1;
            app.filterforwardandbackwardCheckBox.Layout.Column = [1 2];
            app.filterforwardandbackwardCheckBox.Value = true;

            % Create PaddingmethodLabel
            app.PaddingmethodLabel = uilabel(app.GridLayout9);
            app.PaddingmethodLabel.HorizontalAlignment = 'right';
            app.PaddingmethodLabel.WordWrap = 'on';
            app.PaddingmethodLabel.Layout.Row = 2;
            app.PaddingmethodLabel.Layout.Column = 1;
            app.PaddingmethodLabel.Text = {'Padding'; 'method'};

            % Create PaddingmethodDropDown
            app.PaddingmethodDropDown = uidropdown(app.GridLayout9);
            app.PaddingmethodDropDown.Items = {'replicate', 'symmetric', 'no padding'};
            app.PaddingmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.PaddingmethodDropDown.Layout.Row = 2;
            app.PaddingmethodDropDown.Layout.Column = 2;
            app.PaddingmethodDropDown.Value = 'replicate';

            % Create UsecurrentresultsandcloseButton
            app.UsecurrentresultsandcloseButton = uibutton(app.GridLayout9, 'push');
            app.UsecurrentresultsandcloseButton.ButtonPushedFcn = createCallbackFcn(app, @UsecurrentresultsandcloseButtonPushed, true);
            app.UsecurrentresultsandcloseButton.BackgroundColor = [1 0.4118 0.1608];
            app.UsecurrentresultsandcloseButton.Layout.Row = 5;
            app.UsecurrentresultsandcloseButton.Layout.Column = [1 2];
            app.UsecurrentresultsandcloseButton.Text = {'Use current'; 'results'; 'and close'};

            % Create listentooriginaldataButton
            app.listentooriginaldataButton = uibutton(app.GridLayout9, 'state');
            app.listentooriginaldataButton.ValueChangedFcn = createCallbackFcn(app, @listentooriginaldataButtonValueChanged, true);
            app.listentooriginaldataButton.Text = 'listen to original data';
            app.listentooriginaldataButton.WordWrap = 'on';
            app.listentooriginaldataButton.FontSize = 10;
            app.listentooriginaldataButton.Layout.Row = 4;
            app.listentooriginaldataButton.Layout.Column = 1;

            % Create listentofiltereddataButton
            app.listentofiltereddataButton = uibutton(app.GridLayout9, 'state');
            app.listentofiltereddataButton.ValueChangedFcn = createCallbackFcn(app, @listentofiltereddataButtonValueChanged, true);
            app.listentofiltereddataButton.Text = 'listen to filtered data';
            app.listentofiltereddataButton.WordWrap = 'on';
            app.listentofiltereddataButton.FontSize = 10;
            app.listentofiltereddataButton.Layout.Row = 4;
            app.listentofiltereddataButton.Layout.Column = 2;

            % Create Preserve0valuesandclipbelowCheckBox
            app.Preserve0valuesandclipbelowCheckBox = uicheckbox(app.GridLayout9);
            app.Preserve0valuesandclipbelowCheckBox.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.Preserve0valuesandclipbelowCheckBox.Tooltip = {'Useful e.g. for GAW recordings.'};
            app.Preserve0valuesandclipbelowCheckBox.Text = 'Preserve 0 values and clip below';
            app.Preserve0valuesandclipbelowCheckBox.Layout.Row = 3;
            app.Preserve0valuesandclipbelowCheckBox.Layout.Column = [1 2];

            % Create NonspectralsmoothingPanel
            app.NonspectralsmoothingPanel = uipanel(app.GridLayout2);
            app.NonspectralsmoothingPanel.Title = 'Non spectral smoothing';
            app.NonspectralsmoothingPanel.Layout.Row = 2;
            app.NonspectralsmoothingPanel.Layout.Column = 1;

            % Create GridLayout14
            app.GridLayout14 = uigridlayout(app.NonspectralsmoothingPanel);
            app.GridLayout14.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout14.RowHeight = {'1x', '1x', '1x', '1x'};
            app.GridLayout14.ColumnSpacing = 3;
            app.GridLayout14.RowSpacing = 1;
            app.GridLayout14.Padding = [1 1 1 1];

            % Create activatewindowedsmoothingCheckBox
            app.activatewindowedsmoothingCheckBox = uicheckbox(app.GridLayout14);
            app.activatewindowedsmoothingCheckBox.ValueChangedFcn = createCallbackFcn(app, @activatewindowedsmoothingCheckBoxValueChanged, true);
            app.activatewindowedsmoothingCheckBox.Text = 'activate windowed smoothing';
            app.activatewindowedsmoothingCheckBox.WordWrap = 'on';
            app.activatewindowedsmoothingCheckBox.Layout.Row = 1;
            app.activatewindowedsmoothingCheckBox.Layout.Column = [1 3];

            % Create MethodDropDownLabel
            app.MethodDropDownLabel = uilabel(app.GridLayout14);
            app.MethodDropDownLabel.HorizontalAlignment = 'right';
            app.MethodDropDownLabel.Layout.Row = 3;
            app.MethodDropDownLabel.Layout.Column = 1;
            app.MethodDropDownLabel.Text = 'Method';

            % Create MethodDropDown
            app.MethodDropDown = uidropdown(app.GridLayout14);
            app.MethodDropDown.Items = {'moving mean', 'moving median'};
            app.MethodDropDown.ItemsData = {'movmean', 'movmedian'};
            app.MethodDropDown.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.MethodDropDown.Enable = 'off';
            app.MethodDropDown.Layout.Row = 3;
            app.MethodDropDown.Layout.Column = [2 3];
            app.MethodDropDown.Value = 'movmedian';

            % Create WindowlengthLabel
            app.WindowlengthLabel = uilabel(app.GridLayout14);
            app.WindowlengthLabel.HorizontalAlignment = 'right';
            app.WindowlengthLabel.WordWrap = 'on';
            app.WindowlengthLabel.Layout.Row = 4;
            app.WindowlengthLabel.Layout.Column = [1 2];
            app.WindowlengthLabel.Text = 'Window length';

            % Create WindowlengthEditField
            app.WindowlengthEditField = uieditfield(app.GridLayout14, 'numeric');
            app.WindowlengthEditField.Limits = [2 Inf];
            app.WindowlengthEditField.RoundFractionalValues = 'on';
            app.WindowlengthEditField.ValueDisplayFormat = '%i';
            app.WindowlengthEditField.ValueChangedFcn = createCallbackFcn(app, @generalRefreshCallback, true);
            app.WindowlengthEditField.Enable = 'off';
            app.WindowlengthEditField.Layout.Row = 4;
            app.WindowlengthEditField.Layout.Column = 3;
            app.WindowlengthEditField.Value = 3;

            % Create leavenonoutliersuntouchedCheckBox
            app.leavenonoutliersuntouchedCheckBox = uicheckbox(app.GridLayout14);
            app.leavenonoutliersuntouchedCheckBox.ValueChangedFcn = createCallbackFcn(app, @leavenonoutliersuntouchedCheckBoxValueChanged, true);
            app.leavenonoutliersuntouchedCheckBox.Enable = 'off';
            app.leavenonoutliersuntouchedCheckBox.Text = 'leave non outliers untouched';
            app.leavenonoutliersuntouchedCheckBox.WordWrap = 'on';
            app.leavenonoutliersuntouchedCheckBox.Layout.Row = 2;
            app.leavenonoutliersuntouchedCheckBox.Layout.Column = [1 3];
            app.leavenonoutliersuntouchedCheckBox.Value = true;

            % Create TabGroup2
            app.TabGroup2 = uitabgroup(app.GridLayout);
            app.TabGroup2.Layout.Row = 3;
            app.TabGroup2.Layout.Column = [1 3];

            % Create timedomainTab
            app.timedomainTab = uitab(app.TabGroup2);
            app.timedomainTab.Title = 'time domain';

            % Create GridLayout12
            app.GridLayout12 = uigridlayout(app.timedomainTab);
            app.GridLayout12.ColumnWidth = {'1x'};
            app.GridLayout12.RowHeight = {'1x'};
            app.GridLayout12.ColumnSpacing = 0;
            app.GridLayout12.RowSpacing = 0;
            app.GridLayout12.Padding = [0 0 0 0];

            % Create timeDataPlotAxis
            app.timeDataPlotAxis = uiaxes(app.GridLayout12);
            title(app.timeDataPlotAxis, 'time plot of original and filtered data')
            xlabel(app.timeDataPlotAxis, 'time (s)')
            zlabel(app.timeDataPlotAxis, 'Z')
            app.timeDataPlotAxis.Toolbar.Visible = 'off';
            app.timeDataPlotAxis.XLimitMethod = 'tight';
            app.timeDataPlotAxis.YLimitMethod = 'padded';
            app.timeDataPlotAxis.XGrid = 'on';
            app.timeDataPlotAxis.YGrid = 'on';
            app.timeDataPlotAxis.Layout.Row = 1;
            app.timeDataPlotAxis.Layout.Column = 1;

            % Create spectrumTab
            app.spectrumTab = uitab(app.TabGroup2);
            app.spectrumTab.Title = 'spectrum';

            % Create GridLayout13
            app.GridLayout13 = uigridlayout(app.spectrumTab);
            app.GridLayout13.ColumnWidth = {'1x'};
            app.GridLayout13.RowHeight = {'1x'};
            app.GridLayout13.ColumnSpacing = 0;
            app.GridLayout13.RowSpacing = 0;
            app.GridLayout13.Padding = [0 0 0 0];

            % Create spectrumPlotAxis
            app.spectrumPlotAxis = uiaxes(app.GridLayout13);
            title(app.spectrumPlotAxis, 'spectrum of original and filtered data')
            xlabel(app.spectrumPlotAxis, 'f (Hz)')
            ylabel(app.spectrumPlotAxis, 'amplitude (dB)')
            zlabel(app.spectrumPlotAxis, 'Z')
            app.spectrumPlotAxis.Toolbar.Visible = 'off';
            app.spectrumPlotAxis.XScale = 'log';
            app.spectrumPlotAxis.XMinorTick = 'on';
            app.spectrumPlotAxis.XGrid = 'on';
            app.spectrumPlotAxis.YGrid = 'on';
            app.spectrumPlotAxis.Layout.Row = 1;
            app.spectrumPlotAxis.Layout.Column = 1;

            % Create currentStateLampLabel
            app.currentStateLampLabel = uilabel(app.GridLayout);
            app.currentStateLampLabel.HorizontalAlignment = 'right';
            app.currentStateLampLabel.Layout.Row = 1;
            app.currentStateLampLabel.Layout.Column = 2;
            app.currentStateLampLabel.Text = 'Plots are up to date';

            % Create currentStateLamp
            app.currentStateLamp = uilamp(app.GridLayout);
            app.currentStateLamp.Layout.Row = 1;
            app.currentStateLamp.Layout.Column = 3;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = interactiveFiltering

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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
