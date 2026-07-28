
classdef maskCreator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        CloseCancelButton               matlab.ui.control.Button
        CloseGenerateMaskButton         matlab.ui.control.Button
        MinimumExtremaProminenceValueEditField  matlab.ui.control.NumericEditField
        MinimumExtremaProminenceValueEditFieldLabel  matlab.ui.control.Label
        MinimumExtremaProminenceSlider  matlab.ui.control.Slider
        MinimumExtremaProminenceSliderLabel  matlab.ui.control.Label
        MaximumFrequencyValueEditField  matlab.ui.control.NumericEditField
        MaximumFrequencyValueEditFieldLabel  matlab.ui.control.Label
        MaximumFrequencySlider          matlab.ui.control.Slider
        MaximumFrequencySliderLabel     matlab.ui.control.Label
        MaximumValueEditField           matlab.ui.control.NumericEditField
        MaximumValueEditFieldLabel      matlab.ui.control.Label
        MinimumValueEditField           matlab.ui.control.NumericEditField
        MinimumValueEditFieldLabel      matlab.ui.control.Label
        AmplitudeAreatoselect0Minima100maximaSlider  matlab.ui.control.RangeSlider
        AmplitudeAreatoselect0Minima100maximaLabel  matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        XData
        YData % Description
        fs % Description
        wasRow = 0; % Description
        plotHandle % Description
        maximaHandle
        minimaHandle
        YDataMax
        YDataMin
        YDataRange
        markedRegionHandles % Description
        currentMask % Description
    end
    
    properties (Access = public)
        finalMask = []; % Description
    end
    
    methods (Access = private)
        
        function renewMarkedRegions(app,rangeValue,maxFrequency,minProm)
            
                if nargin==1 || isempty(rangeValue)
                    currentRangeValue=app.AmplitudeAreatoselect0Minima100maximaSlider.Value;
                else
                    currentRangeValue=rangeValue;
                end
                
                if nargin==1 || isempty(maxFrequency)
                    minSeparation=app.fs/app.MaximumFrequencyValueEditField.Value;
                else
                    minSeparation=app.fs/maxFrequency;
                end
    
                if nargin==1 || isempty(minProm)
                    minProminence=app.MinimumExtremaProminenceValueEditField.Value;
                else
                    minProminence=minProm;
                end

                app.CloseGenerateMaskButton.Enable="off";

            peakLocs=islocalmax(app.YData,'MinProminence',minProminence,'MinSeparation',minSeparation);

            valleyLocs=islocalmin(app.YData,'MinProminence',minProminence,'MinSeparation',minSeparation);

            %% plot maxima
            if isempty(app.maximaHandle) || ~ishandle(app.maximaHandle)
                app.maximaHandle=line(app.UIAxes,app.XData(peakLocs),app.YData(peakLocs),'Color','r','LineStyle','none','Marker','^','MarkerSize',6,'MarkerFaceColor','r');
                app.minimaHandle=line(app.UIAxes,app.XData(valleyLocs),app.YData(valleyLocs),'Color','r','LineStyle','none','Marker','v','MarkerSize',6,'MarkerFaceColor','r');
            else
                set(app.maximaHandle,'XData',app.XData(peakLocs),'YData',app.YData(peakLocs));
                set(app.minimaHandle,'XData',app.XData(valleyLocs),'YData',app.YData(valleyLocs));
            end

            %% find percentage regions

            delete(app.markedRegionHandles);
            app.markedRegionHandles=[];
            

            if currentRangeValue(1)==currentRangeValue(2)
                return;
            end

            peakIdx = find(peakLocs);
            valleyIdx = find(valleyLocs);
            
            % Kombiniere Extreme und sortiere sie
            [extremaIdx,sortOrder] = sort([peakIdx; valleyIdx]);
            extremaType = [ones(size(peakIdx)); -ones(size(valleyIdx))]; % Max=1, Min=-1
            extremaType = extremaType(sortOrder);
            
            % Regions-Matrix initialisieren
            regions = [];
            
            for i = 1:length(extremaIdx)-1
                type1 = extremaType(i);
                type2 = extremaType(i+1);
                idx1 = extremaIdx(i);
                idx2 = extremaIdx(i+1);
            
                if type1 ~= type2
                    % Definiere Bereich zwischen den Extrema (zeitlich sortiert)
                    segStart = min(idx1, idx2);
                    segEnd = max(idx1, idx2);
                    segmentY = app.YData(segStart:segEnd);
            
                    % Amplitudenwerte an beiden Extrema
                    val1 = app.YData(idx1);
                    val2 = app.YData(idx2);
            
                    % Kleinere und größere Amplitude bestimmen
                    lowerVal = min(val1, val2);
                    higherVal = max(val1, val2);
            
                    % Prozentwerte als Bruch umrechnen (z.B. 33%=0.33)
                    pLow = currentRangeValue(1) / 100;
                    pHigh = currentRangeValue(2) / 100;
            
                    % Ziel-Amplituden berechnen
                    vLow = lowerVal + (higherVal - lowerVal) * pLow;
                    vHigh = lowerVal + (higherVal - lowerVal) * pHigh;
            
                    % Suche Index im Segment wo Y >= vLow (von links)
                    if type1==-1
                        idxLowRel = find(segmentY >= vLow, 1, 'first');
                    else
                        idxLowRel = find(segmentY >= vLow, 1, 'last');
                    end
                    if isempty(idxLowRel)
                        idxLowRel = 1; % ggf. Anfang Segment
                    end
            
                    % Suche Index im Segment wo Y >= vHigh (von links)
                    if type1==-1
                        idxHighRel = find(segmentY >= vHigh, 1, 'first');
                    else
                        idxHighRel = find(segmentY >= vHigh, 1, 'last');
                    end
                    if isempty(idxHighRel)
                        idxHighRel = length(segmentY); % ggf. Ende Segment
                    end
            
                    % Gesamt-Indizes im Datensatz
                    regionStart = segStart - 1 + idxLowRel;
                    regionEnd = segStart - 1 + idxHighRel;
            
                    % Bereich speichern
                    regions = [regions; regionStart, regionEnd];
                end
            end

            regions=sort(regions,2);


            app.markedRegionHandles=gobjects(1,size(regions, 1));
            app.currentMask=zeros(size(app.YData));
            
            % Beispiel: die gefundenen Bereiche als Flächen unterlegen
            hold(app.UIAxes, 'on');
            for r = 1:size(regions, 1)
                app.currentMask(regions(r, 1):regions(r, 2))=1;
                xregion = (regions(r, 1):regions(r, 2))/app.fs;
                %yregion = app.YData(regions(r, 1):regions(r, 2));
                yregion=ones(1,numel(regions(r, 1):regions(r, 2)))*max(app.YData);
                app.markedRegionHandles(r)=area(app.UIAxes, xregion, yregion, 'FaceAlpha', 0.3, 'FaceColor', [0.8 0.3 0.3],'BaseValue',min(app.YData),'LineStyle','none','ShowBaseLine','off');
            end
            hold(app.UIAxes, 'off');

            if ~isempty(regions)
                app.CloseGenerateMaskButton.Enable="on";
            end
 
        end
        
        function debounceRenewMarkedRegions(app,amplitudeRange,maxFrequency,minProminence)
            persistent timerObj

            if ~isempty(timerObj)
                stop(timerObj);
            end
            timerObj=timer("ExecutionMode","singleShot","StartDelay",0.1,"TimerFcn",@(~,~)app.renewMarkedRegions(amplitudeRange,maxFrequency,minProminence));
            timerObj.start();
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, YData, XData)
            if nargin<3
                XData=0:1/20000:2;
                YData=5*sin(2*pi*3*XData)+10;
                YData=YData+rand(size(YData));
            end

            if isrow(YData)
                YData=YData(:);
                XData=XData(:);
                app.wasRow=1;
            end

           

            app.XData=XData;
            app.YData=YData;
            
            app.fs=1/mean(diff(app.XData));
            app.YDataMax=max(YData);
            app.YDataMin=min(YData);
            app.YDataRange=range(YData);

            %maxFreq=round(app.fs/2)-1;

            maxFreq=30;

            app.MaximumFrequencySlider.Limits(2)=maxFreq;
            app.MaximumFrequencyValueEditField.Limits(2)=maxFreq;

            initialMinProminence=0.01*app.YDataRange;

            app.MinimumExtremaProminenceSlider.Limits(2)=app.YDataRange;
            app.MinimumExtremaProminenceValueEditField.Limits(2)=app.YDataRange;
            app.MinimumExtremaProminenceSlider.Value=initialMinProminence;
            app.MinimumExtremaProminenceValueEditField.Value=initialMinProminence;
            

            app.plotHandle=plot(app.UIAxes,XData,YData,'LineWidth',1,'Color','k');

            ylim(app.UIAxes,'padded');


            if isfile('lastMaskCreatorSettings.mat')
                load('lastMaskCreatorSettings.mat',"settings");

                try
                    app.AmplitudeAreatoselect0Minima100maximaSlider.Value=settings.rangeVals;
                    app.MinimumValueEditField.Value=settings.rangeVals(1);
                    app.MaximumValueEditField.Value=settings.rangeVals(2);
                end

                try
                    app.MaximumFrequencySlider.Value=settings.maxFreq;
                    app.MaximumFrequencyValueEditField.Value=settings.maxFreq;
                end

                try
                    app.MinimumExtremaProminenceSlider.Value=settings.minProm;
                    app.MinimumExtremaProminenceValueEditField.Value=settings.minProm;
                end
            end

            


            app.renewMarkedRegions();

            app.UIFigure.CloseRequestFcn='';
            
        end

        % Value changing function: 
        % AmplitudeAreatoselect0Minima100maximaSlider
        function AmplitudeAreatoselect0Minima100maximaSliderValueChanging(app, event)
            changingValue = event.Value;
            

            app.MinimumValueEditField.Limits(2)=changingValue(2);
            app.MaximumValueEditField.Limits(1)=changingValue(1);

            app.MinimumValueEditField.Value=changingValue(1);
            app.MaximumValueEditField.Value=changingValue(2);


            app.debounceRenewMarkedRegions(changingValue,[],[]);
        end

        % Value changed function: MinimumValueEditField
        function MinimumValueEditFieldValueChanged(app, event)
            value = app.MinimumValueEditField.Value;
            app.AmplitudeAreatoselect0Minima100maximaSlider.Value(1)=value;
            app.MaximumValueEditField.Limits(1)=value;

            app.renewMarkedRegions();
        end

        % Value changed function: MaximumValueEditField
        function MaximumValueEditFieldValueChanged(app, event)
            value = app.MaximumValueEditField.Value;
            app.AmplitudeAreatoselect0Minima100maximaSlider.Value(2)=value;
            app.MinimumValueEditField.Limits(2)=value;

            app.renewMarkedRegions();
        end

        % Value changing function: MaximumFrequencySlider
        function MaximumFrequencySliderValueChanging(app, event)
            changingValue = event.Value;
            app.MaximumFrequencyValueEditField.Value=changingValue;

            app.debounceRenewMarkedRegions([],changingValue,[]);
        end

        % Value changed function: MaximumFrequencyValueEditField
        function MaximumFrequencyValueEditFieldValueChanged(app, event)
            value = app.MaximumFrequencyValueEditField.Value;
            app.MaximumFrequencySlider.Value=value;

            app.renewMarkedRegions();
        end

        % Value changing function: MinimumExtremaProminenceSlider
        function MinimumExtremaProminenceSliderValueChanging(app, event)
            changingValue = event.Value;
            app.MinimumExtremaProminenceValueEditField.Value=changingValue;

            app.debounceRenewMarkedRegions([],[],changingValue);
        end

        % Value changed function: MinimumExtremaProminenceValueEditField
        function MinimumExtremaProminenceValueEditFieldValueChanged(app, event)
            value = app.MinimumExtremaProminenceValueEditField.Value;
            app.MinimumExtremaProminenceSlider.Value=value;

            app.renewMarkedRegions();
        end

        % Button pushed function: CloseGenerateMaskButton
        function CloseGenerateMaskButtonPushed(app, event)
            % store settings values for later
            settings.rangeVals=app.AmplitudeAreatoselect0Minima100maximaSlider.Value;
            settings.maxFreq=app.MaximumFrequencySlider.Value;
            settings.minProm=app.MinimumExtremaProminenceSlider.Value;

            save('lastMaskCreatorSettings',"settings");


            app.finalMask=app.currentMask;
        end

        % Button pushed function: CloseCancelButton
        function CloseCancelButtonPushed(app, event)
            app.finalMask=NaN;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 842 644];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Raw Data and marked area')
            xlabel(app.UIAxes, 'time (s)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = [7 11];
            app.UIAxes.Layout.Column = [1 4];

            % Create AmplitudeAreatoselect0Minima100maximaLabel
            app.AmplitudeAreatoselect0Minima100maximaLabel = uilabel(app.GridLayout);
            app.AmplitudeAreatoselect0Minima100maximaLabel.HorizontalAlignment = 'right';
            app.AmplitudeAreatoselect0Minima100maximaLabel.WordWrap = 'on';
            app.AmplitudeAreatoselect0Minima100maximaLabel.Layout.Row = 1;
            app.AmplitudeAreatoselect0Minima100maximaLabel.Layout.Column = 1;
            app.AmplitudeAreatoselect0Minima100maximaLabel.Text = {'Amplitude Area to select'; '0% = Minima, 100% = maxima'};

            % Create AmplitudeAreatoselect0Minima100maximaSlider
            app.AmplitudeAreatoselect0Minima100maximaSlider = uislider(app.GridLayout, 'range');
            app.AmplitudeAreatoselect0Minima100maximaSlider.ValueChangingFcn = createCallbackFcn(app, @AmplitudeAreatoselect0Minima100maximaSliderValueChanging, true);
            app.AmplitudeAreatoselect0Minima100maximaSlider.Step = 1;
            app.AmplitudeAreatoselect0Minima100maximaSlider.Layout.Row = 1;
            app.AmplitudeAreatoselect0Minima100maximaSlider.Layout.Column = [2 4];
            app.AmplitudeAreatoselect0Minima100maximaSlider.Value = [33 66];

            % Create MinimumValueEditFieldLabel
            app.MinimumValueEditFieldLabel = uilabel(app.GridLayout);
            app.MinimumValueEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumValueEditFieldLabel.WordWrap = 'on';
            app.MinimumValueEditFieldLabel.Layout.Row = 2;
            app.MinimumValueEditFieldLabel.Layout.Column = 1;
            app.MinimumValueEditFieldLabel.Text = 'Minimum Value';

            % Create MinimumValueEditField
            app.MinimumValueEditField = uieditfield(app.GridLayout, 'numeric');
            app.MinimumValueEditField.Limits = [0 66];
            app.MinimumValueEditField.ValueDisplayFormat = '%11.4g %%';
            app.MinimumValueEditField.ValueChangedFcn = createCallbackFcn(app, @MinimumValueEditFieldValueChanged, true);
            app.MinimumValueEditField.Layout.Row = 2;
            app.MinimumValueEditField.Layout.Column = 2;
            app.MinimumValueEditField.Value = 33;

            % Create MaximumValueEditFieldLabel
            app.MaximumValueEditFieldLabel = uilabel(app.GridLayout);
            app.MaximumValueEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumValueEditFieldLabel.WordWrap = 'on';
            app.MaximumValueEditFieldLabel.Layout.Row = 2;
            app.MaximumValueEditFieldLabel.Layout.Column = 3;
            app.MaximumValueEditFieldLabel.Text = 'Maximum Value';

            % Create MaximumValueEditField
            app.MaximumValueEditField = uieditfield(app.GridLayout, 'numeric');
            app.MaximumValueEditField.Limits = [33 100];
            app.MaximumValueEditField.ValueDisplayFormat = '%11.4g %%';
            app.MaximumValueEditField.ValueChangedFcn = createCallbackFcn(app, @MaximumValueEditFieldValueChanged, true);
            app.MaximumValueEditField.Layout.Row = 2;
            app.MaximumValueEditField.Layout.Column = 4;
            app.MaximumValueEditField.Value = 66;

            % Create MaximumFrequencySliderLabel
            app.MaximumFrequencySliderLabel = uilabel(app.GridLayout);
            app.MaximumFrequencySliderLabel.HorizontalAlignment = 'right';
            app.MaximumFrequencySliderLabel.WordWrap = 'on';
            app.MaximumFrequencySliderLabel.Layout.Row = 3;
            app.MaximumFrequencySliderLabel.Layout.Column = 1;
            app.MaximumFrequencySliderLabel.Text = 'Maximum Frequency';

            % Create MaximumFrequencySlider
            app.MaximumFrequencySlider = uislider(app.GridLayout);
            app.MaximumFrequencySlider.Limits = [1 100];
            app.MaximumFrequencySlider.ValueChangingFcn = createCallbackFcn(app, @MaximumFrequencySliderValueChanging, true);
            app.MaximumFrequencySlider.Step = 1;
            app.MaximumFrequencySlider.Layout.Row = 3;
            app.MaximumFrequencySlider.Layout.Column = [2 4];
            app.MaximumFrequencySlider.Value = 5;

            % Create MaximumFrequencyValueEditFieldLabel
            app.MaximumFrequencyValueEditFieldLabel = uilabel(app.GridLayout);
            app.MaximumFrequencyValueEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumFrequencyValueEditFieldLabel.WordWrap = 'on';
            app.MaximumFrequencyValueEditFieldLabel.Layout.Row = 4;
            app.MaximumFrequencyValueEditFieldLabel.Layout.Column = 1;
            app.MaximumFrequencyValueEditFieldLabel.Text = 'Maximum Frequency Value';

            % Create MaximumFrequencyValueEditField
            app.MaximumFrequencyValueEditField = uieditfield(app.GridLayout, 'numeric');
            app.MaximumFrequencyValueEditField.Limits = [1 Inf];
            app.MaximumFrequencyValueEditField.RoundFractionalValues = 'on';
            app.MaximumFrequencyValueEditField.ValueDisplayFormat = '%11.4g Hz';
            app.MaximumFrequencyValueEditField.ValueChangedFcn = createCallbackFcn(app, @MaximumFrequencyValueEditFieldValueChanged, true);
            app.MaximumFrequencyValueEditField.Layout.Row = 4;
            app.MaximumFrequencyValueEditField.Layout.Column = 2;
            app.MaximumFrequencyValueEditField.Value = 5;

            % Create MinimumExtremaProminenceSliderLabel
            app.MinimumExtremaProminenceSliderLabel = uilabel(app.GridLayout);
            app.MinimumExtremaProminenceSliderLabel.HorizontalAlignment = 'right';
            app.MinimumExtremaProminenceSliderLabel.WordWrap = 'on';
            app.MinimumExtremaProminenceSliderLabel.Layout.Row = 5;
            app.MinimumExtremaProminenceSliderLabel.Layout.Column = 1;
            app.MinimumExtremaProminenceSliderLabel.Text = 'Minimum Extrema Prominence';

            % Create MinimumExtremaProminenceSlider
            app.MinimumExtremaProminenceSlider = uislider(app.GridLayout);
            app.MinimumExtremaProminenceSlider.ValueChangingFcn = createCallbackFcn(app, @MinimumExtremaProminenceSliderValueChanging, true);
            app.MinimumExtremaProminenceSlider.Layout.Row = 5;
            app.MinimumExtremaProminenceSlider.Layout.Column = [2 4];

            % Create MinimumExtremaProminenceValueEditFieldLabel
            app.MinimumExtremaProminenceValueEditFieldLabel = uilabel(app.GridLayout);
            app.MinimumExtremaProminenceValueEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumExtremaProminenceValueEditFieldLabel.WordWrap = 'on';
            app.MinimumExtremaProminenceValueEditFieldLabel.Layout.Row = 6;
            app.MinimumExtremaProminenceValueEditFieldLabel.Layout.Column = 1;
            app.MinimumExtremaProminenceValueEditFieldLabel.Text = 'Minimum Extrema Prominence Value';

            % Create MinimumExtremaProminenceValueEditField
            app.MinimumExtremaProminenceValueEditField = uieditfield(app.GridLayout, 'numeric');
            app.MinimumExtremaProminenceValueEditField.ValueChangedFcn = createCallbackFcn(app, @MinimumExtremaProminenceValueEditFieldValueChanged, true);
            app.MinimumExtremaProminenceValueEditField.Layout.Row = 6;
            app.MinimumExtremaProminenceValueEditField.Layout.Column = 2;

            % Create CloseGenerateMaskButton
            app.CloseGenerateMaskButton = uibutton(app.GridLayout, 'push');
            app.CloseGenerateMaskButton.ButtonPushedFcn = createCallbackFcn(app, @CloseGenerateMaskButtonPushed, true);
            app.CloseGenerateMaskButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.CloseGenerateMaskButton.Layout.Row = 12;
            app.CloseGenerateMaskButton.Layout.Column = 4;
            app.CloseGenerateMaskButton.Text = 'Close & Generate Mask';

            % Create CloseCancelButton
            app.CloseCancelButton = uibutton(app.GridLayout, 'push');
            app.CloseCancelButton.ButtonPushedFcn = createCallbackFcn(app, @CloseCancelButtonPushed, true);
            app.CloseCancelButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.CloseCancelButton.Layout.Row = 12;
            app.CloseCancelButton.Layout.Column = 3;
            app.CloseCancelButton.Text = 'Close & Cancel';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = maskCreator(varargin)

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
