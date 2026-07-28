
classdef Vocaliscope < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        FileimportappendexportMenu      matlab.ui.container.Menu
        ImportappendchanneldatafromfilesMenu  matlab.ui.container.Menu
        SavechanneldatatowavandmatMenu  matlab.ui.container.Menu
        allavailablechannelsMenu        matlab.ui.container.Menu
        to1multichannelMenu             matlab.ui.container.Menu
        tomultiplesinglechannelMenu     matlab.ui.container.Menu
        selectedchannelsonlyMenu        matlab.ui.container.Menu
        to1multichannelMenu_2           matlab.ui.container.Menu
        tomultiplesinglechannelMenu_2   matlab.ui.container.Menu
        SavechannelnamessourcetypesandselectedareatoFileMenu  matlab.ui.container.Menu
        LoadchannelnamessourcetypesandselectedareafromFileMenu  matlab.ui.container.Menu
        ViewMenu                        matlab.ui.container.Menu
        FontSizeMenu                    matlab.ui.container.Menu
        IncreasepressMenu               matlab.ui.container.Menu
        DecreasepressMenu               matlab.ui.container.Menu
        SelectionevaluationsMenu        matlab.ui.container.Menu
        ShowSelectionEvaluationsMenu    matlab.ui.container.Menu
        HideSelectionEvaluationsMenu    matlab.ui.container.Menu
        ShowMeanMenu                    matlab.ui.container.Menu
        ShowMedianMenu                  matlab.ui.container.Menu
        ShowMinMenu                     matlab.ui.container.Menu
        ShowMaxMenu                     matlab.ui.container.Menu
        ShowRangeMenu                   matlab.ui.container.Menu
        ShowStandardDeviationMenu       matlab.ui.container.Menu
        ShowRootMeanSquareMenu          matlab.ui.container.Menu
        Show1selectiondurationMenu      matlab.ui.container.Menu
        ChangechannelcolorsMenu         matlab.ui.container.Menu
        ExtrasMenu                      matlab.ui.container.Menu
        PianoMenu                       matlab.ui.container.Menu
        LagEstimatorofselectionMenu     matlab.ui.container.Menu
        RecalculateallmatfileswithallparametersMenu  matlab.ui.container.Menu
        RestartVocaliscopeMenu          matlab.ui.container.Menu
        GridLayout                      matlab.ui.container.GridLayout
        SelectedAreaDurationEditField   matlab.ui.control.NumericEditField
        DurationEditFieldLabel          matlab.ui.control.Label
        SelectedAreaEndEditField        matlab.ui.control.NumericEditField
        SelectionendLabel               matlab.ui.control.Label
        SelectedAreaStartEditField      matlab.ui.control.NumericEditField
        SelectionstartLabel             matlab.ui.control.Label
        SelectedAreaLabel               matlab.ui.control.Label
        showngraphswithoutscrollingDropDown  matlab.ui.control.DropDown
        showngraphswithoutscrollingDropDownLabel  matlab.ui.control.Label
        DeletenonselectedsignalsButton  matlab.ui.control.Button
        DeleteselectedsignalsButton     matlab.ui.control.Button
        ClQareasarehiddenButton         matlab.ui.control.StateButton
        HideOQareasButton               matlab.ui.control.StateButton
        HidecyclesbordersButton         matlab.ui.control.StateButton
        InvertselectionButton           matlab.ui.control.Button
        DeselectallButton               matlab.ui.control.Button
        SelectallButton                 matlab.ui.control.Button
        availableChannelsTable          matlab.ui.control.Table
        TabGroup                        matlab.ui.container.TabGroup
        TimeViewTab                     matlab.ui.container.Tab
        GridLayout4                     matlab.ui.container.GridLayout
        plottingPanelContainer          matlab.ui.container.Panel
        plottingPanel                   matlab.ui.container.Panel
        UndoallshiftsButton             matlab.ui.control.Button
        InteractionModeButtonGroup      matlab.ui.container.ButtonGroup
        MoveGraphButton                 matlab.ui.control.RadioButton
        MarkAreaButton                  matlab.ui.control.RadioButton
        normalButton                    matlab.ui.control.RadioButton
        TimeSpectralViewTab             matlab.ui.container.Tab
        GridLayout4_2                   matlab.ui.container.GridLayout
        plottingPanelContainerSpectral  matlab.ui.container.Panel
        plottingPanelSpectral           matlab.ui.container.Panel
        UndoallshiftsButtonSpectralTab  matlab.ui.control.Button
        choosesettingsandrecalculatespectraButton  matlab.ui.control.Button
        InteractionModeButtonGroupSpectralTab  matlab.ui.container.ButtonGroup
        MoveGraphButtonSpectral         matlab.ui.control.RadioButton
        MarkAreaButtonSpectral          matlab.ui.control.RadioButton
        normalButtonSpectral            matlab.ui.control.RadioButton
        ResultsTab                      matlab.ui.container.Tab
        GridLayout5                     matlab.ui.container.GridLayout
        parameterResultsUITable         matlab.ui.control.Table
        SourcetypeCheckBox              matlab.ui.control.CheckBox
        ParameternameCheckBox           matlab.ui.control.CheckBox
        ChannelnameCheckBox             matlab.ui.control.CheckBox
        SearchinthesecolumnsLabel       matlab.ui.control.Label
        CasesensitiveCheckBox           matlab.ui.control.CheckBox
        FilterResultsTableEditField     matlab.ui.control.EditField
        SoundVolumeSlider               matlab.ui.control.Slider
        StopSoundButton                 matlab.ui.control.Button
        weightchannelsevenlyCheckBox    matlab.ui.control.CheckBox
        PlaySoundButton                 matlab.ui.control.Button
        savechanneldatatoxlsxCheckBox   matlab.ui.control.CheckBox
        savewavandchannelnamestypesCheckBox  matlab.ui.control.CheckBox
        openfileaftersavingCheckBox     matlab.ui.control.CheckBox
        SaveResultsButton               matlab.ui.control.Button
        CalculateParametersButton       matlab.ui.control.Button
        uOupenShiftToolButton           matlab.ui.control.Button
        ParameterResultsTableContextMenu  matlab.ui.container.ContextMenu
        CopyleftclickedCellMenu         matlab.ui.container.Menu
        RowWindowdataMenu               matlab.ui.container.Menu
        copyMenu                        matlab.ui.container.Menu
        plotMenu                        matlab.ui.container.Menu
        copycompleterowMenu             matlab.ui.container.Menu
        withoutcolumnheaderMenu         matlab.ui.container.Menu
        withcolumnheaderMenu            matlab.ui.container.Menu
        channelTableContextMenu         matlab.ui.container.ContextMenu
        SelectallMenu                   matlab.ui.container.Menu
    end


    properties (Access = private)
        tlTime; % Tiled Layout for time plots
        tlSpectral;
        channelYValues = {}; % "y-values" of each channel
        channelXValues = {};
        channelYValuesHistory = {}; % versions of each channel and the original
        channelXValuesHistory = {}; % time data of versions of each channel and the original
        channelNames = {};
        channelSampleRates = [];
        channelSource = {}; % Description
        channelSourcePossibilities =      {'Audio','Flow','Pressure','GAW','EGG','Larynx Height','Accelerometer','Raw'}; % Description
        channelSourcePossibilitiesColor = [  255     0.0      0.0     245   128       128            220          0.0;...
            225     130      130     130   0.0       0.0            190          0.0;...
            25     200      200      48   0.0       0.0            255          0.0]'/255;
        customChannelColors;

        channelAxes = gobjects(0); % Description
        channelAxesSpectral = gobjects(0);
        xlimListener = []; % Description
        DraggingData = struct('Dragging', false, 'StartX', [], 'EndX', [],...
            'CurrentRectangles', [], 'PreviousRectangles', []);
        spectralRectangles = gobjects(0);
        spectralRectanglesPrevious = gobjects(0);
        timePlotHandles = gobjects(0); % Description
        spectralPlotHandles = gobjects(0);
        selectionEvaluationTexts = gobjects(0);
        selectionEvaluationSpectralTexts = gobjects(0);
        appliedLagTexts = gobjects(0);
        channelLag = []; % Description
        executeXLimListener=1; % Description
        audioPlayerObj % Description
        audioPlayerData % Description
        calculationSettings = [];% Description
        calculationCalledAsPreview = [];
        calculationResults = [];
        cycleBorderHandles=gobjects(0);
        keepVocaliscopeSettingsOverSession = 1; % Description
        xlimBeforeDeletion =[]; % Description
        parameterResultsUITableLastValue = ''; % Description
        cycleOQHandle = gobjects(0); % marking of the OQ areas
        cycleClQHandle = gobjects(0); % marking of the ClQ areas
        currentResultsTableChannelSources % a vector which saves the correct channel number for each of the table rows
        currentResultsTableChannelSourcesFiltered % when filter text is applied the rows are mixed and reduced
        refreshInteractionComingFromZoomTool=0; % Description
        titleTimer; % Description
        playbackPositionXLines; % Description
        playbackPositionXLinesSpectral;
        spectrumCalculationSettings=struct('maxFreq',2000,'minFreq',50,'frequencyValuesPerOctave',30,'spectralPrecision',5,'syncUpperFreqAndTimeResolution',true);
        currentAppVersion = ''; % Description
        doProfiling = 0; % Description
        timePlotPadPercentage = 0.2; % Description
        batchMode=0; % Description

    end

    methods (Static)

        % function success=downloadPraatIfNonExistent()
        % 
        %     success=0;
        %     scriptfolder=fileparts(mfilename('fullpath'));
        %     % voxplotPraatScripts
        % 
        %     praatExe   = [scriptfolder filesep 'Praat.exe'];
        % 
        % 
        %     disp('checking if praat exe is available locally....')
        % 
        %     try
        %         if ~isfile(praatExe)
        %             disp('praat is missing')
        %             if ispc
        %                 arch=computer('arch');
        %                 if strcmpi(arch,'win64')
        %                     url = 'https://github.com/praat/praat.github.io/releases/download/v6.4.67/praat6467_win-x64v3.zip';
        %                 else
        %                     url = 'https://github.com/praat/praat.github.io/releases/download/v6.4.67/praat6467_win-intel32.zip';
        %                 end
        % 
        % 
        %             end
        % 
        %             filename = [tempdir 'praat.zip'];
        % 
        %             disp('downloading Praat 6.4.67...')
        %             websave(filename, url);
        % 
        %             disp('unzipping...')
        %             unzip(filename,scriptfolder);
        % 
        %             movefile(fullfile(scriptfolder,'Praat.exe'),praatExe);
        % 
        %             delete(filename);
        %             success=1;
        %         else
        %             disp('praat found');
        %             success=1;
        % 
        % 
        %         end
        % 
        %     catch ME
        %         disp('error while downloading praat');
        %         disp(ME.getReport);
        % 
        %         success=0;
        % 
        %     end
        % 
        % end

        function createPoolIfNonexistent()
            if isempty(gcp("nocreate"))
                parpool("Processes",[1 min(4,feature('numcores'))],"IdleTimeout",12*60);
            end
        end

        function HNR_dB = computeHNRbiasedXcorr(x)
            % x : input signal (single window)

            % Step 1: Remove DC offset
            x = x - mean(x);

            % Step 2: Autocorrelation
            r = xcorr(x, 'biased');
            mid = ceil(length(r)/2);
            rxx = r(mid:end); % keep non-negative lags

            % Step 3: Find fundamental period (lag of max peak beyond zero)
            [~, T0] = max(rxx(2:end));

            % Step 4: Harmonics-to-Noise Ratio
            R0  = rxx(1);        % autocorrelation at lag 0
            RT0 = rxx(T0+1);     % autocorrelation at lag T0
            HNR_dB = 10*log10(RT0 / (R0 - RT0));

            if ~isreal(HNR_dB)
                HNR_dB=NaN;
            end
        end

        function success=downloadCrepeIfNonExistent(fig)

            success=0;

            neededFiles={'crepefulldlnet','crepelargedlnet','crepemediumdlnet','CREPENetfull','CREPENetlarge','CREPENetmedium','CREPENetsmall','CREPENettiny','crepesmalldlnet','crepetinydlnet'};
            neededFiles=append(neededFiles,'.mat');

            newCrepeLicenseName='crepeLicense.txt';

            neededFiles=[neededFiles {newCrepeLicenseName}];

            if any(~isfile(neededFiles))

                if ~isdeployed
                    addpath('filedownloadGUI\');
                end

                downloadName = fullfile(tempdir,'crepeDownloadedZIP.zip');
                urlplace='https://ssd.mathworks.com/supportfiles/audio/crepe.zip';

                
                downloadFile(downloadName,urlplace,"ShowFilename",true,'Figure',fig);

                
               

                crepeLocation = tempdir;
                unzip(downloadName,crepeLocation);

                files=dir([crepeLocation 'crepe' filesep '*.mat']); % crepe files

                for fileNr=1:numel(files)
                    movefile(fullfile(files(fileNr).folder,files(fileNr).name),pwd,"f");
                end

                movefile([crepeLocation 'crepe' filesep 'LICENSE.txt'],fullfile(pwd,newCrepeLicenseName),'f'); % crepe license

                %% cleaning up
                if isfolder([crepeLocation 'crepe'])
                    rmdir([crepeLocation 'crepe'],'s');
                end

                if isfile(downloadName)
                    delete(downloadName);
                end

                success=1;

            end

            


        end


    end

    methods (Access = private)

        function [data,meta] = importPhotronWVD(~,path,numberOutputStyle)

            if nargin>1 && ~isempty(numberOutputStyle) && (isstring(numberOutputStyle)|| ischar(numberOutputStyle)) && strcmpi(numberOutputStyle,'native')
                native=1;
            else
                native=0;
            end

            id=fopen(path,'r');

            if native==0
                meta.headerSize=fread(id,1,"long=>double");
                meta.WVDversion=fread(id,1,"long=>double");

                meta.vendorName=fread(id,[1 64],"char*1=>char");
                meta.vendorName=strrep(meta.vendorName,char(0),'');

                meta.deviceName=fread(id,[1 64],"char*1=>char");
                meta.deviceName=strrep(meta.deviceName,char(0),'');

                meta.deviceID=fread(id,1,"long=>double");
                meta.sampleRate=fread(id,1,"float=>double");
                meta.numberOfData=fread(id,1,"ulong=>double");
                meta.numberOfChannels=fread(id,1,"ulong=>double");

                meta.channelNumber=nan(1,meta.numberOfChannels);
                meta.channelName=cell(1,meta.numberOfChannels);
                for nr=1:meta.numberOfChannels
                    meta.channelNumber(nr)=fread(id,1,"ulong=>double");
                end

                for nr=1:meta.numberOfChannels
                    meta.channelName{nr}=fread(id,[1 64],"char*1=>char");
                end
                meta.channelName=strtrim(meta.channelName);

                meta.startFrame=fread(id,1,"long=>double");

                data=fread(id,[meta.numberOfChannels meta.numberOfData],"float=>double");


            else
                meta.headerSize=fread(id,1,"long=>long");
                meta.WVDversion=fread(id,1,"long=>long");

                meta.vendorName=fread(id,[1 64],"char*1=>char*1");

                meta.deviceName=fread(id,[1 64],"char*1=>char*1");

                meta.deviceID=fread(id,1,"long=>long");
                meta.sampleRate=fread(id,1,"float=>float");
                meta.numberOfData=fread(id,1,"ulong=>ulong");
                meta.numberOfChannels=fread(id,1,"ulong=>ulong");

                meta.channelNumber=nan(1,meta.numberOfChannels);
                meta.channelName=cell(1,meta.numberOfChannels);
                for nr=1:meta.numberOfChannels
                    meta.channelNumber(nr)=fread(id,1,"ulong=>ulong");
                end

                for nr=1:meta.numberOfChannels
                    meta.channelName{nr}=fread(id,[1 64],"char*1=>char*1");
                end

                meta.startFrame=fread(id,1,"long=>long");

                data=fread(id,[meta.numberOfChannels meta.numberOfData],"float=>float");

            end

            fclose(id);

        end

        function [header,allData]=readPhotronGraphExportData(~,filepath)
            disp('reading photron csv header...')

            header=readcell(filepath,'Range','A1:K23');
            header(end+1,:)=header(end,:);
            header(end-1,:)={[]};

            header(cellfun(@(in) all(ismissing(in)),header))={[]};

            disp('reading photron csv measurement data...')
            allData=readmatrix(filepath,'Range','A24');
        end



        function rescaleTimeAndSpectralPlotTilesVerticallyPanel(app,refreshTicks)
            numberOfMaxPlotsToView=str2double(app.showngraphswithoutscrollingDropDown.Value);

            % this can also be 0 when nothing is selected in the table
            numberOfSelectedChannels=numel(app.availableChannelsTable.Selection);
            bestMax=min(numberOfMaxPlotsToView,numberOfSelectedChannels);

            if bestMax>0
                if numberOfSelectedChannels<=numberOfMaxPlotsToView
                    correctionFactor=1.1;
                else
                    correctionFactor=1.05;
                end


                app.plottingPanel.OuterPosition(4)          =app.plottingPanelContainer.InnerPosition(4)*numberOfSelectedChannels/bestMax*correctionFactor;
                app.plottingPanelSpectral.OuterPosition(4)  =app.plottingPanel.OuterPosition(4);
                if ~refreshTicks
                    return;
                end
                for channelNr=1:numel(app.channelAxes)


                    xticklabels(app.channelAxes(channelNr),'auto');
                    xticklabels(app.channelAxesSpectral(channelNr),'auto');



                    if channelNr==numel(app.channelAxes)
                        xlabel(app.channelAxes(channelNr),'time (s)');
                        xlabel(app.channelAxesSpectral(channelNr),'time (s)');
                    end
                    xticks(app.channelAxes(channelNr),'auto');
                    xticks(app.channelAxesSpectral(channelNr),'auto');
                    %ylim(app.channelAxes(dispChannelNr),'padded');
                end
            else

            end

           


        end

        function refreshTimeAndSpectralPlotData(app)
            if ~isdeployed && app.doProfiling
                %#exclude profile
                profile on;
            end

            if ~app.batchMode
                progDiag = uiprogressdlg(app.UIFigure,'Title','Plotting Data...',...
                    'Indeterminate','on');
            end

            if ~isempty(app.channelAxes)
                oldXLim=app.channelAxes(1).XLim;
            elseif ~isempty(app.xlimBeforeDeletion)
                oldXLim=app.xlimBeforeDeletion;
            else
                oldXLim='tight';
            end

            nChannels=size(app.availableChannelsTable.Data,1);

            app.executeXLimListener=0;

            delete(app.channelAxes);
            delete(app.channelAxesSpectral);

            app.timePlotHandles=gobjects(1,nChannels);
            app.spectralPlotHandles=gobjects(1,nChannels);

            app.cycleBorderHandles=gobjects(1,nChannels);
            app.cycleOQHandle=gobjects(1,nChannels);
            app.cycleClQHandle=gobjects(1,nChannels);

            app.channelAxes=gobjects(1,nChannels);
            app.channelAxesSpectral=gobjects(1,nChannels);

            if isempty(app.availableChannelsTable.Selection)
                return;
            end

            app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(0);
            %drawnow;



            %app.tlTime=tiledlayout(app.plottingPanel,numel(app.availableChannelsTable.Selection),1,'TileSpacing','tight','Padding','tight','Visible','off');
            %app.tlTime=tiledlayout(app.plottingPanel,'vertical','TileSpacing','tight','Padding','tight','Visible','off');

            %channelNr=1;


            for channelNr=1:nChannels

                %% create plot line and set labels
                currAxTime=nexttile(app.tlTime);
                currAxSpectral=nexttile(app.tlSpectral);



                app.channelAxes(channelNr)=currAxTime;
                app.channelAxesSpectral(channelNr)=currAxSpectral;

                xlim(currAxTime,oldXLim);
                xlim(currAxSpectral,oldXLim);

                currYData=app.channelYValues{channelNr};
                %currFs=app.channelSampleRates(channelNr);
                %currTData=(0:numel(currYData)-1)/currFs;

                currTData=app.channelXValues{channelNr};

                hold(currAxTime,'on'); % otherwise the xlims are set to tickalgigned
                hold(currAxSpectral,'on');

                currentLineColor=app.channelSourcePossibilitiesColor(ismember(app.channelSourcePossibilities,app.channelSource{channelNr}),:);
                %app.timePlotHandles(channelNr)=plot(currAx,currTData+app.channelLag(channelNr),currYData,'-','LineWidth',1,'PickableParts','none','Color',currentLineColor);
                app.timePlotHandles(channelNr)=plot(currAxTime,currTData,currYData,'-','LineWidth',1,'PickableParts','none','Color',currentLineColor);
            end


            app.refreshSpectralPlots(1:nChannels);

            for channelNr=1:nChannels

                currAxTime=app.channelAxes(channelNr);
                currAxSpectral=app.channelAxesSpectral(channelNr);

                hold(currAxTime,'off');
                hold(currAxSpectral,'off');



                currAxTime.UserData.channelNr=channelNr;
                currAxSpectral.UserData.channelNr=channelNr;

                %                 if channelNr~=app.availableChannelsTable.Selection(end) && mod(plotNr,str2double(app.showngraphswithoutscrollingDropDown.Value))~=0
                %                     xticklabels(currAx,{''});
                %                 end
                xticks(currAxTime,'auto');
                xticks(currAxSpectral,'auto');

                splitTitle=app.splitCharArray(app.channelNames{channelNr},110);
                title(currAxTime,splitTitle,'Interpreter','none','Interactions',editInteraction);
                title(currAxSpectral,splitTitle,'Interpreter','none');

                xlabel(currAxTime,'time (s)');
                xlabel(currAxSpectral,'time (s)');




                ylabel(currAxTime,app.channelSource{channelNr},'Interpreter','none');
                ylabel(currAxSpectral,app.channelSource{channelNr},'Interpreter','none');


                %ylim(currAx,'padded');


                %% create context menus for each axis
                if ~app.batchMode
                    app.addContextMenuToAxis(channelNr);
                end



            end


            %% set basic layout of axes and labels
            % use a basic grid
            grid(app.channelAxes,"on");
            grid(app.channelAxesSpectral,"off");


            enableLegacyExplorationModes(app.UIFigure);
            % do not show the axtoolbars
            %arrayfun(@(in) axtoolbar(in,'Visible','off'),app.channelAxes);
            % arrayfun(@(in) axtoolbar(in,["zoomin" "zoomout"],'SelectionChangedFcn',@app.setToNormalModeWhenManualToolSelected),app.channelAxes);
            
            % try % in 2026a this gives a weird error but seems to have
            % done all necessary work before crashing. so i use try
            % statement here
            %     axtoolbar(app.tlTime,["zoomin" "zoomout"],'Expanded','on','SelectionChangedFcn',@app.setToNormalModeWhenManualToolSelected);
            % end

            arrayfun(@(in) axtoolbar(in,["zoom" "export"],'Expanded','on','SelectionChangedFcn',@app.setToNormalModeWhenManualToolSelected),app.channelAxes);



            %arrayfun(@(in) set(zoom(in),'Motion','horizontal'),app.channelAxes);

            z=zoom(app.UIFigure);
            set(z,'Motion','horizontal');

            % using linkaxes updates only when stopping dragging
            %linkaxes(app.channelAxes,'x');
            %linkprop(app.channelAxes,'XTicks');


            % i want to have the full y scale visible also after zooming
            delete(app.xlimListener);
            app.xlimListener=listener([app.channelAxes app.channelAxesSpectral], 'XLim', 'PostSet', @(~, evt) debounceMinimizeYLims(app,evt));
            % app.xlimListener=listener(app.channelAxesSpectral, 'XLim', 'PostSet', @(~, evt) debounceMinimizeYLims(app,evt));


            %             app.rescaleTimePlotTilesVerticallyPanel(0);
            %scroll(app.plottingPanelContainer,"top");

            if ~app.batchMode
                app.refreshInteractionMode();
            end






            %% add rectangles
            % if ~isempty(app.DraggingData.StartX)
            %     rectanglesTime = gobjects(1,numel(app.channelAxes));
            %     rectanglesSpectral = gobjects(1,numel(app.channelAxesSpectral));
            % end

            if ~isempty(app.DraggingData.StartX) && ~app.batchMode

                rectanglesTime = gobjects(1,numel(app.channelAxes));
                rectanglesSpectral = gobjects(1,numel(app.channelAxesSpectral));

                % when a selection is outside a newly loaded channel, we
                % need to delete the rectangles
                app.DraggingData.StartX=max(cellfun(@(in) in(1),app.channelXValues));
                app.DraggingData.EndX=min(cellfun(@(in) in(end),app.channelXValues));

                if app.DraggingData.StartX==app.DraggingData.EndX
                    app.DraggingData.StartX=[];
                    app.DraggingData.EndX=[];
                    delete(app.DraggingData.CurrentRectangles);
                    app.DraggingData.CurrentRectangles=[];

                    delete(app.spectralRectangles);
                    app.spectralRectangles=[];
                else
                    for channelNr=1:numel(app.channelAxes)
                        % draw rectangle if data already existed




                        if isnumeric(oldXLim)
                            currExcerpt=app.channelXValues{channelNr}>=oldXLim(1) & app.channelXValues{channelNr}<=oldXLim(2);
                            %else % if it is tight
                            %  oldXLim=[-inf inf];
                        end

                        % if any(currExcerpt)
                        %     yMin = min(app.channelYValues{channelNr}(currExcerpt));
                        %     yMax = max(app.channelYValues{channelNr}(currExcerpt));
                        % else
                        yMin=min(app.channelYValues{channelNr});
                        yMax=max(app.channelYValues{channelNr});
                        % end

                        yMinSpectral=min(app.spectralPlotHandles(channelNr).YData);
                        yMaxSpectral=max(app.spectralPlotHandles(channelNr).YData);

                        padval=app.timePlotPadPercentage*range(yMax-yMin);
                        yMin=yMin-padval;
                        yMax=yMax+padval;


                        rectTime = rectangle(app.channelAxes(channelNr), ...
                            'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                            'FaceColor', [0.8, 0.8, 1, 0.5], ...
                            'FaceAlpha',0.5,...
                            'EdgeColor', 'none', ...
                            'PickableParts', 'none');
                        %rectanglesTime = [rectanglesTime rectTime];
                        rectanglesTime(channelNr)=rectTime;

                        rectSpectral = rectangle(app.channelAxesSpectral(channelNr), ...
                            'Position', [app.DraggingData.StartX, yMinSpectral, app.DraggingData.EndX-app.DraggingData.StartX, yMaxSpectral - yMinSpectral], ...
                            'FaceColor', [0.8, 0.8, 1, 0.5], ...
                            'FaceAlpha',0.2,...
                            'EdgeColor', 'none', ...
                            'PickableParts', 'none');
                        %rectanglesSpectral= [rectanglesSpectral rectSpectral];
                        rectanglesSpectral(channelNr)=rectSpectral;




                    end

                end



            end

            % save rectangles after creation
            if ~isempty(app.DraggingData.StartX) && ~app.batchMode
                arrayfun(@(in)uistack(in,"bottom"),rectanglesTime);
                arrayfun(@(in)uistack(in,"top"),rectanglesSpectral);

                app.DraggingData.CurrentRectangles = rectanglesTime;
                app.spectralRectangles = rectanglesSpectral;
            end

            app.refreshSelectionEvaluationText();

            app.refreshAppliedLagTexts();



            %% set selection border edit values
            app.updateSelectionAreaEditFieldsValues()

            %% add cycle Borders if availble
            %channelNr=1;
            for channelNr=app.availableChannelsTable.Selection
                if ~isempty(app.calculationResults) && isfield(app.calculationResults,'channelResults') && numel(app.calculationResults.channelResults)>=channelNr
                    if ~isempty(app.calculationResults.channelResults(channelNr).cycleBorderVals)
                        if app.HidecyclesbordersButton.Value==1
                            vis='off';
                        else
                            vis='on';
                        end
                        app.cycleBorderHandles(channelNr)=app.addManyXlinesAsSingleObj(channelNr,app.calculationResults.channelResults(channelNr).cycleBorderVals,vis);
                        uistack(app.cycleBorderHandles(channelNr),'top');
                        uistack(app.timePlotHandles(channelNr),'top');
                    end
                end
                %channelNr=channelNr+1;
            end

            %% cycle OQ and ClQ areas if available

            for channelNr=app.availableChannelsTable.Selection
                if ~isempty(app.calculationResults) && isfield(app.calculationResults,'channelResults') && numel(app.calculationResults.channelResults)>=channelNr
                    if isfield(app.calculationResults.channelResults(channelNr),'allOQBorders') && ~isempty(app.calculationResults.channelResults(channelNr).allOQBorders)
                        %if ismember(channelNr,app.availableChannelsTable.Selection)

                        if app.HideOQareasButton.Value==1
                            oqvis='off';
                        else
                            oqvis='on';
                        end
                        if app.ClQareasarehiddenButton.Value==1
                            clqvis='off';
                        else
                            clqvis='on';
                        end

                        %channelNr=find(app.availableChannelsTable.Selection==channelNr,1);
                        app.cycleOQHandle(channelNr)=app.addManyPatchesAsSinglePatch(channelNr,app.calculationResults.channelResults(channelNr).allOQBorders,[0.2 0 0],[],oqvis);
                        app.cycleClQHandle(channelNr)=app.addManyPatchesAsSinglePatch(channelNr,app.calculationResults.channelResults(channelNr).allClQBorders,[0 0.2 0],[],clqvis);

                        uistack(app.cycleOQHandle(channelNr),'bottom');
                        %end



                    end
                end
            end




            %% load new data for audio player
            app.createAudioPlayerData();

            %% set old xlims and activate listener again
            %             if ~isempty(oldXLim)
            %                 %drawnow;
            %                 %xlim(app.channelAxes,oldXLim);
            %                 set(app.channelAxes,'XLim',oldXLim);
            %             end

            %% make tiledlayout visible again

            set(app.tlTime,'Units','normalized','OuterPosition',[0 0 1 1]);
            set(app.tlSpectral,'Units','normalized','OuterPosition',[0 0 1 1]);
            %drawnow limitrate;% pause(0.1)

            app.tlTime.Visible='on';
            app.tlSpectral.Visible='on';
            %drawnow limitrate;



            %drawnow;
            

            if ~app.batchMode
                app.executeXLimListener=1;
                close(progDiag);
                drawnow;
            end





           

            if ~isdeployed && app.doProfiling
                %#exclude profile
                profile viewer;
            end
        end

        function refreshTimeAndSpectralPlotDataVisibility(app)
            if ~app.batchMode
                axesToShow=ismember(1:size(app.availableChannelsTable.Data,1),app.availableChannelsTable.Selection);
    
                set(app.tlTime,'Visible','off');
                set(app.tlSpectral,'Visible','off');
                drawnow;
                set(app.channelAxes(axesToShow),'Parent',app.tlTime);
                set(app.channelAxesSpectral(axesToShow),'Parent',app.tlSpectral);
    
                set(app.channelAxes(~axesToShow),'Parent',[]);
                set(app.channelAxesSpectral(~axesToShow),'Parent',[]);
                drawnow;
                app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(0);
    
                app.createAudioPlayerData();
    
                drawnow;
    
                set(app.tlTime,'Visible','on');
                set(app.tlSpectral,'Visible','on');
            end
        end

        function minimizeYLims(app,evt)
            %drawnow;

            if ~app.executeXLimListener
                return;
            end


            % with pause it seems to work, but seems not to be smooth
            %pause(0.01);


            if ishandle(evt) % if i give an axes as event
                newXLim=evt.XLim;
                originatingAxis=evt;
            else
                newXLim=evt.AffectedObject.XLim;
                originatingAxis=evt.AffectedObject;
            end

            % update only the axes of the calling xlim axis, since each
            % axis has its own listener and linked, each axis should be
            % called anyways
            % ok now the listener is only attached to the first axes, so we
            % do have less listener callbacks, but all axes are updated
            %                 channelIdx=find(app.channelAxes==evt.AffectedObject,1);
            %
            %                 currDataExcerpt=app.channelYValues{channelIdx}(app.channelXValues{channelIdx}>=newXLim(1)-app.channelLag(channelIdx) & app.channelXValues{channelIdx}<=newXLim(2)-app.channelLag(channelIdx));
            %
            %                 minVal=min(currDataExcerpt);
            %                 maxVal=max(currDataExcerpt);
            %                 ylim(evt.AffectedObject,[minVal maxVal]+app.timePlotPadPercentage*[-1 1]*(maxVal-minVal));
            %                 yticks(evt.AffectedObject,'auto');

            % listener is only attached to first axis, but since axes are
            % linked with linkaxes, it should execute every time when it is
            % zoomed

            for channelNr=1:size(app.availableChannelsTable.Data,1)

                selectionPart=app.channelXValues{channelNr}>=newXLim(1) & app.channelXValues{channelNr}<=newXLim(2);

                % no need to add/remove lag here since the XData cell was
                % updated while dragging
                %selectionPart=app.channelXValues{channelIdx}>=newXLim(1)-app.channelLag(channelIdx) & app.channelXValues{channelIdx}<=newXLim(2)-app.channelLag(channelIdx);


                currDataExcerpt=app.channelYValues{channelNr}(selectionPart);



                minVal=min(currDataExcerpt);
                maxVal=max(currDataExcerpt);
                newYLimits=[minVal maxVal]+app.timePlotPadPercentage*[-1 1]*(maxVal-minVal);

                if isequal(originatingAxis,app.channelAxes(channelNr)) && ~app.batchMode % only the axes in which is zoomed shows a problem
                    mytimer=timer("StartDelay",1,"ExecutionMode","singleShot","TimerFcn", {@app.tmpFcn, channelNr, newYLimits});
                    mytimer.start();
                end

                ylim(app.channelAxes(channelNr),newYLimits);


                yticks(app.channelAxes(channelNr),'auto');



                % if numel(app.cycleBorderHandles)>= channelNr && app.isvalidhandle(app.cycleBorderHandles(channelNr))
                %     app.cycleBorderHandles(channelNr).YData(1:3:end)=newYLimits(1);
                %     app.cycleBorderHandles(channelNr).YData(2:3:end)=newYLimits(2);
                % end

                % use maximum range of the data, so when refreshed, the y
                % data does not change and does not put stress on the
                % rederer
                tmpmin=min(app.channelYValues{channelNr});
                tmpmax=max(app.channelYValues{channelNr});
                tmpYLimits=[tmpmin tmpmax]+app.timePlotPadPercentage*[-1 1]*(tmpmax-tmpmin);
                if numel(app.cycleBorderHandles)>= channelNr && app.isvalidhandle(app.cycleBorderHandles(channelNr))
                    app.cycleBorderHandles(channelNr).YData(1:3:end)=tmpYLimits(1);
                    app.cycleBorderHandles(channelNr).YData(2:3:end)=tmpYLimits(2);
                end

                if numel(app.cycleOQHandle)>= channelNr && app.isvalidhandle(app.cycleOQHandle(channelNr)) && ishandle(app.cycleOQHandle(channelNr))
                    app.cycleOQHandle(channelNr).Vertices([1:4:end 2:4:end],2)=tmpYLimits(1);
                    app.cycleOQHandle(channelNr).Vertices([3:4:end 4:4:end],2)=tmpYLimits(2);

                    app.cycleClQHandle(channelNr).Vertices([1:4:end 2:4:end],2)=tmpYLimits(1);
                    app.cycleClQHandle(channelNr).Vertices([3:4:end 4:4:end],2)=tmpYLimits(2);
                end

                if ~isempty(app.DraggingData.CurrentRectangles) && numel(app.DraggingData.CurrentRectangles)>= channelNr && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                    app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[tmpYLimits(1) tmpYLimits(2)-tmpYLimits(1)];
                end
            end


            % manual linked x axes

            %ylim([app.channelAxes],'padded')
            %newXLim=evt.AffectedObject.XLim;

            app.executeXLimListener=0;
            xlim([app.channelAxes app.channelAxesSpectral],newXLim);


            %             for chNr=1:numel(app.channelAxes)
            %                 if evt.AffectedObject~=app.channelAxes(chNr) && ~isequal(app.channelAxes(chNr).XLim,newXLim)
            %                     xlim(app.channelAxes(chNr),newXLim);
            %                 end
            %
            %             end

            if ~app.batchMode
                drawnow;
                app.executeXLimListener=1;
            end
           

        end

        function setToDataMarkMode(app)
            app.executeXLimListener=0;
            set(app.timePlotHandles,'HitTest','off');
            set(app.spectralPlotHandles,'HitTest','off');


            % Disable default interactions and set up dragging mode
            for channelNr = 1:numel(app.channelAxes)
                app.channelAxes(channelNr).Interactions = []; % Disable interactivity
                app.channelAxesSpectral(channelNr).Interactions = []; % Disable interactivity
            end

            % Set up callbacks for drag behavior
            app.UIFigure.WindowButtonDownFcn = @(src, ~) startDrag(app,src);
            app.UIFigure.WindowButtonMotionFcn = @(src,~) duringDrag(app,src);
            app.UIFigure.WindowButtonUpFcn = @(src,~) endDrag(app,src);

            % Add listeners for YLim changes
            for channelNr = 1:numel(app.channelAxes)
                if isfield(app.channelAxes(channelNr).UserData,'Listener')
                    delete(app.channelAxes(channelNr).UserData.Listener);
                end
                if isfield(app.channelAxesSpectral(channelNr).UserData,'Listener')
                    delete(app.channelAxesSpectral(channelNr).UserData.Listener);
                end
            end
            disp('Data mark mode enabled');


            % Dragging Callbacks
            function startDrag(app,src)
                if ~strcmp(src.SelectionType, 'normal'),return;end





                app.UIFigure.WindowButtonMotionFcn = @(src,~) duringDrag(app,src);
                ax = app.UIFigure.CurrentObject;


                if isempty(ax) || ~isa(ax, 'matlab.graphics.axis.Axes'), return; end

                disp('Start data mark');



                if ~isempty(app.audioPlayerObj)
                    stop(app.audioPlayerObj);
                    %delete(app.playbackPositionXLines);
                end
                delete(app.playbackPositionXLines);
                delete(app.playbackPositionXLinesSpectral);

                set(app.PlaySoundButton,'Text','Play Sound');

                ax.CurrentPoint
                app.UIFigure.CurrentPoint

                % Store drag state
                data = app.DraggingData;
                data.Dragging = true;
                data.StartX = ax.CurrentPoint(1, 1);
                data.PreviousRectangles = data.CurrentRectangles;
                app.spectralRectanglesPrevious = app.spectralRectangles;

                app.DraggingData = data;



                % Create new rectangles
                rectanglesTime = gobjects(1,numel(app.channelAxes));
                rectanglesSpectral = gobjects(1,numel(app.channelAxes));
                for axisNr = 1:numel(app.channelAxes)
                    yMin = app.channelAxes(axisNr).YLim(1);
                    yMax = app.channelAxes(axisNr).YLim(2);
                    rectTime = rectangle(app.channelAxes(axisNr), ...
                        'Position', [data.StartX, yMin, 0, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.5,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none','HandleVisibility','off');
                    yMin = min(app.spectralPlotHandles(axisNr).YData);
                    yMax = max(app.spectralPlotHandles(axisNr).YData);
                    rectSpectral = rectangle(app.channelAxesSpectral(axisNr), ...
                        'Position', [data.StartX, yMin, 0, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.2,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none','HandleVisibility','off');
                    rectanglesTime(axisNr)=rectTime;
                    rectanglesSpectral(axisNr) =rectSpectral;
                end

                arrayfun(@(in)uistack(in,"top"),rectanglesTime);
                arrayfun(@(in)uistack(in,"down"),rectanglesTime);
                arrayfun(@(in)uistack(in,"down"),rectanglesTime);
                arrayfun(@(in)uistack(in,"top"),rectanglesSpectral);


                data.CurrentRectangles = rectanglesTime;
                app.DraggingData = data;



                app.spectralRectangles = rectanglesSpectral;

                % disp(app.DraggingData);
                % disp(data);



            end

            function duringDrag(app,src)
                if ~strcmp(src.SelectionType, 'normal'),return;end
                data = app.DraggingData;


                ax = app.UIFigure.CurrentObject;
                if isempty(ax) || ~isa(ax, 'matlab.graphics.axis.Axes'), return; end

                if ~data.Dragging
                    disp('Dragging is false')
                    return;
                end


                %disp('During data mark');

                currX = ax.CurrentPoint(1, 1);
                xPos = min(data.StartX, currX);
                width = abs(currX - data.StartX);
                app.DraggingData.EndX=currX;


                % Update rectangles
                for axNr = 1:numel(data.CurrentRectangles)
                    yMin = app.channelAxes(axNr).YLim(1);
                    yMax = app.channelAxes(axNr).YLim(2);
                    data.CurrentRectangles(axNr).Position = [xPos, yMin, width, yMax - yMin];

                    yMin = min(app.spectralPlotHandles(axNr).YData);
                    yMax = max(app.spectralPlotHandles(axNr).YData);
                    app.spectralRectangles(axNr).Position = [xPos, yMin, width, yMax - yMin];





                end

                % also refresh calucations in the selected area
                persistent debounceTimer;
                if ~isempty(debounceTimer) && isvalid(debounceTimer)
                    stop(debounceTimer);
                end
                debounceTimer=timer("ExecutionMode","singleShot",'StartDelay',0.5,'TimerFcn',@(~,~) app.refreshSelectionEvaluationText(1:numel(data.CurrentRectangles),[xPos xPos+width]));

                start(debounceTimer)



                app.updateSelectionAreaEditFieldsValues();

                drawnow limitrate;
            end

            function endDrag(app,src)
                if ~strcmp(src.SelectionType, 'normal')
                    return;
                end
                data = app.DraggingData;

                ax=app.UIFigure.CurrentObject;
                if isempty(ax) || ~isa(ax, 'matlab.graphics.axis.Axes')
                    return;
                end
                app.UIFigure.WindowButtonMotionFcn = '';
                %disp('into end drag')

                maxMinX=max(cellfun(@(in) in(1),app.channelXValues));
                minMaxX=min(cellfun(@(in) in(end),app.channelXValues));

                if data.Dragging && (isempty(data.CurrentRectangles) || data.CurrentRectangles(1).Position(3)==0)
                    data.Dragging = false;

                    delete(app.DraggingData.PreviousRectangles);
                    delete(app.spectralRectanglesPrevious);

                    delete(app.DraggingData.CurrentRectangles);
                    delete(app.spectralRectangles);

                    app.DraggingData.PreviousRectangles=[];
                    app.spectralRectanglesPrevious=[];

                    app.DraggingData.CurrentRectangles=[];
                    app.spectralRectangles=[];

                    p=ax.CurrentPoint(1,1);
                    app.DraggingData.StartX=[];
                    app.DraggingData.EndX=[];
                    app.createAudioPlayerData();

                    app.DraggingData.Dragging=false;

                    app.updateSelectionAreaEditFieldsValues();
                    app.refreshSelectionEvaluationText();
                    return;
                end

                if data.Dragging
                    %disp('End data mark');
                    data.Dragging = false;


                    data.StartX=min(app.DraggingData.StartX,app.DraggingData.EndX);
                    data.EndX=max(app.DraggingData.StartX,app.DraggingData.EndX);



                    if sum(data.CurrentRectangles(1).Position([1 3]))<maxMinX || data.CurrentRectangles(1).Position(1)>minMaxX
                        % when the marked region is completly below the
                        % highest minimum or above the smallest maximum
                        % then do not paint
                        delete(data.CurrentRectangles);
                        delete(app.spectralRectangles);

                        data.currentRectangles=[];
                        app.spectralRectangles=[];

                        data.StartX=[];
                        data.EndX=[];
                    else
                        if maxMinX>data.CurrentRectangles(1).Position(1)
                            oldEnd=sum(data.CurrentRectangles(1).Position([1 3]));
                            for rectNr=1:numel(data.CurrentRectangles)
                                data.CurrentRectangles(rectNr).Position(1)=maxMinX;
                                data.CurrentRectangles(rectNr).Position(3)=oldEnd-maxMinX;

                                app.spectralRectangles(rectNr).Position(1)=maxMinX;
                                app.spectralRectangles(rectNr).Position(3)=oldEnd-maxMinX;
                            end
                            data.StartX=maxMinX;

                        end

                        if minMaxX<sum(data.CurrentRectangles(1).Position([1 3]))
                            for rectNr=1:numel(data.CurrentRectangles)
                                data.CurrentRectangles(rectNr).Position(3)=minMaxX-data.CurrentRectangles(rectNr).Position(1);
                                app.spectralRectangles(rectNr).Position(3)=minMaxX-app.spectralRectangles(rectNr).Position(1);
                            end
                            data.EndX=minMaxX;

                        end
                    end


                    % Delete previous rectangles
                    if ~isempty(data.PreviousRectangles)
                        delete(data.PreviousRectangles);
                        data.PreviousRectangles = [];

                        delete(app.spectralRectanglesPrevious);
                        app.spectralRectanglesPrevious=[];
                    end




                    app.DraggingData = data;

                    app.createAudioPlayerData();



                    % set selection edit field values
                    app.updateSelectionAreaEditFieldsValues();

                    drawnow;


                end

                app.refreshSelectionEvaluationText();
            end



        end




        function refreshInteractionMode(app)
            if isempty(app.channelAxes)
                return;
            end

            % for channelNr=1:numel(app.channelAxes)
            %     if ~isempty(app.channelAxes(channelNr).Parent) && ~app.refreshInteractionComingFromZoomTool
            %         zoom(app.channelAxes(channelNr),'off');
            %     end
            % end


            if ~app.refreshInteractionComingFromZoomTool
                zoom(app.UIFigure,'off');
            end


            app.refreshInteractionComingFromZoomTool=0;

            drawnow;


            if contains(app.InteractionModeButtonGroup.SelectedObject.Text,'normal','IgnoreCase',true)
                % normal mode
                %ylim(app.channelAxes,'auto');
                app.setToNormalInteractionMode();
            elseif contains(app.InteractionModeButtonGroup.SelectedObject.Text,'mark','IgnoreCase',true)
                % selection mode
                %ylim(app.channelAxes,'auto');
                app.setToDataMarkMode();
            else
                % move graph mode
                app.setToDataDragMode();
            end
            %pause(0.1);
            %drawnow;

        end

        function setToDataDragMode(app)
            set(app.timePlotHandles,'HitTest','off');
            set(app.spectralPlotHandles,'HitTest','off');
            app.executeXLimListener=0;
            if isempty(app.availableChannelsTable.Data) || isempty(app.availableChannelsTable.Selection), return,end
            xlim(app.channelAxes, 'manual');
            ylim(app.channelAxes,'manual');

            xlim(app.channelAxesSpectral, 'manual');
            ylim(app.channelAxesSpectral,'manual');

            disp('Data shift mode enabled');


            % Initialize state variables
            appState.StartPoint = [];
            appState.CurrentGraph = []; % Index of the currently active graph
            appState.ClickedAxis = [];
            appState.XData = [];

            % Set callbacks for mouse actions
            app.UIFigure.WindowButtonDownFcn = @(~, ~) onMouseDown(app);
            app.UIFigure.WindowButtonMotionFcn = @(~, ~) onMouseDrag(app);
            app.UIFigure.WindowButtonUpFcn = @(~, ~) onMouseUp(app);

            % Nested function: onMouseDown
            function onMouseDown(app)
                clickedObject = app.UIFigure.CurrentObject;
                if isa(clickedObject, 'matlab.graphics.axis.Axes')
                    % Find the corresponding graph index
                    if ismember(clickedObject,app.channelAxes)
                        axesHandles = app.channelAxes;
                        plotHandles = app.timePlotHandles;
                    else
                        axesHandles = app.channelAxesSpectral;
                        plotHandles = app.spectralPlotHandles;
                    end
                    appState.CurrentGraph = find(axesHandles == clickedObject); % Direct indexing for arrays
                    appState.StartPoint = clickedObject.CurrentPoint;
                    appState.ClickedAxis=clickedObject;
                    appState.XData = {plotHandles.XData};
                else
                    appState.CurrentGraph = [];
                    appState.StartPoint = [];
                    appState.ClickedAxis=[];
                    appState.XData = [];
                end
            end

            % Nested function: onMouseDrag
            function onMouseDrag(app)
                if ~isempty(appState.StartPoint) && ~isempty(appState.CurrentGraph)
                    % Access the current graph's data
                    idx = appState.CurrentGraph;

                    if ismember(appState.ClickedAxis,app.channelAxes)
                        axesHandles = app.channelAxes;
                        plotHandles = app.timePlotHandles;
                        xData = app.channelXValues;
                        comingFromTime=1;
                    else
                        axesHandles = app.channelAxesSpectral;
                        plotHandles = app.spectralPlotHandles;
                        xData = appState.XData;
                        comingFromTime=0;
                    end
                    %cumulativeShifts = app.channelLag(app.availableChannelsTable.Selection);
                    cumulativeShifts = app.channelLag;

                    % Calculate the shift
                    currentPoint = axesHandles(idx).CurrentPoint; % Use array indexing
                    shiftAmount = currentPoint(1, 1) - appState.StartPoint(1, 1);

                    % Update xData and cumulative shift
                    newXData = xData{idx} + shiftAmount; % Keep xData access as a cell array
                    xData{idx} = newXData; % Save updated xData
                    cumulativeShifts(idx) = cumulativeShifts(idx) + shiftAmount;

                    % Update the plot
                    %plotHandles(idx).XData = newXData; % Use array indexing for plot handles
                    app.spectralPlotHandles(idx).XData=app.spectralPlotHandles(idx).XData+shiftAmount;
                    app.timePlotHandles(idx).XData=app.timePlotHandles(idx).XData+shiftAmount;

                    if numel(app.cycleBorderHandles)>=idx && app.isvalidhandle(app.cycleBorderHandles(idx))
                        app.cycleBorderHandles(idx).XData([1:3:end 2:3:end])=app.cycleBorderHandles(idx).XData([1:3:end 2:3:end])+shiftAmount;
                    end

                    if numel(app.cycleOQHandle)>=idx && app.isvalidhandle(app.cycleOQHandle(idx))
                        app.cycleOQHandle(idx).Vertices(:,1)=app.cycleOQHandle(idx).Vertices(:,1)+shiftAmount;
                        app.cycleClQHandle(idx).Vertices(:,1)=app.cycleClQHandle(idx).Vertices(:,1)+shiftAmount;
                    end


                    % Update the axis title with the total shift
                    %title(axesHandles(idx), sprintf('X Shift: %+.2f', cumulativeShifts(idx)));

                    % Save updated data back to UserData

                    % if comingFromTime
                    app.channelXValues = xData;
                    % else
                    %     for xdataNr=1:numel(xData)
                    %         app.spectralPlotHandles(xdataNr).XData=xData{xdataNr};
                    %     end
                    % end
                    % app.channelLag(app.availableChannelsTable.Selection)= cumulativeShifts;

                    app.channelLag=cumulativeShifts;


                    % Update the start point for smooth dragging
                    appState.StartPoint = currentPoint;

                    app.refreshSelectionEvaluationText(idx);
                    app.refreshAppliedLagTexts();
                end
            end

            % Nested function: onMouseUp
            function onMouseUp(app)
                % Clear state variables
                appState.StartPoint = [];
                appState.CurrentGraph = [];

                app.updateSelectionAreaEditFieldsLimits();



            end
        end


        function lineObj=addManyXlinesAsSingleObj(app,channelNr,xvals,vis)
            ax=app.channelAxes(channelNr);

            % removed for testing if necessary
            %xlims=xlim(ax);
            %currydata=app.timePlotHandles(channelNr).YData(app.timePlotHandles(channelNr).XData>=xlims(1) & app.timePlotHandles(channelNr).XData<=xlims(2));

            currydata=app.timePlotHandles(channelNr).YData;
            ylims=[min(currydata) max(currydata)]+[-1 1]*app.timePlotPadPercentage*range(currydata);
            %ylims=ylim(ax);
            plotxvals=repelem(xvals,3); xvals(3:3:end)=NaN;
            yvals=repmat([ylims NaN],[1 numel(xvals)]);

            lineObj=line(ax,plotxvals(:),yvals(:),'PickableParts','none','Color',[0.2 0 0],'LineStyle','-','Visible',vis);

            if isempty(lineObj)
                lineObj=gobjects(1);
            end
        end

        function setToNormalInteractionMode(app)
            set(app.timePlotHandles,'HitTest','on');
            set(app.spectralPlotHandles,'HitTest','on');

            app.executeXLimListener=1;
            for i=1:numel(app.channelAxes)
                app.channelAxes(i).ButtonDownFcn = [];
                app.channelAxesSpectral(i).ButtonDownFcn = [];
            end

            warning('off'); % while in manual zoom mode we are not allowed to set those function, becuase it gives a warning
            app.UIFigure.WindowButtonDownFcn = [];
            app.UIFigure.WindowButtonMotionFcn = [];
            app.UIFigure.WindowButtonUpFcn = [];
            warning('on');

            %set(app.channelAxes,'Interactions',[panInteraction("Dimensions",'x') zoomInteraction("Dimensions",'x') dataTipInteraction]);
            set(app.channelAxes,'Interactions',[panInteraction("Dimensions",'x') zoomInteraction("Dimensions",'x')]);
            set(app.channelAxesSpectral,'Interactions',[panInteraction("Dimensions",'x') zoomInteraction("Dimensions",'x')]);

            disp('Normal mode enabled (zoom, pan)');
        end

        function setChannelShiftToZero(app,channelNumbers)
            for nr=channelNumbers
                app.channelXValues{nr}=(0:numel(app.channelYValues{nr})-1)/app.channelSampleRates(nr);
            end

            %nr=1;
            for nr=channelNumbers%app.availableChannelsTable.Selection
                xlim(app.channelAxes(nr),'manual');
                app.timePlotHandles(nr).XData=app.channelXValues{nr};
                if numel(app.cycleBorderHandles)>=nr && app.isvalidhandle(app.cycleBorderHandles(nr))
                    app.cycleBorderHandles(nr).XData([1:3:end 2:3:end])=app.cycleBorderHandles(nr).XData([1:3:end 2:3:end])-app.channelLag(nr);
                end

                app.refreshSpectralPlots(nr,1);
            end

            app.channelLag(channelNumbers)=0;

            app.createAudioPlayerData();

            app.refreshAppliedLagTexts();

            drawnow;


        end

        function createAudioPlayerData(app)

            if isempty(app.availableChannelsTable.Selection) || app.batchMode
                return;
            end

            % if there is a marked area available
            if ~isempty(app.DraggingData) && ~isempty(app.DraggingData.StartX) && ~isempty(app.DraggingData.EndX) && app.DraggingData.StartX~=app.DraggingData.EndX%(app.DraggingData.EndX-app.DraggingData.StartX)>0.1
                startTime = app.DraggingData.StartX;
                endTime = app.DraggingData.EndX;
            else
                % if nothing was marked yet, play the most common points in
                % time
                startTime=max(cellfun(@(in) in(1),app.channelXValues));
                endTime=min(cellfun(@(in) in(end),app.channelXValues));
            end

            % Determine the common sample rate (e.g., maximum of given sample rates)
            commonRate = max(app.channelSampleRates(app.availableChannelsTable.Selection));

            % Resample all traces to the common sample rate and extract the required segment

            resampledData = [];
            for channelNr = app.availableChannelsTable.Selection
                trace = app.channelYValues{channelNr};
                time=app.channelXValues{channelNr};

                trace=trace(time>=startTime & time<=endTime);

                originalRate = app.channelSampleRates(channelNr);

                % Calculate the resampling ratio
                [P, Q] = rat(commonRate / originalRate);

                % Resample the trace
                resampledTrace = resample(trace, P, Q);

                % we only play AC parst of the signals
                resampledTrace=resampledTrace-mean(resampledTrace);

                % we can weight the channels evenyl by normalizing each
                % channel by the number of channels selected
                if app.weightchannelsevenlyCheckBox.Value==1
                    resampledTrace=resampledTrace/max(abs(resampledTrace))/numel(app.availableChannelsTable.Selection);
                end

                % Adjust the length of the current trace to match resampledData, if necessary
                if isempty(resampledData)
                    resampledData = resampledTrace; % First trace defines the length
                else
                    if length(resampledTrace) < length(resampledData)
                        % Pad with zeros if shorter
                        resampledTrace = [resampledTrace; zeros(length(resampledData) - length(resampledTrace), 1)];
                    elseif length(resampledTrace) > length(resampledData)
                        % Truncate if longer
                        resampledTrace = resampledTrace(1:length(resampledData));
                    end
                    % Combine the traces
                    resampledData = resampledData + resampledTrace;
                end
            end

            % normalize to keep it to maxmimum abs amplitude of 1

            % Normalize the combined data to avoid clipping
            resampledData = resampledData / max(abs(resampledData));

            app.audioPlayerData=resampledData;


        end








        function uiMenuChangeColorCallback(app,src,channelNr)
            % Uncheck all menu items first
            for nr = 1:numel(src.Parent.Children)
                src.Parent.Children(nr).Checked = 'off';
            end


            % Check the selected menu item
            % edit: V 4.3 skipping the checking since all axes use the same
            % cmenu
            %src.Checked = 'on';


            app.timePlotHandles(channelNr).Color=app.channelSourcePossibilitiesColor(ismember(app.channelSourcePossibilities,src.Label),:);
            ylabel(app.channelAxes(channelNr),src.Label);

            app.availableChannelsTable.Data{channelNr,2}=src.Label;
            app.channelSource{channelNr}=src.Label;


            % Display selected entry
            fprintf('Selected Source: %s\n', src.Label);
        end

        function updateSelectionAreaEditFieldsValues(app)

            if ~isempty(app.DraggingData.StartX)
                %if app.DraggingData.StartX ~= app.DraggingData.EndX
                app.SelectedAreaStartEditField.Value=min([app.DraggingData.StartX,app.DraggingData.EndX]);
                app.SelectedAreaEndEditField.Value=max([app.DraggingData.StartX,app.DraggingData.EndX]);
                app.SelectedAreaDurationEditField.Value=abs(app.DraggingData.EndX-app.DraggingData.StartX); % also called during dragging, so there could be negative values
            else % during mark mode it was not dragged, but only clicked

                % we could use this to limit the borders to the latest
                % start end earliest data ending.
                %                     app.SelectedAreaStartEditField.Value=max(cellfun(@(in) in(1),app.channelXValues));
                %                     app.SelectedAreaEndEditField.Value=min(cellfun(@(in) in(end),app.channelXValues));


                app.SelectedAreaStartEditField.Value=max(cellfun(@(in) in(1),app.channelXValues));
                app.SelectedAreaEndEditField.Value=min(cellfun(@(in) in(end),app.channelXValues));
                app.SelectedAreaDurationEditField.Value=app.SelectedAreaEndEditField.Value-app.SelectedAreaStartEditField.Value;

                %end
            end


        end

        function updateSelectionAreaEditFieldsLimits(app)

            if isempty(app.DraggingData.StartX) % e.g. when deleting all channels and setting those fields to inf, this function is called also
                return;
            end

            channelEndTimes=(cellfun(@numel,app.channelYValues)-1)./app.channelSampleRates+app.channelLag;

            if isinf(app.SelectedAreaStartEditField.Value)
                drawRects=0;
            else
                drawRects=1;
            end

            app.SelectedAreaEndEditField.Value=min([channelEndTimes,app.SelectedAreaEndEditField.Value]);
            app.SelectedAreaStartEditField.Value=max([app.channelLag,app.SelectedAreaStartEditField.Value]);

            app.SelectedAreaEndEditField.Value=max([app.channelLag,app.SelectedAreaEndEditField.Value]);
            app.SelectedAreaStartEditField.Value=min([channelEndTimes,app.SelectedAreaStartEditField.Value]);

            app.SelectedAreaDurationEditField.Value=app.SelectedAreaEndEditField.Value-app.SelectedAreaStartEditField.Value;

            % set rect dragging data appropriatly
            %if ~isempty(app.DraggingData.StartX)
            app.DraggingData.StartX=app.SelectedAreaStartEditField.Value;
            app.DraggingData.EndX=app.SelectedAreaEndEditField.Value;

            % also change displayed rectangles, if displayed
            if ~isempty(app.DraggingData.CurrentRectangles)
                for rectNr=1:numel(app.DraggingData.CurrentRectangles)
                    app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.SelectedAreaStartEditField.Value,app.SelectedAreaDurationEditField.Value];
                end
            elseif drawRects
                rectsTime=gobjects(1,numel(app.channelAxes));
                rectsSpec=gobjects(1,numel(app.channelAxes));
                for rectNr=1:numel(app.channelAxes)


                    % lets use the full yrange instead to minimize
                    % later renderer updates

                    %xlimits=xlim(app.channelAxes(rectNr));
                    %excerpt=app.channelYValues{rectNr}(app.channelXValues{rectNr}>=xlimits(1) & app.channelXValues{rectNr}<=xlimits(2));
                    %ylimits=[min(excerpt) max(excerpt)];

                    ylimits=[min(app.channelYValues{rectNr}) max(app.channelYValues{rectNr})];
                    ylim(app.channelAxes(rectNr),'manual');

                    ylimits=ylimits+[-1 1]*app.timePlotPadPercentage*range(ylimits);
                    yMin=ylimits(1);
                    yMax=ylimits(2);

                    ylim(app.channelAxes(rectNr),'manual');
                    rectsTime(rectNr)=rectangle(app.channelAxes(rectNr), ...
                        'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.5,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none');
                    % app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.SelectedAreaStartEditField.Value,app.SelectedAreaDurationEditField.Value];

                    yMin=min(app.spectralPlotHandles(rectNr).YData);
                    yMax=max(app.spectralPlotHandles(rectNr).YData);
                    rectsSpec(rectNr)=rectangle(app.channelAxesSpectral(rectNr), ...
                        'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.2,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none');
                end
                app.DraggingData.CurrentRectangles=rectsTime;
                arrayfun(@(in) uistack(in,'bottom'),rectsTime);

                app.spectralRectangles=rectsSpec;
                arrayfun(@(in) uistack(in,'top'),rectsSpec);
            end

            %end

            app.refreshSelectionEvaluationText();

        end

        function uiMenuFilterDataCallback(app,channelNr)
            %channelNr=axisHandle.UserData.channelNr;
            yDataIn=app.channelYValues{channelNr};
            fsIn=round(app.channelSampleRates(channelNr));

            filterToolboxApp=interactiveFiltering();
            if strcmp(app.channelSource{channelNr},'GAW')
                filterToolboxApp.Preserve0valuesandclipbelowCheckBox.Value=1;
            end
            %filterToolboxApp.UIFigure.WindowStyle='modal';

            filterToolboxApp.UIFigure.Theme='light';
            filterToolboxApp.originalData=yDataIn;
            filterToolboxApp.originalFs=fsIn;
            filterToolboxApp.setFreqMaxValues();
            filterToolboxApp.refreshFilterPlot();
            filterToolboxApp.refreshDataPlot();

            waitfor(filterToolboxApp,'finalOutputData');
            if isvalid(filterToolboxApp) % if filter tools were closed by apply button

                outputData=filterToolboxApp.finalOutputData;
                app.channelYValues{channelNr}=outputData;
                app.timePlotHandles(channelNr).YData=outputData;
                app.createAudioPlayerData();

                app.addValueSetToValueHistory(outputData,app.timePlotHandles(channelNr).XData,channelNr)

                ylim(app.channelAxes(channelNr),[min(outputData) max(outputData)]+[-1 1]*app.timePlotPadPercentage*range(outputData));


                delete(filterToolboxApp);




            else % if just the window was closed

                % when doing that, the settings are deleted if calculated
                % before
                %                 app.calculationSettings=[];
                %                 app.calculationCalledAsPreview=[];
                return;
            end
        end

        function performBasicChannelEditing(app,OriginatingChannelNr,oneSomeOrAllChannels,wholeOrMarked,actionToPerform)


            if strcmpi(oneSomeOrAllChannels,'displayed')
                channelsToEdit=app.availableChannelsTable.Selection;
            elseif strcmpi(oneSomeOrAllChannels,'all')
                channelsToEdit=1:size(app.availableChannelsTable.Data,1);
            else % 'this'
                channelsToEdit=OriginatingChannelNr;
            end

            if ~isempty(app.DraggingData.StartX)

                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
            else
                selectionStart=app.SelectedAreaStartEditField.Value;
                selectionEnd=app.SelectedAreaEndEditField.Value;
            end


            for channelNr=channelsToEdit
                currXData=app.channelXValues{channelNr};
                currYData=app.channelYValues{channelNr};
                currFs=app.channelSampleRates(channelNr);


                if ~strcmp(actionToPerform,'leadingZerosToLag')


                    if strcmpi(wholeOrMarked,'whole') % affect whole channel
                        destinationExcerpt=true(size(app.channelYValues{channelNr}));
                    else %% affect only selected region
                        destinationExcerpt=currXData>=selectionStart & currXData<=selectionEnd;
                    end

                    if contains(actionToPerform,'Selection')
                        sourceExcerpt=currXData>=selectionStart & currXData<=selectionEnd;
                    else
                        sourceExcerpt=true(size(app.channelYValues{channelNr}));
                    end

                    if strcmpi(wholeOrMarked,'whole') && contains(actionToPerform,'selectionDifferential')
                        sourceExcerpt=currXData>=selectionStart & currXData<=selectionEnd;
                        destinationExcerpt=currXData>=selectionStart;
                    end

                    if strcmpi(wholeOrMarked,'whole') && contains(actionToPerform,'deleteInverse')
                        sourceExcerpt=currXData<selectionStart | currXData>selectionEnd;
                        destinationExcerpt=sourceExcerpt;
                    end

                    currSourceYData=app.channelYValues{channelNr}(sourceExcerpt);

                end


                switch actionToPerform
                    case 'delete'
                        currYData(destinationExcerpt)=[];

                        if destinationExcerpt(1)==0 % of not the first sample is selected, delete values and concatenate
                            currXData=(0:numel(currYData)-1)/app.channelSampleRates(channelNr)+app.channelLag(channelNr);
                        else % if the first value is selected, we do not want to move the rest of the signal to make it start from channelLag, but keep the time values and set the lag appropriately
                            currXData(destinationExcerpt)=[];
                            app.channelLag(channelNr)=currXData(1);
                        end
                        if ~isempty(app.DraggingData.StartX)
                            app.updateSelectionAreaEditFieldsLimits();
                        end
                    case 'deleteInverse'
                        currYData(destinationExcerpt)=[];
                        currXData(destinationExcerpt)=[];
                        app.channelLag(channelNr)=currXData(1);
                        if ~isempty(app.DraggingData.StartX)
                            app.updateSelectionAreaEditFieldsLimits();
                        end

                    case 'linearRamp'
                        currYData(destinationExcerpt)=linspace(currSourceYData(1),currSourceYData(end),sum(destinationExcerpt));

                        %% changes in differential
                    case 'selectionDifferentialMinToZero'
                        %initVal=currYData(sourceExcerpt);
                        %initVal=initVal(1);

                        differential=diff(currYData(sourceExcerpt));
                        [value,minIdx]=min(differential);
                        %differential(minIdx)=0;

                        %currYData(destinationExcerpt)=cumsum([0; differential(:)]+initVal);
                        currYData(find(sourceExcerpt==1,1,"first")+minIdx:end)=currYData(find(sourceExcerpt==1,1,"first")+minIdx:end)-value;
                    case 'selectionDifferentialMaxToZero'
                        % initVal=currYData(sourceExcerpt);
                        % initVal=initVal(1);

                        differential=diff(currYData(sourceExcerpt));
                        [value,maxIdx]=max(differential);
                        % differential(maxIdx)=0;

                        % currYData(destinationExcerpt)=cumsum([initVal; differential(:)]);
                        currYData(find(sourceExcerpt==1,1,"first")+maxIdx:end)=currYData(find(sourceExcerpt==1,1,"first")+maxIdx:end)-value;
                    case 'selectionDifferentialAbsMaxToZero'
                        %initVal=currYData(sourceExcerpt);
                        %initVal=initVal(1);

                        differential=diff(currYData(sourceExcerpt));
                        [value,maxIdx]=max(abs(differential));
                        value=sign(differential(maxIdx))*value;

                        %differential(maxIdx)=0;

                        %currYData(destinationExcerpt)=cumsum([0; differential(:)]+initVal);

                        currYData(find(sourceExcerpt==1,1,"first")+maxIdx:end)=currYData(find(sourceExcerpt==1,1,"first")+maxIdx:end)-value;

                        %% set to value...
                    case 'setToZero'
                        currYData(destinationExcerpt)=0;
                    case 'setToChannelMin'
                        currYData(destinationExcerpt)=min(currSourceYData);
                    case 'setToSelectionMin'
                        currYData(destinationExcerpt)=min(currSourceYData);
                    case 'setToChannelMax'
                        currYData(destinationExcerpt)=max(currSourceYData);
                    case 'setToSelectionMax'
                        currYData(destinationExcerpt)=max(currSourceYData);
                    case 'setToChannelMean'
                        currYData(destinationExcerpt)=mean(currSourceYData);
                    case 'setToSelectionMean'
                        currYData(destinationExcerpt)=mean(currSourceYData);
                    case 'setToChannelMedian'
                        currYData(destinationExcerpt)=median(currSourceYData);
                    case 'setToSelectionMedian'
                        currYData(destinationExcerpt)=median(currSourceYData);

                        %% add value...
                    case 'addChannelMin'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+min(currYData(sourceExcerpt));
                    case 'addSelectionMin'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+min(currYData(sourceExcerpt));
                    case 'addChannelMax'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+max(currYData(sourceExcerpt));
                    case 'addSelectionMax'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+max(currYData(sourceExcerpt));
                    case 'addChannelMean'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+mean(currYData(sourceExcerpt));
                    case 'addSelectionMean'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+mean(currYData(sourceExcerpt));
                    case 'addChannelMedian'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+median(currYData(sourceExcerpt));
                    case 'addSelectionMedian'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)+median(currYData(sourceExcerpt));

                        %% subtract value...
                    case 'subtractChannelMin'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-min(currYData(sourceExcerpt));
                    case 'subtractSelectionMin'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-min(currYData(sourceExcerpt));
                    case 'subtractChannelMax'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-max(currYData(sourceExcerpt));
                    case 'subtractSelectionMax'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-max(currYData(sourceExcerpt));
                    case 'subtractChannelMean'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-mean(currYData(sourceExcerpt));
                    case 'subtractSelectionMean'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-mean(currYData(sourceExcerpt));
                    case 'subtractChannelMedian'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-median(currYData(sourceExcerpt));
                    case 'subtractSelectionMedian'
                        currYData(destinationExcerpt)=currYData(destinationExcerpt)-median(currYData(sourceExcerpt));

                        %% convert leading zeros to lag
                    case 'leadingZerosToLag'
                        firstNonZero=find(currYData~=0,1,"first");
                        if firstNonZero==1 % abort then
                            continue;
                        end
                        app.channelLag(channelNr)=currXData(firstNonZero);
                        currYData(1:firstNonZero-1)=[];
                        currXData(1:firstNonZero-1)=[];

                        if ~isempty(app.DraggingData.StartX) && app.DraggingData.StartX<currXData(1)
                            newStartX=currXData(1);
                            newWidth=app.DraggingData.EndX-newStartX;

                            if newWidth>0
                                for rectNr=1:numel(app.DraggingData.CurrentRectangles)
                                    app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[newStartX newWidth];
                                end
                                app.DraggingData.StartX=newStartX;
                                app.DraggingData.EndX=newStartX+newWidth;
                            else
                                delete(app.DraggingData.CurrentRectangles);
                                app.DraggingData.CurrentRectangles=[];
                                app.DraggingData.StartX=[];
                                app.DraggingData.EndX=[];
                            end

                            app.updateSelectionAreaEditFieldsValues();

                        end

                        %% padding
                    case 'prepadToEarliestStart'
                        earliestStart=min(cellfun(@min,app.channelXValues));
                        if earliestStart<=currXData(1)-1/currFs
                            prepadT=(currXData(1)-1/currFs):-1/currFs:earliestStart;
                            prepadT=flip(prepadT);

                            currXData=[prepadT';currXData];
                            currYData=[zeros(numel(prepadT),1);currYData];
                        end

                    case 'postpadToLatestEnd'
                        latestStart=max(cellfun(@max,app.channelXValues));
                        if latestStart>=currXData(end)+1/currFs
                            postpadT=(currXData(end)+1/currFs):1/currFs:latestStart;

                            currXData=[currXData;postpadT'];
                            currYData=[currYData;zeros(numel(postpadT),1)];
                        end

                    case 'preAndPostPad'
                        earliestStart=min(cellfun(@min,app.channelXValues));
                        if earliestStart<=currXData(1)-1/currFs
                            prepadT=(currXData(1)-1/currFs):-1/currFs:earliestStart;

                            currXData=[prepadT';currXData];
                            currYData=[zeros(numel(prepadT),1);currYData];
                        end

                        latestStart=max(cellfun(@max,app.channelXValues));
                        if latestStart>=currXData(end)+1/currFs
                            postpadT=(currXData(end)+1/currFs):1/currFs:latestStart;

                            currXData=[currXData;postpadT'];
                            currYData=[currYData;zeros(numel(postpadT),1)];
                        end

                end


                app.channelYValues{channelNr}=currYData;
                app.channelXValues{channelNr}=currXData;

                app.addValueSetToValueHistory(currYData,currXData,channelNr);


                set(app.timePlotHandles(channelNr),'XData',currXData,'YData',currYData);

                currXLim=xlim(app.channelAxes(channelNr));
                displayMask=app.channelXValues{channelNr}>=currXLim(1) & app.channelXValues{channelNr}<=currXLim(2);
                newylims=[min(currYData(displayMask)) max(currYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(currYData(displayMask));
                ylim(app.channelAxes(channelNr),newylims);

                if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                    app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newylims(1) newylims(2)-newylims(1)];
                end


            end

            if ~app.batchMode

                app.refreshInteractionMode();
    
                app.refreshSelectionEvaluationText();

            end



            %ylim(app.channelAxes,'padded');
            %drawnow;
            %ylim(app.channelAxes,'manual');
        end

        function populateResultsTable(app)
            app.FilterResultsTableEditField.Value='';

            nWindows=app.calculationResults.numberOfWindows;
            nChannels=numel(app.calculationResults.channelResults);

            % organize by parameter type

            parameterNames=fieldnames(app.calculationResults.channelResults);

            parameterNames(contains(parameterNames,{'curr'},"IgnoreCase",true))=[];
            parameterNames(ismember(parameterNames,{'cycleBorderVals' 'cycleDurations' 'allOQBorders' 'allClQBorders'}))=[];
            parameterNames(contains(parameterNames,'_Unit'))=[];



            app.parameterResultsUITable.Data=[];
            TableHeader={'Channel name','Parameter','Parameter Unit','Source','Median','Mean','STD','Min','Max'};

            windowHeaders=arrayfun(@(x) ['window ' num2str(x)], 1:nWindows, 'UniformOutput', false);
            TableHeader=[TableHeader windowHeaders {''}];
            app.parameterResultsUITable.ColumnName=TableHeader;
            app.parameterResultsUITable.ColumnWidth=[repelem({'fit'},numel(TableHeader)-1) {'1x'}];
            app.parameterResultsUITable.ColumnFormat=[repelem({''}, 4) repelem({'shortG'}, numel(TableHeader)-4)];

            channelShortNames=app.shortenNames(app.channelNames);

            tableData={};
            app.currentResultsTableChannelSources=[];
            for parameterNr=1:numel(parameterNames)
                windowValues={app.calculationResults.channelResults.(parameterNames{parameterNr})}';

                channelsInWhichTheParameterExists=~cellfun(@isempty,windowValues);

                % EGG the quotients are only calucated for EGG and GAW
                windowValues=windowValues(channelsInWhichTheParameterExists);

                medians=cellfun(@(in) median(in,"omitmissing"),windowValues,'UniformOutput',false);
                means=cellfun(@(in) mean(in,'omitmissing'),windowValues,'UniformOutput',false);
                stds=cellfun(@(in) std(in,'omitmissing'),windowValues,'UniformOutput',false);
                mins=cellfun(@(in) min(in,[],'omitmissing'),windowValues,'UniformOutput',false);
                maxs=cellfun(@(in) max(in,[],'omitmissing'),windowValues,'UniformOutput',false);


                currnames=channelShortNames(channelsInWhichTheParameterExists);
                currparams=repelem(parameterNames(parameterNr),sum(channelsInWhichTheParameterExists),1);
                currsources=app.channelSource(channelsInWhichTheParameterExists)';
                currparamunits=cellstr(vertcat(app.calculationResults.channelResults.([parameterNames{parameterNr} '_Unit'])));

                currnames=currnames(:);
                currparams=currparams(:);
                currsources=currsources(:);

                try
                    tableData=[tableData;...
                    currnames currparams currparamunits currsources medians means stds mins maxs num2cell(cell2mat(windowValues)) repelem({''},sum(channelsInWhichTheParameterExists),1)];
                catch ME
                    tableData
                    rethrow(ME);
                end

                app.currentResultsTableChannelSources=[app.currentResultsTableChannelSources; find(channelsInWhichTheParameterExists)];
            end

            removeStyle(app.parameterResultsUITable);

            % center text
            centerStyle=uistyle('HorizontalAlignment','center');
            addStyle(app.parameterResultsUITable,centerStyle,"column",2:4)


            [app.parameterResultsUITable.Data,idx]=sortrows(tableData,2,'ascend');
            app.currentResultsTableChannelSources=app.currentResultsTableChannelSources(idx);

            % save the full results table as USerData to the Filter Line to
            % be able to remove non fitting rows
            app.FilterResultsTableEditField.UserData.ResultsTable=app.parameterResultsUITable.Data;


            app.ResultsTab.Parent=app.TabGroup;

            app.parameterResultsUITable.Enable='on';
            app.SaveResultsButton.Enable='on';

        end





        function result = splitCharArray(~,inputArray, maxLength)
            % Initialize output cell array
            result = {};
            while ~isempty(inputArray)
                % Check if remaining part is longer than maxLength
                if length(inputArray) > maxLength
                    % Find last space within maxLength to split neatly
                    splitPoint = find(inputArray(1:maxLength) == ' ', 1, 'last');
                    if isempty(splitPoint)
                        % No space found, split at maxLength
                        splitPoint = maxLength;
                    end
                else
                    % Use remaining length if shorter than maxLength
                    splitPoint = length(inputArray);
                end
                % Extract substring and add to result
                result{end+1} = inputArray(1:splitPoint);
                % Remove the processed part from inputArray
                inputArray = strtrim(inputArray(splitPoint+1:end));
            end
        end


        function uiMenuUndoDataChangeCallback(app,channelNr)



            %

            nonEmptyCells=~cellfun(@isempty,app.channelYValuesHistory(:,channelNr));

            if sum(nonEmptyCells)==1 % if there is still the original data or if only one filtering process was done
                return;
            else
                lastNonEmpty=find(nonEmptyCells,1,'last');

                % Y Values
                app.channelYValues(channelNr)=app.channelYValuesHistory(lastNonEmpty-1,channelNr);
                app.channelYValuesHistory{lastNonEmpty,channelNr}=[];

                % X Values
                app.channelXValues(channelNr)=app.channelXValuesHistory(lastNonEmpty-1,channelNr);
                app.channelXValuesHistory{lastNonEmpty,channelNr}=[];

                app.channelLag(channelNr)=app.channelXValues{channelNr}(1);

                % we also need to restore fs when undoing e.g. resampling
                app.channelSampleRates(channelNr)=round(1/min(diff(app.channelXValues{channelNr})));
            end

            app.timePlotHandles(channelNr).YData=app.channelYValues{channelNr};
            app.timePlotHandles(channelNr).XData=app.channelXValues{channelNr};
            app.createAudioPlayerData();

            app.refreshSpectralPlots(channelNr);

            try
                app.calculationResults.channelResults(channelNr).cycleBorderVals=NaN;
                delete(app.cycleBorderHandles(channelNr));
            end

            drawnow;

            %ylim(app.channelAxes(channelNr),'padded');
            %app.minimizeYLims(app.channelAxes(channelNr));

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=app.channelXValues{channelNr}>=currXLim(1) & app.channelXValues{channelNr}<=currXLim(2);
            newYLimits=[min(app.channelYValues{channelNr}(displayMask)) max(app.channelYValues{channelNr}(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(app.channelYValues{channelNr}(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end

            app.refreshInteractionMode();

            app.refreshSelectionEvaluationText(channelNr);



        end




        function shortNames = shortenNames(~, nameList)
            if isempty(nameList)
                shortNames = {};
                return;
            elseif isscalar(nameList)
                shortNames = nameList;
                return;
            end

            % Step 1: Identify common word-based prefixes across meaningful subsets
            prefixCounts = containers.Map;
            for i = 1:length(nameList)
                for j = i+1:length(nameList)
                    commonPrefix = getCommonWordPrefix(nameList{i}, nameList{j});
                    if ~isempty(commonPrefix)
                        if isKey(prefixCounts, commonPrefix)
                            prefixCounts(commonPrefix) = prefixCounts(commonPrefix) + 1;
                        else
                            prefixCounts(commonPrefix) = 2; % At least two occurrences
                        end
                    end
                end
            end

            % Filter out prefixes that appear in too few entries
            minGroupSize = 2; % Require at least two occurrences to consider removing
            validPrefixes = keys(prefixCounts);
            validPrefixes = validPrefixes(cellfun(@(x) prefixCounts(x) >= minGroupSize, validPrefixes));

            % Sort prefixes by word count (longest first)
            [~, idx] = sort(cellfun(@(x) numel(strsplit(convertCharsToStrings(x), ' ')), validPrefixes), 'descend');
            validPrefixes = validPrefixes(idx);

            % Step 2: Remove meaningful word prefixes within subsets while ensuring non-empty output
            shortNames = nameList;
            for i = 1:length(nameList)
                for p = validPrefixes
                    if startsWith(nameList{i}, p{1})
                        tempName = erase(nameList{i}, p{1});
                        tempName = strtrim(tempName); % Trim leading/trailing spaces
                        if ~isempty(tempName) % Prevent empty strings
                            shortNames{i} = tempName;
                        end
                        break; % Remove only one prefix per name
                    end
                end
            end



            % Nested function to find common word-based prefix
            function wp = getCommonWordPrefix(str1, str2)
                % Ensure both inputs are strings or cell arrays properly converted
                str1 = convertCharsToStrings(str1);
                str2 = convertCharsToStrings(str2);

                words1 = strsplit(str1, ' ');
                words2 = strsplit(str2, ' ');
                minLen = min(length(words1), length(words2));

                wp = {}; % Use a cell array to collect words safely
                for k = 1:minLen
                    if strcmp(words1{k}, words2{k})
                        wp{end+1} = words1{k}; %#ok<AGROW> Collect words as cell array
                    else
                        break;
                    end
                end

                wp = strjoin(wp, ' '); % Convert cell array to a single string safely
            end
        end








        function patchObj=addManyPatchesAsSinglePatch(app,channelNr,x_pairs,facecolor,facealpha,vis)
            if nargin<4 || isempty(facecolor)
                facecolor='blue';
            end

            if nargin<5 || isempty(facealpha)
                facealpha=0.3;
            end

            ax=app.channelAxes(channelNr);

            num_patches = size(x_pairs,1);

            %ylims=ylim(ax);

            xlims=xlim(ax);
            currydata=app.timePlotHandles(channelNr).YData(app.timePlotHandles(channelNr).XData>=xlims(1) & app.timePlotHandles(channelNr).XData<=xlims(2));
            ylims=[min(currydata) max(currydata)]+[-1 1]*app.timePlotPadPercentage*range(currydata);

            % Preallocate arrays for vertex coordinates
            vertices = zeros(num_patches * 4, 2); % Each patch has 4 corners
            faces = zeros(num_patches, 4);        % Each face links four vertices

            for i = 1:num_patches
                idx = (i-1)*4 + (1:4); % Index range for vertices

                % Define the four corners of the rectangle
                vertices(idx, :) = [ ...
                    x_pairs(i,1), ylims(1); % Bottom-left
                    x_pairs(i,2), ylims(1); % Bottom-right
                    x_pairs(i,2), ylims(2); % Top-right
                    x_pairs(i,1), ylims(2)  % Top-left
                    ];

                % Define the face linking the four vertices
                faces(i, :) = idx;
            end

            % Create a single patch object using FaceVertexData
            patchObj=patch(ax,'Faces', faces, 'Vertices', vertices, 'FaceColor', facecolor, ...
                'FaceAlpha', facealpha, 'EdgeColor', 'none','HitTest','off','Visible',vis);

        end



        function addValueSetToValueHistory(app,newDataYArray,newDataXArray,channelNr)

            % add data to history cell
            nonEmptyCells=~cellfun(@isempty,app.channelYValuesHistory(:,channelNr));
            if all(nonEmptyCells)
                app.channelYValuesHistory(end+1,channelNr)={newDataYArray};
                app.channelXValuesHistory(end+1,channelNr)={newDataXArray};
            else
                app.channelYValuesHistory(find(~nonEmptyCells,1,"first"),channelNr)={newDataYArray};
                app.channelXValuesHistory(find(~nonEmptyCells,1,"first"),channelNr)={newDataXArray};
            end

        end

        function accelerator=getLowerLeftAccelerator(~)
            accelerator='Y';
            if ispc
                % Add the .NET assembly for Windows Forms (if not already loaded)
                NET.addAssembly('System.Windows.Forms');

                % Get the current input language object
                inputLang = System.Windows.Forms.InputLanguage.CurrentInputLanguage;

                % Retrieve the layout name and culture information
                layoutName  = char(inputLang.LayoutName);
                cultureName = char(inputLang.Culture.EnglishName);

                % Decide on the accelerator key based on common layout conventions:
                % For a German keyboard (QWERTZ), the lower left key is usually 'Y',
                % while for a US/UK keyboard (QWERTY), it is usually 'Z'.
                if contains(layoutName, 'German', 'IgnoreCase', true) || ...
                        contains(cultureName, 'Germany', 'IgnoreCase', true)
                    accelerator = 'Y';
                elseif contains(layoutName, 'French', 'IgnoreCase', true) || ...
                        contains(cultureName, 'France', 'IgnoreCase', true)
                    accelerator = 'W';
                elseif contains(layoutName, 'Belgian', 'IgnoreCase', true)
                    accelerator = 'W';
                elseif contains(layoutName, 'Spanish', 'IgnoreCase', true) || ...
                        contains(cultureName, 'Spain', 'IgnoreCase', true)
                    accelerator = 'Z';
                elseif contains(layoutName, 'Italian', 'IgnoreCase', true) || ...
                        contains(cultureName, 'Italy', 'IgnoreCase', true)
                    accelerator = 'Z';
                else
                    % Fallback: assume QWERTY.
                    accelerator = 'Z';
                end
            else
                disp('Getting lower left keyboard accelerator key only supported for windows.');
            end
        end


        function updateChannelName(app)

            if isempty(app.channelAxes) || any(~ishandle(app.channelAxes))
                return;
            end

            try
                currentTitlesOnAxes=get([app.channelAxes.Title],'String');

                for titleNr=1:numel(currentTitlesOnAxes)
                    if iscell(currentTitlesOnAxes{titleNr})
                        currentTitlesOnAxes{titleNr}=strjoin(currentTitlesOnAxes{titleNr},'');
                    end
                end

                if size(currentTitlesOnAxes,1)>size(currentTitlesOnAxes,2)
                    currentTitlesOnAxes=currentTitlesOnAxes';
                end

                % welaso have to refresh the actual channel names!
                app.channelNames=currentTitlesOnAxes;

                shortNames=app.shortenNames(currentTitlesOnAxes);

                app.availableChannelsTable.Data(:,1)=shortNames;

            catch ME
                disp(ME.getReport());
            end




            % newChannelName=app.channelAxes(channelNr).Title.String;
            %
            % if iscell(newChannelName) && isscalar(newChannelName) % one liner
            %     newChannelName=newChannelName{1};
            % elseif ~ischar(newChannelName)
            %     newChannelName=strjoin(newChannelName);
            % end
            % app.channelNames{channelNr}=newChannelName;
            %
            % if ~isempty(app.availableChannelsTable) % when deleting all channels, this coud interfer by setting the data property to the channels names, effectively not deleting the available channels table
            %     %app.availableChannelsTable.Data{channelNr,1}=newChannelName;
            %     app.availableChannelsTable.Data(:,1)=app.shortenNames(app.channelNames);
            % end
            % %app.populateResultsTable();
        end

        function results = isvalidhandle(~,in)
            results=ishandle(in) & isvalid(in);
        end

        function path=exportChannelsToWAV(app,toMultiChannel,selectedChannelsOnly,completepath)




            if selectedChannelsOnly && isempty(app.availableChannelsTable.Selection)
                return; % if no channels are selected but only selected files shall be exported, abort
            end

            if nargin<4 || isempty(completepath)
                fakefig=figure('Visible','off');

                persistent lastPath;

                [file,path,index]=uiputfile({'*.wav','32-bit float';'*.wav','64-bit float'},'Where to save wav files',[lastPath 'exportedData']);

                close(fakefig);
                figure(app.UIFigure);
                if isequal(path,0)
                    return;
                end

                lastPath=path;
            else
                [path,file,ext]=fileparts(completepath);
                path=[path filesep];
                file=[file ext];
                index=1;
            end

            % if there is a marked area available
            % if ~isempty(app.DraggingData) && ~isempty(app.DraggingData.StartX) && app.DraggingData.StartX~=app.DraggingData.EndX%(app.DraggingData.EndX-app.DraggingData.StartX)>0.1
            %     startTime = app.DraggingData.StartX;
            %     endTime = app.DraggingData.EndX;
            % else
            % if nothing was marked yet, play the most common points in
            % time
            startTime=min(cellfun(@(in) in(1),app.channelXValues));
            endTime=max(cellfun(@(in) in(end),app.channelXValues));
            % end

            if selectedChannelsOnly
                channelsToSave=app.availableChannelsTable.Selection;
            else
                channelsToSave=1:numel(app.channelAxes);
            end

            if index == 2
                BITS = 64;
            else
                BITS = 32;
            end

            sampleRatesForExport=app.channelSampleRates(channelsToSave);
            yValuesForExport=app.channelYValues(channelsToSave);
            xValuesForExport=app.channelXValues(channelsToSave);
            sourceTypesForExport=app.channelSource(channelsToSave);
            namesForExport=app.channelNames(channelsToSave);


            [xSetValuesOut, ySetValuesOut] = app.prepadPostpadToCommonRange(xValuesForExport, yValuesForExport, sampleRatesForExport,startTime,endTime);

            [uniqueSampleRates,~,groupNumber]=unique(sampleRatesForExport,'stable');

            if toMultiChannel
                listOfChannelTypes={};
                listOfChannelNames={};
                listOfYHistory={};
                listOfXHistory={};
                for i = 1:numel(uniqueSampleRates)
                    idxGroup = groupNumber == i;
                    signalsGroup = ySetValuesOut(idxGroup);

                    listOfChannelTypes=[listOfChannelTypes sourceTypesForExport(idxGroup)];

                    curnames=namesForExport(idxGroup);
                    if size(curnames,1)>size(curnames,2)
                        curnames=curnames';
                    end

                    listOfChannelNames=[listOfChannelNames curnames];
                    listOfYHistory=[listOfYHistory app.channelYValuesHistory(:,idxGroup)];
                    listOfXHistory=[listOfXHistory app.channelXValuesHistory(:,idxGroup)];

                    minSize=min(cellfun(@numel,signalsGroup));
                    signalsGroup=cellfun(@(in) in(1:minSize),signalsGroup,'UniformOutput',false);

                    % Directly form multi-channel matrix assuming equal length signals
                    multiChannelData = horzcat(signalsGroup{:});

                    % Compose filename for this sample rate group
                    [~, name, ext] = fileparts(file);

                    if numel(uniqueSampleRates)>1
                        saveFileName = fullfile(path, [name sprintf('_%03i_fs-%dHz', i, uniqueSampleRates(i)) ext]);
                    else
                        saveFileName = fullfile(path, [name ext]);
                    end

                    % Save multi-channel WAV
                    audiowrite(saveFileName, multiChannelData, uniqueSampleRates(i), 'BitsPerSample', BITS);

                    if ~isempty(app.DraggingData) && ~isempty(app.DraggingData.StartX) && app.DraggingData.StartX~=app.DraggingData.EndX%(app.DraggingData.EndX-app.DraggingData.StartX)>0.1
                        markingStart = app.DraggingData.StartX;
                        markingEnd = app.DraggingData.EndX;

                        firstIdx=round((markingStart-startTime)*uniqueSampleRates(i));
                        lastIdx=round((markingEnd-startTime)*uniqueSampleRates(i));
                        % here the cut version
                        audiowrite(replace(saveFileName,'.wav','_cut.wav'), multiChannelData(firstIdx:lastIdx,:), uniqueSampleRates(i), 'BitsPerSample', BITS);
                    end
                end

                sources=listOfChannelTypes;
                names=listOfChannelNames;
                yhistory=listOfYHistory;
                xhistory=listOfXHistory;
                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
                appVersion=app.currentAppVersion;

                save(fullfile(path, [strrep(name,'_channelData','') '_fullSessionData.mat']),'sources','names','yhistory',"xhistory","selectionEnd","selectionStart","appVersion");


            else
                for channelNr = 1:numel(ySetValuesOut)
                    ySingleChannel = ySetValuesOut{channelNr};
                    fs = sampleRatesForExport(channelNr);
                    [~, name, ext] = fileparts(file);
                    saveFileName = fullfile(path, [name sprintf('-channel%02d', app.availableChannelsTable.Selection(channelNr)) ext]);
                    audiowrite(saveFileName, ySingleChannel, fs, 'BitsPerSample', BITS);

                    if ~isempty(app.DraggingData) && ~isempty(app.DraggingData.StartX) && app.DraggingData.StartX~=app.DraggingData.EndX%(app.DraggingData.EndX-app.DraggingData.StartX)>0.1
                        markingStart = app.DraggingData.StartX;
                        markingEnd = app.DraggingData.EndX;

                        firstIdx=round((markingStart-startTime)*fs);
                        lastIdx=round((markingEnd-startTime)*fs);
                        % here the cut version
                        audiowrite(replace(saveFileName,'.wav','_cut.wav'), ySingleChannel(firstIdx:lastIdx,:), fs, 'BitsPerSample', BITS);
                    end
                end
            end


        end

        function calibrationByStartEnd(app,channelNr)
            if ~isempty(app.DraggingData.StartX)
                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
            else
                selectionStart=app.SelectedAreaStartEditField.Value;
                selectionEnd=app.SelectedAreaEndEditField.Value;
            end


            targetValue=0;

            %% create figure
            fig=uifigure('Units','normalized','Position',[0 0 0.5 0.08],'Visible','off','Theme','light');
            movegui(fig,'center');

            drawnow;
            fig.Visible='on';

            gl=uigridlayout(fig,[2 2],"ColumnWidth",{'1x','fit'},'RowSpacing',1);

            label=uilabel(gl,"Text",'End minus start equals which value?','WordWrap','on');
            label.Layout.Column=1;

            persistent editFieldValue

            if isempty(editFieldValue)
                editFieldValue=-20;
            end

            editField=uieditfield(gl,'numeric','Limits',[-inf inf],'Tooltip','Use 0 or close window if you want to cancel','Value',editFieldValue);
            editField.Layout.Column=2;

            applyButton=uibutton(gl,'Text','apply','ButtonPushedFcn',@saveAndClose);
            applyButton.Layout.Column=2;
            applyButton.Layout.Row=2;

            function saveAndClose(~,~)
                targetValue=editField.Value;
                editFieldValue=editField.Value;
                delete(fig);
            end

            uiwait(fig);

            %% now do something with the result
            if targetValue==0
                return;
            end

            currYData=app.channelYValues{channelNr};
            currXData=app.channelXValues{channelNr};
            currYExcerpt=currYData(currXData>=selectionStart & currXData<=selectionEnd);

            calibrationFactor=targetValue/(currYExcerpt(end)-currYExcerpt(1));

            newYData=currYData*calibrationFactor;

            % add this as version
            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=currXData>=currXLim(1) & currXData<=currXLim(2);
            newYLimits=[min(newYData(displayMask)) max(newYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(newYData(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end

        end

        function calibrationBySummedArea(app,channelNr)
            if ~isempty(app.DraggingData.StartX)
                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
            else
                selectionStart=app.SelectedAreaStartEditField.Value;
                selectionEnd=app.SelectedAreaEndEditField.Value;
            end


            targetValue=0;

            %% create figure
            fig=uifigure('Units','normalized','Position',[0 0 0.5 0.08],'Visible','off','Theme','light');
            movegui(fig,'center');

            drawnow;
            fig.Visible='on';

            gl=uigridlayout(fig,[2 2],"ColumnWidth",{'1x','fit'},'RowSpacing',1);

            label=uilabel(gl,"Text",'summed amplitudes equals which value?','WordWrap','on');
            label.Layout.Column=1;

            persistent editFieldValue

            if isempty(editFieldValue)
                editFieldValue=140;
            end

            editField=uieditfield(gl,'numeric','Limits',[-inf inf],'Tooltip','Use 0 or close window if you want to cancel','Value',editFieldValue);
            editField.Layout.Column=2;

            applyButton=uibutton(gl,'Text','apply','ButtonPushedFcn',@saveAndClose);
            applyButton.Layout.Column=2;
            applyButton.Layout.Row=2;

            function saveAndClose(~,~)
                targetValue=editField.Value;
                editFieldValue=editField.Value;
                delete(fig);
            end

            uiwait(fig);

            %% now do something with the result
            if targetValue==0
                return;
            end

            currYData=app.channelYValues{channelNr};
            currXData=app.channelXValues{channelNr};
            currYExcerpt=currYData(currXData>=selectionStart & currXData<=selectionEnd);

            calibrationFactor=targetValue/sum(currYExcerpt);

            newYData=currYData*calibrationFactor;

            % add this as version
            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=currXData>=currXLim(1) & currXData<=currXLim(2);
            newYLimits=[min(newYData(displayMask)) max(newYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(newYData(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end

        end

        function calibrationByAreaSPL(app,channelNr)
            if ~isempty(app.DraggingData.StartX)
                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
            else
                selectionStart=app.SelectedAreaStartEditField.Value;
                selectionEnd=app.SelectedAreaEndEditField.Value;
            end


            targetValue=0;

            persistent splWeighting %splSpeed

            if isempty(splWeighting)
                splWeighting='A-weighting';
                %splSpeed='Fast';

            end


            %% create figure
            fig=uifigure('Units','pixels','Position',[0 0 350 300],'Visible','off','Theme','light');
            movegui(fig,'center');

            drawnow;
            fig.Visible='on';

            gl=uigridlayout(fig,[3 2],"ColumnWidth",{'3x','1x'},'RowSpacing',1);

            spllabel=uilabel(gl,"Text",'which SPL value in marked area?','WordWrap','on');
            spllabel.Layout.Column=1;
            spllabel.Layout.Row=1;

            persistent lastSPLvalue;

            if isempty(lastSPLvalue)
                lastSPLvalue=0;
            end

            editField=uieditfield(gl,'numeric','Limits',[-inf inf],'Tooltip','Use 0 or close window if you want to cancel','Value',lastSPLvalue);
            editField.Layout.Column=2;
            editField.Layout.Row=1;

            spltypelabel=uilabel(gl,"Text",'SPL weighting','WordWrap','on');
            spltypelabel.Layout.Column=1;
            spltypelabel.Layout.Row=2;

            dBtypeDropdown=uidropdown(gl,"Items",{'dB(A)','dB(C)','dB(Z)','none'},'ItemsData',{'A-weighting','C-weighting','Z-weighting','none'},'Value',splWeighting);
            dBtypeDropdown.Layout.Column=2;
            dBtypeDropdown.Layout.Row=2;

            % splSpeedlabel=uilabel(gl,"Text",'SPL time constant','WordWrap','on');
            % splSpeedlabel.Layout.Column=1;
            % splSpeedlabel.Layout.Row=3;
            %
            % dBSpeedDropdown=uidropdown(gl,"Items",{'Fast','Slow'},'Value',splSpeed);
            % dBSpeedDropdown.Layout.Column=2;
            % dBSpeedDropdown.Layout.Row=3;




            applyButton=uibutton(gl,'Text','apply','ButtonPushedFcn',@saveAndClose);
            applyButton.Layout.Column=2;
            applyButton.Layout.Row=3;



            function saveAndClose(~,~)
                targetValue=editField.Value;
                lastSPLvalue=targetValue;
                splWeighting=dBtypeDropdown.Value;
                % splSpeed=dBSpeedDropdown.Value;
                delete(fig);
            end

            uiwait(fig);

            %% now do something with the result
            if targetValue==0
                return;
            end

            currYData=app.channelYValues{channelNr};
            currXData=app.channelXValues{channelNr};
            currYExcerpt=currYData(currXData>=selectionStart & currXData<=selectionEnd);

            % if strcmp(splWeighting,'none')
            %     splDiff=targetValue-20*log10(rms(currYExcerpt)/(20e-6));
            % else
            %     splmeterObj=splMeter('SampleRate',app.channelSampleRates(channelNr),'TimeWeighting',splSpeed,'FrequencyWeighting',splWeighting,"PressureReference",20e-6);
            %     splDiff=targetValue-mean(splmeterObj(currYExcerpt));
            % end
            % calibrationFactor=10^(splDiff/20);

            if strcmp(splWeighting,'none')
                splDiff=targetValue-20*log10(rms(currYExcerpt)/(20e-6));
                calibrationFactor=10^(splDiff/20);
            else
                calibrationFactor=calibrateMicrophone(currYExcerpt,app.channelSampleRates(channelNr),targetValue,'FrequencyWeighting',splWeighting,'PressureReference',20e-6);
            end




            newYData=currYData*calibrationFactor;

            % add this as version
            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=currXData>=currXLim(1) & currXData<=currXLim(2);
            newYLimits=[min(newYData(displayMask)) max(newYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(newYData(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end

        end

        function calibrationByTwoChannels(app)
            if numel(app.channelAxes) < 2
                return;
            end

            % Create main figure for calibration UI
            fig = uifigure('Name','Calibration by channel comparison','Position',[100 100 1000 700],'Toolbar', 'none','Theme','light');
            gl = uigridlayout(fig,[7 12],'Padding',[5 5 5 5],'RowSpacing',5,'ColumnSpacing',5,'RowHeight',{'fit' 'fit' '1x' '1x' '1x' '1x' 'fit'});

            % UI Labels for signals and methods
            lbl1 = uilabel(gl,'Text',{'1. signal','(values to be mapped according signal 2)'},'WordWrap','on');
            lbl1.Layout.Row = 1; lbl1.Layout.Column = [1 2];
            lbl2 = uilabel(gl,'Text',{'2. signal' '(value region to which the signal 1 is mapped)'},'WordWrap','on');
            lbl2.Layout.Row = 1; lbl2.Layout.Column = [3 4];
            lbl3 = uilabel(gl,'Text','Value method');
            lbl3.Layout.Row = 1; lbl3.Layout.Column = [5 6];
            lbl4 = uilabel(gl,'Text','Fit method');
            lbl4.Layout.Row = 1; lbl4.Layout.Column = [7 8];
            lblForced = uilabel(gl,'Text','Forced Point');
            lblForced.Layout.Row = 1; lblForced.Layout.Column = [9 10];

            lblWeighting = uilabel(gl,'Text','Scatter points weighting method','WordWrap','on');
            lblWeighting.Layout.Row = 1; lblWeighting.Layout.Column = [11 12];

            % Dropdowns for channel selection and methods
            signal1Dropdown = uidropdown(gl,'Items',app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes));
            signal1Dropdown.Layout.Row = 2; signal1Dropdown.Layout.Column = [1 2];
            signal2Dropdown = uidropdown(gl,'Items',app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes),'Value',2);
            signal2Dropdown.Layout.Row = 2; signal2Dropdown.Layout.Column = [3 4];
            if numel(app.availableChannelsTable.Selection)>=2
                signal1Dropdown.Value=app.availableChannelsTable.Selection(1);
                signal2Dropdown.Value=app.availableChannelsTable.Selection(2);
            end

            valueMethodDD = uidropdown(gl, ...
                'Items',{'Area Means','Area Medians','Area RMS','Area Maxs','Area Mins','Single values'}, ...
                'ItemsData',{'mean','median','rms','max','min','single'}, ...
                'Value','mean');
            valueMethodDD.Layout.Row = 2; valueMethodDD.Layout.Column = [5 6];

            fitMethodDD = uidropdown(gl, ...
                'Items',{'Linear','Quadratic','Cubic','Exponential','Power','weibull','Sinusoidal','Gauss','log','log10','log2','logistic','cubic spline','smoothing spline'}, ...
                'ItemsData',{'poly1','poly2','poly3','exp1','power1','weibull','sin1','gauss1','log','log10','log2','logistic','cubicspline','smoothingspline'}, ...
                'Value','poly1');
            fitMethodDD.Layout.Row = 2; fitMethodDD.Layout.Column = [7 8];

            forcedXEdit = uieditfield(gl,'numeric','AllowEmpty','on','Value',[],'Placeholder','Forced x coordinate');
            forcedYEdit = uieditfield(gl,'numeric','AllowEmpty','on','Value',[],'Placeholder','Forced y coordinate');
            forcedXEdit.Layout.Row = 2; forcedXEdit.Layout.Column = 9;
            forcedYEdit.Layout.Row = 2; forcedYEdit.Layout.Column = 10;

            weightingMethodDropdown = uidropdown(gl, ...
                'Items',{'Equal weighting','Weight by segment length'}, ...
                'ItemsData',{'equal','duration'}, ...
                'Value','equal');
            weightingMethodDropdown.Layout.Row = 2; weightingMethodDropdown.Layout.Column = [11 12];

            % Main panel with tiled layout (now 5 tiles, no axMask)
            panel = uipanel(gl,'BorderType','none');
            panel.Layout.Row = [3 6]; panel.Layout.Column = [1 12];
            tl = tiledlayout(panel,5,1,'Padding','none','TileSpacing','compact');  % Changed to 5 rows

            % Axes: signal1, signal2, scatter, applied (skipped tile 4 for spacing)
            ax1 = nexttile(tl,1);
            ax2 = nexttile(tl,2);
            axScatter = nexttile(tl,3);
            % 4 is for the legend of the scatter/fit plot
            axApplied = nexttile(tl,5);

            applyButton=uibutton(gl,'Text','Use displayed calibrated version and close','WordWrap','on','Enable','off','BusyAction','cancel');
            applyButton.Layout.Row=7;
            applyButton.Layout.Column=[11 12];

            % Wire up callbacks for interactive updates
            signal1Dropdown.ValueChangedFcn = @(~,~) resetMaskAndRefresh();
            signal2Dropdown.ValueChangedFcn = @(~,~) resetMaskAndRefresh();
            valueMethodDD.ValueChangedFcn = @(~,~) updateScatterAndFit();
            fitMethodDD.ValueChangedFcn = @(~,~) updateScatterAndFit();
            forcedXEdit.ValueChangedFcn = @(~,~) updateScatterAndFit();
            forcedYEdit.ValueChangedFcn = @(~,~) updateScatterAndFit();
            weightingMethodDropdown.ValueChangedFcn = @(~,~) updateScatterAndFit();
            applyButton.ButtonPushedFcn= @(~,~) applyAndClose(app);

            % State storage for signals, mask, drawing
            Private_Calibr = struct();
            Private_Calibr.drawing = false;
            Private_Calibr.lastXidx = NaN;
            Private_Calibr.targetAx = [];  % New: which axis drawing started on

            % Figure mouse callbacks for mask drawing
            fig.WindowButtonDownFcn = @(~,~) onButtonDown();
            fig.WindowButtonUpFcn   = @(~,~) onButtonUp();
            fig.WindowButtonMotionFcn = @(~,~) onMouseMove();

            % Initial setup
            refreshContexts();

            % ---- Nested helper functions ----
            function applyAndClose(app)
                sourceChannelNr=signal1Dropdown.Value;

                plotline=findall(axApplied,'type','line');

                xdata=plotline.XData;
                ydata=plotline.YData;

                %lg=findall(axScatter,'type','legend');
                %fitInformationString=[axApplied.Title.String '\n' lg.String{2}];

                app.channelYValues{sourceChannelNr}=ydata;
                app.channelXValues{sourceChannelNr}=xdata;

                set(app.timePlotHandles(sourceChannelNr),'XData',xdata,'YData',ydata);
                app.addValueSetToValueHistory(ydata,xdata,sourceChannelNr);

                app.minimizeYLims(app.channelAxes(sourceChannelNr));

                close(fig);


            end

            function refreshContexts()
                % Resample and align signals to common time base
                i1 = signal1Dropdown.Value;
                i2 = signal2Dropdown.Value;
                y1 = app.channelYValues{i1}(:);
                y2 = app.channelYValues{i2}(:);
                fs1 = app.channelSampleRates(i1);
                fs2 = app.channelSampleRates(i2);
                t1_orig = app.channelXValues{i1}(:);
                t2_orig = app.channelXValues{i2}(:);

                commonFs = max(fs1, fs2);
                [y1r, ty1] = resample(y1, t1_orig, commonFs);
                [y2r, ty2] = resample(y2, t2_orig, commonFs);

                tStart = min(ty1(1), ty2(1));
                tEnd   = max(ty1(end), ty2(end));
                nCommon = floor((tEnd - tStart)*commonFs) + 1;
                tCommon = (0:nCommon-1)'/commonFs + tStart;

                y1_onCommon = interp1(ty1, y1r, tCommon, 'makima', NaN);
                y2_onCommon = interp1(ty2, y2r, tCommon, 'makima', NaN);
                y1_onCommon(isnan(y1_onCommon)) = 0;
                y2_onCommon(isnan(y2_onCommon)) = 0;

                % Store aligned data and reset mask
                Private_Calibr.t = tCommon;
                Private_Calibr.y1 = y1_onCommon(:);
                Private_Calibr.y2 = y2_onCommon(:);
                Private_Calibr.fs = commonFs;
                Private_Calibr.mask = zeros(numel(tCommon),1);

                % Plot original signals
                persistent original1Line original2Line;
                if isempty(original1Line) || ~isvalid(original1Line)
                    original1Line = plot(ax1, Private_Calibr.t, Private_Calibr.y1, 'b');
                    ylabel(ax1,'Signal 1');
                    original2Line = plot(ax2, Private_Calibr.t, Private_Calibr.y2, 'r');
                    ylabel(ax2,'Signal 2');
                    grid([ax1 ax2 axScatter axApplied],'on');  % Updated link without axMask
                    linkaxes([ax1 ax2 axApplied],'x');  % Link X axes
                else
                    set(original1Line,'XData',Private_Calibr.t,'YData',Private_Calibr.y1);
                    set(original2Line,'XData',Private_Calibr.t,'YData',Private_Calibr.y2);
                end

                ylim(ax1,[min(Private_Calibr.y1) max(Private_Calibr.y1)]+[-1 1]*0.1*range(Private_Calibr.y1));
                ylim(ax2,[min(Private_Calibr.y2) max(Private_Calibr.y2)]+[-1 1]*0.1*range(Private_Calibr.y2));

                % Setup applied and scatter axes
                xlim(axApplied,'manual');
                delete(axApplied.Children);
                xlabel(axApplied,'time (s)');
                title(axApplied,'Signal 1 calibrated');
                grid(axApplied,'on');

                cla(axScatter);
                xlabel(axScatter,'Signal 1');
                ylabel(axScatter,'Signal 2');
                grid(axScatter,'on');

                % Clear mask overlays and preview
                clearMaskOverlays();

                % Initial updates
                updateMaskPlot();
                updateScatterAndFit();

                % Hide toolbars
                %arrayfun(@(in) axtoolbar(in,{'datacursor','pan','zoomin','zoomout','restoreview'},'Visible','on'),[ax1 ax2 axScatter axApplied]);
                axtoolbar(tl,{'datacursor','pan','zoomin','zoomout','restoreview'},'Visible','on')
            end

            function resetMaskAndRefresh()
                % Reset mask and refresh all views
                if isfield(Private_Calibr,'mask')
                    Private_Calibr.mask(:) = 0;
                end
                clearMaskOverlays();
                refreshContexts();
            end

            function clearMaskOverlays()
                % Delete persistent mask overlay handles
                delete(findall([ax1 ax2],'type','area'));
            end

            function updateMaskPlot()
                % Plot committed mask as semi-transparent overlay on ax1 and ax2
                if ~isfield(Private_Calibr,'mask'), return; end
                t = Private_Calibr.t;
                m = Private_Calibr.mask;

                clearMaskOverlays();  % Clear previous

                if any(m==1)
                    ylims1 = ylim(ax1);
                    ylims2 = ylim(ax2);

                    hold([ax1 ax2],'on');
                    maskInSignal1 = area(ax1, t, m*range(ylims1)+ylims1(1), ylims1(1), ...
                        'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off','FaceAlpha',0.5);
                    uistack(maskInSignal1,'bottom');

                    maskInSignal2 = area(ax2, t, m*range(ylims2)+ylims2(1), ylims2(1), ...
                        'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off','FaceAlpha',0.5);
                    uistack(maskInSignal2,'bottom');
                    hold([ax1 ax2],'off');
                end
            end

            function updateScatterAndFit()
                % Compute scatter points from masked regions and fit curve
                if ~isfield(Private_Calibr,'y1'), return; end
                y1 = Private_Calibr.y1;
                y2 = Private_Calibr.y2;
                m  = Private_Calibr.mask;

                xlabel(axScatter,'Signal 1'); ylabel(axScatter,'Signal 2'); grid(axScatter,'on');
                if all(m==0)
                    title(axScatter,'No mask regions selected');
                    cla(axScatter);
                    return;
                end

                idx = find(m==1);
                if isempty(idx)
                    title(axScatter,'No mask regions selected');
                    cla(axScatter);
                    return;
                end

                % Group into contiguous segments
                segs = {};
                startPos = 1;
                for k = 2:numel(idx)
                    if idx(k) ~= idx(k-1)+1
                        segs{end+1} = idx(startPos:k-1);
                        startPos = k;
                    end
                end
                segs{end+1} = idx(startPos:end);

                % Extract values per segment based on method
                methodVal = valueMethodDD.Value;
                Xvals = [];
                Yvals = [];
                for s = 1:numel(segs)
                    idcs = segs{s};
                    v1 = y1(idcs);
                    v2 = y2(idcs);
                    switch lower(methodVal)
                        case 'mean',    Xvals(end+1,1) = mean(v1); Yvals(end+1,1) = mean(v2);
                        case 'median',  Xvals(end+1,1) = median(v1); Yvals(end+1,1) = median(v2);
                        case 'rms',     Xvals(end+1,1) = sqrt(mean(v1.^2)); Yvals(end+1,1) = sqrt(mean(v2.^2));
                        case 'max',     Xvals(end+1,1) = max(v1); Yvals(end+1,1) = max(v2);
                        case 'min',     Xvals(end+1,1) = min(v1); Yvals(end+1,1) = min(v2);
                        case 'single',  Xvals = [Xvals; v1(:)]; Yvals = [Yvals; v2(:)];
                    end
                end

                if strcmpi(methodVal,'single') || strcmpi(weightingMethodDropdown.Value,'equal')
                    weights=ones(size(Xvals));
                else
                    weights=cellfun(@numel,segs);
                end

                % Update scatter plot
                persistent scatterHandle fitLineHandle contraintPointHandle appliedToDataHandle;
                delete(contraintPointHandle);

                if isempty(scatterHandle) || ~isvalid(scatterHandle)
                    scatterHandle = scatter(axScatter, Xvals, Yvals, 36, 'filled','DisplayName','area value(s)');
                else
                    set(scatterHandle,'XData',Xvals,'YData',Yvals);
                end

                grid(axScatter,'on');

                hold(axScatter,'on');
                if numel(Xvals) >= 2
                    fitType = fitMethodDD.Value;
                    xi = linspace(min(Xvals), max(Xvals), 200).';
                    constraintPoint = [];
                    if ~isempty(forcedXEdit.Value) && ~isempty(forcedYEdit.Value) && ~isnan(forcedXEdit.Value) && ~isnan(forcedYEdit.Value)
                        constraintPoint = [forcedXEdit.Value forcedYEdit.Value];
                    end

                    progDiag = uiprogressdlg(fig,"Cancelable","off","Indeterminate","on","Title",'Wait...','Message','fitting...','Icon','none');
                    try
                        robust = 'LAR';
                        if ismember(fitType,{'cubicspline','smoothingspline'})
                            [fobj, gof] = fit(Xvals(:), Yvals(:), fitType,'ConstraintPoints',constraintPoint,'Weights',weights);
                        else
                            [fobj, gof] = fit(Xvals(:), Yvals(:), fitType,'Robust',robust,'ConstraintPoints',constraintPoint,'Weights',weights);
                        end
                    catch ME
                        disp('Error while calculating fit:');
                        disp(ME.getReport);
                        disp('Falling back to linear');
                        fitType = 'poly1';
                        [fobj, gof] = fit(Xvals(:), Yvals(:), 'poly1','Robust','LAR','ConstraintPoints',constraintPoint,'Weights',weights);
                    end
                    delete(progDiag);

                    rsq = gof.rsquare;
                    rmse = gof.rmse;
                    sse = gof.sse;
                    yi = feval(fobj, xi);

                    eqnStr = formula(fobj);
                    if ~ismember(fitType,{'cubicspline','smoothingspline'})
                        eqnStr = ['y = ' replace(eqnStr,coeffnames(fobj),cellfun(@num2str,num2cell(coeffvalues(fobj)),'UniformOutput',false)')];
                        eqnStr = replace(eqnStr,{'+ -','-'},{'– ','–'});
                    end

                    if ~all(isnan(yi))
                        if isempty(fitLineHandle) || ~isvalid(fitLineHandle)
                            fitLineHandle = plot(axScatter, xi, yi, '-', 'LineWidth', 1.5, 'Color', [0 0.6 0]);
                        else
                            set(fitLineHandle,'XData',xi,'YData',yi);
                        end
                    end

                    if ~isempty(constraintPoint)
                        contraintPointHandle = line(axScatter,constraintPoint(1),constraintPoint(2),'Marker','x','Color','red','LineWidth',1.5,'DisplayName','Constraint point');
                    end

                    annotationStr = sprintf('%s\nR^2 = %.4g\nRMSE = %.4g\nSSE = %.4g', eqnStr, rsq,rmse,sse);

                    if strcmp(methodVal,'single')
                        valueDesc='area single value(s)';
                    else
                        valueDesc='area value(s)';
                    end

                    lg = legend(axScatter,valueDesc,annotationStr,'Orientation','horizontal');
                    lg.Layout.Tile=4;
                    title(axScatter,sprintf('Fit method %s',fitType));

                    % Apply fit to full signal 1
                    index1 = signal1Dropdown.Value;
                    yvaluesOfFirstSignal = app.channelYValues{index1}(:);
                    xvaluesOfFirstSignal = app.channelXValues{index1}(:);

                    if isempty(appliedToDataHandle) || ~isvalid(appliedToDataHandle)
                        appliedToDataHandle = plot(axApplied,xvaluesOfFirstSignal,feval(fobj, yvaluesOfFirstSignal));
                    else
                        set(appliedToDataHandle,'XData',xvaluesOfFirstSignal,'YData',feval(fobj, yvaluesOfFirstSignal));
                    end

                    applyButton.Enable='on';

                else
                    if ~isempty(fitLineHandle) && isvalid(fitLineHandle), delete(fitLineHandle); end

                    xlim(axApplied,'manual');
                    delete(appliedToDataHandle);

                    applyButton.Enable='off';
                end
                hold(axScatter,'off');
                %arrayfun(@(in) set(in.Toolbar,'Visible','off'), [ax1 ax2 axScatter axApplied]);

                
            end

            % ---- Mouse interaction for drawing mask ----
            function onButtonDown()
                axClicked = ancestor(fig.CurrentObject,'axes');

                if isempty(axClicked) || ~ismember(axClicked, [ax1 ax2])
                    return;
                end  % Only on signal axes

                cp = axClicked.CurrentPoint;
                tx = cp(1,1);
                ty = cp(1,2);
                t = Private_Calibr.t;

                if tx < t(1) || tx > t(end), return; end
                [~, startIdx] = min(abs(t - tx));

                % EXACT original logic: single check at button down!
                ylims = ylim(axClicked);
                startVal = double(ty > mean(ylims));  % 1 if above midline, 0 if below

                Private_Calibr.drawing = true;
                Private_Calibr.drawStartIdx = startIdx;
                Private_Calibr.drawStartVal = startVal;  % FIXED: This controls everything!
                Private_Calibr.drawCurrentIdx = startIdx;

                previewMaskAndPlot();  % Original name for consistency
            end



            function onMouseMove()
                if ~Private_Calibr.drawing, return; end

                try
                    axCurr = ancestor(fig.CurrentObject,'axes');
                    if ~ismember(axCurr, [ax1 ax2]), return; end
                    cp = axCurr.CurrentPoint;
                    tx = cp(1,1);
                catch
                    return;
                end

                t = Private_Calibr.t;
                tx = max(min(tx, t(end)), t(1));
                [~, currIdx] = min(abs(t - tx));
                Private_Calibr.drawCurrentIdx = currIdx;

                previewMaskAndPlot();
            end


            function onButtonUp()
                if ~Private_Calibr.drawing, return; end

                Private_Calibr.drawing = false;
                s = Private_Calibr.drawStartIdx;
                e = Private_Calibr.drawCurrentIdx;
                if s>e, [s,e]=deal(e,s); end

                % Commit with the SAME startVal from button down!
                Private_Calibr.mask(s:e) = Private_Calibr.drawStartVal;

                clearMaskOverlays();
                updateMaskPlot();
                updateScatterAndFit();

                % Clear state
                rmfields = {'drawStartIdx','drawCurrentIdx','drawStartVal','targetAx'};
                for k = 1:numel(rmfields)
                    if isfield(Private_Calibr, rmfields{k}), Private_Calibr = rmfield(Private_Calibr, rmfields{k}); end
                end
            end


            function previewMaskAndPlot()
                t = Private_Calibr.t;
                mask = Private_Calibr.mask;
                s = Private_Calibr.drawStartIdx;
                e = Private_Calibr.drawCurrentIdx;
                if s>e, [s,e]=deal(e,s); end

                tempMask = mask;
                tempMask(s:e) = Private_Calibr.drawStartVal;  % USE FIXED startVal!


                previewMask1 = findall(ax1,'type','area');
                previewMask2 = findall(ax2,'type','area');

                % Update/create preview overlays (3-element color: [0.5 0.5 0.5])
                ylims1 = ylim(ax1);
                ylims2 = ylim(ax2);

                hold([ax1 ax2],'on');
                if isempty(previewMask1) || ~isvalid(previewMask1)
                    previewMask1 = area(ax1,t,tempMask*range(ylims1)+ylims1(1), ylims1(1), ...
                        'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off','FaceAlpha',0.5);  % 3 elements!
                    uistack(previewMask1,'bottom');
                else
                    set(previewMask1,'YData',tempMask*range(ylims1)+ylims1(1));
                end

                if isempty(previewMask2) || ~isvalid(previewMask2)
                    previewMask2 = area(ax2,t,tempMask*range(ylims2)+ylims2(1), ylims2(1), ...
                        'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off','FaceAlpha',0.5);
                    uistack(previewMask2,'bottom');
                else
                    set(previewMask2,'YData',tempMask*range(ylims2)+ylims2(1));
                end
                hold([ax1 ax2],'off');

                drawnow limitrate;
            end





        end


        % function calibrationByTwoChannels(app)
        %     if numel(app.channelAxes) < 2
        %         return;
        %     end
        %
        %     fig = uifigure('Name','Calibration by channel comparison','Position',[100 100 1000 700],'Toolbar', 'none');
        %
        %     gl = uigridlayout(fig,[6 10],'Padding',[5 5 5 5],'RowSpacing',5,'ColumnSpacing',5,'RowHeight',{'fit' 'fit'});
        %
        %     lbl1 = uilabel(gl,'Text',{'1. signal','(values to be mapped according signal 2)'},'WordWrap','on');
        %     lbl1.Layout.Row = 1; lbl1.Layout.Column = [1 2];
        %     lbl2 = uilabel(gl,'Text',{'2. signal' '(value region to which the signal 1 is mapped)'},'WordWrap','on');
        %     lbl2.Layout.Row = 1; lbl2.Layout.Column = [3 4];
        %     lbl3 = uilabel(gl,'Text','Value method');
        %     lbl3.Layout.Row = 1; lbl3.Layout.Column = [5 6];
        %     lbl4 = uilabel(gl,'Text','Fit method');
        %     lbl4.Layout.Row = 1; lbl4.Layout.Column = [7 8];
        %     lbl4 = uilabel(gl,'Text','Forced Point');
        %     lbl4.Layout.Row = 1; lbl4.Layout.Column = [9 10];
        %
        %     signal1DD = uidropdown(gl,'Items',app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes));
        %     signal1DD.Layout.Row = 2; signal1DD.Layout.Column = [1 2];
        %     signal2DD = uidropdown(gl,'Items',app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes),'Value',2);
        %     signal2DD.Layout.Row = 2; signal2DD.Layout.Column = [3 4];
        %
        %     if numel(app.availableChannelsTable.Selection)>=2
        %         signal1DD.Value=app.availableChannelsTable.Selection(1);
        %         signal2DD.Value=app.availableChannelsTable.Selection(2);
        %     end
        %
        %     valueMethodDD = uidropdown(gl, ...
        %         'Items',{'Area Means','Area Medians','Area RMS','Area Maxs','Area Mins','Single values'}, ...
        %         'ItemsData',{'mean','median','rms','max','min','single'}, ...
        %         'Value','mean');
        %     valueMethodDD.Layout.Row = 2; valueMethodDD.Layout.Column = [5 6];
        %
        %     % fitMethodDD = uidropdown(gl, ...
        %     %     'Items',{'Linear (poly1)','Quadratic (poly2)','Cubic (poly3)', ...
        %     %     'Exponential (exp1)','Power (power1)','Robust Linear (poly1, robust)'}, ...
        %     %     'ItemsData',{'poly1','poly2','poly3','exp1','power1','poly1_robust'}, ...
        %     %     'Value','poly1');
        %     fitMethodDD = uidropdown(gl, ...
        %         'Items',{'Linear','Quadratic','Cubic','Exponential','Power','weibull','Sinusoidal','Gauss','log','log10','log2','logistic','cubic spline','smoothing spline'}, ...
        %         'ItemsData',{'poly1','poly2','poly3','exp1','power1','weibull','sin1','gauss1','log','log10','log2','logistic','cubicspline','smoothingspline'}, ...
        %         'Value','poly1');
        %
        %     fitMethodDD.Layout.Row = 2; fitMethodDD.Layout.Column = [7 8];
        %
        %     forcedXEdit = uieditfield(gl,'numeric','AllowEmpty','on','Value',[],'Placeholder','Forced x coordinate');
        %     forcedYEdit = uieditfield(gl,'numeric','AllowEmpty','on','Value',[],'Placeholder','Forced y coordinate');
        %
        %     forcedXEdit.Layout.Row = 2; forcedXEdit.Layout.Column = 9;
        %     forcedYEdit.Layout.Row = 2; forcedYEdit.Layout.Column = 10;
        %
        %     % Panel and axes
        %     panel = uipanel(gl,'BorderType','none');
        %     panel.Layout.Row = [3 6]; panel.Layout.Column = [1 10];
        %
        %     tl = tiledlayout(panel,6,1,'Padding','none','TileSpacing','compact');
        %     ax1 = nexttile(tl,1);
        %     ax2 = nexttile(tl,2);
        %     axMask = nexttile(tl,3);
        %     axScatter = nexttile(tl,4);
        %     axApplied = nexttile(tl,6);
        %
        %
        %
        %
        %
        %     % Wire up callbacks
        %     signal1DD.ValueChangedFcn = @(~,~) resetMaskAndRefresh();
        %     signal2DD.ValueChangedFcn = @(~,~) resetMaskAndRefresh();
        %     valueMethodDD.ValueChangedFcn = @(~,~) updateScatterAndFit();
        %     fitMethodDD.ValueChangedFcn = @(~,~) updateScatterAndFit();
        %     forcedXEdit.ValueChangedFcn = @(~,~) updateScatterAndFit();
        %     forcedYEdit.ValueChangedFcn = @(~,~) updateScatterAndFit();
        %
        %     % state storage
        %     Private_Calibr = struct();
        %
        %
        %     % drawing state
        %     Private_Calibr.drawing = false;
        %     Private_Calibr.lastXidx = NaN;
        %
        %     % window callbacks
        %     fig.WindowButtonDownFcn = @(~,~) onButtonDown();
        %     fig.WindowButtonUpFcn   = @(~,~) onButtonUp();
        %     fig.WindowButtonMotionFcn = @(~,~) onMouseMove();
        %
        %     % initial population
        %     refreshContexts();
        %
        %     % ---- nested helpers ----
        %
        %     function refreshContexts()
        %         i1 = signal1DD.Value;
        %         i2 = signal2DD.Value;
        %         y1 = app.channelYValues{i1}(:);
        %         y2 = app.channelYValues{i2}(:);
        %         fs1 = app.channelSampleRates(i1);
        %         fs2 = app.channelSampleRates(i2);
        %
        %         % time vectors come from app.channelXValues per user
        %         t1_orig = app.channelXValues{i1}(:);
        %         t2_orig = app.channelXValues{i2}(:);
        %
        %         % desired common sample rate: use max of both sample rates
        %         commonFs = max(fs1, fs2);
        %
        %         % resample using time-vector syntax to preserve absolute times after resampling
        %         [y1r, ty1] = resample(y1, t1_orig, commonFs);
        %         [y2r, ty2] = resample(y2, t2_orig, commonFs);
        %
        %         % build common absolute time axis that covers union of both resampled ranges
        %         tStart = min(ty1(1), ty2(1));
        %         tEnd   = max(ty1(end), ty2(end));
        %         nCommon = floor((tEnd - tStart)*commonFs) + 1;
        %         tCommon = (0:nCommon-1)'/commonFs + tStart;
        %
        %         % interpolate resampled signals onto common grid (makima used here)
        %         y1_onCommon = interp1(ty1, y1r, tCommon, 'makima', NaN);
        %         y2_onCommon = interp1(ty2, y2r, tCommon, 'makima', NaN);
        %         y1_onCommon(isnan(y1_onCommon)) = 0;
        %         y2_onCommon(isnan(y2_onCommon)) = 0;
        %
        %         Private_Calibr.t = tCommon;
        %         Private_Calibr.y1 = y1_onCommon(:);
        %         Private_Calibr.y2 = y2_onCommon(:);
        %         Private_Calibr.fs = commonFs;
        %
        %         % initialize/reset mask
        %         Private_Calibr.mask = zeros(numel(tCommon),1);
        %
        %         % plot signals using absolute times
        %
        %         persistent original1Line original2Line
        %
        %         if isempty(original1Line) || ~isvalid(original1Line)
        %              original1Line=plot(ax1, Private_Calibr.t, Private_Calibr.y1, 'b'); ylabel(ax1,'Signal 1');
        %              original2Line=plot(ax2, Private_Calibr.t, Private_Calibr.y2, 'r'); ylabel(ax2,'Signal 2');
        %              grid([ax1 ax2 axScatter],'on');
        %              linkaxes([ax1 ax2 axMask axApplied],'x');
        %         else
        %             set(original1Line,'XData',Private_Calibr.t,'YData',Private_Calibr.y1);
        %             set(original2Line,'XData',Private_Calibr.t,'YData',Private_Calibr.y2);
        %
        %         end
        %
        %
        %         % set up newly calibrated signal
        %         cla(axApplied);
        %         xlabel(axApplied,'time (s)');
        %         title(axApplied,'Signal 1 calibrated');
        %         grid(axApplied,'on');
        %
        %
        %         % mask axis setup
        %         cla(axMask);
        %         axMask.YLim = [0 1];
        %
        %
        %         xlabel(axMask,'time (s)');
        %         ylabel(axMask,'mask');
        %         title(axMask,'point and draw above .5 to set to 1, below .5 to set to 0');
        %         updateMaskPlot();
        %
        %         grid(axMask,'on');
        %
        %         % scatter axis
        %         cla(axScatter); xlabel(axScatter,'Signal 1'); ylabel(axScatter,'Signal 2'); grid(axScatter,'on');
        %
        %         updateScatterAndFit();
        %
        %         arrayfun(@(in) set(in.Toolbar,'Visible','off'),[ax1 ax2 axMask axScatter]);
        %
        %     end
        %
        %     function resetMaskAndRefresh()
        %         if isfield(Private_Calibr,'mask')
        %             Private_Calibr.mask(:) = 0;
        %         end
        %         refreshContexts();
        %     end
        %
        %     function updateMaskPlot()
        %         if ~isfield(Private_Calibr,'mask'), return; end
        %         t = Private_Calibr.t;
        %         m = Private_Calibr.mask;
        %         cla(axMask);
        %         hold(axMask,'on');
        %         area(axMask,t,m,'FaceColor',[0.3 0.3 0.8],'EdgeColor','none','ShowBaseline','off');
        %         hold(axMask,'off');
        %         ylim(axMask,[0 1]);
        %         xlabel([ax1 ax2 axMask],'time (s)');
        %
        %         arrayfun(@(in) set(in.Toolbar,'Visible','off'),[ax1 ax2 axMask axScatter]);
        %
        %         persistent maskInSignal1 maskInSignal2;
        %
        %         delete(maskInSignal1);
        %         delete(maskInSignal2);
        %
        %         if any(axMask.Children(1).YData==1)
        %
        %             drawnow;
        %             ylims1=ylim(ax1);
        %             ylims2=ylim(ax2);
        %
        %             hold([ax1 ax2],'on');
        %             maskInSignal1=area(ax1,t,m*range(ylims1)+ylims1(1),ylims1(1),'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off');
        %             uistack(maskInSignal1,'bottom');
        %             maskInSignal2=area(ax2,t,m*range(ylims2)+ylims2(1),ylims2(1),'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','ShowBaseline','off');
        %             uistack(maskInSignal2,'bottom');
        %             hold([ax1 ax2],'off');
        %         end
        %
        %     end
        %
        %
        %     function updateScatterAndFit()
        %         if ~isfield(Private_Calibr,'y1'), return; end
        %
        %         y1 = Private_Calibr.y1;
        %         y2 = Private_Calibr.y2;
        %         m  = Private_Calibr.mask;
        %
        %         %cla(axScatter);
        %         xlabel(axScatter,'Signal 1'); ylabel(axScatter,'Signal 2'); grid(axScatter,'on');
        %
        %         if all(m==0)
        %             title(axScatter,'No mask regions selected');
        %             cla(axScatter);
        %             return;
        %         end
        %
        %         idx = find(m==1);
        %         if isempty(idx)
        %             title(axScatter,'No mask regions selected');
        %             cla(axScatter);
        %             return;
        %         end
        %
        %         % contiguous segments
        %         segs = {};
        %         startPos = 1;
        %         for k = 2:numel(idx)
        %             if idx(k) ~= idx(k-1)+1
        %                 segs{end+1} = idx(startPos:k-1); %#ok<AGROW>
        %                 startPos = k;
        %             end
        %         end
        %         segs{end+1} = idx(startPos:end);
        %
        %         % obtain values per segment according to method
        %         methodVal = valueMethodDD.Value; % ItemsData element
        %         Xvals = [];
        %         Yvals = [];
        %         for s = 1:numel(segs)
        %             idcs = segs{s};
        %             v1 = y1(idcs);
        %             v2 = y2(idcs);
        %
        %             switch lower(methodVal)
        %                 case 'mean'
        %                     Xvals(end+1,1) = mean(v1); %#ok<AGROW>
        %                     Yvals(end+1,1) = mean(v2); %#ok<AGROW>
        %                 case 'median'
        %                     Xvals(end+1,1) = median(v1); %#ok<AGROW>
        %                     Yvals(end+1,1) = median(v2); %#ok<AGROW>
        %                 case 'rms'
        %                     Xvals(end+1,1) = sqrt(mean(v1.^2)); %#ok<AGROW>
        %                     Yvals(end+1,1) = sqrt(mean(v2.^2)); %#ok<AGROW>
        %                 case 'max'
        %                     Xvals(end+1,1) = max(v1); %#ok<AGROW>
        %                     Yvals(end+1,1) = max(v2); %#ok<AGROW>
        %                 case 'min'
        %                     Xvals(end+1,1) = min(v1); %#ok<AGROW>
        %                     Yvals(end+1,1) = min(v2); %#ok<AGROW>
        %                 case 'single'
        %                     Xvals = [Xvals; v1(:)]; %#ok<AGROW>
        %                     Yvals = [Yvals; v2(:)]; %#ok<AGROW>
        %             end
        %         end
        %
        %         persistent scatterHandle;
        %         persistent fitLineHandle;
        %         persistent contraintPointHandle;
        %         persistent appliedToDataHandle;
        %
        %         delete(contraintPointHandle);
        %         delete(appliedToDataHandle);
        %
        %
        %         if isempty(scatterHandle) || ~isvalid(scatterHandle)
        %             scatterHandle=scatter(axScatter, Xvals, Yvals, 36, 'filled','DisplayName','area value(s)');
        %         else
        %             set(scatterHandle,'XData',Xvals,'YData',Yvals);
        %         end
        %         hold(axScatter,'on');
        %
        %         if numel(Xvals) >= 2
        %             fitType = fitMethodDD.Value;
        %             xi = linspace(min(Xvals), max(Xvals), 200).';
        %
        %             if ~isempty(forcedXEdit.Value) && ~isempty(forcedYEdit.Value) && ~isnan(forcedXEdit.Value) && ~isnan(forcedYEdit.Value)
        %                 constraintPoint=[forcedXEdit.Value forcedYEdit.Value];
        %             else
        %                 constraintPoint=[];
        %             end
        %
        %             progDiag=uiprogressdlg(fig,"Cancelable","off","Indeterminate","on","Title",'Wait...','Message','fitting...','Icon','none');
        %
        %             % Fit with Curve Fitting Toolbox; request gof output (incl. rsquare) [web:1]
        %             try
        %                 robust='LAR';
        %                 if ismember(fitType,{'cubicspline','smoothingspline'})
        %                     [fobj, gof] = fit(Xvals(:), Yvals(:), fitType,'ConstraintPoints',constraintPoint);
        %                 else
        %                     [fobj, gof] = fit(Xvals(:), Yvals(:), fitType,'Robust',robust,'ConstraintPoints',constraintPoint);  % fitType: 'poly1','poly2','poly3','exp1','power1',...
        %                 end
        %             catch ME
        %                 disp('Error while calculating fit:')
        %                 disp(ME.getReport);
        %                 disp('Falling back to linear')
        %                 fitType='poly1';
        %                 [fobj, gof] = fit(Xvals(:), Yvals(:), fitType,'Robust','LAR','ConstraintPoints',constraintPoint);  % fitType: 'poly1','poly2','poly3','exp1','power1',...
        %             end
        %
        %             delete(progDiag);
        %
        %             rsq = gof.rsquare;                                % goodness-of-fit R^2 [web:1]
        %             sse= gof.sse;
        %             rmse = gof.rmse;
        %
        %             yi = feval(fobj, xi);
        %
        %             % equation string
        %             eqnStr = formula(fobj);                    % model formula text
        %             if ~ismember(fitType,{'cubicspline','smoothingspline'})
        %                 eqnStr = ['y = ' replace(eqnStr,coeffnames(fobj),cellfun(@num2str,num2cell(coeffvalues(fobj)),'UniformOutput',false)')];
        %                 eqnStr = replace(eqnStr,{'+ -','-'},{'– ','–'});
        %             end
        %
        %
        %             if ~all(isnan(yi))
        %                 if isempty(fitLineHandle) || ~isvalid(fitLineHandle)
        %                     fitLineHandle=plot(axScatter, xi, yi, '-', 'LineWidth', 1.5, 'Color', [0 0.6 0]);
        %                 else
        %                     set(fitLineHandle,'XData',xi,'YData',yi);
        %                 end
        %             end
        %
        %             % display equation and R^2
        %             annotationStr = sprintf('%s\nR^2 = %.4g\nRMSE = %.4g\nSSE = %.4g', eqnStr, rsq,rmse,sse);
        %
        %
        %             if ~isempty(constraintPoint)
        %                 contraintPointHandle=line(axScatter,constraintPoint(1),constraintPoint(2),'Marker','x','Color','red','LineWidth',1.5,'DisplayName','Constraint point');
        %             end
        %
        %             lg=legend(axScatter,'area value(s)',annotationStr,'Location','southoutside','Orientation','horizontal');
        %             lg.Layout.Tile=5;
        %
        %             xlabel(axScatter,'Signal 1'); ylabel(axScatter,'Signal 2'); grid(axScatter,'on');
        %             title(axScatter,sprintf('Fit method %s',fitType));
        %
        %
        %             % get true data and plot mapped version
        %             index1 = signal1DD.Value;
        %
        %             yvaluesOfFirstSignal = app.channelYValues{index1}(:);
        %             xvaluesOfFirstSignal = app.channelXValues{index1}(:);
        %
        %             appliedToDataHandle=plot(axApplied,xvaluesOfFirstSignal,feval(fobj, yvaluesOfFirstSignal));
        %
        %
        %         else
        %             delete(fitLineHandle);
        %         end
        %
        %         hold(axScatter,'off');
        %         arrayfun(@(in) set(in.Toolbar,'Visible','off'), [ax1 ax2 axMask axScatter]);
        %     end
        %
        %
        %     % ---- Mouse interaction ----
        %     function onButtonDown()
        %         axClicked = ancestor(fig.CurrentObject,'axes');
        %         if isempty(axClicked), return; end
        %         if 1%axClicked == axMask
        %             cp = axClicked.CurrentPoint; tx = cp(1,1); ty = cp(1,2);
        %             t = Private_Calibr.t;
        %             if tx < t(1) || tx > t(end), return; end
        %             [~, startIdx] = min(abs(t - tx));
        %             startVal = double(ty > mean(ylim(axClicked)));            % initial click value to apply
        %             Private_Calibr.drawing = true;
        %             Private_Calibr.drawStartIdx = startIdx;
        %             Private_Calibr.drawStartVal = startVal;
        %             Private_Calibr.drawCurrentIdx = startIdx;
        %             previewMaskAndPlot();
        %         end
        %     end
        %
        %     function onMouseMove()
        %         % mouse moved: update preview while drawing
        %         if ~isfield(Private_Calibr,'drawing') || ~Private_Calibr.drawing
        %             return;
        %         end
        %         % ensure we still have axes and t
        %         if ~isfield(Private_Calibr,'t'), return; end
        %         % get current point in mask axis
        %         try
        %             cp = axMask.CurrentPoint; tx = cp(1,1); ty = cp(1,2);
        %         catch
        %             return;
        %         end
        %         t = Private_Calibr.t;
        %         % clip tx to time range
        %         tx = max(min(tx, t(end)), t(1));
        %         [~, currIdx] = min(abs(t - tx));
        %         Private_Calibr.drawCurrentIdx = currIdx;
        %         previewMaskAndPlot();
        %     end
        %
        %     function onButtonUp()
        %         % finish drawing and commit mask changes
        %         if ~isfield(Private_Calibr,'drawing') || ~Private_Calibr.drawing
        %             return;
        %         end
        %         Private_Calibr.drawing = false;
        %         % commit range
        %         if isfield(Private_Calibr,'drawStartIdx') && isfield(Private_Calibr,'drawCurrentIdx')
        %             s = Private_Calibr.drawStartIdx;
        %             e = Private_Calibr.drawCurrentIdx;
        %             if s>e, tmp=s; s=e; e=tmp; end
        %             val = Private_Calibr.drawStartVal;
        %             if val
        %                 Private_Calibr.mask(s:e) = 1;
        %             else
        %                 Private_Calibr.mask(s:e) = 0;
        %             end
        %         end
        %         % clear draw state
        %         rmfields = {'drawStartIdx','drawCurrentIdx','drawStartVal'};
        %         for k = 1:numel(rmfields)
        %             if isfield(Private_Calibr, rmfields{k}), Private_Calibr = rmfield(Private_Calibr, rmfields{k}); end
        %         end
        %         updateMaskPlot();
        %         updateScatterAndFit();
        %     end
        %
        %     function previewMaskAndPlot()
        %         % Show temporary mask preview while dragging
        %         if ~isfield(Private_Calibr,'t'), return; end
        %         t = Private_Calibr.t;
        %         mask = Private_Calibr.mask;
        %         s = Private_Calibr.drawStartIdx;
        %         e = Private_Calibr.drawCurrentIdx;
        %         if isempty(s) || isempty(e), return; end
        %         if s>e, tmp=s; s=e; e=tmp; end
        %         tempMask = mask;
        %         if Private_Calibr.drawStartVal
        %             tempMask(s:e) = 1;
        %         else
        %             tempMask(s:e) = 0;
        %         end
        %         axMask.XLimMode = 'manual';
        %
        %
        %
        %         if isempty(axMask.Children) || ~isvalid(axMask.Children)
        %             %delete(axMask.Children);
        %             hold(axMask,'on');
        %             area(axMask, t, tempMask, 'FaceColor',[0.3 0.3 0.8], 'EdgeColor','none','ShowBaseline','off');
        %             hold(axMask,'off');
        %         else
        %             set(axMask.Children(1),'XData',t,'YData',tempMask);
        %         end
        %
        %
        %         ylim(axMask,[0 1]);
        %         xlabel(axMask,'time (s)');
        %         drawnow limitrate;
        %     end
        %
        %
        %
        % end



        function copyCompleteRowToClipboard(app,copyHeader)



            completeRow=num2str(cell2mat(app.parameterResultsUITable.Data(app.parameterResultsUITable.Selection(1),4:end-1)),'%12e\t');
            completeRow=[strjoin(app.parameterResultsUITable.Data(app.parameterResultsUITable.Selection(1),1:3),'\t') sprintf('\t') completeRow];

            if ~copyHeader
                clipboard("copy",completeRow);
            else
                clipboard("copy",[strjoin(app.parameterResultsUITable.ColumnName(1:end-1)','\t') newline completeRow]);
            end


            h=msgbox('Copied successfully...','Success','help');
            pause(1);
            if isvalid(h)
                close(h);
            end
        end

        function tmpFcn(app,~,~, channelNr, newYLimits)
            ylim(app.channelAxes(channelNr), newYLimits);
        end

        function [channelTypeStrings,abortValue] = createChooseWAVchannelTypesFigure(app,filepath,numOfChannels)
            chooseChannelFig=uifigure('Name','choose channels'' source type','Units','normalized','Position',[0.25 0.05 0.5 0.9],'CloseRequestFcn','','WindowStyle','modal','Theme','light');

            thegrid=uigridlayout(chooseChannelFig,[numOfChannels+3,2]);
            lbl=uilabel(thegrid,'Text',filepath,'WordWrap','on');
            lbl.Layout.Column=[1 2]; lbl.Layout.Row=1;

            lbl=uilabel(thegrid,'Text','set all channels'' type','WordWrap','on','HorizontalAlignment','right','FontWeight','bold');
            lbl.Layout.Column=1; lbl.Layout.Row=2;



            allDropdowns=gobjects(numOfChannels,1);
            for channelNr=1:numOfChannels
                allDropdowns(channelNr)=uidropdown(thegrid,"Items",app.channelSourcePossibilities,'Value','Raw','ValueChangedFcn',@setsetAllDropdown);
                allDropdowns(channelNr).Layout.Column=2;
                allDropdowns(channelNr).Layout.Row=2+channelNr;

                lbl=uilabel(thegrid,'Text',['channel ' num2str(channelNr,'%i')],'WordWrap','on','HorizontalAlignment','right');
                lbl.Layout.Column=1; lbl.Layout.Row=2+channelNr;
            end

            setAllDropdown=uidropdown(thegrid,"Items",[app.channelSourcePossibilities {'mixed'}],'Value','Raw',"ValueChangedFcn",@setAllChannelTypes);
            setAllDropdown.Layout.Column=2; setAllDropdown.Layout.Row=2;

            loadConfigButton=uibutton(thegrid,'Text','load channel configuration from file','WordWrap','on','ButtonPushedFcn',@loadWavConfig);
            loadConfigButton.Layout.Column=1; loadConfigButton.Layout.Row=numOfChannels+3;

            saveConfigButton=uibutton(thegrid,'Text','save channel configuration to file','WordWrap','on','ButtonPushedFcn',@saveWavConfig);
            saveConfigButton.Layout.Column=2; saveConfigButton.Layout.Row=numOfChannels+3;


            abortValue=0;

            cancelButton=uibutton(thegrid,'Text','cancel import','FontWeight','bold','ButtonPushedFcn',@(~,~) closeThatFig(1));
            cancelButton.Layout.Column=1; cancelButton.Layout.Row=numOfChannels+4;

            applyButton=uibutton(thegrid,'Text','apply channel types','FontWeight','bold','ButtonPushedFcn',@(~,~) closeThatFig(0));
            applyButton.Layout.Column=2; cancelButton.Layout.Row=numOfChannels+4;

            uiwait(chooseChannelFig);
            function closeThatFig(doAbort)
                abortValue=doAbort;
                channelTypeStrings={allDropdowns.Value};
                delete(chooseChannelFig);
            end

            function saveWavConfig(~,~)
                persistent lastPath;

                defaultfilename=['loadWavChannelConfigurationFile-' strjoin({allDropdowns.Value},'-') '.txt'];

                if isempty(lastPath)
                    [foldername,~,~]=fileparts(filepath);
                    [file,path]=uiputfile('*.txt','save to wav config text file',fullfile(foldername,defaultfilename));
                else
                    [file,path]=uiputfile('*.txt','save to wav config text file',fullfile(lastPath,defaultfilename));
                end
                if isequal(file,0)
                    return;
                end

                lastPath=path;

                writecell({allDropdowns.Value},fullfile(path,file),"WriteMode","overwrite","FileType","text",'Delimiter',';');

            end

            function loadWavConfig(~,~)
                persistent lastPath;


                if isempty(lastPath)
                    [foldername,~,~]=fileparts(filepath);
                    [file,path]=uigetfile('*.txt','load from wav config text file',foldername);
                else
                    [file,path]=uigetfile('*.txt','load from wav config text file',lastPath);
                end
                if isequal(file,0)
                    return;
                end

                lastPath=path;

                listOfChannelTypes=readcell(fullfile(path,file),'TextType','char','Delimiter',';','FileType','text');

                %disp(listOfChannelTypes')

                for dropdownNr=1:min(numel(listOfChannelTypes),numel(allDropdowns))
                    allDropdowns(dropdownNr).Value=listOfChannelTypes{dropdownNr};
                end

                if isscalar(unique({allDropdowns.Value}))
                    setAllDropdown.Value=listOfChannelTypes{dropdownNr};
                else
                    setAllDropdown.Value='mixed';
                end

            end

            function setsetAllDropdown(~,~)
                currentdropdownvalues=unique({allDropdowns.Value});

                if numel(currentdropdownvalues)>1
                    setAllDropdown.Value='mixed';
                else
                    setAllDropdown.Value=currentdropdownvalues{1};
                end

            end



            function setAllChannelTypes(~,~)
                if strcmp(setAllDropdown.Value,'mixed')
                    return;
                else
                    set(allDropdowns,'Value',setAllDropdown.Value);
                end
            end

        end

        function debounceMinimizeYLims(app,evt)

            persistent debounceTimer;

            if ~isempty(debounceTimer) && isvalid(debounceTimer)
                stop(debounceTimer);
            end

            if app.executeXLimListener
                debounceTimer=timer("ExecutionMode","singleShot","StartDelay",0.5,"TimerFcn",@(~,~) minimizeYLims(app,evt));
                start(debounceTimer);
            end

        end

        function [sourceChannelNr,targetChannelNr] = append_channel_assignment(~,nNewChannels, nExist)

            if nargin==0
                nNewChannels = 4;
                nExist  = 8;
            end

            sourceChannelNr = [];
            targetChannelNr = [];

            figHeight = (nNewChannels + 4) * 40;
            fig = uifigure('Position', [100 100 650 figHeight], ...
                'Name', 'Choose source and target channel fro appending', ...
                'Visible', 'off', ...
                'CloseRequestFcn', @onClose,'Theme','light');
            movegui(fig, 'center');

            kanalliste = arrayfun(@(k) sprintf('existing channel number %d', k), 1:nExist, 'UniformOutput', false);
            kanalIDs   = 1:nExist;

            yStart = figHeight - 20;
            dd = gobjects(nNewChannels,1);

            itemsText = ['–', kanalliste];
            itemsData = [0, kanalIDs];

            % Labels und Dropdowns erzeugen
            for i = 1:nNewChannels
                uilabel(fig, 'Position', [0, yStart - 40*i, 300, 22], ...
                    'Text', sprintf('New channel %d shall be appended to', i), ...
                    'HorizontalAlignment', 'right');
                dd(i) = uidropdown(fig, ...
                    'Position', [310, yStart - 40*i, 300, 22], ...
                    'Items', itemsText, ...
                    'ItemsData', itemsData, ...
                    'Value', 0);
            end

            set(dd,'ValueChangedFcn', @(src,~) updateDropdowns(dd, itemsData, itemsText));

            % Button auto apply
            btnAuto = uibutton(fig, 'push', ...
                'Text', 'auto apply: 1→1, 2→2, ...', ...
                'Position', [220, figHeight - 25, 210, 25], ...
                'ButtonPushedFcn', @(~,~) autoAssign(dd, kanalIDs));

            % Button "Apply"
            btnApply = uibutton(fig, 'push', ...
                'Text', 'Apply', ...
                'Position', [135, 15, 150, 30], ...
                'ButtonPushedFcn', @onApply);

            % Button "Abort"
            btnAbort = uibutton(fig, 'push', ...
                'Text', 'cancel', ...
                'Position', [330, 15, 150, 30], ...
                'ButtonPushedFcn', @onAbort);

            updateDropdowns(dd, itemsData, itemsText);

            % already auto apply as default
            autoAssign(dd, kanalIDs);


            drawnow;
            fig.Visible = 'on';

            uiwait(fig);

            if isvalid(fig) && ~isempty(getappdata(fig,'AssignedValues'))
                vals = getappdata(fig,'AssignedValues');
                idxValid = find(vals ~= 0);
                % output as n x 2 Matrix
                sourceChannelNr = idxValid(:);
                targetChannelNr = vals(idxValid);
                delete(fig);
            else
                sourceChannelNr = [];
                if isvalid(fig)
                    delete(fig);
                end
            end


            function updateDropdowns(dropdowns, allData, allText)
                persistent isUpdating
                if isempty(isUpdating), isUpdating = false; end
                if isUpdating, return; end
                isUpdating = true;

                selectedData = arrayfun(@(d) d.Value, dropdowns);

                for k = 1:numel(dropdowns)
                    prevVal = dropdowns(k).Value;
                    alreadyTaken = setdiff(selectedData, [0, prevVal]); % außer eigener
                    freeData = setdiff(allData(allData > 0), alreadyTaken);
                    itemsXData = [0, freeData];
                    itemsXText = allText(ismember(allData, itemsXData));
                    dropdowns(k).Items = itemsXText;
                    dropdowns(k).ItemsData = itemsXData;

                    if ~ismember(prevVal, itemsXData)
                        dropdowns(k).Value = 0;
                    else
                        dropdowns(k).Value = prevVal;
                    end
                end

                isUpdating = false;
            end

            function autoAssign(dropdowns, kanalIDs)
                set(dropdowns, 'Items', itemsText, 'ItemsData', itemsData, 'Value', 0);
                drawnow;
                nDD = numel(dropdowns);
                maxAssign = min(numel(kanalIDs), nDD);
                assigned = zeros(1, nDD);
                assigned(1:maxAssign) = kanalIDs(1:maxAssign);
                for i = 1:nDD
                    dropdowns(i).Value = assigned(i);
                end
                updateDropdowns(dd, itemsData, itemsText);
            end

            function onApply(~, ~)
                vals = arrayfun(@(d) d.Value, dd);
                setappdata(fig, 'AssignedValues', vals);
                uiresume(fig);
            end

            function onAbort(~, ~)
                if isappdata(fig, 'AssignedValues')
                    rmappdata(fig, 'AssignedValues');
                end
                uiresume(fig);
            end

            function onClose(~, ~)
                if isappdata(fig, 'AssignedValues')
                    rmappdata(fig, 'AssignedValues');
                end
                uiresume(fig);
                delete(fig);
            end
        end




        function setToNormalModeWhenManualToolSelected(app,src,evt)

            if strcmp(evt.Selection.Value,'on') && app.normalButton.Value~=1
                app.refreshInteractionComingFromZoomTool=1;
                app.normalButton.Value=1;
                drawnow;
                app.refreshInteractionMode();
                %evt.Selection.Value='on';
            else
                app.refreshInteractionComingFromZoomTool=1;
                app.refreshInteractionMode();
            end

        end

        function resetView(app,specificAxisNr)

            oldState=app.executeXLimListener;
            app.executeXLimListener=1;
            if ~isempty(specificAxisNr)
                newXLims=app.timePlotHandles(specificAxisNr).XData([1 end]);
                xlim(app.channelAxes,newXLims);
                app.minimizeYLims(app.channelAxes(specificAxisNr));
            else
                xlim(app.channelAxes,[min(cellfun(@(in) in(1),app.channelXValues)) max(cellfun(@(in) in(end),app.channelXValues))]);
                app.minimizeYLims(app.channelAxes(1));
            end

            drawnow;

            app.executeXLimListener=oldState;
        end

        function outCell = struct2cell2col(app)
            %STRUCT2CELL2COL  Wandelt einen skalaren Struct in eine 2-spaltige Zelle um.
            %   outCell = STRUCT2CELL2COL(settings)
            %   Spalte 1: vollständiger Feldname (Punktnotation bei Nested Structs)
            %   Spalte 2: Wert als char
            %
            %   Beide Spalten enthalten Zellarrays von char-Vektoren.

            settings=app.calculationSettings;

            outCell = recurseStruct(settings, '');

            function cellRows = recurseStruct(S, prefix)
                cellRows = {};
                fields = fieldnames(S);
                for i = 1:numel(fields)
                    fname = fields{i};
                    fullName = fname;
                    if ~isempty(prefix)
                        fullName = [prefix '.' fname];
                    end
                    value = S.(fname);
                    if isstruct(value) && isscalar(value)
                        % Rekursiv weitergehen bei Nested Struct
                        cellRows = [cellRows; recurseStruct(value, fullName)];
                    else
                        % Wert → Text umwandeln
                        if isnumeric(value)
                            %valStr = num2str(value);
                            valStr = value; % if numeric, we want to keep it as it is
                        elseif ischar(value)
                            valStr = value;
                        elseif isstring(value)
                            valStr = char(value);
                        elseif islogical(value)
                            valStr = mat2str(value);
                        else
                            valStr = ['<' class(value) '>'];
                        end
                        cellRows = [cellRows; {fullName, valStr}];
                    end
                end
            end
        end




        function openSampEnApp(app,channelNr)
            SEApp=SampEnApp(app.channelYValues{channelNr},app.channelSampleRates(channelNr));

            %SEApp.UIFigure.WindowStyle="modal";

            waitfor(SEApp,'dataApplied',1);

            if ~isvalid(SEApp)
                disp('sample entropy calculation aborted')
                return;
            else
                disp('exporting sample entropy calculation...')
            end

            sampEn=SEApp.finalSampEn(:);
            sampEnTime=SEApp.finalSampEnTime(:);

            if sampEnTime(1)~=0 % this way the signal will have the same delay as the input EGG signal
                sampEnTime=[0;sampEnTime];
                sampEn=[0;sampEn];
            end

            if ~isempty(SEApp.finalCycleFreq)
                cycleFreq=SEApp.finalCycleFreq(:);
                cycleFreqTime=SEApp.finalCycleFreqTime(:);
                cycleFreqAvailable=1;

                if cycleFreqTime(1)~=0 % this way the signal will have the same delay as the input EGG signal
                    cycleFreqTime=[0;cycleFreqTime];
                    cycleFreq=[cycleFreq(1);cycleFreq];
                end
            else
                cycleFreqAvailable=0;
            end



            if isvalid(SEApp)
                delete(SEApp);
            end

            %% save SampEn values

            newFs=1/(min(diff(sampEnTime)));
            [sampEnResampled,sampEnTimeResampled]=resample(sampEn,sampEnTime,newFs);

            % if the original signal was shifted, we also have to shift the
            % new signal
            sampEnTimeResampled=sampEnTimeResampled+app.channelLag(channelNr);

            app.addSingleChannelData(sampEnResampled,sampEnTimeResampled,[app.channelNames{channelNr} ' SampEn']);

            % app.channelLag(end+1)=app.channelLag(channelNr);
            % app.channelYValues{end+1}=sampEnResampled;
            % app.channelXValues{end+1}=sampEnTimeResampled;
            % app.channelSampleRates(end+1)=newFs;
            %
            % app.channelYValuesHistory{1,end+1} = sampEnResampled;
            % app.channelXValuesHistory{1,end+1} = sampEnTimeResampled;
            %
            % app.channelSource{end+1}='Raw';
            %
            % app.channelNames{end+1}=['SampEn of ' app.channelNames{channelNr}];

            %% save cycleFreq if available

            if cycleFreqAvailable
                newFs=1/(min(diff(cycleFreqTime)));
                [cycleFreqResampled,cycleFreqTimeResampled]=resample(cycleFreq,cycleFreqTime,newFs);

                % if the original signal was shifted, we also have to shift the
                % new signal
                cycleFreqTimeResampled=cycleFreqTimeResampled+app.channelLag(channelNr);

                app.addSingleChannelData(cycleFreqResampled,cycleFreqTimeResampled,[app.channelNames{channelNr} ' Cycle Frequency according hilbert']);

                % app.channelLag(end+1)=app.channelLag(channelNr);
                % app.channelYValues{end+1}=cycleFreqResampled;
                % app.channelXValues{end+1}=cycleFreqTimeResampled;
                % app.channelSampleRates(end+1)=newFs;
                %
                % app.channelYValuesHistory{1,end+1} = cycleFreqResampled;
                % app.channelXValuesHistory{1,end+1} = cycleFreqTimeResampled;
                %
                % app.channelSource{end+1}='Raw';
                %
                % app.channelNames{end+1}=['Cycle Frequency according hilbert of ' app.channelNames{channelNr}];

            end



            %% store to table and plot

            % app.availableChannelsTable.Data=[app.channelNames(:) app.channelSource(:)];
            %
            % oldSelection=app.availableChannelsTable.Selection;
            %
            % app.availableChannelsTable.Selection=1:size(app.availableChannelsTable.Data,1);
            %
            % app.refreshTimeAndSpectralPlotData();
            %
            % if ~cycleFreqAvailable
            %     app.availableChannelsTable.Selection=[oldSelection size(app.availableChannelsTable.Data,1)];
            % else
            %     app.availableChannelsTable.Selection=[oldSelection size(app.availableChannelsTable.Data,1)+[-1 0]];
            % end
            % drawnow;
            % app.refreshTimePlotDataVisibility();
        end

        function saveChannelNamesTypesAndSelectedArea(app,completepath,showconfirm)
            if numel(app.channelAxes)==0
                return;
            end

            if nargin<2 || isempty(completepath)
                fakefig=figure('Visible','off');

                persistent lastPath;

                [file,path]=uiputfile({'*.mat','mat file'},'Where to save channel name and type',[lastPath 'channelNamesTypesAndSelectedArea']);

                close(fakefig);
                figure(app.UIFigure);
                if isequal(path,0)
                    return;
                end
                lastPath=path;
                completepath=[path file];
            end
            sources=app.channelSource;
            names=app.channelNames;
            %yhistory=app.channelYValuesHistory;
            %xhistory=app.channelXValuesHistory;
            selectionStart=app.DraggingData.StartX;
            selectionEnd=app.DraggingData.EndX;
            save(completepath,'sources','names','selectionEnd',"selectionStart");

            if nargin<3 || showconfirm==1

                uialert(app.UIFigure,'Saving successfull','Success','Icon','success');

            end

        end

        function loadChannelNamesTypesAndSelectedArea(app,completepath)
            if numel(app.channelAxes)==0
                return;
            end
            if nargin<2 || isempty(completepath)
                fakefig=figure('Visible','off');

                persistent lastPath;

                [file,path]=uigetfile({'*.mat','mat file from Vocaliscope'},'Select mat file with channel name and type',[lastPath 'channelNamesAndTypes']);

                close(fakefig);
                figure(app.UIFigure);
                if isequal(path,0)
                    return;
                end
                lastPath=path;
                completepath=[path file];
            end

            load(completepath,'sources','names');


            for sourceNr=1:min(numel(sources),numel(app.channelAxes))
                if ismember(sources{sourceNr},app.channelSourcePossibilities)
                    currChannelName=names{sourceNr};
                    currSourceType=sources{sourceNr};


                    app.channelSource{sourceNr}=currSourceType;
                    app.channelNames{sourceNr}=currChannelName;
                    app.channelAxes(sourceNr).Title.String=currChannelName;
                    app.availableChannelsTable.Data{sourceNr,1}=currChannelName;
                    app.availableChannelsTable.Data{sourceNr,2}=currSourceType;




                    app.channelAxes(sourceNr).YLabel.String=currSourceType;
                    app.timePlotHandles(sourceNr).Color=app.channelSourcePossibilitiesColor(ismember(app.channelSourcePossibilities,currSourceType),:);
                end
            end

            % before 2.6 the history cells were not sorted according the
            % sample rates of the channel, like the WAV files or channel
            % names. So restoring yhistory is disabled using this function
            %load(completepath, 'yhistory','xhistory');
            %app.channelYValuesHistory=yhistory(:,1:min(numel(sources),numel(app.channelAxes)));
            %app.channelXValuesHistory=xhistory(:,1:min(numel(sources),numel(app.channelAxes)));



            try % added in later version (since 2.5), so we try it
                load(completepath,'selectionEnd',"selectionStart");
                app.DraggingData.StartX=selectionStart;
                app.DraggingData.EndX=selectionEnd;

                delete(app.DraggingData.CurrentRectangles);
                app.DraggingData.CurrentRectangles=gobjects(1,numel(app.channelAxes));

                for channelNr=1:numel(app.channelAxes)
                    yMin=min(app.channelYValues{channelNr})-app.timePlotPadPercentage*range(app.channelYValues{channelNr});
                    yMax=max(app.channelYValues{channelNr})+app.timePlotPadPercentage*range(app.channelYValues{channelNr});
                    app.DraggingData.CurrentRectangles(channelNr) = rectangle(app.channelAxes(channelNr), ...
                        'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.5,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none');
                    uistack(app.DraggingData.CurrentRectangles(channelNr),'bottom');

                    yMin=min(app.spectralPlotHandles(channelNr).YData);
                    yMax=max(app.spectralPlotHandles(channelNr).YData);
                    app.spectralRectangles(channelNr) = rectangle(app.channelAxesSpectral(channelNr), ...
                        'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                        'FaceColor', [0.8, 0.8, 1, 0.5], ...
                        'FaceAlpha',0.2,...
                        'EdgeColor', 'none', ...
                        'PickableParts', 'none');
                    uistack(app.spectralRectangles(channelNr),'top');
                end

                app.SelectedAreaStartEditField.Value=selectionStart;
                app.SelectedAreaEndEditField.Value=selectionEnd;
                app.SelectedAreaDurationEditField.Value=selectionEnd-selectionStart;


            end

            uialert(app.UIFigure,'Loading successfull','Success','Icon','success');



        end

        function createNewNasalanceChannel(app)

            fig=uifigure('Name','Nasalance calculation window','Units','normalized','Position',[0.2 0.2 0.6 0.6],'Theme','light');

            gl=uigridlayout(fig,[7,3],'RowSpacing',3,'ColumnSpacing',3,'Padding',[0 0 0 0],'ColumnWidth',{'1x' '1x' '3x'});


            nasalLabel=uilabel(gl,'Text','Nasal Flow');
            nasalLabel.Layout.Row=1;
            nasalLabel.Layout.Column=1;

            nasalChannelEditField=uieditfield(gl,'numeric','RoundFractionalValues','on','Limits',[1 numel(app.channelAxes)],'AllowEmpty','on');
            nasalChannelEditField.Layout.Row=1;
            nasalChannelEditField.Layout.Column=2;

            oralLabel=uilabel(gl,'Text','Oral Flow');
            oralLabel.Layout.Row=2;
            oralLabel.Layout.Column=1;

            oralChannelEditField=uieditfield(gl,'numeric','RoundFractionalValues','on','Limits',[1 numel(app.channelAxes)],'AllowEmpty','on');
            oralChannelEditField.Layout.Row=2;
            oralChannelEditField.Layout.Column=2;

            existingChannelsWithFlow=flip(find(contains(app.channelSource,'Flow','IgnoreCase',true)));

            if numel(existingChannelsWithFlow)>0
                nasalChannelEditField.Value=existingChannelsWithFlow(1);
            end

            if numel(existingChannelsWithFlow)>1
                oralChannelEditField.Value=existingChannelsWithFlow(2);
            end

            methodDropdown=uidropdown(gl,"Items",["Use Lowpass" "dB(Z) (use stopband freq two change window length)"],'ItemsData',[1 2]);
            methodDropdown.Layout.Row=3;
            methodDropdown.Layout.Column=[1 2];

            passbandFreqLabel=uilabel(gl,'Text','lowpass passband frequency (Hz)');
            passbandFreqLabel.Layout.Row=4;
            passbandFreqLabel.Layout.Column=1;

            passbandFreqEditField = uieditfield(gl,'numeric','Value',10,'Limits',[0.1 inf],'AllowEmpty','off');
            passbandFreqEditField.Layout.Row=4;
            passbandFreqEditField.Layout.Column=2;

            stopbandFreqLabel=uilabel(gl,'Text','lowpass stopband frequency (Hz)');
            stopbandFreqLabel.Layout.Row=5;
            stopbandFreqLabel.Layout.Column=1;

            stopbandFreqEditField = uieditfield(gl,'numeric','Value',20,'Limits',[0.1 inf],'AllowEmpty','off');
            stopbandFreqEditField.Layout.Row=5;
            stopbandFreqEditField.Layout.Column=2;

            stopbandAttLabel=uilabel(gl,'Text','stopband attenuation (dB)');
            stopbandAttLabel.Layout.Row=6;
            stopbandAttLabel.Layout.Column=1;

            stopbandAttEditField = uieditfield(gl,'numeric','Value',30,'Limits',[5 150],'AllowEmpty','off');
            stopbandAttEditField.Layout.Row=6;
            stopbandAttEditField.Layout.Column=2;

            panel=uipanel(gl,'Title','','BorderType','none');
            panel.Layout.Column=3;
            panel.Layout.Row=[1 6];

            tl=tiledlayout(panel,3,2,'Padding','tight','TileSpacing','compact','TileIndexing','columnmajor');

            axNasalRaw=nexttile(tl,1);
            axOralRaw=nexttile(tl,2);
            axNasalanceRaw=nexttile(tl,3);

            axNasalProc=nexttile(tl,4);
            axOralProc=nexttile(tl,5);
            axNasalanceProc=nexttile(tl,6);

            set(findall(fig,'-property','ValueChangedFcn','Parent',gl),'ValueChangedFcn',@(~,~) refreshNasalancePlots(app))


            minLimEditField=uieditfield(gl,'numeric','Value',1);
            minLimEditField.Layout.Column=2;
            minLimEditField.Layout.Row=7;

            maxLimEditField=uieditfield(gl,'numeric','Value',2);
            maxLimEditField.Layout.Column=3;
            maxLimEditField.Layout.Row=7;

            if ~isempty(app.DraggingData.StartX)
                minLimEditField.Value=app.DraggingData.StartX;
                maxLimEditField.Value=app.DraggingData.EndX;
            end

            set([minLimEditField maxLimEditField],'ValueChangedFcn',@setXlims)


            applyButton=uibutton(gl,'Text','Use as new channel');
            applyButton.Layout.Row=7;
            applyButton.Layout.Column=1;

            applyButton.ButtonPushedFcn=@(~,~) calcAndClose(app);




            set(findall(fig,'-property','WordWrap'),'WordWrap','on')


            refreshNasalancePlots(app);

            function setXlims(~,~)
                if isempty(axNasalanceProc.Children)
                    return;
                end

                drawnow;

                xlims=sort([minLimEditField.Value maxLimEditField.Value]);

                xlim([axNasalRaw axOralRaw axNasalanceRaw axNasalProc axOralProc axNasalanceProc],xlims);

                drawnow;

                ylim([axNasalRaw axOralRaw axNasalanceRaw axNasalProc axOralProc axNasalanceProc],'padded');

            end


            function [NasalanceProcessed,NasalanceProcessedTime]=refreshNasalancePlots(app)

                if isempty(nasalChannelEditField.Value)
                    cla(axNasalRaw);
                    cla(axNasalanceRaw);
                end

                if isempty(oralChannelEditField.Value)
                    cla(axOralRaw);
                    cla(axNasalanceRaw);
                end

                if isempty(nasalChannelEditField.Value) && isempty(oralChannelEditField.Value)
                    return;
                end

                nasalChannelNr=nasalChannelEditField.Value;
                oralChannelNr=oralChannelEditField.Value;

                currSampleRates=app.channelSampleRates([nasalChannelNr oralChannelNr]);

                if numel(unique(currSampleRates))>1 % if not same sample rate
                    uialert(fig,"The flow channels do not have the same sample rate. Aborting...","Error");
                    return;
                end

                timeSelectionStart=max([app.channelXValues{oralChannelNr}(1) app.channelXValues{nasalChannelNr}(1)]);
                timeSelectionEnd=min([app.channelXValues{oralChannelNr}(end) app.channelXValues{nasalChannelNr}(end)]);

                % where nose an oral flow signal overlap
                noseExcerpt=app.channelXValues{nasalChannelNr}>=timeSelectionStart & app.channelXValues{nasalChannelNr}<=timeSelectionEnd;
                oralExcerpt=app.channelXValues{oralChannelNr}>=timeSelectionStart & app.channelXValues{oralChannelNr}<=timeSelectionEnd;


                noseFlow=app.channelYValues{nasalChannelNr}(noseExcerpt);
                oralFlow=app.channelYValues{oralChannelNr}(oralExcerpt);

                noseFlowTime=app.channelXValues{nasalChannelNr}(noseExcerpt);
                oralFlowTime=app.channelXValues{oralChannelNr}(oralExcerpt);

                plot(axNasalRaw,noseFlowTime,noseFlow);
                plot(axOralRaw,oralFlowTime,oralFlow);


                nasalanceRaw=combineFlowsFcn(noseFlow,oralFlow);



                nasalanceRaw(nasalanceRaw>1)=1;
                nasalanceRaw(nasalanceRaw<0)=0;

                plot(axNasalanceRaw,noseFlowTime,nasalanceRaw);


                %% pre and post pad

                if size(noseFlow,1)==1 % row vector
                    noseFlow=[ones(1,currSampleRates(1))*noseFlow(1), noseFlow, ones(1,currSampleRates(1))*noseFlow(end)];
                else
                    noseFlow=[ones(currSampleRates(1),1)*noseFlow(1); noseFlow; ones(currSampleRates(1),1)*noseFlow(end)];
                end

                if size(oralFlow,1)==1 % row vector
                    oralFlow=[ones(1,currSampleRates(1))*oralFlow(1), oralFlow, ones(1,currSampleRates(1))*oralFlow(end)];
                else
                    oralFlow=[ones(currSampleRates(1),1)*oralFlow(1); oralFlow; ones(currSampleRates(1),1)*oralFlow(end)];
                end


                %% now we process the flows

                switch methodDropdown.Value


                    case 1 % low pass
                        d = designfilt('lowpassiir', ...        % Response type
                            'PassbandFrequency',passbandFreqEditField.Value, ...     % Frequency constraints
                            'StopbandFrequency',stopbandFreqEditField.Value, ...
                            'PassbandRipple',1, ...          % Magnitude constraints
                            'StopbandAttenuation',stopbandAttEditField.Value, ...
                            'DesignMethod','butter', ...      % Design method
                            'MatchExactly','passband', ...   % Design method options
                            'SampleRate',max(currSampleRates));

                        noseFlowProcessed=filtfilt(d,noseFlow);
                        oralFlowProcessed=filtfilt(d,oralFlow);


                    case 2
                        %splmeter=splMeter("FrequencyWeighting","Z-weighting","SampleRate",max(currSampleRates),'TimeWeighting','Fast');



                        splmeter = dsp.MovingRMS('ForgettingFactor',0,'WindowLength',round(max(currSampleRates)/stopbandFreqEditField.Value));
                        noseFlowProcessed=log10(splmeter(noseFlow));
                        oralFlowProcessed=log10(splmeter(oralFlow));


                end

                %% remove pre and post padded values
                noseFlowProcessed=noseFlowProcessed(currSampleRates(1)+1:end-currSampleRates(1));
                oralFlowProcessed=oralFlowProcessed(currSampleRates(1)+1:end-currSampleRates(1));
                noseFlow=noseFlow(currSampleRates(1)+1:end-currSampleRates(1));
                oralFlow=oralFlow(currSampleRates(1)+1:end-currSampleRates(1));


                %% combine and plot

                NasalanceProcessed=combineFlowsFcn(noseFlowProcessed,oralFlowProcessed);


                NasalanceProcessed(NasalanceProcessed>1)=1;
                NasalanceProcessed(NasalanceProcessed<0)=0;

                NasalanceProcessedTime=(noseFlowTime+noseFlowTime)/2;

                plot(axNasalProc,noseFlowTime,noseFlowProcessed);
                plot(axOralProc,oralFlowTime,oralFlowProcessed);

                plot(axNasalanceProc,NasalanceProcessedTime,NasalanceProcessed);


                title(axNasalRaw,'Nasal Flow Raw');
                title(axOralRaw,'Oral Flow Raw');
                title(axNasalanceRaw,'Nasalance Raw');

                title(axNasalProc,'Nasal Flow Processed');
                title(axOralProc,'Oral Flow Processed');
                title(axNasalanceProc,'Nasalance Processed');

                linkaxes([axNasalRaw axOralRaw axNasalanceRaw axNasalProc axOralProc axNasalanceProc],'x');
                % linkaxes([axNasalRaw   axNasalProc  ],'xy');
                % linkaxes([ axOralRaw   axOralProc ],'xy');
                % linkaxes([  axNasalanceRaw   axNasalanceProc],'xy');



                setXlims([],[]);



            end


            function nasalanceOut=combineFlowsFcn(noseFlow,oralFlow)

                switch methodDropdown.Value
                    case 1
                        nasalanceOut=noseFlow./(noseFlow+oralFlow);
                    case 2
                        nasalanceOut=noseFlow./(noseFlow+oralFlow);
                end

            end

            function calcAndClose(app)


                [NasalanceProcessed,NasalanceProcessedTime]=refreshNasalancePlots(app);

                app.addSingleChannelData(NasalanceProcessed,NasalanceProcessedTime,'Nasalance');

                close(fig);

            end





            %app.addSingleChannelData(NasalanceEnergyBased,NasalanceTime,'Nasalance');



        end

        function addSingleChannelData(app,newY,newX,nameOfNewChannel,typeOfNewChannel,skipStuff)

            if nargin<5 || isempty(typeOfNewChannel)
                typeOfNewChannel='Raw';
            end

            if nargin<6 || isempty(skipStuff)
                skipStuff=0;
            end


            app.titleTimer.stop();

            progDiag=uiprogressdlg(app.UIFigure,"Indeterminate","on",'Title','Adding...','Message','Adding new channel data...');

            newChannelNr=numel(app.channelAxes)+1;

            app.channelYValues(newChannelNr)={newY(:)};
            app.channelXValues(newChannelNr)={newX(:)};
            app.channelNames{newChannelNr}=nameOfNewChannel;
            app.channelSource{newChannelNr}=typeOfNewChannel;
            app.channelYValuesHistory(1,newChannelNr)={newY(:)};
            app.channelXValuesHistory(1,newChannelNr)={newX(:)};
            app.channelSampleRates(newChannelNr)=round(1/min(diff(newX)));
            app.availableChannelsTable.Data=[app.channelNames(:) app.channelSource(:)];
            app.availableChannelsTable.Selection=[app.availableChannelsTable.Selection newChannelNr];
            app.channelLag(newChannelNr)=newX(1);

            app.cycleBorderHandles(newChannelNr)=gobjects(1);
            app.cycleOQHandle(newChannelNr)=gobjects(1);
            app.cycleClQHandle(newChannelNr)=gobjects(1);
            app.timePlotHandles(newChannelNr)=gobjects(1);
            app.spectralPlotHandles(newChannelNr)=gobjects(1);


            % tile numbers are not refreshed when an axes, e.g. the 3rd of
            % 5 is deleted, so the tile number has to be the max number +1

            % this fails when e.g. axes are hidden by setting th eparent
            % prop to zero
            %nextTileNumber=max(tilenum(app.channelAxes))+1;

            nextTileNumber=max(arrayfun(@(in) in.Layout.Tile,app.channelAxes))+1;


            app.channelAxes(newChannelNr)=nexttile(app.tlTime,nextTileNumber);
            app.channelAxesSpectral(newChannelNr)=nexttile(app.tlSpectral,nextTileNumber);


            channelColor=app.channelSourcePossibilitiesColor(contains(app.channelSourcePossibilities,typeOfNewChannel),:);
            app.timePlotHandles(newChannelNr)=plot(app.channelAxes(newChannelNr),newX,newY,'Color',channelColor,'LineWidth',1,'PickableParts','none');
            app.refreshSpectralPlots(newChannelNr);

            xlabel(app.channelAxes(newChannelNr),'time (s)');
            ylabel(app.channelAxes(newChannelNr),'Raw');
            title(app.channelAxes(newChannelNr),app.splitCharArray(nameOfNewChannel,110),'Interpreter','none','Interactions',editInteraction);

            xlabel(app.channelAxesSpectral(newChannelNr),'time (s)');
            ylabel(app.channelAxesSpectral(newChannelNr),'Raw');
            title(app.channelAxesSpectral(newChannelNr),app.splitCharArray(nameOfNewChannel,110),'Interpreter','none');


            app.refreshSelectionEvaluationText(newChannelNr);
            app.refreshAppliedLagTexts();


            grid(app.channelAxes(newChannelNr),'on');
            grid(app.channelAxesSpectral(newChannelNr),'off');



            app.channelAxes(newChannelNr).UserData.channelNr=newChannelNr;
            app.channelAxesSpectral(newChannelNr).UserData.channelNr=newChannelNr;

            app.addContextMenuToAxis(newChannelNr);



            drawnow;

            if ~skipStuff

                prae=app.executeXLimListener;
                app.executeXLimListener=1;
                app.minimizeYLims(app.channelAxes(1));
    
                app.executeXLimListener=prae;
    
                delete(app.xlimListener);
                app.xlimListener=listener([app.channelAxes app.channelAxesSpectral], 'XLim', 'PostSet', @(~, evt) debounceMinimizeYLims(app,evt));

            
                app.refreshInteractionMode();
    
                app.createAudioPlayerData();

                drawnow;

                app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(0);
            end

            if ~isempty(app.DraggingData.StartX) % we need to add the rectangle to the newly added channel
                % xlimits=xlim(app.channelAxes(newChannelNr));
                % excerpt=app.channelYValues{newChannelNr}(app.channelXValues{newChannelNr}>=xlimits(1) & app.channelXValues{newChannelNr}<=xlimits(2));
                % ylimits=[min(excerpt) max(excerpt)];

                ylimits=[min(app.channelYValues{newChannelNr}) max(app.channelYValues{newChannelNr})];%range(app.channelYValues{newChannelNr});
                ylim(app.channelAxes(newChannelNr),'manual');
                ylimits=ylimits+[-1 1]*app.timePlotPadPercentage*range(ylimits);
                yMin=ylimits(1);
                yMax=ylimits(2);
                app.DraggingData.CurrentRectangles(newChannelNr)=rectangle(app.channelAxes(newChannelNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.5,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
                uistack(app.DraggingData.CurrentRectangles(newChannelNr),'bottom');

                yMin=min(app.spectralPlotHandles(newChannelNr).YData);
                yMax=max(app.spectralPlotHandles(newChannelNr).YData);
                app.spectralRectangles(newChannelNr)=rectangle(app.channelAxesSpectral(newChannelNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.2,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
                uistack(app.spectralRectangles(newChannelNr),'top');


            end

            drawnow;

            %scroll(app.plottingPanelContainer,'bottom');
            
            delete(progDiag);

            app.titleTimer.start();

        end

        function addContextMenuToAxis(app,channelNr)

            persistent cmenu

            nameOfNodeToChangeSourceType='Change Source';

            if isempty(cmenu)

                cmenu = uicontextmenu(app.UIFigure);

                % change source node
                changeSourceNode = uimenu(cmenu, 'Text', nameOfNodeToChangeSourceType);
                subNodesText = app.channelSourcePossibilities;
                subHandles = gobjects(size(subNodesText));
                for dispNr = 1:numel(subNodesText)
                    subHandles(dispNr) = uimenu(changeSourceNode, 'Text', subNodesText{dispNr}, ...
                        'Callback',@(src,~)app.uiMenuChangeColorCallback(src,app.UIFigure.CurrentAxes.UserData.channelNr));
                end

                % i skip that since i want to use the same cmenu for all
                % axes for now, so i disable the check marks
                %subHandles(ismember(app.channelSourcePossibilities,app.channelSource{channelNr})).Checked='on';

                % filter channel node
                %filteringNode = uimenu(cmenu, 'Text', 'Filtering...');
                filterToolboxNode = uimenu(cmenu, 'Text', 'Process with Filter Toolbox...','Callback',@(~,~) app.uiMenuFilterDataCallback(app.UIFigure.CurrentAxes.UserData.channelNr),'Separator','on');




                % edit selected area
                basicEditingNode = uimenu(cmenu,'Text','Basic Editing');
                basicEditingThisChannelOnlySubnode = uimenu(basicEditingNode,'Text','Edit this channel only');
                basicEditingAllDisplayedChannelsSubnode = uimenu(basicEditingNode,'Text','Edit all displayed channels');
                basicEditingAllChannelsSubnode = uimenu(basicEditingNode,'Text','Edit all available channels');

                basicEditingTypes={'this','displayed','all'};
                nodes=[basicEditingThisChannelOnlySubnode basicEditingAllDisplayedChannelsSubnode basicEditingAllChannelsSubnode];
                for affectedChannelsTypeNr=1:numel(basicEditingTypes)
                    editWholeChannelDataNode = uimenu(nodes(affectedChannelsTypeNr),'Text','affect whole channel data');
                    markedAreaOnlyNode = uimenu(nodes(affectedChannelsTypeNr),'Text','affect selected area only');

                    affectedArea={'whole' 'marked'};
                    affectedAreaNodes=[editWholeChannelDataNode markedAreaOnlyNode];
                    for affectedAreaTypeNr=1:numel(affectedArea)

                        if affectedAreaTypeNr>1 % only available for affecting the marked area
                            uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Delete and concatenate','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'delete'));

                            uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Overwrite with linear ramp','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'linearRamp'));

                            %% set to
                            setToNode=uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Set to ...');
                            uimenu(setToNode,'Text','Zero','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToZero'));

                            uimenu(setToNode,'Text','Channel min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToChannelMin'));
                            uimenu(setToNode,'Text','Channel marked area min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToSelectionMin'));

                            uimenu(setToNode,'Text','Channel max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToChannelMax'));
                            uimenu(setToNode,'Text','Channel marked area max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToSelectionMax'));

                            uimenu(setToNode,'Text','Channel mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToChannelMean'));
                            uimenu(setToNode,'Text','Channel marked area mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToSelectionMean'));

                            uimenu(setToNode,'Text','Channel median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToChannelMedian'));
                            uimenu(setToNode,'Text','Channel marked area median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'setToSelectionMedian'));
                        end

                        %% changes in differential
                        if affectedChannelsTypeNr==1
                            differentialNode=uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Differential...');
                            uimenu(differentialNode,'Text','Set selection maximum to 0','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'selectionDifferentialMaxToZero'));
                            uimenu(differentialNode,'Text','Set selection minimum to 0','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'selectionDifferentialMinToZero'));
                            uimenu(differentialNode,'Text','Set selection absolute maximum to 0','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'selectionDifferentialAbsMaxToZero'));

                            uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Delete inverse selection','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'deleteInverse'));


                        end

                        %% add ...
                        addValueNode=uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Add value ...');

                        uimenu(addValueNode,'Text','Channel min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addChannelMin'));
                        uimenu(addValueNode,'Text','Channel marked area min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addSelectionMin'));

                        uimenu(addValueNode,'Text','Channel max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addChannelMax'));
                        uimenu(addValueNode,'Text','Channel marked area max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addSelectionMax'));

                        uimenu(addValueNode,'Text','Channel mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addChannelMean'));
                        uimenu(addValueNode,'Text','Channel marked area mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addSelectionMean'));

                        uimenu(addValueNode,'Text','Channel median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addChannelMedian'));
                        uimenu(addValueNode,'Text','Channel marked area median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'addSelectionMedian'));

                        %% subtract ...
                        subtractValueNode=uimenu(affectedAreaNodes(affectedAreaTypeNr),'Text','Subtract value ...');

                        uimenu(subtractValueNode,'Text','Channel min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractChannelMin'));
                        uimenu(subtractValueNode,'Text','Channel marked area min','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractSelectionMin'));

                        uimenu(subtractValueNode,'Text','Channel max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractChannelMax'));
                        uimenu(subtractValueNode,'Text','Channel marked area max','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractSelectionMax'));

                        uimenu(subtractValueNode,'Text','Channel mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractChannelMean'));
                        uimenu(subtractValueNode,'Text','Channel marked area mean','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractSelectionMean'));

                        uimenu(subtractValueNode,'Text','Channel median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractChannelMedian'));
                        uimenu(subtractValueNode,'Text','Channel marked area median','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'subtractSelectionMedian'));





                    end

                    % if the basic editing does not depend on affected area
                    % whole or selected

                    % leading zeros to lag
                    leadingZerosToLagNode = uimenu(nodes(affectedChannelsTypeNr),'Text','Convert leading zeros to lag','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'leadingZerosToLag'));
                    paddingNode = uimenu(nodes(affectedChannelsTypeNr),'Text','Padding...');
                    prepadNode = uimenu(paddingNode,'Text','Pre-pad to earliest signal start','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'prepadToEarliestStart'));
                    postpadNode = uimenu(paddingNode,'Text','Post-pad to latest signal end','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'postpadToLatestEnd'));
                    preAndPostpadNode = uimenu(paddingNode,'Text','Pre- and post-pad','Callback',@(src,evt) app.performBasicChannelEditing(app.UIFigure.CurrentAxes.UserData.channelNr,basicEditingTypes{affectedChannelsTypeNr},affectedArea{affectedAreaTypeNr},'preAndPostPad'));


                end

                %% calibration point
                calibrationNode = uimenu(cmenu, 'Text', 'Calibrate using...');

                calibrateByStartAndEndNode = uimenu(calibrationNode, 'Text','Abs. Difference of start and end of marked region','Callback',@(src,evt) app.calibrationByStartEnd(app.UIFigure.CurrentAxes.UserData.channelNr));
                calibrateBySummedAreaNode  = uimenu(calibrationNode, 'Text','summed values inside marked region','Callback',@(src,evt) app.calibrationBySummedArea(app.UIFigure.CurrentAxes.UserData.channelNr));
                calibrateBySPL             = uimenu(calibrationNode, 'Text','SPL inside marked region','Callback',@(src,evt) app.calibrationByAreaSPL(app.UIFigure.CurrentAxes.UserData.channelNr));
                calibrateByTwoChannel      = uimenu(calibrationNode, 'Text','Comparison of two channels','Callback',@(src,evt) app.calibrationByTwoChannels());


                %% generate data from this channel
                createNewChannelsNode = uimenu(cmenu,'Text','Calculate from this channel...');
                sampleEntropyNode = uimenu(createNewChannelsNode, 'Text', 'Sample Entropy based on Fourier descriptors...','Callback',@(~,~) app.openSampEnApp(app.UIFigure.CurrentAxes.UserData.channelNr));
                NasalanceNode = uimenu(createNewChannelsNode,'Text', 'Nasalance','Callback',@(~,~) app.createNewNasalanceChannel());
                MaskCreatorNode = uimenu(createNewChannelsNode,'Text', 'Mask depending on signal valleys and peaks','Callback',@(~,~) app.openMaskCreatorApp(app.UIFigure.CurrentAxes.UserData.channelNr));
                SPLCreaterNode = uimenu(createNewChannelsNode,'Text', 'SPL','Callback',@(~,~) app.openSPLcalculationWindow(app.UIFigure.CurrentAxes.UserData.channelNr));
                foCreaterNode = uimenu(createNewChannelsNode,'Text', 'Fundamental Frequency','Callback',@(~,~) app.openFoCalculationWindow(app.UIFigure.CurrentAxes.UserData.channelNr));
                formantCreaterNode = uimenu(createNewChannelsNode,'Text', 'Formants','Callback',@(~,~) app.openFormantEstimationWindow(app.UIFigure.CurrentAxes.UserData.channelNr));
                inverseFilteringNode = uimenu(createNewChannelsNode,'Text', 'Inverse Filtering (selection)');

                aaltoAparatNode=uimenu(inverseFilteringNode,'Text', 'Aalto Aparat (QCP + IAIF)','Callback',@(~,~) app.openAaltoAparat(app.UIFigure.CurrentAxes.UserData.channelNr));
                otherInverseFilteringNode =uimenu(inverseFilteringNode,'Text', 'Others','Callback',@(~,~) app.openInverseFilteringApp(app.UIFigure.CurrentAxes.UserData.channelNr));

                praatNode=uimenu(createNewChannelsNode,'Text', 'Praat Playground','Callback',@(~,~) openPraatAnalysisWindow(app,app.UIFigure.CurrentAxes.UserData.channelNr));

                onsetNode=uimenu(createNewChannelsNode,'Text','Onset Analysis...','Callback',@(~,~) openOnsetAnalysisWindow(app,app.UIFigure.CurrentAxes.UserData.channelNr));

                vibratoNode = uimenu(createNewChannelsNode,'Text','Vibrato Analysis...','Callback',@(~,~) openVibratoAnalysisWindow(app,app.UIFigure.CurrentAxes.UserData.channelNr));

                
                
                voiceActivityCreaterNode = uimenu(createNewChannelsNode,'Text', 'Voice activity probability','Callback',@(~,~) app.openVADWindow(app.UIFigure.CurrentAxes.UserData.channelNr));
                envelopeCreaterNode = uimenu(createNewChannelsNode,'Text', 'Envelope','Callback',@(~,~) app.openEnvelopeWindow(app.UIFigure.CurrentAxes.UserData.channelNr));

                % disabled since we now have a spectral view anyways
                % cwtCreatorNode = uimenu(createNewChannelsNode,'Text', 'Continuous Wavelet transform (like spectrogram)','Callback',@(~,~) app.openCWTWindow(app.UIFigure.CurrentAxes.UserData.channelNr));


                changeTemporalResolutionNode = uimenu(cmenu,'Text','Resample...','Callback',@(~,~) app.openResamplingApp(app.UIFigure.CurrentAxes.UserData.channelNr));


                % conversion, e.g. Pa to cm H2O
                conversionChannelNode = uimenu(cmenu, 'Text', 'Unit conversion...','Separator','on');
                cmH2OToPaChannelNode = uimenu(conversionChannelNode, 'Text', 'cm H2O to Pa','Callback',@(~,~) app.convertCmH2OtoPa(app.UIFigure.CurrentAxes.UserData.channelNr));
                PaToCmH2OChannelNode = uimenu(conversionChannelNode, 'Text', 'Pa cm H2O','Callback',@(~,~) app.convertPaToCmH2O(app.UIFigure.CurrentAxes.UserData.channelNr));

                dB2MagChannelNode = uimenu(conversionChannelNode, 'Text', 'dB to magnitude','Callback',@(~,~) app.convertdBtoMag(app.UIFigure.CurrentAxes.UserData.channelNr));
                magTodBChannelNode = uimenu(conversionChannelNode, 'Text', 'magnitude to dB','Callback',@(~,~) app.convertMagTodB(app.UIFigure.CurrentAxes.UserData.channelNr));



                %% duplicate channel
                duplicateChannelNode = uimenu(cmenu, 'Text', 'Duplicate channel','Callback',@(~,~) app.uiMenuDuplicateChannelCallback(app.UIFigure.CurrentAxes.UserData.channelNr),'Separator','on');



                %% undo context point
                lowerLeftAccelerator='';%app.getLowerLeftAccelerator();
                changeUndoNode = uimenu(cmenu, 'Text', 'Go back to previous version','Callback',@(~,~) app.uiMenuUndoDataChangeCallback(app.UIFigure.CurrentAxes.UserData.channelNr),'Accelerator',lowerLeftAccelerator,'Separator','on');

                changeUndoNode.UserData.channelNr=channelNr;



                %% restore view context point

                resetViewNode = uimenu(cmenu, 'Text', 'Reset view in...','Separator','on');

                resetViewSingleNode = uimenu(resetViewNode, 'Text', 'this channel','Callback',@(~,~) app.resetView(app.UIFigure.CurrentAxes.UserData.channelNr));
                resetViewAllNode = uimenu(resetViewNode, 'Text', 'all channels','Callback',@(~,~) app.resetView([]));


                

            end

            app.channelAxes(channelNr).ContextMenu=cmenu;
            %app.channelAxesSpectral(channelNr).ContextMenu=cmenu;


            % this does not work since the same cmenu is used for all
            % objects, so this would set it always to the value of the last
            % channel loaded. for that reason, i skip checking the menu for
            % now

            % % for all axes that use the non newly generated cmenu. we have
            % % to update the channel source property in the context menu
            % subHandles=findall(cmenu,'Text',nameOfNodeToChangeSourceType).Children;
            % subHandles=flip(subHandles); % children are generated vice versa as expected
            % set(subHandles,'Checked','off');
            % subHandles(ismember(app.channelSourcePossibilities,app.channelSource{channelNr})).Checked='on';


        end

        function deleteSignals(app,selection)
            if ~isempty(app.availableChannelsTable.Data)
                app.channelYValues(selection)=[];
                app.channelXValues(selection)=[];
                app.channelYValuesHistory(:,selection)=[];
                app.channelXValuesHistory(:,selection)=[];
                app.channelLag(selection)=[];
                %app.channelNames(selection)=[]; moved to the end since
                %this is refreshed by the title refresh timer
                app.channelSampleRates(selection)=[];
                app.channelSource(selection)=[];
                app.selectionEvaluationTexts(selection)=[];
                app.selectionEvaluationSpectralTexts(selection)=[];

                % this is needed because the
                % updateSelectionAreaEditFieldsLimits throws an error of
                % invalid objects exist.
                if ~isempty(app.DraggingData.CurrentRectangles)
                    delete(app.DraggingData.CurrentRectangles);
                    app.DraggingData.CurrentRectangles=[];

                    delete(app.spectralRectangles);
                    app.spectralRectangles=[];
                end

                % if every channel was deleted
                if isempty(app.channelLag)
                    delete(app.DraggingData.CurrentRectangles);
                    delete(app.DraggingData.PreviousRectangles);
                    delete(app.spectralRectangles);
                    delete(app.spectralRectanglesPrevious);
                    app.DraggingData=struct('Dragging', false, 'StartX', [], 'EndX', [],...
                        'CurrentRectangles', [], 'PreviousRectangles', []);

                    app.spectralRectangles=[];
                    app.spectralRectanglesPrevious=[];

                    app.SelectedAreaStartEditField.Value=-inf;
                    app.SelectedAreaEndEditField.Value=inf;
                    app.SelectedAreaDurationEditField.Value=0;
                    app.SaveResultsButton.Enable="off";
                end


                if ~isempty(app.calculationResults) && ~isempty(app.calculationResults.channelResults)
                    % remove calcultions stored from that channel
                    app.calculationResults.channelResults(selection(selection<=numel(app.calculationResults.channelResults)))=[];
                end

                if ~isempty(app.channelAxes)
                    app.xlimBeforeDeletion=app.channelAxes(1).XLim;
                end

                delete(app.channelAxes(selection));
                delete(app.channelAxesSpectral(selection));

                app.channelAxes(selection)=[];
                app.channelAxesSpectral(selection)=[];

                % remove from channel table and set no selection

                app.availableChannelsTable.Data(selection,:)=[];




                %app.channelAxes=gobjects(0);

                % update the channel number stored in the UserData
                for channelNr=1:numel(app.channelAxes)
                    app.channelAxes(channelNr).UserData.channelNr=channelNr;
                    app.channelAxesSpectral(channelNr).UserData.channelNr=channelNr;
                end

                app.timePlotHandles(selection)=[];
                app.spectralPlotHandles(selection)=[];

                app.cycleBorderHandles(selection)=[];
                app.cycleOQHandle(selection)=[];
                app.cycleClQHandle(selection)=[];


                if isempty(app.availableChannelsTable.Data)
                    app.ResultsTab.Parent=[];
                    app.TabGroup.SelectedTab=app.TimeViewTab;
                end


                app.channelNames(selection)=[];
                app.updateSelectionAreaEditFieldsLimits();


                app.availableChannelsTable.Selection=1:numel(app.channelAxes);
                app.refreshTimeAndSpectralPlotDataVisibility();

                app.refreshAppliedLagTexts();
            end

        end

        function [xSetValuesOut, ySetValuesOut] = prepadPostpadToCommonRange(~,xSetValues, ySetValues, sampleRates,minStart,maxEnd)
            nSignals = numel(xSetValues);

            xSetValuesOut = cell(size(xSetValues));
            ySetValuesOut = cell(size(ySetValues));

            for i = 1:nSignals
                x = xSetValues{i}(:);
                y = ySetValues{i}(:);
                fs = sampleRates(i);
                dx = 1/fs;

                % Prepad calculations
                shiftStart = x(1) - minStart;
                nPrePad = round(shiftStart * fs);

                % Postpad calculations
                shiftEnd = maxEnd - x(end);
                nPostPad = round(shiftEnd * fs);

                % Generate prepend and append time vectors and zero values
                xPrePad = minStart + ((0:(nPrePad-1))*dx)';
                yPrePad = zeros(nPrePad,1);
                xPostPad = (x(end) + dx) + ((0:(nPostPad-1))*dx)';
                yPostPad = zeros(nPostPad,1);



                % Concatenate padded vectors
                xSetValuesOut{i} = [xPrePad; x; xPostPad];
                ySetValuesOut{i} = [yPrePad; y; yPostPad];
            end
        end


        function uiMenuDuplicateChannelCallback(app,channelNr)

            newChannelName=[app.channelNames{channelNr} ' duplicate'];

            newXData=app.channelXValues{channelNr};
            newYData=app.channelYValues{channelNr};

            app.addSingleChannelData(newYData,newXData,newChannelName,app.channelSource{channelNr});

        end

        function openMaskCreatorApp(app,channelNr)

            maskApp=maskCreator(app.channelYValues{channelNr},app.channelXValues{channelNr});

            %uiwait(app.UIFigure);

            waitfor(maskApp,'finalMask');

            returnedMask=maskApp.finalMask;
            delete(maskApp);


            %uiresume(app.UIFigure);

            if isnan(returnedMask)
                return;
            end

            app.addSingleChannelData(returnedMask,app.channelXValues{channelNr},'Mask');

        end

        function openShiftTool(app)
            if isempty(app.availableChannelsTable.Data)
                return;
            end

            shifttoolFig=uifigure('WindowStyle','normal','Name','Shifttool','Units','normalized','Position',[0.25 0.25 0.5 0.5],'Theme','light','Visible','off');

            uigrid=uigridlayout(shifttoolFig,[5,2],"ColumnWidth",{200 '1x'},"RowHeight",{'fit','fit','1x','fit'});

            persistent lastShiftNumberUnit lastShiftAmountValue

            if isempty(lastShiftNumberUnit)
                lastShiftNumberUnit='ms';
                lastShiftAmountValue=0;
            end


            ShiftTypeDropdown=uidropdown(uigrid,"Items",{'Time in ms','Time in s','By Frames'},'ItemsData',{'ms' 's' 'frames'},'Value',lastShiftNumberUnit);
            ShiftTypeDropdown.Layout.Row=1;
            ShiftTypeDropdown.Layout.Column=2;

            ShiftTypeDropdownLabel=uilabel(uigrid,"Text",'Unit of shift','WordWrap','on');
            ShiftTypeDropdownLabel.Layout.Row=1;
            ShiftTypeDropdownLabel.Layout.Column=1;

            ShiftAmountEdit=uieditfield(uigrid,"numeric","Value",lastShiftAmountValue,"Tooltip",'Positive values add lag','ValueDisplayFormat',['%+11g ' ShiftTypeDropdown.Value]);
            ShiftAmountEdit.Layout.Row=2;
            ShiftAmountEdit.Layout.Column=2;

            ShiftTypeDropdown.ValueChangedFcn=@(~,~) set(ShiftAmountEdit,'ValueDisplayFormat',['%+11g ' ShiftTypeDropdown.Value],'RoundFractionalValues',contains(ShiftTypeDropdown.Value,'frame'));

            HowMuchEditLabel=uilabel(uigrid,"Text",'How much? (ms)','Tooltip',ShiftAmountEdit.Tooltip,'WordWrap','on');
            HowMuchEditLabel.Layout.Row=2;
            HowMuchEditLabel.Layout.Column=1;

            availableSignalsTable = uitable(uigrid,'Data',[app.shortenNames(app.availableChannelsTable.Data(:,1)) num2cell(app.channelLag(:))],'ColumnWidth',{'1x' '1x'},...
                'ColumnEditable',[false false],'SelectionType','row','ColumnName',{'channel name' 'current shift (s)'},...
                'ColumnSortable',[false false],'Multiselect','on','RowName',[],'Selection',1:numel(app.channelLag),'RowStriping','off');
            availableSignalsTable.Layout.Row=3;
            availableSignalsTable.Layout.Column=2;

            availableSignalsTableLabel= uilabel(uigrid,"Text",'Select signals to shift','WordWrap','on','VerticalAlignment','top');
            availableSignalsTableLabel.Layout.Row=3;
            availableSignalsTableLabel.Layout.Column=1;

            openShiftEstimatorButton = uibutton(uigrid,'Text','Open Lag Estimator Tool','WordWrap','on','ButtonPushedFcn',@(~,evt) app.LagEstimatorofselectionMenuSelected(evt));
            openShiftEstimatorButton.Layout.Row=4;
            openShiftEstimatorButton.Layout.Column = [1 2];

            RemoveShiftButton=uibutton(uigrid,'push','Text','Remove Shift','ButtonPushedFcn',@(~,~)removeChannelShift(app),'WordWrap','on');
            RemoveShiftButton.Layout.Row=5;
            RemoveShiftButton.Layout.Column=1;

            function removeChannelShift(app)
                if isempty(availableSignalsTable.Selection)
                    return;
                end
                app.setChannelShiftToZero(availableSignalsTable.Selection);
                availableSignalsTable.Data(availableSignalsTable.Selection,2)={0};

                drawnow;
            end

            ApplyShiftButton=uibutton(uigrid,'push','Text','Apply Shift');
            ApplyShiftButton.Layout.Row=5;
            ApplyShiftButton.Layout.Column=2;

            ApplyShiftButton.ButtonPushedFcn=@(~,~) adjustSignalShift(app);

            shifttoolFig.CloseRequestFcn=@(~,~) addLatestVersionsToHistory(app);

            drawnow;

            shifttoolFig.Visible='on';
            drawnow;


            function adjustSignalShift(app)
                selected=availableSignalsTable.Selection;
                oldLags=app.channelLag(selected);

                % convert to seconds
                if strcmp(ShiftTypeDropdown.Value,'ms')
                    toBeAdded=repelem(ShiftAmountEdit.Value/1000,numel(selected));
                elseif strcmp(ShiftTypeDropdown.Value,'s')
                    toBeAdded=repelem(ShiftAmountEdit.Value,numel(selected));
                else % frames
                    toBeAdded=ShiftAmountEdit.Value./app.channelSampleRates(selected);
                end
                newTotalLags=oldLags+toBeAdded;
                app.channelLag(selected)=newTotalLags;

                availableSignalsTable.Data(selected,2)=num2cell(newTotalLags);

                % this is slow and not that handy, try to adjust the
                % plotted handles directly
                %app.refreshTimeAndSpectralPlotData();

                xlim(app.channelAxes,'manual');
                for nr=1:numel(selected)
                    newTimevalues=app.channelXValues{selected(nr)}+toBeAdded(nr);
                    app.channelXValues{selected(nr)}=newTimevalues;

                    if ~isempty(find(app.availableChannelsTable.Selection==selected(nr),1))
                        %app.timePlotHandles(find(app.availableChannelsTable.Selection==selected(nr),1)).XData=newTimevalues;

                        app.timePlotHandles(selected(nr)).XData=newTimevalues;
                    end

                    if numel(app.cycleBorderHandles)>=nr && app.isvalidhandle(app.cycleBorderHandles(selected(nr)))
                        app.cycleBorderHandles(selected(nr)).XData([1:3:end 2:3:end])=app.cycleBorderHandles(selected(nr)).XData([1:3:end 2:3:end])+toBeAdded(nr);
                    end

                    app.refreshSpectralPlots(selected(nr),1);
                end

                drawnow;

                lastShiftNumberUnit=ShiftTypeDropdown.Value;
                lastShiftAmountValue=ShiftAmountEdit.Value;


                % if we move the signals outside the marked area, we need
                % reduce the marked area
                if ~isempty(app.DraggingData.StartX)
                    app.DraggingData.StartX=max([app.DraggingData.StartX cellfun(@(in) in(1),app.channelXValues)]);
                    app.DraggingData.EndX=min([app.DraggingData.EndX cellfun(@(in) in(end),app.channelXValues)]);

                    if app.DraggingData.StartX>=app.DraggingData.EndX
                        app.DraggingData.StartX=[];
                        app.DraggingData.EndX=[];
                        delete(app.DraggingData.CurrentRectangles);
                        app.DraggingData.CurrentRectangles=[];

                        delete(app.spectralRectangles);
                        app.spectralRectangles=[];

                        app.SelectedAreaStartEditField.Value=max(cellfun(@(in) in(1),app.channelXValues));
                        app.SelectedAreaEndEditField.Value=min(cellfun(@(in) in(end),app.channelXValues));
                        app.SelectedAreaDurationEditField=app.SelectedAreaEndEditField.Value-app.SelectedAreaStartEditField.Value;
                    else
                        for rectNr=1:numel(app.DraggingData.CurrentRectangles)
                            app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.DraggingData.StartX app.DraggingData.EndX-app.DraggingData.StartX];
                            app.spectralRectangles(rectNr).Position([1 3])=app.DraggingData.CurrentRectangles(rectNr).Position([1 3]);
                        end
                    end

                end



                app.updateSelectionAreaEditFieldsValues();

                %if ~isempty(app.DraggingData.StartX)
                app.updateSelectionAreaEditFieldsLimits();
                %end

                app.refreshSelectionEvaluationText();
                app.refreshAppliedLagTexts();

                app.createAudioPlayerData();
            end


            function addLatestVersionsToHistory(app)

                for channelNr=1:numel(app.channelAxes)
                    currentChannelYHistory=app.channelYValuesHistory(:,channelNr);
                    currentChannelXHistory=app.channelXValuesHistory(:,channelNr);

                    mostRecentYValues=app.channelYValues{channelNr};
                    mostRecentXValues=app.channelXValues{channelNr};

                    lastNonEmptyEntry=find(~cellfun(@isempty,currentChannelYHistory),1,"last");

                    if ~isequal(mostRecentYValues,currentChannelYHistory{lastNonEmptyEntry}) || ~isequal(mostRecentXValues,currentChannelXHistory{lastNonEmptyEntry})
                        app.addValueSetToValueHistory(mostRecentYValues,mostRecentXValues,channelNr);
                    end
                end

                delete(shifttoolFig);
            end


        end

        function openSPLcalculationWindow(app,channelNr)
            targetValue=0;
            persistent splWeighting splSpeed splOutputMetric reportInterval
            if isempty(splWeighting)
                splWeighting='A-weighting';
                splSpeed='Fast';
                splOutputMetric=1;
                reportInterval=1;
            end

            %% create figure
            fig=uifigure('Units','pixels','Position',[0 0 900 300],'Visible','off','Theme','light'); % doubled width
            movegui(fig,'center');

            drawnow;
            fig.Visible='on';

            % Updated grid layout: 12 rows, 3 columns, to fit new axes
            gl=uigridlayout(fig,[6 3],"ColumnWidth",{'1x','1x','2x'},'RowSpacing',1);

            spllabel=uilabel(gl,"Text",'Reference Pressure (Pa)','WordWrap','on');
            spllabel.Layout.Column=1;
            spllabel.Layout.Row=3;
            persistent lastSPLreferenceValue;
            if isempty(lastSPLreferenceValue)
                lastSPLreferenceValue=20e-6;
            end

            editField=uieditfield(gl,'numeric','Limits',[0 inf],'Tooltip','Use 0 or close window if you want to cancel','Value',lastSPLreferenceValue,'ValueDisplayFormat','%g Pa');
            editField.Layout.Column=2;
            editField.Layout.Row=3;
            spltypelabel=uilabel(gl,"Text",'SPL weighting','WordWrap','on');
            spltypelabel.Layout.Column=1;
            spltypelabel.Layout.Row=1;
            dBtypeDropdown=uidropdown(gl,"Items",{'dB(A)','dB(C)','dB(Z)'},'ItemsData',{'A-weighting','C-weighting','Z-weighting'},'Value',splWeighting);
            dBtypeDropdown.Layout.Column=2;
            dBtypeDropdown.Layout.Row=1;
            splSpeedlabel=uilabel(gl,"Text",'SPL time constant','WordWrap','on');
            splSpeedlabel.Layout.Column=1;
            splSpeedlabel.Layout.Row=2;
            dBSpeedDropdown=uidropdown(gl,'Items',{'Fast (125ms)','Slow (1s)'},"ItemsData",{'Fast','Slow'},'Value',splSpeed);
            dBSpeedDropdown.Layout.Column=2;
            dBSpeedDropdown.Layout.Row=2;
            sploutputlabel=uilabel(gl,"Text",'Output Metric','WordWrap','on');
            sploutputlabel.Layout.Column=1;
            sploutputlabel.Layout.Row=4;
            metricList={'Time-weighted sound level','Equivalent-continuous sound level','Peak sound level','Maximum time-weighted sound level'};
            dBoutputmetricDropdown=uidropdown(gl,"Items",metricList,'ItemsData',{1 2 3 4},'Value',splOutputMetric);
            dBoutputmetricDropdown.Layout.Column=2;
            dBoutputmetricDropdown.Layout.Row=4;

            vis=splOutputMetric~=1;
            sploutputintervallabel=uilabel(gl,"Text",'Report interval (s)','WordWrap','on','Visible',vis);
            sploutputintervallabel.Layout.Column=1;
            sploutputintervallabel.Layout.Row=5;
            dBoutputmetricIntervalEditField=uieditfield(gl,'numeric','Visible',vis,'Limits',[0 range(app.channelXValues{channelNr})],'LowerLimitInclusive','off','ValueDisplayFormat','%g s','Value',reportInterval);
            dBoutputmetricIntervalEditField.Layout.Column=2;
            dBoutputmetricIntervalEditField.Layout.Row=5;




            applyButton=uibutton(gl,'Text','apply','ButtonPushedFcn',@saveAndClose);
            applyButton.Layout.Column=2;
            applyButton.Layout.Row=6;

            pnl=uipanel(gl,"Title",'','BorderType','none','Visible','off');
            pnl.Layout.Column=3;
            pnl.Layout.Row=[1 6];

            tl=tiledlayout(pnl,2,1,'Padding','compact','TileSpacing','compact');
            % tl.Layout.Row=[1 6];
            % tl.Layout.Column=3;

            % Add two new axes to third column: upper 3 rows for original data, lower 6 rows for SPL curve
            % axOriginal = uiaxes(gl);
            % axOriginal.Layout.Row = [1 3];
            % axOriginal.Layout.Column = 3;
            axOriginal = nexttile(tl,1);
            plot(axOriginal, app.channelXValues{channelNr}, app.channelYValues{channelNr});
            title(axOriginal, 'Original Data');
            xlabel(axOriginal,'time (s)');

            % axSPL = uiaxes(gl);
            % axSPL.Layout.Row = [4 6];
            % axSPL.Layout.Column = 3;
            axSPL = nexttile(tl,2);
            % Initial empty plot for SPL
            axSPL.Title.String = 'SPL Curve';




            linkaxes([axSPL axOriginal],'x');

            % Callback function to update SPL curve
            function updateSPLCurve(~,~)
                currYData = app.channelYValues{channelNr};
                currXData = app.channelXValues{channelNr};
                splmeterObj = splMeter('SampleRate', app.channelSampleRates(channelNr), 'TimeWeighting', dBSpeedDropdown.Value, ...
                    'FrequencyWeighting', dBtypeDropdown.Value, 'PressureReference', editField.Value, 'TimeInterval', dBoutputmetricIntervalEditField.Value);
                [A,B,C,D] = splmeterObj(currYData);
                switch dBoutputmetricDropdown.Value
                    case 1
                        newYData = A;
                    case 2
                        newYData = B;
                    case 3
                        newYData = C;
                    case 4
                        newYData = D;
                end
                % Refresh SPL curve plot
                plot(axSPL, currXData, newYData);
                title(axSPL, 'SPL Curve');
            end

            function outputMetricCallback(src,~)
                set([sploutputintervallabel dBoutputmetricIntervalEditField],'Visible',src.Value~=1);
                updateSPLCurve();
            end

            dBoutputmetricDropdown.ValueChangedFcn=@outputMetricCallback;

            % Assign callbacks to update SPL curve on value changes
            editField.ValueChangedFcn = @updateSPLCurve;
            dBtypeDropdown.ValueChangedFcn = @updateSPLCurve;
            dBSpeedDropdown.ValueChangedFcn = @updateSPLCurve;
            updateSPLCurve();  % also update SPL curve plot when metric changes
            dBoutputmetricIntervalEditField.ValueChangedFcn = @updateSPLCurve;

            % Initial plot update
            updateSPLCurve();

            xlabel(axSPL,'time (s)');
            ylabel(axSPL,'SPL')

            drawnow; pnl.Visible='on';

            function saveAndClose(~,~)
                targetValue=editField.Value;
                lastSPLreferenceValue=targetValue;
                splWeighting=dBtypeDropdown.Value;
                splSpeed=dBSpeedDropdown.Value;
                splOutputMetric=dBoutputmetricDropdown.Value;
                reportInterval=dBoutputmetricIntervalEditField.Value;
                delete(fig);
            end

            uiwait(fig);

            %% now do something with the result
            if targetValue==0
                return;
            end
            currYData=app.channelYValues{channelNr};
            currXData=app.channelXValues{channelNr};
            splmeterObj=splMeter('SampleRate',app.channelSampleRates(channelNr),'TimeWeighting',splSpeed,'FrequencyWeighting',splWeighting,"PressureReference",targetValue,'TimeInterval',reportInterval);
            [A,B,C,D]=splmeterObj(currYData);
            switch splOutputMetric
                case 1
                    newYData=A;
                case 2
                    newYData=B;
                case 3
                    newYData=C;
                case 4
                    newYData=D;
            end

            if splOutputMetric==1
                newTitle=[app.channelNames{channelNr} ' ' metricList{splOutputMetric} ' ' splWeighting ' ' splSpeed ' ref ' num2str(targetValue,'%g')];
            else
                newTitle=[app.channelNames{channelNr} ' ' metricList{splOutputMetric} ' ' splWeighting ' ' splSpeed ' ref ' num2str(targetValue,'%g') ' report interval ' num2str(reportInterval,'%g s')];
            end
            app.addSingleChannelData(newYData,currXData,newTitle,'Raw');
        end

        function openFoCalculationWindow(app, channelNr)

            waitDlg=uiprogressdlg(app.UIFigure,'Indeterminate','on','Message','Waiting for fo Tool Closing');

            windowClosedByApply=0;

            % Persistent settings
            persistent pitchMethod foMin foMax windowLength overlap capacityLevel fillMissingMethod
            if isempty(pitchMethod)
                pitchMethod = 'NCF';
                foMin = 80;
                foMax = 500;
                windowLength = 0.03;
                overlap = 0.5;
                capacityLevel = 'tiny';
                fillMissingMethod = "next";
            end

            fs = app.channelSampleRates(channelNr);
            y = app.channelYValues{channelNr};
            t = app.channelXValues{channelNr};

            %% check if crepe files are available and ask if it shall be
            %% downloaded or not
            neededFilesForCrepe={'crepefulldlnet','crepelargedlnet','crepemediumdlnet','CREPENetfull','CREPENetlarge','CREPENetmedium','CREPENetsmall','CREPENettiny','crepesmalldlnet','crepetinydlnet'};
            neededFilesForCrepe=append(neededFilesForCrepe,'.mat');
            newCrepeLicenseName='crepeLicense.txt';
            neededFilesForCrepe=[neededFilesForCrepe {newCrepeLicenseName}];


            if any(~isfile(neededFilesForCrepe))
                answer=uiconfirm(app.UIFigure,'Files for neuronal network pitch calucation not available. Download it?','CREPE files missing');

                if isequal(answer,'OK')
                    success=app.downloadCrepeIfNonExistent(app.UIFigure);
                    if success
                        crepeFilesAvailable=1;
                    else % user aborted download
                        crepeFilesAvailable=0;
                    end
                else
                    crepeFilesAvailable=0;

                end
            else
                crepeFilesAvailable=1;
            end

            %% download praat if non existent locally
            neededFilesForPraat='Praat.exe';
            if ~isfile(neededFilesForPraat)
                answer=uiconfirm(app.UIFigure,'Praat.exe not found. Donwload it?','Praat.exe missing');

                if isequal(answer,'OK')
                    success=app.downloadPraatIfNonExistent();
                    if success
                        praatAvailable=1;
                    else % user aborted download
                        praatAvailable=0;
                    end
                else
                    praatAvailable=0;

                end
            else
                praatAvailable=1;
            end

            %% gui components


            % --- Figure & GridLayout ---
            fig = uifigure('Units','pixels','Position',[0 0 900 700],'Visible','off','Name','Pitch (fo) Calculation','Theme','light','WindowStyle','alwaysontop');
            movegui(fig, 'center');
            drawnow;
            fig.Visible = 'on';
            gl = uigridlayout(fig, [16 3], 'ColumnWidth', {'1x','1x','2x'}, 'RowSpacing', 3, 'Padding', 10);

            % --- Controls ---

            % generating methods cell arrays depending on available
            % addiitonal files

            methodItems=    {'Normalized Correlation Function','Pitch Estimation Filter','Cepstrum Pitch Determination','Log-Harmonic Summation','Summation of Residual Harmonics','SWIPE''','SHR','Yin pitch detection','Bayesian F0 estimation','YAAPT pitch tracking'};
            methodItemsData={'NCF',                            'PEF',                    'CEP',                         'LHS',                   'SRH',                            'SWIPE''','SHR',                  'YIN',                  'BF0NLS',               'YAAPT'};

            if crepeFilesAvailable
                methodItems=[methodItems {'Deep neuronal network (CREPE)'}];
                methodItemsData=[methodItemsData {'CREPE'}];
            else
                % if the last chosen value was crepe but the files are not
                % available now
                if strcmpi(pitchMethod,'CREPE')
                    pitchMethod = 'NCF';
                end
            end

            if praatAvailable
                methodItems=[methodItems         {'Praat filtered ac'       ,'Praat raw cc'       ,'Praat raw ac'         ,'Praat filtered cc'         ,'Praat shs','Praat SPINET'}];
                methodItemsData=[methodItemsData {'filtered_ac','cc','ac','filtered_cc','shs',      'spinet'}];
            else
                % if the last chosen value was a praat algorithm but the files are not
                % available now
                if ismember(pitchMethod,{'filtered_autocorrelation','raw_autocorrelation','raw_cross_correlation','filtered_cross_correlation','shs',      'SPINET'})
                    pitchMethod = 'NCF';
                end
            end

            methodLabel = uilabel(gl, 'Text', 'Pitch Method', 'FontWeight', 'bold','Interpreter','tex');
            methodLabel.Layout.Row = 1; methodLabel.Layout.Column = 1;
            methodDropdown = uidropdown(gl, 'Items',methodItems,...
                'ItemsData',methodItemsData, 'Value', pitchMethod);
            methodDropdown.Layout.Row = 1; methodDropdown.Layout.Column = 2;


            capacityLabel = uilabel(gl, 'Text', 'DNN Capacity', 'FontWeight', 'bold','Interpreter','tex');
            capacityLabel.Layout.Row = 2; capacityLabel.Layout.Column = 1;
            capacityDropdown = uidropdown(gl, 'Items',{'tiny', 'small', 'medium', 'large', 'full'},...
                'Value', capacityLevel);
            capacityDropdown.Layout.Row = 2; capacityDropdown.Layout.Column = 2;
            set([capacityLabel capacityDropdown],'Tooltip','The larger, the more precise, but the longer the computation.');

            minLabel = uilabel(gl, 'Text', 'Min f_o (Hz)', 'FontWeight', 'bold','Interpreter','tex');
            minLabel.Layout.Row = 2; minLabel.Layout.Column = 1;
            minEdit = uieditfield(gl,'numeric','Value',foMin,'ValueDisplayFormat','%.1f');
            minEdit.Layout.Row = 2; minEdit.Layout.Column = 2;



            maxLabel = uilabel(gl, 'Text', 'Max f_o (Hz)', 'FontWeight', 'bold','Interpreter','tex');
            maxLabel.Layout.Row = 3; maxLabel.Layout.Column = 1;
            maxEdit = uieditfield(gl,'numeric','Value',foMax,'ValueDisplayFormat','%.1f');
            maxEdit.Layout.Row = 3; maxEdit.Layout.Column = 2;

            winLabel = uilabel(gl, 'Text', 'Window Length (s)', 'FontWeight', 'bold','Interpreter','tex');
            winLabel.Layout.Row = 4; winLabel.Layout.Column = 1;
            winEdit = uieditfield(gl,'numeric','Value',windowLength,'Limits',[0.005 0.1],'ValueDisplayFormat','%.3f');
            winEdit.Layout.Row = 4; winEdit.Layout.Column = 2;

            set([winLabel winEdit],'Tooltip','Set analysis window length in s. When using CREPE, the input is resampled to 16kHz and window length fixed to 1024 Samples -> 64 ms.');

            ovLabel = uilabel(gl, 'Text', 'Overlap (% / 100)', 'FontWeight', 'bold','Interpreter','tex');
            ovLabel.Layout.Row = 5; ovLabel.Layout.Column = 1;
            ovEdit = uieditfield(gl,'numeric','Value',overlap,'Limits',[0 0.95],'ValueDisplayFormat','%.2f');
            ovEdit.Layout.Row = 5; ovEdit.Layout.Column = 2;

            applyBtn = uibutton(gl, 'Text', 'Apply', 'FontWeight', 'bold','Interpreter','tex');
            applyBtn.Layout.Row = 16; applyBtn.Layout.Column = 2;


            %% Praat ui components

            % only (raw/filtered) autocorrelation
            praatveryAccurateLabel = uilabel(gl, 'Text', 'Very accurate', 'FontWeight', 'bold');
            praatveryAccurateLabel.Layout.Row = 8; praatveryAccurateLabel.Layout.Column = 1;
            praatveryAccurateDd = uidropdown(gl, 'Value', "on",'Items',["yes" "no"],'ItemsData',["on" "off"]);
            praatveryAccurateDd.Layout.Row = 8; praatveryAccurateDd.Layout.Column = 2;


            praatsilenceLabel = uilabel(gl, 'Text', 'Silence threshold', 'FontWeight', 'bold');
            praatsilenceLabel.Layout.Row = 9; praatsilenceLabel.Layout.Column = 1;
            praatsilenceEdit = uieditfield(gl, 'numeric', 'Value', 0.03, 'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            praatsilenceEdit.Layout.Row = 9; praatsilenceEdit.Layout.Column = 2;

            praatvoicingLabel = uilabel(gl, 'Text', 'Voicing threshold', 'FontWeight', 'bold');
            praatvoicingLabel.Layout.Row = 10; praatvoicingLabel.Layout.Column = 1;
            praatvoicingEdit = uieditfield(gl, 'numeric', 'Value', 0.45, 'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            praatvoicingEdit.Layout.Row = 10; praatvoicingEdit.Layout.Column = 2;

            praatoctaveCostLabel = uilabel(gl, 'Text', 'Octave cost', 'FontWeight', 'bold');
            praatoctaveCostLabel.Layout.Row = 11; praatoctaveCostLabel.Layout.Column = 1;
            praatoctaveCostEdit = uieditfield(gl, 'numeric', 'Value', 0.01, 'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            praatoctaveCostEdit.Layout.Row = 11; praatoctaveCostEdit.Layout.Column = 2;

            praatoctaveJumpLabel = uilabel(gl, 'Text', 'Octave-jump cost', 'FontWeight', 'bold');
            praatoctaveJumpLabel.Layout.Row = 12; praatoctaveJumpLabel.Layout.Column = 1;
            praatoctaveJumpEdit = uieditfield(gl, 'numeric', 'Value', 0.35, 'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            praatoctaveJumpEdit.Layout.Row = 12; praatoctaveJumpEdit.Layout.Column = 2;

            praatvuvCostLabel = uilabel(gl, 'Text', 'Voiced / unvoiced cost', 'FontWeight', 'bold');
            praatvuvCostLabel.Layout.Row = 13; praatvuvCostLabel.Layout.Column = 1;
            praatvuvCostEdit = uieditfield(gl, 'numeric', 'Value', 0.14, 'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            praatvuvCostEdit.Layout.Row = 13; praatvuvCostEdit.Layout.Column = 2;

            praatAttTopLabel = uilabel(gl, 'Text', 'Attenuation at top', 'FontWeight', 'bold');
            praatAttTopLabel.Layout.Row = 14; praatAttTopLabel.Layout.Column = 1;
            praatAttTopEdit = uieditfield(gl, 'numeric', 'Value', 0.03, 'Limits', [0 1], 'ValueDisplayFormat', '%.3f');
            praatAttTopEdit.Layout.Row = 14; praatAttTopEdit.Layout.Column = 2;

            praatNumPitchCandidatesLabel = uilabel(gl, 'Text', 'Max number of candidates', 'FontWeight', 'bold');
            praatNumPitchCandidatesLabel.Layout.Row = 15; praatNumPitchCandidatesLabel.Layout.Column = 1;
            praatNumPitchCandidatesEdit = uieditfield(gl, 'numeric', 'Value', 15, 'Limits', [1 30], 'ValueDisplayFormat', '%i');
            praatNumPitchCandidatesEdit.Layout.Row = 15; praatNumPitchCandidatesEdit.Layout.Column = 2;

            % only SHS
            praatshsFreqMaxLabel = uilabel(gl, 'Text', 'SHS maximum frequency (Hz)', 'FontWeight', 'bold');
            praatshsFreqMaxLabel.Layout.Row = 9; praatshsFreqMaxLabel.Layout.Column = 1;
            praatshsFreqMaxEdit = uieditfield(gl, 'numeric', 'Value', 1250, 'Limits', [1 fs/2], 'ValueDisplayFormat', '%.1f');
            praatshsFreqMaxEdit.Layout.Row = 9; praatshsFreqMaxEdit.Layout.Column = 2;

            praatshsMaxNumSubharmLabel = uilabel(gl, 'Text', 'SHS max. subharmonics', 'FontWeight', 'bold');
            praatshsMaxNumSubharmLabel.Layout.Row = 10; praatshsMaxNumSubharmLabel.Layout.Column = 1;
            praatshsMaxNumSubharmEdit = uieditfield(gl, 'numeric', 'Value', 15, 'Limits', [1 100], 'ValueDisplayFormat', '%.0f');
            praatshsMaxNumSubharmEdit.Layout.Row = 10; praatshsMaxNumSubharmEdit.Layout.Column = 2;

            praatshsCompressionLabel = uilabel(gl, 'Text', 'SHS compression factor', 'FontWeight', 'bold');
            praatshsCompressionLabel.Layout.Row = 11; praatshsCompressionLabel.Layout.Column = 1;
            praatshsCompressionEdit = uieditfield(gl, 'numeric', 'Value', 0.84, 'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            praatshsCompressionEdit.Layout.Row = 11; praatshsCompressionEdit.Layout.Column = 2;

            praatshsPointsPerOctaveLabel = uilabel(gl, 'Text', 'SHS points / octave', 'FontWeight', 'bold');
            praatshsPointsPerOctaveLabel.Layout.Row = 12; praatshsPointsPerOctaveLabel.Layout.Column = 1;
            praatshsPointsPerOctaveEdit = uieditfield(gl, 'numeric', 'Value', 48, 'Limits', [1 500], 'ValueDisplayFormat', '%.0f');
            praatshsPointsPerOctaveEdit.Layout.Row = 12; praatshsPointsPerOctaveEdit.Layout.Column = 2;


            % only SPINET

            praatspinetFBMinFreqLabel = uilabel(gl, 'Text', 'SPINET gammatone min (Hz)', 'FontWeight', 'bold');
            praatspinetFBMinFreqLabel.Layout.Row = 9; praatspinetFBMinFreqLabel.Layout.Column = 1;
            praatspinetFBMinFreqEdit = uieditfield(gl, 'numeric', 'Value', 70, 'Limits', [1 fs/2], 'ValueDisplayFormat', '%.1f');
            praatspinetFBMinFreqEdit.Layout.Row = 9; praatspinetFBMinFreqEdit.Layout.Column = 2;

            praatspinetFBMaxFreqLabel = uilabel(gl, 'Text', 'SPINET gammatone max (Hz)', 'FontWeight', 'bold');
            praatspinetFBMaxFreqLabel.Layout.Row = 10; praatspinetFBMaxFreqLabel.Layout.Column = 1;
            praatspinetFBMaxFreqEdit = uieditfield(gl, 'numeric', 'Value', 5000, 'Limits', [1 fs/2], 'ValueDisplayFormat', '%.1f');
            praatspinetFBMaxFreqEdit.Layout.Row = 10; praatspinetFBMaxFreqEdit.Layout.Column = 2;

            praatspinetFBNumFiltersLabel = uilabel(gl, 'Text', 'SPINET num. filters', 'FontWeight', 'bold');
            praatspinetFBNumFiltersLabel.Layout.Row = 11; praatspinetFBNumFiltersLabel.Layout.Column = 1;
            praatspinetFBNumFiltersEdit = uieditfield(gl, 'numeric', 'Value', 250, 'Limits', [1 1000], 'ValueDisplayFormat', '%.0f');
            praatspinetFBNumFiltersEdit.Layout.Row = 11; praatspinetFBNumFiltersEdit.Layout.Column = 2;

            praatFillMissingLabel = uilabel(gl, 'Text', 'How to fill unvoiced parts:', 'FontWeight', 'bold');
            praatFillMissingLabel.Layout.Row = 6; praatFillMissingLabel.Layout.Column = 1;
            praatFillMissingLabel.Visible = 'off';
            praatFillMissingDd = uidropdown(gl, 'Value', fillMissingMethod,'Items',["previous" "next" "nearest" "linear" "spline" "pchip" "makima","zero"]);
            praatFillMissingDd.Layout.Row = 6; praatFillMissingDd.Layout.Column = 2;
            praatFillMissingDd.Visible = 'off';


            %% grouping of the praat gui variables
            pitchSwipeSHRFunctionElements=[minLabel minEdit maxLabel maxEdit ovLabel ovEdit winLabel winEdit];
            praatRawElements=     [minLabel minEdit maxLabel maxEdit ovLabel ovEdit praatveryAccurateLabel, praatveryAccurateDd, praatsilenceLabel, praatsilenceEdit, praatvoicingLabel, praatvoicingEdit, praatoctaveCostLabel, praatoctaveCostEdit praatoctaveJumpLabel praatoctaveJumpEdit praatvuvCostLabel praatvuvCostEdit praatNumPitchCandidatesLabel praatNumPitchCandidatesEdit];
            praatFilteredElements=[minLabel minEdit maxLabel maxEdit ovLabel ovEdit praatveryAccurateLabel, praatveryAccurateDd, praatsilenceLabel, praatsilenceEdit, praatvoicingLabel, praatvoicingEdit, praatoctaveCostLabel, praatoctaveCostEdit praatoctaveJumpLabel praatoctaveJumpEdit praatvuvCostLabel praatvuvCostEdit praatAttTopLabel praatAttTopEdit praatNumPitchCandidatesLabel praatNumPitchCandidatesEdit];
            praatShsElements=     [minLabel minEdit maxLabel maxEdit ovLabel ovEdit praatNumPitchCandidatesLabel praatNumPitchCandidatesEdit praatshsFreqMaxLabel praatshsFreqMaxEdit praatshsMaxNumSubharmLabel praatshsMaxNumSubharmEdit praatshsCompressionLabel praatshsCompressionEdit praatshsPointsPerOctaveLabel praatshsPointsPerOctaveEdit];
            praatSPINETelements = [minLabel minEdit maxLabel maxEdit ovLabel ovEdit winLabel winEdit praatspinetFBMinFreqLabel praatspinetFBMinFreqEdit praatspinetFBMaxFreqLabel praatspinetFBMaxFreqEdit praatspinetFBNumFiltersLabel praatspinetFBNumFiltersEdit praatNumPitchCandidatesLabel praatNumPitchCandidatesEdit];

            %% setting initial visibility
            if ~strcmp(pitchMethod,'CREPE')
                set([capacityLabel capacityDropdown],'Visible','off');
            end
            if ~ismember(pitchMethod,{'raw_autocorrelation','raw_cross_correlation'})
                set(praatRawElements   ,'Visible','off');
            end
            if ~ismember(pitchMethod,{'filtered_autocorrelation','filtered_cross_correlation'})
                set( praatFilteredElements  ,'Visible','off');
            end
            if ~strcmpi(pitchMethod,'shs')
                set(  praatShsElements ,'Visible','off');
            end
            if ~strcmpi(pitchMethod,'SPINET')
                set(   praatSPINETelements,'Visible','off');
            end




            if strcmp(pitchMethod,'CREPE')
                set([capacityLabel capacityDropdown],'Visible','off');
                winEdit.Enable='off';
                winEdit.Value=0.064;
            else
                winEdit.Enable='on';
            end
            %%

            % --- Plots ---
            pnl = uipanel(gl, 'BorderType', 'none','Visible','off');
            pnl.Layout.Column = 3; pnl.Layout.Row = [1 16];
            tl = tiledlayout(pnl, 2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
            axOriginal = nexttile(tl, 1);
            plot(axOriginal,t,y); title(axOriginal,'Original Data'); xlabel(axOriginal,'Time (s)');
            axPitch = nexttile(tl, 2);
            title(axPitch,'Pitch (f_o) Contour','Interpreter','tex'); xlabel(axPitch,'Time (s)'); ylabel(axPitch,'Frequency (Hz)');
            linkaxes([axOriginal axPitch],'x');
            axtoolbar(tl,{'zoom' 'pan' 'restoreview' 'datacursor' 'export'});

            xlabel(axOriginal,'time (s)');

            tPitch=NaN; f0=NaN;

            % --- Helper for valid pitch ranges ---
            function [vMin,vMax] = getValidRange(method,fs,winLen)
                if winLen <= 0, winLen = 0.01; end
                switch method
                    case 'NCF'
                        vMin = fs/winLen;   vMax = fs/2;
                    case 'PEF'
                        vMin = 10;          vMax = min(4000,fs/2);
                    case 'CEP'
                        nPow = 2^nextpow2(2*round(winLen*fs)-1);
                        if nPow <= 0, nPow = 128; end
                        vMin = fs/nPow;     vMax = fs/2;
                    case {'LHS','SRH'}
                        vMin = 1;           vMax = fs/5-1;
                    otherwise
                        vMin = 10;          vMax = fs/2;
                end
                % Ensure valid numbers and order
                if ~isfinite(vMin) || ~isfinite(vMax) || isnan(vMin) || isnan(vMax) || vMin >= vMax
                    vMin = 10;
                    vMax = fs/2;
                end
            end

            function updateValidRangeAndInputs(~,~)
                method = methodDropdown.Value;
                winLen = winEdit.Value;
                [validMin, validMax] = getValidRange(method, fs, winLen);
                minEdit.Limits = [validMin, validMax];
                maxEdit.Limits = [validMin, validMax];
                if minEdit.Value < validMin, minEdit.Value = validMin; end
                if minEdit.Value > validMax, minEdit.Value = validMax; end
                if maxEdit.Value > validMax, maxEdit.Value = validMax; end
                if maxEdit.Value < validMin, maxEdit.Value = validMin; end
                if minEdit.Value >= maxEdit.Value
                    maxEdit.Value = minEdit.Value + 1;
                    if maxEdit.Value > validMax, maxEdit.Value = validMax; end
                end
                updatePitch();
            end

            function updatePitch(~,~)

                progDiag=uiprogressdlg(fig,"Indeterminate","on","Message",'Calculating pitch...');




                % calculate pitch
                method = methodDropdown.Value;


                % visibility of GUI elements
                set([capacityLabel capacityDropdown praatRawElements praatFilteredElements praatShsElements praatSPINETelements],'Visible','off');
                if strcmp(method,'CREPE')
                    %set([minEdit minLabel maxEdit maxLabel],'Visible','off');
                    set([capacityLabel capacityDropdown],'Visible','on');
                    winEdit.Enable='off';
                    winEdit.Value=0.064;
                else
                    winEdit.Enable='on';
                    if ismember(method,{'NCF','PEF','CEP','LHS','SRH','SWIPE''','SHR','YIN','BF0NLS','YAAPT'})
                        set(pitchSwipeSHRFunctionElements,'Visible','on')
                        %set([capacityLabel capacityDropdown],'Visible','off');
                    elseif ismember(method,{'ac','cc'})
                        set(praatRawElements   ,'Visible','on');
                    elseif ismember(method,{'filtered_ac','filtered_cc'})
                        set( praatFilteredElements  ,'Visible','on');
                    elseif strcmpi(method,'shs')
                        set(  praatShsElements ,'Visible','on');
                    elseif strcmpi(method,'SPINET')
                        set(   praatSPINETelements,'Visible','on');
                    end


                end


                % pitch calculation

                minFq = minEdit.Value; maxFq = maxEdit.Value;
                winLen = winEdit.Value; ovrlp = ovEdit.Value;
                winSamples = round(winLen * fs);
                overlapSamples = round(ovrlp * winSamples);
                capa=capacityDropdown.Value;
                try
                    if ismember(method,{'NCF','PEF','CEP','LHS','SRH'})
                        [f0,loc] = pitch(y,fs,'Method',method,'Range',[minFq, maxFq],'WindowLength',winSamples,'OverlapLength',overlapSamples);
                        tPitch = loc / fs;
                    elseif strcmpi(method,'SWIPE''')
                        [f0,tPitch] = PitchTracker.SWIPEP.swipep(y,fs,[minFq, maxFq],(winSamples-overlapSamples)/fs,[],[],overlapSamples/winSamples);
                    elseif strcmpi(method,'SHR')
                        [tPitch,f0] = SHRP.shrp(y,fs,[minFq, maxFq],winSamples/fs*1000,overlapSamples/fs*1000,min(fs/2, maxFq*5)); % according to Herbst we should use 5times the highest fo. https://doi.org/10.1016/j.jvoice.2019.11.005
                        tPitch=tPitch/1000;
                    elseif strcmp(method, 'YIN')
                        opts = struct('f0_min', minFq, 'f0_max', maxFq, ...
                            'frameLength_s', winLen, 'hopLength_s', (1-ovrlp)*winLen);
                        [f0, tPitch] = VibratoAnalysis.extractPitch(y, fs, 'YIN', opts);
                    elseif strcmpi(method,'CREPE')
                        [f0,tPitch]=pitchnn(y,fs,"OverlapPercentage",ovrlp*100,"ModelCapacity",capa,"ConfidenceThreshold",0);
                    elseif strcmp(method, 'BF0NLS')
                        opts = struct('f0_min', minFq, 'f0_max', maxFq, ...
                            'windowLength_s', winLen, 'overlapFrac', ovrlp);
                        [f0, tPitch] = VibratoAnalysis.extractPitch(y, fs, 'BF0NLS', opts);
                    elseif strcmp(method, 'YAAPT')
                        opts = struct('f0_min', minFq, 'f0_max', maxFq);
                        [f0, tPitch] = VibratoAnalysis.extractPitch(y, fs, 'YAAPT', opts);
                    elseif ismember(method,{'filtered_ac','ac','cc','filtered_cc','shs','spinet'})

                        % Normalize audio for SHS/SPINET (required) and good practice for all
                        yNorm = y / max(abs(y));

                        % Common parameters
                        pitchMethod = method;
                        timeStep = ovrlp / minFq;
                        pitchFloor = minFq;
                        pitchCeiling = maxFq;
                        maxCandidates = praatNumPitchCandidatesEdit.Value;

                        % Method-specific extras
                        switch lower(method)
                            case {'filtered_ac', 'filtered_cc'}
                                results = praatMEX.praatmex('pitch', yNorm, fs, ...
                                    'pitchMethod', pitchMethod, ...
                                    'timeStep', timeStep, ...
                                    'pitchFloor', pitchFloor, ...
                                    'pitchCeiling', pitchCeiling, ...
                                    'maxnCandidates', maxCandidates, ...
                                    'veryAccurate', strcmp(praatveryAccurateDd.Value, 'on'), ...
                                    'attenuationAtTop', praatAttTopEdit.Value, ...
                                    'silenceThreshold', praatsilenceEdit.Value, ...
                                    'voicingThreshold', praatvoicingEdit.Value, ...
                                    'octaveCost', praatoctaveCostEdit.Value, ...
                                    'octaveJumpCost', praatoctaveJumpEdit.Value, ...
                                    'voicedUnvoicedCost', praatvuvCostEdit.Value);

                            case {'ac', 'cc'}
                                results = praatMEX.praatmex('pitch', yNorm, fs, ...
                                    'pitchMethod', pitchMethod, ...
                                    'timeStep', timeStep, ...
                                    'pitchFloor', pitchFloor, ...
                                    'pitchCeiling', pitchCeiling, ...
                                    'maxnCandidates', maxCandidates, ...
                                    'veryAccurate', strcmp(praatveryAccurateDd.Value, 'on'), ...
                                    'silenceThreshold', praatsilenceEdit.Value, ...
                                    'voicingThreshold', praatvoicingEdit.Value, ...
                                    'octaveCost', praatoctaveCostEdit.Value, ...
                                    'octaveJumpCost', praatoctaveJumpEdit.Value, ...
                                    'voicedUnvoicedCost', praatvuvCostEdit.Value);

                            case 'shs'
                                results = praatMEX.praatmex('pitch', yNorm, fs, ...
                                    'pitchMethod', pitchMethod, ...
                                    'timeStep', timeStep, ...  % REQUIRED for SHS (>0)
                                    'pitchFloor', pitchFloor, ...
                                    'pitchCeiling', pitchCeiling, ...
                                    'maxnCandidates', maxCandidates, ...
                                    'shsHighestFrequency', praatshsFreqMaxEdit.Value, ...
                                    'shsMaxnSubharmonics', praatshsMaxNumSubharmEdit.Value, ...
                                    'shsCompressionFactor', praatshsCompressionEdit.Value, ...
                                    'shsPointsPerOctave', praatshsPointsPerOctaveEdit.Value);

                            case 'spinet'
                                results = praatMEX.praatmex('pitch', yNorm, fs, ...
                                    'pitchMethod', pitchMethod, ...
                                    'timeStep', timeStep, ...  % REQUIRED for SPINET
                                    'pitchCeiling', pitchCeiling, ...
                                    'maxnCandidates', maxCandidates, ...
                                    'spinetWindowLength', winLen, ...
                                    'spinetMinFreq', praatspinetFBMinFreqEdit.Value, ...
                                    'spinetMaxFreq', praatspinetFBMaxFreqEdit.Value, ...
                                    'spinetNumFilters', praatspinetFBNumFiltersEdit.Value);
                        end

                        % Extract results (praatMEX returns struct with freq, strength, voiced, time)
                        f0 = results.freq;
                        tPitch = results.time;

                        % Optional: strength and voiced flags available as results.strength, results.voiced




                    end
                    cla(axPitch);
                    plot(axPitch, tPitch+t(1), f0, '-');

                    hasNaN = any(isnan(f0));
                    if hasNaN
                        praatFillMissingLabel.Visible = 'on';
                        praatFillMissingDd.Visible = 'on';
                        if praatFillMissingDd.Value ~= "zero"
                            f0copy = fillmissing(f0, praatFillMissingDd.Value);
                            f0copy(~isnan(f0)) = NaN;
                            line(axPitch, tPitch+t(1), f0copy, 'Color', 'r', 'LineWidth', 1.5);
                            f0 = fillmissing(f0, praatFillMissingDd.Value);
                        else
                            f0copy = fillmissing(f0, 'constant', 0);
                            f0copy(~isnan(f0)) = NaN;
                            line(axPitch, tPitch+t(1), f0copy, 'Color', 'r', 'LineWidth', 1.5);
                            f0 = fillmissing(f0, 'constant', 0);
                        end
                    else
                        praatFillMissingLabel.Visible = 'off';
                        praatFillMissingDd.Visible = 'off';
                    end

                    ylim(axPitch, [minFq maxFq]*1.2);
                    title(axPitch, ['Pitch Contour (' method ')'],'Interpreter','none');
                catch ME
                    cla(axPitch);
                    text(0.5,0.5,['Error: ' ME.message], 'Parent',axPitch, 'HorizontalAlignment','center', 'FontSize',12);
                    disp(ME.getReport())
                end

                delete(progDiag);
            end

            methodDropdown.ValueChangedFcn  = @updateValidRangeAndInputs;
            winEdit.ValueChangedFcn         = @updateValidRangeAndInputs;
            minEdit.ValueChangedFcn         = @updateValidRangeAndInputs;
            maxEdit.ValueChangedFcn         = @updateValidRangeAndInputs;
            ovEdit.ValueChangedFcn          = @updatePitch;
            capacityDropdown.ValueChangedFcn= @updatePitch;
            praatFillMissingDd.ValueChangedFcn = @updatePitch;
            applyBtn.ButtonPushedFcn        = @(src, event) saveAndClose();

            allPraatElements=[praatSPINETelements praatShsElements praatFilteredElements praatRawElements];
            allPraatElements(allPraatElements==methodDropdown |  allPraatElements==winEdit | allPraatElements==minEdit | allPraatElements==maxEdit)=[];
            set(findall(allPraatElements,'-not','type','uilabel'),'ValueChangedFcn',@updatePitch);


            updateValidRangeAndInputs();

            ylabel(axPitch,'f_o (Hz)','Interpreter','tex');
            xlabel(axPitch,'time (s)');

            drawnow; pnl.Visible='on';

            function saveAndClose()
                pitchMethod   = methodDropdown.Value;
                foMin         = minEdit.Value;
                foMax         = maxEdit.Value;
                windowLength  = winEdit.Value;
                overlap       = ovEdit.Value;
                capacityLevel = capacityDropdown.Value;
                fillMissingMethod = praatFillMissingDd.Value;

                windowClosedByApply=1;

            end

            uiwait(fig);

            delete(waitDlg);

            if ~windowClosedByApply || foMin==0 || foMax==0, return; end

            if ismember(pitchMethod,{'NCF','PEF','CEP','LHS','SRH','SWIPE''','SHR','YIN','BF0NLS','YAAPT'})
                newTitle = [app.channelNames{channelNr} ' fo (' pitchMethod ') ' ...
                    num2str(foMin,'%.1f') ' to ' num2str(foMax,'%.1f Hz') ', Win:' num2str(windowLength,'%.3f s') ', Overlap:' num2str(overlap*windowLength,'%.2f s') ...
                    ', Fill: ' char(praatFillMissingDd.Value)];
            elseif strcmpi(pitchMethod,'CREPE')
                newTitle = [app.channelNames{channelNr} ' fo (' pitchMethod '), ' ...
                    'Model capacity: ' capacityLevel ', Win: ' num2str(windowLength,'%.3f s') ', Overlap: ' num2str(overlap,'%.2f %%') ...
                    ', Fill: ' char(praatFillMissingDd.Value)];
            elseif ismember(pitchMethod,{'ac','cc'})
                newTitle = sprintf(['%s fo (%s) %.1f to %.1f Hz, Win: %.3f s, Overlap: %.2f s, ' ...
                    'Very accurate: %s, Silence: %.2f, Voicing: %.2f, Octave cost: %.3f, ' ...
                    'Octave-jump cost: %.3f, V/UV cost: %.3f, Max candidates: %d, Fill missing: %s'], ...
                    app.channelNames{channelNr}, pitchMethod, foMin, foMax, windowLength, overlap*windowLength, ...
                    string(praatveryAccurateDd.Value), praatsilenceEdit.Value, praatvoicingEdit.Value, ...
                    praatoctaveCostEdit.Value, praatoctaveJumpEdit.Value, praatvuvCostEdit.Value, ...
                    praatNumPitchCandidatesEdit.Value, praatFillMissingDd.Value);

            elseif ismember(pitchMethod,{'filtered_ac','filtered_cc'})
                newTitle = sprintf(['%s fo (%s) %.1f to %.1f Hz, Win: %.3f s, Overlap: %.2f s, ' ...
                    'Very accurate: %s, Silence: %.2f, Voicing: %.2f, Octave cost: %.3f, ' ...
                    'Octave-jump cost: %.3f, V/UV cost: %.3f, Att. top: %.3f, Max candidates: %d, Fill missing: %s'], ...
                    app.channelNames{channelNr}, pitchMethod, foMin, foMax, windowLength, overlap*windowLength, ...
                    string(praatveryAccurateDd.Value), praatsilenceEdit.Value, praatvoicingEdit.Value, ...
                    praatoctaveCostEdit.Value, praatoctaveJumpEdit.Value, praatvuvCostEdit.Value, ...
                    praatAttTopEdit.Value, praatNumPitchCandidatesEdit.Value, praatFillMissingDd.Value);

            elseif strcmpi(pitchMethod,'shs')
                newTitle = sprintf(['%s fo (%s) %.1f to %.1f Hz, Win: %.3f s, Overlap: %.2f s, ' ...
                    'Max candidates: %d, SHS fmax: %.1f Hz, Subharmonics: %d, Compression: %.2f, Points/octave: %d, Fill missing: %s'], ...
                    app.channelNames{channelNr}, pitchMethod, foMin, foMax, windowLength, overlap*windowLength, ...
                    praatNumPitchCandidatesEdit.Value, praatshsFreqMaxEdit.Value, praatshsMaxNumSubharmEdit.Value, ...
                    praatshsCompressionEdit.Value, praatshsPointsPerOctaveEdit.Value, praatFillMissingDd.Value);

            elseif strcmpi(pitchMethod,'spinet')
                newTitle = sprintf(['%s fo (%s) %.1f to %.1f Hz, Win: %.3f s, Overlap: %.2f s, ' ...
                    'SPINET min: %.1f Hz, SPINET max: %.1f Hz, Filters: %d, Max candidates: %d, Fill missing: %s'], ...
                    app.channelNames{channelNr}, pitchMethod, foMin, foMax, windowLength, overlap*windowLength, ...
                    praatspinetFBMinFreqEdit.Value, praatspinetFBMaxFreqEdit.Value, ...
                    praatspinetFBNumFiltersEdit.Value, praatNumPitchCandidatesEdit.Value, praatFillMissingDd.Value);

            end
            delete(fig);
            app.addSingleChannelData(f0, tPitch+t(1), newTitle, 'Raw');
        end


        function openFormantEstimationWindow(app, channelNr)

            windowClosedByApply=0;

            % Persistent settings
            persistent estimationMethod foMin foMax windowLength overlap lpMethod formantsData timeData NformantsToEstimate formantLines
            if isempty(estimationMethod)
                estimationMethod = 'TVQCP';
                lpMethod = 'tvwlp_l2';
                NformantsToEstimate=3;
                foMin = 80;
                foMax = 500;
                windowLength = 0.2;
                overlap = 0.5;

                formantsData=[];
                timeData=[];
                
            end

            fs = app.channelSampleRates(channelNr);
            y = app.channelYValues{channelNr};
            t = app.channelXValues{channelNr};

            % --- Figure & GridLayout ---
            fig = uifigure('Units','pixels','Position',[0 0 900 400],'Visible','off','Name','Formant Estimation','Theme','light');
            movegui(fig, 'center');
            
            fig.Visible = 'off';
            gl = uigridlayout(fig, [9 3], 'ColumnWidth', {'1x','1x','2x'}, 'RowSpacing', 3, 'Padding', 10);

            % --- Controls ---
            methodLabel = uilabel(gl, 'Text', 'Formant Estimation Method', 'FontWeight', 'bold','Interpreter','tex');
            methodLabel.Layout.Row = 1; methodLabel.Layout.Column = 1;
            mDrop = uidropdown(gl, 'Items',{      'Time Varying Quasi Closed Phase', 'According Story & Bunton for children'},...
                'ItemsData',                       {'TVQCP','Story'}                            , 'Value', estimationMethod);
            mDrop.Layout.Row = 1; mDrop.Layout.Column = 2;

            linearPredictionTypeLabel = uilabel(gl, 'Text', 'Linear Prediction Type', 'FontWeight', 'bold','Interpreter','tex');
            linearPredictionTypeLabel.Layout.Row = 2; linearPredictionTypeLabel.Layout.Column = 1;

            % the L1 methods do not run from scratch, i did not have the
            % time and knowledge to fix them. so i allow only the L2
            % methods for now

            % linearPredictionTypeDrop = uidropdown(gl, 'Items',{'Time Varying Weighted Linear Prediction with L2 Norm','Time Varying Weighted Linear Prediction with L1 Norm','Time Varying Linear Prediction with L2 Norm','Time Varying Linear Prediction with L1 Norm'},...
            %     'ItemsData',                                  {'tvwlp_l2',                                            'tvwlp_l1',                                            'tvlp_l2',                                    'tvlp_l1'}, 'Value', lpMethod);
            
            
            linearPredictionTypeDrop = uidropdown(gl, 'Items',{'Time Varying Weighted Linear Prediction with L2 Norm','Time Varying Linear Prediction with L2 Norm'},...
                'ItemsData',                                  {'tvwlp_l2',                                             'tvlp_l2'}, 'Value', lpMethod);
            linearPredictionTypeDrop.Layout.Row = 2; linearPredictionTypeDrop.Layout.Column = 2;

            numberOfFormantsLabel = uilabel(gl, 'Text', 'Number of Formants to estimate', 'FontWeight', 'bold','Interpreter','tex','WordWrap','on');
            numberOfFormantsLabel.Layout.Row = 3; numberOfFormantsLabel.Layout.Column = 1;
            numberOfFormantsDrop = uidropdown(gl, 'Items',{'1','2','3','4','5'},...
                'ItemsData',                                  {1, 2, 3, 4, 5}, 'Value', NformantsToEstimate);
            numberOfFormantsDrop.Layout.Row = 3; numberOfFormantsDrop.Layout.Column = 2;


            minLabel = uilabel(gl, 'Text', 'Min f_o (Hz)', 'FontWeight', 'bold','Interpreter','tex');
            minLabel.Layout.Row = 4; minLabel.Layout.Column = 1;
            minEdit = uieditfield(gl,'numeric','Value',foMin,'ValueDisplayFormat','%.1f');
            minEdit.Layout.Row = 4; minEdit.Layout.Column = 2;

            maxLabel = uilabel(gl, 'Text', 'Max f_o (Hz)', 'FontWeight', 'bold','Interpreter','tex');
            maxLabel.Layout.Row = 5; maxLabel.Layout.Column = 1;
            maxEdit = uieditfield(gl,'numeric','Value',foMax,'ValueDisplayFormat','%.1f');
            maxEdit.Layout.Row = 5; maxEdit.Layout.Column = 2;

            winLabel = uilabel(gl, 'Text', 'Window Length (s)', 'FontWeight', 'bold','Interpreter','tex');
            winLabel.Layout.Row = 6; winLabel.Layout.Column = 1;
            winEdit = uieditfield(gl,'numeric','Value',windowLength,'Limits',[0.001 1],'ValueDisplayFormat','%.3f');
            winEdit.Layout.Row = 6; winEdit.Layout.Column = 2;

            ovLabel = uilabel(gl, 'Text', 'Overlap (% / 100)', 'FontWeight', 'bold','Interpreter','tex');
            ovLabel.Layout.Row = 7; ovLabel.Layout.Column = 1;
            ovEdit = uieditfield(gl,'numeric','Value',overlap,'Limits',[0 0.99],'ValueDisplayFormat','%.2f');
            ovEdit.Layout.Row = 7; ovEdit.Layout.Column = 2;

            applyBtn = uibutton(gl, 'Text', 'Apply', 'FontWeight', 'bold','Interpreter','tex');
            applyBtn.Layout.Row = 8; applyBtn.Layout.Column = 2;

            % --- Plots ---
            pnl = uipanel(gl, 'BorderType', 'none','Visible','off');
            pnl.Layout.Column = 3; pnl.Layout.Row = [1 9];
            tl = tiledlayout(pnl, 2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
            axOriginal = nexttile(tl, 1);
            plot(axOriginal,t,y); title(axOriginal,'Original Data'); xlabel(axOriginal,'Time (s)');
            axFormants = nexttile(tl, 2);
            title(axFormants,'Formants Contours','Interpreter','tex'); xlabel(axFormants,'Time (s)'); ylabel(axFormants,'Frequency (Hz)');
            linkaxes([axOriginal axFormants],'x');

           
            xlabel(axOriginal,'time (s)');

            % if the input to fCWT is too short fcwt crashes -> padding
            yPadded=[y(:).' rand(1,2048)];

            warning('off');
            if ~isfile(sprintf('n%i_t1.wis',2^nextpow2(numel(y))))
                FCWT.fCWT_create_plan(numel(yPadded),1,'measure');
            end

            
            [S,f] = FCWT.fCWT(single(yPadded(:).'),5,fs,50,floor(fs/2),30*log(floor(fs/2)/50),1);
            warning('on');
            S=S.';

            % remove the padding
            S(:,end-2048+1:end)=[];
            tspec=(0:numel(y)-1)/fs;
            imagesc(axFormants,tspec,f,20*log10(abs(S)));
            colormap(axFormants,'gray');

            drawnow;
            fig.Visible = 'on';

            function updateFormants(~,~)

                %% updating gui depending on the algorithm

                if strcmpi(mDrop.Value,{'TVQCP'})
                    set([minEdit linearPredictionTypeDrop],'Visible','on');
                    set(winEdit,'Enable','on');
                    ovEdit.Limits(1)=0;
                elseif strcmpi(mDrop.Value,{'Story'})
                    set([minEdit linearPredictionTypeDrop],'Visible','off');
                    set(winEdit,'Enable','off');
                    ovEdit.Limits(1)=1/fs; % the story algorithm crashes with 0 overlap,
                    if(fs > 40000) %% this is taken from the story code, which uses this internal method to set the window size
                        Nwind = 4096;  %Not Story and Bunton used Nwind =4410
                    else
                        Nwind = 2048;
                    end
                    winEdit.Value=Nwind/fs;
                end



                %%

                progDiag=uiprogressdlg(fig,"Indeterminate","on",'Message','Calculating...');

                estimationmethod = mDrop.Value;
                lpmethod = linearPredictionTypeDrop.Value;
                
                minFq = minEdit.Value; maxFq = maxEdit.Value;
                winLen = winEdit.Value; ovrlp = ovEdit.Value;
                winSamples = round(winLen * fs);
                overlapSamples = floor(ovrlp * winSamples);
                nFormants= numberOfFormantsDrop.Value;

                winSpec=(fs* 1/minFq)*2;
                overlSpec=floor(ovrlp * winSpec);
                try
                   
                    if strcmpi(estimationmethod,{'TVQCP'})
                        maxSpectrogramF=4000; % TVQCP resampled the signals always to 8kHz
                        [formants,~,tPitch] = FormantEstimation.TVQCP.ftrack_tvwlp(y,fs,lpmethod,winSamples,winSamples-overlapSamples,[],[],nFormants,[],[],[minFq, min(maxFq,maxSpectrogramF)],0);

                        formants=formants.';
                    elseif strcmpi(estimationmethod,{'Story'})
                        [FormantsDataStruct] = FormantEstimation.STORYnBUNTON.TrackChildFmts(y(:),fs,maxFq,[],0,nFormants,ovrlp*100);
                        maxSpectrogramF=fs/2;
                        formants=FormantsDataStruct.F;
                        tPitch=FormantsDataStruct.tm;

                        
                    end

                    % not higher than niquist
                    maxSpectrogramF=min(maxSpectrogramF,floor(fs/2));

                    if ishandle(formantLines)
                        delete(formantLines);
                    end
                    %[S,f,tspec]=spectrogram(y,winSpec,overlSpec,[],fs);

                    axFormants.ColorOrderIndex=1;
                    hold(axFormants,'on');
                    formantLines=plot(axFormants, tPitch, formants, '.');
                    hold(axFormants,'off');

                    axis(axFormants,'xy');
                    yscale(axFormants,'log');

                    formantsData=formants;
                    timeData=tPitch(:);

                    ylim(axFormants, [min(formants(:))*0.9 min(max(formants(:))*1.1,maxSpectrogramF)]);
                    title(axFormants, ['Formants Contour (' estimationmethod ')']);
                catch ME
                    delete(formantLines);
                    text(0,1,['Error: ' ME.message], 'Parent',axFormants,'Units','normalized', 'HorizontalAlignment','left', 'FontSize',8,'VerticalAlignment','top');
                    disp(ME.getReport);

                    formantsData=[];
                    timeData=[];
                end

                delete(progDiag);
            end

            mDrop.ValueChangedFcn      = @updateFormants;
            linearPredictionTypeDrop.ValueChangedFcn = @updateFormants;
            numberOfFormantsDrop.ValueChangedFcn = @updateFormants;
            winEdit.ValueChangedFcn    = @updateFormants;
            minEdit.ValueChangedFcn    = @updateFormants;
            maxEdit.ValueChangedFcn    = @updateFormants;
            ovEdit.ValueChangedFcn     = @updateFormants;
            applyBtn.ButtonPushedFcn   = @(src, event) saveAndClose();

            ylabel(axFormants,'f_o (Hz)','Interpreter','tex');
            xlabel(axFormants,'time (s)');

            updateFormants();
             disableDefaultInteractivity(axOriginal);
            disableDefaultInteractivity(axFormants);


            drawnow; pnl.Visible='on';

            % function saveAndClose()
            %     estimationMethod   = mDrop.Value;
            %     foMin         = minEdit.Value;
            %     foMax         = maxEdit.Value;
            %     windowLength  = winEdit.Value;
            %     overlap       = ovEdit.Value;
            %     lpMethod        = linearPredictionTypeDrop.Value;
            %     NformantsToEstimate=numberOfFormantsDrop.Value;
            % 
            %     windowClosedByApply=1;
            %     delete(fig);
            % end
            % 
            % uiwait(fig);
            % 
            % if ~windowClosedByApply || foMin==0 || foMax==0, return; end
            % 
            % 
            % winSamples     = round(windowLength * fs);
            % overlapSamples = round(overlap * winSamples);
            % 
            % 
            % for formantNr=1:size(formantsData,2)            
            %     newTitle = [app.channelNames{channelNr} ' Formant ' num2str(formantNr,'%i') ' of ' num2str(NformantsToEstimate,'%i') ' (' estimationMethod ') ' ...
            %         num2str(foMin,'%.1f') ' to ' num2str(foMax,'%.1f Hz') ', Win:' num2str(windowLength,'%.3f s') ', Ovl:' num2str(overlap*windowLength,'%.2f s') ', LP method: ' lpMethod];
            %     app.addSingleChannelData(formantsData(:,formantNr), timeData, newTitle, 'Raw');
            % end

               function saveAndClose()
                estimationMethod   = mDrop.Value;
                foMin         = minEdit.Value;
                foMax         = maxEdit.Value;
                windowLength  = winEdit.Value;
                overlap       = ovEdit.Value;
                lpMethod        = linearPredictionTypeDrop.Value;
                NformantsToEstimate=numberOfFormantsDrop.Value;

                windowClosedByApply=1;

                if foMin==0 || foMax==0, return; end


                winSamples     = round(windowLength * fs);
                overlapSamples = round(overlap * winSamples);

                delete(fig);
                %app.plottingPanel.Visible='off';
                for formantNr=1:size(formantsData,2)
                    if strcmpi(estimationMethod,'TVQCP')
                        newTitle = sprintf('%s Formant %i of %i (%s) %.1f to %.1f Hz, Win: %.3f s, Ovl: %.2f s, LP method: %s', ...
                                    app.channelNames{channelNr}, formantNr, NformantsToEstimate, estimationMethod, ...
                                    foMin, foMax, windowLength, overlap*windowLength, lpMethod);

                    elseif strcmpi(estimationMethod,'Story')
                        newTitle = sprintf('%s Formant %i of %i (%s) %.1f to %.1f Hz, Win: %.3f s, Ovl: %.2f s', ...
                                    app.channelNames{channelNr}, formantNr, NformantsToEstimate, estimationMethod, ...
                                    foMin, foMax, windowLength, overlap*windowLength);
                    end

                    skipStuff=formantNr~=size(formantsData,2);
                    app.addSingleChannelData(formantsData(:,formantNr), timeData, newTitle, 'Raw',skipStuff);
                end
               % app.plottingPanel.Visible='on';
               % drawnow;
              %  app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(0);
                
            end


          
        end

        function result = openOnsetAnalysisWindow(app, channelNr)
            %openOnsetAnalysisWindow  GUI for computing and comparing voice onset measures
            %
            %   result = openOnsetAnalysisWindow()                   Demo mode
            %   result = openOnsetAnalysisWindow(app, channelNr)     From Vocaliscope app
            %
            %   result       struct with fields for each method, or [] when cancelled

            %% Input handling & demo mode
            if nargin == 0
                wavFile = fullfile(fileparts(mfilename('fullpath')), 'hardOnsetEGG+Audio.wav');
                [channels, fs] = audioread(wavFile);
                channelLabels = {'EGG (ch 1)', 'Audio (ch 2)'};
                audioCh = 2;
                eggCh = 1;
                t = (0:size(channels,1)-1)' / fs;
                channelName = 'Audio (hard onset, EGG+Audio)';
            else
                % Extract from Vocaliscope app
                narginchk(2, 2);
                nCh = numel(app.channelYValues);
                if nCh == 0
                    error('No channels available in app.');
                end
                channelNr = max(1, min(channelNr, nCh));

                % Use the selected channel's time base
                t = app.channelXValues{channelNr}(:);
                fs = app.channelSampleRates(channelNr);

                % Build multi-channel matrix (resample to common time base if needed)
                channels = zeros(numel(t), nCh);
                channelLabels = cell(1, nCh);
                for c = 1:nCh
                    chT = app.channelXValues{c}(:);
                    chY = app.channelYValues{c}(:);
                    if numel(chT) == numel(t) && all(abs(chT - t) < 1e-12)
                        channels(:,c) = chY;
                    else
                        channels(:,c) = interp1(chT, chY, t, 'linear', 0);
                    end
                    channelLabels{c} = app.channelNames{c};
                end

                % Attempt channel source detection; fall back to name heuristics
                audioCh = [];
                eggCh = [];
                try
                    src = app.channelSource;
                    audioCh = find(strcmpi(src, 'Audio'), 1);
                    eggCh = find(strcmpi(src, 'EGG'), 1);
                catch
                end
                if isempty(audioCh)
                    audioCh = find(~cellfun(@isempty, regexpi(channelLabels, 'audio|mic|sp')), 1);
                end
                if isempty(audioCh)
                    audioCh = 1;
                end
                if isempty(eggCh)
                    eggCh = find(~cellfun(@isempty, regexpi(channelLabels, 'egg|lx')), 1);
                end
                if isempty(eggCh)
                    eggCh = NaN;
                end
                channelName = app.channelNames{channelNr};
            end

            % Pre-compute DC-free normalised channels
            nChannels = size(channels, 2);
            normChannels = zeros(size(channels));
            for c = 1:nChannels
                ch = channels(:, c);
                ch = ch - mean(ch);
                denom = max(abs(ch));
                if denom > 0
                    ch = ch / denom;
                end
                normChannels(:, c) = ch;
            end
            t = t(:);

            %% Load onset methods
            onsetMethods = OnsetAnalysis.onsetDescriptions();
            nMethods = numel(onsetMethods);
            methodAcrs = {onsetMethods.acronym};

            %% Persistent settings
            persistent pParams
            if isempty(pParams)
                pParams = struct();
                for i = 1:nMethods
                    m = onsetMethods(i);
                    pParams.(m.acronym) = struct();
                    pn = fieldnames(m.descriptor.params);
                    for k = 1:numel(pn)
                        pParams.(m.acronym).(pn{k}) = m.descriptor.params.(pn{k}).default;
                    end
                end
            end

            %% Result cache & source index tracker
            cachedResults = cell(nMethods, 1);
            srcIdxMap = struct();
            for i = 1:nMethods
                srcIdxMap.(methodAcrs{i}) = 1;
            end

            %% Build description HTML (collapsible sections)
            descHtmlParts = {};
            descHtmlParts{end+1} = ['<div style="overflow-y:auto; height:95%; font-family:Segoe UI; font-size:11px; padding:2px 4px;">' ...
                '<p style="margin:0 0 6px 0"><b>Method descriptions</b> (click to expand):</p>'];

            for i = 1:nMethods
                m = onsetMethods(i);
                descHtmlParts{end+1} = sprintf('<details style="margin:4px 0"><summary style="cursor:pointer; font-weight:bold">%s (%s)</summary>', ...
                    escHtml(m.name), escHtml(m.acronym));
                descHtmlParts{end+1} = sprintf('<p style="margin:4px 0 2px 0">%s</p>', escHtml(m.descriptor.summary));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0">%s</p>', escHtml(m.descriptor.details));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Required signals:</b> %s</p>', ...
                    escHtml(strjoin(m.descriptor.requiredSignals, ', ')));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Validated for:</b> %s</p>', ...
                    escHtml(m.descriptor.validatedFor));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Min sample rate:</b> %d Hz</p>', ...
                    m.descriptor.minFs_Hz);
                descHtmlParts{end+1} = '<p style="margin:6px 0 2px 0"><b>References:</b></p>';
                refs = m.sources;
                for k = 1:numel(refs)
                    doiUrl = refs(k).doi;
                    if ~startsWith(doiUrl, 'http')
                        doiUrl = ['https://doi.org/' doiUrl];
                    end
                    refText = sprintf('[%d] %s (%d) %s. %s.', ...
                        k, refs(k).authors, refs(k).year, refs(k).title, refs(k).journal);
                    descHtmlParts{end+1} = sprintf('<p style="margin:1px 0">%s<br><span style="color:#666; font-size:10px;">%s</span></p>', ...
                        escHtml(refText), escHtml(doiUrl));
                end
                descHtmlParts{end+1} = '</details>';
            end
            descHtmlParts{end+1} = '</div>';
            htmlStr = strjoin(descHtmlParts, newline);

            %% Create figure
            fig = uifigure('Units', 'pixels', 'Position', [0 0 1100 750], ...
                'Visible', 'off', 'Name', 'Onset Analysis', ...
                'Theme', 'light', 'WindowStyle', 'normal','WindowState','maximized', ...
                'CloseRequestFcn', @(s,e) uiresume(s));
            %movegui(fig, 'center');
            fig.Visible = 'on';
            cleanupObj = onCleanup(@() delete(fig));

            %% Main grid: left controls, right preview
            gl = uigridlayout(fig, [1 2], 'ColumnWidth', {380, '1x'}, ...
                'Padding', [8 8 8 8], 'RowSpacing', 5, 'ColumnSpacing', 10);

            %% -- LEFT PANEL: Controls (scrollable) + button footer --
            leftGrid = uigridlayout(gl, [2 1], 'RowHeight', {'1x', 'fit'}, ...
                'Padding', [0 0 0 0], 'RowSpacing', 0);
            leftGrid.Layout.Column = 1;

            innerGl = uigridlayout(leftGrid, [300 2], ...
                'RowHeight', repmat({'fit'}, 1, 300), ...
                'ColumnWidth', {'1x', '1x'}, ...
                'RowSpacing', 3, 'ColumnSpacing', 6, 'Padding', [5 5 5 20], ...
                'Scrollable', 'on');
            innerGl.Layout.Row = 1;

            buttonGl = uigridlayout(leftGrid, [1 3], ...
                'RowHeight', {'fit'}, ...
                'ColumnWidth', {'1x', '1x', '1x'}, ...
                'Padding', [5 5 5 5], 'RowSpacing', 3);
            buttonGl.Layout.Row = 2;

            row = 1;

            % Audio source selector
            audioChanLabel = uilabel(innerGl, 'Text', 'Audio source:', 'FontWeight', 'bold');
            audioChanLabel.Layout.Row = row; audioChanLabel.Layout.Column = [1 2]; row = row + 1;

            audioChanDd = uidropdown(innerGl, 'Items', channelLabels, ...
                'Value', channelLabels{audioCh}, ...
                'ValueChangedFcn', @(s,e) onAudioChannelChanged());
            audioChanDd.Layout.Row = row; audioChanDd.Layout.Column = [1 2]; row = row + 1;

            % EGG source selector
            eggLabel = uilabel(innerGl, 'Text', 'EGG source:', 'FontWeight', 'bold');
            eggLabel.Layout.Row = row; eggLabel.Layout.Column = [1 2]; row = row + 1;

            eggItems = [channelLabels, {'Synthetic'}];
            if isnan(eggCh)
                defaultEgg = 'Synthetic';
            else
                defaultEgg = channelLabels{eggCh};
            end
            eggDd = uidropdown(innerGl, 'Items', eggItems, ...
                'Value', defaultEgg, ...
                'ValueChangedFcn', @(s,e) onEggSourceChanged());
            eggDd.Layout.Row = row; eggDd.Layout.Column = [1 2]; row = row + 1;

            % Description
            sep1 = uilabel(innerGl, 'Text', '');
            sep1.Layout.Row = row; sep1.Layout.Column = [1 2]; row = row + 1;

            descHeader = uilabel(innerGl, 'Text', 'Method Descriptions', 'FontWeight', 'bold');
            descHeader.Layout.Row = row; descHeader.Layout.Column = [1 2]; row = row + 1;

            descHtml = uihtml(innerGl, 'HTMLSource', htmlStr);
            descHtml.Layout.Row = row; descHtml.Layout.Column = [1 2];
            descHtml_row = row; row = row + 1;

            % Spacer
            sep2 = uilabel(innerGl, 'Text', '');
            sep2.Layout.Row = row; sep2.Layout.Column = [1 2]; row = row + 1;

            %% Create per-method parameter sections
            methodParamEdits = cell(nMethods, 1);
            for i = 1:nMethods
                m = onsetMethods(i);
                pnames = fieldnames(m.descriptor.params);
                np = numel(pnames);

                % Method header label
                hdr = uilabel(innerGl, 'Text', sprintf('--- %s Parameters ---', m.name), ...
                    'FontWeight', 'bold', 'FontAngle', 'italic');
                hdr.Layout.Row = row; hdr.Layout.Column = [1 2]; row = row + 1;

                % Parameter controls
                edits = struct();
                for k = 1:np
                    p = m.descriptor.params.(pnames{k});
                    lblStr = pnames{k};
                    switch lblStr
                        case 'rmsWindow_s',        lblStr = 'RMS window (s)';
                        case 'noiseFloor_s',       lblStr = 'Noise floor (s)';
                        case 'thresholdFactor',    lblStr = 'Threshold factor';
                        case 'steadyStateFrac',    lblStr = 'Steady-state fraction';
                        case 'frameLen_s',         lblStr = 'Frame length (s)';
                        case 'frameStep_s',        lblStr = 'Frame step (s)';
                        case 'periodicityThresh',  lblStr = 'Periodicity threshold';
                        case 'minPeriod_s',        lblStr = 'Min. period (s)';
                        case 'maxPeriod_s',        lblStr = 'Max. period (s)';
                        case 'smoothWindow_s',       lblStr = 'Smooth window (s)';
                        case 'f0BandpassLowScale',  lblStr = 'Bandpass low (×F0)';
                        case 'f0BandpassHighScale', lblStr = 'Bandpass high (×F0)';
                        case 'smoothPeriods',       lblStr = 'Smoothing (pitches)';
                        case 'diffLagPeriods',      lblStr = 'Difference lag (pitches)';
                        case 'maxLag_s',            lblStr = 'Max lag (s)';
                        case 'fomThreshold',        lblStr = 'Figure of Merit threshold';
                        case 'bpLowScale',          lblStr = 'Bandpass low (×F0)';
                        case 'bpHighScale',         lblStr = 'Bandpass high (×F0)';
                        case 'maxWindow_s',         lblStr = 'Max. window (s)';
                    end
                    lbl = uilabel(innerGl, 'Text', lblStr, ...
                        'Tooltip', p.tooltip);
                    lbl.Layout.Row = row; lbl.Layout.Column = 1;

                    val = p.default;
                    if isfield(pParams, m.acronym) && isfield(pParams.(m.acronym), pnames{k})
                        val = pParams.(m.acronym).(pnames{k});
                    end
                    ed = uieditfield(innerGl, 'numeric', 'Value', val, ...
                        'Limits', p.limits, 'ToolTip', p.tooltip, ...
                        'ValueChangedFcn', @(s,e) onParamChanged(s, m.acronym));
                    ed.Layout.Row = row; ed.Layout.Column = 2;
                    ed.UserData = struct('method', m.acronym, 'param', pnames{k});
                    edits.(pnames{k}) = ed;
                    row = row + 1;
                end
                methodParamEdits{i} = edits;

                % Spacer after section
                sp = uilabel(innerGl, 'Text', '');
                sp.Layout.Row = row; sp.Layout.Column = [1 2]; row = row + 1;
            end

            % Set description area row height to fixed 200px
            innerGl.RowHeight{descHtml_row} = 130;

            %% -- Right panel: Preview + Table --
            rightPnl = uipanel(gl, 'Title', 'Preview & Results', 'FontWeight', 'bold', ...
                'BorderType', 'none');
            rightPnl.Layout.Column = 2;

            rightGrid = uigridlayout(rightPnl, [4 1], ...
                'RowHeight', {'1x', '1x', 'fit', '1.5x'}, ...
                'Padding', [5 5 5 5], 'RowSpacing', 5);

            % Panel wrapping a single tiledlayout for both axes (aligned)
            axisPanel = uipanel(rightGrid, 'BorderType', 'none');
            axisPanel.Layout.Row = [1 2];

            onsetTL = tiledlayout(axisPanel, 2, 1, 'TileSpacing', 'compact');

            % Axis 1: waveform + markers (Tile 1)
            ax1 = nexttile(onsetTL);
            title(ax1, 'Waveform + Onset Markers', 'Interpreter', 'none');
            xlabel(ax1, 'Time (s)'); ylabel(ax1, 'Amplitude');
            hold(ax1, 'on');

            % Axis 2: intermediate results (Tile 2)
            ax2 = nexttile(onsetTL);
            title(ax2, 'Intermediate Results', 'Interpreter', 'none');
            xlabel(ax2, 'Time (s)'); ylabel(ax2, 'Value');
            hold(ax2, 'on');
            ax2.Visible = 'off';

            % Link x-axes for synchronized zoom/pan
            linkaxes([ax1, ax2], 'x');

            % Dummy legend handles — created fresh in update functions
            lgd1 = gobjects(0);
            lgd2 = gobjects(0);

            % Intermediates selector bar (below the axes)
            interGrid = uigridlayout(rightGrid, [2 3], ...
                'ColumnWidth', {'1x', '1x', '1x'}, 'RowHeight', {'fit', 'fit'}, ...
                'Padding', [0 0 0 0], 'RowSpacing', 2);
            interGrid.Layout.Row = 3;

            interLabel = uilabel(interGrid, 'Text', 'Show intermediates:');
            interLabel.Layout.Row = 1; interLabel.Layout.Column = 1;

            interDd = uidropdown(interGrid, 'Items', {onsetMethods.name}, ...
                'ItemsData', methodAcrs, ...
                'Value', methodAcrs{1}, ...
                'ValueChangedFcn', @(s,e) onIntermediatesChange());
            interDd.Layout.Row = 1; interDd.Layout.Column = [2 3];

            instanceLabel = uilabel(interGrid, 'Text', 'Instance:', 'Visible', 'off');
            instanceLabel.Layout.Row = 2; instanceLabel.Layout.Column = 1;

            instanceDd = uidropdown(interGrid, 'Items', {''}, 'Visible', 'off', ...
                'ValueChangedFcn', @(s,e) onInstanceChanged());
            instanceDd.Layout.Row = 2; instanceDd.Layout.Column = [2 3];

            % Results table
            colNames = {'#', 'Method', 'Acronym', 'Source', 'Status', 'Onset Start (s)', 'Result (s)', 'Details'};
            colWidths = {30, 230, 70, 120, 65, 110, 90, 'auto'};

            resultsTable = uitable(rightGrid, 'Data', cell(0, 8), ...
                'ColumnName', colNames, 'ColumnWidth', colWidths, ...
                'RowName', [], 'ColumnEditable', false);
            resultsTable.Layout.Row = 4;

            %% -- Buttons (Cancel, Export) --
            exportBtn = uibutton(buttonGl, 'Text', 'Export...', ...
                'ButtonPushedFcn', @(s,e) onExport());
            exportBtn.Layout.Row = 1; exportBtn.Layout.Column = 1;

            cancelBtn = uibutton(buttonGl, 'Text', 'Cancel', ...
                'ButtonPushedFcn', @(s,e) onCancel());
            cancelBtn.Layout.Row = 1; cancelBtn.Layout.Column = 3;

            %% --- Helper: get parameter values for a method ---
            function params = getMethodParams(mAcr)
                mi = find(strcmp(methodAcrs, mAcr), 1);
                if isempty(mi)
                    params = struct();
                    return;
                end
                edits = methodParamEdits{mi};
                pnames = fieldnames(edits);
                params = struct();
                for k = 1:numel(pnames)
                    params.(pnames{k}) = edits.(pnames{k}).Value;
                end
            end

            %% --- Get active (selected source) result for a method ---
            function res = getActiveResult(mi)
                if isempty(cachedResults{mi})
                    res = [];
                    return;
                end
                n = numel(cachedResults{mi});
                if n <= 1
                    res = cachedResults{mi};
                else
                    sel = interDd.Value;
                    idx = min(srcIdxMap.(sel), n);
                    res = cachedResults{mi}(idx);
                end
            end

            %% --- Compute one method ---
            function computeMethod(mAcr)
                mi = find(strcmp(methodAcrs, mAcr), 1);
                if isempty(mi), return; end

                params = getMethodParams(mAcr);

                try
                    switch mAcr
                        case 'VRT'
                            results = [];
                            for c = 1:nChannels
                                r = OnsetAnalysis.VRT.compute(normChannels(:,c), fs, params);
                                r.sourceLabel = channelLabels{c};
                                r.sourceIdx = c;
                                results = [results; r]; %#ok<AGROW>
                            end
                            cachedResults{mi} = results;

                        case 'POT_M'
                            results = [];
                            for c = 1:nChannels
                                r = OnsetAnalysis.POTMergell.compute(normChannels(:,c), fs, params);
                                r.sourceLabel = channelLabels{c};
                                r.sourceIdx = c;
                                results = [results; r]; %#ok<AGROW>
                            end
                            cachedResults{mi} = results;

                        case 'POT_P'
                            results = [];
                            for c = 1:nChannels
                                r = OnsetAnalysis.POTPetermann.compute(normChannels(:,c), fs, params);
                                r.sourceLabel = channelLabels{c};
                                r.sourceIdx = c;
                                results = [results; r]; %#ok<AGROW>
                            end
                            cachedResults{mi} = results;

                        case 'VAT'
                            audio = normChannels(:, audioCh);
                            if ~isnan(eggCh)
                                egg = normChannels(:, eggCh);
                                res = OnsetAnalysis.VAT.compute(audio, fs, params, egg);
                            else
                                res = OnsetAnalysis.VAT.compute(audio, fs, params);
                            end
                            if isnan(eggCh)
                                res.sourceLabel = channelLabels{audioCh};
                            else
                                res.sourceLabel = sprintf('%s %s %s', ...
                                    channelLabels{eggCh}, char(8594), channelLabels{audioCh});
                            end
                            res.sourceIdx = 1;
                            cachedResults{mi} = res;

                        otherwise
                            cachedResults{mi} = struct('success', false);
                    end
                catch ME
                    cachedResults{mi} = struct('success', false, 'error', ME.message);
                end
            end

            %% --- Compute all methods (on open) ---
            function computeAll()
                for i = 1:nMethods
                    computeMethod(methodAcrs{i});
                end
            end

            %% --- Rebuild results table ---
            function rebuildTable()
                rows = {};
                rowNum = 0;
                for mi = 1:nMethods
                    m = onsetMethods(mi);
                    resArray = cachedResults{mi};
                    if isempty(resArray)
                        rowNum = rowNum + 1;
                        rows{rowNum, 1} = rowNum; %#ok<AGROW>
                        rows{rowNum, 2} = m.name;
                        rows{rowNum, 3} = m.acronym;
                        rows{rowNum, 4} = '';
                        rows{rowNum, 5} = '';
                        rows{rowNum, 6} = '';
                        rows{rowNum, 7} = '';
                        rows{rowNum, 8} = '';
                        continue;
                    end
                    nInst = numel(resArray);
                    for k = 1:nInst
                        res = resArray(min(k, numel(resArray)));
                        rowNum = rowNum + 1;
                        rows{rowNum, 1} = rowNum; %#ok<AGROW>
                        rows{rowNum, 2} = m.name;
                        rows{rowNum, 3} = m.acronym;
                        rows{rowNum, 4} = res.sourceLabel;
                        if isfield(res, 'success') && res.success
                            rows{rowNum, 5} = 'OK';
                            switch m.acronym
                                case 'VRT'
                                    rows{rowNum, 6} = sprintf('%.4f', res.onsetTime_s);
                                    rows{rowNum, 7} = sprintf('%.4f', res.vrt_s);
                                    rows{rowNum, 8} = sprintf('VRT = %.4f s (ssAmp = %.3f, thresh = %.2e)', ...
                                        res.vrt_s, res.steadyStateAmp, res.threshold);
                                case 'POT_M'
                                    rows{rowNum, 6} = sprintf('%.4f', res.onsetTime_32pct_s);
                                    rows{rowNum, 7} = sprintf('%.4f', res.pot_s);
                                    rows{rowNum, 8} = sprintf('r0 = %.3e, rf = %.3e, a = %.1f', ...
                                        res.r0, res.rf, res.a);
                                case 'POT_P'
                                    rows{rowNum, 6} = sprintf('%.4f', res.onsetTime_32pct_s);
                                    rows{rowNum, 7} = sprintf('%.4f', res.pot_s);
                                    rows{rowNum, 8} = sprintf('F0 = %.1f Hz, r0 = %.3e, rf = %.3e, a = %.1f', ...
                                        res.f0_Hz, res.r0, res.rf, res.a);
                                case 'VAT'
                                    rows{rowNum, 6} = sprintf('%.4f', res.onsetTime_s);
                                    rows{rowNum, 7} = sprintf('%.4f', res.vat_s);
                                    rows{rowNum, 8} = sprintf('VAT = %.4f s (FOM = %.3f)', ...
                                        res.vat_s, res.fom);
                            end
                        elseif isfield(res, 'success') && ~res.success
                            rows{rowNum, 5} = 'FAIL';
                            rows{rowNum, 6} = '';
                            rows{rowNum, 7} = '';
                            rows{rowNum, 8} = '';
                        else
                            rows{rowNum, 5} = 'ERR';
                            rows{rowNum, 6} = '';
                            rows{rowNum, 7} = '';
                            rows{rowNum, 8} = res.error;
                        end
                    end
                end
                if isempty(rows)
                    resultsTable.Data = cell(0, 8);
                else
                    resultsTable.Data = rows;
                end
            end

            %% --- Update instance dropdown ---
            function updateInstanceDropdown()
                sel = interDd.Value;
                mi = find(strcmp(methodAcrs, sel), 1);
                if isempty(mi) || isempty(cachedResults{mi})
                    instanceLabel.Visible = 'off';
                    instanceDd.Visible = 'off';
                    return;
                end
                n = numel(cachedResults{mi});
                if n > 1
                    items = cell(n, 1);
                    for k = 1:n
                        items{k} = cachedResults{mi}(k).sourceLabel;
                    end
                    instanceDd.Items = items;
                    sidx = min(srcIdxMap.(sel), n);
                    srcIdxMap.(sel) = sidx;
                    instanceDd.Value = items{sidx};
                    instanceLabel.Visible = 'on';
                    instanceDd.Visible = 'on';
                else
                    instanceLabel.Visible = 'off';
                    instanceDd.Visible = 'off';
                end
            end

            %% --- Update axis 1 (waveform + selected method markers) ---
            function updateWaveformAxis()
                sel = interDd.Value;
                mi = find(strcmp(methodAcrs, sel), 1);

                res = getActiveResult(mi);

                % Determine which channel waveform to show
                if isempty(res) || ~isfield(res, 'success') || ~res.success
                    yPlot = normChannels(:, audioCh);
                elseif numel(cachedResults{mi}) > 1
                    yPlot = normChannels(:, res.sourceIdx);
                else
                    yPlot = normChannels(:, audioCh);
                end

                cla(ax1); hold(ax1, 'on');

                plotRaw = ~strcmp(sel, 'POT_P');
                if plotRaw
                    hWave = plot(ax1, t, yPlot, 'k-', 'LineWidth', 0.5);
                    hWave.Annotation.LegendInformation.IconDisplayStyle = 'off';
                end
                xlim(ax1, [t(1), t(end)]);
                ylabel(ax1, 'Amplitude');

                if isempty(res) || ~isfield(res, 'success') || ~res.success
                    if ~isempty(lgd1) && isvalid(lgd1)
                        lgd1.Visible = 'off';
                    end
                    return;
                end

                colors = lines(nMethods);
                plotHandles = gobjects(0);
                plotLabels = {};

                switch sel
                    case 'VRT'
                        idxOnset = res.onsetIdx;
                        idxEnd = res.endIdx;
                        yl = ylim(ax1);
                        if isfield(res, 'steadyStartIdx') && isfield(res, 'steadyEndIdx') ...
                                && ~isempty(res.steadyStartIdx) && ~isempty(res.steadyEndIdx) ...
                                && res.steadyEndIdx > res.steadyStartIdx
                            patch(ax1, t([res.steadyStartIdx, res.steadyStartIdx, ...
                                res.steadyEndIdx, res.steadyEndIdx]), ...
                                [yl(1) yl(2) yl(2) yl(1)], ...
                                [0.8 0.95 0.8], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
                        end
                        if ~isempty(idxOnset)
                            h = plot(ax1, t(idxOnset)*[1 1], ylim(ax1), '--', ...
                                'Color', colors(mi,:), 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset';
                        end
                        if ~isempty(idxEnd) && (isempty(idxOnset) || idxEnd ~= idxOnset)
                            h = plot(ax1, t(idxEnd)*[1 1], ylim(ax1), ':', ...
                                'Color', colors(mi,:), 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'VRT end';
                        end
                        if isfield(res, 'vad') && ~isempty(res.vad)
                            v = res.vad;
                            if any(v)
                                d = diff([0; v; 0]);
                                starts = find(d == 1);
                                ends = find(d == -1) - 1;
                                for k = 1:numel(starts)
                                    patch(ax1, t([starts(k), starts(k), ends(k), ends(k)]), ...
                                        [yl(1) yl(2) yl(2) yl(1)], ...
                                        colors(mi,:), 'FaceAlpha', 0.08, 'EdgeColor', 'none');
                                end
                            end
                        end

                    case 'POT_M'
                        yl = ylim(ax1);
                        if ~isempty(res.onsetIdx) && ~isempty(res.steadyIdx) ...
                                && res.steadyIdx > res.onsetIdx
                            patch(ax1, t([res.onsetIdx, res.onsetIdx, res.steadyIdx, res.steadyIdx]), ...
                                [yl(1) yl(2) yl(2) yl(1)], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
                        end
                        if ~isempty(res.onsetIdx)
                            h = xline(ax1, t(res.onsetIdx), 'b--', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset start';
                        end
                        if ~isempty(res.steadyIdx)
                            h = xline(ax1, t(res.steadyIdx), 'b:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Steady-state';
                        end
                        env = res.envelope;
                        if ~isempty(env)
                            h = plot(ax1, t, env, 'b-', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Envelope';
                        end
                        fitC = res.fitCurve;
                        if ~isempty(fitC)
                            h = plot(ax1, t, fitC, 'r-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Growth fit';
                        end
                        if ~isempty(res.idx32) && ~isempty(res.idx67) && res.idx67 > res.idx32
                            patch(ax1, t([res.idx32, res.idx32, res.idx67, res.idx67]), ...
                                [yl(1) yl(2) yl(2) yl(1)], ...
                                [0.8 0.9 0.8], 'FaceAlpha', 0.25, 'EdgeColor', 'none');
                        end
                        if ~isempty(res.idx32) && res.idx32 > 0 && res.idx32 <= numel(t)
                            h = xline(ax1, res.onsetTime_32pct_s, 'm--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (32.2%)';
                        end
                        if ~isempty(res.idx67) && res.idx67 > 0 && res.idx67 <= numel(t) ...
                                && (~isempty(res.idx32) || res.idx67 ~= res.idx32)
                            h = xline(ax1, res.onsetTime_67pct_s, 'g--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (67.8%)';
                        end
                        h = yline(ax2, res.r0, 'c:', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = 'r0';
                        h = yline(ax2, res.rf, 'k:', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = 'rf';
                        r32 = res.r0 + 0.322 * (res.rf - res.r0);
                        r67 = res.r0 + 0.678 * (res.rf - res.r0);
                        h = yline(ax2, r32, 'm--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '32.2% level';
                        h = yline(ax2, r67, 'g--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '67.8% level';
                        h = yline(ax1, res.r0, 'c:', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = 'r0';
                        h = yline(ax1, res.rf, 'k:', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = 'rf';

                    case 'POT_P'
                        yl = ylim(ax1);
                        % BP-filtered signal as main trace (visible blue)
                        if isfield(res, 'bpFilt') && ~isempty(res.bpFilt)
                            h = plot(ax1, t, res.bpFilt, 'Color', [0.3 0.5 0.9], 'LineWidth', 0.8);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
                        end
                        % Onset/steady patch
                        if ~isempty(res.onsetIdx) && ~isempty(res.steadyIdx) ...
                                && res.steadyIdx > res.onsetIdx
                            patch(ax1, t([res.onsetIdx, res.onsetIdx, res.steadyIdx, res.steadyIdx]), ...
                                [yl(1) yl(2) yl(2) yl(1)], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
                        end
                        % Growth fit curve (continuous, from fitFine)
                        if isfield(res, 'fitFineTimes') && ~isempty(res.fitFineTimes)
                            h = plot(ax1, res.fitFineTimes, res.fitFine, 'r-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Growth fit';
                        end
                        % Crop peaks (light open circles)
                        if isfield(res, 'cropPeakTimes') && ~isempty(res.cropPeakTimes)
                            h = plot(ax1, res.cropPeakTimes, res.cropPeakAmps, 'o', ...
                                'Color', [0.4 0.4 0.4], 'MarkerSize', 4, 'LineWidth', 0.6);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Crop peaks';
                        end
                        % 32.2% / 67.8% crossings
                        if ~isempty(res.onsetIdx) && ~isempty(res.steadyIdx)
                            if ~isempty(res.idx32) && res.idx32 > 0 && res.idx32 <= numel(t)
                                h = xline(ax1, res.onsetTime_32pct_s, 'm--', 'LineWidth', 1.5);
                                h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                                plotHandles(end+1) = h;
                                plotLabels{end+1} = 't (32.2%)';
                            end
                            if ~isempty(res.idx67) && res.idx67 > 0 && res.idx67 <= numel(t) ...
                                    && (~isempty(res.idx32) || res.idx67 ~= res.idx32)
                                h = xline(ax1, res.onsetTime_67pct_s, 'g--', 'LineWidth', 1.5);
                                h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                                plotHandles(end+1) = h;
                                plotLabels{end+1} = 't (67.8%)';
                            end
                        end
                        % F0 annotation
                        if isfield(res, 'f0_Hz') && ~isempty(res.f0_Hz) && ~isnan(res.f0_Hz)
                            yl = ylim(ax1);
                            text(ax1, res.peakTimes(1), yl(2) - 0.05 * (yl(2) - yl(1)), ...
                                sprintf('F_0 = %.1f Hz', res.f0_Hz), ...
                                'FontSize', 9, 'Color', [0.5 0.2 0.2], 'FontWeight', 'bold');
                        end

                    case 'VAT'
                        yl = ylim(ax1);
                        if ~isempty(res.windowStartIdx) && ~isempty(res.windowEndIdx) ...
                                && res.windowEndIdx > res.windowStartIdx
                            patch(ax1, t([res.windowStartIdx, res.windowStartIdx, ...
                                res.windowEndIdx, res.windowEndIdx]), ...
                                [yl(1) yl(2) yl(2) yl(1)], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
                        end
                        if isfield(res, 'eggSignal') && ~isempty(res.eggSignal)
                            eggScaled = res.eggSignal * (max(abs(yPlot)) / (max(abs(res.eggSignal)) + eps));
                            h = plot(ax1, t, eggScaled, 'r-', 'LineWidth', 0.7);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            if strcmp(eggDd.Value, 'Synthetic')
                                plotLabels{end+1} = 'EGG (synthetic)';
                            else
                                plotLabels{end+1} = 'EGG (real)';
                            end
                        end
                        if ~isempty(res.onsetIdx)
                            h = xline(ax1, t(res.onsetIdx), 'b--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset';
                        end
                        if ~isempty(res.onsetIdx) && ~isnan(res.vat_s)
                            eggLagTime = t(res.onsetIdx) + res.vat_s;
                            h = xline(ax1, eggLagTime, 'r:', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'EGG lag';
                        end
                end

                % Refresh northern legend
                if ~isempty(lgd1) && isvalid(lgd1)
                    delete(lgd1);
                end
                if ~isempty(plotHandles)
                    lgd1 = legend(ax1, plotHandles, plotLabels);
                    lgd1.Layout.Tile = 'north';
                    lgd1.Orientation = 'horizontal';
                    lgd1.Box = 'off';
                else
                    lgd1 = gobjects(0);
                end
            end

            %% --- Update axis 2 (intermediates) ---
            function updateIntermediatesAxis()
                sel = interDd.Value;

                cla(ax2); hold(ax2, 'on');
                xlim(ax2, 'auto'); ylim(ax2, 'auto');

                ax2.Visible = 'on';
                xlabel(ax2, 'Time (s)');
                ylabel(ax2, 'Value');

                mi = find(strcmp(methodAcrs, sel), 1);
                if isempty(mi), return; end

                title(ax2, sprintf('Intermediate Results: %s', onsetMethods(mi).name), ...
                    'Interpreter', 'none');
                res = getActiveResult(mi);
                if isempty(res) || ~isfield(res, 'success') || ~res.success
                    if ~isempty(lgd2) && isvalid(lgd2)
                        lgd2.Visible = 'off';
                    end
                    text(ax2, 0.5, 0.5, 'No data available', ...
                        'Units', 'normalized', 'HorizontalAlignment', 'center');
                    return;
                end

                params = getMethodParams(sel);
                plotHandles = gobjects(0);
                plotLabels = {};

                switch sel
                    case 'VRT'
                        vMin = 0; vMax = 1;
                        if isfield(res, 'rmsEnvelope') && ~isempty(res.rmsEnvelope)
                            vMin = min(res.rmsEnvelope);
                            vMax = max(res.rmsEnvelope);
                        end
                        if isfield(res, 'rmsEnvelope') && ~isempty(res.rmsEnvelope)
                            h = plot(ax2, t, res.rmsEnvelope, 'b-', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'RMS envelope';
                        end
                        if isfield(res, 'threshold')
                            h = yline(ax2, res.threshold, 'r--', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Threshold';
                        end
                        if isfield(res, 'steadyStateAmp')
                            h = yline(ax2, res.steadyStateAmp * params.steadyStateFrac, ...
                                'g:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Target level';
                        end
                        if isfield(res, 'steadyStartIdx') && isfield(res, 'steadyEndIdx') ...
                                && ~isempty(res.steadyStartIdx) && ~isempty(res.steadyEndIdx) ...
                                && res.steadyEndIdx > res.steadyStartIdx
                            patch(ax2, t([res.steadyStartIdx, res.steadyStartIdx, ...
                                res.steadyEndIdx, res.steadyEndIdx]), ...
                                [vMin vMax vMax vMin], ...
                                [0.8 0.95 0.8], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
                        end
                        if ~isempty(res.onsetIdx)
                            h = plot(ax2, t(res.onsetIdx)*[1 1], [vMin vMax], ...
                                'g--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset';
                        end
                        if ~isempty(res.endIdx) && res.endIdx ~= res.onsetIdx
                            h = plot(ax2, t(res.endIdx)*[1 1], [vMin vMax], ...
                                'c--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'VRT endpoint';
                        end

                    case 'POT_M'
                        vMin = 0; vMax = 1;
                        if ~isempty(res.envelope)
                            vMin = min(res.envelope);
                            vMax = max(res.envelope);
                        end
                        if ~isempty(res.envelope)
                            h = plot(ax2, t, res.envelope, 'b-', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Smoothed envelope';
                        end
                        if ~isempty(res.fitCurve)
                            h = plot(ax2, t, res.fitCurve, 'r-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Growth fit';
                        end
                        if ~isempty(res.onsetIdx) && ~isempty(res.steadyIdx) ...
                                && res.steadyIdx > res.onsetIdx
                            patch(ax2, t([res.onsetIdx, res.onsetIdx, res.steadyIdx, res.steadyIdx]), ...
                                [vMin vMax vMax vMin], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
                        end
                        if ~isempty(res.onsetIdx)
                            h = plot(ax2, t(res.onsetIdx)*[1 1], [vMin vMax], ...
                                'b--', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset start';
                        end
                        if ~isempty(res.steadyIdx)
                            h = plot(ax2, t(res.steadyIdx)*[1 1], [vMin vMax], ...
                                'b:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Steady-state';
                        end
                        if ~isempty(res.envPeaks)
                            h = plot(ax2, res.envPeakTimes, res.envPeaks, 'ko', ...
                                'MarkerSize', 3, 'LineWidth', 0.5, 'MarkerFaceColor', 'k');
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Envelope peaks';
                        end
                        r32 = res.r0 + 0.322 * (res.rf - res.r0);
                        r67 = res.r0 + 0.678 * (res.rf - res.r0);
                        h = yline(ax2, r32, 'm--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '32.2% level';
                        h = yline(ax2, r67, 'g--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '67.8% level';
                        if ~isempty(res.idx32) && res.idx32 > 0
                            h = plot(ax2, res.onsetTime_32pct_s*[1 1], [vMin vMax], ...
                                'm:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (32.2%)';
                        end
                        if ~isempty(res.idx67) && res.idx67 > 0
                            h = plot(ax2, res.onsetTime_67pct_s*[1 1], [vMin vMax], ...
                                'g:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (67.8%)';
                        end

                    case 'POT_P'
                        vMin = 0; vMax = 1;
                        if isfield(res, 'bpFilt') && ~isempty(res.bpFilt)
                            vMin = min([vMin; res.bpFilt]);
                            vMax = max([vMax; res.bpFilt]);
                        end
                        % Fine fit curve (interpolated, continuous)
                        if isfield(res, 'fitFine') && ~isempty(res.fitFine)
                            h = plot(ax2, res.fitFineTimes, res.fitFine, 'r-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Growth fit';
                        end
                        % Crop peaks as scatter (light open circles)
                        if isfield(res, 'cropPeakTimes') && ~isempty(res.cropPeakTimes)
                            h = plot(ax2, res.cropPeakTimes, res.cropPeakAmps, 'o', ...
                                'Color', [0.4 0.4 0.4], 'MarkerSize', 4, 'LineWidth', 0.6);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Crop peaks';
                        end
                        if isfield(res, 'peakTimes') && ~isempty(res.peakTimes)
                            % Draw all peaks (faded) as context
                            isCrop = false(size(res.peakTimes));
                            if isfield(res, 'cropPeakTimes') && ~isempty(res.cropPeakTimes)
                                for k = 1:numel(res.peakTimes)
                                    if any(abs(res.peakTimes(k) - res.cropPeakTimes) < 1/fs)
                                        isCrop(k) = true;
                                    end
                                end
                            end
                            nonCrop = ~isCrop;
                            if any(nonCrop)
                                h = plot(ax2, res.peakTimes(nonCrop), res.peakAmps(nonCrop), 'o', ...
                                    'Color', [0.6 0.6 0.6], 'MarkerSize', 3, 'LineWidth', 0.5, ...
                                    'MarkerFaceColor', [0.8 0.8 0.8]);
                                h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                                plotHandles(end+1) = h;
                                plotLabels{end+1} = 'Other peaks';
                            end
                        end
                        if isfield(res, 'bpFilt') && ~isempty(res.bpFilt)
                            h = plot(ax2, t, res.bpFilt, 'Color', [0.3 0.5 0.9], 'LineWidth', 0.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'BP filtered';
                        end
                        if ~isempty(res.onsetIdx) && ~isempty(res.steadyIdx) ...
                                && res.steadyIdx > res.onsetIdx
                            patch(ax2, t([res.onsetIdx, res.onsetIdx, res.steadyIdx, res.steadyIdx]), ...
                                [vMin vMax vMax vMin], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
                        end
                        if ~isempty(res.onsetIdx)
                            h = plot(ax2, t(res.onsetIdx)*[1 1], [vMin vMax], ...
                                'b--', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset start';
                        end
                        if ~isempty(res.steadyIdx)
                            h = plot(ax2, t(res.steadyIdx)*[1 1], [vMin vMax], ...
                                'b:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Steady-state';
                        end
                        r32 = res.r0 + 0.322 * (res.rf - res.r0);
                        r67 = res.r0 + 0.678 * (res.rf - res.r0);
                        h = yline(ax2, r32, 'm--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '32.2% level';
                        h = yline(ax2, r67, 'g--', 'LineWidth', 1);
                        h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                        plotHandles(end+1) = h;
                        plotLabels{end+1} = '67.8% level';
                        if isfield(res, 'onsetTime_32pct_s') && ~isempty(res.onsetTime_32pct_s) ...
                                && ~isnan(res.onsetTime_32pct_s)
                            h = plot(ax2, res.onsetTime_32pct_s*[1 1], [vMin vMax], ...
                                'm:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (32.2%)';
                        end
                        if isfield(res, 'onsetTime_67pct_s') && ~isempty(res.onsetTime_67pct_s) ...
                                && ~isnan(res.onsetTime_67pct_s)
                            h = plot(ax2, res.onsetTime_67pct_s*[1 1], [vMin vMax], ...
                                'g:', 'LineWidth', 1);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 't (67.8%)';
                        end

                    case 'VAT'
                        yMin = 0; yMax = 1;
                        if isfield(res, 'audioFilt') && ~isempty(res.audioFilt)
                            yMin = min([yMin; res.audioFilt; res.eggFilt]);
                            yMax = max([yMax; res.audioFilt; res.eggFilt]);
                        end
                        if isfield(res, 'audioEnvelope') && ~isempty(res.audioEnvelope)
                            yMin = min([yMin; res.audioEnvelope; res.eggEnvelope]);
                            yMax = max([yMax; res.audioEnvelope; res.eggEnvelope]);
                        end
                        if ~isempty(res.windowStartIdx) && ~isempty(res.windowEndIdx) ...
                                && res.windowEndIdx > res.windowStartIdx
                            patch(ax2, t([res.windowStartIdx, res.windowStartIdx, ...
                                res.windowEndIdx, res.windowEndIdx]), ...
                                [yMin yMax yMax yMin], ...
                                [0.9 0.95 1], 'FaceAlpha', 0.12, 'EdgeColor', 'none');
                        end
                        % Filtered audio signal (familiar oscillating waveform)
                        if isfield(res, 'audioFilt') && ~isempty(res.audioFilt)
                            h = plot(ax2, t, res.audioFilt, 'Color', [0.3 0.5 0.9], 'LineWidth', 0.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'SP filtered';
                        end
                        % Filtered EGG signal
                        if isfield(res, 'eggFilt') && ~isempty(res.eggFilt)
                            h = plot(ax2, t, res.eggFilt, 'Color', [0.9 0.4 0.3], 'LineWidth', 0.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'EGG filtered';
                        end
                        % Audio envelope (thick overlay)
                        if ~isempty(res.audioEnvelope)
                            h = plot(ax2, t, res.audioEnvelope, 'b-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'SP envelope';
                        end
                        % EGG envelope (thick overlay)
                        if ~isempty(res.eggEnvelope)
                            h = plot(ax2, t, res.eggEnvelope, 'r-', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'EGG envelope';
                        end
                        if ~isempty(res.onsetIdx)
                            h = plot(ax2, t(res.onsetIdx)*[1 1], [yMin yMax], ...
                                'k--', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'Onset';
                        end
                        if ~isempty(res.onsetIdx) && ~isnan(res.vat_s)
                            lagTime = t(res.onsetIdx) + res.vat_s;
                            h = plot(ax2, lagTime*[1 1], [yMin yMax], ...
                                'm:', 'LineWidth', 1.5);
                            h.Annotation.LegendInformation.IconDisplayStyle = 'on';
                            plotHandles(end+1) = h;
                            plotLabels{end+1} = 'EGG lag';
                        end
                        f0Str = '';
                        if isfield(res, 'f0_Hz') && ~isempty(res.f0_Hz) && ~isnan(res.f0_Hz)
                            f0Str = sprintf('F0 = %.1f Hz', res.f0_Hz);
                        end
                        if isempty(f0Str)
                            annStr = sprintf('VAT = %.4f s (%.2f ms)\nFOM = %.3f', ...
                                res.vat_s, res.vat_s*1000, res.fom);
                        else
                            annStr = sprintf('VAT = %.4f s (%.2f ms)\nFOM = %.3f | %s', ...
                                res.vat_s, res.vat_s*1000, res.fom, f0Str);
                        end
                        text(ax2, 0.02, 0.98, annStr, ...
                            'Units', 'normalized', 'VerticalAlignment', 'top', ...
                            'HorizontalAlignment', 'left', ...
                            'BackgroundColor', 'w', 'EdgeColor', [0.6 0.6 0.6], ...
                            'FontSize', 10, 'FontWeight', 'bold');
                end

                xlim(ax2, [t(1), t(end)]);

                % Refresh southern legend
                if ~isempty(lgd2) && isvalid(lgd2)
                    delete(lgd2);
                end
                if ~isempty(plotHandles)
                    lgd2 = legend(ax2, plotHandles, plotLabels);
                    lgd2.Layout.Tile = 'south';
                    lgd2.Orientation = 'horizontal';
                    lgd2.Box = 'off';
                else
                    lgd2 = gobjects(0);
                end
            end

            %% --- Callback: audio channel changed ---
            function onAudioChannelChanged()
                chName = audioChanDd.Value;
                cIdx = find(strcmp(channelLabels, chName), 1);
                if isempty(cIdx) || cIdx == audioCh
                    return;
                end
                audioCh = cIdx;
                channelName = chName;

                % Recompute only VAT (VRT/POT are channel-independent; their table
                % rows already cover all channels)
                miVAT = find(strcmp(methodAcrs, 'VAT'), 1);
                if ~isempty(miVAT)
                    cachedResults{miVAT} = [];
                    computeMethod('VAT');
                end

                rebuildTable();
                updateInstanceDropdown();
                updateWaveformAxis();
                updateIntermediatesAxis();
            end

            %% --- Callback: EGG source changed ---
            function onEggSourceChanged()
                eggName = eggDd.Value;
                if strcmp(eggName, 'Synthetic')
                    if isnan(eggCh)
                        return;
                    end
                    eggCh = NaN;
                else
                    cIdx = find(strcmp(channelLabels, eggName), 1);
                    if isempty(cIdx) || cIdx == eggCh
                        return;
                    end
                    eggCh = cIdx;
                end

                miVAT = find(strcmp(methodAcrs, 'VAT'), 1);
                if ~isempty(miVAT)
                    cachedResults{miVAT} = [];
                    computeMethod('VAT');
                end

                rebuildTable();
                updateInstanceDropdown();
                updateWaveformAxis();
                updateIntermediatesAxis();
            end

            %% --- Callback: param changed ---
            function onParamChanged(src, mAcr)
                pname = src.UserData.param;
                pParams.(mAcr).(pname) = src.Value;

                cachedResults{find(strcmp(methodAcrs, mAcr), 1)} = [];
                computeMethod(mAcr);
                rebuildTable();
                updateInstanceDropdown();
                updateWaveformAxis();
                updateIntermediatesAxis();
            end

            %% --- Callback: intermediates dropdown ---
            function onIntermediatesChange()
                updateInstanceDropdown();
                updateWaveformAxis();
                updateIntermediatesAxis();
            end

            %% --- Callback: instance dropdown ---
            function onInstanceChanged()
                sel = interDd.Value;
                srcIdxMap.(sel) = find(strcmp(instanceDd.Items, instanceDd.Value), 1);

                updateWaveformAxis();
                updateIntermediatesAxis();
            end

            %% --- Callback: Export CSV ---
            function onExport()
                data = resultsTable.Data;
                if isempty(data)
                    uialert(fig, 'No results to export.', 'Export');
                    return;
                end

                [fname, fpath] = uiputfile({'*.csv', 'CSV Files (*.csv)'}, ...
                    'Export Onset Analysis Results', 'onset_analysis_results.csv');
                if isequal(fname, 0) || isequal(fpath, 0)
                    return;
                end

                fullPath = fullfile(fpath, fname);
                try
                    fid = fopen(fullPath, 'w');
                    hdrCols = resultsTable.ColumnName;
                    hdrCols = cellfun(@(c) strrep(c, '#', 'Index'), hdrCols, 'UniformOutput', false);
                    fprintf(fid, '%s\n', strjoin(hdrCols, ';'));

                    nRows = size(data, 1);
                    nCols = size(data, 2);
                    for r = 1:nRows
                        rowVals = cell(1, nCols);
                        for c = 1:nCols
                            val = data{r, c};
                            if isempty(val)
                                rowVals{c} = '';
                            elseif isnumeric(val)
                                rowVals{c} = num2str(val);
                            else
                                s = char(val);
                                if contains(s, ';') || contains(s, '"') || contains(s, newline)
                                    s = ['"' strrep(s, '"', '""') '"'];
                                end
                                rowVals{c} = s;
                            end
                        end
                        fprintf(fid, '%s\n', strjoin(rowVals, ';'));
                    end
                    fclose(fid);
                    uialert(fig, sprintf('Results exported to:\n%s', fullPath), 'Export Complete', ...
                        'Icon', 'success');
                catch ME
                    uialert(fig, sprintf('Export failed:\n%s', ME.message), 'Export Error');
                end
            end

            %% --- Callback: Cancel ---
            function onCancel()
                delete(fig);
            end

            %% --- Close request ---
            fig.CloseRequestFcn = @(s,e) onCancel();

            %% Initialize
            computeAll();
            rebuildTable();
            updateInstanceDropdown();
            updateWaveformAxis();
            updateIntermediatesAxis();

            %% Wait for user
            uiwait(fig);

            %% Return result
            if isvalid(fig)
                result = struct('channelName', channelName);
                for i = 1:nMethods
                    mAcr = methodAcrs{i};
                    if isempty(cachedResults{i})
                        result.(mAcr) = [];
                    else
                        result.(mAcr) = cachedResults{i};
                    end
                end
                delete(fig);
            else
                result = [];
            end

            %% --- Helper: HTML-escape a string ---
            function s = escHtml(s)
                s = strrep(s, '&', '&amp;');
                s = strrep(s, '<', '&lt;');
                s = strrep(s, '>', '&gt;');
                s = strrep(s, '"', '&quot;');
            end

        end

        function result = openVibratoAnalysisWindow(app, channelNr)
            %openVibratoAnalysisWindow  Vibrato Analysis GUI for Vocaliscope app integration
            %
            %   result = openVibratoAnalysisWindow()              Demo mode
            %   result = openVibratoAnalysisWindow(app, channelNr) From app
            %
            %   result       struct with fields for each method, or [] when cancelled

            %% Input handling & demo mode
            if nargin == 0
                wavFile = fullfile(fileparts(mfilename('fullpath')), '+VibratoAnalysis', 'testData', 'vowel a C4_6.0_0.5_1_1_015.wav');
                [channels, fs] = audioread(wavFile);
                channelLabels = {'Audio (synthetic vibrato: 6 Hz, 50 cents)'};
                audioCh = 1;
                channelNr = 1;
                t = (0:size(channels,1)-1)' / fs;
                channelName = 'Audio (hard onset, EGG+Audio)';
            else
                % Extract from Vocaliscope app
                narginchk(2, 2);
                nCh = numel(app.channelYValues);
                if nCh == 0
                    error('No channels available in app.');
                end
                channelNr = max(1, min(channelNr, nCh));

                % Use the selected channel's time base
                t = app.channelXValues{channelNr}(:);
                fs = app.channelSampleRates(channelNr);

                % Build multi-channel matrix (resample to common time base if needed)
                channels = zeros(numel(t), nCh);
                channelLabels = cell(1, nCh);
                for c = 1:nCh
                    chT = app.channelXValues{c}(:);
                    chY = app.channelYValues{c}(:);
                    if numel(chT) == numel(t) && all(abs(chT - t) < 1e-12)
                        channels(:,c) = chY;
                    else
                        channels(:,c) = interp1(chT, chY, t, 'linear', 0);
                    end
                    channelLabels{c} = app.channelNames{c};
                end

                % Auto-detect audio channel
                audioCh = find(~cellfun(@isempty, regexpi(channelLabels, 'audio|mic|sp')), 1);
                if isempty(audioCh)
                    audioCh = 1;
                end
                channelName = app.channelNames{channelNr};
            end
            t = t(:);

            %% Load vibrato methods
            vibratoMethods = VibratoAnalysis.vibratoDescriptions();
            nMethods = numel(vibratoMethods);
            methodAcrs = {vibratoMethods.acronym};

            %% Persistent settings
            persistent pParams
            if isempty(pParams)
                pParams = struct();
                for i = 1:nMethods
                    m = vibratoMethods(i);
                    pParams.(m.acronym) = struct();
                    pn = fieldnames(m.descriptor.params);
                    for k = 1:numel(pn)
                        pParams.(m.acronym).(pn{k}) = m.descriptor.params.(pn{k}).default;
                    end
                end
            end

            persistent pPitchParams
            if isempty(pPitchParams)
                pPitchParams = struct('f0_min', 60, 'f0_max', 500, ...
                    'windowLength_s', 0.04, 'overlapFrac', 0.5);
            end

            %% Result cache
            cachedResults = cell(nMethods, 1);

            %% Build description HTML (collapsible sections)
            descHtmlParts = {};
            descHtmlParts{end+1} = ['<div style="overflow-y:auto; height:95%; font-family:Segoe UI; font-size:11px; padding:2px 4px;">' ...
                '<p style="margin:0 0 6px 0"><b>Method descriptions</b> (click to expand):</p>'];

            for i = 1:nMethods
                m = vibratoMethods(i);
                descHtmlParts{end+1} = sprintf('<details style="margin:4px 0"><summary style="cursor:pointer; font-weight:bold">%s (%s)</summary>', ...
                    escHtml(m.name), escHtml(m.acronym));
                descHtmlParts{end+1} = sprintf('<p style="margin:4px 0 2px 0">%s</p>', escHtml(m.descriptor.summary));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0">%s</p>', escHtml(m.descriptor.details));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Required signals:</b> %s</p>', ...
                    escHtml(strjoin(m.descriptor.requiredSignals, ', ')));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Validated for:</b> %s</p>', ...
                    escHtml(m.descriptor.validatedFor));
                descHtmlParts{end+1} = sprintf('<p style="margin:2px 0"><b>Min sample rate:</b> %d Hz</p>', ...
                    m.descriptor.minFs_Hz);
                descHtmlParts{end+1} = '<p style="margin:6px 0 2px 0"><b>References:</b></p>';
                refs = m.sources;
                for k = 1:numel(refs)
                    if isfield(refs(k), 'doi') && ~isempty(refs(k).doi)
                        doiUrl = refs(k).doi;
                        if ~startsWith(doiUrl, 'http')
                            doiUrl = ['https://doi.org/' doiUrl];
                        end
                        refText = sprintf('[%d] %s (%d) %s. %s.', ...
                            k, refs(k).authors, refs(k).year, refs(k).title, refs(k).journal);
                        descHtmlParts{end+1} = sprintf('<p style="margin:1px 0">%s<br><span style="color:#666; font-size:10px;">%s</span></p>', ...
                            escHtml(refText), escHtml(doiUrl));
                    else
                        refText = sprintf('[%d] %s', k, refs(k).citation);
                        descHtmlParts{end+1} = sprintf('<p style="margin:1px 0">%s</p>', escHtml(refText));
                    end
                end
                descHtmlParts{end+1} = '</details>';
            end
            descHtmlParts{end+1} = '</div>';
            descHtmlStr = strjoin(descHtmlParts, newline);

            %% Create figure
            fig = uifigure('Units', 'pixels', 'Position', [0 0 1200 800], ...
                'Visible', 'off', 'Name', 'Vibrato Analysis', ...
                'Theme', 'light', 'WindowStyle', 'normal','WindowState','maximized', ...
                'CloseRequestFcn', @(s,e) uiresume(s));
            %movegui(fig, 'center');
            fig.Visible = 'on';
            cleanupObj = onCleanup(@() delete(fig));

            %% Main grid: left controls, right preview
            gl = uigridlayout(fig, [1 2], 'ColumnWidth', {400, '1x'}, ...
                'Padding', [8 8 8 8], 'RowSpacing', 5, 'ColumnSpacing', 10);

            %% -- LEFT PANEL: Controls (scrollable) + button footer --
            leftGrid = uigridlayout(gl, [2 1], 'RowHeight', {'1x', 'fit'}, ...
                'Padding', [0 0 0 0], 'RowSpacing', 0);
            leftGrid.Layout.Column = 1;

            innerGl = uigridlayout(leftGrid, [300 2], ...
                'RowHeight', repmat({'fit'}, 1, 300), ...
                'ColumnWidth', {'1x', '1x'}, ...
                'RowSpacing', 3, 'ColumnSpacing', 6, 'Padding', [5 5 5 20], ...
                'Scrollable', 'on');
            innerGl.Layout.Row = 1;

            buttonGl = uigridlayout(leftGrid, [1 3], ...
                'RowHeight', {'fit'}, ...
                'ColumnWidth', {'1x', '1x', '1x'}, ...
                'Padding', [5 5 5 5], 'RowSpacing', 3);
            buttonGl.Layout.Row = 2;

            row = 1;

            % Channel selector
            chanLabel = uilabel(innerGl, 'Text', 'Channel:', 'FontWeight', 'bold');
            chanLabel.Layout.Row = row; chanLabel.Layout.Column = [1 2]; row = row + 1;

            chanDd = uidropdown(innerGl, 'Items', channelLabels, ...
                'Value', channelLabels{channelNr}, ...
                'ValueChangedFcn', @(s,e) onChannelChanged());
            chanDd.Layout.Row = row; chanDd.Layout.Column = [1 2]; row = row + 1;

            % Input type checkbox
            inputTypeCb = uicheckbox(innerGl, 'Text', 'Input is already a pitch line (F0)', ...
                'Value', false, ...
                'ValueChangedFcn', @(s,e) onInputTypeChanged());
            inputTypeCb.Layout.Row = row; inputTypeCb.Layout.Column = [1 2]; row = row + 1;

            % Pitch tracker selector (hidden when input is pitch line)
            ptLabel = uilabel(innerGl, 'Text', 'Pitch tracker:', 'FontWeight', 'bold');
            ptLabel.Layout.Row = row; ptLabel.Layout.Column = 1; row = row + 1;

            ptItems = {'Normalized Correlation Function', 'Pitch Estimation Filter', ...
                'Cepstrum Pitch Determination', 'Log-Harmonic Summation', ...
                'Summation of Residual Harmonics', 'SWIPE''', 'SHR', ...
                'Yin pitch detection', 'Bayesian F0 estimation', 'YAAPT pitch tracking', ...
                'Praat', 'CREPE'};
            ptItemsData = {'NCF', 'PEF', 'CEP', 'LHS', 'SRH', 'SWIPE''', 'SHR', ...
                'YIN', 'BF0NLS', 'YAAPT', 'Praat', 'CREPE'};
            ptDd = uidropdown(innerGl, 'Items', ptItems, ...
                'ItemsData', ptItemsData, ...
                'Value', 'SWIPE''', ...
                'ValueChangedFcn', @(s,e) onPitchTrackerChanged());
            ptDd.Layout.Row = row; ptDd.Layout.Column = 2; row = row + 1;

            % Secondary dropdown (visible only for Praat sub-method or CREPE capacity)
            ptSubLabel = uilabel(innerGl, 'Text', 'Sub-method:', 'FontWeight', 'bold');
            ptSubLabel.Layout.Row = row; ptSubLabel.Layout.Column = 1;
            ptSubLabel.Visible = 'off';

            ptSubDd = uidropdown(innerGl, 'Items', {'filtered_ac', 'ac', ...
                'cc', 'filtered_cc', 'shs', 'spinet'}, ...
                'Value', 'filtered_ac', ...
                'ValueChangedFcn', @(s,e) onPitchTrackerChanged());
            ptSubDd.Layout.Row = row; ptSubDd.Layout.Column = 2;
            ptSubDd.Visible = 'off'; row = row + 1;

            % Pitch extraction settings
            pitchHeader = uilabel(innerGl, 'Text', '--- Pitch Extraction Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            pitchHeader.Layout.Row = row; pitchHeader.Layout.Column = [1 2]; row = row + 1;

            foMinLabel = uilabel(innerGl, 'Text', 'Minimum F0 (Hz)');
            foMinLabel.Layout.Row = row; foMinLabel.Layout.Column = 1;
            foMinEd = uieditfield(innerGl, 'numeric', 'Value', pPitchParams.f0_min, ...
                'Limits', [20 2000], 'ValueDisplayFormat', '%.1f', ...
                'ValueChangedFcn', @(s,e) onPitchSettingChanged());
            foMinEd.Layout.Row = row; foMinEd.Layout.Column = 2; row = row + 1;

            foMaxLabel = uilabel(innerGl, 'Text', 'Maximum F0 (Hz)');
            foMaxLabel.Layout.Row = row; foMaxLabel.Layout.Column = 1;
            foMaxEd = uieditfield(innerGl, 'numeric', 'Value', pPitchParams.f0_max, ...
                'Limits', [50 5000], 'ValueDisplayFormat', '%.1f', ...
                'ValueChangedFcn', @(s,e) onPitchSettingChanged());
            foMaxEd.Layout.Row = row; foMaxEd.Layout.Column = 2; row = row + 1;

            winLenLabel = uilabel(innerGl, 'Text', 'Window length (s)');
            winLenLabel.Layout.Row = row; winLenLabel.Layout.Column = 1;
            winLenEd = uieditfield(innerGl, 'numeric', 'Value', pPitchParams.windowLength_s, ...
                'Limits', [0.005 0.2], 'ValueDisplayFormat', '%.3f', ...
                'Tooltip', 'Analysis window length in seconds (e.g., 0.04 = 40 ms). Ignored by SWIPE'' and YAAPT (use native settings).', ...
                'ValueChangedFcn', @(s,e) onPitchSettingChanged());
            winLenEd.Layout.Row = row; winLenEd.Layout.Column = 2; row = row + 1;

            overlapLabel = uilabel(innerGl, 'Text', 'Overlap (fraction)');
            overlapLabel.Layout.Row = row; overlapLabel.Layout.Column = 1;
            overlapEd = uieditfield(innerGl, 'numeric', 'Value', pPitchParams.overlapFrac, ...
                'Limits', [0 0.95], 'ValueDisplayFormat', '%.2f', ...
                'Tooltip', 'Fractional overlap between analysis frames (0-0.95). Ignored by SWIPE'' and YAAPT.', ...
                'ValueChangedFcn', @(s,e) onPitchSettingChanged());
            overlapEd.Layout.Row = row; overlapEd.Layout.Column = 2; row = row + 1;

            % Time interval
            timeLabel = uilabel(innerGl, 'Text', 'Time interval (s):', 'FontWeight', 'bold');
            timeLabel.Layout.Row = row; timeLabel.Layout.Column = [1 2]; row = row + 1;

            startTimeEd = uieditfield(innerGl, 'numeric', 'Value', 0, ...
                'Limits', [0 t(end)], 'ValueChangedFcn', @(s,e) onTimeChanged());
            startTimeEd.Layout.Row = row; startTimeEd.Layout.Column = 1;

            endTimeEd = uieditfield(innerGl, 'numeric', 'Value', t(end), ...
                'Limits', [0 t(end)], 'ValueChangedFcn', @(s,e) onTimeChanged());
            endTimeEd.Layout.Row = row; endTimeEd.Layout.Column = 2; row = row + 1;

            % Method descriptions (collapsible)
            descHeader = uilabel(innerGl, 'Text', 'Method Descriptions', 'FontWeight', 'bold');
            descHeader.Layout.Row = row; descHeader.Layout.Column = [1 2]; row = row + 1;

            descHtmlWidget = uihtml(innerGl, 'HTMLSource', descHtmlStr);
            descHtmlWidget.Layout.Row = row; descHtmlWidget.Layout.Column = [1 2];
            descHtml_row = row; row = row + 1;

            % Spacer
            sep3 = uilabel(innerGl, 'Text', '');
            sep3.Layout.Row = row; sep3.Layout.Column = [1 2]; row = row + 1;

            %% Create per-method parameter sections
            methodParamEdits = cell(nMethods, 1);
            for i = 1:nMethods
                m = vibratoMethods(i);
                pnames = fieldnames(m.descriptor.params);
                np = numel(pnames);

                hdr = uilabel(innerGl, 'Text', sprintf('--- %s Parameters ---', m.name), ...
                    'FontWeight', 'bold', 'FontAngle', 'italic');
                hdr.Layout.Row = row; hdr.Layout.Column = [1 2]; row = row + 1;

                edits = struct();
                for k = 1:np
                    p = m.descriptor.params.(pnames{k});
                    lblStr = pnames{k};
                    switch lblStr
                        case 'bpLowHz',          lblStr = 'Bandpass low (Hz)';
                        case 'bpHighHz',         lblStr = 'Bandpass high (Hz)';
                        case 'bpOrder',          lblStr = 'Filter order';
                        case 'peakProminence',   lblStr = 'Peak prominence (cents)';
                        case 'peakDistance',     lblStr = 'Peak distance (samples)';
                        case 'minHalfExtent',    lblStr = 'Minimum half-extent (cents)';
                        case 'maxHalfExtent',    lblStr = 'Maximum half-extent (cents)';
                        case 'outlierThreshold', lblStr = 'Outlier threshold (MAD)';
                        case 'resampleFs',       lblStr = 'Resample rate (Hz)';
                        case 'sampEnM',          lblStr = 'Sample entropy dimension';
                        case 'sampEnR',          lblStr = 'Sample entropy tolerance';
                        case 'bpLowScale',       lblStr = 'Bandpass low (×F0)';
                        case 'bpHighScale',      lblStr = 'Bandpass high (×F0)';
                        case 'smoothWindow_s',   lblStr = 'Smooth window (s)';
                        case 'minModIndex',      lblStr = 'Minimum modulation index';
                        case 'fMin',             lblStr = 'Minimum frequency (Hz)';
                        case 'fMax',             lblStr = 'Maximum frequency (Hz)';
                        case 'c0',               lblStr = 'Morlet c0';
                        case 'voicesPerOctave',  lblStr = 'Voices per octave';
                        case 'minSpeedHz',       lblStr = 'Minimum speed (Hz)';
                        case 'maxSpeedHz',       lblStr = 'Maximum speed (Hz)';
                        case 'minExtent_cents',  lblStr = 'Minimum extent (cents)';
                        case 'extentRefWindow_s', lblStr = 'Reference window (s)';
                        case 'kMax',             lblStr = 'Maximum components';
                        case 'frameLength_s',    lblStr = 'Frame length (s)';
                        case 'frameOverlap',     lblStr = 'Frame overlap';
                        case 'amplitudeMin',     lblStr = 'Minimum amplitude';
                        case 'minVibratoFrames', lblStr = 'Minimum vibrato frames';
                        case 'minFreqHz',        lblStr = 'Minimum frequency (Hz)';
                        case 'maxFreqHz',        lblStr = 'Maximum frequency (Hz)';
                        case 'frameLen',         lblStr = 'Frame length (s)';
                        case 'overlap',          lblStr = 'Overlap (fraction)';
                    end
                    lbl = uilabel(innerGl, 'Text', lblStr, ...
                        'Tooltip', p.tooltip);
                    lbl.Layout.Row = row; lbl.Layout.Column = 1;

                    val = p.default;
                    if isfield(pParams, m.acronym) && isfield(pParams.(m.acronym), pnames{k})
                        val = pParams.(m.acronym).(pnames{k});
                    end
                    ed = uieditfield(innerGl, 'numeric', 'Value', val, ...
                        'Limits', p.limits, 'ToolTip', p.tooltip, ...
                        'ValueChangedFcn', @(s,e) onParamChanged(s, m.acronym));
                    ed.Layout.Row = row; ed.Layout.Column = 2;
                    ed.UserData = struct('method', m.acronym, 'param', pnames{k});
                    edits.(pnames{k}) = ed;
                    row = row + 1;
                end
                methodParamEdits{i} = edits;

                sp = uilabel(innerGl, 'Text', '');
                sp.Layout.Row = row; sp.Layout.Column = [1 2]; row = row + 1;
            end

            % Set fixed heights for HTML areas
            innerGl.RowHeight{descHtml_row} = 130;

            %% -- Right panel: Preview + Table --
            rightPnl = uipanel(gl, 'Title', 'Preview & Results', 'FontWeight', 'bold', ...
                'BorderType', 'none');
            rightPnl.Layout.Column = 2;

            rightGrid = uigridlayout(rightPnl, [4 1], ...
                'RowHeight', {'1x', '1x', 'fit', '1.5x'}, ...
                'Padding', [5 5 5 5], 'RowSpacing', 5);

            % Panel wrapping tiledlayout for axes
            axisPanel = uipanel(rightGrid, 'BorderType', 'none');
            axisPanel.Layout.Row = [1 2];

            vibTL = tiledlayout(axisPanel, 2, 1, 'TileSpacing', 'compact');

            % Axis 1: pitch contour
            ax1 = nexttile(vibTL);
            title(ax1, 'Pitch Contour + Vibrato Markers', 'Interpreter', 'none');
            xlabel(ax1, 'Time (s)'); ylabel(ax1, 'F0 (Hz)');
            hold(ax1, 'on');

            % Axis 2: vibrato speed + extent
            ax2 = nexttile(vibTL);
            title(ax2, 'Vibrato Speed & Extent', 'Interpreter', 'none');
            xlabel(ax2, 'Time (s)'); ylabel(ax2, 'Value');
            hold(ax2, 'on');

            % Link x-axes
            linkaxes([ax1, ax2], 'x');

            % Method selector for display
            interGrid = uigridlayout(rightGrid, [1 2], ...
                'ColumnWidth', {'fit', '1x'}, 'RowHeight', {'fit'}, ...
                'Padding', [0 0 0 0], 'RowSpacing', 2);
            interGrid.Layout.Row = 3;

            interLabel = uilabel(interGrid, 'Text', 'Show results for:');
            interLabel.Layout.Row = 1; interLabel.Layout.Column = 1;

            interDd = uidropdown(interGrid, 'Items', {vibratoMethods.name}, ...
                'ItemsData', methodAcrs, ...
                'Value', methodAcrs{1}, ...
                'ValueChangedFcn', @(s,e) onIntermediatesChange());
            interDd.Layout.Row = 1; interDd.Layout.Column = 2;

            % Results table
            colNames = {'#', 'Method', 'Rate (Hz)', 'Extent (cents)', 'Extent (semitone)', 'Status', 'Details'};
            colWidths = {30, 120, 80, 100, 110, 65, 'auto'};

            resultsTable = uitable(rightGrid, 'Data', cell(0, 7), ...
                'ColumnName', colNames, 'ColumnWidth', colWidths, ...
                'RowName', [], 'ColumnEditable', false);
            resultsTable.Layout.Row = 4;

            %% -- Buttons (Export CSV, Export Channel, Close) --
            exportBtn = uibutton(buttonGl, 'Text', 'Export to csv', ...
                'ButtonPushedFcn', @(s,e) onExport());
            exportBtn.Layout.Row = 1; exportBtn.Layout.Column = 1;

            exportChBtn = uibutton(buttonGl, 'Text', 'Export as channel', ...
                'ButtonPushedFcn', @(s,e) onExportChannel());
            exportChBtn.Layout.Row = 1; exportChBtn.Layout.Column = 2;
            if nargin < 2
                exportChBtn.Visible = 'off';
            end

            cancelBtn = uibutton(buttonGl, 'Text', 'Close', ...
                'ButtonPushedFcn', @(s,e) onCancel());
            cancelBtn.Layout.Row = 1; cancelBtn.Layout.Column = 3;

            %% --- Helper: get parameter values for a method ---
            function params = getMethodParams(mAcr)
                mi = find(strcmp(methodAcrs, mAcr), 1);
                if isempty(mi)
                    params = struct();
                    return;
                end
                edits = methodParamEdits{mi};
                pnames = fieldnames(edits);
                params = struct();
                for k = 1:numel(pnames)
                    params.(pnames{k}) = edits.(pnames{k}).Value;
                end
            end

            %% --- Get selected channel data ---
            function [ySel, fsSel] = getSelectedChannel()
                cIdx = find(strcmp(channelLabels, chanDd.Value), 1);
                if isempty(cIdx), cIdx = audioCh; end
                ySel = channels(:, cIdx);
                fsSel = fs;
            end

            %% --- Compute one method ---
            function computeMethod(mAcr)
                mi = find(strcmp(methodAcrs, mAcr), 1);
                if isempty(mi), return; end

                params = getMethodParams(mAcr);
                params.pitchTracker = ptDd.Value;

                % Build pitch extraction options
                pitchOpts = struct();
                pitchOpts.f0_min = foMinEd.Value;
                pitchOpts.f0_max = foMaxEd.Value;
                pitchOpts.windowLength_s = winLenEd.Value;
                pitchOpts.overlapFrac = overlapEd.Value;
                if strcmp(ptDd.Value, 'Praat')
                    pitchOpts.praatSubMethod = ptSubDd.Value;
                elseif strcmp(ptDd.Value, 'CREPE')
                    pitchOpts.crepeCapacity = ptSubDd.Value;
                end
                params.pitchOpts = pitchOpts;

                try
                    [ySel, fsSel] = getSelectedChannel();

                    % Apply time interval
                    tStart = startTimeEd.Value;
                    tEnd = endTimeEd.Value;
                    mask = t >= tStart & t <= tEnd;
                    yCrop = ySel(mask);

                    if inputTypeCb.Value
                        % Input is already pitch line (F0 in Hz)
                        r = struct();
                        r.success = true;
                        r.method = mAcr;
                        r.inputType = 'PitchLine';
                        r.pitchHz = mean(yCrop(yCrop > 0), 'omitnan');
                        r.rate_Hz = NaN;
                        r.extent_cents = NaN;
                        r.extent_semitone = NaN;
                        r.warnings = {'Pitch line input: running CWT analysis on provided F0'};
                        r.intermediates = struct('pitchHz', yCrop, 'time_s', t(mask));
                        cachedResults{mi} = r;
                    else
                        switch mAcr
                            case 'VAT'
                                r = VibratoAnalysis.VibratoToolbox.compute(yCrop, fsSel, params);
                            case 'AVA'
                                r = VibratoAnalysis.AVA.compute(yCrop, fsSel, params);
                            case 'VIBSCOPE'
                                r = VibratoAnalysis.VibratoScope.compute(yCrop, fsSel, params);
                            case 'CWTF0'
                                r = VibratoAnalysis.CWTf0.compute(yCrop, fsSel, params);
                            otherwise
                                r = struct('success', false, 'warnings', {'Unknown method'});
                        end
                        cachedResults{mi} = r;
                    end
                catch ME
                    cachedResults{mi} = struct('success', false, 'warnings', {ME.message});
                end
            end

            %% --- Compute all methods ---
            function computeAll()
                for i = 1:nMethods
                    computeMethod(methodAcrs{i});
                end
            end

            %% --- Rebuild results table ---
            function rebuildTable()
                rows = {};
                rowNum = 0;
                for mi = 1:nMethods
                    m = vibratoMethods(mi);
                    res = cachedResults{mi};
                    rowNum = rowNum + 1;
                    rows{rowNum, 1} = rowNum;
                    rows{rowNum, 2} = m.name;

                    if isempty(res)
                        rows{rowNum, 3} = '';
                        rows{rowNum, 4} = '';
                        rows{rowNum, 5} = '';
                        rows{rowNum, 6} = '';
                        rows{rowNum, 7} = '';
                        continue;
                    end

                    if isfield(res, 'success') && res.success
                        % Rate: show mean ± std from time series
                        if isfield(res, 'rate_Hz_ts') && ~isempty(res.rate_Hz_ts)
                            rateTs = res.rate_Hz_ts;
                            rows{rowNum, 3} = sprintf('%.2f ± %.2f', mean(rateTs, 'omitnan'), std(rateTs, 0, 'omitnan'));
                        else
                            rows{rowNum, 3} = sprintf('%.2f', res.rate_Hz);
                        end
                        % Extent: show mean ± std from time series
                        if isfield(res, 'extent_cents_ts') && ~isempty(res.extent_cents_ts)
                            extTs = res.extent_cents_ts;
                            rows{rowNum, 4} = sprintf('%.1f ± %.1f', mean(extTs, 'omitnan'), std(extTs, 0, 'omitnan'));
                        else
                            rows{rowNum, 4} = sprintf('%.2f', res.extent_cents);
                        end
                        rows{rowNum, 5} = sprintf('%.3f', res.extent_semitone);
                        rows{rowNum, 6} = 'OK';
                        if isfield(res, 'nCycles')
                            rows{rowNum, 7} = sprintf('Cycles: %d', res.nCycles);
                        elseif isfield(res, 'rate_Hz_ts') && ~isempty(res.rate_Hz_ts)
                            rows{rowNum, 7} = sprintf('Points: %d', numel(res.rate_Hz_ts));
                        elseif isfield(res, 'speed_Hz') && ~isempty(res.speed_Hz)
                            rows{rowNum, 7} = sprintf('Points: %d', numel(res.speed_Hz));
                        else
                            rows{rowNum, 7} = '';
                        end
                    else
                        rows{rowNum, 3} = '';
                        rows{rowNum, 4} = '';
                        rows{rowNum, 5} = '';
                        rows{rowNum, 6} = 'FAIL';
                        if isfield(res, 'warnings') && ~isempty(res.warnings)
                            if iscell(res.warnings)
                                rows{rowNum, 7} = res.warnings{1};
                            else
                                rows{rowNum, 7} = char(res.warnings);
                            end
                        else
                            rows{rowNum, 7} = '';
                        end
                    end
                end
                if isempty(rows)
                    resultsTable.Data = cell(0, 7);
                else
                    resultsTable.Data = rows;
                end
            end

            %% --- Update plots ---
            function updatePlots()
                sel = interDd.Value;
                mi = find(strcmp(methodAcrs, sel), 1);
                res = cachedResults{mi};

                cla(ax1); cla(ax2);

                [ySel, ~] = getSelectedChannel();
                tStart = startTimeEd.Value;
                tEnd = endTimeEd.Value;
                mask = t >= tStart & t <= tEnd;
                tCrop = t(mask);

                wfColor = [0.35 0.35 0.35];
                pitchColor = [0.0 0.6 0.3];
                refColor = [0.8 0 0];

                yyaxis(ax1, 'left'); cla(ax1);
                yyaxis(ax1, 'right'); cla(ax1);
                hold(ax1, 'on');

                legH = []; legL = {};

                if ~inputTypeCb.Value
                    yyaxis(ax1, 'left');
                    ax1.YAxis(1).Color = wfColor;
                    h = plot(ax1, tCrop, ySel(mask), 'Color', wfColor, 'LineWidth', 0.5);
                    legH(end+1) = h; legL{end+1} = 'Waveform';
                    ylabel(ax1, 'Amplitude', 'Color', wfColor);
                    ylim(ax1, 'auto');
                end

                if ~isempty(res) && isfield(res, 'success') && res.success
                    if isfield(res, 'intermediates') && isfield(res.intermediates, 'pitchHz')
                        ppHz = res.intermediates.pitchHz;
                        if isfield(res.intermediates, 'pitchTime') && ~isempty(res.intermediates.pitchTime)
                            ppTime = res.intermediates.pitchTime + tStart;
                        else
                            ppTime = linspace(tCrop(1), tCrop(end), numel(ppHz));
                        end
                        switch sel
                            case 'VAT', refType = 'median';
                            otherwise,  refType = 'mean';
                        end
                        tm = ppTime >= tCrop(1) & ppTime <= tCrop(end);
                        if any(tm)
                            yyaxis(ax1, 'right');
                            ax1.YAxis(2).Color = pitchColor;
                            h = plot(ax1, ppTime(tm), ppHz(tm), 'Color', pitchColor, 'LineWidth', 1.5);
                            legH(end+1) = h; legL{end+1} = 'Pitch';
                            ylabel(ax1, 'f_o (Hz)', 'Color', pitchColor, 'Interpreter', 'tex');
                            if isfield(res, 'pitchHz') && isscalar(res.pitchHz) && res.pitchHz > 0
                                h = yline(ax1, res.pitchHz, '--', 'Color', refColor, 'LineWidth', 1);
                                legH(end+1) = h; legL{end+1} = sprintf('%s %.0f Hz', refType, res.pitchHz);
                            end
                            ylim(ax1, 'auto');
                        end
                    end
                end
                xlim(ax1, [tCrop(1), tCrop(end)]);
                if ~isempty(legH)
                    lg = legend(ax1, legH, legL, 'Orientation', 'horizontal');
                    lg.Layout.Tile = 'north';
                end

                rateColor = [0.85 0.325 0.098];
                extColor = [0.494 0.184 0.556];

                yyaxis(ax2, 'left'); cla(ax2);
                yyaxis(ax2, 'right'); cla(ax2);
                hold(ax2, 'on');

                if ~isempty(res) && isfield(res, 'success') && res.success
                    hasTS = false;
                    rateTs = []; extTs = []; timeTs = [];
                    if isfield(res, 'rate_Hz_ts') && ~isempty(res.rate_Hz_ts)
                        rateTs = res.rate_Hz_ts;
                        extTs = res.extent_cents_ts;
                        timeTs = res.time_s + tStart;
                        hasTS = true;
                    elseif isfield(res, 'speed_Hz') && ~isempty(res.speed_Hz)
                        rateTs = res.speed_Hz;
                        extTs = res.extent_cents_ts;
                        timeTs = res.time_s + tStart;
                        hasTS = true;
                    end
                    if hasTS
                        yyaxis(ax2, 'left');
                        ax2.YAxis(1).Color = rateColor;
                        plot(ax2, timeTs, rateTs, 'Color', rateColor, 'LineWidth', 1);
                        ylabel(ax2, 'Rate (Hz)', 'Color', rateColor);
                        ylim(ax2, 'auto');
                        yyaxis(ax2, 'right');
                        ax2.YAxis(2).Color = extColor;
                        plot(ax2, timeTs, extTs, 'Color', extColor, 'LineWidth', 1);
                        ylabel(ax2, 'Extent (cents)', 'Color', extColor);
                        ylim(ax2, 'auto');
                    end
                end
                xlim(ax2, [tCrop(1), tCrop(end)]);
            end

            %% --- Callback: channel changed ---
            function onChannelChanged()
                computeAll();
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: input type changed ---
            function onInputTypeChanged()
                if inputTypeCb.Value
                    ptLabel.Visible = 'off';
                    ptDd.Visible = 'off';
                    ptSubLabel.Visible = 'off';
                    ptSubDd.Visible = 'off';
                else
                    ptLabel.Visible = 'on';
                    ptDd.Visible = 'on';
                    onPitchTrackerChanged();  % restore secondary dropdown visibility
                end
                computeAll();
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: pitch tracker changed ---
            function onPitchSettingChanged()
                pPitchParams.f0_min = foMinEd.Value;
                pPitchParams.f0_max = foMaxEd.Value;
                pPitchParams.windowLength_s = winLenEd.Value;
                pPitchParams.overlapFrac = overlapEd.Value;
                computeAll();
                rebuildTable();
                updatePlots();
            end

            function onPitchTrackerChanged()
                sel = ptDd.Value;
                % Show/hide secondary dropdown
                if strcmp(sel, 'Praat')
                    ptSubLabel.Text = 'Sub-method:';
                    ptSubLabel.Visible = 'on';
                    ptSubDd.Visible = 'on';
                    ptSubDd.Items = {'filtered_ac', 'ac', ...
                        'cc', 'filtered_cc', 'shs', 'spinet'};
                elseif strcmp(sel, 'CREPE')
                    ptSubLabel.Text = 'Capacity:';
                    ptSubLabel.Visible = 'on';
                    ptSubDd.Visible = 'on';
                    ptSubDd.Items = {'tiny', 'small', 'medium', 'large', 'full'};
                    ptSubDd.Value = 'medium';
                else
                    ptSubLabel.Visible = 'off';
                    ptSubDd.Visible = 'off';
                end

                % Show/hide pitch extraction controls based on method
                isCrepe = strcmp(sel, 'CREPE');
                if isCrepe
                    foMinLabel.Visible = 'off'; foMinEd.Visible = 'off';
                    foMaxLabel.Visible = 'off'; foMaxEd.Visible = 'off';
                else
                    foMinLabel.Visible = 'on';  foMinEd.Visible = 'on';
                    foMaxLabel.Visible = 'on';  foMaxEd.Visible = 'on';
                end

                hasFrame = ismember(sel, {'NCF', 'PEF', 'CEP', 'LHS', 'SRH', 'SHR', 'YIN', 'BF0NLS', 'Praat'});
                if hasFrame
                    winLenLabel.Visible = 'on';  winLenEd.Visible = 'on';
                else
                    winLenLabel.Visible = 'off'; winLenEd.Visible = 'off';
                end

                hasOverlap = ismember(sel, {'NCF', 'PEF', 'CEP', 'LHS', 'SRH', 'SHR', 'YIN', 'BF0NLS', 'Praat', 'CREPE'});
                if hasOverlap
                    overlapLabel.Visible = 'on';  overlapEd.Visible = 'on';
                else
                    overlapLabel.Visible = 'off'; overlapEd.Visible = 'off';
                end

                computeAll();
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: time interval changed ---
            function onTimeChanged()
                computeAll();
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: param changed ---
            function onParamChanged(src, mAcr)
                pname = src.UserData.param;
                pParams.(mAcr).(pname) = src.Value;

                cachedResults{find(strcmp(methodAcrs, mAcr), 1)} = [];
                computeMethod(mAcr);
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: method selector changed ---
            function onIntermediatesChange()
                updatePlots();
            end

            %% --- Callback: Compute all ---
            function onComputeAll()
                computeAll();
                rebuildTable();
                updatePlots();
            end

            %% --- Callback: Export CSV ---
            function onExport()
                data = resultsTable.Data;
                if isempty(data)
                    uialert(fig, 'No results to export.', 'Export');
                    return;
                end

                [fname, fpath] = uiputfile({'*.csv', 'CSV Files (*.csv)'}, ...
                    'Export Vibrato Analysis Results', 'vibrato_analysis_results.csv');
                if isequal(fname, 0) || isequal(fpath, 0)
                    return;
                end

                fullPath = fullfile(fpath, fname);
                try
                    fid = fopen(fullPath, 'w');
                    hdrCols = resultsTable.ColumnName;
                    hdrCols = cellfun(@(c) strrep(c, '#', 'Index'), hdrCols, 'UniformOutput', false);
                    fprintf(fid, '%s\n', strjoin(hdrCols, ';'));

                    nRows = size(data, 1);
                    nCols = size(data, 2);
                    for r = 1:nRows
                        rowVals = cell(1, nCols);
                        for c = 1:nCols
                            val = data{r, c};
                            if isempty(val)
                                rowVals{c} = '';
                            elseif isnumeric(val)
                                rowVals{c} = num2str(val);
                            else
                                s = char(val);
                                if contains(s, ';') || contains(s, '"') || contains(s, newline)
                                    s = ['"' strrep(s, '"', '""') '"'];
                                end
                                rowVals{c} = s;
                            end
                        end
                        fprintf(fid, '%s\n', strjoin(rowVals, ';'));
                    end
                    fclose(fid);
                    uialert(fig, sprintf('Results exported to:\n%s', fullPath), 'Export Complete', ...
                        'Icon', 'success');
                catch ME
                    uialert(fig, sprintf('Export failed:\n%s', ME.message), 'Export Error');
                end
            end

            %% --- Callback: Export as channel ---
            function onExportChannel()
                sel = interDd.Value;
                mi = find(strcmp(methodAcrs, sel), 1);
                res = cachedResults{mi};
                if isempty(res) || ~isfield(res, 'success') || ~res.success
                    uialert(fig, 'No valid results for the selected method.', 'Export as Channel');
                    return;
                end

                % Build list of available exports
                options = {};
                optionKeys = {};
                if isfield(res, 'intermediates') && isfield(res.intermediates, 'pitchHz') ...
                        && ~isempty(res.intermediates.pitchHz) && ~inputTypeCb.Value
                    options{end+1} = 'Pitch contour (Hz)';
                    optionKeys{end+1} = 'pitch';
                end
                if isfield(res, 'rate_Hz_ts') && ~isempty(res.rate_Hz_ts)
                    options{end+1} = 'Vibrato rate (Hz)';
                    optionKeys{end+1} = 'rate';
                elseif isfield(res, 'speed_Hz') && ~isempty(res.speed_Hz)
                    options{end+1} = 'Vibrato rate (Hz)';
                    optionKeys{end+1} = 'rate';
                end
                if isfield(res, 'extent_cents_ts') && ~isempty(res.extent_cents_ts)
                    options{end+1} = 'Vibrato extent (cents)';
                    optionKeys{end+1} = 'extent';
                end

                if isempty(options)
                    uialert(fig, 'No time-series data available for export.', 'Export as Channel');
                    return;
                end

                % Selection dialog
                [selIdx, ok] = listdlg('ListString', options, ...
                    'SelectionMode', 'multiple', ...
                    'PromptString', 'Select data to export as new channel(s):', ...
                    'Name', 'Export as Channel', ...
                    'ListSize', [250 120]);
                if ~ok || isempty(selIdx), return; end

                tStart = startTimeEd.Value;
                methodName = vibratoMethods(mi).name;
                ptMethod = ptDd.Value;

                exported = 0;
                for s = 1:numel(selIdx)
                    key = optionKeys{selIdx(s)};
                    switch key
                        case 'pitch'
                            yData = res.intermediates.pitchHz(:);
                            if isfield(res.intermediates, 'pitchTime') && ~isempty(res.intermediates.pitchTime)
                                xData = res.intermediates.pitchTime(:) + tStart;
                            else
                                xData = linspace(tStart, endTimeEd.Value, numel(yData))';
                            end
                            chName = sprintf('%s pitch (%s, %s)', channelName, methodName, ptMethod);

                        case 'rate'
                            if isfield(res, 'rate_Hz_ts') && ~isempty(res.rate_Hz_ts)
                                yData = res.rate_Hz_ts(:);
                            else
                                yData = res.speed_Hz(:);
                            end
                            xData = res.time_s(:) + tStart;
                            chName = sprintf('%s vibrato rate (%s, %s)', channelName, methodName, ptMethod);

                        case 'extent'
                            yData = res.extent_cents_ts(:);
                            xData = res.time_s(:) + tStart;
                            chName = sprintf('%s vibrato extent (%s, %s)', channelName, methodName, ptMethod);
                    end

                    try
                        app.addSingleChannelData(yData, xData, chName, 'Raw');
                        exported = exported + 1;
                    catch ME
                        uialert(fig, sprintf('Export failed for "%s":\n%s', chName, ME.message), 'Export Error');
                    end
                end

                if exported > 0
                    uialert(fig, sprintf('%d channel(s) exported to Vocaliscope.', exported), ...
                        'Export Complete', 'Icon', 'success');
                end
            end

            %% --- Callback: Cancel ---
            function onCancel()
                delete(fig);
            end

            %% --- Close request ---
            fig.CloseRequestFcn = @(s,e) onCancel();

            %% Initialize
            onPitchTrackerChanged(); % Set initial visibility
            computeAll();
            rebuildTable();
            updatePlots();

            %% Wait for user
            uiwait(fig);

            %% Return result
            if isvalid(fig)
                result = struct('channelName', channelName);
                for i = 1:nMethods
                    mAcr = methodAcrs{i};
                    if isempty(cachedResults{i})
                        result.(mAcr) = [];
                    else
                        result.(mAcr) = cachedResults{i};
                    end
                end
                delete(fig);
            else
                result = [];
            end

            %% --- HTML escape helper ---
            function s = escHtml(s)
                s = strrep(s, '&', '&amp;');
                s = strrep(s, '<', '&lt;');
                s = strrep(s, '>', '&gt;');
                s = strrep(s, '"', '&quot;');
                s = strrep(s, newline, '<br>');
            end

        end

        



   
        function openEnvelopeWindow(app, channelNr)

            windowClosedByApply=0;

            % Persistent settings
            persistent envelopeMethod windowLength envelopeToAdd referenceMethod windowDirection
            if isempty(envelopeMethod)
                envelopeMethod = 'peak';
                windowLength = 0.1;
                envelopeToAdd='upper';
                referenceMethod = 'moving mean';
                windowDirection = 'centered';

            end

            fs = app.channelSampleRates(channelNr);
            y = app.channelYValues{channelNr};
            t = app.channelXValues{channelNr};

            % --- Figure & GridLayout ---
            fig = uifigure('Units','pixels','Position',[0 0 1000 450],'Visible','off','Name','Envelope Estimation','Theme','light');
            movegui(fig, 'center');
            drawnow;
            fig.Visible = 'on';
            gl = uigridlayout(fig, [6 3], 'ColumnWidth', {'1x','1x','2x'}, 'RowSpacing', 3, 'Padding', 10);

            % --- Controls ---
            methodLabel = uilabel(gl, 'Text', 'Envelope Method', 'FontWeight', 'bold');
            methodLabel.Layout.Row = 1; methodLabel.Layout.Column = 1;

            envelopeMethodDropdown = uidropdown(gl, 'Items',{'analytic','peak',...
                'moving rms',     'moving rms of values above/below reference',...
                'moving min/max', 'moving abs. max',...
                'moving mean',    'moving mean of values above/below reference',...
                'moving median',  'moving median of values above/below reference',...
                'moving STD',     'moving STD of values above/below reference'},...
                'Value', envelopeMethod);
            envelopeMethodDropdown.Layout.Row = 1; envelopeMethodDropdown.Layout.Column = 2;


            referenceMethodLabel = uilabel(gl, 'Text', 'Center Reference Method', 'FontWeight', 'bold','Visible',~ismember(envelopeMethodDropdown.Value,{'analytic','peak'}));
            referenceMethodLabel.Layout.Row = 2; referenceMethodLabel.Layout.Column = 1;

            referenceMethodDropdown = uidropdown(gl, 'Items',{ 'moving mean', 'moving median', 'global mean' , 'global median' },...
                'Value', referenceMethod,'Visible',~ismember(envelopeMethodDropdown.Value,{'analytic','peak'}));
            referenceMethodDropdown.Layout.Row = 2; referenceMethodDropdown.Layout.Column = 2;

            windowLengthLabel = uilabel(gl, 'Text', 'Time Window (s)', 'FontWeight', 'bold');
            windowLengthLabel.Layout.Row = 3; windowLengthLabel.Layout.Column = 1;

            WindowLengthEdit = uieditfield(gl,'numeric','Value',windowLength,'ValueDisplayFormat','%f','Limits',[2/fs (numel(y)-1)/fs]);
            WindowLengthEdit.Layout.Row = 3; WindowLengthEdit.Layout.Column = 2;

            windowDirectionLabel = uilabel(gl, 'Text', 'Center Reference Method', 'FontWeight', 'bold','Visible',~ismember(envelopeMethodDropdown.Value,{'analytic','peak'}));
            windowDirectionLabel.Layout.Row = 4; windowDirectionLabel.Layout.Column = 1;

            windowDirectionDropdown = uidropdown(gl, 'Items',{ 'centered', 'forward', 'backward' },...
                'Value', windowDirection,'Visible',~ismember(envelopeMethodDropdown.Value,{'analytic','peak'}));
            windowDirectionDropdown.Layout.Row = 4; windowDirectionDropdown.Layout.Column = 2;


            whichEnvelopeToAddLabel = uilabel(gl, 'Text', 'Which Envelope to add', 'FontWeight', 'bold');
            whichEnvelopeToAddLabel.Layout.Row = 5; whichEnvelopeToAddLabel.Layout.Column = 1;

            whichEnvelopeToAddDropdown = uidropdown(gl, 'Items',{'upper' 'lower' 'both'},'Value',envelopeToAdd);
            whichEnvelopeToAddDropdown.Layout.Row = 5; whichEnvelopeToAddDropdown.Layout.Column = 2;



            applyBtn = uibutton(gl, 'Text', 'Apply', 'FontWeight', 'bold');
            applyBtn.Layout.Row = 6; applyBtn.Layout.Column = 2;

            % --- Plots ---
            ax = uiaxes(gl);
            ax.Layout.Column = 3; ax.Layout.Row = [1 6];
            lOriginal=plot(ax,t,y,'k','DisplayName','Original Data'); title(ax,'Original Data and Envelope'); xlabel(ax,'Time (s)');

            lEnvelopeUpper=gobjects(1);
            lEnvelopeLower=gobjects(1);

            lReference = gobjects(1);


            function updateEnvelope(~,~)
                method = envelopeMethodDropdown.Value;
                windowLength = WindowLengthEdit.Value;
                windowLengthSamples=round(windowLength*fs);
                delete([lEnvelopeUpper lEnvelopeLower lReference]);

                set([referenceMethodDropdown referenceMethodLabel windowDirectionDropdown windowDirectionLabel],'Visible',~ismember(method,{'analytic','peak'}))

                if ~ismember(method,{'analytic', 'peak'})

                    switch windowDirectionDropdown.Value
                        case 'forward'
                            windowLengthSamples=[0 windowLengthSamples-1];
                        case 'backward'
                            windowLengthSamples=[windowLengthSamples-1 0];
                    end

                    switch referenceMethodDropdown.Value
                        case 'moving mean'
                            yReference=movmean(y,windowLengthSamples);
                        case 'moving median'
                            yReference=movmedian(y,windowLengthSamples);
                        case 'global median'
                            yReference=repmat(median(y),size(t));
                        case 'global mean'
                            yReference=repmat(mean(y),size(t));
                    end

                    plotReferenceLine=1;

                else
                    plotReferenceLine=0;

                end
                try



                    if ismember(method,{'analytic', 'peak'})
                        [yupper,ylower] = envelope(y,windowLengthSamples,method);
                    elseif strcmpi(method,'moving min/max')
                        [yupper] = movmax(y,windowLengthSamples);
                        [ylower] = movmin(y,windowLengthSamples);
                    elseif strcmpi(method,'moving abs. max')
                        [yupper] = movmax(abs(y-yReference),windowLengthSamples);

                        ylower = -yupper+yReference;
                        yupper = yupper+yReference;
                    elseif strcmpi(method,'moving mean of values above/below reference')
                        centered=y-yReference;
                        [yupper] = movmean(centered(centered>=0),windowLengthSamples,'SamplePoints',find(centered>=0));
                        [ylower] = movmean(centered(centered<=0),windowLengthSamples,'SamplePoints',find(centered<=0));

                        yupper = interp1(find(centered>=0),yupper,1:numel(centered),"makima",NaN);
                        ylower = interp1(find(centered<=0),ylower,1:numel(centered),"makima",NaN);


                        yupper = yupper(:)+yReference;
                        ylower = ylower(:)+yReference;
                    elseif strcmpi(method,'moving mean')
                        [yupper] = movmean(abs(y-yReference),windowLengthSamples);

                        ylower = -yupper+yReference;
                        yupper = yupper+yReference;
                    elseif strcmpi(method,'moving median of values above/below reference')
                        centered=y-yReference;
                        [yupper] = movmedian(centered(centered>=0),windowLengthSamples,'SamplePoints',find(centered>=0));
                        [ylower] = movmedian(centered(centered<=0),windowLengthSamples,'SamplePoints',find(centered<=0));

                        yupper = interp1(find(centered>=0),yupper,1:numel(centered),"makima",NaN);
                        ylower = interp1(find(centered<=0),ylower,1:numel(centered),"makima",NaN);


                        yupper = yupper(:)+yReference;
                        ylower = ylower(:)+yReference;
                    elseif strcmpi(method,'moving median')
                        [yupper] = movmedian(abs(y-yReference),windowLengthSamples);

                        ylower = -yupper+yReference;
                        yupper = yupper+yReference;
                    elseif strcmpi(method,'moving rms')
                        [yupper] = sqrt(movmean((y-yReference).^2,windowLengthSamples));

                        ylower = -yupper+yReference;
                        yupper = yupper+yReference;
                    elseif strcmpi(method,'moving rms of values above/below reference')
                        centered=y-yReference;
                        [yupper] = sqrt(movmean(centered(centered>=0).^2,windowLengthSamples,'SamplePoints',find(centered>=0)));
                        [ylower] = -sqrt(movmean(centered(centered<=0).^2,windowLengthSamples,'SamplePoints',find(centered<=0)));

                        yupper = interp1(find(centered>=0),yupper,1:numel(centered),"makima",NaN);
                        ylower = interp1(find(centered<=0),ylower,1:numel(centered),"makima",NaN);


                        yupper = yupper(:)+yReference;
                        ylower = ylower(:)+yReference;
                    elseif strcmpi(method,'moving STD of values above/below reference')
                        centered=y-yReference;
                        [yupper] = movstd(centered(centered>=0),windowLengthSamples,'SamplePoints',find(centered>=0));
                        [ylower] = -movstd(centered(centered<=0),windowLengthSamples,'SamplePoints',find(centered<=0));

                        yupper = interp1(find(centered>=0),yupper,1:numel(centered),"makima",NaN);
                        ylower = interp1(find(centered<=0),ylower,1:numel(centered),"makima",NaN);


                        yupper = yupper(:)+yReference;
                        ylower = ylower(:)+yReference;
                    elseif strcmpi(method,'moving STD')
                        [yupper] = movstd(abs(y-yReference),windowLengthSamples);

                        ylower = -yupper+yReference;
                        yupper = yupper+yReference;
                    end

                    lEnvelopeUpper=line(ax, t(~isnan(yupper)), yupper(~isnan(yupper)), 'Color','b','DisplayName','Upper Envelope');
                    lEnvelopeLower=line(ax, t(~isnan(ylower)), ylower(~isnan(ylower)), 'Color','r','DisplayName','Lower Envelope');

                    if plotReferenceLine
                        lReference=line(ax, t, yReference, 'Color','g','DisplayName','Center Reference');
                    end

                    combinedData=[ylower(:);yupper(:);y(:)];
                    ylim(ax, [min(combinedData) max(combinedData)]*1.2);

                    legend(ax,'Location','southoutside','Orientation','horizontal','NumColumns',3),
                catch ME
                    uiconfirm(fig,['Error: ' ME.message],'Erro','Icon','error');
                end
            end

            envelopeMethodDropdown.ValueChangedFcn      = @updateEnvelope;
            WindowLengthEdit.ValueChangedFcn    = @updateEnvelope;
            referenceMethodDropdown.ValueChangedFcn    = @updateEnvelope;
            windowDirectionDropdown.ValueChangedFcn    = @updateEnvelope;


            applyBtn.ButtonPushedFcn   = @(src, event) saveAndClose();

            updateEnvelope();

            drawnow;

            [outLowerX,outLowerY,outUpperX,outUpperY]=deal([]);

            function saveAndClose()
                envelopeMethod   = envelopeMethodDropdown.Value;
                windowLength         = WindowLengthEdit.Value;
                envelopeToAdd = whichEnvelopeToAddDropdown.Value;
                windowDirection = windowDirectionDropdown.Value;

                outLowerX=lEnvelopeLower.XData;
                outLowerY=lEnvelopeLower.YData;
                outUpperX=lEnvelopeUpper.XData;
                outUpperY=lEnvelopeUpper.YData;

                windowClosedByApply=1;
                delete(fig);
            end

            uiwait(fig);

            if ~windowClosedByApply || windowLength==0, return; end


            skipStuff=0;
            if strcmpi(envelopeToAdd,'both')
                skipStuff=1;
                app.plottingPanel.Visible='off';
            end

            if ~strcmpi(envelopeToAdd,'lower')
                newTitle = [app.channelNames{channelNr} 'upper envelope method (' envelopeMethod '), window length ' num2str(windowLength,'%f')  ' s, ' windowDirection ];
                app.addSingleChannelData(outUpperY, outUpperX, newTitle, 'Raw',skipStuff);
            end
            if ~strcmpi(envelopeToAdd,'upper')
                newTitle = [app.channelNames{channelNr} 'lower envelope method (' envelopeMethod '), window length ' num2str(windowLength,'%f')  ' s, ' windowDirection ];
                app.addSingleChannelData(outLowerY, outLowerX, newTitle, 'Raw',skipStuff);
            end

            if strcmpi(envelopeToAdd,'both')
                app.plottingPanel.Visible='on';
                drawnow;
                app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(0);
            end


        end

        function openPraatAnalysisWindow(app, channelNr)
            % openPraatAnalysisWindow_ForApp  GUI for selecting and running Praat analyses
            %
            %
            %   Runs as a modal GUI within the Vocaliscope app for the given channel.
            %   Results are added as new channels via app.addSingleChannelData()
            %   when the user clicks "Apply & Close".
            %
            %   openPraatAnalysisWindow()  - demo mode with synthetic audio
            %   openPraatAnalysisWindow(app, channelNr)  - app mode

            %% Demo mode: generate synthetic audio when called without arguments
            if nargin == 0
                fs = 16000;
                t = (0:1/fs:1)';
                y = sin(2*pi*440*t) + 0.3*sin(2*pi*880*t) + 0.05*randn(size(t));
                y = y / max(abs(y));
                app = struct('channelSampleRates', fs);
                app.channelYValues = {y};
                app.channelXValues = {t};
                app.channelNames = {'Demo_Channel'};
                app.addSingleChannelData = @(val,time,label,type)disp(['Would add channel: ' label]);
                channelNr = 1;
            end
            fs = app.channelSampleRates(channelNr);
            y  = app.channelYValues{channelNr}(:);
            t  = app.channelXValues{channelNr}(:);
            channelName = app.channelNames{channelNr};

            %% Persistent settings
            persistent pAnalysisType pFillMissing
            persistent pPitchMethod pPitchFloor pPitchCeiling pPitchTimeStep
            persistent pPitchMaxCandidates pPitchVeryAccurate pPitchAttenuationAtTop
            persistent pPitchSilenceThreshold pPitchVoicingThreshold
            persistent pPitchOctaveCost pPitchOctaveJumpCost pPitchVuvCost
            persistent pShsFreqMax pShsMaxSubharm pShsCompression pShsPointsPerOctave
            persistent pSpinetWinLen pSpinetFBmin pSpinetFBmax pSpinetFBnum
            persistent pPPmethod pPPselectMax pPPselectMin
            persistent pJitterShortPeriod pJitterLongPeriod pJitterMaxFactor
            persistent pJitterWinLen pJitterWinStep
            persistent pShimmerMaxAmpFactor
            persistent pFmtMethod pFmtMaxFormants pFmtCeiling pFmtWinLen pFmtPreEmph
            persistent pFmtRobustStd pFmtRobustIter pFmtRobustTol
            persistent pFmtTrack pFmtTrackN pFmtRef1 pFmtRef2 pFmtRef3 pFmtRef4 pFmtRef5
            persistent pFmtFreqCost pFmtBandCost pFmtTransCost
            persistent pIntMinPitch pIntWinLen pIntSubMean
            persistent pHnrTimeStep pHnrPitchFloor pHnrSilence pHnrPeriods
            persistent pHnrGNEmin pHnrGNEmax pHnrGNEBW pHnrGNEStep
            persistent pCppPitchFloor pCppTimeStep pCppMaxFreq pCppPreEmph
            persistent pCppRemoveTrend pCppTimeAvg pCppQuefAvg
            persistent pCppPeakFmin pCppPeakFmax pCppPeakPreEmph pCppPeakInterp
            persistent pCppTrendLow pCppTrendHigh pCppTrendType pCppFitMethod

            if isempty(pAnalysisType)
                pAnalysisType = 'Pitch';
                pFillMissing = 'next';
                pPitchMethod = 'filtered_ac';
                pPitchFloor = 75;  pPitchCeiling = 600;  pPitchTimeStep = 0.0;
                pPitchMaxCandidates = 15;  pPitchVeryAccurate = 'off';
                pPitchAttenuationAtTop = 0.03;
                pPitchSilenceThreshold = 0.03;  pPitchVoicingThreshold = 0.45;
                pPitchOctaveCost = 0.01;  pPitchOctaveJumpCost = 0.35;
                pPitchVuvCost = 0.14;
                pShsFreqMax = 1250;  pShsMaxSubharm = 15;
                pShsCompression = 0.84;  pShsPointsPerOctave = 48;
                pSpinetWinLen = 0.04;  pSpinetFBmin = 70;
                pSpinetFBmax = 5000;  pSpinetFBnum = 250;
                pPPmethod = 'periodic_cc';
                pPPselectMax = 'yes';  pPPselectMin = 'no';
                pJitterShortPeriod = 0.0001;  pJitterLongPeriod = 0.02;
                pJitterMaxFactor = 1.3;  pJitterWinLen = 0;  pJitterWinStep = 0;
                pShimmerMaxAmpFactor = 1.6;
                pFmtMethod = 'burg';  pFmtMaxFormants = 5;  pFmtCeiling = 5500;
                pFmtWinLen = 0.025;  pFmtPreEmph = 50;
                pFmtRobustStd = 1.5;  pFmtRobustIter = 5;  pFmtRobustTol = 1e-6;
                pFmtTrack = 'yes';  pFmtTrackN = 3;
                pFmtRef1 = 550;  pFmtRef2 = 1650;  pFmtRef3 = 2750;
                pFmtRef4 = 3850;  pFmtRef5 = 4950;
                pFmtFreqCost = 1;  pFmtBandCost = 1;  pFmtTransCost = 1;
                pIntMinPitch = 100;  pIntWinLen = 0;  pIntSubMean = 'yes';
                pHnrTimeStep = 0.01;  pHnrPitchFloor = 75;
                pHnrSilence = 0.1;  pHnrPeriods = 4.5;
                pHnrGNEmin = 500;  pHnrGNEmax = 4500;
                pHnrGNEBW = 1000;  pHnrGNEStep = 80;
                pCppPitchFloor = 60;  pCppTimeStep = 0.002;
                pCppMaxFreq = 5000;  pCppPreEmph = 50;
                pCppRemoveTrend = 'yes';  pCppTimeAvg = 0.02;
                pCppQuefAvg = 0.0005;  pCppPeakFmin = 60;  pCppPeakFmax = 330;
                pCppPeakPreEmph = 0.05;  pCppPeakInterp = 'parabolic';
                pCppTrendLow = 0.001;  pCppTrendHigh = 0.05;
                pCppTrendType = 'Exponential decay';  pCppFitMethod = 'Robust slow';
            end

            %% Create figure
            fig = uifigure('Units', 'pixels', 'Position', [50 0 1100 700], ...
                'Visible', 'off', 'Name', 'Praat Analysis', ...
                'Theme', 'light', 'WindowStyle', 'normal','WindowState','maximized', ...
                'CloseRequestFcn', @(s,e) uiresume(s));
            %movegui(fig, 'center');
            drawnow;
            fig.Visible = 'on';
            windowClosedByApply = false;

            % Main grid: left controls, right preview
            gl = uigridlayout(fig, [1 2], 'ColumnWidth', {350, '1x'}, ...
                'Padding', [8 8 8 8], 'RowSpacing', 5, 'ColumnSpacing', 8);

            %% -- LEFT PANEL: Controls (scrollable) + button footer --
            leftGrid = uigridlayout(gl, [2 1],         'RowHeight', {'1x', 'fit'}, ...
                'Padding', [0 0 0 0], 'RowSpacing', 0);
            leftGrid.Layout.Column = 1;

            innerGl = uigridlayout(leftGrid, [200 2], ...
                'RowHeight', repmat({'fit'}, 1, 200), ...
                'ColumnWidth', {'1x', '1x'}, ...
                'RowSpacing', 3, 'ColumnSpacing', 6, 'Padding', [5 5 5 20], ...
                'Scrollable', 'on');
            innerGl.Layout.Row = 1;

            buttonGl = uigridlayout(leftGrid, [2 2], ...
                'RowHeight', {'fit', 'fit'}, ...
                'ColumnWidth', {'1x', '1x'}, ...
                'Padding', [5 5 5 5], 'RowSpacing', 3);
            buttonGl.Layout.Row = 2;

            row = 1;

            % --- Settings header ---
            settingsHdr = uilabel(innerGl, 'Text', 'Settings', 'FontWeight', 'bold');
            settingsHdr.Layout.Row = row;  settingsHdr.Layout.Column = [1 2];  row = row+1;

            % --- Analysis Type ---
            analysisLabel = uilabel(innerGl, 'Text', 'Analysis Type', 'FontWeight', 'bold');
            analysisLabel.Layout.Row = row;  analysisLabel.Layout.Column = [1 2];  row = row+1;

            analysisTypes = {'Pitch', 'PointProcess', 'Jitter', 'Shimmer', ...
                'Formant', 'Intensity', 'Harmonicity (HNR/GNE)', 'CPP/CPPS'};
            analysisDd = uidropdown(innerGl, 'Items', analysisTypes, 'Value', pAnalysisType, ...
                'ValueChangedFcn', @(s,e) onAnalysisTypeChange());
            analysisDd.Layout.Row = row;  analysisDd.Layout.Column = [1 2];  row = row+1;

            sepLabel = uilabel(innerGl, 'Text', '');
            sepLabel.Layout.Row = row;  sepLabel.Layout.Column = [1 2];  row = row+1;

            % ====== PITCH SECTION ======
            pitchSecLabel = uilabel(innerGl, 'Text', '--- Pitch Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            pitchSecLabel.Layout.Row = row;  pitchSecLabel.Layout.Column = [1 2];  row = row+1;

            pitchMethodLabel = uilabel(innerGl, 'Text', 'Pitch Method');
            pitchMethodLabel.Layout.Row = row;  pitchMethodLabel.Layout.Column = 1;
            pitchMethodDd = uidropdown(innerGl, ...
                'Items', {'filtered AC', 'raw AC', ...
                'raw CC', 'filtered CC', ...
                'SHS', 'SPINET'}, ...
                'ItemsData', {'filtered_ac', 'ac', ...
                'cc', 'filtered_cc', ...
                'shs', 'spinet'}, ...
                'Value', pPitchMethod);
            pitchMethodDd.Layout.Row = row;  pitchMethodDd.Layout.Column = 2;  row = row+1;

            pitchFloorLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
            pitchFloorLabel.Layout.Row = row;  pitchFloorLabel.Layout.Column = 1;
            pitchFloorEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchFloor, ...
                'Limits', [20 2000], 'ValueDisplayFormat', '%.0f');
            pitchFloorEdit.Layout.Row = row;  pitchFloorEdit.Layout.Column = 2;  row = row+1;

            pitchCeilingLabel = uilabel(innerGl, 'Text', 'Pitch Ceiling (Hz)');
            pitchCeilingLabel.Layout.Row = row;  pitchCeilingLabel.Layout.Column = 1;
            pitchCeilingEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchCeiling, ...
                'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
            pitchCeilingEdit.Layout.Row = row;  pitchCeilingEdit.Layout.Column = 2;  row = row+1;

            pitchTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
            pitchTimeStepLabel.Layout.Row = row;  pitchTimeStepLabel.Layout.Column = 1;
            pitchTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchTimeStep, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
            pitchTimeStepEdit.Layout.Row = row;  pitchTimeStepEdit.Layout.Column = 2;  row = row+1;
            set([pitchTimeStepLabel pitchTimeStepEdit], 'Tooltip', '0 = auto');

            pitchVeryAccLabel = uilabel(innerGl, 'Text', 'Very Accurate');
            pitchVeryAccLabel.Layout.Row = row;  pitchVeryAccLabel.Layout.Column = 1;
            pitchVeryAccDd = uidropdown(innerGl, 'Items', {'yes (on)', 'no (off)'}, ...
                'ItemsData', {'on', 'off'}, 'Value', pPitchVeryAccurate);
            pitchVeryAccDd.Layout.Row = row;  pitchVeryAccDd.Layout.Column = 2;  row = row+1;

            pitchAttTopLabel = uilabel(innerGl, 'Text', 'Attenuation at Top');
            pitchAttTopLabel.Layout.Row = row;  pitchAttTopLabel.Layout.Column = 1;
            pitchAttTopEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchAttenuationAtTop, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.3f');
            pitchAttTopEdit.Layout.Row = row;  pitchAttTopEdit.Layout.Column = 2;  row = row+1;
            set([pitchAttTopLabel pitchAttTopEdit], 'Tooltip', 'Filtered methods only');

            pitchSilenceLabel = uilabel(innerGl, 'Text', 'Silence Threshold');
            pitchSilenceLabel.Layout.Row = row;  pitchSilenceLabel.Layout.Column = 1;
            pitchSilenceEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchSilenceThreshold, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            pitchSilenceEdit.Layout.Row = row;  pitchSilenceEdit.Layout.Column = 2;  row = row+1;

            pitchVoicingLabel = uilabel(innerGl, 'Text', 'Voicing Threshold');
            pitchVoicingLabel.Layout.Row = row;  pitchVoicingLabel.Layout.Column = 1;
            pitchVoicingEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchVoicingThreshold, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            pitchVoicingEdit.Layout.Row = row;  pitchVoicingEdit.Layout.Column = 2;  row = row+1;

            pitchOctCostLabel = uilabel(innerGl, 'Text', 'Octave Cost');
            pitchOctCostLabel.Layout.Row = row;  pitchOctCostLabel.Layout.Column = 1;
            pitchOctCostEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchOctaveCost, ...
                'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            pitchOctCostEdit.Layout.Row = row;  pitchOctCostEdit.Layout.Column = 2;  row = row+1;

            pitchOctJumpLabel = uilabel(innerGl, 'Text', 'Octave-Jump Cost');
            pitchOctJumpLabel.Layout.Row = row;  pitchOctJumpLabel.Layout.Column = 1;
            pitchOctJumpEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchOctaveJumpCost, ...
                'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            pitchOctJumpEdit.Layout.Row = row;  pitchOctJumpEdit.Layout.Column = 2;  row = row+1;

            pitchVuvLabel = uilabel(innerGl, 'Text', 'Voiced/Unvoiced Cost');
            pitchVuvLabel.Layout.Row = row;  pitchVuvLabel.Layout.Column = 1;
            pitchVuvEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchVuvCost, ...
                'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            pitchVuvEdit.Layout.Row = row;  pitchVuvEdit.Layout.Column = 2;  row = row+1;

            pitchMaxCandLabel = uilabel(innerGl, 'Text', 'Max Candidates');
            pitchMaxCandLabel.Layout.Row = row;  pitchMaxCandLabel.Layout.Column = 1;
            pitchMaxCandEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchMaxCandidates, ...
                'Limits', [1 30], 'ValueDisplayFormat', '%d');
            pitchMaxCandEdit.Layout.Row = row;  pitchMaxCandEdit.Layout.Column = 2;  row = row+1;

            % SHS-specific
            shsFreqMaxLabel = uilabel(innerGl, 'Text', 'SHS Max Frequency (Hz)');
            shsFreqMaxLabel.Layout.Row = row;  shsFreqMaxLabel.Layout.Column = 1;
            shsFreqMaxEdit = uieditfield(innerGl, 'numeric', 'Value', pShsFreqMax, ...
                'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
            shsFreqMaxEdit.Layout.Row = row;  shsFreqMaxEdit.Layout.Column = 2;  row = row+1;

            shsMaxSubLabel = uilabel(innerGl, 'Text', 'SHS Max Subharmonics');
            shsMaxSubLabel.Layout.Row = row;  shsMaxSubLabel.Layout.Column = 1;
            shsMaxSubEdit = uieditfield(innerGl, 'numeric', 'Value', pShsMaxSubharm, ...
                'Limits', [1 100], 'ValueDisplayFormat', '%d');
            shsMaxSubEdit.Layout.Row = row;  shsMaxSubEdit.Layout.Column = 2;  row = row+1;

            shsCompLabel = uilabel(innerGl, 'Text', 'SHS Compression');
            shsCompLabel.Layout.Row = row;  shsCompLabel.Layout.Column = 1;
            shsCompEdit = uieditfield(innerGl, 'numeric', 'Value', pShsCompression, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            shsCompEdit.Layout.Row = row;  shsCompEdit.Layout.Column = 2;  row = row+1;

            shsPointsOctLabel = uilabel(innerGl, 'Text', 'SHS Points/Octave');
            shsPointsOctLabel.Layout.Row = row;  shsPointsOctLabel.Layout.Column = 1;
            shsPointsOctEdit = uieditfield(innerGl, 'numeric', 'Value', pShsPointsPerOctave, ...
                'Limits', [1 500], 'ValueDisplayFormat', '%d');
            shsPointsOctEdit.Layout.Row = row;  shsPointsOctEdit.Layout.Column = 2;  row = row+1;

            % SPINET-specific
            spinetWinLabel = uilabel(innerGl, 'Text', 'SPINET Window (s)');
            spinetWinLabel.Layout.Row = row;  spinetWinLabel.Layout.Column = 1;
            spinetWinEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetWinLen, ...
                'Limits', [0.001 1], 'ValueDisplayFormat', '%.3f');
            spinetWinEdit.Layout.Row = row;  spinetWinEdit.Layout.Column = 2;  row = row+1;

            spinetFBminLabel = uilabel(innerGl, 'Text', 'SPINET Gammatone Min (Hz)');
            spinetFBminLabel.Layout.Row = row;  spinetFBminLabel.Layout.Column = 1;
            spinetFBminEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBmin, ...
                'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
            spinetFBminEdit.Layout.Row = row;  spinetFBminEdit.Layout.Column = 2;  row = row+1;

            spinetFBmaxLabel = uilabel(innerGl, 'Text', 'SPINET Gammatone Max (Hz)');
            spinetFBmaxLabel.Layout.Row = row;  spinetFBmaxLabel.Layout.Column = 1;
            spinetFBmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBmax, ...
                'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
            spinetFBmaxEdit.Layout.Row = row;  spinetFBmaxEdit.Layout.Column = 2;  row = row+1;

            spinetFBnumLabel = uilabel(innerGl, 'Text', 'SPINET Num Filters');
            spinetFBnumLabel.Layout.Row = row;  spinetFBnumLabel.Layout.Column = 1;
            spinetFBnumEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBnum, ...
                'Limits', [1 1000], 'ValueDisplayFormat', '%d');
            spinetFBnumEdit.Layout.Row = row;  spinetFBnumEdit.Layout.Column = 2;  row = row+1;

            % Fill missing (all pitch-based methods)
            fillMissLabel = uilabel(innerGl, 'Text', 'Fill Missing');
            fillMissLabel.Layout.Row = row;  fillMissLabel.Layout.Column = 1;
            fillMissDd = uidropdown(innerGl, ...
                'Items', {'previous', 'next', 'nearest', 'linear', 'spline', 'pchip', 'makima', 'zero'}, ...
                'Value', pFillMissing);
            fillMissDd.Layout.Row = row;  fillMissDd.Layout.Column = 2;  row = row+1;

            sep2Label = uilabel(innerGl, 'Text', '');
            sep2Label.Layout.Row = row;  sep2Label.Layout.Column = [1 2];  row = row+1;

            % ====== POINTPROCESS SECTION ======
            ppSecLabel = uilabel(innerGl, 'Text', '--- PointProcess Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            ppSecLabel.Layout.Row = row;  ppSecLabel.Layout.Column = [1 2];  row = row+1;

            ppMethodLabel = uilabel(innerGl, 'Text', 'PointProcess Method');
            ppMethodLabel.Layout.Row = row;  ppMethodLabel.Layout.Column = 1;
            ppMethodDd = uidropdown(innerGl, ...
                'Items', {'periodic CC (sound+pitch)', 'periodic peaks (sound+pitch)', ...
                'pitch only', 'extrema', 'periodic direct'}, ...
                'ItemsData', {'periodic_cc', 'periodic_peaks', 'pitch_only', 'extrema', 'periodic_direct'}, ...
                'Value', pPPmethod);
            ppMethodDd.Layout.Row = row;  ppMethodDd.Layout.Column = 2;  row = row+1;

            ppSelectMaxLabel = uilabel(innerGl, 'Text', 'Select Maxima (peaks)');
            ppSelectMaxLabel.Layout.Row = row;  ppSelectMaxLabel.Layout.Column = 1;
            ppSelectMaxDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pPPselectMax);
            ppSelectMaxDd.Layout.Row = row;  ppSelectMaxDd.Layout.Column = 2;  row = row+1;

            ppSelectMinLabel = uilabel(innerGl, 'Text', 'Select Minima (peaks)');
            ppSelectMinLabel.Layout.Row = row;  ppSelectMinLabel.Layout.Column = 1;
            ppSelectMinDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pPPselectMin);
            ppSelectMinDd.Layout.Row = row;  ppSelectMinDd.Layout.Column = 2;  row = row+1;

            sep3Label = uilabel(innerGl, 'Text', '');
            sep3Label.Layout.Row = row;  sep3Label.Layout.Column = [1 2];  row = row+1;

            % ====== JITTER / SHIMMER SECTION ======
            jitterSecLabel = uilabel(innerGl, 'Text', '--- Jitter / Shimmer Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            jitterSecLabel.Layout.Row = row;  jitterSecLabel.Layout.Column = [1 2];  row = row+1;

            jitterShortLabel = uilabel(innerGl, 'Text', 'Shortest Period (s)');
            jitterShortLabel.Layout.Row = row;  jitterShortLabel.Layout.Column = 1;
            jitterShortEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterShortPeriod, ...
                'Limits', [1e-6 0.1], 'ValueDisplayFormat', '%.6f');
            jitterShortEdit.Layout.Row = row;  jitterShortEdit.Layout.Column = 2;  row = row+1;

            jitterLongLabel = uilabel(innerGl, 'Text', 'Longest Period (s)');
            jitterLongLabel.Layout.Row = row;  jitterLongLabel.Layout.Column = 1;
            jitterLongEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterLongPeriod, ...
                'Limits', [0.001 1], 'ValueDisplayFormat', '%.4f');
            jitterLongEdit.Layout.Row = row;  jitterLongEdit.Layout.Column = 2;  row = row+1;

            jitterMaxFactorLabel = uilabel(innerGl, 'Text', 'Max Period Factor');
            jitterMaxFactorLabel.Layout.Row = row;  jitterMaxFactorLabel.Layout.Column = 1;
            jitterMaxFactorEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterMaxFactor, ...
                'Limits', [1 10], 'ValueDisplayFormat', '%.2f');
            jitterMaxFactorEdit.Layout.Row = row;  jitterMaxFactorEdit.Layout.Column = 2;  row = row+1;

            jitterWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
            jitterWinLenLabel.Layout.Row = row;  jitterWinLenLabel.Layout.Column = 1;
            jitterWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterWinLen, ...
                'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            jitterWinLenEdit.Layout.Row = row;  jitterWinLenEdit.Layout.Column = 2;  row = row+1;
            set([jitterWinLenLabel jitterWinLenEdit], 'Tooltip', '0 = entire range');

            jitterWinStepLabel = uilabel(innerGl, 'Text', 'Window Step (s)');
            jitterWinStepLabel.Layout.Row = row;  jitterWinStepLabel.Layout.Column = 1;
            jitterWinStepEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterWinStep, ...
                'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
            jitterWinStepEdit.Layout.Row = row;  jitterWinStepEdit.Layout.Column = 2;  row = row+1;

            shimmerAmpMaxLabel = uilabel(innerGl, 'Text', 'Max Amplitude Factor');
            shimmerAmpMaxLabel.Layout.Row = row;  shimmerAmpMaxLabel.Layout.Column = 1;
            shimmerAmpMaxEdit = uieditfield(innerGl, 'numeric', 'Value', pShimmerMaxAmpFactor, ...
                'Limits', [1 10], 'ValueDisplayFormat', '%.2f');
            shimmerAmpMaxEdit.Layout.Row = row;  shimmerAmpMaxEdit.Layout.Column = 2;  row = row+1;

            sep4Label = uilabel(innerGl, 'Text', '');
            sep4Label.Layout.Row = row;  sep4Label.Layout.Column = [1 2];  row = row+1;

            % ====== FORMANT SECTION ======
            fmtSecLabel = uilabel(innerGl, 'Text', '--- Formant Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            fmtSecLabel.Layout.Row = row;  fmtSecLabel.Layout.Column = [1 2];  row = row+1;

            fmtMethodLabel = uilabel(innerGl, 'Text', 'Formant Method');
            fmtMethodLabel.Layout.Row = row;  fmtMethodLabel.Layout.Column = 1;
            fmtMethodDd = uidropdown(innerGl, 'Items', {'Burg', 'Keep all', 'Willems', 'Robust'}, ...
                'ItemsData', {'burg', 'keepall', 'willems', 'robust'}, 'Value', pFmtMethod);
            fmtMethodDd.Layout.Row = row;  fmtMethodDd.Layout.Column = 2;  row = row+1;

            fmtMaxFormantsLabel = uilabel(innerGl, 'Text', 'Max # Formants');
            fmtMaxFormantsLabel.Layout.Row = row;  fmtMaxFormantsLabel.Layout.Column = 1;
            fmtMaxFormantsEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtMaxFormants, ...
                'Limits', [1 10], 'ValueDisplayFormat', '%d');
            fmtMaxFormantsEdit.Layout.Row = row;  fmtMaxFormantsEdit.Layout.Column = 2;  row = row+1;

            fmtCeilingLabel = uilabel(innerGl, 'Text', 'Ceiling (Hz)');
            fmtCeilingLabel.Layout.Row = row;  fmtCeilingLabel.Layout.Column = 1;
            fmtCeilingEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtCeiling, ...
                'Limits', [500 fs/2], 'ValueDisplayFormat', '%.0f');
            fmtCeilingEdit.Layout.Row = row;  fmtCeilingEdit.Layout.Column = 2;  row = row+1;

            fmtWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
            fmtWinLenLabel.Layout.Row = row;  fmtWinLenLabel.Layout.Column = 1;
            fmtWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtWinLen, ...
                'Limits', [0.001 1], 'ValueDisplayFormat', '%.4f');
            fmtWinLenEdit.Layout.Row = row;  fmtWinLenEdit.Layout.Column = 2;  row = row+1;

            fmtPreEmphLabel = uilabel(innerGl, 'Text', 'Pre-Emphasis (Hz)');
            fmtPreEmphLabel.Layout.Row = row;  fmtPreEmphLabel.Layout.Column = 1;
            fmtPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtPreEmph, ...
                'Limits', [0 fs/2], 'ValueDisplayFormat', '%.0f');
            fmtPreEmphEdit.Layout.Row = row;  fmtPreEmphEdit.Layout.Column = 2;  row = row+1;

            fmtRobustStdLabel = uilabel(innerGl, 'Text', 'Robust # StdDev');
            fmtRobustStdLabel.Layout.Row = row;  fmtRobustStdLabel.Layout.Column = 1;
            fmtRobustStdEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustStd, ...
                'Limits', [0.1 10], 'ValueDisplayFormat', '%.1f');
            fmtRobustStdEdit.Layout.Row = row;  fmtRobustStdEdit.Layout.Column = 2;  row = row+1;
            set([fmtRobustStdLabel fmtRobustStdEdit], 'Tooltip', 'Robust method only');

            fmtRobustIterLabel = uilabel(innerGl, 'Text', 'Robust Iterations');
            fmtRobustIterLabel.Layout.Row = row;  fmtRobustIterLabel.Layout.Column = 1;
            fmtRobustIterEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustIter, ...
                'Limits', [1 100], 'ValueDisplayFormat', '%d');
            fmtRobustIterEdit.Layout.Row = row;  fmtRobustIterEdit.Layout.Column = 2;  row = row+1;

            fmtRobustTolLabel = uilabel(innerGl, 'Text', 'Robust Tolerance');
            fmtRobustTolLabel.Layout.Row = row;  fmtRobustTolLabel.Layout.Column = 1;
            fmtRobustTolEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustTol, ...
                'Limits', [1e-12 1], 'ValueDisplayFormat', '%.1e');
            fmtRobustTolEdit.Layout.Row = row;  fmtRobustTolEdit.Layout.Column = 2;  row = row+1;

            % Formant Tracking
            fmtTrackLabel = uilabel(innerGl, 'Text', 'Track Formants');
            fmtTrackLabel.Layout.Row = row;  fmtTrackLabel.Layout.Column = 1;
            fmtTrackDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pFmtTrack);
            fmtTrackDd.Layout.Row = row;  fmtTrackDd.Layout.Column = 2;  row = row+1;

            fmtTrackNLabel = uilabel(innerGl, 'Text', 'Num Tracks');
            fmtTrackNLabel.Layout.Row = row;  fmtTrackNLabel.Layout.Column = 1;
            fmtTrackNEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtTrackN, ...
                'Limits', [1 5], 'ValueDisplayFormat', '%d');
            fmtTrackNEdit.Layout.Row = row;  fmtTrackNEdit.Layout.Column = 2;  row = row+1;

            fmtRef1Label = uilabel(innerGl, 'Text', 'Ref F1 (Hz)');
            fmtRef1Label.Layout.Row = row;  fmtRef1Label.Layout.Column = 1;
            fmtRef1Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef1, ...
                'Limits', [50 2000], 'ValueDisplayFormat', '%.0f');
            fmtRef1Edit.Layout.Row = row;  fmtRef1Edit.Layout.Column = 2;  row = row+1;

            fmtRef2Label = uilabel(innerGl, 'Text', 'Ref F2 (Hz)');
            fmtRef2Label.Layout.Row = row;  fmtRef2Label.Layout.Column = 1;
            fmtRef2Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef2, ...
                'Limits', [100 5000], 'ValueDisplayFormat', '%.0f');
            fmtRef2Edit.Layout.Row = row;  fmtRef2Edit.Layout.Column = 2;  row = row+1;

            fmtRef3Label = uilabel(innerGl, 'Text', 'Ref F3 (Hz)');
            fmtRef3Label.Layout.Row = row;  fmtRef3Label.Layout.Column = 1;
            fmtRef3Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef3, ...
                'Limits', [200 8000], 'ValueDisplayFormat', '%.0f');
            fmtRef3Edit.Layout.Row = row;  fmtRef3Edit.Layout.Column = 2;  row = row+1;

            fmtRef4Label = uilabel(innerGl, 'Text', 'Ref F4 (Hz)');
            fmtRef4Label.Layout.Row = row;  fmtRef4Label.Layout.Column = 1;
            fmtRef4Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef4, ...
                'Limits', [300 10000], 'ValueDisplayFormat', '%.0f');
            fmtRef4Edit.Layout.Row = row;  fmtRef4Edit.Layout.Column = 2;  row = row+1;

            fmtRef5Label = uilabel(innerGl, 'Text', 'Ref F5 (Hz)');
            fmtRef5Label.Layout.Row = row;  fmtRef5Label.Layout.Column = 1;
            fmtRef5Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef5, ...
                'Limits', [400 12000], 'ValueDisplayFormat', '%.0f');
            fmtRef5Edit.Layout.Row = row;  fmtRef5Edit.Layout.Column = 2;  row = row+1;

            fmtFreqCostLabel = uilabel(innerGl, 'Text', 'Frequency Cost (/kHz)');
            fmtFreqCostLabel.Layout.Row = row;  fmtFreqCostLabel.Layout.Column = 1;
            fmtFreqCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtFreqCost, ...
                'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
            fmtFreqCostEdit.Layout.Row = row;  fmtFreqCostEdit.Layout.Column = 2;  row = row+1;

            fmtBandCostLabel = uilabel(innerGl, 'Text', 'Bandwidth Cost');
            fmtBandCostLabel.Layout.Row = row;  fmtBandCostLabel.Layout.Column = 1;
            fmtBandCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtBandCost, ...
                'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
            fmtBandCostEdit.Layout.Row = row;  fmtBandCostEdit.Layout.Column = 2;  row = row+1;

            fmtTransCostLabel = uilabel(innerGl, 'Text', 'Transition Cost/Oct');
            fmtTransCostLabel.Layout.Row = row;  fmtTransCostLabel.Layout.Column = 1;
            fmtTransCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtTransCost, ...
                'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
            fmtTransCostEdit.Layout.Row = row;  fmtTransCostEdit.Layout.Column = 2;  row = row+1;

            sep5Label = uilabel(innerGl, 'Text', '');
            sep5Label.Layout.Row = row;  sep5Label.Layout.Column = [1 2];  row = row+1;

            % ====== INTENSITY SECTION ======
            intSecLabel = uilabel(innerGl, 'Text', '--- Intensity Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            intSecLabel.Layout.Row = row;  intSecLabel.Layout.Column = [1 2];  row = row+1;

            intMinPitchLabel = uilabel(innerGl, 'Text', 'Min Pitch (Hz)');
            intMinPitchLabel.Layout.Row = row;  intMinPitchLabel.Layout.Column = 1;
            intMinPitchEdit = uieditfield(innerGl, 'numeric', 'Value', pIntMinPitch, ...
                'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
            intMinPitchEdit.Layout.Row = row;  intMinPitchEdit.Layout.Column = 2;  row = row+1;

            intWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
            intWinLenLabel.Layout.Row = row;  intWinLenLabel.Layout.Column = 1;
            intWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pIntWinLen, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.3f');
            intWinLenEdit.Layout.Row = row;  intWinLenEdit.Layout.Column = 2;  row = row+1;
            set([intWinLenLabel intWinLenEdit], 'Tooltip', '0 = auto');

            intSubMeanLabel = uilabel(innerGl, 'Text', 'Subtract Mean');
            intSubMeanLabel.Layout.Row = row;  intSubMeanLabel.Layout.Column = 1;
            intSubMeanDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pIntSubMean);
            intSubMeanDd.Layout.Row = row;  intSubMeanDd.Layout.Column = 2;  row = row+1;

            sep6Label = uilabel(innerGl, 'Text', '');
            sep6Label.Layout.Row = row;  sep6Label.Layout.Column = [1 2];  row = row+1;

            % ====== HARMONICITY SECTION ======
            hnrSecLabel = uilabel(innerGl, 'Text', '--- Harmonicity Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            hnrSecLabel.Layout.Row = row;  hnrSecLabel.Layout.Column = [1 2];  row = row+1;

            hnrTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
            hnrTimeStepLabel.Layout.Row = row;  hnrTimeStepLabel.Layout.Column = 1;
            hnrTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrTimeStep, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
            hnrTimeStepEdit.Layout.Row = row;  hnrTimeStepEdit.Layout.Column = 2;  row = row+1;

            hnrPitchFloorLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
            hnrPitchFloorLabel.Layout.Row = row;  hnrPitchFloorLabel.Layout.Column = 1;
            hnrPitchFloorEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrPitchFloor, ...
                'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
            hnrPitchFloorEdit.Layout.Row = row;  hnrPitchFloorEdit.Layout.Column = 2;  row = row+1;

            hnrSilenceLabel = uilabel(innerGl, 'Text', 'Silence Threshold');
            hnrSilenceLabel.Layout.Row = row;  hnrSilenceLabel.Layout.Column = 1;
            hnrSilenceEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrSilence, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
            hnrSilenceEdit.Layout.Row = row;  hnrSilenceEdit.Layout.Column = 2;  row = row+1;

            hnrPeriodsLabel = uilabel(innerGl, 'Text', 'Periods / Window');
            hnrPeriodsLabel.Layout.Row = row;  hnrPeriodsLabel.Layout.Column = 1;
            hnrPeriodsEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrPeriods, ...
                'Limits', [1 20], 'ValueDisplayFormat', '%.1f');
            hnrPeriodsEdit.Layout.Row = row;  hnrPeriodsEdit.Layout.Column = 2;  row = row+1;

            sepHnrLabel = uilabel(innerGl, 'Text', '');
            sepHnrLabel.Layout.Row = row;  sepHnrLabel.Layout.Column = [1 2];  row = row+1;

            hnrGNELabel = uilabel(innerGl, 'Text', '--- GNE Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            hnrGNELabel.Layout.Row = row;  hnrGNELabel.Layout.Column = [1 2];  row = row+1;

            hnrGNEminLabel = uilabel(innerGl, 'Text', 'GNE Min Freq (Hz)');
            hnrGNEminLabel.Layout.Row = row;  hnrGNEminLabel.Layout.Column = 1;
            hnrGNEminEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEmin, ...
                'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
            hnrGNEminEdit.Layout.Row = row;  hnrGNEminEdit.Layout.Column = 2;  row = row+1;

            hnrGNEmaxLabel = uilabel(innerGl, 'Text', 'GNE Max Freq (Hz)');
            hnrGNEmaxLabel.Layout.Row = row;  hnrGNEmaxLabel.Layout.Column = 1;
            hnrGNEmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEmax, ...
                'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
            hnrGNEmaxEdit.Layout.Row = row;  hnrGNEmaxEdit.Layout.Column = 2;  row = row+1;

            hnrGNEBWLabel = uilabel(innerGl, 'Text', 'GNE Bandwidth (Hz)');
            hnrGNEBWLabel.Layout.Row = row;  hnrGNEBWLabel.Layout.Column = 1;
            hnrGNEBWEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEBW, ...
                'Limits', [10 10000], 'ValueDisplayFormat', '%.0f');
            hnrGNEBWEdit.Layout.Row = row;  hnrGNEBWEdit.Layout.Column = 2;  row = row+1;

            hnrGNEStepLabel = uilabel(innerGl, 'Text', 'GNE Step (Hz)');
            hnrGNEStepLabel.Layout.Row = row;  hnrGNEStepLabel.Layout.Column = 1;
            hnrGNEStepEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEStep, ...
                'Limits', [1 1000], 'ValueDisplayFormat', '%.0f');
            hnrGNEStepEdit.Layout.Row = row;  hnrGNEStepEdit.Layout.Column = 2;  row = row+1;

            sep7Label = uilabel(innerGl, 'Text', '');
            sep7Label.Layout.Row = row;  sep7Label.Layout.Column = [1 2];  row = row+1;

            % ====== CPP/CPPS SECTION ======
            cppSecLabel = uilabel(innerGl, 'Text', '--- CPP/CPPS Settings ---', ...
                'FontWeight', 'bold', 'FontAngle', 'italic');
            cppSecLabel.Layout.Row = row;  cppSecLabel.Layout.Column = [1 2];  row = row+1;

            cppPitchFLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
            cppPitchFLabel.Layout.Row = row;  cppPitchFLabel.Layout.Column = 1;
            cppPitchFEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPitchFloor, ...
                'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
            cppPitchFEdit.Layout.Row = row;  cppPitchFEdit.Layout.Column = 2;  row = row+1;

            cppTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
            cppTimeStepLabel.Layout.Row = row;  cppTimeStepLabel.Layout.Column = 1;
            cppTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTimeStep, ...
                'Limits', [0.0001 1], 'ValueDisplayFormat', '%.4f');
            cppTimeStepEdit.Layout.Row = row;  cppTimeStepEdit.Layout.Column = 2;  row = row+1;

            cppMaxFreqLabel = uilabel(innerGl, 'Text', 'Max Frequency (Hz)');
            cppMaxFreqLabel.Layout.Row = row;  cppMaxFreqLabel.Layout.Column = 1;
            cppMaxFreqEdit = uieditfield(innerGl, 'numeric', 'Value', pCppMaxFreq, ...
                'Limits', [100 fs/2], 'ValueDisplayFormat', '%.0f');
            cppMaxFreqEdit.Layout.Row = row;  cppMaxFreqEdit.Layout.Column = 2;  row = row+1;

            cppPreEmphLabel = uilabel(innerGl, 'Text', 'Pre-Emphasis (Hz)');
            cppPreEmphLabel.Layout.Row = row;  cppPreEmphLabel.Layout.Column = 1;
            cppPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPreEmph, ...
                'Limits', [0 fs/2], 'ValueDisplayFormat', '%.0f');
            cppPreEmphEdit.Layout.Row = row;  cppPreEmphEdit.Layout.Column = 2;  row = row+1;

            cppRemoveTrendLabel = uilabel(innerGl, 'Text', 'Remove Trend');
            cppRemoveTrendLabel.Layout.Row = row;  cppRemoveTrendLabel.Layout.Column = 1;
            cppRemoveTrendDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pCppRemoveTrend);
            cppRemoveTrendDd.Layout.Row = row;  cppRemoveTrendDd.Layout.Column = 2;  row = row+1;

            cppTimeAvgLabel = uilabel(innerGl, 'Text', 'Time Avg Window (s)');
            cppTimeAvgLabel.Layout.Row = row;  cppTimeAvgLabel.Layout.Column = 1;
            cppTimeAvgEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTimeAvg, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
            cppTimeAvgEdit.Layout.Row = row;  cppTimeAvgEdit.Layout.Column = 2;  row = row+1;

            cppQuefAvgLabel = uilabel(innerGl, 'Text', 'Quefrency Avg (s)');
            cppQuefAvgLabel.Layout.Row = row;  cppQuefAvgLabel.Layout.Column = 1;
            cppQuefAvgEdit = uieditfield(innerGl, 'numeric', 'Value', pCppQuefAvg, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.5f');
            cppQuefAvgEdit.Layout.Row = row;  cppQuefAvgEdit.Layout.Column = 2;  row = row+1;

            cppPeakFminLabel = uilabel(innerGl, 'Text', 'Peak Search f_min (Hz)');
            cppPeakFminLabel.Layout.Row = row;  cppPeakFminLabel.Layout.Column = 1;
            cppPeakFminEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakFmin, ...
                'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
            cppPeakFminEdit.Layout.Row = row;  cppPeakFminEdit.Layout.Column = 2;  row = row+1;

            cppPeakFmaxLabel = uilabel(innerGl, 'Text', 'Peak Search f_max (Hz)');
            cppPeakFmaxLabel.Layout.Row = row;  cppPeakFmaxLabel.Layout.Column = 1;
            cppPeakFmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakFmax, ...
                'Limits', [50 fs/2], 'ValueDisplayFormat', '%.0f');
            cppPeakFmaxEdit.Layout.Row = row;  cppPeakFmaxEdit.Layout.Column = 2;  row = row+1;

            cppPeakPreEmphLabel = uilabel(innerGl, 'Text', 'Peak Pre-Emphasis (Hz)');
            cppPeakPreEmphLabel.Layout.Row = row;  cppPeakPreEmphLabel.Layout.Column = 1;
            cppPeakPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakPreEmph, ...
                'Limits', [0 fs/2], 'ValueDisplayFormat', '%.2f');
            cppPeakPreEmphEdit.Layout.Row = row;  cppPeakPreEmphEdit.Layout.Column = 2;  row = row+1;

            cppPeakInterpLabel = uilabel(innerGl, 'Text', 'Peak Interpolation');
            cppPeakInterpLabel.Layout.Row = row;  cppPeakInterpLabel.Layout.Column = 1;
            cppPeakInterpDd = uidropdown(innerGl, ...
                'Items', {'none', 'parabolic', 'cubic', 'sinc70', 'sinc700'}, ...
                'Value', pCppPeakInterp);
            cppPeakInterpDd.Layout.Row = row;  cppPeakInterpDd.Layout.Column = 2;  row = row+1;

            cppTrendLowLabel = uilabel(innerGl, 'Text', 'Trend Lower Bound (s)');
            cppTrendLowLabel.Layout.Row = row;  cppTrendLowLabel.Layout.Column = 1;
            cppTrendLowEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTrendLow, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
            cppTrendLowEdit.Layout.Row = row;  cppTrendLowEdit.Layout.Column = 2;  row = row+1;

            cppTrendHighLabel = uilabel(innerGl, 'Text', 'Trend Upper Bound (s)');
            cppTrendHighLabel.Layout.Row = row;  cppTrendHighLabel.Layout.Column = 1;
            cppTrendHighEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTrendHigh, ...
                'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
            cppTrendHighEdit.Layout.Row = row;  cppTrendHighEdit.Layout.Column = 2;  row = row+1;

            cppTrendTypeLabel = uilabel(innerGl, 'Text', 'Trend Type');
            cppTrendTypeLabel.Layout.Row = row;  cppTrendTypeLabel.Layout.Column = 1;
            cppTrendTypeDd = uidropdown(innerGl, ...
                'Items', {'straight', 'Exponential decay'}, 'Value', pCppTrendType);
            cppTrendTypeDd.Layout.Row = row;  cppTrendTypeDd.Layout.Column = 2;  row = row+1;

            cppFitMethodLabel = uilabel(innerGl, 'Text', 'Fit Method');
            cppFitMethodLabel.Layout.Row = row;  cppFitMethodLabel.Layout.Column = 1;
            cppFitMethodDd = uidropdown(innerGl, ...
                'Items', {'Robust slow', 'Robust', 'Least squares'}, 'Value', pCppFitMethod);
            cppFitMethodDd.Layout.Row = row;  cppFitMethodDd.Layout.Column = 2;  row = row+1;

            resetBtn = uibutton(buttonGl, 'Text', 'Reset Parameters', 'WordWrap', 'on', ...
                'ButtonPushedFcn', @(s,e) resetParameters());
            resetBtn.Layout.Row = 1;  resetBtn.Layout.Column = 1;

            applyBtn = uibutton(buttonGl, 'Text', 'Apply && Close', 'FontWeight', 'bold', ...
                'ButtonPushedFcn', @(s,e) saveAndClose());
            applyBtn.Layout.Row = 1;  applyBtn.Layout.Column = 2;

            cancelBtn = uibutton(buttonGl, 'Text', 'Cancel', ...
                'ButtonPushedFcn', @(s,e) cancelAndClose());
            cancelBtn.Layout.Row = 2;  cancelBtn.Layout.Column = [1 2];

            %% -- RIGHT PANEL: Preview axes --
            rightPnl = uipanel(gl, 'Title', 'Preview', 'FontWeight', 'bold', ...
                'BorderType', 'none');
            rightPnl.Layout.Column = 2;
            % tiledlayout will be created dynamically inside rightPnl
            tl = [];
            ax = gobjects(0);

            %% COLLECT ALL CONTROL HANDLES (for visibility management)
            % Pitch group
            allPitchControls = [pitchMethodLabel pitchMethodDd ...
                pitchFloorLabel pitchFloorEdit pitchCeilingLabel pitchCeilingEdit ...
                pitchTimeStepLabel pitchTimeStepEdit ...
                pitchVeryAccLabel pitchVeryAccDd ...
                pitchAttTopLabel pitchAttTopEdit ...
                pitchSilenceLabel pitchSilenceEdit pitchVoicingLabel pitchVoicingEdit ...
                pitchOctCostLabel pitchOctCostEdit pitchOctJumpLabel pitchOctJumpEdit ...
                pitchVuvLabel pitchVuvEdit pitchMaxCandLabel pitchMaxCandEdit ...
                fillMissLabel fillMissDd];

            shsControls = [shsFreqMaxLabel shsFreqMaxEdit shsMaxSubLabel shsMaxSubEdit ...
                shsCompLabel shsCompEdit shsPointsOctLabel shsPointsOctEdit];

            spinetControls = [spinetWinLabel spinetWinEdit spinetFBminLabel spinetFBminEdit ...
                spinetFBmaxLabel spinetFBmaxEdit spinetFBnumLabel spinetFBnumEdit];

            filteredOnlyControls = [pitchAttTopLabel pitchAttTopEdit];

            ppControls = [ppSecLabel ppMethodLabel ppMethodDd ...
                ppSelectMaxLabel ppSelectMaxDd ppSelectMinLabel ppSelectMinDd];

            jitterControls = [jitterSecLabel jitterShortLabel jitterShortEdit ...
                jitterLongLabel jitterLongEdit jitterMaxFactorLabel jitterMaxFactorEdit ...
                jitterWinLenLabel jitterWinLenEdit jitterWinStepLabel jitterWinStepEdit];

            shimmerExtraControls = [shimmerAmpMaxLabel shimmerAmpMaxEdit];

            fmtControls = [fmtSecLabel fmtMethodLabel fmtMethodDd ...
                fmtMaxFormantsLabel fmtMaxFormantsEdit fmtCeilingLabel fmtCeilingEdit ...
                fmtWinLenLabel fmtWinLenEdit fmtPreEmphLabel fmtPreEmphEdit ...
                fmtRobustStdLabel fmtRobustStdEdit fmtRobustIterLabel fmtRobustIterEdit ...
                fmtRobustTolLabel fmtRobustTolEdit ...
                fmtTrackLabel fmtTrackDd fmtTrackNLabel fmtTrackNEdit ...
                fmtRef1Label fmtRef1Edit fmtRef2Label fmtRef2Edit ...
                fmtRef3Label fmtRef3Edit fmtRef4Label fmtRef4Edit ...
                fmtRef5Label fmtRef5Edit ...
                fmtFreqCostLabel fmtFreqCostEdit fmtBandCostLabel fmtBandCostEdit ...
                fmtTransCostLabel fmtTransCostEdit];

            intControls = [intSecLabel intMinPitchLabel intMinPitchEdit ...
                intWinLenLabel intWinLenEdit intSubMeanLabel intSubMeanDd];

            hnrControls = [hnrSecLabel hnrTimeStepLabel hnrTimeStepEdit ...
                hnrPitchFloorLabel hnrPitchFloorEdit hnrSilenceLabel hnrSilenceEdit ...
                hnrPeriodsLabel hnrPeriodsEdit ...
                hnrGNELabel hnrGNEminLabel hnrGNEminEdit hnrGNEmaxLabel hnrGNEmaxEdit ...
                hnrGNEBWLabel hnrGNEBWEdit hnrGNEStepLabel hnrGNEStepEdit];

            cppControls = [cppSecLabel cppPitchFLabel cppPitchFEdit ...
                cppTimeStepLabel cppTimeStepEdit cppMaxFreqLabel cppMaxFreqEdit ...
                cppPreEmphLabel cppPreEmphEdit cppRemoveTrendLabel cppRemoveTrendDd ...
                cppTimeAvgLabel cppTimeAvgEdit cppQuefAvgLabel cppQuefAvgEdit ...
                cppPeakFminLabel cppPeakFminEdit cppPeakFmaxLabel cppPeakFmaxEdit ...
                cppPeakPreEmphLabel cppPeakPreEmphEdit cppPeakInterpLabel cppPeakInterpDd ...
                cppTrendLowLabel cppTrendLowEdit cppTrendHighLabel cppTrendHighEdit ...
                cppTrendTypeLabel cppTrendTypeDd cppFitMethodLabel cppFitMethodDd];

            %% Apply initial visibility
            setVisibility();

            %% --- Callback: Analysis type changed ---
            function onAnalysisTypeChange()
                setVisibility();
                rebuildPreviewPanel();
                runAnalysis();
            end

            %% --- Visibility management ---
            function setVisibility()
                atype = analysisDd.Value;
                % Hide all method-specific sections
                allSections = [allPitchControls shsControls spinetControls ...
                    ppControls jitterControls shimmerExtraControls ...
                    fmtControls intControls hnrControls cppControls ...
                    pitchSecLabel sepLabel sep2Label sep3Label sep4Label ...
                    sep5Label sep6Label sep7Label sepHnrLabel];
                set(allSections, 'Visible', 'off');

                pitchSecLabel.Visible = 'on';
                set(allPitchControls, 'Visible', 'on');

                switch atype
                    case 'Pitch'
                        % Show pitch section + SHS/SPINET sub-controls
                        pitchSecLabel.Visible = 'on';
                        set(allPitchControls, 'Visible', 'on');
                        updatePitchSubVisibility();

                    case 'PointProcess'
                        pitchSecLabel.Visible = 'on';
                        set(allPitchControls, 'Visible', 'on');
                        set(ppControls, 'Visible', 'on');
                        updatePitchSubVisibility();

                    case 'Jitter'
                        pitchSecLabel.Visible = 'on';
                        set(allPitchControls, 'Visible', 'on');
                        set(ppControls, 'Visible', 'on');
                        set(jitterControls, 'Visible', 'on');
                        updatePitchSubVisibility();

                    case 'Shimmer'
                        pitchSecLabel.Visible = 'on';
                        set(allPitchControls, 'Visible', 'on');
                        set(ppControls, 'Visible', 'on');
                        set(jitterControls, 'Visible', 'on');
                        set(shimmerExtraControls, 'Visible', 'on');
                        updatePitchSubVisibility();

                    case 'Formant'
                        set(fmtControls, 'Visible', 'on');

                    case 'Intensity'
                        set(intControls, 'Visible', 'on');

                    case 'Harmonicity (HNR/GNE)'
                        set(hnrControls, 'Visible', 'on');

                    case 'CPP/CPPS'
                        set(cppControls, 'Visible', 'on');
                end
                updateRowHeights();
            end

            function updateRowHeights()
                children = innerGl.Children;
                nRows = length(innerGl.RowHeight);
                newHeights = cell(1, nRows);
                for ri = 1:nRows
                    newHeights{ri} = 0;
                    for ci = 1:length(children)
                        if isprop(children(ci), 'Layout') && isprop(children(ci).Layout, 'Row') ...
                                && children(ci).Layout.Row == ri
                            if strcmp(children(ci).Visible, 'on')
                                newHeights{ri} = 'fit';
                                break;
                            end
                        end
                    end
                end
                innerGl.RowHeight = newHeights;
            end

            function updatePitchSubVisibility()
                pm = pitchMethodDd.Value;
                isFiltered = ismember(pm, {'filtered_ac', 'filtered_cc'});
                isShs = strcmp(pm, 'shs');
                isSpinet = strcmp(pm, 'spinet');

                set(filteredOnlyControls, 'Visible', isFiltered);
                set(shsControls, 'Visible', isShs);
                set(spinetControls, 'Visible', isSpinet);
            end

            %% --- Rebuild preview panel ---
            function rebuildPreviewPanel()
                atype = analysisDd.Value;
                nAxes = getNumAxes(atype);

                delete(rightPnl.Children);
                tl = tiledlayout(rightPnl, nAxes, 1, ...
                    'Padding', 'compact', 'TileSpacing', 'compact');

                ax = gobjects(nAxes, 1);
                titles = getAxisTitles(atype);
                for i = 1:nAxes
                    ax(i) = nexttile(tl);
                    title(ax(i), titles{i}, 'Interpreter', 'none');
                    xlabel(ax(i), 'Time (s)');
                end
                linkaxes(ax, 'x');
                axtoolbar(tl, {'zoom', 'pan', 'restoreview', 'datacursor', 'export'});
            end

            function n = getNumAxes(atype)
                switch atype
                    case 'Pitch',          n = 2;
                    case 'PointProcess',   n = 2;
                    case 'Jitter',         n = 3;
                    case 'Shimmer',        n = 3;
                    case 'Formant',        n = 3;
                    case 'Intensity',      n = 3;
                    case 'Harmonicity (HNR/GNE)', n = 3;
                    case 'CPP/CPPS',       n = 3;
                    otherwise,             n = 1;
                end
            end

            function titles = getAxisTitles(atype)
                switch atype
                    case 'Pitch'
                        titles = {'Raw Data', 'Pitch Contour (Hz)'};
                    case 'PointProcess'
                        titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)'};
                    case 'Jitter'
                        titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)', 'Jitter Metrics'};
                    case 'Shimmer'
                        titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)', 'Shimmer Metrics'};
                    case 'Formant'
                        titles = {'Raw Data', 'Pitch Contour (Hz)', 'Formant Tracks (Hz)'};
                    case 'Intensity'
                        titles = {'Raw Data', 'Pitch Contour (Hz)', 'Intensity (dB)'};
                    case 'Harmonicity (HNR/GNE)'
                        titles = {'Raw Data', 'Pitch Contour (Hz)', 'HNR (dB)'};
                    case 'CPP/CPPS'
                        titles = {'Raw Data', 'Pitch Contour (Hz)', 'CPP / CPPS (dB)'};
                end
            end

            %% --- RUN ANALYSIS ---
            function runAnalysis()
                if isempty(tl) || ~isvalid(tl)
                    rebuildPreviewPanel();
                end

                atype = analysisDd.Value;
                % Normalize audio for SHS/SPINET (required), good practice for all
                yNorm = y / max(abs(y));

                progDlg = uiprogressdlg(fig, 'Indeterminate', 'on', ...
                    'Message', sprintf('Running %s analysis...', atype));
                drawnow;

                try
                    switch atype
                        case 'Pitch'
                            results = runPitch(yNorm, fs);
                        case 'PointProcess'
                            results = runPointProcess(y, fs);
                        case 'Jitter'
                            results = runJitter(y, fs);
                        case 'Shimmer'
                            results = runShimmer(y, fs);
                        case 'Formant'
                            results = runFormant(y, fs);
                        case 'Intensity'
                            results = runIntensity(y, fs);
                        case 'Harmonicity (HNR/GNE)'
                            results = runHarmonicity(y, fs);
                        case 'CPP/CPPS'
                            results = runCppCpps(y, fs);
                        otherwise
                            error('Unknown analysis type: %s', atype);
                    end
                    plotResults(atype, results);
                    fig.UserData.lastResults = results;
                    fig.UserData.lastAnalysisType = atype;
                catch ME
                    delete(progDlg);
                    uialert(fig, ME.message, 'Analysis Error');
                    return;
                end
                delete(progDlg);
            end

            %% --- Individual analysis runners ---
            function results = runPitch(y, fs)
                pm = pitchMethodDd.Value;
                tstep = pitchTimeStepEdit.Value;
                if tstep == 0
                    tstep = 0.8 / pitchFloorEdit.Value;
                end

                args = {'pitchMethod', pm, 'timeStep', tstep, ...
                    'pitchFloor', pitchFloorEdit.Value, ...
                    'pitchCeiling', pitchCeilingEdit.Value, ...
                    'maxnCandidates', pitchMaxCandEdit.Value, ...
                    'veryAccurate', strcmp(pitchVeryAccDd.Value, 'on'), ...
                    'silenceThreshold', pitchSilenceEdit.Value, ...
                    'voicingThreshold', pitchVoicingEdit.Value, ...
                    'octaveCost', pitchOctCostEdit.Value, ...
                    'octaveJumpCost', pitchOctJumpEdit.Value, ...
                    'voicedUnvoicedCost', pitchVuvEdit.Value};

                switch pm
                    case {'filtered_ac', 'filtered_cc'}
                        args = [args, {'attenuationAtTop', pitchAttTopEdit.Value}];
                    case 'shs'
                        args = [args, {'shsHighestFrequency', shsFreqMaxEdit.Value, ...
                            'shsMaxnSubharmonics', shsMaxSubEdit.Value, ...
                            'shsCompressionFactor', shsCompEdit.Value, ...
                            'shsPointsPerOctave', shsPointsOctEdit.Value}];
                    case 'spinet'
                        args = [args, {'spinetWindowLength', spinetWinEdit.Value, ...
                            'spinetMinFreq', spinetFBminEdit.Value, ...
                            'spinetMaxFreq', spinetFBmaxEdit.Value, ...
                            'spinetNumFilters', spinetFBnumEdit.Value}];
                end

                pr = praatMEX.praatmex('pitch', y, fs, args{:});
                results.pitch = struct('time', pr.time, 'value', pr.freq);
            end

            function results = runPointProcess(y, fs)
                [pitchArgs, ppArgs] = collectPitchPPArgs();
                results.pointProcess = praatMEX.praatmex('pointprocess', y, fs, ...
                    pitchArgs{:}, ppArgs{:});
                pr = praatMEX.praatmex('pitch', y, fs, pitchArgs{:});
                results.pitch = struct('time', pr.time, 'value', pr.freq);
            end

            function results = runJitter(y, fs)
                [pitchArgs, ppArgs] = collectPitchPPArgs();
                jitArgs = {'method', 'all', 'maxPeriodFactor', jitterMaxFactorEdit.Value, ...
                    'windowLength', jitterWinLenEdit.Value, ...
                    'windowStep', jitterWinStepEdit.Value};
                jr = praatMEX.praatmex('jitter', y, fs, jitArgs{:}, pitchArgs{:}, ppArgs{:});
                if isfield(jr, 'time') && ~isempty(jr.time); jt = jr.time; else jt = []; end
                jitterMap = {'local','local_absolute','rap','ppq5','ddp'};
                jitterOut  = {'jitter_local','jitter_local_absolute','jitter_rap','jitter_ppq5','jitter_ddp'};
                for ji = 1:numel(jitterMap)
                    results.(jitterOut{ji}) = struct('time', jt, 'value', jr.(jitterMap{ji}));
                end
                pr = praatMEX.praatmex('pitch', y, fs, pitchArgs{:});
                results.pitch = struct('time', pr.time, 'value', pr.freq);
                results.pointProcess = praatMEX.praatmex('pointprocess', y, fs, ...
                    pitchArgs{:}, ppArgs{:});
            end

            function results = runShimmer(y, fs)
                [pitchArgs, ppArgs] = collectPitchPPArgs();
                shimArgs = {'method', 'all', 'maxAmplitudeFactor', shimmerAmpMaxEdit.Value, ...
                    'windowLength', jitterWinLenEdit.Value, ...
                    'windowStep', jitterWinStepEdit.Value};
                sr = praatMEX.praatmex('shimmer', y, fs, shimArgs{:}, pitchArgs{:}, ppArgs{:});
                if isfield(sr, 'time') && ~isempty(sr.time); st = sr.time; else st = []; end
                shimmerMap = {'local','local_dB','apq3','apq5','apq11','dda'};
                shimmerOut  = {'shimmer_local','shimmer_local_db','shimmer_apq3','shimmer_apq5','shimmer_apq11','shimmer_dda'};
                for si = 1:numel(shimmerMap)
                    results.(shimmerOut{si}) = struct('time', st, 'value', sr.(shimmerMap{si}));
                end
                pr = praatMEX.praatmex('pitch', y, fs, pitchArgs{:});
                results.pitch = struct('time', pr.time, 'value', pr.freq);
                results.pointProcess = praatMEX.praatmex('pointprocess', y, fs, ...
                    pitchArgs{:}, ppArgs{:});
            end

            function results = runFormant(y, fs)
                fr = praatMEX.praatmex('formant', y, fs, ...
                    'method', fmtMethodDd.Value, ...
                    'timeStep', 0.01, ...
                    'maxFormants', fmtMaxFormantsEdit.Value, ...
                    'maxFreq', fmtCeilingEdit.Value, ...
                    'windowLength', fmtWinLenEdit.Value, ...
                    'preEmphHz', fmtPreEmphEdit.Value, ...
                    'trackFormants', fmtTrackDd.Value, ...
                    'numberOfTracks', fmtTrackNEdit.Value, ...
                    'refF1', fmtRef1Edit.Value, ...
                    'refF2', fmtRef2Edit.Value, ...
                    'refF3', fmtRef3Edit.Value, ...
                    'refF4', fmtRef4Edit.Value, ...
                    'refF5', fmtRef5Edit.Value, ...
                    'dfCost', fmtFreqCostEdit.Value, ...
                    'bfCost', fmtBandCostEdit.Value, ...
                    'octaveJumpCost', fmtTransCostEdit.Value, ...
                    'nrOfStdDev', fmtRobustStdEdit.Value, ...
                    'maxIterations', fmtRobustIterEdit.Value, ...
                    'tolerance', fmtRobustTolEdit.Value);
                numFormants = min(fmtMaxFormantsEdit.Value, size(fr.freq, 1));
                for fi = 1:numFormants
                    results.(sprintf('formant_f%d', fi)) = ...
                        struct('time', fr.time(:), 'value', fr.freq(fi, :)');
                end
                results = addPitchToResults(y, fs, results);
            end

            function results = runIntensity(y, fs)
                r = praatMEX.praatmex('intensity', y, fs, ...
                    'pitchFloor', intMinPitchEdit.Value, ...
                    'timeStep', intWinLenEdit.Value, ...
                    'subtractMean', intSubMeanDd.Value);
                results.Intensity = struct('time', r.time, 'value', r.intensity);
                results = addPitchToResults(y, fs, results);
            end

            function results = runHarmonicity(y, fs)
                r = praatMEX.praatmex('harmonicity', y, fs, ...
                    'method', 'HNRac', ...
                    'timeStep', hnrTimeStepEdit.Value, ...
                    'pitchFloor', hnrPitchFloorEdit.Value, ...
                    'silenceThreshold', hnrSilenceEdit.Value, ...
                    'periodsPerWindow', hnrPeriodsEdit.Value);
                results.HNRac = struct('time', r.time, 'value', r.harmonicity);
                r = praatMEX.praatmex('harmonicity', y, fs, ...
                    'method', 'HNRcc', ...
                    'timeStep', hnrTimeStepEdit.Value, ...
                    'pitchFloor', hnrPitchFloorEdit.Value, ...
                    'silenceThreshold', hnrSilenceEdit.Value, ...
                    'periodsPerWindow', hnrPeriodsEdit.Value);
                results.HNRcc = struct('time', r.time, 'value', r.harmonicity);
                r = praatMEX.praatmex('harmonicity', y, fs, ...
                    'method', 'GNE', ...
                    'gneMinFreq', hnrGNEminEdit.Value, ...
                    'gneMaxFreq', hnrGNEmaxEdit.Value, ...
                    'gneBandwidth', hnrGNEBWEdit.Value, ...
                    'gneStep', hnrGNEStepEdit.Value);
                if isfield(r, 'matrix') && ~isempty(r.time)
                    results.GNE = struct('time', r.time, 'value', r.matrix);
                else
                    results.GNE = struct('time', r.time, 'value', r.harmonicity);
                end
                results = addPitchToResults(y, fs, results);
            end

            function results = runCppCpps(y, fs)
                trendTypeMap = containers.Map({'straight', 'Exponential decay'}, {'linear', 'exponential'});
                fitMethodMap = containers.Map({'Robust slow', 'Robust', 'Least squares'}, {'robust_slow', 'robust', 'lsq'});

                r = praatMEX.praatmex('cpp', y, fs, ...
                    'pitchFloor', cppPitchFEdit.Value, ...
                    'pitchCeiling', cppPeakFmaxEdit.Value, ...
                    'timeStep', cppTimeStepEdit.Value, ...
                    'maximumFrequency', cppMaxFreqEdit.Value, ...
                    'preEmphasisFrom', cppPreEmphEdit.Value, ...
                    'computeCPPs', true, ...
                    'timeAveragingWindow', cppTimeAvgEdit.Value, ...
                    'quefrencyAveragingWindow', cppQuefAvgEdit.Value, ...
                    'peakInterpolation', cppPeakInterpDd.Value, ...
                    'trendLowerBound', cppTrendLowEdit.Value, ...
                    'trendUpperBound', cppTrendHighEdit.Value, ...
                    'trendType', trendTypeMap(cppTrendTypeDd.Value), ...
                    'fitMethod', fitMethodMap(cppFitMethodDd.Value));
                results.CPP = struct('time', r.time, 'value', r.cpp);
                if isfield(r, 'cpps') && isfield(r, 'time')
                    results.CPPs = struct('time', r.time, 'value', r.cpps);
                end
                results = addPitchToResults(y, fs, results);
            end

            function results = addPitchToResults(y, fs, results)
                pm = pitchMethodDd.Value;
                tstep = pitchTimeStepEdit.Value;
                if tstep == 0
                    tstep = 0.8 / pitchFloorEdit.Value;
                end
                args = {'pitchMethod', pm, 'timeStep', tstep, ...
                    'pitchFloor', pitchFloorEdit.Value, ...
                    'pitchCeiling', pitchCeilingEdit.Value, ...
                    'maxnCandidates', pitchMaxCandEdit.Value, ...
                    'veryAccurate', strcmp(pitchVeryAccDd.Value, 'on'), ...
                    'silenceThreshold', pitchSilenceEdit.Value, ...
                    'voicingThreshold', pitchVoicingEdit.Value, ...
                    'octaveCost', pitchOctCostEdit.Value, ...
                    'octaveJumpCost', pitchOctJumpEdit.Value, ...
                    'voicedUnvoicedCost', pitchVuvEdit.Value};
                switch pm
                    case {'filtered_ac', 'filtered_cc'}
                        args = [args, {'attenuationAtTop', pitchAttTopEdit.Value}];
                    case 'shs'
                        yN = y / max(abs(y));
                        args = [args, {'shsHighestFrequency', shsFreqMaxEdit.Value, ...
                            'shsMaxnSubharmonics', shsMaxSubEdit.Value, ...
                            'shsCompressionFactor', shsCompEdit.Value, ...
                            'shsPointsPerOctave', shsPointsOctEdit.Value}];
                    case 'spinet'
                        yN = y / max(abs(y));
                        args = [args, {'spinetWindowLength', spinetWinEdit.Value, ...
                            'spinetMinFreq', spinetFBminEdit.Value, ...
                            'spinetMaxFreq', spinetFBmaxEdit.Value, ...
                            'spinetNumFilters', spinetFBnumEdit.Value}];
                end
                if ~exist('yN', 'var'), yN = y; end
                pr = praatMEX.praatmex('pitch', yN, fs, args{:});
                results.pitch = struct('time', pr.time, 'value', pr.freq);
            end

            function [pitchArgs, ppArgs] = collectPitchPPArgs()
                pm = pitchMethodDd.Value;
                tstep = pitchTimeStepEdit.Value;
                if tstep == 0
                    tstep = 0.8 / pitchFloorEdit.Value;
                end

                pitchArgs = {'pitchMethod', pm, 'timeStep', tstep, ...
                    'pitchFloor', pitchFloorEdit.Value, ...
                    'pitchCeiling', pitchCeilingEdit.Value, ...
                    'maxnCandidates', pitchMaxCandEdit.Value, ...
                    'veryAccurate', strcmp(pitchVeryAccDd.Value, 'on'), ...
                    'silenceThreshold', pitchSilenceEdit.Value, ...
                    'voicingThreshold', pitchVoicingEdit.Value, ...
                    'octaveCost', pitchOctCostEdit.Value, ...
                    'octaveJumpCost', pitchOctJumpEdit.Value, ...
                    'voicedUnvoicedCost', pitchVuvEdit.Value};

                switch pm
                    case {'filtered_ac', 'filtered_cc'}
                        pitchArgs = [pitchArgs, {'attenuationAtTop', pitchAttTopEdit.Value}];
                    case 'shs'
                        pitchArgs = [pitchArgs, {'shsHighestFrequency', shsFreqMaxEdit.Value, ...
                            'shsMaxnSubharmonics', shsMaxSubEdit.Value, ...
                            'shsCompressionFactor', shsCompEdit.Value, ...
                            'shsPointsPerOctave', shsPointsOctEdit.Value}];
                    case 'spinet'
                        pitchArgs = [pitchArgs, {'spinetWindowLength', spinetWinEdit.Value, ...
                            'spinetMinFreq', spinetFBminEdit.Value, ...
                            'spinetMaxFreq', spinetFBmaxEdit.Value, ...
                            'spinetNumFilters', spinetFBnumEdit.Value}];
                end

                ppArgs = {'ppMethod', ppMethodDd.Value, ...
                    'includeMaxima', ppSelectMaxDd.Value, ...
                    'includeMinima', ppSelectMinDd.Value};
            end

            %% --- PLOT RESULTS ---
            function plotResults(atype, results)
                if isempty(tl) || ~isvalid(tl)
                    return;
                end

                % Remove only plotted objects (keep titles/labels)
                for i = 1:numel(ax)
                    if isvalid(ax(i))
                        delete(findobj(ax(i), 'Type', 'line'));
                        delete(findobj(ax(i), 'Type', 'ConstantLine'));
                        delete(findobj(ax(i), 'Type', 'Legend'));
                        ax(i).XLimMode = 'auto';
                        ax(i).YLimMode = 'auto';
                    end
                end
                hold(ax(1), 'on');

                plot(ax(1), t, y, 'k-', 'LineWidth', 0.5);
                ylabel(ax(1), 'Amplitude');

                % Common: if pitch data exists and no dedicated pitch axis,
                % plot pulses on first axis
                hasPitch = isfield(results, 'pitch') && isstruct(results.pitch) ...
                    && isfield(results.pitch, 'time') && ~isempty(results.pitch.time);
                hasPP = isfield(results, 'pointProcess') && isstruct(results.pointProcess) ...
                    && isfield(results.pointProcess, 'time') && ~isempty(results.pointProcess.time);

                switch atype
                    case 'Pitch'
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                            ylim(ax(2), 'padded');
                        end
                        ylabel(ax(2), 'Frequency (Hz)');

                    case 'PointProcess'
                        if hasPP
                            plotPulses(ax(1), results.pointProcess.time + t(1));
                        end
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');

                    case 'Jitter'
                        if hasPP
                            plotPulses(ax(1), results.pointProcess.time + t(1));
                        end
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        plotJitterShimmer(ax(3), results, 'jitter');

                    case 'Shimmer'
                        if hasPP
                            plotPulses(ax(1), results.pointProcess.time + t(1));
                        end
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        plotJitterShimmer(ax(3), results, 'shimmer');

                    case 'Formant'
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        hold(ax(3), 'on');
                        colors = lines(5);
                        legendEntries = {};
                        for fi = 1:5
                            fld = sprintf('formant_f%d', fi);
                            if isfield(results, fld) && isstruct(results.(fld)) ...
                                    && isfield(results.(fld), 'time') ...
                                    && ~isempty(results.(fld).time) ...
                                    && isfield(results.(fld), 'value') ...
                                    && ~isempty(results.(fld).value)
                                tF = results.(fld).time(:) + t(1);
                                vF = results.(fld).value(:);
                                valid = ~isnan(vF) & ~isnan(tF);
                                if any(valid)
                                    hold(ax(3),'on');
                                    plot(ax(3), tF(valid), vF(valid), 'o-', ...
                                        'Color', colors(fi,:), ...
                                        'LineWidth', 0.8, 'MarkerSize', 2);
                                    legendEntries{end+1} = sprintf('F%d', fi); %#ok<AGROW>
                                end
                            end
                        end
                        ylabel(ax(3), 'Frequency (Hz)');
                        if ~isempty(legendEntries)
                            lg=legend(ax(3), legendEntries, ...
                                'Box', 'off','Orientation','horizontal');
                            lg.Layout.Tile='south';
                        end

                    case 'Intensity'
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        if isfield(results, 'Intensity') && isstruct(results.Intensity)
                            tI = results.Intensity.time(:) + t(1);
                            vI = results.Intensity.value(:);
                            hold(ax(3),'on');
                            plot(ax(3), tI, vI, 'r-', 'LineWidth', 1.5);
                            ylabel(ax(3), 'Intensity (dB)');
                        end

                    case 'Harmonicity (HNR/GNE)'
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        hold(ax(3), 'on');
                        if isfield(results, 'HNRac') && isstruct(results.HNRac)
                            plot(ax(3), results.HNRac.time + t(1), results.HNRac.value, ...
                                'b-', 'LineWidth', 1);
                        end
                        if isfield(results, 'HNRcc') && isstruct(results.HNRcc)
                            plot(ax(3), results.HNRcc.time + t(1), results.HNRcc.value, ...
                                'r-', 'LineWidth', 1);
                        end
                        ylabel(ax(3), 'HNR (dB)');
                        lg=legend(ax(3), {'HNRac', 'HNRcc'}, 'Box', 'off','Orientation','horizontal');
                        lg.Layout.Tile='south';

                    case 'CPP/CPPS'
                        if hasPitch
                            f0 = fillMissingIfRequested(results.pitch);
                            hold(ax(2),'on');
                            plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
                        end
                        ylabel(ax(2), 'Frequency (Hz)');
                        hold(ax(3), 'on');
                        if isfield(results, 'CPP') && isstruct(results.CPP)
                            plot(ax(3), results.CPP.time + t(1), results.CPP.value, ...
                                'b-', 'LineWidth', 1);
                        end
                        if isfield(results, 'CPPs') && isstruct(results.CPPs)
                            plot(ax(3), results.CPPs.time + t(1), results.CPPs.value, ...
                                'r-', 'LineWidth', 1);
                        end
                        ylabel(ax(3), 'CPP / CPPS (dB)');
                        lg=legend(ax(3), {'CPP', 'CPPS'}, 'Box', 'off','Orientation','horizontal');
                        lg.Layout.Tile='south';
                end

                % Link x-axes
                linkaxes(ax, 'x');
                xlim(ax(1), [t(1) t(end)]);
            end

            function v = fillMissingIfRequested(pitchStruct)
                v = pitchStruct.value;
                method = fillMissDd.Value;
                if strcmp(method, 'zero')
                    v(isnan(v)) = 0;
                else
                    v = fillmissing(v, method);
                end
            end

            function plotPulses(axH, pulseTimes)
                % for k = 1:length(pulseTimes)
                %     xline(axH, pulseTimes(k), '-', 'Color', [0.8 0.2 0.2], ...
                %         'LineWidth', 0.5, 'Alpha', 0.5);
                % end

                %ylims=[-10 10];
                ylims=ylim(axH);
                plotxvals=repelem(pulseTimes,3); pulseTimes(3:3:end)=NaN;
                yvals=repmat([ylims NaN],[1 numel(pulseTimes)]);

                lineObj=line(axH,plotxvals(:),yvals(:),'PickableParts','none','Color',[0.8 0.8 0.8],'LineStyle','-','LineWidth', 0.5,'AffectAutoLimits','off');
                uistack(lineObj,'bottom');
            end

            function plotJitterShimmer(axH, results, kind)
                hold(axH, 'on');
                colors = lines(6);
                if strcmp(kind, 'jitter')
                    metrics = {'jitter_local', 'jitter_local_absolute', 'jitter_rap', ...
                        'jitter_ppq5', 'jitter_ddp'};
                    labels = {'local', 'local abs', 'rap', 'ppq5', 'ddp'};
                else
                    metrics = {'shimmer_local', 'shimmer_local_db', 'shimmer_apq3', ...
                        'shimmer_apq5', 'shimmer_apq11', 'shimmer_dda'};
                    labels = {'local', 'dB', 'apq3', 'apq5', 'apq11', 'dda'};
                end
                plotted = 0;
                for mi = 1:length(metrics)
                    if isfield(results, metrics{mi}) && isstruct(results.(metrics{mi})) ...
                            && isfield(results.(metrics{mi}), 'time') ...
                            && ~isempty(results.(metrics{mi}).time)
                        tM = results.(metrics{mi}).time + t(1);
                        vM = results.(metrics{mi}).value;
                        plot(axH, tM, vM, 'o-', 'Color', colors(mi,:), ...
                            'LineWidth', 1, 'MarkerSize', 3);
                        plotted = plotted + 1;
                    end
                end
                if plotted > 0
                    lg=legend(axH, labels(1:plotted), 'Box', 'off', ...
                        'FontSize', 8,'Orientation','horizontal');
                    lg.Layout.Tile='south';
                end
                ylabel(axH, 'Value');
            end

            function series = getExportableTimeSeries(results)
                series = struct('field', {}, 'time', {}, 'value', {}, 'label', {});
                flds = fieldnames(results);
                for i = 1:length(flds)
                    f = flds{i};
                    v = results.(f);
                    if isstruct(v) && isfield(v, 'time') && ~isempty(v.time) ...
                            && isfield(v, 'value') && ~isempty(v.value)
                        series(end+1).field = f;
                        series(end).time = v.time(:);
                        series(end).value = v.value(:);
                        series(end).label = strrep(f, '_', ' ');
                    end
                end
            end

            function [selected, ok] = showExportDialog(series)
                n = length(series);
                dlgH = min(50*n + 120, 600);
                dlg = uifigure('Name', 'Export Channels', ...
                    'Position', [0 0 420 dlgH], 'WindowStyle', 'modal', 'Visible', 'off');
                importHandles = gobjects(n, 1);
                gl = uigridlayout(dlg, [2 1], 'RowHeight', {'1x', 'fit'}, 'Padding', [10 10 10 10]);
                scrollGl = uigridlayout(gl, [n 1], 'RowHeight', repmat({'fit'}, 1, n), 'Scrollable', 'on');
                scrollGl.Layout.Row = 1;
                for i = 1:n
                    importHandles(i) = uicheckbox(scrollGl, 'Text', series(i).label, 'Value', true);
                    importHandles(i).Layout.Row = i;
                end
                cancelFlag = false;
                btnGl = uigridlayout(gl, [1 2], 'ColumnWidth', {'1x', '1x'}, 'Padding', [0 5 0 0]);
                btnGl.Layout.Row = 2;
                exportBtn = uibutton(btnGl, 'Text', 'Export', 'FontWeight', 'bold', ...
                    'ButtonPushedFcn', @(s,e) uiresume(dlg));
                exportBtn.Layout.Row = 1; exportBtn.Layout.Column = 1;
                skipBtn = uibutton(btnGl, 'Text', 'Skip', ...
                    'ButtonPushedFcn', @(s,e) onSkip());
                skipBtn.Layout.Row = 1; skipBtn.Layout.Column = 2;

                function onSkip()
                    cancelFlag = true;
                    uiresume(dlg);
                end

                movegui(dlg, 'center');
                dlg.Visible = 'on';
                uiwait(dlg);
                if cancelFlag || ~isvalid(dlg)
                    ok = false;  selected = [];
                else
                    ok = true;
                    selected = find([importHandles.Value]);
                end
                delete(dlg);
            end

            %% --- Save settings and close ---
            function saveAndClose()
                pAnalysisType = analysisDd.Value;
                pFillMissing = fillMissDd.Value;
                pPitchMethod = pitchMethodDd.Value;
                pPitchFloor = pitchFloorEdit.Value;
                pPitchCeiling = pitchCeilingEdit.Value;
                pPitchTimeStep = pitchTimeStepEdit.Value;
                pPitchMaxCandidates = pitchMaxCandEdit.Value;
                pPitchVeryAccurate = pitchVeryAccDd.Value;
                pPitchAttenuationAtTop = pitchAttTopEdit.Value;
                pPitchSilenceThreshold = pitchSilenceEdit.Value;
                pPitchVoicingThreshold = pitchVoicingEdit.Value;
                pPitchOctaveCost = pitchOctCostEdit.Value;
                pPitchOctaveJumpCost = pitchOctJumpEdit.Value;
                pPitchVuvCost = pitchVuvEdit.Value;
                pShsFreqMax = shsFreqMaxEdit.Value;
                pShsMaxSubharm = shsMaxSubEdit.Value;
                pShsCompression = shsCompEdit.Value;
                pShsPointsPerOctave = shsPointsOctEdit.Value;
                pSpinetWinLen = spinetWinEdit.Value;
                pSpinetFBmin = spinetFBminEdit.Value;
                pSpinetFBmax = spinetFBmaxEdit.Value;
                pSpinetFBnum = spinetFBnumEdit.Value;
                pPPmethod = ppMethodDd.Value;
                pPPselectMax = ppSelectMaxDd.Value;
                pPPselectMin = ppSelectMinDd.Value;
                pJitterShortPeriod = jitterShortEdit.Value;
                pJitterLongPeriod = jitterLongEdit.Value;
                pJitterMaxFactor = jitterMaxFactorEdit.Value;
                pJitterWinLen = jitterWinLenEdit.Value;
                pJitterWinStep = jitterWinStepEdit.Value;
                pShimmerMaxAmpFactor = shimmerAmpMaxEdit.Value;
                pFmtMethod = fmtMethodDd.Value;
                pFmtMaxFormants = fmtMaxFormantsEdit.Value;
                pFmtCeiling = fmtCeilingEdit.Value;
                pFmtWinLen = fmtWinLenEdit.Value;
                pFmtPreEmph = fmtPreEmphEdit.Value;
                pFmtRobustStd = fmtRobustStdEdit.Value;
                pFmtRobustIter = fmtRobustIterEdit.Value;
                pFmtRobustTol = fmtRobustTolEdit.Value;
                pFmtTrack = fmtTrackDd.Value;
                pFmtTrackN = fmtTrackNEdit.Value;
                pFmtRef1 = fmtRef1Edit.Value;
                pFmtRef2 = fmtRef2Edit.Value;
                pFmtRef3 = fmtRef3Edit.Value;
                pFmtRef4 = fmtRef4Edit.Value;
                pFmtRef5 = fmtRef5Edit.Value;
                pFmtFreqCost = fmtFreqCostEdit.Value;
                pFmtBandCost = fmtBandCostEdit.Value;
                pFmtTransCost = fmtTransCostEdit.Value;
                pIntMinPitch = intMinPitchEdit.Value;
                pIntWinLen = intWinLenEdit.Value;
                pIntSubMean = intSubMeanDd.Value;
                pHnrTimeStep = hnrTimeStepEdit.Value;
                pHnrPitchFloor = hnrPitchFloorEdit.Value;
                pHnrSilence = hnrSilenceEdit.Value;
                pHnrPeriods = hnrPeriodsEdit.Value;
                pHnrGNEmin = hnrGNEminEdit.Value;
                pHnrGNEmax = hnrGNEmaxEdit.Value;
                pHnrGNEBW = hnrGNEBWEdit.Value;
                pHnrGNEStep = hnrGNEStepEdit.Value;
                pCppPitchFloor = cppPitchFEdit.Value;
                pCppTimeStep = cppTimeStepEdit.Value;
                pCppMaxFreq = cppMaxFreqEdit.Value;
                pCppPreEmph = cppPreEmphEdit.Value;
                pCppRemoveTrend = cppRemoveTrendDd.Value;
                pCppTimeAvg = cppTimeAvgEdit.Value;
                pCppQuefAvg = cppQuefAvgEdit.Value;
                pCppPeakFmin = cppPeakFminEdit.Value;
                pCppPeakFmax = cppPeakFmaxEdit.Value;
                pCppPeakPreEmph = cppPeakPreEmphEdit.Value;
                pCppPeakInterp = cppPeakInterpDd.Value;
                pCppTrendLow = cppTrendLowEdit.Value;
                pCppTrendHigh = cppTrendHighEdit.Value;
                pCppTrendType = cppTrendTypeDd.Value;
                pCppFitMethod = cppFitMethodDd.Value;

                if isfield(fig.UserData, 'lastResults') && ~isempty(fig.UserData.lastResults)
                    series = getExportableTimeSeries(fig.UserData.lastResults);
                    if ~isempty(series)
                        [sel, ok] = showExportDialog(series);
                        if ok && ~isempty(sel)
                            for i = 1:length(sel)
                                s = series(sel(i));
                                label = [channelName ' - ' s.label ' (' pAnalysisType ')'];
                                app.addSingleChannelData(s.value, s.time + t(1), label, 'Raw');
                            end
                        end
                    end
                end

                windowClosedByApply = true;
                uiresume(fig);
            end

            function cancelAndClose()
                windowClosedByApply = false;
                uiresume(fig);
            end

            function resetParameters()
                % Reset all persistent variables to defaults
                pAnalysisType = 'Pitch';
                pFillMissing = 'next';
                pPitchMethod = 'filtered_ac';
                pPitchFloor = 75;  pPitchCeiling = 600;  pPitchTimeStep = 0.0;
                pPitchMaxCandidates = 15;  pPitchVeryAccurate = 'off';
                pPitchAttenuationAtTop = 0.03;
                pPitchSilenceThreshold = 0.03;  pPitchVoicingThreshold = 0.45;
                pPitchOctaveCost = 0.01;  pPitchOctaveJumpCost = 0.35;
                pPitchVuvCost = 0.14;
                pShsFreqMax = 1250;  pShsMaxSubharm = 15;
                pShsCompression = 0.84;  pShsPointsPerOctave = 48;
                pSpinetWinLen = 0.04;  pSpinetFBmin = 70;
                pSpinetFBmax = 5000;  pSpinetFBnum = 250;
                pPPmethod = 'periodic_cc';
                pPPselectMax = 'yes';  pPPselectMin = 'no';
                pJitterShortPeriod = 0.0001;  pJitterLongPeriod = 0.02;
                pJitterMaxFactor = 1.3;  pJitterWinLen = 0;  pJitterWinStep = 0;
                pShimmerMaxAmpFactor = 1.6;
                pFmtMethod = 'burg';  pFmtMaxFormants = 5;  pFmtCeiling = 5500;
                pFmtWinLen = 0.025;  pFmtPreEmph = 50;
                pFmtRobustStd = 1.5;  pFmtRobustIter = 5;  pFmtRobustTol = 1e-6;
                pFmtTrack = 'yes';  pFmtTrackN = 3;
                pFmtRef1 = 550;  pFmtRef2 = 1650;  pFmtRef3 = 2750;
                pFmtRef4 = 3850;  pFmtRef5 = 4950;
                pFmtFreqCost = 1;  pFmtBandCost = 1;  pFmtTransCost = 1;
                pIntMinPitch = 100;  pIntWinLen = 0;  pIntSubMean = 'yes';
                pHnrTimeStep = 0.01;  pHnrPitchFloor = 75;
                pHnrSilence = 0.1;  pHnrPeriods = 4.5;
                pHnrGNEmin = 500;  pHnrGNEmax = 4500;
                pHnrGNEBW = 1000;  pHnrGNEStep = 80;
                pCppPitchFloor = 60;  pCppTimeStep = 0.002;
                pCppMaxFreq = 5000;  pCppPreEmph = 50;
                pCppRemoveTrend = 'yes';  pCppTimeAvg = 0.02;
                pCppQuefAvg = 0.0005;  pCppPeakFmin = 60;  pCppPeakFmax = 330;
                pCppPeakPreEmph = 0.05;  pCppPeakInterp = 'parabolic';
                pCppTrendLow = 0.001;  pCppTrendHigh = 0.05;
                pCppTrendType = 'Exponential decay';  pCppFitMethod = 'Robust slow';

                % Update all GUI controls to match
                analysisDd.Value = pAnalysisType;
                fillMissDd.Value = pFillMissing;
                pitchMethodDd.Value = pPitchMethod;
                pitchFloorEdit.Value = pPitchFloor;
                pitchCeilingEdit.Value = pPitchCeiling;
                pitchTimeStepEdit.Value = pPitchTimeStep;
                pitchMaxCandEdit.Value = pPitchMaxCandidates;
                pitchVeryAccDd.Value = pPitchVeryAccurate;
                pitchAttTopEdit.Value = pPitchAttenuationAtTop;
                pitchSilenceEdit.Value = pPitchSilenceThreshold;
                pitchVoicingEdit.Value = pPitchVoicingThreshold;
                pitchOctCostEdit.Value = pPitchOctaveCost;
                pitchOctJumpEdit.Value = pPitchOctaveJumpCost;
                pitchVuvEdit.Value = pPitchVuvCost;
                shsFreqMaxEdit.Value = pShsFreqMax;
                shsMaxSubEdit.Value = pShsMaxSubharm;
                shsCompEdit.Value = pShsCompression;
                shsPointsOctEdit.Value = pShsPointsPerOctave;
                spinetWinEdit.Value = pSpinetWinLen;
                spinetFBminEdit.Value = pSpinetFBmin;
                spinetFBmaxEdit.Value = pSpinetFBmax;
                spinetFBnumEdit.Value = pSpinetFBnum;
                ppMethodDd.Value = pPPmethod;
                ppSelectMaxDd.Value = pPPselectMax;
                ppSelectMinDd.Value = pPPselectMin;
                jitterShortEdit.Value = pJitterShortPeriod;
                jitterLongEdit.Value = pJitterLongPeriod;
                jitterMaxFactorEdit.Value = pJitterMaxFactor;
                jitterWinLenEdit.Value = pJitterWinLen;
                jitterWinStepEdit.Value = pJitterWinStep;
                shimmerAmpMaxEdit.Value = pShimmerMaxAmpFactor;
                fmtMethodDd.Value = pFmtMethod;
                fmtMaxFormantsEdit.Value = pFmtMaxFormants;
                fmtCeilingEdit.Value = pFmtCeiling;
                fmtWinLenEdit.Value = pFmtWinLen;
                fmtPreEmphEdit.Value = pFmtPreEmph;
                fmtRobustStdEdit.Value = pFmtRobustStd;
                fmtRobustIterEdit.Value = pFmtRobustIter;
                fmtRobustTolEdit.Value = pFmtRobustTol;
                fmtTrackDd.Value = pFmtTrack;
                fmtTrackNEdit.Value = pFmtTrackN;
                fmtRef1Edit.Value = pFmtRef1;
                fmtRef2Edit.Value = pFmtRef2;
                fmtRef3Edit.Value = pFmtRef3;
                fmtRef4Edit.Value = pFmtRef4;
                fmtRef5Edit.Value = pFmtRef5;
                fmtFreqCostEdit.Value = pFmtFreqCost;
                fmtBandCostEdit.Value = pFmtBandCost;
                fmtTransCostEdit.Value = pFmtTransCost;
                intMinPitchEdit.Value = pIntMinPitch;
                intWinLenEdit.Value = pIntWinLen;
                intSubMeanDd.Value = pIntSubMean;
                hnrTimeStepEdit.Value = pHnrTimeStep;
                hnrPitchFloorEdit.Value = pHnrPitchFloor;
                hnrSilenceEdit.Value = pHnrSilence;
                hnrPeriodsEdit.Value = pHnrPeriods;
                hnrGNEminEdit.Value = pHnrGNEmin;
                hnrGNEmaxEdit.Value = pHnrGNEmax;
                hnrGNEBWEdit.Value = pHnrGNEBW;
                hnrGNEStepEdit.Value = pHnrGNEStep;
                cppPitchFEdit.Value = pCppPitchFloor;
                cppTimeStepEdit.Value = pCppTimeStep;
                cppMaxFreqEdit.Value = pCppMaxFreq;
                cppPreEmphEdit.Value = pCppPreEmph;
                cppRemoveTrendDd.Value = pCppRemoveTrend;
                cppTimeAvgEdit.Value = pCppTimeAvg;
                cppQuefAvgEdit.Value = pCppQuefAvg;
                cppPeakFminEdit.Value = pCppPeakFmin;
                cppPeakFmaxEdit.Value = pCppPeakFmax;
                cppPeakPreEmphEdit.Value = pCppPeakPreEmph;
                cppPeakInterpDd.Value = pCppPeakInterp;
                cppTrendLowEdit.Value = pCppTrendLow;
                cppTrendHighEdit.Value = pCppTrendHigh;
                cppTrendTypeDd.Value = pCppTrendType;
                cppFitMethodDd.Value = pCppFitMethod;

                % Rebuild UI for the default analysis type
                setVisibility();
                rebuildPreviewPanel();
                runAnalysis();
            end

            %% Hook up parameter change callbacks to auto-run
            allParamControls = [pitchMethodDd pitchFloorEdit pitchCeilingEdit ...
                pitchTimeStepEdit pitchVeryAccDd pitchAttTopEdit ...
                pitchSilenceEdit pitchVoicingEdit pitchOctCostEdit ...
                pitchOctJumpEdit pitchVuvEdit pitchMaxCandEdit ...
                shsFreqMaxEdit shsMaxSubEdit shsCompEdit shsPointsOctEdit ...
                spinetWinEdit spinetFBminEdit spinetFBmaxEdit spinetFBnumEdit ...
                fillMissDd ppMethodDd ppSelectMaxDd ppSelectMinDd ...
                jitterShortEdit jitterLongEdit jitterMaxFactorEdit ...
                jitterWinLenEdit jitterWinStepEdit shimmerAmpMaxEdit ...
                fmtMethodDd fmtMaxFormantsEdit fmtCeilingEdit fmtWinLenEdit ...
                fmtPreEmphEdit fmtRobustStdEdit fmtRobustIterEdit fmtRobustTolEdit ...
                fmtTrackDd fmtTrackNEdit ...
                fmtRef1Edit fmtRef2Edit fmtRef3Edit fmtRef4Edit fmtRef5Edit ...
                fmtFreqCostEdit fmtBandCostEdit fmtTransCostEdit ...
                intMinPitchEdit intWinLenEdit intSubMeanDd ...
                hnrTimeStepEdit hnrPitchFloorEdit hnrSilenceEdit hnrPeriodsEdit ...
                hnrGNEminEdit hnrGNEmaxEdit hnrGNEBWEdit hnrGNEStepEdit ...
                cppPitchFEdit cppTimeStepEdit cppMaxFreqEdit cppPreEmphEdit ...
                cppRemoveTrendDd cppTimeAvgEdit cppQuefAvgEdit ...
                cppPeakFminEdit cppPeakFmaxEdit cppPeakPreEmphEdit cppPeakInterpDd ...
                cppTrendLowEdit cppTrendHighEdit cppTrendTypeDd cppFitMethodDd];

            for h = allParamControls
                if isprop(h, 'ValueChangedFcn')
                    h.ValueChangedFcn = @(s,e) runAnalysis();
                end
            end
            pitchMethodDd.ValueChangedFcn = @(s,e) onPitchMethodChange();

            function onPitchMethodChange()
                updatePitchSubVisibility();
                runAnalysis();
            end

            %% Initialize
            rebuildPreviewPanel();
            runAnalysis();

            %% Wait for user to close
            uiwait(fig);  % commented out for non-blocking demo/testing; re-enable for app use

            %% Cleanup
            delete(fig);
        end

        % function openPraatAnalysisWindow(app, channelNr)
        %     % openPraatAnalysisWindow_ForApp  GUI for selecting and running Praat analyses
        %     %
        %     %   
        %     %
        %     %   Runs as a modal GUI within the Vocaliscope app for the given channel.
        %     %   Results are added as new channels via app.addSingleChannelData()
        %     %   when the user clicks "Apply & Close".
        % 
        %     %% Read data from app
        %     fs = app.channelSampleRates(channelNr);
        %     y  = app.channelYValues{channelNr}(:);
        %     t  = app.channelXValues{channelNr}(:);
        %     channelName = app.channelNames{channelNr};
        % 
        %     %% Persistent settings
        %     persistent pAnalysisType pFillMissing
        %     persistent pPitchMethod pPitchFloor pPitchCeiling pPitchTimeStep
        %     persistent pPitchMaxCandidates pPitchVeryAccurate pPitchAttenuationAtTop
        %     persistent pPitchSilenceThreshold pPitchVoicingThreshold
        %     persistent pPitchOctaveCost pPitchOctaveJumpCost pPitchVuvCost
        %     persistent pShsFreqMax pShsMaxSubharm pShsCompression pShsPointsPerOctave
        %     persistent pSpinetWinLen pSpinetFBmin pSpinetFBmax pSpinetFBnum
        %     persistent pPPmethod pPPselectMax pPPselectMin
        %     persistent pJitterShortPeriod pJitterLongPeriod pJitterMaxFactor
        %     persistent pJitterWinLen pJitterWinStep
        %     persistent pShimmerMaxAmpFactor
        %     persistent pFmtMethod pFmtMaxFormants pFmtCeiling pFmtWinLen pFmtPreEmph
        %     persistent pFmtRobustStd pFmtRobustIter pFmtRobustTol
        %     persistent pFmtTrack pFmtTrackN pFmtRef1 pFmtRef2 pFmtRef3 pFmtRef4 pFmtRef5
        %     persistent pFmtFreqCost pFmtBandCost pFmtTransCost
        %     persistent pIntMinPitch pIntWinLen pIntSubMean
        %     persistent pHnrTimeStep pHnrPitchFloor pHnrSilence pHnrPeriods
        %     persistent pHnrGNEmin pHnrGNEmax pHnrGNEBW pHnrGNEStep
        %     persistent pCppPitchFloor pCppTimeStep pCppMaxFreq pCppPreEmph
        %     persistent pCppRemoveTrend pCppTimeAvg pCppQuefAvg
        %     persistent pCppPeakFmin pCppPeakFmax pCppPeakPreEmph pCppPeakInterp
        %     persistent pCppTrendLow pCppTrendHigh pCppTrendType pCppFitMethod
        % 
        %     if isempty(pAnalysisType)
        %         pAnalysisType = 'Pitch';
        %         pFillMissing = 'next';
        %         pPitchMethod = 'filtered_autocorrelation';
        %         pPitchFloor = 75;  pPitchCeiling = 600;  pPitchTimeStep = 0.0;
        %         pPitchMaxCandidates = 15;  pPitchVeryAccurate = 'off';
        %         pPitchAttenuationAtTop = 0.03;
        %         pPitchSilenceThreshold = 0.03;  pPitchVoicingThreshold = 0.45;
        %         pPitchOctaveCost = 0.01;  pPitchOctaveJumpCost = 0.35;
        %         pPitchVuvCost = 0.14;
        %         pShsFreqMax = 1250;  pShsMaxSubharm = 15;
        %         pShsCompression = 0.84;  pShsPointsPerOctave = 48;
        %         pSpinetWinLen = 0.04;  pSpinetFBmin = 70;
        %         pSpinetFBmax = 5000;  pSpinetFBnum = 250;
        %         pPPmethod = 'sound+pitch_cc';
        %         pPPselectMax = 'yes';  pPPselectMin = 'no';
        %         pJitterShortPeriod = 0.0001;  pJitterLongPeriod = 0.02;
        %         pJitterMaxFactor = 1.3;  pJitterWinLen = 0;  pJitterWinStep = 0;
        %         pShimmerMaxAmpFactor = 1.6;
        %         pFmtMethod = 'burg';  pFmtMaxFormants = 5;  pFmtCeiling = 5500;
        %         pFmtWinLen = 0.025;  pFmtPreEmph = 50;
        %         pFmtRobustStd = 1.5;  pFmtRobustIter = 5;  pFmtRobustTol = 1e-6;
        %         pFmtTrack = 'yes';  pFmtTrackN = 3;
        %         pFmtRef1 = 550;  pFmtRef2 = 1650;  pFmtRef3 = 2750;
        %         pFmtRef4 = 3850;  pFmtRef5 = 4950;
        %         pFmtFreqCost = 1;  pFmtBandCost = 1;  pFmtTransCost = 1;
        %         pIntMinPitch = 100;  pIntWinLen = 0;  pIntSubMean = 'yes';
        %         pHnrTimeStep = 0.01;  pHnrPitchFloor = 75;
        %         pHnrSilence = 0.1;  pHnrPeriods = 4.5;
        %         pHnrGNEmin = 500;  pHnrGNEmax = 4500;
        %         pHnrGNEBW = 1000;  pHnrGNEStep = 80;
        %         pCppPitchFloor = 60;  pCppTimeStep = 0.002;
        %         pCppMaxFreq = 5000;  pCppPreEmph = 50;
        %         pCppRemoveTrend = 'yes';  pCppTimeAvg = 0.02;
        %         pCppQuefAvg = 0.0005;  pCppPeakFmin = 60;  pCppPeakFmax = 330;
        %         pCppPeakPreEmph = 0.05;  pCppPeakInterp = 'parabolic';
        %         pCppTrendLow = 0.001;  pCppTrendHigh = 0.05;
        %         pCppTrendType = 'Exponential decay';  pCppFitMethod = 'Robust slow';
        %     end
        % 
        %     %% Check Praat availability
        %     praatExe = 'Praat.exe';
        %     if ~isfile(praatExe)
        %         error('Praat.exe not found in current directory.');
        %     end
        % 
        %     %% Create figure
        %     fig = uifigure('Units', 'pixels', 'Position', [50 0 1100 700], ...
        %         'Visible', 'off', 'Name', 'Praat Analysis', ...
        %         'Theme', 'light', 'WindowStyle', 'normal','WindowState','maximized', ...
        %         'CloseRequestFcn', @(s,e) uiresume(s));
        %     %movegui(fig, 'center');
        %     drawnow;
        %     fig.Visible = 'on';
        %     windowClosedByApply = false;
        % 
        %     % Main grid: left controls, right preview
        %     gl = uigridlayout(fig, [1 2], 'ColumnWidth', {350, '1x'}, ...
        %         'Padding', [8 8 8 8], 'RowSpacing', 5, 'ColumnSpacing', 8);
        % 
        %     %% -- LEFT PANEL: Controls (scrollable) + button footer --
        %     leftGrid = uigridlayout(gl, [2 1],         'RowHeight', {'1x', 'fit'}, ...
        %         'Padding', [0 0 0 0], 'RowSpacing', 0);
        %     leftGrid.Layout.Column = 1;
        % 
        %     innerGl = uigridlayout(leftGrid, [200 2], ...
        %         'RowHeight', repmat({'fit'}, 1, 200), ...
        %         'ColumnWidth', {'1x', '1x'}, ...
        %         'RowSpacing', 3, 'ColumnSpacing', 6, 'Padding', [5 5 5 20], ...
        %         'Scrollable', 'on');
        %     innerGl.Layout.Row = 1;
        % 
        %     buttonGl = uigridlayout(leftGrid, [2 2], ...
        %         'RowHeight', {'fit', 'fit'}, ...
        %         'ColumnWidth', {'1x', '1x'}, ...
        %         'Padding', [5 5 5 5], 'RowSpacing', 3);
        %     buttonGl.Layout.Row = 2;
        % 
        %     row = 1;
        % 
        %     % --- Settings header ---
        %     settingsHdr = uilabel(innerGl, 'Text', 'Settings', 'FontWeight', 'bold');
        %     settingsHdr.Layout.Row = row;  settingsHdr.Layout.Column = [1 2];  row = row+1;
        % 
        %     % --- Analysis Type ---
        %     analysisLabel = uilabel(innerGl, 'Text', 'Analysis Type', 'FontWeight', 'bold');
        %     analysisLabel.Layout.Row = row;  analysisLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     analysisTypes = {'Pitch', 'PointProcess', 'Jitter', 'Shimmer', ...
        %         'Formant', 'Intensity', 'Harmonicity (HNR/GNE)', 'CPP/CPPS'};
        %     analysisDd = uidropdown(innerGl, 'Items', analysisTypes, 'Value', pAnalysisType, ...
        %         'ValueChangedFcn', @(s,e) onAnalysisTypeChange());
        %     analysisDd.Layout.Row = row;  analysisDd.Layout.Column = [1 2];  row = row+1;
        % 
        %     sepLabel = uilabel(innerGl, 'Text', '');
        %     sepLabel.Layout.Row = row;  sepLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== PITCH SECTION ======
        %     pitchSecLabel = uilabel(innerGl, 'Text', '--- Pitch Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     pitchSecLabel.Layout.Row = row;  pitchSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     pitchMethodLabel = uilabel(innerGl, 'Text', 'Pitch Method');
        %     pitchMethodLabel.Layout.Row = row;  pitchMethodLabel.Layout.Column = 1;
        %     pitchMethodDd = uidropdown(innerGl, ...
        %         'Items', {'filtered autocorrelation', 'raw autocorrelation', ...
        %         'raw cross-correlation', 'filtered cross-correlation', ...
        %         'SHS', 'SPINET'}, ...
        %         'ItemsData', {'filtered_autocorrelation', 'raw_autocorrelation', ...
        %         'raw_cross_correlation', 'filtered_cross_correlation', ...
        %         'shs', 'SPINET'}, ...
        %         'Value', pPitchMethod);
        %     pitchMethodDd.Layout.Row = row;  pitchMethodDd.Layout.Column = 2;  row = row+1;
        % 
        %     pitchFloorLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
        %     pitchFloorLabel.Layout.Row = row;  pitchFloorLabel.Layout.Column = 1;
        %     pitchFloorEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchFloor, ...
        %         'Limits', [20 2000], 'ValueDisplayFormat', '%.0f');
        %     pitchFloorEdit.Layout.Row = row;  pitchFloorEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchCeilingLabel = uilabel(innerGl, 'Text', 'Pitch Ceiling (Hz)');
        %     pitchCeilingLabel.Layout.Row = row;  pitchCeilingLabel.Layout.Column = 1;
        %     pitchCeilingEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchCeiling, ...
        %         'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
        %     pitchCeilingEdit.Layout.Row = row;  pitchCeilingEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
        %     pitchTimeStepLabel.Layout.Row = row;  pitchTimeStepLabel.Layout.Column = 1;
        %     pitchTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchTimeStep, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
        %     pitchTimeStepEdit.Layout.Row = row;  pitchTimeStepEdit.Layout.Column = 2;  row = row+1;
        %     set([pitchTimeStepLabel pitchTimeStepEdit], 'Tooltip', '0 = auto');
        % 
        %     pitchVeryAccLabel = uilabel(innerGl, 'Text', 'Very Accurate');
        %     pitchVeryAccLabel.Layout.Row = row;  pitchVeryAccLabel.Layout.Column = 1;
        %     pitchVeryAccDd = uidropdown(innerGl, 'Items', {'yes (on)', 'no (off)'}, ...
        %         'ItemsData', {'on', 'off'}, 'Value', pPitchVeryAccurate);
        %     pitchVeryAccDd.Layout.Row = row;  pitchVeryAccDd.Layout.Column = 2;  row = row+1;
        % 
        %     pitchAttTopLabel = uilabel(innerGl, 'Text', 'Attenuation at Top');
        %     pitchAttTopLabel.Layout.Row = row;  pitchAttTopLabel.Layout.Column = 1;
        %     pitchAttTopEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchAttenuationAtTop, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.3f');
        %     pitchAttTopEdit.Layout.Row = row;  pitchAttTopEdit.Layout.Column = 2;  row = row+1;
        %     set([pitchAttTopLabel pitchAttTopEdit], 'Tooltip', 'Filtered methods only');
        % 
        %     pitchSilenceLabel = uilabel(innerGl, 'Text', 'Silence Threshold');
        %     pitchSilenceLabel.Layout.Row = row;  pitchSilenceLabel.Layout.Column = 1;
        %     pitchSilenceEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchSilenceThreshold, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
        %     pitchSilenceEdit.Layout.Row = row;  pitchSilenceEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchVoicingLabel = uilabel(innerGl, 'Text', 'Voicing Threshold');
        %     pitchVoicingLabel.Layout.Row = row;  pitchVoicingLabel.Layout.Column = 1;
        %     pitchVoicingEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchVoicingThreshold, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
        %     pitchVoicingEdit.Layout.Row = row;  pitchVoicingEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchOctCostLabel = uilabel(innerGl, 'Text', 'Octave Cost');
        %     pitchOctCostLabel.Layout.Row = row;  pitchOctCostLabel.Layout.Column = 1;
        %     pitchOctCostEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchOctaveCost, ...
        %         'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
        %     pitchOctCostEdit.Layout.Row = row;  pitchOctCostEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchOctJumpLabel = uilabel(innerGl, 'Text', 'Octave-Jump Cost');
        %     pitchOctJumpLabel.Layout.Row = row;  pitchOctJumpLabel.Layout.Column = 1;
        %     pitchOctJumpEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchOctaveJumpCost, ...
        %         'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
        %     pitchOctJumpEdit.Layout.Row = row;  pitchOctJumpEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchVuvLabel = uilabel(innerGl, 'Text', 'Voiced/Unvoiced Cost');
        %     pitchVuvLabel.Layout.Row = row;  pitchVuvLabel.Layout.Column = 1;
        %     pitchVuvEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchVuvCost, ...
        %         'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
        %     pitchVuvEdit.Layout.Row = row;  pitchVuvEdit.Layout.Column = 2;  row = row+1;
        % 
        %     pitchMaxCandLabel = uilabel(innerGl, 'Text', 'Max Candidates');
        %     pitchMaxCandLabel.Layout.Row = row;  pitchMaxCandLabel.Layout.Column = 1;
        %     pitchMaxCandEdit = uieditfield(innerGl, 'numeric', 'Value', pPitchMaxCandidates, ...
        %         'Limits', [1 30], 'ValueDisplayFormat', '%d');
        %     pitchMaxCandEdit.Layout.Row = row;  pitchMaxCandEdit.Layout.Column = 2;  row = row+1;
        % 
        %     % SHS-specific
        %     shsFreqMaxLabel = uilabel(innerGl, 'Text', 'SHS Max Frequency (Hz)');
        %     shsFreqMaxLabel.Layout.Row = row;  shsFreqMaxLabel.Layout.Column = 1;
        %     shsFreqMaxEdit = uieditfield(innerGl, 'numeric', 'Value', pShsFreqMax, ...
        %         'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
        %     shsFreqMaxEdit.Layout.Row = row;  shsFreqMaxEdit.Layout.Column = 2;  row = row+1;
        % 
        %     shsMaxSubLabel = uilabel(innerGl, 'Text', 'SHS Max Subharmonics');
        %     shsMaxSubLabel.Layout.Row = row;  shsMaxSubLabel.Layout.Column = 1;
        %     shsMaxSubEdit = uieditfield(innerGl, 'numeric', 'Value', pShsMaxSubharm, ...
        %         'Limits', [1 100], 'ValueDisplayFormat', '%d');
        %     shsMaxSubEdit.Layout.Row = row;  shsMaxSubEdit.Layout.Column = 2;  row = row+1;
        % 
        %     shsCompLabel = uilabel(innerGl, 'Text', 'SHS Compression');
        %     shsCompLabel.Layout.Row = row;  shsCompLabel.Layout.Column = 1;
        %     shsCompEdit = uieditfield(innerGl, 'numeric', 'Value', pShsCompression, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
        %     shsCompEdit.Layout.Row = row;  shsCompEdit.Layout.Column = 2;  row = row+1;
        % 
        %     shsPointsOctLabel = uilabel(innerGl, 'Text', 'SHS Points/Octave');
        %     shsPointsOctLabel.Layout.Row = row;  shsPointsOctLabel.Layout.Column = 1;
        %     shsPointsOctEdit = uieditfield(innerGl, 'numeric', 'Value', pShsPointsPerOctave, ...
        %         'Limits', [1 500], 'ValueDisplayFormat', '%d');
        %     shsPointsOctEdit.Layout.Row = row;  shsPointsOctEdit.Layout.Column = 2;  row = row+1;
        % 
        %     % SPINET-specific
        %     spinetWinLabel = uilabel(innerGl, 'Text', 'SPINET Window (s)');
        %     spinetWinLabel.Layout.Row = row;  spinetWinLabel.Layout.Column = 1;
        %     spinetWinEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetWinLen, ...
        %         'Limits', [0.001 1], 'ValueDisplayFormat', '%.3f');
        %     spinetWinEdit.Layout.Row = row;  spinetWinEdit.Layout.Column = 2;  row = row+1;
        % 
        %     spinetFBminLabel = uilabel(innerGl, 'Text', 'SPINET Gammatone Min (Hz)');
        %     spinetFBminLabel.Layout.Row = row;  spinetFBminLabel.Layout.Column = 1;
        %     spinetFBminEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBmin, ...
        %         'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
        %     spinetFBminEdit.Layout.Row = row;  spinetFBminEdit.Layout.Column = 2;  row = row+1;
        % 
        %     spinetFBmaxLabel = uilabel(innerGl, 'Text', 'SPINET Gammatone Max (Hz)');
        %     spinetFBmaxLabel.Layout.Row = row;  spinetFBmaxLabel.Layout.Column = 1;
        %     spinetFBmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBmax, ...
        %         'Limits', [1 fs/2], 'ValueDisplayFormat', '%.0f');
        %     spinetFBmaxEdit.Layout.Row = row;  spinetFBmaxEdit.Layout.Column = 2;  row = row+1;
        % 
        %     spinetFBnumLabel = uilabel(innerGl, 'Text', 'SPINET Num Filters');
        %     spinetFBnumLabel.Layout.Row = row;  spinetFBnumLabel.Layout.Column = 1;
        %     spinetFBnumEdit = uieditfield(innerGl, 'numeric', 'Value', pSpinetFBnum, ...
        %         'Limits', [1 1000], 'ValueDisplayFormat', '%d');
        %     spinetFBnumEdit.Layout.Row = row;  spinetFBnumEdit.Layout.Column = 2;  row = row+1;
        % 
        %     % Fill missing (all pitch-based methods)
        %     fillMissLabel = uilabel(innerGl, 'Text', 'Fill Missing');
        %     fillMissLabel.Layout.Row = row;  fillMissLabel.Layout.Column = 1;
        %     fillMissDd = uidropdown(innerGl, ...
        %         'Items', {'previous', 'next', 'nearest', 'linear', 'spline', 'pchip', 'makima', 'zero'}, ...
        %         'Value', pFillMissing);
        %     fillMissDd.Layout.Row = row;  fillMissDd.Layout.Column = 2;  row = row+1;
        % 
        %     sep2Label = uilabel(innerGl, 'Text', '');
        %     sep2Label.Layout.Row = row;  sep2Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== POINTPROCESS SECTION ======
        %     ppSecLabel = uilabel(innerGl, 'Text', '--- PointProcess Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     ppSecLabel.Layout.Row = row;  ppSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     ppMethodLabel = uilabel(innerGl, 'Text', 'PointProcess Method');
        %     ppMethodLabel.Layout.Row = row;  ppMethodLabel.Layout.Column = 1;
        %     ppMethodDd = uidropdown(innerGl, ...
        %         'Items', {'sound + pitch (cc)', 'sound + pitch (peaks)', 'pitch only', 'pitchtier'}, ...
        %         'ItemsData', {'sound+pitch_cc', 'sound+pitch_peaks', 'pitch_only', 'pitchtier'}, ...
        %         'Value', pPPmethod);
        %     ppMethodDd.Layout.Row = row;  ppMethodDd.Layout.Column = 2;  row = row+1;
        % 
        %     ppSelectMaxLabel = uilabel(innerGl, 'Text', 'Select Maxima (peaks)');
        %     ppSelectMaxLabel.Layout.Row = row;  ppSelectMaxLabel.Layout.Column = 1;
        %     ppSelectMaxDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pPPselectMax);
        %     ppSelectMaxDd.Layout.Row = row;  ppSelectMaxDd.Layout.Column = 2;  row = row+1;
        % 
        %     ppSelectMinLabel = uilabel(innerGl, 'Text', 'Select Minima (peaks)');
        %     ppSelectMinLabel.Layout.Row = row;  ppSelectMinLabel.Layout.Column = 1;
        %     ppSelectMinDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pPPselectMin);
        %     ppSelectMinDd.Layout.Row = row;  ppSelectMinDd.Layout.Column = 2;  row = row+1;
        % 
        %     sep3Label = uilabel(innerGl, 'Text', '');
        %     sep3Label.Layout.Row = row;  sep3Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== JITTER / SHIMMER SECTION ======
        %     jitterSecLabel = uilabel(innerGl, 'Text', '--- Jitter / Shimmer Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     jitterSecLabel.Layout.Row = row;  jitterSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     jitterShortLabel = uilabel(innerGl, 'Text', 'Shortest Period (s)');
        %     jitterShortLabel.Layout.Row = row;  jitterShortLabel.Layout.Column = 1;
        %     jitterShortEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterShortPeriod, ...
        %         'Limits', [1e-6 0.1], 'ValueDisplayFormat', '%.6f');
        %     jitterShortEdit.Layout.Row = row;  jitterShortEdit.Layout.Column = 2;  row = row+1;
        % 
        %     jitterLongLabel = uilabel(innerGl, 'Text', 'Longest Period (s)');
        %     jitterLongLabel.Layout.Row = row;  jitterLongLabel.Layout.Column = 1;
        %     jitterLongEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterLongPeriod, ...
        %         'Limits', [0.001 1], 'ValueDisplayFormat', '%.4f');
        %     jitterLongEdit.Layout.Row = row;  jitterLongEdit.Layout.Column = 2;  row = row+1;
        % 
        %     jitterMaxFactorLabel = uilabel(innerGl, 'Text', 'Max Period Factor');
        %     jitterMaxFactorLabel.Layout.Row = row;  jitterMaxFactorLabel.Layout.Column = 1;
        %     jitterMaxFactorEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterMaxFactor, ...
        %         'Limits', [1 10], 'ValueDisplayFormat', '%.2f');
        %     jitterMaxFactorEdit.Layout.Row = row;  jitterMaxFactorEdit.Layout.Column = 2;  row = row+1;
        % 
        %     jitterWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
        %     jitterWinLenLabel.Layout.Row = row;  jitterWinLenLabel.Layout.Column = 1;
        %     jitterWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterWinLen, ...
        %         'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
        %     jitterWinLenEdit.Layout.Row = row;  jitterWinLenEdit.Layout.Column = 2;  row = row+1;
        %     set([jitterWinLenLabel jitterWinLenEdit], 'Tooltip', '0 = entire range');
        % 
        %     jitterWinStepLabel = uilabel(innerGl, 'Text', 'Window Step (s)');
        %     jitterWinStepLabel.Layout.Row = row;  jitterWinStepLabel.Layout.Column = 1;
        %     jitterWinStepEdit = uieditfield(innerGl, 'numeric', 'Value', pJitterWinStep, ...
        %         'Limits', [0 10], 'ValueDisplayFormat', '%.3f');
        %     jitterWinStepEdit.Layout.Row = row;  jitterWinStepEdit.Layout.Column = 2;  row = row+1;
        % 
        %     shimmerAmpMaxLabel = uilabel(innerGl, 'Text', 'Max Amplitude Factor');
        %     shimmerAmpMaxLabel.Layout.Row = row;  shimmerAmpMaxLabel.Layout.Column = 1;
        %     shimmerAmpMaxEdit = uieditfield(innerGl, 'numeric', 'Value', pShimmerMaxAmpFactor, ...
        %         'Limits', [1 10], 'ValueDisplayFormat', '%.2f');
        %     shimmerAmpMaxEdit.Layout.Row = row;  shimmerAmpMaxEdit.Layout.Column = 2;  row = row+1;
        % 
        %     sep4Label = uilabel(innerGl, 'Text', '');
        %     sep4Label.Layout.Row = row;  sep4Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== FORMANT SECTION ======
        %     fmtSecLabel = uilabel(innerGl, 'Text', '--- Formant Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     fmtSecLabel.Layout.Row = row;  fmtSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     fmtMethodLabel = uilabel(innerGl, 'Text', 'Formant Method');
        %     fmtMethodLabel.Layout.Row = row;  fmtMethodLabel.Layout.Column = 1;
        %     fmtMethodDd = uidropdown(innerGl, 'Items', {'Burg', 'Split-Levinson', 'Robust'}, ...
        %         'ItemsData', {'burg', 'sl', 'robust'}, 'Value', pFmtMethod);
        %     fmtMethodDd.Layout.Row = row;  fmtMethodDd.Layout.Column = 2;  row = row+1;
        % 
        %     fmtMaxFormantsLabel = uilabel(innerGl, 'Text', 'Max # Formants');
        %     fmtMaxFormantsLabel.Layout.Row = row;  fmtMaxFormantsLabel.Layout.Column = 1;
        %     fmtMaxFormantsEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtMaxFormants, ...
        %         'Limits', [1 10], 'ValueDisplayFormat', '%d');
        %     fmtMaxFormantsEdit.Layout.Row = row;  fmtMaxFormantsEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtCeilingLabel = uilabel(innerGl, 'Text', 'Ceiling (Hz)');
        %     fmtCeilingLabel.Layout.Row = row;  fmtCeilingLabel.Layout.Column = 1;
        %     fmtCeilingEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtCeiling, ...
        %         'Limits', [500 fs/2], 'ValueDisplayFormat', '%.0f');
        %     fmtCeilingEdit.Layout.Row = row;  fmtCeilingEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
        %     fmtWinLenLabel.Layout.Row = row;  fmtWinLenLabel.Layout.Column = 1;
        %     fmtWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtWinLen, ...
        %         'Limits', [0.001 1], 'ValueDisplayFormat', '%.4f');
        %     fmtWinLenEdit.Layout.Row = row;  fmtWinLenEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtPreEmphLabel = uilabel(innerGl, 'Text', 'Pre-Emphasis (Hz)');
        %     fmtPreEmphLabel.Layout.Row = row;  fmtPreEmphLabel.Layout.Column = 1;
        %     fmtPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtPreEmph, ...
        %         'Limits', [0 fs/2], 'ValueDisplayFormat', '%.0f');
        %     fmtPreEmphEdit.Layout.Row = row;  fmtPreEmphEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRobustStdLabel = uilabel(innerGl, 'Text', 'Robust # StdDev');
        %     fmtRobustStdLabel.Layout.Row = row;  fmtRobustStdLabel.Layout.Column = 1;
        %     fmtRobustStdEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustStd, ...
        %         'Limits', [0.1 10], 'ValueDisplayFormat', '%.1f');
        %     fmtRobustStdEdit.Layout.Row = row;  fmtRobustStdEdit.Layout.Column = 2;  row = row+1;
        %     set([fmtRobustStdLabel fmtRobustStdEdit], 'Tooltip', 'Robust method only');
        % 
        %     fmtRobustIterLabel = uilabel(innerGl, 'Text', 'Robust Iterations');
        %     fmtRobustIterLabel.Layout.Row = row;  fmtRobustIterLabel.Layout.Column = 1;
        %     fmtRobustIterEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustIter, ...
        %         'Limits', [1 100], 'ValueDisplayFormat', '%d');
        %     fmtRobustIterEdit.Layout.Row = row;  fmtRobustIterEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRobustTolLabel = uilabel(innerGl, 'Text', 'Robust Tolerance');
        %     fmtRobustTolLabel.Layout.Row = row;  fmtRobustTolLabel.Layout.Column = 1;
        %     fmtRobustTolEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtRobustTol, ...
        %         'Limits', [1e-12 1], 'ValueDisplayFormat', '%.1e');
        %     fmtRobustTolEdit.Layout.Row = row;  fmtRobustTolEdit.Layout.Column = 2;  row = row+1;
        % 
        %     % Formant Tracking
        %     fmtTrackLabel = uilabel(innerGl, 'Text', 'Track Formants');
        %     fmtTrackLabel.Layout.Row = row;  fmtTrackLabel.Layout.Column = 1;
        %     fmtTrackDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pFmtTrack);
        %     fmtTrackDd.Layout.Row = row;  fmtTrackDd.Layout.Column = 2;  row = row+1;
        % 
        %     fmtTrackNLabel = uilabel(innerGl, 'Text', 'Num Tracks');
        %     fmtTrackNLabel.Layout.Row = row;  fmtTrackNLabel.Layout.Column = 1;
        %     fmtTrackNEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtTrackN, ...
        %         'Limits', [1 5], 'ValueDisplayFormat', '%d');
        %     fmtTrackNEdit.Layout.Row = row;  fmtTrackNEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRef1Label = uilabel(innerGl, 'Text', 'Ref F1 (Hz)');
        %     fmtRef1Label.Layout.Row = row;  fmtRef1Label.Layout.Column = 1;
        %     fmtRef1Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef1, ...
        %         'Limits', [50 2000], 'ValueDisplayFormat', '%.0f');
        %     fmtRef1Edit.Layout.Row = row;  fmtRef1Edit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRef2Label = uilabel(innerGl, 'Text', 'Ref F2 (Hz)');
        %     fmtRef2Label.Layout.Row = row;  fmtRef2Label.Layout.Column = 1;
        %     fmtRef2Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef2, ...
        %         'Limits', [100 5000], 'ValueDisplayFormat', '%.0f');
        %     fmtRef2Edit.Layout.Row = row;  fmtRef2Edit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRef3Label = uilabel(innerGl, 'Text', 'Ref F3 (Hz)');
        %     fmtRef3Label.Layout.Row = row;  fmtRef3Label.Layout.Column = 1;
        %     fmtRef3Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef3, ...
        %         'Limits', [200 8000], 'ValueDisplayFormat', '%.0f');
        %     fmtRef3Edit.Layout.Row = row;  fmtRef3Edit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRef4Label = uilabel(innerGl, 'Text', 'Ref F4 (Hz)');
        %     fmtRef4Label.Layout.Row = row;  fmtRef4Label.Layout.Column = 1;
        %     fmtRef4Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef4, ...
        %         'Limits', [300 10000], 'ValueDisplayFormat', '%.0f');
        %     fmtRef4Edit.Layout.Row = row;  fmtRef4Edit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtRef5Label = uilabel(innerGl, 'Text', 'Ref F5 (Hz)');
        %     fmtRef5Label.Layout.Row = row;  fmtRef5Label.Layout.Column = 1;
        %     fmtRef5Edit = uieditfield(innerGl, 'numeric', 'Value', pFmtRef5, ...
        %         'Limits', [400 12000], 'ValueDisplayFormat', '%.0f');
        %     fmtRef5Edit.Layout.Row = row;  fmtRef5Edit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtFreqCostLabel = uilabel(innerGl, 'Text', 'Frequency Cost (/kHz)');
        %     fmtFreqCostLabel.Layout.Row = row;  fmtFreqCostLabel.Layout.Column = 1;
        %     fmtFreqCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtFreqCost, ...
        %         'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
        %     fmtFreqCostEdit.Layout.Row = row;  fmtFreqCostEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtBandCostLabel = uilabel(innerGl, 'Text', 'Bandwidth Cost');
        %     fmtBandCostLabel.Layout.Row = row;  fmtBandCostLabel.Layout.Column = 1;
        %     fmtBandCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtBandCost, ...
        %         'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
        %     fmtBandCostEdit.Layout.Row = row;  fmtBandCostEdit.Layout.Column = 2;  row = row+1;
        % 
        %     fmtTransCostLabel = uilabel(innerGl, 'Text', 'Transition Cost/Oct');
        %     fmtTransCostLabel.Layout.Row = row;  fmtTransCostLabel.Layout.Column = 1;
        %     fmtTransCostEdit = uieditfield(innerGl, 'numeric', 'Value', pFmtTransCost, ...
        %         'Limits', [0 100], 'ValueDisplayFormat', '%.1f');
        %     fmtTransCostEdit.Layout.Row = row;  fmtTransCostEdit.Layout.Column = 2;  row = row+1;
        % 
        %     sep5Label = uilabel(innerGl, 'Text', '');
        %     sep5Label.Layout.Row = row;  sep5Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== INTENSITY SECTION ======
        %     intSecLabel = uilabel(innerGl, 'Text', '--- Intensity Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     intSecLabel.Layout.Row = row;  intSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     intMinPitchLabel = uilabel(innerGl, 'Text', 'Min Pitch (Hz)');
        %     intMinPitchLabel.Layout.Row = row;  intMinPitchLabel.Layout.Column = 1;
        %     intMinPitchEdit = uieditfield(innerGl, 'numeric', 'Value', pIntMinPitch, ...
        %         'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
        %     intMinPitchEdit.Layout.Row = row;  intMinPitchEdit.Layout.Column = 2;  row = row+1;
        % 
        %     intWinLenLabel = uilabel(innerGl, 'Text', 'Window Length (s)');
        %     intWinLenLabel.Layout.Row = row;  intWinLenLabel.Layout.Column = 1;
        %     intWinLenEdit = uieditfield(innerGl, 'numeric', 'Value', pIntWinLen, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.3f');
        %     intWinLenEdit.Layout.Row = row;  intWinLenEdit.Layout.Column = 2;  row = row+1;
        %     set([intWinLenLabel intWinLenEdit], 'Tooltip', '0 = auto');
        % 
        %     intSubMeanLabel = uilabel(innerGl, 'Text', 'Subtract Mean');
        %     intSubMeanLabel.Layout.Row = row;  intSubMeanLabel.Layout.Column = 1;
        %     intSubMeanDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pIntSubMean);
        %     intSubMeanDd.Layout.Row = row;  intSubMeanDd.Layout.Column = 2;  row = row+1;
        % 
        %     sep6Label = uilabel(innerGl, 'Text', '');
        %     sep6Label.Layout.Row = row;  sep6Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== HARMONICITY SECTION ======
        %     hnrSecLabel = uilabel(innerGl, 'Text', '--- Harmonicity Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     hnrSecLabel.Layout.Row = row;  hnrSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     hnrTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
        %     hnrTimeStepLabel.Layout.Row = row;  hnrTimeStepLabel.Layout.Column = 1;
        %     hnrTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrTimeStep, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
        %     hnrTimeStepEdit.Layout.Row = row;  hnrTimeStepEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrPitchFloorLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
        %     hnrPitchFloorLabel.Layout.Row = row;  hnrPitchFloorLabel.Layout.Column = 1;
        %     hnrPitchFloorEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrPitchFloor, ...
        %         'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
        %     hnrPitchFloorEdit.Layout.Row = row;  hnrPitchFloorEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrSilenceLabel = uilabel(innerGl, 'Text', 'Silence Threshold');
        %     hnrSilenceLabel.Layout.Row = row;  hnrSilenceLabel.Layout.Column = 1;
        %     hnrSilenceEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrSilence, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.2f');
        %     hnrSilenceEdit.Layout.Row = row;  hnrSilenceEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrPeriodsLabel = uilabel(innerGl, 'Text', 'Periods / Window');
        %     hnrPeriodsLabel.Layout.Row = row;  hnrPeriodsLabel.Layout.Column = 1;
        %     hnrPeriodsEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrPeriods, ...
        %         'Limits', [1 20], 'ValueDisplayFormat', '%.1f');
        %     hnrPeriodsEdit.Layout.Row = row;  hnrPeriodsEdit.Layout.Column = 2;  row = row+1;
        % 
        %     sepHnrLabel = uilabel(innerGl, 'Text', '');
        %     sepHnrLabel.Layout.Row = row;  sepHnrLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     hnrGNELabel = uilabel(innerGl, 'Text', '--- GNE Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     hnrGNELabel.Layout.Row = row;  hnrGNELabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     hnrGNEminLabel = uilabel(innerGl, 'Text', 'GNE Min Freq (Hz)');
        %     hnrGNEminLabel.Layout.Row = row;  hnrGNEminLabel.Layout.Column = 1;
        %     hnrGNEminEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEmin, ...
        %         'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
        %     hnrGNEminEdit.Layout.Row = row;  hnrGNEminEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrGNEmaxLabel = uilabel(innerGl, 'Text', 'GNE Max Freq (Hz)');
        %     hnrGNEmaxLabel.Layout.Row = row;  hnrGNEmaxLabel.Layout.Column = 1;
        %     hnrGNEmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEmax, ...
        %         'Limits', [20 fs/2], 'ValueDisplayFormat', '%.0f');
        %     hnrGNEmaxEdit.Layout.Row = row;  hnrGNEmaxEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrGNEBWLabel = uilabel(innerGl, 'Text', 'GNE Bandwidth (Hz)');
        %     hnrGNEBWLabel.Layout.Row = row;  hnrGNEBWLabel.Layout.Column = 1;
        %     hnrGNEBWEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEBW, ...
        %         'Limits', [10 10000], 'ValueDisplayFormat', '%.0f');
        %     hnrGNEBWEdit.Layout.Row = row;  hnrGNEBWEdit.Layout.Column = 2;  row = row+1;
        % 
        %     hnrGNEStepLabel = uilabel(innerGl, 'Text', 'GNE Step (Hz)');
        %     hnrGNEStepLabel.Layout.Row = row;  hnrGNEStepLabel.Layout.Column = 1;
        %     hnrGNEStepEdit = uieditfield(innerGl, 'numeric', 'Value', pHnrGNEStep, ...
        %         'Limits', [1 1000], 'ValueDisplayFormat', '%.0f');
        %     hnrGNEStepEdit.Layout.Row = row;  hnrGNEStepEdit.Layout.Column = 2;  row = row+1;
        % 
        %     sep7Label = uilabel(innerGl, 'Text', '');
        %     sep7Label.Layout.Row = row;  sep7Label.Layout.Column = [1 2];  row = row+1;
        % 
        %     % ====== CPP/CPPS SECTION ======
        %     cppSecLabel = uilabel(innerGl, 'Text', '--- CPP/CPPS Settings ---', ...
        %         'FontWeight', 'bold', 'FontAngle', 'italic');
        %     cppSecLabel.Layout.Row = row;  cppSecLabel.Layout.Column = [1 2];  row = row+1;
        % 
        %     cppPitchFLabel = uilabel(innerGl, 'Text', 'Pitch Floor (Hz)');
        %     cppPitchFLabel.Layout.Row = row;  cppPitchFLabel.Layout.Column = 1;
        %     cppPitchFEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPitchFloor, ...
        %         'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
        %     cppPitchFEdit.Layout.Row = row;  cppPitchFEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppTimeStepLabel = uilabel(innerGl, 'Text', 'Time Step (s)');
        %     cppTimeStepLabel.Layout.Row = row;  cppTimeStepLabel.Layout.Column = 1;
        %     cppTimeStepEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTimeStep, ...
        %         'Limits', [0.0001 1], 'ValueDisplayFormat', '%.4f');
        %     cppTimeStepEdit.Layout.Row = row;  cppTimeStepEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppMaxFreqLabel = uilabel(innerGl, 'Text', 'Max Frequency (Hz)');
        %     cppMaxFreqLabel.Layout.Row = row;  cppMaxFreqLabel.Layout.Column = 1;
        %     cppMaxFreqEdit = uieditfield(innerGl, 'numeric', 'Value', pCppMaxFreq, ...
        %         'Limits', [100 fs/2], 'ValueDisplayFormat', '%.0f');
        %     cppMaxFreqEdit.Layout.Row = row;  cppMaxFreqEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppPreEmphLabel = uilabel(innerGl, 'Text', 'Pre-Emphasis (Hz)');
        %     cppPreEmphLabel.Layout.Row = row;  cppPreEmphLabel.Layout.Column = 1;
        %     cppPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPreEmph, ...
        %         'Limits', [0 fs/2], 'ValueDisplayFormat', '%.0f');
        %     cppPreEmphEdit.Layout.Row = row;  cppPreEmphEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppRemoveTrendLabel = uilabel(innerGl, 'Text', 'Remove Trend');
        %     cppRemoveTrendLabel.Layout.Row = row;  cppRemoveTrendLabel.Layout.Column = 1;
        %     cppRemoveTrendDd = uidropdown(innerGl, 'Items', {'yes', 'no'}, 'Value', pCppRemoveTrend);
        %     cppRemoveTrendDd.Layout.Row = row;  cppRemoveTrendDd.Layout.Column = 2;  row = row+1;
        % 
        %     cppTimeAvgLabel = uilabel(innerGl, 'Text', 'Time Avg Window (s)');
        %     cppTimeAvgLabel.Layout.Row = row;  cppTimeAvgLabel.Layout.Column = 1;
        %     cppTimeAvgEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTimeAvg, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
        %     cppTimeAvgEdit.Layout.Row = row;  cppTimeAvgEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppQuefAvgLabel = uilabel(innerGl, 'Text', 'Quefrency Avg (s)');
        %     cppQuefAvgLabel.Layout.Row = row;  cppQuefAvgLabel.Layout.Column = 1;
        %     cppQuefAvgEdit = uieditfield(innerGl, 'numeric', 'Value', pCppQuefAvg, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.5f');
        %     cppQuefAvgEdit.Layout.Row = row;  cppQuefAvgEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppPeakFminLabel = uilabel(innerGl, 'Text', 'Peak Search f_min (Hz)');
        %     cppPeakFminLabel.Layout.Row = row;  cppPeakFminLabel.Layout.Column = 1;
        %     cppPeakFminEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakFmin, ...
        %         'Limits', [20 500], 'ValueDisplayFormat', '%.0f');
        %     cppPeakFminEdit.Layout.Row = row;  cppPeakFminEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppPeakFmaxLabel = uilabel(innerGl, 'Text', 'Peak Search f_max (Hz)');
        %     cppPeakFmaxLabel.Layout.Row = row;  cppPeakFmaxLabel.Layout.Column = 1;
        %     cppPeakFmaxEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakFmax, ...
        %         'Limits', [50 fs/2], 'ValueDisplayFormat', '%.0f');
        %     cppPeakFmaxEdit.Layout.Row = row;  cppPeakFmaxEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppPeakPreEmphLabel = uilabel(innerGl, 'Text', 'Peak Pre-Emphasis (Hz)');
        %     cppPeakPreEmphLabel.Layout.Row = row;  cppPeakPreEmphLabel.Layout.Column = 1;
        %     cppPeakPreEmphEdit = uieditfield(innerGl, 'numeric', 'Value', pCppPeakPreEmph, ...
        %         'Limits', [0 fs/2], 'ValueDisplayFormat', '%.2f');
        %     cppPeakPreEmphEdit.Layout.Row = row;  cppPeakPreEmphEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppPeakInterpLabel = uilabel(innerGl, 'Text', 'Peak Interpolation');
        %     cppPeakInterpLabel.Layout.Row = row;  cppPeakInterpLabel.Layout.Column = 1;
        %     cppPeakInterpDd = uidropdown(innerGl, ...
        %         'Items', {'none', 'parabolic', 'cubic', 'sinc70', 'sinc700'}, ...
        %         'Value', pCppPeakInterp);
        %     cppPeakInterpDd.Layout.Row = row;  cppPeakInterpDd.Layout.Column = 2;  row = row+1;
        % 
        %     cppTrendLowLabel = uilabel(innerGl, 'Text', 'Trend Lower Bound (s)');
        %     cppTrendLowLabel.Layout.Row = row;  cppTrendLowLabel.Layout.Column = 1;
        %     cppTrendLowEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTrendLow, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
        %     cppTrendLowEdit.Layout.Row = row;  cppTrendLowEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppTrendHighLabel = uilabel(innerGl, 'Text', 'Trend Upper Bound (s)');
        %     cppTrendHighLabel.Layout.Row = row;  cppTrendHighLabel.Layout.Column = 1;
        %     cppTrendHighEdit = uieditfield(innerGl, 'numeric', 'Value', pCppTrendHigh, ...
        %         'Limits', [0 1], 'ValueDisplayFormat', '%.4f');
        %     cppTrendHighEdit.Layout.Row = row;  cppTrendHighEdit.Layout.Column = 2;  row = row+1;
        % 
        %     cppTrendTypeLabel = uilabel(innerGl, 'Text', 'Trend Type');
        %     cppTrendTypeLabel.Layout.Row = row;  cppTrendTypeLabel.Layout.Column = 1;
        %     cppTrendTypeDd = uidropdown(innerGl, ...
        %         'Items', {'straight', 'Exponential decay'}, 'Value', pCppTrendType);
        %     cppTrendTypeDd.Layout.Row = row;  cppTrendTypeDd.Layout.Column = 2;  row = row+1;
        % 
        %     cppFitMethodLabel = uilabel(innerGl, 'Text', 'Fit Method');
        %     cppFitMethodLabel.Layout.Row = row;  cppFitMethodLabel.Layout.Column = 1;
        %     cppFitMethodDd = uidropdown(innerGl, ...
        %         'Items', {'Robust slow', 'Robust', 'Least squares'}, 'Value', pCppFitMethod);
        %     cppFitMethodDd.Layout.Row = row;  cppFitMethodDd.Layout.Column = 2;  row = row+1;
        % 
        %     runBtn = uibutton(buttonGl, 'Text', 'Run Analysis', 'FontWeight', 'bold', ...
        %         'ButtonPushedFcn', @(s,e) runAnalysis());
        %     runBtn.Layout.Row = 1;  runBtn.Layout.Column = 1;
        % 
        %     applyBtn = uibutton(buttonGl, 'Text', 'Apply && Close', 'FontWeight', 'bold', ...
        %         'ButtonPushedFcn', @(s,e) saveAndClose());
        %     applyBtn.Layout.Row = 1;  applyBtn.Layout.Column = 2;
        % 
        %     cancelBtn = uibutton(buttonGl, 'Text', 'Cancel', ...
        %         'ButtonPushedFcn', @(s,e) cancelAndClose());
        %     cancelBtn.Layout.Row = 2;  cancelBtn.Layout.Column = [1 2];
        % 
        %     %% -- RIGHT PANEL: Preview axes --
        %     rightPnl = uipanel(gl, 'Title', 'Preview', 'FontWeight', 'bold', ...
        %         'BorderType', 'none');
        %     rightPnl.Layout.Column = 2;
        %     % tiledlayout will be created dynamically inside rightPnl
        %     tl = [];
        %     ax = gobjects(0);
        % 
        %     %% COLLECT ALL CONTROL HANDLES (for visibility management)
        %     % Pitch group
        %     allPitchControls = [pitchMethodLabel pitchMethodDd ...
        %         pitchFloorLabel pitchFloorEdit pitchCeilingLabel pitchCeilingEdit ...
        %         pitchTimeStepLabel pitchTimeStepEdit ...
        %         pitchVeryAccLabel pitchVeryAccDd ...
        %         pitchAttTopLabel pitchAttTopEdit ...
        %         pitchSilenceLabel pitchSilenceEdit pitchVoicingLabel pitchVoicingEdit ...
        %         pitchOctCostLabel pitchOctCostEdit pitchOctJumpLabel pitchOctJumpEdit ...
        %         pitchVuvLabel pitchVuvEdit pitchMaxCandLabel pitchMaxCandEdit ...
        %         fillMissLabel fillMissDd];
        % 
        %     shsControls = [shsFreqMaxLabel shsFreqMaxEdit shsMaxSubLabel shsMaxSubEdit ...
        %         shsCompLabel shsCompEdit shsPointsOctLabel shsPointsOctEdit];
        % 
        %     spinetControls = [spinetWinLabel spinetWinEdit spinetFBminLabel spinetFBminEdit ...
        %         spinetFBmaxLabel spinetFBmaxEdit spinetFBnumLabel spinetFBnumEdit];
        % 
        %     filteredOnlyControls = [pitchAttTopLabel pitchAttTopEdit];
        % 
        %     ppControls = [ppSecLabel ppMethodLabel ppMethodDd ...
        %         ppSelectMaxLabel ppSelectMaxDd ppSelectMinLabel ppSelectMinDd];
        % 
        %     jitterControls = [jitterSecLabel jitterShortLabel jitterShortEdit ...
        %         jitterLongLabel jitterLongEdit jitterMaxFactorLabel jitterMaxFactorEdit ...
        %         jitterWinLenLabel jitterWinLenEdit jitterWinStepLabel jitterWinStepEdit];
        % 
        %     shimmerExtraControls = [shimmerAmpMaxLabel shimmerAmpMaxEdit];
        % 
        %     fmtControls = [fmtSecLabel fmtMethodLabel fmtMethodDd ...
        %         fmtMaxFormantsLabel fmtMaxFormantsEdit fmtCeilingLabel fmtCeilingEdit ...
        %         fmtWinLenLabel fmtWinLenEdit fmtPreEmphLabel fmtPreEmphEdit ...
        %         fmtRobustStdLabel fmtRobustStdEdit fmtRobustIterLabel fmtRobustIterEdit ...
        %         fmtRobustTolLabel fmtRobustTolEdit ...
        %         fmtTrackLabel fmtTrackDd fmtTrackNLabel fmtTrackNEdit ...
        %         fmtRef1Label fmtRef1Edit fmtRef2Label fmtRef2Edit ...
        %         fmtRef3Label fmtRef3Edit fmtRef4Label fmtRef4Edit ...
        %         fmtRef5Label fmtRef5Edit ...
        %         fmtFreqCostLabel fmtFreqCostEdit fmtBandCostLabel fmtBandCostEdit ...
        %         fmtTransCostLabel fmtTransCostEdit];
        % 
        %     intControls = [intSecLabel intMinPitchLabel intMinPitchEdit ...
        %         intWinLenLabel intWinLenEdit intSubMeanLabel intSubMeanDd];
        % 
        %     hnrControls = [hnrSecLabel hnrTimeStepLabel hnrTimeStepEdit ...
        %         hnrPitchFloorLabel hnrPitchFloorEdit hnrSilenceLabel hnrSilenceEdit ...
        %         hnrPeriodsLabel hnrPeriodsEdit ...
        %         hnrGNELabel hnrGNEminLabel hnrGNEminEdit hnrGNEmaxLabel hnrGNEmaxEdit ...
        %         hnrGNEBWLabel hnrGNEBWEdit hnrGNEStepLabel hnrGNEStepEdit];
        % 
        %     cppControls = [cppSecLabel cppPitchFLabel cppPitchFEdit ...
        %         cppTimeStepLabel cppTimeStepEdit cppMaxFreqLabel cppMaxFreqEdit ...
        %         cppPreEmphLabel cppPreEmphEdit cppRemoveTrendLabel cppRemoveTrendDd ...
        %         cppTimeAvgLabel cppTimeAvgEdit cppQuefAvgLabel cppQuefAvgEdit ...
        %         cppPeakFminLabel cppPeakFminEdit cppPeakFmaxLabel cppPeakFmaxEdit ...
        %         cppPeakPreEmphLabel cppPeakPreEmphEdit cppPeakInterpLabel cppPeakInterpDd ...
        %         cppTrendLowLabel cppTrendLowEdit cppTrendHighLabel cppTrendHighEdit ...
        %         cppTrendTypeLabel cppTrendTypeDd cppFitMethodLabel cppFitMethodDd];
        % 
        %     %% Apply initial visibility
        %     setVisibility();
        % 
        %     %% --- Callback: Analysis type changed ---
        %     function onAnalysisTypeChange()
        %         setVisibility();
        %         rebuildPreviewPanel();
        %         runAnalysis();
        %     end
        % 
        %     %% --- Visibility management ---
        %     function setVisibility()
        %         atype = analysisDd.Value;
        %         % Hide all method-specific sections
        %         allSections = [allPitchControls shsControls spinetControls ...
        %             ppControls jitterControls shimmerExtraControls ...
        %             fmtControls intControls hnrControls cppControls ...
        %             pitchSecLabel sepLabel sep2Label sep3Label sep4Label ...
        %             sep5Label sep6Label sep7Label sepHnrLabel];
        %         set(allSections, 'Visible', 'off');
        % 
        %         pitchSecLabel.Visible = 'on';
        %         set(allPitchControls, 'Visible', 'on');
        % 
        %         switch atype
        %             case 'Pitch'
        %                 % Show pitch section + SHS/SPINET sub-controls
        %                 pitchSecLabel.Visible = 'on';
        %                 set(allPitchControls, 'Visible', 'on');
        %                 updatePitchSubVisibility();
        % 
        %             case 'PointProcess'
        %                 pitchSecLabel.Visible = 'on';
        %                 set(allPitchControls, 'Visible', 'on');
        %                 set(ppControls, 'Visible', 'on');
        %                 updatePitchSubVisibility();
        % 
        %             case 'Jitter'
        %                 pitchSecLabel.Visible = 'on';
        %                 set(allPitchControls, 'Visible', 'on');
        %                 set(ppControls, 'Visible', 'on');
        %                 set(jitterControls, 'Visible', 'on');
        %                 updatePitchSubVisibility();
        % 
        %             case 'Shimmer'
        %                 pitchSecLabel.Visible = 'on';
        %                 set(allPitchControls, 'Visible', 'on');
        %                 set(ppControls, 'Visible', 'on');
        %                 set(jitterControls, 'Visible', 'on');
        %                 set(shimmerExtraControls, 'Visible', 'on');
        %                 updatePitchSubVisibility();
        % 
        %             case 'Formant'
        %                 set(fmtControls, 'Visible', 'on');
        % 
        %             case 'Intensity'
        %                 set(intControls, 'Visible', 'on');
        % 
        %             case 'Harmonicity (HNR/GNE)'
        %                 set(hnrControls, 'Visible', 'on');
        % 
        %             case 'CPP/CPPS'
        %                 set(cppControls, 'Visible', 'on');
        %         end
        %         updateRowHeights();
        %     end
        % 
        %     function updateRowHeights()
        %         children = innerGl.Children;
        %         nRows = length(innerGl.RowHeight);
        %         newHeights = cell(1, nRows);
        %         for ri = 1:nRows
        %             newHeights{ri} = 0;
        %             for ci = 1:length(children)
        %                 if isprop(children(ci), 'Layout') && isprop(children(ci).Layout, 'Row') ...
        %                         && children(ci).Layout.Row == ri
        %                     if strcmp(children(ci).Visible, 'on')
        %                         newHeights{ri} = 'fit';
        %                         break;
        %                     end
        %                 end
        %             end
        %         end
        %         innerGl.RowHeight = newHeights;
        %     end
        % 
        %     function updatePitchSubVisibility()
        %         pm = pitchMethodDd.Value;
        %         isFiltered = ismember(pm, {'filtered_autocorrelation', 'filtered_cross_correlation'});
        %         isShs = strcmp(pm, 'shs');
        %         isSpinet = strcmp(pm, 'SPINET');
        % 
        %         set(filteredOnlyControls, 'Visible', isFiltered);
        %         set(shsControls, 'Visible', isShs);
        %         set(spinetControls, 'Visible', isSpinet);
        %     end
        % 
        %     %% --- Rebuild preview panel ---
        %     function rebuildPreviewPanel()
        %         atype = analysisDd.Value;
        %         nAxes = getNumAxes(atype);
        % 
        %         delete(rightPnl.Children);
        %         tl = tiledlayout(rightPnl, nAxes, 1, ...
        %             'Padding', 'compact', 'TileSpacing', 'compact');
        % 
        %         ax = gobjects(nAxes, 1);
        %         titles = getAxisTitles(atype);
        %         for i = 1:nAxes
        %             ax(i) = nexttile(tl);
        %             title(ax(i), titles{i}, 'Interpreter', 'none');
        %             xlabel(ax(i), 'Time (s)');
        %         end
        %         linkaxes(ax, 'x');
        %         axtoolbar(tl, {'zoom', 'pan', 'restoreview', 'datacursor', 'export'});
        %     end
        % 
        %     function n = getNumAxes(atype)
        %         switch atype
        %             case 'Pitch',          n = 2;
        %             case 'PointProcess',   n = 2;
        %             case 'Jitter',         n = 3;
        %             case 'Shimmer',        n = 3;
        %             case 'Formant',        n = 2;
        %             case 'Intensity',      n = 2;
        %             case 'Harmonicity (HNR/GNE)', n = 2;
        %             case 'CPP/CPPS',       n = 2;
        %             otherwise,             n = 1;
        %         end
        %     end
        % 
        %     function titles = getAxisTitles(atype)
        %         switch atype
        %             case 'Pitch'
        %                 titles = {'Raw Data', 'Pitch Contour (Hz)'};
        %             case 'PointProcess'
        %                 titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)'};
        %             case 'Jitter'
        %                 titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)', 'Jitter Metrics'};
        %             case 'Shimmer'
        %                 titles = {'Raw Data + Pulses', 'Pitch Contour (Hz)', 'Shimmer Metrics'};
        %             case 'Formant'
        %                 titles = {'Raw Data', 'Formant Tracks (Hz)'};
        %             case 'Intensity'
        %                 titles = {'Raw Data', 'Intensity (dB)'};
        %             case 'Harmonicity (HNR/GNE)'
        %                 titles = {'Raw Data', 'HNR (dB)'};
        %             case 'CPP/CPPS'
        %                 titles = {'Raw Data', 'CPP / CPPS (dB)'};
        %         end
        %     end
        % 
        %     %% --- RUN ANALYSIS ---
        %     function runAnalysis()
        %         if isempty(tl) || ~isvalid(tl)
        %             rebuildPreviewPanel();
        %         end
        % 
        %         atype = analysisDd.Value;
        %         progDlg = uiprogressdlg(fig, 'Indeterminate', 'on', ...
        %             'Message', sprintf('Running %s analysis...', atype));
        %         drawnow;
        % 
        %         % Write audio to temp file
        %         wavFile = fullfile(tempdir, 'praat_analysis_input.wav');
        %         audiowrite(wavFile, y, fs, 'BitsPerSample', 64);
        % 
        %         scriptDir = fullfile(pwd, '+usePraatViaMatlab');
        %         if ~isfolder(scriptDir)
        %             scriptDir = fullfile(fileparts(mfilename('fullpath')), '+usePraatViaMatlab');
        %         end
        %         outFile = fullfile(tempdir, 'praat_analysis_output.txt');
        % 
        %         try
        %             switch atype
        %                 case 'Pitch'
        %                     results = runPitch(wavFile, scriptDir, outFile);
        %                 case 'PointProcess'
        %                     results = runPointProcess(wavFile, scriptDir, outFile);
        %                 case 'Jitter'
        %                     results = runJitter(wavFile, scriptDir, outFile);
        %                 case 'Shimmer'
        %                     results = runShimmer(wavFile, scriptDir, outFile);
        %                 case 'Formant'
        %                     results = runFormant(wavFile, scriptDir, outFile);
        %                 case 'Intensity'
        %                     results = runIntensity(wavFile, scriptDir, outFile);
        %                 case 'Harmonicity (HNR/GNE)'
        %                     results = runHarmonicity(wavFile, scriptDir, outFile);
        %                 case 'CPP/CPPS'
        %                     results = runCppCpps(wavFile, scriptDir, outFile);
        %                 otherwise
        %                     error('Unknown analysis type: %s', atype);
        %             end
        %             plotResults(atype, results);
        %             fig.UserData.lastResults = results;
        %             fig.UserData.lastAnalysisType = atype;
        %         catch ME
        %             delete(progDlg);
        %             uialert(fig, ME.message, 'Analysis Error');
        %             return;
        %         end
        %         delete(progDlg);
        %     end
        % 
        %     %% --- Individual analysis runners ---
        %     function results = runPitch(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_pitch_analysis.praat');
        %         pm = pitchMethodDd.Value;
        %         tstep = pitchTimeStepEdit.Value;
        %         if tstep == 0
        %             tstep = 0.8 / pitchFloorEdit.Value;
        %         end
        % 
        %         args = {'PitchMethod', pm, 'PitchTimeStep_s', tstep, ...
        %             'PitchFloor_Hz', pitchFloorEdit.Value, ...
        %             'PitchCeiling_Hz', pitchCeilingEdit.Value, ...
        %             'PitchMaxNumberOfCandidates', pitchMaxCandEdit.Value, ...
        %             'PitchVeryAccurate', pitchVeryAccDd.Value, ...
        %             'PitchSilenceThreshold', pitchSilenceEdit.Value, ...
        %             'PitchVoicingThreshold', pitchVoicingEdit.Value, ...
        %             'PitchOctaveCost', pitchOctCostEdit.Value, ...
        %             'PitchOctaveJumpCost', pitchOctJumpEdit.Value, ...
        %             'PitchVoicedUnvoicedCost', pitchVuvEdit.Value, ...
        %             'OutputFile', outFile};
        % 
        %         switch pm
        %             case {'filtered_autocorrelation', 'filtered_cross_correlation'}
        %                 args = [args, {'PitchIfFilteredAttenuationAtTop', pitchAttTopEdit.Value}];
        %             case 'shs'
        %                 args = [args, {'pitchShsFrequencyMaximum', shsFreqMaxEdit.Value, ...
        %                     'pitchShsMaxNumberOfSubharmonics', shsMaxSubEdit.Value, ...
        %                     'pitchShsCompressionFactor', shsCompEdit.Value, ...
        %                     'pitchShsPointsPerOctave', shsPointsOctEdit.Value}];
        %             case 'SPINET'
        %                 args = [args, {'pitchSpinetWindowLength_s', spinetWinEdit.Value, ...
        %                     'pitchSpinetGammatoneFBminFreq_Hz', spinetFBminEdit.Value, ...
        %                     'pitchSpinetGammatoneFBmaxFreq_Hz', spinetFBmaxEdit.Value, ...
        %                     'pitchSpinetGammatoneFBnumFilters', spinetFBnumEdit.Value}];
        %         end
        % 
        %         results = usePraatViaMatlab.runPraatPitchAnalysis(praatExe, wavFile, scriptFile, args{:});
        %     end
        % 
        %     function results = runPointProcess(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_pointprocess_analysis.praat');
        %         [pitchArgs, ppArgs] = collectPitchPPArgs();
        %         allArgs = [pitchArgs, ppArgs, {'OutputFile', outFile, 'ScriptFile', scriptFile}];
        %         results = usePraatViaMatlab.runPraatPointProcessAnalysis(praatExe, wavFile, allArgs{:});
        %         results = runWithPitchContour(results, wavFile, scriptDir);
        %     end
        % 
        %     function results = runJitter(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_jitter_analysis.praat');
        %         [pitchArgs, ppArgs] = collectPitchPPArgs();
        %         jitArgs = {'ShortestPeriod_s', jitterShortEdit.Value, ...
        %             'LongestPeriod_s', jitterLongEdit.Value, ...
        %             'MaximumPeriodFactor', jitterMaxFactorEdit.Value, ...
        %             'WindowLength_s', jitterWinLenEdit.Value, ...
        %             'WindowStep_s', jitterWinStepEdit.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile};
        %         allArgs = [pitchArgs, ppArgs, jitArgs];
        %         results = usePraatViaMatlab.runPraatJitterAnalysis(praatExe, wavFile, allArgs{:});
        %         results = runWithPitchContour(results, wavFile, scriptDir);
        %     end
        % 
        %     function results = runShimmer(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_shimmer_analysis.praat');
        %         [pitchArgs, ppArgs] = collectPitchPPArgs();
        %         shimArgs = {'ShortestPeriod_s', jitterShortEdit.Value, ...
        %             'LongestPeriod_s', jitterLongEdit.Value, ...
        %             'MaximumPeriodFactor', jitterMaxFactorEdit.Value, ...
        %             'MaximumAmplitudeFactor', shimmerAmpMaxEdit.Value, ...
        %             'WindowLength_s', jitterWinLenEdit.Value, ...
        %             'WindowStep_s', jitterWinStepEdit.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile};
        %         allArgs = [pitchArgs, ppArgs, shimArgs];
        %         results = usePraatViaMatlab.runPraatShimmerAnalysis(praatExe, wavFile, allArgs{:});
        %         results = runWithPitchContour(results, wavFile, scriptDir);
        %     end
        % 
        %     function results = runFormant(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_formant_analysis.praat');
        %         results = usePraatViaMatlab.runPraatFormantAnalysis(praatExe, wavFile, ...
        %             'FormantMethod', fmtMethodDd.Value, ...
        %             'FormantTimeStep_s', 0.0, ...
        %             'FormantMaximumNumberOfFormants', fmtMaxFormantsEdit.Value, ...
        %             'FormantCeiling_Hz', fmtCeilingEdit.Value, ...
        %             'FormantWindowLength_s', fmtWinLenEdit.Value, ...
        %             'FormantPreEmphasisFrom_Hz', fmtPreEmphEdit.Value, ...
        %             'FormantRobustNrOfStdDev', fmtRobustStdEdit.Value, ...
        %             'FormantRobustNumberOfIterations', fmtRobustIterEdit.Value, ...
        %             'FormantRobustTolerance', fmtRobustTolEdit.Value, ...
        %             'TrackFormants', fmtTrackDd.Value, ...
        %             'TrackNumberOfTracks', fmtTrackNEdit.Value, ...
        %             'TrackReferenceF1_Hz', fmtRef1Edit.Value, ...
        %             'TrackReferenceF2_Hz', fmtRef2Edit.Value, ...
        %             'TrackReferenceF3_Hz', fmtRef3Edit.Value, ...
        %             'TrackReferenceF4_Hz', fmtRef4Edit.Value, ...
        %             'TrackReferenceF5_Hz', fmtRef5Edit.Value, ...
        %             'TrackFrequencyCostPerKHz', fmtFreqCostEdit.Value, ...
        %             'TrackBandwidthCost', fmtBandCostEdit.Value, ...
        %             'TrackTransitionCostPerOctave', fmtTransCostEdit.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile);
        %     end
        % 
        %     function results = runIntensity(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_intensity_analysis.praat');
        %         results = usePraatViaMatlab.runPraatIntensityAnalysis(praatExe, wavFile, ...
        %             'MinPitch_Hz', intMinPitchEdit.Value, ...
        %             'WindowLength_s', intWinLenEdit.Value, ...
        %             'SubtractMean', intSubMeanDd.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile);
        %     end
        % 
        %     function results = runHarmonicity(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_harmonicity_analysis.praat');
        %         results = usePraatViaMatlab.runPraatHarmonicityAnalysis(praatExe, wavFile, ...
        %             'HNRTimeStep_s', hnrTimeStepEdit.Value, ...
        %             'HNRPitchFloor_Hz', hnrPitchFloorEdit.Value, ...
        %             'HNRSilenceThreshold', hnrSilenceEdit.Value, ...
        %             'HNRPeriodsPerWindow', hnrPeriodsEdit.Value, ...
        %             'GNEMinFrequency_Hz', hnrGNEminEdit.Value, ...
        %             'GNEMaxFrequency_Hz', hnrGNEmaxEdit.Value, ...
        %             'GNEBandwidth_Hz', hnrGNEBWEdit.Value, ...
        %             'GNEFreqStep_Hz', hnrGNEStepEdit.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile);
        %     end
        % 
        %     function results = runCppCpps(wavFile, scriptDir, outFile)
        %         scriptFile = fullfile(scriptDir, 'run_cppcpps_analysis.praat');
        %         results = usePraatViaMatlab.runPraatCppCppsAnalysis(praatExe, wavFile, ...
        %             'PowerCepstrogramPitchFloor_Hz', cppPitchFEdit.Value, ...
        %             'PowerCepstrogramTimeStep_s', cppTimeStepEdit.Value, ...
        %             'PowerCepstrogramMaximumFrequency_Hz', cppMaxFreqEdit.Value, ...
        %             'PowerCepstrogramPreEmphasisFrom_Hz', cppPreEmphEdit.Value, ...
        %             'RemoveTrendBeforeSmoothing', cppRemoveTrendDd.Value, ...
        %             'TimeAveragingWindow_s', cppTimeAvgEdit.Value, ...
        %             'QuefrencyAveragingWindow_s', cppQuefAvgEdit.Value, ...
        %             'PeakSearchPitchFloor_Hz', cppPeakFminEdit.Value, ...
        %             'PeakSearchPitchCeiling_Hz', cppPeakFmaxEdit.Value, ...
        %             'PreEmphasisFromCPPS_Hz', cppPeakPreEmphEdit.Value, ...
        %             'PeakInterpolationMethod', cppPeakInterpDd.Value, ...
        %             'TrendLowerBound_s', cppTrendLowEdit.Value, ...
        %             'TrendUpperBound_s', cppTrendHighEdit.Value, ...
        %             'TrendType', cppTrendTypeDd.Value, ...
        %             'FitMethod', cppFitMethodDd.Value, ...
        %             'OutputFile', outFile, 'ScriptFile', scriptFile);
        %     end
        % 
        %     function [pitchArgs, ppArgs] = collectPitchPPArgs()
        %         pm = pitchMethodDd.Value;
        %         tstep = pitchTimeStepEdit.Value;
        %         if tstep == 0
        %             tstep = 0.8 / pitchFloorEdit.Value;
        %         end
        % 
        %         pitchArgs = {'PitchMethod', pm, 'PitchTimeStep_s', tstep, ...
        %             'PitchFloor_Hz', pitchFloorEdit.Value, ...
        %             'PitchCeiling_Hz', pitchCeilingEdit.Value, ...
        %             'PitchMaxNumberOfCandidates', pitchMaxCandEdit.Value, ...
        %             'PitchVeryAccurate', pitchVeryAccDd.Value, ...
        %             'PitchSilenceThreshold', pitchSilenceEdit.Value, ...
        %             'PitchVoicingThreshold', pitchVoicingEdit.Value, ...
        %             'PitchOctaveCost', pitchOctCostEdit.Value, ...
        %             'PitchOctaveJumpCost', pitchOctJumpEdit.Value, ...
        %             'PitchVoicedUnvoicedCost', pitchVuvEdit.Value};
        % 
        %         switch pm
        %             case {'filtered_autocorrelation', 'filtered_cross_correlation'}
        %                 pitchArgs = [pitchArgs, {'PitchIfFilteredAttenuationAtTop', pitchAttTopEdit.Value}];
        %             case 'shs'
        %                 pitchArgs = [pitchArgs, {'pitchShsFrequencyMaximum', shsFreqMaxEdit.Value, ...
        %                     'pitchShsMaxNumberOfSubharmonics', shsMaxSubEdit.Value, ...
        %                     'pitchShsCompressionFactor', shsCompEdit.Value, ...
        %                     'pitchShsPointsPerOctave', shsPointsOctEdit.Value}];
        %             case 'SPINET'
        %                 pitchArgs = [pitchArgs, {'pitchSpinetWindowLength_s', spinetWinEdit.Value, ...
        %                     'pitchSpinetGammatoneFBminFreq_Hz', spinetFBminEdit.Value, ...
        %                     'pitchSpinetGammatoneFBmaxFreq_Hz', spinetFBmaxEdit.Value, ...
        %                     'pitchSpinetGammatoneFBnumFilters', spinetFBnumEdit.Value}];
        %         end
        % 
        %         ppArgs = {'PointProcessMethod', ppMethodDd.Value, ...
        %             'ifToPPviaPeaks_DoSelectMaxima', ppSelectMaxDd.Value, ...
        %             'ifToPPviaPeaks_DoSelectMinima', ppSelectMinDd.Value};
        %     end
        % 
        %     function results = runWithPitchContour(results, wavFile, scriptDir)
        %         try
        %             [pArgs, ~] = collectPitchPPArgs();
        %             pFile = fullfile(tempdir(), 'praat_pitch_contour.txt');
        %             sFile = fullfile(scriptDir, 'run_pitch_analysis.praat');
        %             pR = usePraatViaMatlab.runPraatPitchAnalysis(praatExe, wavFile, sFile, ...
        %                 pArgs{:}, 'OutputFile', pFile);
        %             if isfield(pR, 'pitch')
        %                 results.pitch = pR.pitch;
        %             end
        %         catch
        %         end
        %     end
        % 
        %     %% --- PLOT RESULTS ---
        %     function plotResults(atype, results)
        %         if isempty(tl) || ~isvalid(tl)
        %             return;
        %         end
        % 
        %         % Remove only plotted objects (keep titles/labels)
        %         for i = 1:numel(ax)
        %             if isvalid(ax(i))
        %                 delete(findobj(ax(i), 'Type', 'line'));
        %                 delete(findobj(ax(i), 'Type', 'ConstantLine'));
        %                 delete(findobj(ax(i), 'Type', 'Legend'));
        %                 ax(i).XLimMode = 'auto';
        %                 ax(i).YLimMode = 'auto';
        %             end
        %         end
        %         hold(ax(1), 'on');
        % 
        %         plot(ax(1), t, y, 'k-', 'LineWidth', 0.5);
        %         ylabel(ax(1), 'Amplitude');
        % 
        %         % Common: if pitch data exists and no dedicated pitch axis,
        %         % plot pulses on first axis
        %         hasPitch = isfield(results, 'pitch') && isstruct(results.pitch) ...
        %             && isfield(results.pitch, 'time') && ~isempty(results.pitch.time);
        %         hasPP = isfield(results, 'pointProcess') && isstruct(results.pointProcess) ...
        %             && isfield(results.pointProcess, 'time') && ~isempty(results.pointProcess.time);
        % 
        %         switch atype
        %             case 'Pitch'
        %                 if hasPitch
        %                     f0 = fillMissingIfRequested(results.pitch);
        %                     hold(ax(2),'on');
        %                     plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
        %                     ylim(ax(2), 'padded');
        %                 end
        %                 ylabel(ax(2), 'Frequency (Hz)');
        % 
        %             case 'PointProcess'
        %                 if hasPP
        %                     plotPulses(ax(1), results.pointProcess.time + t(1));
        %                 end
        %                 if hasPitch
        %                     f0 = fillMissingIfRequested(results.pitch);
        %                     hold(ax(2),'on');
        %                     plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
        %                 end
        %                 ylabel(ax(2), 'Frequency (Hz)');
        % 
        %             case 'Jitter'
        %                 if hasPP
        %                     plotPulses(ax(1), results.pointProcess.time + t(1));
        %                 end
        %                 if hasPitch
        %                     f0 = fillMissingIfRequested(results.pitch);
        %                     hold(ax(2),'on');
        %                     plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
        %                 end
        %                 ylabel(ax(2), 'Frequency (Hz)');
        %                 plotJitterShimmer(ax(3), results, 'jitter');
        % 
        %             case 'Shimmer'
        %                 if hasPP
        %                     plotPulses(ax(1), results.pointProcess.time + t(1));
        %                 end
        %                 if hasPitch
        %                     f0 = fillMissingIfRequested(results.pitch);
        %                     hold(ax(2),'on');
        %                     plot(ax(2), results.pitch.time + t(1), f0, 'b-', 'LineWidth', 1.5);
        %                 end
        %                 ylabel(ax(2), 'Frequency (Hz)');
        %                 plotJitterShimmer(ax(3), results, 'shimmer');
        % 
        %             case 'Formant'
        %                 hold(ax(2), 'on');
        %                 colors = lines(5);
        %                 for fi = 1:5
        %                     fld = sprintf('formant_f%d', fi);
        %                     if isfield(results, fld) && isstruct(results.(fld)) ...
        %                             && isfield(results.(fld), 'time') ...
        %                             && ~isempty(results.(fld).time)
        %                         tF = results.(fld).time + t(1);
        %                         vF = results.(fld).value;
        %                         hold(ax(2),'on');
        %                         plot(ax(2), tF, vF, 'o-', 'Color', colors(fi,:), ...
        %                             'LineWidth', 0.8, 'MarkerSize', 2);
        %                     end
        %                 end
        %                 ylabel(ax(2), 'Frequency (Hz)');
        %                 lg=legend(ax(2), {'F1', 'F2', 'F3', 'F4', 'F5'}, ...
        %                     'Box', 'off','Orientation','horizontal');
        %                 lg.Layout.Tile='south';
        % 
        %             case 'Intensity'
        %                 if isfield(results, 'Intensity') && isstruct(results.Intensity)
        %                     tI = results.Intensity.time + t(1);
        %                     vI = results.Intensity.value;
        %                     hold(ax(2),'on');
        %                     plot(ax(2), tI, vI, 'r-', 'LineWidth', 1.5);
        %                     ylabel(ax(2), 'Intensity (dB)');
        %                 end
        % 
        %             case 'Harmonicity (HNR/GNE)'
        %                 hold(ax(2), 'on');
        %                 if isfield(results, 'HNRac') && isstruct(results.HNRac)
        %                     plot(ax(2), results.HNRac.time + t(1), results.HNRac.value, ...
        %                         'b-', 'LineWidth', 1);
        %                 end
        %                 if isfield(results, 'HNRcc') && isstruct(results.HNRcc)
        %                     plot(ax(2), results.HNRcc.time + t(1), results.HNRcc.value, ...
        %                         'r-', 'LineWidth', 1);
        %                 end
        %                 ylabel(ax(2), 'HNR (dB)');
        %                 lg=legend(ax(2), {'HNRac', 'HNRcc'}, 'Box', 'off','Orientation','horizontal');
        %                 lg.Layout.Tile='south';
        % 
        %             case 'CPP/CPPS'
        %                 hold(ax(2), 'on');
        %                 if isfield(results, 'CPP') && isstruct(results.CPP)
        %                     plot(ax(2), results.CPP.time + t(1), results.CPP.value, ...
        %                         'b-', 'LineWidth', 1);
        %                 end
        %                 if isfield(results, 'CPPs') && isstruct(results.CPPs)
        %                     plot(ax(2), results.CPPs.time + t(1), results.CPPs.value, ...
        %                         'r-', 'LineWidth', 1);
        %                 end
        %                 ylabel(ax(2), 'CPP / CPPS (dB)');
        %                 lg=legend(ax(2), {'CPP', 'CPPS'}, 'Box', 'off','Orientation','horizontal');
        %                 lg.Layout.Tile='south';
        %         end
        % 
        %         % Link x-axes
        %         linkaxes(ax, 'x');
        %         xlim(ax(1), [t(1) t(end)]);
        %     end
        % 
        %     function v = fillMissingIfRequested(pitchStruct)
        %         v = pitchStruct.value;
        %         method = fillMissDd.Value;
        %         if strcmp(method, 'zero')
        %             v(isnan(v)) = 0;
        %         else
        %             v = fillmissing(v, method);
        %         end
        %     end
        % 
        %     function plotPulses(axH, pulseTimes)
        %         % for k = 1:length(pulseTimes)
        %         %     xline(axH, pulseTimes(k), '-', 'Color', [0.8 0.2 0.2], ...
        %         %         'LineWidth', 0.5, 'Alpha', 0.5);
        %         % end
        % 
        %         %ylims=[-10 10];
        %         ylims=ylim(axH);
        %         plotxvals=repelem(pulseTimes,3); pulseTimes(3:3:end)=NaN;
        %         yvals=repmat([ylims NaN],[1 numel(pulseTimes)]);
        % 
        %         lineObj=line(axH,plotxvals(:),yvals(:),'PickableParts','none','Color',[0.8 0.8 0.8],'LineStyle','-','LineWidth', 0.5,'AffectAutoLimits','off');
        %         uistack(lineObj,'bottom');
        %     end
        % 
        %     function plotJitterShimmer(axH, results, kind)
        %         hold(axH, 'on');
        %         colors = lines(6);
        %         if strcmp(kind, 'jitter')
        %             metrics = {'jitter_local', 'jitter_local_absolute', 'jitter_rap', ...
        %                 'jitter_ppq5', 'jitter_ddp'};
        %             labels = {'local', 'local abs', 'rap', 'ppq5', 'ddp'};
        %         else
        %             metrics = {'shimmer_local', 'shimmer_local_db', 'shimmer_apq3', ...
        %                 'shimmer_apq5', 'shimmer_apq11', 'shimmer_dda'};
        %             labels = {'local', 'dB', 'apq3', 'apq5', 'apq11', 'dda'};
        %         end
        %         plotted = 0;
        %         for mi = 1:length(metrics)
        %             if isfield(results, metrics{mi}) && isstruct(results.(metrics{mi})) ...
        %                     && isfield(results.(metrics{mi}), 'time') ...
        %                     && ~isempty(results.(metrics{mi}).time)
        %                 tM = results.(metrics{mi}).time + t(1);
        %                 vM = results.(metrics{mi}).value;
        %                 plot(axH, tM, vM, 'o-', 'Color', colors(mi,:), ...
        %                     'LineWidth', 1, 'MarkerSize', 3);
        %                 plotted = plotted + 1;
        %             end
        %         end
        %         if plotted > 0
        %             lg=legend(axH, labels(1:plotted), 'Box', 'off', ...
        %                 'FontSize', 8,'Orientation','horizontal');
        %                 lg.Layout.Tile='south';
        %         end
        %         ylabel(axH, 'Value');
        %     end
        % 
        %     function series = getExportableTimeSeries(results)
        %         series = struct('field', {}, 'time', {}, 'value', {}, 'label', {});
        %         flds = fieldnames(results);
        %         for i = 1:length(flds)
        %             f = flds{i};
        %             v = results.(f);
        %             if isstruct(v) && isfield(v, 'time') && ~isempty(v.time) ...
        %                     && isfield(v, 'value') && ~isempty(v.value)
        %                 series(end+1).field = f;
        %                 series(end).time = v.time(:);
        %                 series(end).value = v.value(:);
        %                 series(end).label = strrep(f, '_', ' ');
        %             end
        %         end
        %     end
        % 
        %     function [selected, ok] = showExportDialog(series)
        %         n = length(series);
        %         dlgH = min(50*n + 120, 600);
        %         dlg = uifigure('Name', 'Export Channels', ...
        %             'Position', [0 0 420 dlgH], 'WindowStyle', 'modal', 'Visible', 'off');
        %         importHandles = gobjects(n, 1);
        %         gl = uigridlayout(dlg, [2 1], 'RowHeight', {'1x', 'fit'}, 'Padding', [10 10 10 10]);
        %         scrollGl = uigridlayout(gl, [n 1], 'RowHeight', repmat({'fit'}, 1, n), 'Scrollable', 'on');
        %         scrollGl.Layout.Row = 1;
        %         for i = 1:n
        %             importHandles(i) = uicheckbox(scrollGl, 'Text', series(i).label, 'Value', true);
        %             importHandles(i).Layout.Row = i;
        %         end
        %         cancelFlag = false;
        %         btnGl = uigridlayout(gl, [1 2], 'ColumnWidth', {'1x', '1x'}, 'Padding', [0 5 0 0]);
        %         btnGl.Layout.Row = 2;
        %         exportBtn = uibutton(btnGl, 'Text', 'Export', 'FontWeight', 'bold', ...
        %             'ButtonPushedFcn', @(s,e) uiresume(dlg));
        %         exportBtn.Layout.Row = 1; exportBtn.Layout.Column = 1;
        %         skipBtn = uibutton(btnGl, 'Text', 'Skip', ...
        %             'ButtonPushedFcn', @(s,e) onSkip());
        %         skipBtn.Layout.Row = 1; skipBtn.Layout.Column = 2;
        % 
        %         function onSkip()
        %             cancelFlag = true;
        %             uiresume(dlg);
        %         end
        % 
        %         movegui(dlg, 'center');
        %         dlg.Visible = 'on';
        %         uiwait(dlg);
        %         if cancelFlag || ~isvalid(dlg)
        %             ok = false;  selected = [];
        %         else
        %             ok = true;
        %             selected = find([importHandles.Value]);
        %         end
        %         delete(dlg);
        %     end
        % 
        %     %% --- Save settings and close ---
        %     function saveAndClose()
        %         pAnalysisType = analysisDd.Value;
        %         pFillMissing = fillMissDd.Value;
        %         pPitchMethod = pitchMethodDd.Value;
        %         pPitchFloor = pitchFloorEdit.Value;
        %         pPitchCeiling = pitchCeilingEdit.Value;
        %         pPitchTimeStep = pitchTimeStepEdit.Value;
        %         pPitchMaxCandidates = pitchMaxCandEdit.Value;
        %         pPitchVeryAccurate = pitchVeryAccDd.Value;
        %         pPitchAttenuationAtTop = pitchAttTopEdit.Value;
        %         pPitchSilenceThreshold = pitchSilenceEdit.Value;
        %         pPitchVoicingThreshold = pitchVoicingEdit.Value;
        %         pPitchOctaveCost = pitchOctCostEdit.Value;
        %         pPitchOctaveJumpCost = pitchOctJumpEdit.Value;
        %         pPitchVuvCost = pitchVuvEdit.Value;
        %         pShsFreqMax = shsFreqMaxEdit.Value;
        %         pShsMaxSubharm = shsMaxSubEdit.Value;
        %         pShsCompression = shsCompEdit.Value;
        %         pShsPointsPerOctave = shsPointsOctEdit.Value;
        %         pSpinetWinLen = spinetWinEdit.Value;
        %         pSpinetFBmin = spinetFBminEdit.Value;
        %         pSpinetFBmax = spinetFBmaxEdit.Value;
        %         pSpinetFBnum = spinetFBnumEdit.Value;
        %         pPPmethod = ppMethodDd.Value;
        %         pPPselectMax = ppSelectMaxDd.Value;
        %         pPPselectMin = ppSelectMinDd.Value;
        %         pJitterShortPeriod = jitterShortEdit.Value;
        %         pJitterLongPeriod = jitterLongEdit.Value;
        %         pJitterMaxFactor = jitterMaxFactorEdit.Value;
        %         pJitterWinLen = jitterWinLenEdit.Value;
        %         pJitterWinStep = jitterWinStepEdit.Value;
        %         pShimmerMaxAmpFactor = shimmerAmpMaxEdit.Value;
        %         pFmtMethod = fmtMethodDd.Value;
        %         pFmtMaxFormants = fmtMaxFormantsEdit.Value;
        %         pFmtCeiling = fmtCeilingEdit.Value;
        %         pFmtWinLen = fmtWinLenEdit.Value;
        %         pFmtPreEmph = fmtPreEmphEdit.Value;
        %         pFmtRobustStd = fmtRobustStdEdit.Value;
        %         pFmtRobustIter = fmtRobustIterEdit.Value;
        %         pFmtRobustTol = fmtRobustTolEdit.Value;
        %         pFmtTrack = fmtTrackDd.Value;
        %         pFmtTrackN = fmtTrackNEdit.Value;
        %         pFmtRef1 = fmtRef1Edit.Value;
        %         pFmtRef2 = fmtRef2Edit.Value;
        %         pFmtRef3 = fmtRef3Edit.Value;
        %         pFmtRef4 = fmtRef4Edit.Value;
        %         pFmtRef5 = fmtRef5Edit.Value;
        %         pFmtFreqCost = fmtFreqCostEdit.Value;
        %         pFmtBandCost = fmtBandCostEdit.Value;
        %         pFmtTransCost = fmtTransCostEdit.Value;
        %         pIntMinPitch = intMinPitchEdit.Value;
        %         pIntWinLen = intWinLenEdit.Value;
        %         pIntSubMean = intSubMeanDd.Value;
        %         pHnrTimeStep = hnrTimeStepEdit.Value;
        %         pHnrPitchFloor = hnrPitchFloorEdit.Value;
        %         pHnrSilence = hnrSilenceEdit.Value;
        %         pHnrPeriods = hnrPeriodsEdit.Value;
        %         pHnrGNEmin = hnrGNEminEdit.Value;
        %         pHnrGNEmax = hnrGNEmaxEdit.Value;
        %         pHnrGNEBW = hnrGNEBWEdit.Value;
        %         pHnrGNEStep = hnrGNEStepEdit.Value;
        %         pCppPitchFloor = cppPitchFEdit.Value;
        %         pCppTimeStep = cppTimeStepEdit.Value;
        %         pCppMaxFreq = cppMaxFreqEdit.Value;
        %         pCppPreEmph = cppPreEmphEdit.Value;
        %         pCppRemoveTrend = cppRemoveTrendDd.Value;
        %         pCppTimeAvg = cppTimeAvgEdit.Value;
        %         pCppQuefAvg = cppQuefAvgEdit.Value;
        %         pCppPeakFmin = cppPeakFminEdit.Value;
        %         pCppPeakFmax = cppPeakFmaxEdit.Value;
        %         pCppPeakPreEmph = cppPeakPreEmphEdit.Value;
        %         pCppPeakInterp = cppPeakInterpDd.Value;
        %         pCppTrendLow = cppTrendLowEdit.Value;
        %         pCppTrendHigh = cppTrendHighEdit.Value;
        %         pCppTrendType = cppTrendTypeDd.Value;
        %         pCppFitMethod = cppFitMethodDd.Value;
        % 
        %         if isfield(fig.UserData, 'lastResults') && ~isempty(fig.UserData.lastResults)
        %             series = getExportableTimeSeries(fig.UserData.lastResults);
        %             if ~isempty(series)
        %                 [sel, ok] = showExportDialog(series);
        %                 if ok && ~isempty(sel)
        %                     for i = 1:length(sel)
        %                         s = series(sel(i));
        %                         label = [channelName ' - ' s.label ' (' pAnalysisType ')'];
        %                         app.addSingleChannelData(s.value, s.time + t(1), label, 'Raw');
        %                     end
        %                 end
        %             end
        %         end
        % 
        %         windowClosedByApply = true;
        %         uiresume(fig);
        %     end
        % 
        %     function cancelAndClose()
        %         windowClosedByApply = false;
        %         uiresume(fig);
        %     end
        % 
        %     %% Hook up parameter change callbacks to auto-run
        %     allParamControls = [pitchMethodDd pitchFloorEdit pitchCeilingEdit ...
        %         pitchTimeStepEdit pitchVeryAccDd pitchAttTopEdit ...
        %         pitchSilenceEdit pitchVoicingEdit pitchOctCostEdit ...
        %         pitchOctJumpEdit pitchVuvEdit pitchMaxCandEdit ...
        %         shsFreqMaxEdit shsMaxSubEdit shsCompEdit shsPointsOctEdit ...
        %         spinetWinEdit spinetFBminEdit spinetFBmaxEdit spinetFBnumEdit ...
        %         fillMissDd ppMethodDd ppSelectMaxDd ppSelectMinDd ...
        %         jitterShortEdit jitterLongEdit jitterMaxFactorEdit ...
        %         jitterWinLenEdit jitterWinStepEdit shimmerAmpMaxEdit ...
        %         fmtMethodDd fmtMaxFormantsEdit fmtCeilingEdit fmtWinLenEdit ...
        %         fmtPreEmphEdit fmtRobustStdEdit fmtRobustIterEdit fmtRobustTolEdit ...
        %         fmtTrackDd fmtTrackNEdit ...
        %         fmtRef1Edit fmtRef2Edit fmtRef3Edit fmtRef4Edit fmtRef5Edit ...
        %         fmtFreqCostEdit fmtBandCostEdit fmtTransCostEdit ...
        %         intMinPitchEdit intWinLenEdit intSubMeanDd ...
        %         hnrTimeStepEdit hnrPitchFloorEdit hnrSilenceEdit hnrPeriodsEdit ...
        %         hnrGNEminEdit hnrGNEmaxEdit hnrGNEBWEdit hnrGNEStepEdit ...
        %         cppPitchFEdit cppTimeStepEdit cppMaxFreqEdit cppPreEmphEdit ...
        %         cppRemoveTrendDd cppTimeAvgEdit cppQuefAvgEdit ...
        %         cppPeakFminEdit cppPeakFmaxEdit cppPeakPreEmphEdit cppPeakInterpDd ...
        %         cppTrendLowEdit cppTrendHighEdit cppTrendTypeDd cppFitMethodDd];
        % 
        %     for h = allParamControls
        %         if isprop(h, 'ValueChangedFcn')
        %             h.ValueChangedFcn = @(s,e) runAnalysis();
        %         end
        %     end
        %     pitchMethodDd.ValueChangedFcn = @(s,e) onPitchMethodChange();
        % 
        %     function onPitchMethodChange()
        %         updatePitchSubVisibility();
        %         runAnalysis();
        %     end
        % 
        %     %% Initialize
        %     rebuildPreviewPanel();
        %     runAnalysis();
        % 
        %     %% Wait for user to close
        %     uiwait(fig);
        % 
        %     %% Cleanup
        %     delete(fig);
        % end

      



        function convertPaToCmH2O(app,channelNr)
            % Temperaturauswahl
            temps = {'0°C','4°C','10°C','15°C','20°C','25°C','30°C','35°C','37°C','40°C','50°C','60°C','70°C','80°C','90°C','100°C'};
            densities = [999.84, 1000.00, 999.70, 999.10, 998.23, 997.05, 995.65, 994.03, 993.33, 992.22, 988.05, 983.20, 977.76, 971.80, 965.33, 958.36];


            [idx, tf] = listdlg('PromptString','Wähle die Wassertemperatur:', ...
                'SelectionMode','single', ...
                'ListString',temps,'InitialValue',2);

            if ~tf
                return;
            end

            rho = densities(idx); % density at chosen temperature
            g = 9.80665;

            newYData = (app.channelYValues{channelNr} / (rho * g)) * 100;

            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;
            currXData=app.channelXValues{channelNr};

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=currXData>=currXLim(1) & currXData<=currXLim(2);
            newYLimits=[min(newYData(displayMask)) max(newYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(newYData(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end
        end

        function convertCmH2OtoPa(app,channelNr)
            % Temperature
            temps = {'0°C','4°C','10°C','15°C','20°C','25°C','30°C','35°C','37°C','40°C','50°C','60°C','70°C','80°C','90°C','100°C'};
            densities = [999.84, 1000.00, 999.70, 999.10, 998.23, 997.05, 995.65, 994.03, 993.33, 992.22, 988.05, 983.20, 977.76, 971.80, 965.33, 958.36];


            [idx, tf] = listdlg('PromptString','Wähle die Wassertemperatur:', ...
                'SelectionMode','single', ...
                'ListString',temps,'InitialValue',2);

            if ~tf
                return;
            end

            rho = densities(idx); % density at chosen temperature
            g = 9.80665;

            newYData = app.channelYValues{channelNr} * (rho / 100) * g;

            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;
            currXData=app.channelXValues{channelNr};

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            currXLim=xlim(app.channelAxes(channelNr));
            displayMask=currXData>=currXLim(1) & currXData<=currXLim(2);
            newYLimits=[min(newYData(displayMask)) max(newYData(displayMask))]+[-1 1]*app.timePlotPadPercentage*range(newYData(displayMask));
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end
        end

        function convertdBtoMag(app,channelNr)
            newYData = db2mag(app.channelYValues{channelNr});
            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            newYLimits=[min(newYData) max(newYData)]+[-1 1]*app.timePlotPadPercentage*range(newYData);
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end
        end

        function convertMagTodB(app,channelNr)
            newYData = mag2db(app.channelYValues{channelNr}+eps);
            app.addValueSetToValueHistory(newYData,app.channelXValues{channelNr},channelNr);

            %% save new calibrated values
            app.channelYValues{channelNr}=newYData;

            app.timePlotHandles(channelNr).YData=newYData;

            drawnow;

            newYLimits=[min(newYData) max(newYData)]+[-1 1]*app.timePlotPadPercentage*range(newYData);
            ylim(app.channelAxes(channelNr),newYLimits);

            if ~isempty(app.DraggingData.CurrentRectangles) && isvalid(app.DraggingData.CurrentRectangles(channelNr))
                app.DraggingData.CurrentRectangles(channelNr).Position([2 4])=[newYLimits(1) newYLimits(2)-newYLimits(1)];
            end
        end



        % function refreshSelectionEvaluationText(app,givenChannelNrs,manualBorders)
        %
        %     if nargin<2 || isempty(givenChannelNrs)
        %         givenChannelNrs=1:numel(app.channelAxes);
        %     end
        %
        %     for channelNr=givenChannelNrs
        %
        %         if numel(app.selectionEvaluationTexts)>=channelNr
        %             delete(app.selectionEvaluationTexts(channelNr));
        %             delete(app.selectionEvaluationSpectralTexts(channelNr));
        %         end
        %
        %         if ~isempty(app.DraggingData.StartX)
        %
        %             % this is necessary for data calculation during marking
        %             if nargin<3 || isempty(manualBorders)
        %                 startX=min(app.DraggingData.StartX,app.DraggingData.EndX);
        %                 endX=max(app.DraggingData.StartX,app.DraggingData.EndX);
        %             else
        %                 startX=manualBorders(1);
        %                 endX=manualBorders(2);
        %             end
        %
        %
        %             yDataExcerpt=app.channelYValues{channelNr}(app.channelXValues{channelNr}>=startX & app.channelXValues{channelNr}<=endX);
        %             zDataExcerptSpectral=app.spectralPlotHandles(channelNr).CData(:,app.spectralPlotHandles(channelNr).XData>=startX & app.spectralPlotHandles(channelNr).XData<=endX);
        %             timeDataExcerptSpectral=app.spectralPlotHandles(channelNr).XData(app.spectralPlotHandles(channelNr).XData>=startX & app.spectralPlotHandles(channelNr).XData<=endX);
        %         else % e.g. when during mark mode it was only clicked, StartX might be empty
        %             yDataExcerpt=app.channelYValues{channelNr};
        %             zDataExcerptSpectral=app.spectralPlotHandles(channelNr).CData;
        %             timeDataExcerptSpectral=app.spectralPlotHandles(channelNr).XData;
        %
        %         end
        %
        %         frequencyData=app.spectralPlotHandles(channelNr).YData;
        %
        %         if isempty(yDataExcerpt)
        %             continue;
        %         end
        %
        %
        %         evaluations=[mean(yDataExcerpt) median(yDataExcerpt) min(yDataExcerpt) max(yDataExcerpt) range(yDataExcerpt) std(yDataExcerpt) rms(yDataExcerpt)];
        %
        %         evalToShow = get([app.ShowMeanMenu app.ShowMedianMenu app.ShowMinMenu app.ShowMaxMenu app.ShowRangeMenu app.ShowStandardDeviationMenu app.ShowRootMeanSquareMenu], 'Checked');
        %
        %         % Corresponding names and values
        %         evalNames = {'mean', 'median', 'min', 'max', 'range', 'std', 'rms'};
        %
        %         % Build dynamic text string
        %         textParts = cell(1,sum(cellfun(@(in) strcmp(in,'on'),evalToShow)));
        %         idx=1;
        %         for i = 1:length(evalToShow)
        %             if strcmp(evalToShow{i}, 'on')
        %                 textParts{idx} = sprintf('%s: %g', evalNames{i}, evaluations(i));
        %                 idx=idx+1;
        %             end
        %         end
        %         finalText = strjoin(textParts, ', ');
        %
        %         app.selectionEvaluationTexts(channelNr)=text(app.channelAxes(channelNr),1,1,finalText,'HorizontalAlignment','right','VerticalAlignment','top','Units','normalized','Clipping','off','PickableParts','none');
        %
        %         %% now also generate something for the spectral data
        %         [maxZValue,maxFreqIdx]=max(max(zDataExcerptSpectral,[],2));
        %         maxFreq=frequencyData(maxFreqIdx);
        %
        %
        %         [~,maxTimeIdx]=max(max(zDataExcerptSpectral,[],1));
        %         maxTime=timeDataExcerptSpectral(maxTimeIdx);
        %
        %         finalTextSpectral=sprintf('peak =%.1f at %.2f Hz, t= %.3f s',maxZValue,maxFreq,maxTime);
        %         app.selectionEvaluationSpectralTexts(channelNr)=text(app.channelAxesSpectral(channelNr),1,1,finalTextSpectral,'HorizontalAlignment','right','VerticalAlignment','top','Units','normalized','Clipping','off','PickableParts','none','BackgroundColor',[1 1 1]);
        %
        %
        %
        %     end
        %
        % end

        function refreshSelectionEvaluationText(app,givenChannelNrs,manualBorders)
            if nargin<2 || isempty(givenChannelNrs)
                givenChannelNrs=1:numel(app.channelAxes);
            end

            % ---------- GUI cleanup (serial) ----------
            for channelNr=givenChannelNrs
                if numel(app.selectionEvaluationTexts)>=channelNr
                    delete(app.selectionEvaluationTexts(channelNr));
                    delete(app.selectionEvaluationSpectralTexts(channelNr));
                end
            end

            % ---------- determine borders once (serial) ----------
            if ~isempty(app.DraggingData.StartX)
                if nargin<3 || isempty(manualBorders)
                    startX=min(app.DraggingData.StartX,app.DraggingData.EndX);
                    endX=max(app.DraggingData.StartX,app.DraggingData.EndX);
                else
                    startX=manualBorders(1);
                    endX=manualBorders(2);
                end
            else
                startX=[];
                endX=[];
            end

            % ---------- extract everything needed from app (serial) ----------
            % keep original variable names where possible
            channelXVals = app.channelXValues;
            channelYVals = app.channelYValues;

            % Pull spectral plot data out of handles so parfor does not touch graphics handles
            spectralXDataCells = cell(max(givenChannelNrs),1);
            spectralYDataCells = cell(max(givenChannelNrs),1);
            spectralCDataCells = cell(max(givenChannelNrs),1);
            for channelNr=givenChannelNrs
                spectralXDataCells{channelNr} = app.spectralPlotHandles(channelNr).XData;
                spectralYDataCells{channelNr} = app.spectralPlotHandles(channelNr).YData;
                spectralCDataCells{channelNr} = app.spectralPlotHandles(channelNr).CData;
            end

            evalToShow = get([app.ShowMeanMenu app.ShowMedianMenu app.ShowMinMenu app.ShowMaxMenu ...
                app.ShowRangeMenu app.ShowStandardDeviationMenu app.ShowRootMeanSquareMenu app.Show1selectiondurationMenu], ...
                'Checked');


            % outputs (indexed by channelNr to keep your indexing style)
            finalTextCell = cell(max(givenChannelNrs),1);
            finalTextSpectralCell = cell(max(givenChannelNrs),1);

            % ---------- process based parfor (no app inside) ----------
            %app.createPoolIfNonexistent();

            % wante dto use parfor but with combination of debounce timer in the
            % marking dragging function, it is handing somewhere -> to normal for
            % for now
            for channelNr=givenChannelNrs
                % ---- time excerpts ----
                if ~isempty(startX)
                    xData = channelXVals{channelNr};
                    yData = channelYVals{channelNr};
                    yDataExcerpt = yData(xData>=startX & xData<=endX);

                    specXData = spectralXDataCells{channelNr};

                    specCData = spectralCDataCells{channelNr};
                    specMask  = (specXData>=startX & specXData<=endX);

                    zDataExcerptSpectral = specCData(:,specMask);
                    timeDataExcerptSpectral = specXData(specMask);

                    selectionFreq=1/(endX-startX);
                else
                    yDataExcerpt = channelYVals{channelNr};
                    zDataExcerptSpectral = spectralCDataCells{channelNr};
                    timeDataExcerptSpectral = spectralXDataCells{channelNr};

                    selectionFreq=1/diff(channelXVals{channelNr}([1 end]));
                end

                frequencyData = spectralYDataCells{channelNr};

                if isempty(yDataExcerpt)
                    finalTextCell{channelNr} = '';
                    finalTextSpectralCell{channelNr} = '';
                    continue;
                end

                evalNames = {'mean', 'median', 'min', 'max', 'range', 'std', 'rms', 'Freq'};

                evaluations=[mean(yDataExcerpt) median(yDataExcerpt) min(yDataExcerpt) max(yDataExcerpt) ...
                    range(yDataExcerpt) std(yDataExcerpt) rms(yDataExcerpt) selectionFreq];

                textParts = cell(1,sum(cellfun(@(in) strcmp(in,'on'),evalToShow)));
                idx=1;
                for i = 1:length(evalToShow)
                    if strcmp(evalToShow{i}, 'on')
                        textParts{idx} = sprintf('%s: %g', evalNames{i}, evaluations(i));
                        idx=idx+1;
                    end
                end
                finalText = strjoin(textParts, ', ');
                finalTextCell{channelNr} = finalText;

                % ---- spectral peak text ----
                if isempty(zDataExcerptSpectral) || isempty(timeDataExcerptSpectral) || isempty(frequencyData)
                    finalTextSpectralCell{channelNr} = '';
                    continue;
                end

                [maxZValue,maxFreqIdx]=max(max(zDataExcerptSpectral,[],2));
                maxFreq=frequencyData(maxFreqIdx);
                [~,maxTimeIdx]=max(max(zDataExcerptSpectral,[],1));
                maxTime=timeDataExcerptSpectral(maxTimeIdx);
                finalTextSpectral=sprintf('peak =%.1f at %.2f Hz, t= %.3f s',maxZValue,maxFreq,maxTime);

                finalTextSpectralCell{channelNr} = finalTextSpectral;
            end

            % ---------- GUI update (serial) ----------
            for channelNr=givenChannelNrs
                finalText = finalTextCell{channelNr};
                if isempty(finalText)
                    continue;
                end

                app.selectionEvaluationTexts(channelNr)=text(app.channelAxes(channelNr),1,1,finalText, ...
                    'HorizontalAlignment','right','VerticalAlignment','top','Units','normalized', ...
                    'Clipping','off','PickableParts','none','FontSize',app.channelAxes(channelNr).FontSize,'BackgroundColor',[1 1 1],'Margin',eps);

                finalTextSpectral = finalTextSpectralCell{channelNr};
                if ~isempty(finalTextSpectral)
                    app.selectionEvaluationSpectralTexts(channelNr)=text(app.channelAxesSpectral(channelNr),1,1,finalTextSpectral, ...
                        'HorizontalAlignment','right','VerticalAlignment','top','Units','normalized', ...
                        'Clipping','off','PickableParts','none','BackgroundColor',[1 1 1],'FontSize',app.channelAxesSpectral(channelNr).FontSize);
                end
            end
        end




        function openVADWindow(app, channelNr)
            % Interactive window for voiceActivityDetector probability, time-domain input only

            % Persistent vars for user settings
            persistent SpeechToSilenceProbability SilenceToSpeechProbability Window FrameLengthMs Overlap
            if isempty(SpeechToSilenceProbability)
                SpeechToSilenceProbability = 0.1;
                SilenceToSpeechProbability = 0.2;
                Window = 'hann';
                FrameLengthMs = 30;   % default 30 ms frame length visually
                Overlap = 0.5;
            end

            fs = app.channelSampleRates(channelNr);
            y = app.channelYValues{channelNr};
            t = app.channelXValues{channelNr};

            % Create UI figure and layout
            fig = uifigure('Position',[0 0 900 600],'Name','Voice Activity Probability','Visible','off');
            movegui(fig,'center'); drawnow; fig.Visible = 'on';
            gl = uigridlayout(fig,[6 3],'ColumnWidth',{'1x','1x','2x'},'RowSpacing',3,'Padding',10);

            % Window (nontunable) with descriptive names and internal value mapping
            labelWindow = uilabel(gl,'Text','Window:'); labelWindow.Layout.Row=1; labelWindow.Layout.Column=1;
            windowDisplayNames = {'Flat Top', 'Hamming', 'Hann', 'Kaiser', 'Chebyshev', 'Rectangular'};
            windowInternalNames = {'flat top', 'hamming', 'hann', 'kaiser', 'chebyshev', 'rectangular'};
            dropdownWindow = uidropdown(gl,"Items",windowDisplayNames,"ItemsData",windowInternalNames,'Value',Window);
            dropdownWindow.Layout.Row=1; dropdownWindow.Layout.Column=2;

            % Frame Length in ms (nontunable)
            labelFrameLen = uilabel(gl,'Text','Frame Length [ms]:'); labelFrameLen.Layout.Row=2; labelFrameLen.Layout.Column=1;
            frameLenEdit = uieditfield(gl,'numeric','Value',FrameLengthMs,'Limits',[1 1000*0.5*(t(end)-t(1))],'RoundFractionalValues','off');
            frameLenEdit.Layout.Row=2; frameLenEdit.Layout.Column=2;

            % Overlap slider (0 to 0.95)
            labelOverlap = uilabel(gl,'Text','Overlap (0-0.95):'); labelOverlap.Layout.Row=3; labelOverlap.Layout.Column=1;
            overlapSlider = uislider(gl,'Limits',[0 0.95],'Value',Overlap);
            overlapSlider.Layout.Row=3; overlapSlider.Layout.Column=2;

            % SpeechToSilenceProbability (tunable)
            labelSTSP = uilabel(gl,'Text','SpeechToSilenceProb:'); labelSTSP.Layout.Row=4; labelSTSP.Layout.Column=1;
            stspEdit = uieditfield(gl,'numeric','Value',SpeechToSilenceProbability,'Limits',[0 1],'ValueDisplayFormat','%.2f');
            stspEdit.Layout.Row=4; stspEdit.Layout.Column=2;

            % SilenceToSpeechProbability (tunable)
            labelSTSP2 = uilabel(gl,'Text','SilenceToSpeechProb:'); labelSTSP2.Layout.Row=5; labelSTSP2.Layout.Column=1;
            sptsEdit = uieditfield(gl,'numeric','Value',SilenceToSpeechProbability,'Limits',[0 1],'ValueDisplayFormat','%.2f');
            sptsEdit.Layout.Row=5; sptsEdit.Layout.Column=2;

            % Plot panel and tiled layout
            pnl = uipanel(gl,'BorderType','none'); pnl.Layout.Column=3; pnl.Layout.Row=[1 6];
            tl = tiledlayout(pnl,2,1,'Padding','compact','TileSpacing','compact');
            axOriginal = nexttile(tl,1);
            plot(axOriginal,t,y); title(axOriginal,'Original Data'); xlabel(axOriginal,'Time (s)');
            grid(axOriginal,'on');
            axVAD = nexttile(tl,2);
            title(axVAD,'Voice Activity Probability'); xlabel(axVAD,'Time (s)');
            linkaxes([axOriginal axVAD],'x');



            % Create voiceActivityDetector object
            function VAD = createVAD()
                windowVal = dropdownWindow.Value;
                VAD = voiceActivityDetector(...
                    'Window', windowVal, ...
                    'SpeechToSilenceProbability', stspEdit.Value, ...
                    'SilenceToSpeechProbability', sptsEdit.Value);
            end

            vadObj = createVAD();

            probLine = gobjects(1);

            % Refresh VAD probability plot
            function updateVADPlot(~,~)
                release(vadObj);
                frameLenSamples = round(frameLenEdit.Value * fs / 1000); % ms to samples
                overlapVal = overlapSlider.Value;
                voiceProb = [];
                idx = 1;
                step = max(1, round(frameLenSamples * (1 - overlapVal)));
                while idx + frameLenSamples - 1 <= length(y)
                    segment = y(idx:(idx+frameLenSamples-1));
                    p = vadObj(segment);
                    voiceProb = [voiceProb; p(:)];
                    idx = idx + step;
                end
                tVAD = ((0:length(voiceProb)-1)+0.5)*step/fs;
                cla(axVAD);
                if numel(voiceProb)>1
                    probLine(1) = plot(axVAD,tVAD,voiceProb,'-');
                else
                    probLine(1) = plot(axVAD,tVAD,voiceProb,'-o');
                end
                ylim(axVAD,[-0.1 1.1]);
                xlim(axVAD,[t(1) t(end)]+0.1*[-1 1]*(t(end)-t(1)));
                title(axVAD,'Voice Activity Probability'); xlabel(axVAD,'Time (s)');
                grid(axVAD,'on');
            end

            % Nontunable property changes: recreate object
            function changeNontunable(~,~)
                release(vadObj);
                vadObj = createVAD();
                updateVADPlot();
            end

            % Tunable property changes: update properties only
            function changeTunable(~,~)
                if isprop(vadObj,'SpeechToSilenceProbability'), vadObj.SpeechToSilenceProbability = stspEdit.Value; end
                if isprop(vadObj,'SilenceToSpeechProbability'), vadObj.SilenceToSpeechProbability = sptsEdit.Value; end
                updateVADPlot();
            end

            % Assign callbacks
            dropdownWindow.ValueChangedFcn = @changeNontunable;
            frameLenEdit.ValueChangedFcn = @updateVADPlot;
            overlapSlider.ValueChangedFcn = @updateVADPlot;
            stspEdit.ValueChangedFcn = @changeTunable;
            sptsEdit.ValueChangedFcn = @changeTunable;

            updateVADPlot();

            set([axVAD axOriginal],'Interactions',[zoomInteraction panInteraction]);

            % Apply and close button
            applyBtn = uibutton(gl,'Text','Apply','FontWeight','bold');
            applyBtn.Layout.Row = 6; applyBtn.Layout.Column = 2;

            closedByApply = false;
            outX = [];
            outY = [];

            function saveAndClose()
                SpeechToSilenceProbability = stspEdit.Value;
                SilenceToSpeechProbability = sptsEdit.Value;
                Window = dropdownWindow.Value;
                FrameLengthMs = frameLenEdit.Value;
                Overlap = overlapSlider.Value;
                closedByApply = true;

                outX = probLine.XData;
                outY = probLine.YData;
                delete(fig);
            end

            applyBtn.ButtonPushedFcn = @(~,~) saveAndClose();
            uiwait(fig);

            if ~closedByApply
                return;
            end

            newTitle = sprintf('%s Voice Activity Probability speech-to-silence prob %.2f, silence-to-speech prob %.2f, window type %s, frame length %.1f ms, overlap %.1f%%',...
                app.channelNames{channelNr}, SpeechToSilenceProbability, SilenceToSpeechProbability, Window, FrameLengthMs, Overlap*100);

            app.addSingleChannelData(outY, outX, newTitle, 'Raw');
        end






        function updateAudioPlayerIndicator(app,src,evt)

            delete(app.playbackPositionXLines);
            delete(app.playbackPositionXLinesSpectral);

            app.playbackPositionXLines=gobjects(numel(app.channelAxes),1);
            app.playbackPositionXLinesSpectral=gobjects(numel(app.channelAxes),1);

            if ~isempty(app.DraggingData.StartX)
                time=src.CurrentSample/src.SampleRate+app.DraggingData.StartX;
            else
                time=src.CurrentSample/src.SampleRate;
            end
            for channelNr=1:numel(app.channelAxes)
                app.playbackPositionXLines(channelNr)=xline(app.channelAxes(channelNr),time,'-k');
                app.playbackPositionXLinesSpectral(channelNr)=xline(app.channelAxesSpectral(channelNr),time,'-r');
            end

            drawnow limitrate;

        end

        function openResamplingApp(app,channelNr)

            y=app.channelYValues{channelNr};
            x=app.channelXValues{channelNr};
            originalFs=app.channelSampleRates(channelNr);

            fig=uifigure('Units','normalized','Position',[0.25 0.05 0.5 0.85],'Theme','light');

            gl=uigridlayout(fig,[9 2],'RowHeight',{'1x' '1x' '1x' '1x' '1x' '1x' '1x' 'fit' '1x'});

            panel=uipanel(gl,'BorderType','none');
            panel.Layout.Row=[1 4];
            panel.Layout.Column=[1 2];

            tl=tiledlayout(panel,2,1,'TileSpacing','compact','Padding','tight');
            ax1=nexttile(tl,1);
            line1=plot(ax1,x,y,'Color',app.timePlotHandles(channelNr).Color);
            title(ax1,[app.channelNames{channelNr};{['Sample Rate ' num2str(originalFs,'%i') ' Hz']}],'Interpreter','none');
            xlabel(ax1,'time (s)');

            ax2=nexttile(tl,2);
            line2=plot(ax2,x,y,'Color',app.timePlotHandles(channelNr).Color);
            title(ax2,[app.channelNames{channelNr};{['resampled at ' num2str(originalFs,'%i') ' Hz']}],'Interpreter','none');
            xlabel(ax1,'time (s)');

            linkaxes([ax1 ax2]);

            newSampleRateLabel=uilabel(gl,"Text",'New Sample Rate');
            newSampleRateLabel.Layout.Row=5;
            newSampleRateLabel.Layout.Column=1;

            newSampleRateEditField=uieditfield(gl,'numeric','Value',originalFs,'Limits',[1 inf],'RoundFractionalValues','on','ValueDisplayFormat','%i');
            newSampleRateEditField.Layout.Row=5;
            newSampleRateEditField.Layout.Column=2;

            interpolationMethodLabel=uilabel(gl,"Text",'Interpolation Method:');
            interpolationMethodLabel.Layout.Row=6;
            interpolationMethodLabel.Layout.Column=1;

            interpolationMethodDropdown=uidropdown(gl,'Items',{'Linear' 'Shape-preserving piecewise cubic' 'Spline'},'ItemsData',{'linear' 'pchip' 'spline'});
            interpolationMethodDropdown.Layout.Row=6;
            interpolationMethodDropdown.Layout.Column=2;


            affectedChannelsDropdown = uidropdown(gl,"Items",{sprintf('Affect only channel %i',channelNr) 'Affect all channels' 'Affect all channels above sampling frequency ->'},'ItemsData',1:3);
            affectedChannelsDropdown.Layout.Row=7;
            affectedChannelsDropdown.Layout.Column=1;

            affectedChannelsMinFsEditField = uieditfield(gl,'numeric','Limits',[0 inf],'LowerLimitInclusive','off','Visible','off','Value',app.channelSampleRates(channelNr),'ValueDisplayFormat','%i','RoundFractionalValues','on');
            affectedChannelsMinFsEditField.Layout.Row=7;
            affectedChannelsMinFsEditField.Layout.Column=2;

            affectedChannelsListedLabel=uilabel(gl,"Text",'','WordWrap','on','Visible','off');
            affectedChannelsListedLabel.Layout.Row=8;
            affectedChannelsListedLabel.Layout.Column=[1 2];



            doNoSamplingCheckbox=uicheckbox(gl,"Value",0,'Text','Just change time vector without proper resampling','Tooltip','Useful e.g. when the GAW was saved with the wrong sampling rate, e.g. 100kHz instead of 20kHz but the data are in reality in 20kHz. WARNING: this can introduce aliasing when used inproperly!','WordWrap','on');
            doNoSamplingCheckbox.Layout.Row=9;
            doNoSamplingCheckbox.Layout.Column=[1];


            useNewDataButton=uibutton(gl,'Text','Apply',"BackgroundColor",[245, 182, 66]./255,'Enable','on','ButtonPushedFcn',@(~,~) applyAndClose(app,channelNr));
            useNewDataButton.Layout.Row=9;
            useNewDataButton.Layout.Column=2;

            set([doNoSamplingCheckbox interpolationMethodDropdown newSampleRateEditField],'ValueChangedFcn',@(~,~) refreshResampledData(app));


            affectedChannelsDropdown.ValueChangedFcn=@(~,~)affectedChannelsChanged(app);
            affectedChannelsMinFsEditField.ValueChangedFcn=@(~,~)affectedChannelsChanged(app);

            %fig.CloseRequestFcn=@(~,~) uiresume(app.UIFigure);
            %uiwait(app.UIFigure);

            %waitfor(fig);

            function affectedChannelsChanged(app)
                if affectedChannelsDropdown.Value==3
                    affectedChannelsMinFsEditField.Visible='on';
                    affectedChannelsListedLabel.Visible='on';

                    channelsAffected=find(app.channelSampleRates>affectedChannelsMinFsEditField.Value);

                    if ~isempty(channelsAffected)
                        useNewDataButton.Enable='on';
                        affectedChannelsListedLabel.Text=['affecting channels ' strjoin(strsplit(num2str(channelsAffected)),', ')];
                    else
                        affectedChannelsListedLabel.Text='no channels are affected';
                        useNewDataButton.Enable='off';
                    end
                else
                    useNewDataButton.Enable='on';
                    affectedChannelsMinFsEditField.Visible='off';
                    affectedChannelsListedLabel.Visible='on';
                    affectedChannelsListedLabel.Text='';
                end

            end




            function refreshResampledData(app)
                affectedChannelsChanged(app);

                newFs=newSampleRateEditField.Value;
                title(ax2,[app.channelNames{channelNr};{['resampled at ' num2str(newFs,'%i') ' Hz']}]);
                % if newFs==originalFs
                %     useNewDataButton.Enable='off';
                % else
                %     useNewDataButton.Enable='on';
                % end

                if doNoSamplingCheckbox.Value==0
                    [newY,newX]=resample(y,x,newFs,interpolationMethodDropdown.Value);
                else
                    newY=y;
                    newX=((0:numel(y)-1)./newFs)+x(1);
                end
                set(line2,'XData',newX(:),'YData',newY(:));

                drawnow;



            end

            function applyAndClose(app,channelNr)
                newFs=newSampleRateEditField.Value;

                if affectedChannelsDropdown.Value==1
                    channelsToProcess=channelNr;
                elseif affectedChannelsDropdown.Value==2
                    channelsToProcess=1:numel(app.channelAxes);
                else % value==3
                    channelsToProcess=find(app.channelSampleRates>affectedChannelsMinFsEditField.Value);
                end

                for channelNr=channelsToProcess

                    curry=app.channelYValues{channelNr};
                    currx=app.channelXValues{channelNr};

                    if doNoSamplingCheckbox.Value==0
                        [newY,newX]=resample(curry,currx,newFs,interpolationMethodDropdown.Value);
                    else
                        newY=curry;
                        newX=((0:numel(curry)-1)./newFs)+currx(1);
                    end



                    if ~isequal(app.channelYValues{channelNr},newY) || ~isequal(app.channelXValues{channelNr},newX)
                        app.addValueSetToValueHistory(newY,newX,channelNr);
                    else
                        break;
                    end

                    app.channelYValues{channelNr}=newY;

                    app.channelXValues{channelNr}=newX;
                    app.channelSampleRates(channelNr)=newSampleRateEditField.Value;

                    set(app.timePlotHandles(channelNr),'XData',newX,'YData',newY);



                end


                close(fig);

            end

        end


        function refreshSpectralPlots(app,channelsToRefresh,moveInTimeOnly)
            if nargin<2 || isempty(channelsToRefresh)
                channelsToRefresh=1:numel(app.channelAxes);
            end
            if nargin<3 || isempty(moveInTimeOnly)
                moveInTimeOnly=0;
            end

            app.createPoolIfNonexistent();

            timeCells=app.channelXValues;
            yCells=app.channelYValues;
            FSs=app.channelSampleRates;
            specMaxFreq=app.spectrumCalculationSettings.maxFreq;
            specMinFreq=app.spectrumCalculationSettings.minFreq;
            specNFreqs=app.spectrumCalculationSettings.frequencyValuesPerOctave;
            specDOSyncUpperFreq=app.spectrumCalculationSettings.syncUpperFreqAndTimeResolution;
            specPrecision=app.spectrumCalculationSettings.spectralPrecision;
            spectralAxes=app.channelAxesSpectral;
            spectrumHandles=app.spectralPlotHandles;
            validHandles=app.isvalidhandle(app.spectralPlotHandles);

            % --------- numeric part: parfor without graphics ---------
            if ~moveInTimeOnly
                wtCell   = cell(numel(channelsToRefresh),1);
                fCell    = cell(numel(channelsToRefresh),1);
                tCell    = cell(numel(channelsToRefresh),1);
                isBatch= app.batchMode;

                parfor channelNr=channelsToRefresh
                    time=timeCells{channelNr};
                    y=yCells{channelNr};
                    fs=FSs(channelNr);
                    upperFreq=min([fs/2 specMaxFreq]);
                    lowerFreq=min([specMinFreq upperFreq-1]);
                    evals=ceil(log2(upperFreq/lowerFreq)*specNFreqs);
                    if evals<2
                        evals=2;
                    end

                    [resampledY,resampledTime]=deal([]); % otherwise i get a annoying parfor warning for those two variables

                    if ~isBatch
                        try
                            if specDOSyncUpperFreq==1
                                [resampledY,resampledTime]=resample(y(:).',time,upperFreq*2);
                                newFs=upperFreq*2;
                            else
                                [resampledY,resampledTime]=resample(y(:).',time,fs);
                                newFs=fs;
                            end
                            warning('off');

                            

                            resampledYpadded=[resampledY rand(1,2048)];

                            if ~isfile(sprintf('n%i_t1.wis',2^nextpow2(numel(resampledY))))
                                FCWT.fCWT_create_plan(numel(resampledYpadded),1,'measure');
                            end

                            [wt,f] = FCWT.fCWT(single(resampledYpadded),...
                                specPrecision,...
                                newFs,lowerFreq,upperFreq,evals,1);
                            wt=wt.';

                            wt(:,end-2048+1:end)=[];
                            warning('on');
                        catch ME
                            disp('error while calculating fCWT, trying matlab cwt. Error message follows');
                            ME.getReport();
                            try
                                [wt,f] = cwt(resampledY,...
                                    upperFreq*2,...
                                    'FrequencyLimits',[lowerFreq,upperFreq],...
                                    'VoicesPerOctave',min([specNFreqs 48]),...
                                    'TimeBandwidth',specPrecision*15);
                            catch ME
                                disp('error while calculating matlab cwt, replacing with dummy...');
                                ME.getReport();
                                wt=rand(10); f=1:10; resampledTime=linspace(time(1),time(end),10);
                            end
                        end

                    else
                        wt=rand(10); f=1:10; resampledTime=linspace(time(1),time(end),10);

                    end

                    wtCell{channelNr} = abs(wt);
                    fCell{channelNr}  = f;
                    tCell{channelNr}  = resampledTime;
                end

                % --------- grafik part: ---------
                for channelNr = channelsToRefresh
                    wtAbs = wtCell{channelNr};
                    wtAbs=20*log10(wtAbs+eps);
                    fData     = fCell{channelNr};
                    resampledTimeNew = tCell{channelNr};

                    if ~validHandles(channelNr)
                        spectrumHandles(channelNr)=imagesc(spectralAxes(channelNr),resampledTimeNew,fData,wtAbs,'PickableParts','none');
                    else
                        set(spectrumHandles(channelNr),'CData',wtAbs,'YData',fData,'XData',resampledTimeNew);
                    end
                    set(spectralAxes(channelNr),'YDir','normal','YScale','log')
                    axis(spectralAxes(channelNr),'tight');
                    shading(spectralAxes(channelNr),'flat');
                    colormap(spectralAxes(channelNr),"gray");
                end

            else
                for channelNr = channelsToRefresh
                    xlim(spectralAxes(channelNr),'manual');
                    spectrumHandles(channelNr).XData=spectrumHandles(channelNr).XData-spectrumHandles(channelNr).XData(1)+app.channelLag(channelNr);%timeCells{channelNr};
                end
            end

            app.spectralPlotHandles=spectrumHandles;
        end




        function filterParameterResultsTable(app,filterText)

            if nargin<2 || isempty(filterText)
                filterText = '';%app.FilterResultsTableEditField.Value;
            end


            originalTable=app.FilterResultsTableEditField.UserData.ResultsTable;

            if app.CasesensitiveCheckBox.Value==1
                doIgnoreCase=false;
            else
                doIgnoreCase=true;
            end

            if ~app.ChannelnameCheckBox.Value && ~app.ParameternameCheckBox.Value && ~app.SourcetypeCheckBox.Value
                app.ChannelnameCheckBox.Value=1;
                columnsToSearchFor=1;
            else
                columnsToSearchFor=find([app.ChannelnameCheckBox.Value app.ParameternameCheckBox.Value app.SourcetypeCheckBox.Value]==1);
            end

            if ~isempty(filterText)
                suitingRows=any(contains(originalTable(:,columnsToSearchFor),filterText,'IgnoreCase',doIgnoreCase),2);
                app.parameterResultsUITable.Data=originalTable(suitingRows,:);
                app.currentResultsTableChannelSourcesFiltered=app.currentResultsTableChannelSources(suitingRows);
            else
                app.parameterResultsUITable.Data=originalTable;
                app.currentResultsTableChannelSourcesFiltered=app.currentResultsTableChannelSources;
            end

            % coloring can be mixed up when the table is filtered
            numOfStyles=size(app.parameterResultsUITable.StyleConfigurations,1);
            if numOfStyles>1
                removeStyle(app.parameterResultsUITable,2:numOfStyles);
            end

            drawnow limitrate;

        end

        function checkAndInitiateChannelResult(app,fieldsToTest,initNaNs)

            if ~iscell(fieldsToTest) % if given e.g. a character array
                fieldsToTest={fieldsToTest};
            end

            for fieldNr=1:numel(fieldsToTest)
                currField=fieldsToTest{fieldNr};
                % check if field exists and initiate if not
                if ~isfield(app.calculationResults.channelResults(channelNr),currField)
                    app.calculationResults.channelResults(channelNr).(currField)=initNaNs;
                end
            end

        end

        function refreshAppliedLagTexts(app,manualValues)

            if ~isempty(app.appliedLagTexts)
                delete(app.appliedLagTexts);
            end

            app.appliedLagTexts=gobjects(1,numel(app.channelAxes));

            if nargin<3 || isempty(manualValues)
                manualValues=app.channelLag;
            end

            channelsToProcess=1:numel(manualValues);

            for channelNr=channelsToProcess
                app.appliedLagTexts(channelNr)=text(app.channelAxes(channelNr),0,1,sprintf('Applied lag: %6g s',app.channelLag(channelNr)),'HorizontalAlignment','left','VerticalAlignment','bottom','Units','normalized','Clipping','off','PickableParts','none','FontSize',app.channelAxes(channelNr).FontSize);
            end

        end
        
         function importDataFromFile(app, fileImportPath)
             persistent lastPath;

             app.titleTimer.stop();
                listOfFormatsForAudioread=';*.aifc;*.aiff;*.aif;*.au;*.flac;*.ogg;*.opus;*.wav;*.mp3;*.m4a;*.mp4';
                listOfFormatsForImageread=';*.png;*.bmp;*.jpg;*.jpeg;*.jp2';

             if nargin<2 || isempty(fileImportPath)




                 fakefig=uifigure('Visible','off');
                 [files,folder,idx] = uigetfile( ...
                     {['*.gaw;*.csv;*.wvd;*.mat;*.wav' listOfFormatsForAudioread listOfFormatsForImageread],'gaw or photron csv (type A)/wvd import, Vocaliscope .mat files, audio files, audio from mp4, GAW from PVG'; ...
                     '*.*','any other file'}, ...
                     'Select one or more files',lastPath,'MultiSelect','on');
                 close(fakefig);

                 if isequal(files,0)
                     disp('file import aborted by user');
                     app.titleTimer.start();
                     return;
                 end
                 lastPath=folder;

                 

                 filePathGiven=0;

             else
                 idx=1;
                [folder,files,ext]=fileparts(fileImportPath);


                if iscell(fileImportPath)
                    folder=[folder{1} filesep];
                    files=append(files,ext);
                else
                    folder=[folder filesep];
                    files=[files,ext];
                end

                filePathGiven=1;
             end

             % if only one file was selected, convert from char array to cell string
             if ischar(files)
                 files={files};
             end

            

            

            if idx==1 % if mixed audio, photron csv type A, or photron wvd
                for fileNr=1:numel(files)
                    currFile=[folder files{fileNr}];
                    [~,~,currExt]=fileparts(currFile);

                    %% import audio files
                    if ismember(currExt,strsplit(listOfFormatsForAudioread,';*'))

                        info=audioinfo(currFile);

                        [channelTypeNames,doAbort]=app.createChooseWAVchannelTypesFigure(currFile,info.NumChannels);

                        if doAbort%~answerValid
                            disp('User aborted answer. Skipping file');
                            continue;
                        end

                        [newdata,fs]=audioread(currFile,[1 inf],"double");
                        numberOfNewChannelsInThisFile=size(newdata,2);
                        newdataChannelSources=channelTypeNames;%repelem(app.channelSourcePossibilities(answerIdx),numberOfNewChannelsInThisFile);
                        newdataSampleRates=repelem(fs,numberOfNewChannelsInThisFile);

                        if info.NumChannels>1
                            newdataChannelNames=append(files(fileNr),' channel ',strsplit(num2str(1:numberOfNewChannelsInThisFile,'%02i ')));
                        else
                            newdataChannelNames=files(fileNr);
                        end

                    elseif ismember(currExt,strsplit(listOfFormatsForImageread,';*'))

                        

                        newdataChannelSources=app.channelSourcePossibilities(contains(app.channelSourcePossibilities,'GAW','IgnoreCase',true));
                        newdataChannelNames=files(fileNr);

                        [newdata,newdataSampleRates,closedByApply]=app.openPVGimportApp(currFile);

                        if ~closedByApply
                            disp('User aborted PVG import');
                            return;
                        end

                        newdata=newdata(:,1); % contains total, left and right gaw

         


                        numberOfNewChannelsInThisFile=1;




                        %% import photron wvd
                    elseif strcmpi(currExt,'.wvd')
                        [newdata,meta]=app.importPhotronWVD(currFile,'double');
                        newdata=newdata'; % originally the data is given rowwise, so convert to columnwise
                        meta.channelName=regexprep(meta.channelName,char(0),'');
                        fs=meta.sampleRate;

                        numberOfNewChannelsInThisFile=size(newdata,2);
                        newdataSampleRates=repelem(fs,numberOfNewChannelsInThisFile);


                        % check if found channel names are part of the
                        % predefined channel name list
                        % each row is one channel, each column one of the
                        % possibilities in whereToFind
                        whereToFind=false(numberOfNewChannelsInThisFile,numel(app.channelSourcePossibilities));
                        for channelPossNr=1:numel(app.channelSourcePossibilities)
                            whereToFind(:,channelPossNr)=contains(meta.channelName,app.channelSourcePossibilities{channelPossNr});
                        end
                        whereToFind(~any(whereToFind,2),contains(app.channelSourcePossibilities,'Raw','IgnoreCase',true))=true;

                        % maybe better with user input?
                        [row,~]=find(whereToFind');
                        newdataChannelSources=app.channelSourcePossibilities(row);

                        % do not use channel x, but the types here
                        newdataChannelNames=append(files(fileNr),' channel ',meta.channelName);

                        %% import photron type A csv
                    elseif strcmpi(currExt,'.csv')
                        [meta,data]=app.readPhotronGraphExportData(currFile);

                        newdata=data(:,4:end);

                        meta(cellfun(@(in) isempty(in) || ~ischar(in),meta(:,1)),1)={''};
                        fs=meta{contains(meta(:,1),'SamplingRate'),3};
                        newdataChannelNames=append(files(fileNr),' channel ',meta(end,4:end));

                        numberOfNewChannelsInThisFile=numel(newdataChannelNames);
                        whereToFind=false(numberOfNewChannelsInThisFile,numel(app.channelSourcePossibilities));
                        for channelPossNr=1:numel(app.channelSourcePossibilities)
                            %whereToFind(:,channelPossNr)=contains(newdataChannelNames,app.channelSourcePossibilities{channelPossNr});
                            whereToFind(:,channelPossNr)=contains(meta(end,4:end),app.channelSourcePossibilities{channelPossNr});
                        end
                        whereToFind(~any(whereToFind,2),contains(app.channelSourcePossibilities,'Raw','IgnoreCase',true))=true;

                        % maybe better with user input?
                        [row,~]=find(whereToFind');
                        newdataChannelSources=app.channelSourcePossibilities(row);
                        newdataSampleRates=repelem(fs,numberOfNewChannelsInThisFile);

                        %% import vocaliscope mat file
                    elseif strcmpi(currExt,'.mat')

                        availableVars=who(matfile(currFile));
                        if ~all(ismember({'names','yhistory'},availableVars))
                            uialert(app.UIFigure,'Seems no to be a suitable data mat file from Vocaliscope. Skipping it.','Not valid Vocaliscope mat file','Icon','info');
                            continue; % skip mat file if it does not contain the e.g. the history variable and the names variable
                        end


                        load(currFile,'sources','names');
                        newdataChannelSources=sources;
                        newdataChannelNames=names;

                        numberOfNewChannelsInThisFile=numel(sources);

                        if ismember('appVersion',availableVars)
                            appVersionOfSavedMat=load(currFile,'appVersion');

                            if str2double(appVersionOfSavedMat.appVersion)<=2.5 && ~filePathGiven

                                answerLoadHistory = uiconfirm(app.UIFigure, {'Use this only for post Version 2.5 Vocaliscope mat files.' 'Before 2.6 there can occur errors regarding association of channel data and channel name/type when there were channels with more than 1 unique sample rate.' 'Version 2.6 was released on 29.10.2025 if you want to check .mat creation date.' 'Either way you can still use this file to restore channel names and types after loading from e.g. from wav files.' 'Continue?'}, 'Ask for version of mat file', ...
                                    'Options', {'Skip file', 'Continue'}, ...
                                    'DefaultOption', 2, ...  % Continue als Default
                                    'CancelOption', 1);     % Skip file als Cancel
                            else
                                answerLoadHistory='Continue';
                            end

                        elseif ~filePathGiven
                            answerLoadHistory = uiconfirm(app.UIFigure, {'Use this only for post Version 2.5 Vocaliscope mat files.' 'Before 2.6 there can occur errors regarding association of channel data and channel name/type when there were channels with more than 1 unique sample rate.' 'Version 2.6 was released on 29.10.2025 if you want to check .mat creation date.' 'Either way you can still use this file to restore channel names and types after loading from e.g. from wav files.' 'Continue?'}, 'Ask for version of mat file', ...
                                'Options', {'Skip file', 'Continue'}, ...
                                'DefaultOption', 2, ...  % Continue als Default
                                'CancelOption', 1);     % Skip file als Cancel
                        else
                            answerLoadHistory='Continue';
                        end


                        if isempty(answerLoadHistory) || strcmpi(answerLoadHistory,'Skip file')
                            continue;
                        end

                        load(currFile,'yhistory','xhistory');

                        nonemptyEntries=~cellfun(@isempty,yhistory);

                        yhistory(~any(nonemptyEntries,2),:)=[];
                        xhistory(~any(nonemptyEntries,2),:)=[];

                        nonemptyEntries(~any(nonemptyEntries,2),:)=[];

                        lastNonEmpty=arrayfun(@(c) find(nonemptyEntries(:,c), 1, 'last'), 1:size(nonemptyEntries,2));
                        newdata= yhistory(sub2ind(size(yhistory), lastNonEmpty , 1:size(yhistory,2)));
                        newxdata = xhistory(sub2ind(size(xhistory), lastNonEmpty , 1:size(xhistory,2)));
                        newdataSampleRates=cellfun(@(in) round(1/mean(diff(in))),newxdata);


                        %% import GAW
                    elseif strcmpi(currExt,'.gaw')
                        out=readmatrix(currFile,'FileType','text','Range','B:C');
                        out(1,:)=[]; % header lines
                        newdataChannelSources=app.channelSourcePossibilities(contains(app.channelSourcePossibilities,'GAW','IgnoreCase',true));
                        newdataChannelNames=files(fileNr);
                        newdataSampleRates=round(1/mean(diff(out(:,1))));
                        numberOfNewChannelsInThisFile=1;
                        newdata=out(:,2);

                    end

                    if numel(app.channelLag)>0
                        answer=uiconfirm(app.UIFigure,{'Here you can choose to import data as standalone channels or append them to existing channels'...
                            'File Path:' currFile},...
                            'Standalone or append',"Options",["Standalone","Append","Cancel import"], ...
                            "DefaultOption",1,"CancelOption",3,'Icon','Question');
                    else
                        answer='Standalone';
                    end

                    switch answer
                        case 'Cancel import'
                            return;
                        case 'Append'
                            [sourceChannelNr,targetChannelNr] = app.append_channel_assignment(numberOfNewChannelsInThisFile, size(app.availableChannelsTable.Data,1));

                            for appendNr=1:numel(sourceChannelNr)

                                % when the to be appended data has a
                                % different sample rate than the
                                % existing channel, we have to resample
                                % and use the same sampling rate

                                %if ~strcmpi(currExt,'.mat')
                                %    currentNewDataSampleRate=newdataSampleRates;
                                %else
                                currentNewDataSampleRate=newdataSampleRates(sourceChannelNr(appendNr));
                                %end

                                if app.channelSampleRates(targetChannelNr(appendNr))~=currentNewDataSampleRate
                                    rateAnswer=uiconfirm(app.UIFigure,{sprintf('Existing channel %i has different sampling rate (%i Hz) compared to the data in channel %i that shall be appended (%i Hz). Which sampling rate do you want to use?',targetChannelNr(appendNr),app.channelSampleRates(targetChannelNr(appendNr)),sourceChannelNr(appendNr),currentNewDataSampleRate)},...
                                        'Choose Sample Rate',"Options",["Higher Rate","Existing Rate","Lower Rate","appended data Rate"], ...
                                        "DefaultOption",1,"CancelOption",1,'Icon','Question');

                                    switch rateAnswer
                                        case "Existing Rate"
                                            newRate=currentNewDataSampleRate;
                                        case "Lower Rate"
                                            newRate=min(app.channelSampleRates(targetChannelNr(appendNr)),currentNewDataSampleRate);
                                        case "appended data Rate"
                                            newRate=currentNewDataSampleRate;
                                        otherwise
                                            newRate=max(app.channelSampleRates(targetChannelNr(appendNr)),currentNewDataSampleRate);
                                    end

                                else
                                    newRate=app.channelSampleRates(targetChannelNr(appendNr));


                                end


                                if ~strcmpi(currExt,'.mat')



                                    appendedT=(0:size(newdata,1)-1)/currentNewDataSampleRate;
                                    appendedT=appendedT+(app.channelXValues{targetChannelNr(appendNr)}(end)+1/app.channelSampleRates(targetChannelNr(appendNr)));



                                    app.channelXValues{targetChannelNr(appendNr)}=[app.channelXValues{targetChannelNr(appendNr)}(:);...
                                        appendedT(:)];
                                    app.channelYValues{targetChannelNr(appendNr)}=[app.channelYValues{targetChannelNr(appendNr)}(:);...
                                        newdata(:,sourceChannelNr(appendNr))];

                                    % resampling is then done after this if/else

                                else


                                    % this line is different
                                    appendedT=(1:numel(newdata{sourceChannelNr(appendNr)}))/currentNewDataSampleRate;
                                    appendedT=appendedT+app.channelXValues{targetChannelNr(appendNr)}(end);
                                    app.channelXValues{targetChannelNr(appendNr)}=[app.channelXValues{targetChannelNr(appendNr)}(:);...
                                        appendedT(:)];
                                    % and this line is different
                                    app.channelYValues{targetChannelNr(appendNr)}=[app.channelYValues{targetChannelNr(appendNr)}(:);...
                                        newdata{sourceChannelNr(appendNr)}(:)];
                                end

                                [app.channelYValues{targetChannelNr(appendNr)},app.channelXValues{targetChannelNr(appendNr)}]=resample(app.channelYValues{targetChannelNr(appendNr)},app.channelXValues{targetChannelNr(appendNr)},newRate,'pchip');

                                app.channelSampleRates(targetChannelNr(appendNr))=newRate;


                                set(app.timePlotHandles(targetChannelNr(appendNr)),'XData',app.channelXValues{targetChannelNr(appendNr)},...
                                    'YData',app.channelYValues{targetChannelNr(appendNr)});


                                app.addValueSetToValueHistory(app.channelYValues{targetChannelNr(appendNr)},app.channelXValues{targetChannelNr(appendNr)},targetChannelNr(appendNr));




                            end
                            xlim([app.channelAxes app.channelAxesSpectral],[min(cellfun(@(in) in(1),app.channelXValues)) max(cellfun(@(in) in(end),app.channelXValues))]);

                            app.refreshSpectralPlots();

                            app.titleTimer.start();

                            return;

                        otherwise % normal import


                            if ~strcmpi(currExt,'.mat')
                                % replace NaN values

                                nanEntries=isnan(newdata);

                                if any(nanEntries(:))

                                    fillMethodShort={'nearest','linear','spline','makima','pchip'};
                                    fillMethodLong={'nearest non-NaN','linear interpoation','spline interpolation','Modified Akima cubic Hermite interpolation','piecewise cubic interpolation'};
                                    [answeridx,validanswer]=listdlg("PromptString",{['There are NaN values in import channels ' strjoin(strsplit(num2str(find(any(nanEntries,1)))),', ')  '.'] 'Choose replacement method:'},'Name','NaN found','SelectionMode','single','ListString',fillMethodLong,'CancelString','Stop Data Import','OKString','Apply','ListSize',[320 150]);


                                    if ~validanswer
                                        app.titleTimer.start();
                                        return;
                                    end

                                    newdata=fillmissing(newdata,fillMethodShort{answeridx},1);

                                    message='There were NaN values, those were replaced with nearest non-NaN value.';
                                    disp(message)


                                end

                            else

                            end



                            %% add new data to property

                            if ~strcmpi(currExt,'.mat')
                                newYValues=mat2cell(newdata, size(newdata, 1), ones(1, numberOfNewChannelsInThisFile));
                                app.channelYValues=[app.channelYValues newYValues];
                                app.channelXValues=[app.channelXValues mat2cell(repmat((0:size(newdata,1)-1)'/newdataSampleRates(1),[1 numberOfNewChannelsInThisFile]), size(newdata, 1), ones(1, numberOfNewChannelsInThisFile))];
                                app.channelNames=[app.channelNames newdataChannelNames];
                                app.channelSource=[app.channelSource newdataChannelSources];
                                app.channelSampleRates=[app.channelSampleRates newdataSampleRates];
                                app.channelLag=[app.channelLag zeros(1,numberOfNewChannelsInThisFile)];

                                app.channelYValuesHistory(1,end+1:end+numberOfNewChannelsInThisFile) = newYValues;
                                app.channelXValuesHistory(1,end+1:end+numberOfNewChannelsInThisFile) = mat2cell(repmat((0:size(newdata,1)-1)'/newdataSampleRates(1),[1 numberOfNewChannelsInThisFile]), size(newdata, 1), ones(1, numberOfNewChannelsInThisFile));

                            else
                                newYValues=newdata;
                                app.channelYValues=[app.channelYValues newYValues];

                                load(currFile,'xhistory');
                                nonemptyEntries=~cellfun(@isempty,xhistory);
                                xhistory(~any(nonemptyEntries,2),:)=[];
                                nonemptyEntries(~any(nonemptyEntries,2),:)=[];
                                lastNonEmpty=arrayfun(@(c) find(nonemptyEntries(:,c), 1, 'last'), 1:size(nonemptyEntries,2));


                                newxdata= xhistory(sub2ind(size(xhistory), lastNonEmpty , 1:size(xhistory,2)));

                                app.channelXValues=[app.channelXValues newxdata];
                                app.channelNames=[app.channelNames newdataChannelNames];
                                app.channelSource=[app.channelSource newdataChannelSources];
                                newdataSampleRates=cellfun(@(in) round(1/min(diff(in))),newxdata);
                                app.channelSampleRates=[app.channelSampleRates newdataSampleRates];
                                app.channelLag=[app.channelLag cellfun(@(in) in(1),newxdata)];

                                if numel(app.channelYValuesHistory)>0
                                    if size(yhistory,1)>size(app.channelYValuesHistory,1)
                                        app.channelXValuesHistory(end+1:(end+size(yhistory,1)-size(app.channelYValuesHistory,1)),:)=cell(1);
                                        app.channelYValuesHistory(end+1:(end+size(yhistory,1)-size(app.channelYValuesHistory,1)),:)=cell(1);
                                    elseif size(yhistory,1)<size(app.channelYValuesHistory,2)
                                        xhistory(end+1:(end+size(app.channelYValuesHistory,1)-size(yhistory,1)),:)=cell(1);
                                        yhistory(end+1:(end+size(app.channelYValuesHistory,1)-size(yhistory,1)),:)=cell(1);
                                    end
                                    app.channelYValuesHistory=[app.channelYValuesHistory yhistory];
                                    app.channelXValuesHistory=[app.channelXValuesHistory xhistory];
                                else
                                    app.channelYValuesHistory=yhistory;
                                    app.channelXValuesHistory=xhistory;
                                end

                            end
                    end


                end


            elseif idx==2 % not audio, not gaw, not wvd, not photron csv type A
                disp('generic files not yet supported')
                return;


            end

            if ~app.batchMode
                figure(app.UIFigure);
            end



            app.availableChannelsTable.Data=[app.channelNames(:) app.channelSource(:)];
            app.availableChannelsTable.Selection=1:numel(app.channelNames);

            if isempty(app.availableChannelsTable.Data)
                app.titleTimer.start();
                return;
            end

            profile on;

            app.refreshTimeAndSpectralPlotData();

            profile viewer;

            %drawnow;
            %xlim(app.channelAxes,'tight');

            % drawnow;
            xlim(app.channelAxes,[min(cellfun(@(in) in(1),app.channelXValues)) max(cellfun(@(in) in(end),app.channelXValues))]);

            %% set selection edit field values
            %app.updateSelectionAreaEditFieldsValues(); % already included
            %in refreshTimePlotData

            if ~isempty(app.DraggingData.StartX)
                app.updateSelectionAreaEditFieldsLimits();
            end

            set([app.SelectedAreaDurationEditField app.SelectedAreaEndEditField app.SelectedAreaStartEditField],'Editable','on');


            if strcmpi(currExt,'.mat')
                try % added in later version (since 2.5), so we try it
                    load(currFile,'selectionEnd',"selectionStart");
                    app.DraggingData.StartX=selectionStart;
                    app.DraggingData.EndX=selectionEnd;

                    delete(app.DraggingData.CurrentRectangles);
                    app.DraggingData.CurrentRectangles=gobjects(1,numel(app.channelAxes));

                    delete(app.spectralRectangles);
                    app.spectralRectangles=gobjects(1,numel(app.channelAxes));

                    for channelNr=1:numel(app.channelAxes)
                        yMin=min(app.channelYValues{channelNr})-app.timePlotPadPercentage*range(app.channelYValues{channelNr});
                        yMax=max(app.channelYValues{channelNr})+app.timePlotPadPercentage*range(app.channelYValues{channelNr});
                        app.DraggingData.CurrentRectangles(channelNr) = rectangle(app.channelAxes(channelNr), ...
                            'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                            'FaceColor', [0.8, 0.8, 1, 0.5], ...
                            'FaceAlpha',0.5,...
                            'EdgeColor', 'none', ...
                            'PickableParts', 'none');
                        uistack(app.DraggingData.CurrentRectangles(channelNr),'bottom');

                        yMin=min(app.spectralPlotHandles(channelNr).YData);
                        yMax=max(app.spectralPlotHandles(channelNr).YData);
                        app.spectralRectangles(channelNr) = rectangle(app.channelAxesSpectral(channelNr), ...
                            'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                            'FaceColor', [0.8, 0.8, 1, 0.5], ...
                            'FaceAlpha',0.2,...
                            'EdgeColor', 'none', ...
                            'PickableParts', 'none');
                        uistack(app.spectralRectangles(channelNr),'top');


                    end

                    app.SelectedAreaStartEditField.Value=selectionStart;
                    app.SelectedAreaEndEditField.Value=selectionEnd;
                    app.SelectedAreaDurationEditField.Value=selectionEnd-selectionStart;

                    app.createAudioPlayerData();

                end


            end
            app.titleTimer.start();

            % in the exe version of this app, the tiled layout does not
            % scale according to its partent. manually resetting it has no
            % effect, but resizing the window or changeing the window state
            % does....
            persistent onceMaximize

            if isempty(onceMaximize) && isdeployed
                t1=timer("ExecutionMode","singleShot","Period",2,"TimerFcn",@(~,~)set(app.UIFigure,'WindowState','maximized'));
                t1.start();
                onceMaximize='done';
            end
           
        end

        
        function calculateParameters(app)
            %% open settings and let the user chosse settings
            if isempty(app.channelYValues)
                return;
            end
            
            

                      

            if ~app.batchMode
                settingsApp=VocaliscopeCalculationSettings(app.batchMode);
                settingsApp.loadAppState();

                movegui(settingsApp.UIFigure,"center");
    
                settingsApp.channelsSuitableAsMask=find(cellfun(@(in) isequal(unique(in(:)),[0; 1]),app.channelYValues));
                settingsApp.checkIfAnyChannelCanBeUsedAsMask();
    
                settingsApp.UIFigure.Theme='light';
            end

            %% get start and end times of selection if possible
            if isempty(app.DraggingData.StartX) || app.DraggingData.StartX==app.DraggingData.EndX
                selectionStart=max(cellfun(@(in) in(1),app.channelXValues));
                selectionEnd=min(cellfun(@(in) in(end),app.channelXValues));
            else
                selectionStart=app.DraggingData.StartX;
                selectionEnd=app.DraggingData.EndX;
            end

            if ~app.batchMode

                % the maxmimum window size equal to the selected area duration
                settingsApp.setMaximumWindowLength(selectionEnd-selectionStart);
                %settingsApp.UIFigure.WindowStyle='modal';
                drawnow;
                waitfor(settingsApp,'outputSettings');
                if isvalid(settingsApp) % if settings were closed by preview or calculation button
                    app.calculationSettings=settingsApp.outputSettings;
                    app.calculationCalledAsPreview=settingsApp.calledAsPreview;
    
                    app.keepVocaliscopeSettingsOverSession=settingsApp.keepVocaliscopeSettingsOverSession;
                    settingsApp.saveCurrentAppState();
                    delete(settingsApp);
    
                    % also change back to normal mode after parameter
                    % calculation
                    app.normalButton.Value=1;
                    app.setToNormalInteractionMode();
    
                else % if just the window was closed
    
                    % when doing that, the settings are deleted if calculated
                    % before
                    %                 app.calculationSettings=[];
                    %                 app.calculationCalledAsPreview=[];
                    return;
                end

            else
                app.normalButton.Value=1;
                %app.setToNormalInteractionMode();

                app.calculationCalledAsPreview=0;
            end



            %% set allowed channels type for some Parameters

            channelTypesAllowedForAudioFeatureExtractor={'GAW','EGG','Audio','Flow','Pressure'};



            %% delete old cycle borders
            delete(app.cycleBorderHandles);
            app.cycleBorderHandles=gobjects(1,numel(app.channelAxes));

            %% delete old OQ and CLQ areas
            delete(app.cycleOQHandle(isvalid(app.cycleOQHandle)));
            delete(app.cycleClQHandle(isvalid(app.cycleClQHandle)));

            app.cycleOQHandle =gobjects(1,numel(app.channelAxes));
            app.cycleClQHandle=gobjects(1,numel(app.channelAxes));


            %% delete old calculation results
            app.calculationResults=struct();

            nChannels=numel(app.channelYValues);


            %% create progress bar that can be canceled
            


            %setappdata(progDialog,'canceling',0);

            if ~app.batchMode
                if isempty(gcp('nocreate')) && app.calculationCalledAsPreview==0 && (app.calculationSettings.SampleEntropyFD.doCalculate || app.calculationSettings.CPPv1.doCalculate || app.calculationSettings.GNEv2.doCalculate || app.calculationSettings.SampleEntropyTime.doCalculate || app.calculationSettings.pitch.doCalculate)
                    progDialog=uiprogressdlg(app.UIFigure,'Title','Calculating parameters...',...
                        'Message','Preparing parallel computing...','Cancelable','on');
    
                    app.createPoolIfNonexistent();
                else
                    progDialog=uiprogressdlg(app.UIFigure,'Title','Calculating parameters...',...
                        'Message',['0 of ' num2str(nChannels) ' channels complete'],'Cancelable','on');
                end
            end



            %% save applied lag
            app.calculationResults.appliedChannelLag=app.channelLag;


            %% save selected interval
            app.calculationResults.selectionStart=selectionStart;
            app.calculationResults.selectionEnd=selectionEnd;
            app.calculationResults.channelNames=app.channelNames;
            app.calculationResults.channelSource=app.channelSource;
            app.calculationResults.channelSampleRates=app.channelSampleRates;

            %% see if we calculate on base of windows, or use only one window
            if app.calculationSettings.useWindows==1
                startTimes=selectionStart:app.calculationSettings.windowHopLength:selectionEnd-app.calculationSettings.windowLength;
                endTimes=selectionStart+app.calculationSettings.windowLength:app.calculationSettings.windowHopLength:selectionEnd;

                % if we would use the following, the last window could
                % be not full length; maybe add option if this is
                % wanted
                %                     if endTimes(end)~=selectionEnd
                %                         endTimes=[endTimes selectionEnd];
                %                     end

            elseif app.calculationSettings.useMask==1
                maskChannelNumber=app.calculationSettings.maskChannelNumber;

                maskTime=app.channelXValues{maskChannelNumber};
                maskValues=app.channelYValues{maskChannelNumber};

                excerpt=maskTime>=selectionStart & maskTime<=selectionEnd;
                maskValues=maskValues(excerpt);
                maskTime=maskTime(excerpt);

                maskPadded=[0 maskValues(:)' 0];


                starts=strfind(maskPadded,[0 1]);
                ends=strfind(maskPadded,[1 0])-1;

                startTimes=maskTime(starts);
                endTimes=maskTime(ends);

            else
                startTimes=selectionStart;
                endTimes=selectionEnd;
            end

            app.calculationResults.numberOfWindows=numel(startTimes);
            app.calculationResults.windowStartTimes=startTimes;
            app.calculationResults.windowEndTimes=endTimes;




            % separate 1/cycleDuration plot
            if app.calculationSettings.cycleDuration.showSeparate1overCycleDurationPlot==1
                foFig=figure('Units','normalized','OuterPosition',[0.25 0.1 0.5 0.8],'Visible','off','Theme','light','NumberTitle','off','Name','cycle frequencies plot');
                %tl=tiledlayout(foFig,nChannels+1,1,'Padding','tight','TileSpacing','compact');
                tl=tiledlayout(foFig,'vertical','Padding','tight','TileSpacing','compact');
                foAxs=gobjects(0);
            end




            if ~isdeployed && app.doProfiling
                %#exclude profile
                profile on;
            end


            for channelNr=1:nChannels
                % if ~isvalid(progDialog) || getappdata(progDialog,'canceling')
                %     break;
                % end

                if ~app.batchMode && (progDialog.CancelRequested || ~isvalid(progDialog))
                    break;
                end










                %% cycle detection
                excerpt=app.channelXValues{channelNr}>=selectionStart & app.channelXValues{channelNr}<=selectionEnd;
                currYDataExcerpt=app.channelYValues{channelNr}(excerpt);
                currXDataExcerpt=app.channelXValues{channelNr}(excerpt);
                currFs=app.channelSampleRates(channelNr);

                % if currFs>20000
                %     [currYDataExcerpt,currXDataExcerpt]=resample(currYDataExcerpt,currXDataExcerpt,20000);
                %     currFs=20000;
                % end

                % % calculate sampEn based on FD for the whole signal (GAW and EGG)
                % if app.calculationCalledAsPreview~=1 && ismember(app.channelSource{channelNr},{'GAW','EGG'})
                %     minfo=app.calculationSettings.fo.Min;
                %     maxfo=app.calculationSettings.fo.Max;
                %     sampenSex=app.calculationSettings.SampleEntropyFDfixedNumberOfCycles.sex;
                %     try
                %         [sampen_y,sampen_x]=FromSelamtzisCyclebasedSampEn.sampEnFDaLaSelamtzis(currYData,currFs,[minfo maxfo],sampenSex,app.calculationSettings.SampleEntropyFDfixedNumberOfCycles.showInternalCycleDetection,app.calculationSettings.SampleEntropyFDfixedNumberOfCycles.doNormalizeSampEn);
                %         sampen_x=sampen_x+startTimes(1); % the algorith always thinks starting at t=0;
                %     catch ME
                %         sampen_y=nan(1,numel(startTimes));
                %         sampen_x=startTimes;
                %         disp('Error: calculating fixed cycle size SampEn failed');
                %
                %         disp(ME.getReport());
                %     end
                % end

                

                %% pitch pre calculation
                sourceTypesAllowedForPitchCalculation={'GAW','EGG','Audio'};

                if app.calculationCalledAsPreview~=1 && ismember(app.channelSource{channelNr},sourceTypesAllowedForPitchCalculation) && (app.calculationSettings.pitch.doCalculate || app.calculationSettings.harmonics.doCalculate || app.calculationSettings.subharmonics.doCalculate)

                    pitchMethod={'NCF','PEF','CEP','LHS','SRH','SWIPEprime','SHR'};
                    pitchesY=cell(size(pitchMethod));
                    pitchesX=cell(size(pitchMethod));
                    foSearchRange=[app.calculationSettings.fo.Min app.calculationSettings.fo.Max];
                    windowLengthTime=app.calculationSettings.pitch.timeWindow;
                    windowOverlapTime=app.calculationSettings.pitch.timeWindowOverlap;
                    constDataY= parallel.pool.Constant(currYDataExcerpt);
                    constDataX= parallel.pool.Constant(currXDataExcerpt);
                    tmpStart=currXDataExcerpt(1);
                    parfor pitchMethodNr=1:numel(pitchMethod)
                        % no windowing needed since pitch function applies a
                        % window by itself
                        % SRH uses periodic hann, NCF needs no windowing
                        % and all other use periodic hamming window
                        try
                            if ismember(pitchMethod{pitchMethodNr},{'NCF','PEF','CEP','LHS','SRH'})
                                [pitchesY{pitchMethodNr},loc]=pitch(constDataY.Value(:),currFs,'Method',pitchMethod{pitchMethodNr},"Range",foSearchRange,'WindowLength',round(windowLengthTime*currFs),'OverlapLength',round(windowOverlapTime*currFs));
                                pitchesX{pitchMethodNr}=double(constDataX.Value(loc));
                            elseif strcmpi(pitchMethod{pitchMethodNr},'SWIPEprime')
                                [pitchesY{pitchMethodNr},tempPitchT] = PitchTracker.SWIPEP.swipep(constDataY.Value(:),currFs,foSearchRange,windowLengthTime-windowOverlapTime,[],[],windowOverlapTime/windowLengthTime);
                                pitchesX{pitchMethodNr}=tempPitchT+tmpStart;
                            elseif strcmpi(pitchMethod{pitchMethodNr},'SHR')
                                [tempPitchT,pitchesY{pitchMethodNr}] = SHRP.shrp(constDataY.Value(:),currFs,foSearchRange,windowLengthTime*1000,windowOverlapTime*1000,min(currFs/2,foSearchRange(2)*5)); % according to Herbst we should use 5times the highest fo. https://doi.org/10.1016/j.jvoice.2019.11.005 
                                pitchesX{pitchMethodNr}=tempPitchT/1000+tmpStart;
                            end
                        catch ME
                            disp(['Error during pitch calculation using ' pitchMethod{pitchMethodNr} ' method:']);
                            disp(ME.getReport());
                            pitchesY{pitchMethodNr}=[];
                            pitchesX{pitchMethodNr}=[];
                        end
                    end

                end

                %% spectrogram pre calculation
                if app.calculationCalledAsPreview~=1 && ismember(app.channelSource{channelNr},sourceTypesAllowedForPitchCalculation) && (app.calculationSettings.pitch.doCalculate || app.calculationSettings.harmonics.doCalculate || app.calculationSettings.subharmonics.doCalculate)
                    
                    spectrogramWindowLength=round(app.calculationSettings.pitch.timeWindow*currFs);
                    spectrogramWindow=app.windowGenerator(app.calculationSettings.generalFFT.windowType,spectrogramWindowLength);

                    spectrogramWindowOverlap=round(windowOverlapTime*currFs);
                    
                    requestedNFFT=round(currFs/app.calculationSettings.generalFFT.minimumFreqRes);

                    % we do not want to take a shorter nfft than the window
                    % length
                    requestedNFFT=max(requestedNFFT,spectrogramWindowLength);
                    
                    [sSpectrogram,fSpectrogram,tSpectrogram]=spectrogram(currYDataExcerpt,spectrogramWindow,spectrogramWindowOverlap,requestedNFFT,currFs);
    
                    % adjust relative to absolute time
                    tSpectrogram=tSpectrogram+currXDataExcerpt(1);

                    % just use spectrum magnitude and convert to dB
                    sSpectrogram=20*log10(abs(sSpectrogram)+eps);

                    %%% now we precalculate the spectral values at the
                    %%% pitch positions and their harmonics

                    specInterpMethod=app.calculationSettings.generalFFT.interpolationMethod;

                    pitchAndHarmonicsSpectrogramAmplitudes=cell(1,numel(pitchMethod));
                    pitchAndSubharmonicsSpectrogramAmplitudes=cell(1,numel(pitchMethod));
                    for pitchMethodNr=1:numel(pitchMethod)

                        currPitchY=pitchesY{pitchMethodNr};
                        currPitchX=pitchesX{pitchMethodNr};

                        % get pitch values at spectrogram time values
                        currPitchYInterp=interp1(currPitchX,currPitchY,tSpectrogram,"linear",'extrap');

                        % force row vector
                        currPitchYInterp=currPitchYInterp(:).';

                        % generate matrix with harmonics
                        pitchAndHarmonics=currPitchYInterp.*(1:max(4,app.calculationSettings.harmonics.maxOrder)).';

                        % generate matrix with subharmonics
                        pitchAndSubharmonics=currPitchYInterp./(1:max(4,app.calculationSettings.subharmonics.maxOrder)).';

                        % just keep those harmonics rows if all of the
                        % theoretical harmonics' frequency is below the
                        % highest spectrogram frequency (which should be nyquist)
                        pitchAndHarmonics(any(pitchAndHarmonics>max(fSpectrogram),2),:)=[];

                        
                        pitchAndHarmonicsSpectrogramAmplitudes{pitchMethodNr}=nan(size(pitchAndHarmonics));
                        pitchAndSubharmonicsSpectrogramAmplitudes{pitchMethodNr}=nan(size(pitchAndSubharmonics));

                        for idx=1:size(pitchAndHarmonics,2)
                            pitchAndHarmonicsSpectrogramAmplitudes{pitchMethodNr}(:,idx)=interp1(fSpectrogram,sSpectrogram(:,idx),pitchAndHarmonics(:,idx),specInterpMethod);
                            pitchAndSubharmonicsSpectrogramAmplitudes{pitchMethodNr}(:,idx)=interp1(fSpectrogram,sSpectrogram(:,idx),pitchAndSubharmonics(:,idx),specInterpMethod);
                        end







                    end




                end

                %% CPP(s) precalculation

                if app.calculationCalledAsPreview~=1 && app.calculationSettings.CPPv3.doCalculate

                    
                    % CPPs Settings from UI
                    fs_cppv3 = app.calculationSettings.CPPv3.resamplingFrequency;
                    usePreemph_cppv3 = app.calculationSettings.CPPv3.usePreemphasis;
                    winLen_cppv3 = app.calculationSettings.CPPv3.windowLength;
                    hopLen_cppv3 = app.calculationSettings.CPPv3.windowHopLength;
                    timeSmooth_cppv3 = app.calculationSettings.CPPv3.TimeSmoothingWindowLength;
                    quefrSmooth_cppv3 = app.calculationSettings.CPPv3.QuefrencySmoothingWindowLength;
                    quefMin_cppv3 = app.calculationSettings.CPPv3.lowerQuefrencyLimit;  
                    quefMax_cppv3 = app.calculationSettings.CPPv3.upperQuefrencyLimit;
                    fitType_cppv3 = app.calculationSettings.CPPv3.fitMethod;
                    robustType_cppv3 = app.calculationSettings.CPPv3.robustMethod;
                    lowerFo_cppv3=app.calculationSettings.CPPv3.lowerFo;
                    upperFo_cppv3=app.calculationSettings.CPPv3.upperFo;
                    winType_cppv3 = app.calculationSettings.CPPv3.windowType;
                    
                    
                    try
                        [cppsv3, cppsv3times, ~, ~, ~, cppv3, ~] = compute_CPPs(currYDataExcerpt, currFs, fs_cppv3, usePreemph_cppv3, winType_cppv3,winLen_cppv3, hopLen_cppv3, timeSmooth_cppv3, quefrSmooth_cppv3, lowerFo_cppv3, upperFo_cppv3, fitType_cppv3, robustType_cppv3,quefMin_cppv3,quefMax_cppv3,false);
                        cppsv3times=cppsv3times+currXDataExcerpt(1);
                    catch ME
                        disp('Error during CPP(s) v3 calculation:');
                        disp(ME.getReport());
                        cppsv3=[];
                        cppsv3times=[];
                        cppv3=[];
                    end
                    

                end

                %% acoustic loudness, sharpness, fluctuation and roughness

                sourceTypesAllowedForPsychoacousticCalculation={'Pressure','Audio'};

                if app.calculationCalledAsPreview~=1 && ismember(app.channelSource{channelNr},sourceTypesAllowedForPsychoacousticCalculation) && currFs>=8000 && (app.calculationSettings.acousticLoudness.doCalculate || app.calculationSettings.acousticSharpness.doCalculate || app.calculationSettings.acousticRoughness.doCalculate || app.calculationSettings.acousticFluctuation.doCalculate) 

                    if app.calculationSettings.acousticLoudness.doCalculate
                        % using high time resolution -> 0.5ms steps

                        acousticLoudnessDiffuseZwickerTimeVarying = acousticLoudness(currYDataExcerpt,currFs,1,'TimeVarying',true,'TimeResolution','high','PressureReference',20e-6,'SoundField','diffuse','Method','ISO 532-1');
                        acousticLoudnessFreeZwickerTimeVarying = acousticLoudness(currYDataExcerpt,currFs,1,'TimeVarying',true,'TimeResolution','high','PressureReference',20e-6,'SoundField','free','Method','ISO 532-1');

                        acousticLoudnessDiffuseZwickerTimeStationary = acousticLoudness(currYDataExcerpt,currFs,1,'TimeVarying',false,'TimeResolution','high','PressureReference',20e-6,'SoundField','diffuse','Method','ISO 532-1');
                        acousticLoudnessFreeZwickerTimeStationary = acousticLoudness(currYDataExcerpt,currFs,1,'TimeVarying',false,'TimeResolution','high','PressureReference',20e-6,'SoundField','free','Method','ISO 532-1');

                        % time vector for time varying
                        acousticLoudnessTime=(0:numel(acousticLoudnessDiffuseZwickerTimeVarying)-1)*0.0005+currXDataExcerpt(1);
                    end

                    if app.calculationSettings.acousticSharpness.doCalculate
                        % this seems to use always the 2ms time vector (equal to "standard" resolution in acousticLoudness)

                        % time varying
                        acousticSharpnessDiffuseDINTimeVarying = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','diffuse','Weighting','DIN 45692');
                        acousticSharpnessFreeDINTimeVarying    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','free','Weighting','DIN 45692');

                        acousticSharpnessDiffuseAuresTimeVarying = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','diffuse','Weighting','Aures');
                        acousticSharpnessFreeAuresTimeVarying    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','free','Weighting','Aures');

                        acousticSharpnessDiffuseBismarckTimeVarying = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','diffuse','Weighting','von Bismarck');
                        acousticSharpnessFreeBismarckTimeVarying    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',true,'PressureReference',20e-6,'SoundField','free','Weighting','von Bismarck');

                        % time stationary
                        acousticSharpnessDiffuseDINTimeStationary = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','diffuse','Weighting','DIN 45692');
                        acousticSharpnessFreeDINTimeStationary    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','free','Weighting','DIN 45692');

                        acousticSharpnessDiffuseAuresTimeStationary = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','diffuse','Weighting','Aures');
                        acousticSharpnessFreeAuresTimeStationary    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','free','Weighting','Aures');

                        acousticSharpnessDiffuseBismarckTimeStationary = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','diffuse','Weighting','von Bismarck');
                        acousticSharpnessFreeBismarckTimeStationary    = acousticSharpness(currYDataExcerpt,currFs,1, 'TimeVarying',false,'PressureReference',20e-6,'SoundField','free','Weighting','von Bismarck');

                        % time vector for time varying
                        acousticSharpnessTime=(0:numel(acousticSharpnessDiffuseDINTimeVarying)-1)*0.002+currXDataExcerpt(1);

                    end

                    if app.calculationSettings.acousticFluctuation.doCalculate

                        if numel(currYDataExcerpt)>=ceil(0.1*currFs) % acousticFluctuation needs at least 0.1 seconds data
                            % this seems to use always the 2ms time vector (equal to "standard" resolution in acousticLoudness)
                            acousticFluctuationDiffuse = acousticFluctuation(currYDataExcerpt, currFs, 1,"PressureReference",20e-6,"SoundField","diffuse");
                            acousticFluctuationFree = acousticFluctuation(currYDataExcerpt, currFs, 1,"PressureReference",20e-6,"SoundField","free");
    
                            % time vector for time varying
                            acousticFluctuationTime=(0:numel(acousticFluctuationDiffuse)-1)*0.002+currXDataExcerpt(1);
                        else
                            warning('acoustic fluctuation needs at least 0.1s data length, skipping  it');
                            app.calculationSettings.acousticFluctuation.doCalculate=0;
                        end
                    end

                    if app.calculationSettings.acousticRoughness.doCalculate
                        % this seems to use always the 0.5ms time vector (equal to "high" resolution in acousticLoudness)

                        acousticRoughnessDiffuse = acousticRoughness(currYDataExcerpt,currFs,1,'PressureReference',20e-6,'SoundField','diffuse');
                        acousticRoughnessFree = acousticRoughness(currYDataExcerpt,currFs,1,'PressureReference',20e-6,'SoundField','free');

                        % time vector for time varying
                        acousticRoughnessTime=(0:numel(acousticRoughnessDiffuse)-1)*0.0005+currXDataExcerpt(1);
                    end
                end

              
                




                %%

                if app.calculationSettings.fo.useAbsoluteCyclePeakProminence==1
                    prominence=app.calculationSettings.fo.absoluteCyclePeakProminence;
                else
                    prominence=app.calculationSettings.fo.relativeCyclePeakProminence*range(currYDataExcerpt);
                end

                if isfield(app.calculationSettings.pitch,'useTimeDependentUpperMax') && app.calculationSettings.pitch.useTimeDependentUpperMax

                    tempT=currXDataExcerpt-currXDataExcerpt(1);
                    if ismember(app.calculationSettings.pitch.timeDependentUpperMaxAlgorithm,{'NCF','PEF','CEP','LHS','SRH'})
                        [fmaxPredicted,loc]=pitch(currYDataExcerpt(:),currFs,...
                            'Method',app.calculationSettings.pitch.timeDependentUpperMaxAlgorithm,...
                            'Range',[min(app.calculationSettings.fo.Min,currFs/2-1) min(app.calculationSettings.fo.Max,floor(currFs/2))],...
                            'WindowLength',round(app.calculationSettings.pitch.timeWindow*currFs),...
                            'OverlapLength',round(app.calculationSettings.pitch.timeWindowOverlap*currFs),...
                            'MedianFilterLength',5);
                    elseif strcmpi(app.calculationSettings.pitch.timeDependentUpperMaxAlgorithm,'SWIPE''')
                        [fmaxPredicted,tPitch] = PitchTracker.SWIPEP.swipep(currYDataExcerpt(:),currFs,...
                                                [min(app.calculationSettings.fo.Min,currFs/fs-1) min(app.calculationSettings.fo.Max,floor(currFs/2))],...
                                                app.calculationSettings.pitch.timeWindow-app.calculationSettings.pitch.timeWindowOverlap,[],[],...
                                                app.calculationSettings.pitch.timeWindowOverlap/app.calculationSettings.pitch.timeWindow);
                        fmaxPredicted=movmedian(fmaxPredicted,5);
                        loc=round(tPitch*currFs); % from time to samples
                    end

                    fmaxPredicted(fmaxPredicted<app.calculationSettings.fo.Min)=app.calculationSettings.fo.Min;
                    fmaxPredicted(fmaxPredicted>min(app.calculationSettings.fo.Max,floor(currFs/2)))=min(app.calculationSettings.fo.Max,floor(currFs/2));


                    % center loc values around the windows center
                    loc=loc-round(0.5*app.calculationSettings.pitch.timeWindow*currFs);



                    fmaxPredicted=interp1(loc,fmaxPredicted,1:numel(currYDataExcerpt),'makima',NaN);

                    whereIsNaN=isnan(fmaxPredicted);
                    if any(whereIsNaN)
                        fmaxPredicted(whereIsNaN)=interp1(find(~whereIsNaN),fmaxPredicted(~whereIsNaN),find(whereIsNaN),'nearest','extrap');
                    end

                    fmaxPredicted=fmaxPredicted*app.calculationSettings.pitch.timeDependentUpperMaxMarginFactor;




                    % to col vector
                    fmaxPredicted=fmaxPredicted(:);




                    %%% this is version but has problem with using the
                    %%% smaller peaks instead of bigger ones
                    % [~,locs]=findpeaks(currYDataExcerpt,'MinPeakDistance',round(currFs/max(fmaxPredicted)),'MinPeakProminence',prominence);
                    % while any(1./diff(tempT(locs))>max(fmaxPredicted(locs(1:end-1)),fmaxPredicted(locs(2:end))))
                    %
                    %     idx=find((1./diff(tempT(locs)))>max(fmaxPredicted(locs(1:end-1)),fmaxPredicted(locs(2:end))),1,"first");
                    %
                    %     locs(idx+1)=[];
                    % end
                    % where=locs;

                    %%% this is similar to the first, but faster
                    % [~,locs]=findpeaks(currYDataExcerpt,'MinPeakDistance',round(currFs/max(fmaxPredicted)),'MinPeakProminence',prominence);
                    % if length(locs) >= 2
                    %     fmaxPredLocs = fmaxPredicted(locs);
                    %
                    %     while true
                    %         dists = diff(tempT(locs));
                    %         if length(dists) < 1, break; end
                    %
                    %         maxFreq = max([fmaxPredLocs(1:end-1), fmaxPredLocs(2:end)], [], 2);
                    %         tooSmall = (1 ./ dists) > maxFreq;
                    %
                    %         if ~any(tooSmall)
                    %             break;
                    %         end
                    %
                    %         badIdx = find(tooSmall, 1) + 1;
                    %         locs(badIdx) = [];
                    %         fmaxPredLocs(badIdx) = [];
                    %
                    %         if length(locs) < 2
                    %             break;
                    %         end
                    %     end
                    % end
                    %
                    % where = locs;
                    minDistSamples = round(currFs ./ fmaxPredicted);

                    N = length(currYDataExcerpt);
                    locs = nan(1,round(numel(currYDataExcerpt)/min(minDistSamples)));

                    startIdx = 1;
                    %frameLen = round(app.calculationSettings.pitch.timeWindow*currFs);

                    frameLen = round(app.calculationSettings.windowLength*currFs);


                    locCount=0;
                    previousFrame=[];
                    startingAtPeak=0;
                    while startIdx <= N
                        endIdx = min(N, startIdx + frameLen);

                        frameMinDist = min(minDistSamples(startIdx:endIdx));

                        frame = currYDataExcerpt(startIdx:endIdx);

                        if numel(frame)>frameMinDist+1 % at the end there can be some small remaining areas
                            if ~isempty(previousFrame) && startingAtPeak==1
                                [~, frameLocs] = findpeaks([0; 1000000; 0;frame(3:end)], 'MinPeakDistance', frameMinDist,'MinPeakProminence',prominence);
                                if ~isempty(frameLocs)
                                    frameLocs=frameLocs-1;
                                    frameLocs(1)=[];
                                end
                            else
                                [~, frameLocs] = findpeaks(frame, 'MinPeakDistance', frameMinDist,'MinPeakProminence',prominence);
                            end
                        else
                            frameLocs=[];
                        end

                        if ~isempty(frameLocs)
                            nextPeak_rel = frameLocs(end);
                            nextPeak = startIdx + nextPeak_rel - 1;

                            locCount = locCount + numel(frameLocs);
                            locs(locCount-numel(frameLocs)+1:locCount) = frameLocs+startIdx-1;  % Mit Counter!

                            nextStart = nextPeak;
                            startingAtPeak=1;


                        else
                            nextStart = startIdx + frameLen - frameMinDist;
                            startingAtPeak=0;
                        end

                        startIdx = max(1, nextStart);

                        previousFrame=frame;
                    end

                    locs(isnan(locs))=[];

                    locs=unique(locs);
                    where=locs;
                else
                    where=islocalmax(currYDataExcerpt,'MinSeparation',round(app.calculationSettings.cycleDuration.Min*currFs),'MinProminence',prominence);
                end
                cycleBorderVals=currXDataExcerpt(where);
                cycleDurations=diff(cycleBorderVals);

                if app.calculationSettings.useMask
                    notInsideMaskRegions=~any(cycleBorderVals(:)>=startTimes(:)' & cycleBorderVals(:)<=endTimes(:)',2);
                end

                app.calculationResults.channelResults(channelNr).cycleBorderVals=cycleBorderVals;
                app.calculationResults.channelResults(channelNr).cycleBorderVals_Unit="s";

                app.calculationResults.channelResults(channelNr).cycleDurations=cycleDurations;
                app.calculationResults.channelResults(channelNr).cycleDurations_Unit="s";

                if app.HidecyclesbordersButton.Value==1
                    vis='off';
                else
                    vis='on';
                end
                if ~isempty(cycleBorderVals) && ~app.calculationSettings.useMask || app.calculationSettings.useMask && ~isempty(cycleBorderVals(~notInsideMaskRegions))
                    if app.calculationSettings.useMask
                        app.cycleBorderHandles(channelNr)=app.addManyXlinesAsSingleObj(channelNr,cycleBorderVals(~notInsideMaskRegions),vis);
                    else
                        app.cycleBorderHandles(channelNr)=app.addManyXlinesAsSingleObj(channelNr,cycleBorderVals,vis);
                    end
                    if ishandle(app.cycleBorderHandles(channelNr))
                        uistack(app.cycleBorderHandles(channelNr),'bottom');
                    end
                    uistack(app.timePlotHandles(channelNr),'top');
                end

                % separate 1/cycleDuration plot
                if app.calculationSettings.cycleDuration.showSeparate1overCycleDurationPlot==1 && ismember(app.channelSource(channelNr),{'GAW' 'EGG' 'Audio'})
                    %foAxs(channelNr)=nexttile(tl,channelNr);
                    foAxs(end+1)=nexttile(tl);

                    cycleBorderValsWithNaN=cycleBorderVals;
                    if app.calculationSettings.useMask
                        cycleBorderValsWithNaN(notInsideMaskRegions)=NaN;
                    end

                    semilogy(foAxs(end),movmean(cycleBorderValsWithNaN,2,'Endpoints','discard'),1./cycleDurations,'DisplayName','Cycle frequency');

                    if app.calculationSettings.pitch.useTimeDependentUpperMax
                        hold on;
                        semilogy(foAxs(end),currXDataExcerpt(:),fmaxPredicted(:),'r','DisplayName','Predicted fo max');
                        hold off;
                    end


                    title(foAxs(end),app.channelNames{channelNr},'Interpreter','none');

                    lastAx=nexttile(tl,sum(ismember(app.channelSource,{'GAW' 'EGG' 'Audio'}))+1);
                    semilogy(lastAx,movmean(cycleBorderValsWithNaN,2,'Endpoints','discard'),1./cycleDurations,'DisplayName',sprintf('channel %i',channelNr));
                    hold(lastAx,'on');

                    legend(foAxs(end),'Location','northwest');

                end








                nTotalCycles = numel(cycleBorderVals) - 1;
                [allCyclesYDataRange, allCyclesYDataEnergy,allCyclesOQs,allCyclesClQs,allCyclesOpQs,allCyclesGGI,allCyclesPlateauQuotient,allCyclesYDataMax,allCyclesYDataMin,allCyclesYDataDerivateMin] = deal(nan(1, nTotalCycles));

                % for multiple values per cycle
                FDnumberOfHarmonics=app.calculationSettings.SampleEntropyFD.numberOfHarmonics;
                [fourierDescriptors] = deal(nan(FDnumberOfHarmonics, nTotalCycles));

                allOQBorders=[];
                allClQBorders=[];

                %% precompute values for all cycles
                for cycleNr = 1:nTotalCycles
                    currCycleExcerpt=currXDataExcerpt >= cycleBorderVals(cycleNr) & ...
                        currXDataExcerpt <= cycleBorderVals(cycleNr + 1);
                    currCycleYData = currYDataExcerpt(currCycleExcerpt);
                    currCycleXData = currXDataExcerpt(currCycleExcerpt);

                    %% required for some many parameters later
                    [cycleMax,cycleMaxIdx]=max(currCycleYData);
                    [cycleMin,cycleMinIdx]=min(currCycleYData);
                    cycleRange=cycleMax-cycleMin;
                    allCyclesYDataRange(cycleNr) = cycleRange;
                    allCyclesYDataEnergy(cycleNr) = sum(currCycleYData .^ 2);
                    allCyclesGGI(cycleNr)=cycleMin/cycleMax;
                    allCyclesPlateauQuotient(cycleNr)=sum(currCycleYData>=cycleMin+app.calculationSettings.plateauQuotientThreshold*cycleRange);
                    allCyclesYDataMax(cycleNr) = cycleMax;
                    allCyclesYDataMin(cycleNr) = cycleMin;
                    allCyclesYDataDerivateMin(cycleNr) = min(gradient(currCycleYData))*currFs;

                    %% here calculate the basic open, closed, closing and opening quotients
                    if ismember(app.channelSource{channelNr},{'GAW','EGG'})
                        total=numel(currCycleYData);

                        % !!!remember!!! the cycles are (at the moment) max based because min
                        % based values are difficult due to noise
                        if strcmpi(app.channelSource{channelNr},'GAW')
                            zeroThreshold=app.calculationSettings.GAWopenThresholdPercentage*cycleMax;

                            closedDuration=sum(currCycleYData<=zeroThreshold);
                            openDuration=total-closedDuration;
                            openingDuration=sum(currCycleYData(cycleMinIdx:end)>zeroThreshold);
                            closingDuration=sum(currCycleYData(1:cycleMinIdx)>zeroThreshold);

                            closedIdx=find(currCycleYData<=zeroThreshold);
                            if numel(closedIdx)>=2
                                allOQBorders=[allOQBorders  currCycleXData(closedIdx(1)) NaN currCycleXData(closedIdx(end))  ];
                                allClQBorders=[allClQBorders currCycleXData(1) currCycleXData(closedIdx(1)) NaN];
                            end

                        elseif strcmpi(app.channelSource{channelNr},'EGG')
                            % howard for the moment % closed according DEGG,
                            % open according 3/7
                            cycleGradient=gradient(currCycleYData);
                            [~,maxDEGGidx]=max(cycleGradient);
                            closingDuration=maxDEGGidx-cycleMinIdx;

                            openingDuration=find(cycleMin+3/7*(currCycleYData(1)-cycleMin)>=currCycleYData(1:cycleMinIdx),1,"first");

                            openDuration=closingDuration+(cycleMinIdx-openingDuration);
                            closedDuration=total-openDuration;

                            allOQBorders=[allOQBorders currCycleXData(openingDuration) currCycleXData(maxDEGGidx) NaN];
                            allClQBorders=[allClQBorders currCycleXData(cycleMinIdx) currCycleXData(maxDEGGidx) NaN];

                        end
                        allCyclesOQs(cycleNr)=openDuration/total;
                        allCyclesClQs(cycleNr)=closingDuration/total;
                        allCyclesOpQs(cycleNr)=openingDuration/total;
                    end

                    %% calculate FD based SampEn for fixed number of cycles

                    if ismember(app.channelSource{channelNr},{'GAW','EGG'}) && app.calculationSettings.SampleEntropyFD.doCalculate % only for gaw and egg, the cycle fft is so far only needed for FD based SampEn
                        cycleFFT=fft(currCycleYData,numel(currCycleYData));

                        % each column is one cycle
                        fourierDescriptors(:,cycleNr)=cycleFFT(2:2+FDnumberOfHarmonics-1); % magnitudes



                    end
                end

                % only for gaw and egg, the cycle fft is so far only needed for FD based SampEn
                if ismember(app.channelSource{channelNr},{'GAW','EGG'}) && app.calculationSettings.SampleEntropyFD.doCalculate

                    fourierDescriptorsMagnitude=abs(fourierDescriptors);
                    fourierDescriptorsPhase=angle(fourierDescriptors);

                    if app.calculationSettings.SampleEntropyFD.useRelativeFD
                        fourierDescriptorsMagnitude=20*log10(fourierDescriptorsMagnitude(2:end,:)./fourierDescriptorsMagnitude(1,:));
                        fourierDescriptorsPhase=fourierDescriptorsPhase(2:end,:)-fourierDescriptorsPhase(1,:);
                        %currentFDs=currentFDs(2:end,:)-currentFDs(1,:); % now we have one less FD
                    else
                        fourierDescriptorsMagnitude=20*log10(fourierDescriptorsMagnitude);
                    end
                end

                if strcmpi(app.channelSource{channelNr},'GAW')
                    firstNaN=find(isnan(allOQBorders),1,'first');
                    if firstNaN<=2
                        allOQBorders(1:firstNaN)=[]; % should only be relevant for max based GAW, since there the open phase is cut by cycle borders
                    end

                    lastNaN=find(isnan(allOQBorders),1,'last');
                    if lastNaN>=numel(allOQBorders)-1
                        allOQBorders(lastNaN+1:end)=[]; % should only be relevant for max based GAW, since there the open phase is cut by cycle borders
                    end
                end

                if ismember(app.channelSource{channelNr},{'GAW','EGG'}) && numel(allOQBorders)>=3
                    allOQBorders=reshape(allOQBorders,3,[])';
                    allOQBorders(:,3)=[]; % remove NaN values

                    allClQBorders=reshape(allClQBorders,3,[])';
                    allClQBorders(:,3)=[]; % remove NaN values

                    app.calculationResults.channelResults(channelNr).allOQBorders=allOQBorders;
                    app.calculationResults.channelResults(channelNr).allOQBorders_Unit="s";
                    app.calculationResults.channelResults(channelNr).allClQBorders=allClQBorders;
                    app.calculationResults.channelResults(channelNr).allClQBorders_Unit="s";

                    %if ismember(channelNr,app.availableChannelsTable.Selection)

                    if app.HideOQareasButton.Value==1
                        oqvis='off';
                    else
                        oqvis='on';
                    end
                    if app.ClQareasarehiddenButton.Value==1
                        clqvis='off';
                    else
                        clqvis='on';
                    end

                    %channelNr=find(app.availableChannelsTable.Selection==channelNr,1);
                    app.cycleOQHandle(channelNr)=app.addManyPatchesAsSinglePatch(channelNr,allOQBorders,[0.2 0 0],[],oqvis);
                    app.cycleClQHandle(channelNr)=app.addManyPatchesAsSinglePatch(channelNr,allClQBorders,[0 0.2 0],[],clqvis);

                    uistack(app.cycleOQHandle(channelNr),'bottom');
                    %end
                end

                if ~app.batchMode && app.calculationCalledAsPreview==1
                    progDialog.Value=channelNr/nChannels;
                    progDialog.Message=sprintf('%i of %i channels complete',channelNr,nChannels);

                    continue;
                end

                %% starting from here, those calculation are not part of the preview cycles button calculations

                %% initiate audioFeatureExtractor object
                if ismember(app.channelSource{channelNr},channelTypesAllowedForAudioFeatureExtractor)
                    windowForAudioFeatureExtractor=app.windowGenerator(app.calculationSettings.generalFFT.windowType,round(app.calculationSettings.pitch.timeWindow*currFs));
                    afe = audioFeatureExtractor( ...
                        'SampleRate', currFs, ...
                        'Window', windowForAudioFeatureExtractor, ...
                        'OverlapLength',round(app.calculationSettings.pitch.timeWindowOverlap*currFs), ...
                        'spectralCrest', app.calculationSettings.spectralCrest.doCalculate, ...
                        'spectralFlux', app.calculationSettings.spectralFlux.doCalculate, ...
                        'spectralSpread', app.calculationSettings.spectralSpread.doCalculate, ...
                        'spectralSkewness', app.calculationSettings.spectralSkewness.doCalculate, ...
                        'spectralKurtosis', app.calculationSettings.spectralKurtosis.doCalculate, ...
                        'spectralCentroid', app.calculationSettings.spectralCentroid.doCalculate, ...
                        'spectralEntropy', app.calculationSettings.spectralEntropy.doCalculate, ...
                        'spectralSlope', app.calculationSettings.spectralSlope.doCalculate, ...
                        'spectralDecrease', app.calculationSettings.spectralDecrease.doCalculate, ...
                        'spectralRolloffPoint', app.calculationSettings.spectralRolloffPoint.doCalculate, ...
                        'harmonicRatio', app.calculationSettings.harmonicRatio.doCalculate, ...
                        'zerocrossrate', app.calculationSettings.zeroCrossingRate.doCalculate ...
                        );

                    audioFeatureExtractorInfoStruct = afe.info;
                    audioFeatureExtractorInfoStructFields=fieldnames(audioFeatureExtractorInfoStruct);
                end
                %% FD based Sample Entropy
                if ismember(app.channelSource{channelNr},{'GAW','EGG'}) && app.calculationSettings.SampleEntropyFD.doCalculate

                    if strcmpi(app.calculationSettings.SampleEntropyFD.sex,'male')
                        cyclesPerSet=10;
                    else
                        cyclesPerSet=20;
                    end

                    SampEnFDofEachSet=nan(size(fourierDescriptorsMagnitude,2)-cyclesPerSet+1,1);
                    SampEnFDofEachSetTime=SampEnFDofEachSet;




                    for cycleNr=1:size(fourierDescriptors,2)-cyclesPerSet+1

                        currentFDsMagnitude=fourierDescriptorsMagnitude(:,cycleNr:cycleNr+cyclesPerSet-1);
                        currentFDsPhase=fourierDescriptorsPhase(:,cycleNr:cycleNr+cyclesPerSet-1);



                        if contains(app.calculationSettings.SampleEntropyFD.templateLengthMethod,'log10')
                            templateLength=round(log10(size(currentFDsMagnitude,2)));
                        else
                            templateLength=app.calculationSettings.SampleEntropyFD.templateLengthFixed;
                        end

                        if templateLength>size(currentFDsMagnitude,2)-1
                            templateLength=size(currentFDsMagnitude,2)-1;
                        end
                        if templateLength<1
                            templateLength=1;
                        end




                        FSsampEn=nan(size(currentFDsMagnitude,1),1); % either nHarmonics or nHarmonics-1, depending on the relativeFD setting

                        for FDnr=1:size(currentFDsMagnitude,1)


                            %angleSampEnSinus    =SampEn_fast_omidvarnia(sin(currentFDsPhase(FDnr,:)),templateLength,app.calculationSettings.SampleEntropyFD.distanceSTDthresholdPhase);
                            %angleSampEnCosinus  =SampEn_fast_omidvarnia(cos(currentFDsPhase(FDnr,:)),templateLength,app.calculationSettings.SampleEntropyFD.distanceSTDthresholdPhase);
                            % magnitudeSampEn=SampEn_fast_omidvarnia(currentFDsMagnitude(FDnr,:),templateLength,app.calculationSettings.SampleEntropyFD.distanceSTDthresholdMagnitude);

                            sampEnTmpSet=[0 0 0];
                            fdPhase=currentFDsPhase(FDnr,:);
                            fdMag=currentFDsMagnitude(FDnr,:);
                            phaseThr=app.calculationSettings.SampleEntropyFD.distanceSTDthresholdPhase;
                            magThr=app.calculationSettings.SampleEntropyFD.distanceSTDthresholdMagnitude;

                            parfor subNr=1:3
                                switch subNr
                                    case 1
                                        sampEnTmpSet(subNr)    =calculateSampleEntropy(sin(fdPhase),templateLength,phaseThr);
                                    case 2
                                        sampEnTmpSet(subNr)  =calculateSampleEntropy(cos(fdPhase),templateLength,phaseThr);
                                    case 3
                                        sampEnTmpSet(subNr)     =calculateSampleEntropy(fdMag ,templateLength,magThr);
                                end
                            end
                            angleSampEnSinus=sampEnTmpSet(1);
                            angleSampEnCosinus=sampEnTmpSet(2);
                            magnitudeSampEn=sampEnTmpSet(3);

                            switch app.calculationSettings.SampleEntropyFD.combinationMethod
                                case 'add'
                                    FSsampEn(FDnr)=magnitudeSampEn+angleSampEnSinus+angleSampEnCosinus;
                                case 'min'
                                    FSsampEn(FDnr)=min(magnitudeSampEn,[angleSampEnSinus;angleSampEnCosinus]);
                                case 'max'
                                    FSsampEn(FDnr)=max(magnitudeSampEn,[angleSampEnSinus;angleSampEnCosinus]);
                            end


                        end

                        switch app.calculationSettings.SampleEntropyFD.combinationMethod
                            case 'add'
                                SampEnFDofEachSet(cycleNr) = sum(FSsampEn);
                            case 'min'
                                SampEnFDofEachSet(cycleNr) = min(FSsampEn);
                            case 'max'
                                SampEnFDofEachSet(cycleNr) = max(FSsampEn);
                        end

                        SampEnFDofEachSetTime(cycleNr)=cycleBorderVals(cycleNr+1);

                    end

                end

                %% also calculate dB for each of the channels


                if ~strcmpi(app.channelSource{channelNr},'Raw') && app.calculationSettings.SPL.doCalculate
                    splSpeedMethod={'Slow','Fast'};
                    splWeightingMethod={'A-weighting','C-weighting','Z-weighting'};
                    splReferencePressure={20e-6 1};

                    splY=cell(cellfun(@numel,{splSpeedMethod splWeightingMethod splReferencePressure}));
                    for splSpeedNr=1:numel(splSpeedMethod)
                        for splWeightingNr=1:numel(splWeightingMethod)
                            for splReferenceNr=1:numel(splReferencePressure)
                                splObj=splMeter("SampleRate",app.channelSampleRates(channelNr),"PressureReference",splReferencePressure{splReferenceNr},'TimeWeighting',splSpeedMethod{splSpeedNr},'FrequencyWeighting',splWeightingMethod{splWeightingNr});
                                try
                                    splFull=splObj(app.channelYValues{channelNr});
                                    [splY{splSpeedNr,splWeightingNr,splReferenceNr}]=splFull(excerpt);
                                catch ME
                                    disp('Error during SPL calculation');
                                    disp(ME.getReport());
                                    splY{splSpeedNr,splWeightingNr,splReferenceNr}=[];
                                end
                            end
                        end
                    end

                end

                if app.calculationSettings.GNEv2.doCalculate
                    [~,GNE_Tsanas_Precomputed,GNE_Tsanas_BW_TKEO,GNE_Tsanas_BW_energy,GNE_Tsanas_time]=GNE.Tsanas.GNE(currYDataExcerpt,currFs);
                end
                %% window based calculations

                elementsToInit=app.calculationResults.numberOfWindows;
                initedOnce=0;


               

               

                for windowNr=1:numel(startTimes)
                    currWindowCyclesBorders=cycleBorderVals(cycleBorderVals>=startTimes(windowNr) & cycleBorderVals<=endTimes(windowNr));
                    currWindowCyclesDurations=diff(currWindowCyclesBorders);


                    app.calculationResults.channelResults(channelNr).currWindowStartTime(windowNr)=startTimes(windowNr);
                    app.calculationResults.channelResults(channelNr).currWindowEndTime(windowNr)=endTimes(windowNr);
                    if windowNr==1
                        app.calculationResults.channelResults(channelNr).currWindowStartTime_Unit="s";
                        app.calculationResults.channelResults(channelNr).currWindowEndTime_Unit="s";
                    end

                    app.calculationResults.channelResults(channelNr).currWindowCycleBorders{windowNr}=currWindowCyclesBorders;
                    app.calculationResults.channelResults(channelNr).currWindowCycleDurations{windowNr}=currWindowCyclesDurations;
                    if windowNr==1
                        app.calculationResults.channelResults(channelNr).currWindowCycleBorders_Unit="s";
                        app.calculationResults.channelResults(channelNr).currWindowCycleDurations_Unit="s";
                    end



                    currWindowYData=currYDataExcerpt(currXDataExcerpt >= startTimes(windowNr) & ...
                        currXDataExcerpt <= endTimes(windowNr));
                    currWindowXData=currXDataExcerpt(currXDataExcerpt >= startTimes(windowNr) & ...
                        currXDataExcerpt <= endTimes(windowNr));
                    %currWindowYDataWindowed=hann(numel(currWindowYData),"periodic").*currWindowYData;


                    %% get current cycle values

                    whichCycles=cycleBorderVals(1:end-1)>=startTimes(windowNr) & cycleBorderVals(2:end)<=endTimes(windowNr);

                    currWindowCyclesYDataRange = allCyclesYDataRange(whichCycles);
                    currWindowCyclesYDataEnergy = allCyclesYDataEnergy(whichCycles);
                    currWindowCyclesYDataMax = allCyclesYDataMax(whichCycles);

                    if ismember(app.channelSource{channelNr},{'GAW','EGG'})
                        currWindowCyclesOQValues = allCyclesOQs(whichCycles);
                        currWindowCyclesClQValues = allCyclesClQs(whichCycles);
                        currWindowCyclesOpQValues = allCyclesOpQs(whichCycles);
                    end

                    currWindowCyclesGGI = allCyclesGGI(whichCycles);
                    currWindowCyclesPlateauQuotient = allCyclesPlateauQuotient(whichCycles);
                    currWindowCyclesMinDerivate = allCyclesYDataDerivateMin(whichCycles);

                    % Precompute mean values to avoid redundant calculations
                    meanCurrWindowCyclesYDataRange     = mean(currWindowCyclesYDataRange);
                    meanCurrWindowCyclesDurations      = mean(cycleDurations(whichCycles));
                    meanCurrWindowCyclesYDataEnergy    = mean(currWindowCyclesYDataEnergy);

                    medianCurrWindowCyclesYDataRange     = median(currWindowCyclesYDataRange);
                    medianCurrWindowCyclesDurations      = median(cycleDurations(whichCycles));
                    medianCurrWindowCyclesYDataEnergy    = median(currWindowCyclesYDataEnergy);

                    % assign window means of already precomputed cycle
                    % parameters

                    app.calculationResults.channelResults(channelNr).CycleYDataRange_mean(windowNr)=meanCurrWindowCyclesYDataRange;
                    app.calculationResults.channelResults(channelNr).CycleDurations_mean(windowNr)=meanCurrWindowCyclesDurations;
                    app.calculationResults.channelResults(channelNr).CycleYDataEnergy_mean(windowNr)=meanCurrWindowCyclesYDataEnergy;
                    if windowNr==1
                        app.calculationResults.channelResults(channelNr).CycleYDataRange_mean_Unit="channelUnit";
                        app.calculationResults.channelResults(channelNr).CycleDurations_mean_Unit="s";
                        app.calculationResults.channelResults(channelNr).CycleYDataEnergy_mean_Unit="channelUnit^2";
                    end

                    app.calculationResults.channelResults(channelNr).CycleYDataRange_median(windowNr)=medianCurrWindowCyclesYDataRange;
                    app.calculationResults.channelResults(channelNr).CycleDurations_median(windowNr)=medianCurrWindowCyclesDurations;
                    app.calculationResults.channelResults(channelNr).CycleYDataEnergy_median(windowNr)=meanCurrWindowCyclesYDataEnergy;
                    if windowNr==1
                        app.calculationResults.channelResults(channelNr).CycleYDataRange_median_Unit="channelUnit";
                        app.calculationResults.channelResults(channelNr).CycleDurations_median_Unit="s";
                        app.calculationResults.channelResults(channelNr).CycleYDataEnergy_median_Unit="channelUnit^2";
                    end

                    %% Quotient values
                    if ismember(app.channelSource{channelNr},{'GAW','EGG'})
                        app.calculationResults.channelResults(channelNr).OpenQuotientOQ_mean(windowNr)=mean(currWindowCyclesOQValues);
                        app.calculationResults.channelResults(channelNr).OpenQuotientOQ_median(windowNr)=median(currWindowCyclesOQValues);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).OpenQuotientOQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).OpenQuotientOQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).ClosingQuotientClQ_mean(windowNr)=mean(currWindowCyclesClQValues);
                        app.calculationResults.channelResults(channelNr).ClosingQuotientClQ_median(windowNr)=median(currWindowCyclesClQValues);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).ClosingQuotientClQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).ClosingQuotientClQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).OpeningQuotientOpQ_mean(windowNr)=mean(currWindowCyclesOpQValues);
                        app.calculationResults.channelResults(channelNr).OpeningQuotientOpQ_median(windowNr)=median(currWindowCyclesOpQValues);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).OpeningQuotientOpQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).OpeningQuotientOpQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).SpeedQuotientSQ_mean(windowNr)=mean(currWindowCyclesOpQValues./currWindowCyclesClQValues);
                        app.calculationResults.channelResults(channelNr).SpeedQuotientSQ_median(windowNr)=median(currWindowCyclesOpQValues./currWindowCyclesClQValues);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).SpeedQuotientSQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).SpeedQuotientSQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).SpeedIndexSI_mean(windowNr)=mean((currWindowCyclesOpQValues-currWindowCyclesClQValues)./(currWindowCyclesOpQValues+currWindowCyclesClQValues));
                        app.calculationResults.channelResults(channelNr).SpeedIndexSI_median(windowNr)=median((currWindowCyclesOpQValues-currWindowCyclesClQValues)./(currWindowCyclesOpQValues+currWindowCyclesClQValues));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).SpeedIndexSI_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).SpeedIndexSI_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).RateQuotientRQ_mean(windowNr)=mean((1-currWindowCyclesOQValues+currWindowCyclesOpQValues)./currWindowCyclesClQValues);
                        app.calculationResults.channelResults(channelNr).RateQuotientRQ_median(windowNr)=median((1-currWindowCyclesOQValues+currWindowCyclesOpQValues)./currWindowCyclesClQValues);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).RateQuotientRQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).RateQuotientRQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).AsymmetryQuotientAQ_mean(windowNr)=mean(currWindowCyclesOpQValues./(currWindowCyclesClQValues+currWindowCyclesOpQValues));
                        app.calculationResults.channelResults(channelNr).AsymmetryQuotientAQ_median(windowNr)=median(currWindowCyclesOpQValues./(currWindowCyclesClQValues+currWindowCyclesOpQValues));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).AsymmetryQuotientAQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).AsymmetryQuotientAQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).GlottalGapIndexGGI_mean(windowNr)=mean(currWindowCyclesGGI);
                        app.calculationResults.channelResults(channelNr).GlottalGapIndexGGI_median(windowNr)=median(currWindowCyclesGGI);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).GlottalGapIndexGGI_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).GlottalGapIndexGGI_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).PlateauQuotientPQ_mean(windowNr)=mean(currWindowCyclesPlateauQuotient);
                        app.calculationResults.channelResults(channelNr).PlateauQuotientPQ_median(windowNr)=median(currWindowCyclesPlateauQuotient);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).PlateauQuotientPQ_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).PlateauQuotientPQ_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).GlottalAreaIndex_mean(windowNr)=mean(currWindowCyclesYDataRange./(currWindowCyclesYDataMax.*currWindowCyclesOQValues));
                        app.calculationResults.channelResults(channelNr).GlottalAreaIndex_median(windowNr)=median(currWindowCyclesYDataRange./(currWindowCyclesYDataMax.*currWindowCyclesOQValues));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).GlottalAreaIndex_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).GlottalAreaIndex_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).AmplitudePeriodicity_mean(windowNr)=mean(movmin(currWindowCyclesYDataRange,2,'Endpoints','discard')./movmax(currWindowCyclesYDataRange,2,'Endpoints','discard'));
                        app.calculationResults.channelResults(channelNr).AmplitudePeriodicity_median(windowNr)=median(movmin(currWindowCyclesYDataRange,2,'Endpoints','discard')./movmax(currWindowCyclesYDataRange,2,'Endpoints','discard'));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).AmplitudePeriodicity_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).AmplitudePeriodicity_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).CycleDurationPeriodicity_mean(windowNr)=mean(movmin(currWindowCyclesDurations,2,'Endpoints','discard')./movmax(currWindowCyclesDurations,2,'Endpoints','discard'));
                        app.calculationResults.channelResults(channelNr).CycleDurationPeriodicity_median(windowNr)=median(movmin(currWindowCyclesDurations,2,'Endpoints','discard')./movmax(currWindowCyclesDurations,2,'Endpoints','discard'));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).CycleDurationPeriodicity_mean_Unit="-";
                            app.calculationResults.channelResults(channelNr).CycleDurationPeriodicity_median_Unit="-";
                        end

                        app.calculationResults.channelResults(channelNr).MaximumAreaDeclinationRateMADR_mean(windowNr)=mean(abs(currWindowCyclesMinDerivate));
                        app.calculationResults.channelResults(channelNr).MaximumAreaDeclinationRateMADR_median(windowNr)=median(abs(currWindowCyclesMinDerivate));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).MaximumAreaDeclinationRateMADR_mean_Unit="channelUnit/s";
                            app.calculationResults.channelResults(channelNr).MaximumAreaDeclinationRateMADR_median_Unit="channelUnit/s";
                        end

                        app.calculationResults.channelResults(channelNr).AmplitudeQuotientAQ_mean(windowNr)=mean(currWindowCyclesYDataRange./abs(currWindowCyclesMinDerivate));
                        app.calculationResults.channelResults(channelNr).AmplitudeQuotientAQ_median(windowNr)=median(currWindowCyclesYDataRange./abs(currWindowCyclesMinDerivate));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).AmplitudeQuotientAQ_mean_Unit="s";
                            app.calculationResults.channelResults(channelNr).AmplitudeQuotientAQ_median_Unit="s";
                        end




                    end
                    %% perturbation measurements

                    % Generic functions for PF, PQ, and VI calculations
                    calculatePerturbationFactor  = @(data) mean(abs(diff(data) ./ data(2:end))) * 100;
                    calculatePerturbationQuotient = @(data, k) mean(abs(1 - ...
                        (data((k-1)/2+1:end-(k-1)/2) ./ movmean(data, k, 'Endpoints', 'discard')))) * 100;



                    calculateVariabilityIndex     = @(data, meanData) log10(1000 * var(data) / (meanData ^ 2));
                    calculateRAPv1 = @(data) sum(abs(movmean(data, 3, 'Endpoints', 'discard')-data(2:end-1)))/sum(data);
                    calculateRAPv2 = @(data) mean(abs(movmean(data, 3, 'Endpoints', 'discard')-data(2:end-1)))/mean(data);

                    %% Amplitude Perturbation

                    % mean shimmer dB
                    if app.calculationSettings.meanShimmer.doCalculate
                        app.calculationResults.channelResults(channelNr).meanShimmer(windowNr)    = 20 * mean(abs(log10(currWindowCyclesYDataRange(1:end-1) ./ currWindowCyclesYDataRange(2:end))));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).meanShimmer_Unit="dB";
                        end
                    end

                    % shimmer in percent
                    if app.calculationSettings.shimmerInPercent.doCalculate
                        app.calculationResults.channelResults(channelNr).shimmer(windowNr) = mean(abs(diff(currWindowCyclesYDataRange))) / meanCurrWindowCyclesYDataRange * 100;
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).shimmer_Unit="%";
                        end
                    end

                    % APQ
                    if app.calculationSettings.APQ.doCalculate
                        for k = 3:2:11
                            app.calculationResults.channelResults(channelNr).(['AmplitudePerturbationQuotientAPQ' num2str(k)])(windowNr) = calculatePerturbationQuotient(currWindowCyclesYDataRange, k);
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).(['AmplitudePerturbationQuotientAPQ' num2str(k) '_Unit'])="-";
                            end
                        end
                    end

                    % APF
                    if app.calculationSettings.APF.doCalculate
                        app.calculationResults.channelResults(channelNr).AmplitudePerturbationFactorAPF(windowNr) = calculatePerturbationFactor(currWindowCyclesYDataRange);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).AmplitudePerturbationFactorAPF_Unit="%";
                        end
                    end

                    % AVI
                    if app.calculationSettings.AVI.doCalculate
                        app.calculationResults.channelResults(channelNr).AmplitudeVariabilityIndexAVI(windowNr) = calculateVariabilityIndex(currWindowCyclesYDataRange, meanCurrWindowCyclesYDataRange);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).AmplitudeVariabilityIndexAVI_Unit="dB";
                        end
                    end

                    % RAP for cycle ranges (instead of durations)
                    if app.calculationSettings.RAPforCycleRange.doCalculate
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1ofCycleRange(windowNr) = calculateRAPv1(currWindowCyclesYDataRange);
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2ofCycleRange(windowNr) = calculateRAPv2(currWindowCyclesYDataRange);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1ofCycleRange_Unit="-";
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2ofCycleRange_Unit="-";
                        end
                    end
                    %% Period Perturbation
                    % mean Jitter
                    if app.calculationSettings.meanJitter.doCalculate
                        app.calculationResults.channelResults(channelNr).meanJitter(windowNr)      = mean(abs(diff(currWindowCyclesDurations)));
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).meanJitter_Unit="s";
                        end
                    end

                    % Jitter in percent
                    if app.calculationSettings.jitterInPercent.doCalculate
                        app.calculationResults.channelResults(channelNr).jitter(windowNr) = app.calculationResults.channelResults(channelNr).meanJitter(windowNr) / mean(currWindowCyclesDurations) * 100;
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).jitter_Unit="%";
                        end
                    end

                    % Jitter Ratio
                    if app.calculationSettings.jitterRatio.doCalculate
                        app.calculationResults.channelResults(channelNr).jitterRatio(windowNr)    = app.calculationResults.channelResults(channelNr).jitter(windowNr) * 10;
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).jitterRatio_Unit="-";
                        end
                    end

                    % Jitter Factor
                    if app.calculationSettings.jitterFactor.doCalculate
                        app.calculationResults.channelResults(channelNr).jitterFactor(windowNr)    = 100*mean(abs(diff(1./currWindowCyclesDurations)))/mean(1./currWindowCyclesDurations);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).jitterFactor_Unit="%";
                        end
                    end

                    % PPQ
                    if app.calculationSettings.PPQ.doCalculate
                        for k = 3:2:11
                            app.calculationResults.channelResults(channelNr).(['PeriodPerturbationQuotientPPQ' num2str(k)])(windowNr) = calculatePerturbationQuotient(currWindowCyclesDurations, k);
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).(['PeriodPerturbationQuotientPPQ' num2str(k) '_Unit'])="-";
                            end
                        end
                    end

                    % PPF
                    if app.calculationSettings.PPF.doCalculate
                        app.calculationResults.channelResults(channelNr).PeriodPerturbationFactorPPF(windowNr) = calculatePerturbationFactor(currWindowCyclesDurations);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).PeriodPerturbationFactorPPF_Unit="%";
                        end
                    end

                    % RAPv1
                    if app.calculationSettings.RAPv1.doCalculate
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1(windowNr) = calculateRAPv1(currWindowCyclesDurations);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1_Unit="-";
                        end
                    end

                    % RAPv2
                    if app.calculationSettings.RAPv2.doCalculate
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2(windowNr) = calculateRAPv2(currWindowCyclesDurations);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2_Unit="-";
                        end
                    end

                    % PVI
                    if app.calculationSettings.PVI.doCalculate
                        app.calculationResults.channelResults(channelNr).PeriodVariabilityIndexPVI(windowNr) = calculateVariabilityIndex(currWindowCyclesDurations, meanCurrWindowCyclesDurations);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).PeriodVariabilityIndexPVI_Unit="dB";
                        end
                    end



                    %% Energy Perturbation

                    % EPQ
                    if app.calculationSettings.EPQ.doCalculate
                        for k = 3:2:11
                            app.calculationResults.channelResults(channelNr).(['EnergyPerturbationQuotientEPQ' num2str(k)])(windowNr) = calculatePerturbationQuotient(currWindowCyclesYDataEnergy, k);
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).(['EnergyPerturbationQuotientEPQ' num2str(k) '_Unit'])="%";
                            end
                        end
                    end

                    % EPF
                    if app.calculationSettings.EPF.doCalculate
                        app.calculationResults.channelResults(channelNr).EnergyPerturbationFactorEPF(windowNr) = calculatePerturbationFactor(currWindowCyclesYDataEnergy);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).EnergyPerturbationFactorEPF_Unit="%";
                        end
                    end

                    % EVI
                    if app.calculationSettings.EVI.doCalculate
                        app.calculationResults.channelResults(channelNr).EnergyVariabilityIndexEVI(windowNr) = calculateVariabilityIndex(currWindowCyclesYDataEnergy,meanCurrWindowCyclesYDataEnergy);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).EnergyVariabilityIndexEVI_Unit="dB";
                        end
                    end

                    % RAP for cycle energy (instead of cycle duration)
                    if app.calculationSettings.RAPforCycleEnergy.doCalculate
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1ofCycleEnergy(windowNr) = calculateRAPv1(currWindowCyclesYDataEnergy);
                        app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2ofCycleEnergy(windowNr) = calculateRAPv2(currWindowCyclesYDataEnergy);
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv1ofCycleEnergy_Unit="-";
                            app.calculationResults.channelResults(channelNr).RelativeAveragePerturbationRAPv2ofCycleEnergy_Unit="-";
                        end
                    end
                    %% noise measurements

                    % harmonic intensity - window based

                    % HNR - cycle based

                    % NNE based - window based

                    % spectral flatness - window based
                    % !!!!! different to MSA implemetation!!!!
                    % this is based on Johnston, J. D. "Transform Coding of Audio Signals Using Perceptual Noise Criteria." IEEE Journal on Selected Areas in Communications. Vol. 6, Number 2, 1988, pp. 314–323.
                    % MSA is based on J. Lessing. “Entwicklung einer Klassiﬁkationsmethode zur akustischen Analyse fortlaufender Sprache unterschiedlicher Stimmgüte mittels Neuronaler Netze und deren Anwendung”. PhD thesis. Georg-August-Universität Göttingen, Mathematisch-Naturwissenschaftlich Fakultät, 2007.

                    if app.calculationSettings.spectralFlatness.doCalculate
                        try
                            windowForSpectralFlatness=app.windowGenerator(app.calculationSettings.generalFFT.windowType,numel(currWindowYData));
                            app.calculationResults.channelResults(channelNr).spectralFlatness(windowNr) = spectralFlatness(currWindowYData(:),currFs,"Window",windowForSpectralFlatness,"OverlapLength",0);
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).spectralFlatness_Unit="-";
                            end
                        catch ME
                            app.calculationResults.channelResults(channelNr).spectralFlatness(windowNr)=NaN;
                            disp('error while calculating spectral flatness, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                    end
                    % GNE - window based

                    if app.calculationSettings.GNEv2.doCalculate

                        % this is the version from T. Tsanas Voice Analysis,
                        % NOT FROM GAT
                        % Toolbox: https://github.com/ThanasisTsanas/VoiceAnalysisToolbox
                        % Outputs are   % {'GNE->mean'                              }
                        % {'GNE->std'                               }
                        % {'GNE->SNR_TKEO'                          }
                        % {'GNE->SNR_SEO'                           }
                        % {'GNE->NSR_TKEO'                          }
                        % {'GNE->NSR_SEO'                           }
                        % TKEO = Teager‑Kaiser Energy Operator
                        % SEO = Squared Energy Operator).

                        idx = GNE_Tsanas_time >= startTimes(windowNr) & GNE_Tsanas_time <= endTimes(windowNr);

                        % 1. GNE->mean
                        GNE_mean_custom = mean(GNE_Tsanas_Precomputed(idx));

                        % 2. GNE->std
                        GNE_std_custom = std(GNE_Tsanas_Precomputed(idx));

                        % 3. GNE->SNR_TKEO
                        TKEO_low = sum(mean(GNE_Tsanas_BW_TKEO(idx,1:2),2));
                        TKEO_high = sum(mean(GNE_Tsanas_BW_TKEO(idx,end-3:end),2));
                        SNR_TKEO_custom = TKEO_low / TKEO_high;

                        % 4. GNE->SNR_SEO
                        SEO_low = sum(mean(GNE_Tsanas_BW_energy(idx,1:2),2));
                        SEO_high = sum(mean(GNE_Tsanas_BW_energy(idx,end-3:end),2));
                        SNR_SEO_custom = SEO_low / SEO_high;

                        % 5. GNE->NSR_TKEO
                        logTKEO_low = sum(log(mean(GNE_Tsanas_BW_TKEO(idx,1:2),2)));
                        logTKEO_high = sum(log(mean(GNE_Tsanas_BW_TKEO(idx,end-3:end),2)));
                        NSR_TKEO_custom = logTKEO_high / logTKEO_low;

                        % 6. GNE->NSR_SEO
                        logSEO_low = sum(log(mean(GNE_Tsanas_BW_energy(idx,1:2),2)));
                        logSEO_high = sum(log(mean(GNE_Tsanas_BW_energy(idx,end-3:end),2)));
                        NSR_SEO_custom = logSEO_high / logSEO_low;


                        app.calculationResults.channelResults(channelNr).GNEv2_mean(windowNr) = GNE_mean_custom;
                        app.calculationResults.channelResults(channelNr).GNEv2_std(windowNr) = GNE_std_custom;

                        app.calculationResults.channelResults(channelNr).GNEv2SNR_TKEO(windowNr) = SNR_TKEO_custom;
                        app.calculationResults.channelResults(channelNr).GNEv2SNR_SEO(windowNr) = SNR_SEO_custom;

                        app.calculationResults.channelResults(channelNr).GNEv2NSR_TKEO(windowNr) = NSR_TKEO_custom;
                        app.calculationResults.channelResults(channelNr).GNEv2NSR_SEO(windowNr) = NSR_SEO_custom;

                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).GNEv2_mean_Unit = "-";
                            app.calculationResults.channelResults(channelNr).GNEv2_std_Unit = "-";

                            app.calculationResults.channelResults(channelNr).GNEv2SNR_TKEO_Unit = "-";
                            app.calculationResults.channelResults(channelNr).GNEv2SNR_SEO_Unit = "-";

                            app.calculationResults.channelResults(channelNr).GNEv2NSR_TKEO_Unit = "-";
                            app.calculationResults.channelResults(channelNr).GNEv2NSR_SEO_Unit = "-";
                        end
                    end


                    % WMC - window based

                    % MWMC - window based

                    % SNR v1- window based % !! matlab snr is calucated elsewhere

                    % SNR v2 - window based % !! matlab snr is calucated elsewhere

                    % CPP v1 - window based

                    


                    % CPP v2 - window based

                    %% mechanical

                    % stiffness - cycle based

                    % peak closing velocity - cycle based

                    % peak acceleration - cycle based

                    % amplitude to length ratio  - cycle based




                    %% calculate FS based SampEn using fixed number of cycles

                    if ismember(app.channelSource{channelNr},{'GAW','EGG'}) && app.calculationSettings.SampleEntropyFD.doCalculate

                        % % from selamtzis output
                        % currWindowSampEn=sampen_y(sampen_x >= startTimes(windowNr) & sampen_x < endTimes(windowNr));
                        % if isempty(currWindowSampEn)
                        %     currWindowSampEn=NaN;
                        % else
                        %     currWindowSampEn=mean(currWindowSampEn);
                        % end
                        % app.calculationResults.channelResults(channelNr).sampleEntropyFourierDomainFixedNumberOfCycles(windowNr)=currWindowSampEn;


                        % from my own output
                        currWindowSampEn=SampEnFDofEachSet(SampEnFDofEachSetTime >= startTimes(windowNr) & SampEnFDofEachSetTime < endTimes(windowNr));
                        if isempty(currWindowSampEn)
                            currWindowSampEn=NaN;
                        else
                            currWindowSampEn=mean(currWindowSampEn);
                        end
                        app.calculationResults.channelResults(channelNr).sampleEntropyFourierDomain(windowNr)=currWindowSampEn;

                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).sampleEntropyFourierDomain_Unit="-";
                        end




                    end

                    %% list of additional parameters

                    % fo values
                    if ismember(app.channelSource{channelNr},sourceTypesAllowedForPitchCalculation) && (app.calculationSettings.pitch.doCalculate || app.calculationSettings.harmonics.doCalculate || app.calculationSettings.subharmonics.doCalculate)

                        for pitchMethodNr=1:numel(pitchMethod)
                            % no pitch needed since pitch function apllies a
                            % window by itself
                            % SRH uses periodic hann, NCF needs no windowing
                            % and all other use periodic hamming window
                            try

                                % currPitchExcerpt=pitchesY{pitchMethodNr}(pitchesX{pitchMethodNr} >= startTimes(windowNr) & pitchesX{pitchMethodNr} <= endTimes(windowNr));
                                % 
                                % app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currPitchExcerpt);
                                % app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currPitchExcerpt);
                                % app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr} '_iqr'])(windowNr)=iqr(currPitchExcerpt);
                                % app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr} '_std'])(windowNr)=std(currPitchExcerpt);

                                app.diversifyParameterTimeSequence(pitchesY{pitchMethodNr}, pitchesX{pitchMethodNr}, ['fo' pitchMethod{pitchMethodNr}],channelNr, windowNr, startTimes, endTimes,"Hz");


                            catch ME
                                disp(['Error getting pitch in window during ' pitchMethod{pitchMethodNr} ' method:']);
                                disp(ME.getReport());
                                app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr}])(windowNr)=NaN;
                            end
                        end
                    end

                    % harmonic order, H1H2 etc
                    if ismember(app.channelSource{channelNr},sourceTypesAllowedForPitchCalculation) && (app.calculationSettings.pitch.doCalculate || app.calculationSettings.harmonics.doCalculate || app.calculationSettings.subharmonics.doCalculate)

                        % each pitch algorithm gets potentially another fo,
                        % so when we want to calculate e.g. H1H2 those
                        % values can differ
                        for pitchMethodNr=1:numel(pitchMethod)

                            currWindowHarmonicsAmps=pitchAndHarmonicsSpectrogramAmplitudes{pitchMethodNr}(:,tSpectrogram>= startTimes(windowNr) & tSpectrogram<= endTimes(windowNr));
                            currWindowSubharmonicsAmps=pitchAndSubharmonicsSpectrogramAmplitudes{pitchMethodNr}(:,tSpectrogram>= startTimes(windowNr) & tSpectrogram<= endTimes(windowNr));
                            
                                try
    
                                    
                                    
                                    
                                    

                                    % now get the lowest harmonic (Hz)
                                    % which still fullfilles the threshold
                                    % for all frames in the current window

                                    highestHarmonicFreqOrder=nan(1,size(currWindowHarmonicsAmps,2));

                                    for nr=1:numel(highestHarmonicFreqOrder)
                                        tmp=find(currWindowHarmonicsAmps(1:app.calculationSettings.harmonics.maxOrder,nr)<currWindowHarmonicsAmps(1,nr)+20*log10(app.calculationSettings.harmonics.percentageThreshold),1)-1;

                                        if isempty(tmp)
                                            highestHarmonicFreqOrder(nr)=app.calculationSettings.harmonics.maxOrder;
                                        else
                                            highestHarmonicFreqOrder(nr)=tmp;
                                        end
                                    end

                                    % now we need to decide which is the
                                    % highest valid harmonic, we could
                                    % choose it very strict such that all
                                    % frames must fullfill that in the
                                    % window, or we could let decide the
                                    % median which tells us which is more
                                    % commonly true

                                    highestHarmonicFreqOrder=median(highestHarmonicFreqOrder);


                                    %%% saving highest harmonic and H1 H2 H3 H4
                                   

                                    app.calculationResults.channelResults(channelNr).(['highestMedianHarmonicOrderUsing' pitchMethod{pitchMethodNr}])(windowNr)=highestHarmonicFreqOrder;

                                    % H1
                                    app.calculationResults.channelResults(channelNr).(['H1using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(1,:));
                                    app.calculationResults.channelResults(channelNr).(['H1using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(1,:));

                                    % residual H1 ref window energy
                                    window_energy_dB_without_mean = 20*log10(rms(currWindowYData-mean(currWindowYData)));
                                    app.calculationResults.channelResults(channelNr).(['H1ResidualUsing' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=app.calculationResults.channelResults(channelNr).(['H1using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)-window_energy_dB_without_mean;
                                    app.calculationResults.channelResults(channelNr).(['H1ResidualUsing' pitchMethod{pitchMethodNr} '_median'])(windowNr)=app.calculationResults.channelResults(channelNr).(['H1using' pitchMethod{pitchMethodNr} '_median'])(windowNr)-window_energy_dB_without_mean;


                                    if size(currWindowHarmonicsAmps,1)>1 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % H2
                                        app.calculationResults.channelResults(channelNr).(['H2using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(2,:));
                                        app.calculationResults.channelResults(channelNr).(['H2using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(2,:));

                                        % H1H2
                                        app.calculationResults.channelResults(channelNr).(['H1H2using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(2,:));
                                        app.calculationResults.channelResults(channelNr).(['H1H2using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(2,:));
                                    end
                                    if size(currWindowHarmonicsAmps,1)>2 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % H3
                                        app.calculationResults.channelResults(channelNr).(['H3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['H3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(3,:));
                                        % H1H3
                                        app.calculationResults.channelResults(channelNr).(['H1H3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['H1H3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(3,:));
                                        % H2H3
                                        app.calculationResults.channelResults(channelNr).(['H2H3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(2,:)-currWindowHarmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['H2H3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(2,:)-currWindowHarmonicsAmps(3,:));

                                    end
                                    if size(currWindowHarmonicsAmps,1)>3 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % H4
                                        app.calculationResults.channelResults(channelNr).(['H3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['H3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(4,:));
                                        % H1H4
                                        app.calculationResults.channelResults(channelNr).(['H1H4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['H1H4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(1,:)-currWindowHarmonicsAmps(4,:));
                                        % H2H4
                                        app.calculationResults.channelResults(channelNr).(['H2H4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(2,:)-currWindowHarmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['H2H4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(2,:)-currWindowHarmonicsAmps(4,:));
                                        % H3H4
                                        app.calculationResults.channelResults(channelNr).(['H3H4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowHarmonicsAmps(3,:)-currWindowHarmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['H3H4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowHarmonicsAmps(3,:)-currWindowHarmonicsAmps(4,:));
                                    end

                                 


                                    %%% now get the lowest subharmonic order
                                    

                                    % search for the first subharmonic that
                                    % does not fullfill the threshold rule

                                    lowestSubharmonicFreqIdx=nan(1,size(currWindowSubharmonicsAmps,2));

                                    for nr=1:numel(lowestSubharmonicFreqIdx)
                                        tmp=find(currWindowSubharmonicsAmps(1:app.calculationSettings.subharmonics.maxOrder,nr)<currWindowSubharmonicsAmps(1,nr)+20*log10(app.calculationSettings.subharmonics.percentageThreshold),1)-1;

                                        if isempty(tmp)
                                            lowestSubharmonicFreqIdx(nr)=app.calculationSettings.subharmonics.maxOrder;
                                        else
                                            lowestSubharmonicFreqIdx(nr)=tmp;
                                        end
                                    end

                                    highestSubharmonicFreqOrder=median(lowestSubharmonicFreqIdx);

                                    
                                    % highest subharmonic order

                                    app.calculationResults.channelResults(channelNr).(['highestMedianSubharmonicOrderUsing' pitchMethod{pitchMethodNr}])(windowNr)=highestSubharmonicFreqOrder;
                                    
                                    % S1
                                    app.calculationResults.channelResults(channelNr).(['S1using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(1,:));
                                    app.calculationResults.channelResults(channelNr).(['S1using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(1,:));

                                    % residual S1 ref window energy
                                    window_energy_dB_without_mean = 20*log10(rms(currWindowYData-mean(currWindowYData)));
                                    app.calculationResults.channelResults(channelNr).(['S1ResidualUsing' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=app.calculationResults.channelResults(channelNr).(['S1using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)-window_energy_dB_without_mean;
                                    app.calculationResults.channelResults(channelNr).(['S1ResidualUsing' pitchMethod{pitchMethodNr} '_median'])(windowNr)=app.calculationResults.channelResults(channelNr).(['S1using' pitchMethod{pitchMethodNr} '_median'])(windowNr)-window_energy_dB_without_mean;


                                    if size(currWindowSubharmonicsAmps,1)>1 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % S2
                                        app.calculationResults.channelResults(channelNr).(['S2using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(2,:));
                                        app.calculationResults.channelResults(channelNr).(['S2using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(2,:));

                                        % S1S2
                                        app.calculationResults.channelResults(channelNr).(['S1S2using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(2,:));
                                        app.calculationResults.channelResults(channelNr).(['S1S2using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(2,:));
                                    end
                                    if size(currWindowSubharmonicsAmps,1)>2 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % S3
                                        app.calculationResults.channelResults(channelNr).(['S3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['S3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(3,:));
                                        % S1S3
                                        app.calculationResults.channelResults(channelNr).(['S1S3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['S1S3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(3,:));
                                        % S2S3
                                        app.calculationResults.channelResults(channelNr).(['S2S3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(2,:)-currWindowSubharmonicsAmps(3,:));
                                        app.calculationResults.channelResults(channelNr).(['S2S3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(2,:)-currWindowSubharmonicsAmps(3,:));

                                    end
                                    if size(currWindowSubharmonicsAmps,1)>3 % normally this should be the case since internally at least 4 harmonics are checked, but for the case that the harmonics frequency lies outside max(fSpectrogram), this could not be fullfilled
                                        % S4
                                        app.calculationResults.channelResults(channelNr).(['S3using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['S3using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(4,:));
                                        % S1S4
                                        app.calculationResults.channelResults(channelNr).(['S1S4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['S1S4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(1,:)-currWindowSubharmonicsAmps(4,:));
                                        % S2S4
                                        app.calculationResults.channelResults(channelNr).(['S2S4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(2,:)-currWindowSubharmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['S2S4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(2,:)-currWindowSubharmonicsAmps(4,:));
                                        % S3S4
                                        app.calculationResults.channelResults(channelNr).(['S3S4using' pitchMethod{pitchMethodNr} '_mean'])(windowNr)=mean(currWindowSubharmonicsAmps(3,:)-currWindowSubharmonicsAmps(4,:));
                                        app.calculationResults.channelResults(channelNr).(['S3S4using' pitchMethod{pitchMethodNr} '_median'])(windowNr)=median(currWindowSubharmonicsAmps(3,:)-currWindowSubharmonicsAmps(4,:));
                                    end
                                    

    
    
                                catch ME
                                    disp(['Error getting harmonic data or H1H2 values ' pitchMethod{pitchMethodNr} ' method:']);
                                    disp(ME.getReport());
                                    %app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr}])(windowNr)=NaN;
                                end

                        end


                    end


                    if app.calculationSettings.CPPv3.doCalculate
                         try
                                % whereCPP=cppsv3times >= startTimes(windowNr) & cppsv3times <= endTimes(windowNr);
                                % currCPPsv3Excerpt=cppsv3(whereCPP);
                                % currCPPv3Excerpt=cppv3(whereCPP);
                                % 
                                % cppNotNaN=~isnan(currCPPv3Excerpt);
                                % app.calculationResults.channelResults(channelNr).(['CPPv3' '_median'])(windowNr)=median(currCPPv3Excerpt(cppNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPv3' '_mean'])(windowNr)=mean(currCPPv3Excerpt(cppNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPv3' '_iqr'])(windowNr)=iqr(currCPPv3Excerpt(cppNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPv3' '_std'])(windowNr)=std(currCPPv3Excerpt(cppNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPv3' '_rms'])(windowNr)=rms(currCPPv3Excerpt(cppNotNaN));

                                app.diversifyParameterTimeSequence(cppv3, cppsv3times, 'CPPv3',channelNr, windowNr, startTimes, endTimes,"dB");


                                % cppsNotNaN=~isnan(currCPPsv3Excerpt);
                                % app.calculationResults.channelResults(channelNr).(['CPPsv3' '_median'])(windowNr)=median(currCPPsv3Excerpt(cppsNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPsv3' '_mean'])(windowNr)=mean(currCPPsv3Excerpt(cppsNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPsv3' '_iqr'])(windowNr)=iqr(currCPPsv3Excerpt(cppsNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPsv3' '_std'])(windowNr)=std(currCPPsv3Excerpt(cppsNotNaN));
                                % app.calculationResults.channelResults(channelNr).(['CPPsv3' '_rms'])(windowNr)=rms(currCPPsv3Excerpt(cppsNotNaN));

                                app.diversifyParameterTimeSequence(cppsv3, cppsv3times, 'CPPsv3',channelNr, windowNr, startTimes, endTimes,"dB");



                         catch ME
                             disp(['Error getting CPP(s) median or similar:']);
                             disp(ME.getReport());
                             app.calculationResults.channelResults(channelNr).(['fo' pitchMethod{pitchMethodNr}])(windowNr)=NaN;
                         end
                    end

                    %% psychoacoustic measurements
                    if app.calculationCalledAsPreview~=1 && ismember(app.channelSource{channelNr},sourceTypesAllowedForPsychoacousticCalculation) && currFs>=8000 && (app.calculationSettings.acousticLoudness.doCalculate || app.calculationSettings.acousticSharpness.doCalculate || app.calculationSettings.acousticRoughness.doCalculate || app.calculationSettings.acousticFluctuation.doCalculate)

                        if app.calculationSettings.acousticLoudness.doCalculate
                            app.diversifyParameterTimeSequence(acousticLoudnessDiffuseZwickerTimeVarying, acousticLoudnessTime, 'PsychoacousticLoudness_TimeVarying_DiffuseSoundField',channelNr, windowNr, startTimes, endTimes,"sone");
                            app.diversifyParameterTimeSequence(acousticLoudnessFreeZwickerTimeVarying, acousticLoudnessTime, 'PsychoacousticLoudness_TimeVarying_FreeSoundField',channelNr, windowNr, startTimes, endTimes,"sone");

                            app.calculationResults.channelResults(channelNr).('PsychoacousticLoudness_TimeStationary_DiffuseSoundField')(windowNr)=acousticLoudnessDiffuseZwickerTimeStationary;
                            app.calculationResults.channelResults(channelNr).('PsychoacousticLoudness_TimeStationary_FreeSoundField')(windowNr)=acousticLoudnessFreeZwickerTimeStationary;


                        end

                        if app.calculationSettings.acousticSharpness.doCalculate
               

                            % DIN
                            app.diversifyParameterTimeSequence(acousticSharpnessDiffuseDINTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_DiffuseSoundField_DINWeighting',channelNr, windowNr, startTimes, endTimes,"acum");
                            app.diversifyParameterTimeSequence(acousticSharpnessFreeDINTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_FreeSoundField_DINWeighting',channelNr, windowNr, startTimes, endTimes,"acum");

                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_DiffuseSoundField_DINWeighting')(windowNr)=acousticSharpnessDiffuseDINTimeStationary;
                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_FreeSoundField_DINWeighting')(windowNr)=acousticSharpnessFreeDINTimeStationary;
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_DiffuseSoundField_DINWeighting_Unit')="acum";
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_FreeSoundField_DINWeighting_Unit')="acum";
                            end

                            % Aures
                            app.diversifyParameterTimeSequence(acousticSharpnessDiffuseAuresTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_DiffuseSoundField_AuresWeighting',channelNr, windowNr, startTimes, endTimes,"acum");
                            app.diversifyParameterTimeSequence(acousticSharpnessFreeAuresTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_FreeSoundField_AuresWeighting',channelNr, windowNr, startTimes, endTimes,"acum");

                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpnessTimeStationaryDiffuseSoundField_AuresWeighting')(windowNr)=acousticSharpnessDiffuseAuresTimeStationary;
                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpnessTimeStationaryFreeSoundField_AuresWeighting')(windowNr)=acousticSharpnessFreeAuresTimeStationary;
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpnessTimeStationaryDiffuseSoundField_AuresWeighting_Unit')="acum";
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpnessTimeStationaryFreeSoundField_AuresWeighting_Unit')="acum";
                            end

                            % Bismarck
                            app.diversifyParameterTimeSequence(acousticSharpnessDiffuseBismarckTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_DiffuseSoundField_BismarckWeighting',channelNr, windowNr, startTimes, endTimes,"acum");
                            app.diversifyParameterTimeSequence(acousticSharpnessFreeBismarckTimeVarying, acousticSharpnessTime, 'PsychoacousticSharpness_TimeVarying_FreeSoundField_BismarckWeighting',channelNr, windowNr, startTimes, endTimes,"acum");

                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_DiffuseSoundField_BismarckWeighting')(windowNr)=acousticSharpnessDiffuseBismarckTimeStationary;
                            app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_FreeSoundField_BismarckWeighting')(windowNr)=acousticSharpnessFreeBismarckTimeStationary;
                            if windowNr==1
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_DiffuseSoundField_BismarckWeighting_Unit')="acum";
                                app.calculationResults.channelResults(channelNr).('PsychoacousticSharpness_TimeStationary_FreeSoundField_BismarckWeighting_Unit')="acum";
                            end

                        end

                        if app.calculationSettings.acousticFluctuation.doCalculate
                            app.diversifyParameterTimeSequence(acousticFluctuationDiffuse, acousticFluctuationTime, 'PsychoacousticFluctuation_DiffuseSoundField',channelNr, windowNr, startTimes, endTimes,"vacil");
                            app.diversifyParameterTimeSequence(acousticFluctuationFree, acousticFluctuationTime, 'PsychoacousticFluctuation_FreeSoundField',channelNr, windowNr, startTimes, endTimes,"vacil");
                        end

                        if app.calculationSettings.acousticRoughness.doCalculate
                            app.diversifyParameterTimeSequence(acousticRoughnessDiffuse, acousticRoughnessTime, 'PsychoacousticRoughness_DiffuseSoundField',channelNr, windowNr, startTimes, endTimes,"asper");
                            app.diversifyParameterTimeSequence(acousticRoughnessFree, acousticRoughnessTime, 'PsychoacousticRoughness_FreeSoundField',channelNr, windowNr, startTimes, endTimes,"asper");
                        end
                    end

                    if ~strcmpi(app.channelSource{channelNr},'Raw') && app.calculationSettings.SPL.doCalculate

                        splSpeedMethod={'Slow','Fast'};
                        splWeightingMethod={'A-weighting','C-weighting','Z-weighting'};
                        splReferencePressure={'20mu' '1'};

                        for splSpeedNr=1:numel(splSpeedMethod)
                            for splWeightingNr=1:numel(splWeightingMethod)
                                for splReferenceNr=1:numel(splReferencePressure)
                                    try
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr} '_mean'])(windowNr)=mean(splY{splSpeedNr,splWeightingNr,splReferenceNr}(currXDataExcerpt >= startTimes(windowNr) & currXDataExcerpt <= endTimes(windowNr)));
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr}  '_median'])(windowNr)=median(splY{splSpeedNr,splWeightingNr,splReferenceNr}(currXDataExcerpt >= startTimes(windowNr) & currXDataExcerpt <= endTimes(windowNr)));
                                    catch ME
                                        disp('Error gettin mean or median SPL in window. Replacing with NaN');
                                        disp(ME.getReport());
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr} '_mean'])(windowNr)=NaN;
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr} '_median'])(windowNr)=NaN;
                                    end

                                    if windowNr==1
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr} '_mean_Unit'])="dB(" + string(splWeightingMethod{splWeightingNr}(1)) + ")";
                                        app.calculationResults.channelResults(channelNr).(['SPL' strrep(splWeightingMethod{splWeightingNr},'-','') splSpeedMethod{splSpeedNr} 'Ref' splReferencePressure{splReferenceNr}  '_median_Unit'])="dB(" + string(splWeightingMethod{splWeightingNr}(1)) + ")";
                                    end
                                end
                            end
                        end

                    end

                    %% basic measurements like mean, median etc

                    if app.calculationSettings.signalMean.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalMean(windowNr) = mean(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalMean(windowNr) = NaN;
                            disp('error while calculating signalMean, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalMean_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMean.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalHarmonicMean(windowNr) = harmmean(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalHarmonicMean(windowNr) = NaN;
                            disp('error while calculating signalHarmonicMean, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalHarmonicMean_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMean.doCalculate
                        try
                            geometricMeanFcn = @(in) prod(abs(in))^(1/numel(in));
                            app.calculationResults.channelResults(channelNr).signalGeometricMean(windowNr) = geometricMeanFcn(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalGeometricMean(windowNr) = NaN;
                            disp('error while calculating signalGeometricMean, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalGeometricMean_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalStd.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByNminus1(windowNr) = std(currWindowYData,0);
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByN(windowNr) = std(currWindowYData,1);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByNminus1(windowNr) = NaN;
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByN(windowNr) = NaN;
                            disp('error while calculating signalStd, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByNminus1_Unit = "channelUnit";
                            app.calculationResults.channelResults(channelNr).signalStd_NormalizedByN_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMedian.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalMedian(windowNr) = median(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalMedian(windowNr) = NaN;
                            disp('error while calculating signalMedian, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalMedian_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMode.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalMode(windowNr) = mode(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalMode(windowNr) = NaN;
                            disp('error while calculating signalMode, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalMode_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMinMax.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalMin(windowNr) = min(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalMin(windowNr) = NaN;
                            disp('error while calculating signalMin, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalMin_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalMinMax.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalMax(windowNr) = max(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalMax(windowNr) = NaN;
                            disp('error while calculating signalMax, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalMax_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalIQR.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalIQR(windowNr) = iqr(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalIQR(windowNr) = NaN;
                            disp('error while calculating signalIQR, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalIQR_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalKurtosis.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalKurtosis(windowNr) = kurtosis(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalKurtosis(windowNr) = NaN;
                            disp('error while calculating signalKurtosis, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalKurtosis_Unit = "-";
                        end
                    end
                    if app.calculationSettings.signalSkewness.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalSkewness(windowNr) = skewness(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalSkewness(windowNr) = NaN;
                            disp('error while calculating signalSkewness, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalSkewness_Unit = "-";
                        end
                    end
                    if app.calculationSettings.signalSummedSquares.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalSummedSquares(windowNr) = sum(currWindowYData.^2);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalSummedSquares(windowNr) = NaN;
                            disp('error while calculating signalSummedSquares, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalSummedSquares_Unit = "channelUnit^2";
                        end
                    end
                    if app.calculationSettings.signalRMS.doCalculate
                        try
                            app.calculationResults.channelResults(channelNr).signalRMS(windowNr) = rms(currWindowYData);
                        catch ME
                            app.calculationResults.channelResults(channelNr).signalRMS(windowNr) = NaN;
                            disp('error while calculating signalRMS, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).signalRMS_Unit = "channelUnit";
                        end
                    end
                    if app.calculationSettings.signalQuantiles.doCalculate
                        try
                            quantQuery = 0.05:0.05:0.95;
                            quantValues = quantile(currWindowYData, quantQuery);
                            for qNr = 1:numel(quantQuery)
                                app.calculationResults.channelResults(channelNr).(['signalQuantile' num2str(quantQuery(qNr)*100) 'percent'])(windowNr) = quantValues(qNr);
                                if windowNr==1
                                    app.calculationResults.channelResults(channelNr).(['signalQuantile' num2str(quantQuery(qNr)*100) 'percent_Unit']) = "channelUnit";
                                end
                            end
                        catch ME
                            % Set all quantiles to NaN if error occurs
                            quantQuery = 0.05:0.05:0.95;
                            for qNr = 1:numel(quantQuery)
                                app.calculationResults.channelResults(channelNr).(['signalQuantile' num2str(quantQuery(qNr)*100) 'percent'])(windowNr) = NaN;
                                if windowNr==1
                                    app.calculationResults.channelResults(channelNr).(['signalQuantile' num2str(quantQuery(qNr)*100) 'percent_Unit']) = "channelUnit";
                                end
                            end
                            disp('error while calculating signal quantiles, replacing all with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                    end
          
                    if app.calculationSettings.SNRdBcarrier.doCalculate
                        try
                            % This is different compared to the MSA implementation!
                            app.calculationResults.channelResults(channelNr).SignalToNoiseRatioSNR(windowNr) = snr(currWindowYData(:), currFs, app.calculationSettings.harmonics.maxOrder);
                        catch ME
                            app.calculationResults.channelResults(channelNr).SignalToNoiseRatioSNR(windowNr) = NaN;
                            disp('error while calculating SNR (dBcarrier), replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).SignalToNoiseRatioSNR_Unit = "dBc";
                        end
                    end
                    if app.calculationSettings.HNRXCorrBiased.doCalculate
                        try
                            % Different compared to MSA: this is based on xcorr, not on spectral
                            app.calculationResults.channelResults(channelNr).HarmonicToNoiseRatioHNRxcorrBiased(windowNr) = app.computeHNRbiasedXcorr(currWindowYData(:));
                        catch ME
                            app.calculationResults.channelResults(channelNr).HarmonicToNoiseRatioHNRxcorrBiased(windowNr) = NaN;
                            disp('error while calculating HNRxcorrBiased, replacing with NaN. Error message:');
                            disp(ME.getReport());
                            disp('-----------------');
                        end
                        if windowNr==1
                            app.calculationResults.channelResults(channelNr).HarmonicToNoiseRatioHNRxcorrBiased_Unit = "dB";
                        end
                    end


                    if windowNr==2 && initedOnce==0

                        existingFields=fieldnames(app.calculationResults.channelResults(channelNr));

                        existingFields(contains(existingFields,'_Unit'))=[];


                        for fieldNr=3:numel(existingFields) % the first two are cycleBorderVals and cycleDurations
                            if isequal(size(app.calculationResults.channelResults(channelNr).(existingFields{fieldNr})),[1,2]) % there should be only 2 entries yet since we are at the end of window iteration 2
                                if iscell(app.calculationResults.channelResults(channelNr).(existingFields{fieldNr}))
                                    app.calculationResults.channelResults(channelNr).(existingFields{fieldNr})(3:elementsToInit)=cell(1,elementsToInit-2);
                                else
                                    app.calculationResults.channelResults(channelNr).(existingFields{fieldNr})(3:elementsToInit)=nan(1,elementsToInit-2);
                                end
                            end
                        end


                        initedOnce=1;
                    end

                end

                if ismember(app.channelSource{channelNr},channelTypesAllowedForAudioFeatureExtractor)
                    calculatedAudioFeatures = extract(afe, currYDataExcerpt(:));
                    calculatedAudioFeaturesTime = linspace(currXDataExcerpt(1),currXDataExcerpt(end),size(calculatedAudioFeatures,1)+1);
                    calculatedAudioFeaturesTime= calculatedAudioFeaturesTime(1:end-1)+app.calculationSettings.pitch.timeWindow;




                    for featureNr=1:numel(audioFeatureExtractorInfoStructFields)
                        currFeatureValue=calculatedAudioFeatures(:,featureNr);

                        if strcmpi(audioFeatureExtractorInfoStructFields{featureNr},'zerocrossrate')
                            % convert to Hz
                            currFeatureValue=currFeatureValue*currFs;
                        end

                        audioFeatureMean=nan(1,numel(startTimes));
                        audioFeatureMedian=nan(1,numel(startTimes));
                        audioFeatureSTD=nan(1,numel(startTimes));
                        audioFeatureIQR=nan(1,numel(startTimes));

                        for windowNr=1:numel(startTimes)

                            audioFeatureExcerpt=calculatedAudioFeaturesTime>=startTimes(windowNr) & calculatedAudioFeaturesTime<=endTimes(windowNr);

                            audioFeatureMean(windowNr)=mean(currFeatureValue(audioFeatureExcerpt));
                            audioFeatureMedian(windowNr)=median(currFeatureValue(audioFeatureExcerpt));
                            audioFeatureSTD(windowNr)=std(currFeatureValue(audioFeatureExcerpt));
                            audioFeatureIQR(windowNr)=iqr(currFeatureValue(audioFeatureExcerpt));


                        end

                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_mean'])=audioFeatureMean;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_median'])=audioFeatureMedian;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_std'])=audioFeatureSTD;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_iqr'])=audioFeatureIQR;


                        switch audioFeatureExtractorInfoStructFields{featureNr}
                            case 'spectralCrest'
                                unit="-";
                            case 'spectralFlux'
                                unit="-";
                            case 'spectralSpread'
                                unit="Hz";
                            case 'spectralSkewness'
                                unit="-";
                            case 'spectralKurtosis'
                                unit="-";
                            case 'spectralCentroid'
                                unit="Hz";
                            case 'spectralEntropy'
                                unit="-";
                            case 'spectralSlope'
                                unit="-";
                            case 'spectralDecrease'
                                unit="-";
                            case 'spectralRolloffPoint'
                                unit="Hz";
                            case 'harmonicRatio'
                                unit="-";
                            case 'zerocrossrate'
                                unit="Hz";
                            otherwise
                                unit="-";
                                disp('no suitable case, setting unit to "-" for audioFeatureExtractor feature');
                        end

                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_mean_Unit'])=unit;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_median_Unit'])=unit;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_std_Unit'])=unit;
                        app.calculationResults.channelResults(channelNr).([audioFeatureExtractorInfoStructFields{featureNr} '_iqr_Unit'])=unit;



                    end
                end

                %% separate per window calculations

                if app.calculationSettings.CPPv1.doCalculate
                    plotCPP=0;
                    cppWindowType=app.calculationSettings.CPPv1.windowType;
                    cppLowerLimit=app.calculationSettings.CPPv1.lowerQuefrencyLimit;
                    cppUpperLimit=app.calculationSettings.CPPv1.upperQuefrencyLimit;
                    cppMaxInFitRegion=app.calculationSettings.CPPv1.maxInFitRegion;
                    cppFitMethod=app.calculationSettings.CPPv1.fitMethod;
                    cppRobustMethod=app.calculationSettings.CPPv1.robustMethod;

                    cppPoly1off=nan(1,numel(startTimes));
                    cppPoly1LAR=nan(1,numel(startTimes));
                    cppPoly1bisquare=nan(1,numel(startTimes));

                    cppPoly2off=nan(1,numel(startTimes));
                    cppPoly2LAR=nan(1,numel(startTimes));
                    cppPoly2bisquare=nan(1,numel(startTimes));

                    cppExp1off=nan(1,numel(startTimes));
                    cppExp1LAR=nan(1,numel(startTimes));
                    cppExp1bisquare=nan(1,numel(startTimes));


                    parfor windowNr=1:numel(startTimes)
                        currWindowYData=currYDataExcerpt(currXDataExcerpt >= startTimes(windowNr) & ...
                            currXDataExcerpt <= endTimes(windowNr));
                        currWindowXData=currXDataExcerpt(currXDataExcerpt >= startTimes(windowNr) & ...
                            currXDataExcerpt <= endTimes(windowNr));


                        [CPPout]=calculateCPP(currWindowYData,currWindowXData-min(currWindowXData),...
                            plotCPP,...
                            cppWindowType,...
                            cppLowerLimit,...
                            cppUpperLimit,...
                            cppMaxInFitRegion,...
                            cppFitMethod,...
                            cppRobustMethod);

                        for fitShapeNr=1:numel(CPPout)
                            for robustNr=1:numel(CPPout(fitShapeNr).value)
                                switch CPPout(fitShapeNr).fitShape
                                    case 'poly1'
                                        switch CPPout(fitShapeNr).method{robustNr}
                                            case 'off'
                                                cppPoly1off(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            case 'LAR'
                                                cppPoly1LAR(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            otherwise % bisquare
                                                cppPoly1bisquare(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                        end
                                    case 'poly2'
                                        switch CPPout(fitShapeNr).method{robustNr}
                                            case 'off'
                                                cppPoly2off(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            case 'LAR'
                                                cppPoly2LAR(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            otherwise % bisquare
                                                cppPoly2bisquare(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                        end
                                    otherwise % exp1
                                        switch CPPout(fitShapeNr).method{robustNr}
                                            case 'off'
                                                cppExp1off(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            case 'LAR'
                                                cppExp1LAR(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                            otherwise % bisquare
                                                cppExp1bisquare(windowNr)=CPPout(fitShapeNr).value(robustNr);
                                        end
                                end
                            end
                        end
                    end

                    % if any(~isnan(cppPoly1off))
                    %     app.calculationResults.channelResults(channelNr).CPPv1linRobustOff=cppPoly1off;
                    % end
                    % if any(~isnan(cppPoly1LAR))
                    %     app.calculationResults.channelResults(channelNr).CPPv1linRobustLAR=cppPoly1LAR;
                    % end
                    % if any(~isnan(cppPoly1bisquare))
                    %     app.calculationResults.channelResults(channelNr).CPPv1linRobustBisquare=cppPoly1bisquare;
                    % end
                    % if any(~isnan(cppPoly2off))
                    %     app.calculationResults.channelResults(channelNr).CPPv1quadraticRobustOff=cppPoly2off;
                    % end
                    % if any(~isnan(cppPoly2LAR))
                    %     app.calculationResults.channelResults(channelNr).CPPv1quadraticRobustLAR=cppPoly2LAR;
                    % end
                    % if any(~isnan(cppPoly2bisquare))
                    %     app.calculationResults.channelResults(channelNr).CPPv1quadraticRobustBisquare=cppPoly2bisquare;
                    % end
                    % if any(~isnan(cppExp1off))
                    %     app.calculationResults.channelResults(channelNr).CPPv1expRobustOff=cppExp1off;
                    % end
                    % if any(~isnan(cppExp1LAR))
                    %     app.calculationResults.channelResults(channelNr).CPPv1expRobustLAR=cppExp1LAR;
                    % end
                    % if any(~isnan(cppExp1bisquare))
                    %     app.calculationResults.channelResults(channelNr).CPPv1expRobustBisquare=cppExp1bisquare;
                    % end


                    % V 4.7 removing the meta information from the
                    % parameter name. since only one method for fit shape
                    % and orbist method can be chosen now, we only need one CPPv1
                    if any(~isnan(cppPoly1off))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly1off;
                    end
                    if any(~isnan(cppPoly1LAR))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly1LAR;
                    end
                    if any(~isnan(cppPoly1bisquare))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly1bisquare;
                    end
                    if any(~isnan(cppPoly2off))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly2off;
                    end
                    if any(~isnan(cppPoly2LAR))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly2LAR;
                    end
                    if any(~isnan(cppPoly2bisquare))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppPoly2bisquare;
                    end
                    if any(~isnan(cppExp1off))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppExp1off;
                    end
                    if any(~isnan(cppExp1LAR))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppExp1LAR;
                    end
                    if any(~isnan(cppExp1bisquare))
                        app.calculationResults.channelResults(channelNr).CPPv1=cppExp1bisquare;
                    end

                    app.calculationResults.channelResults(channelNr).CPPv1_Unit="dB";


                end

                %% calculate sample entropy in time domain for this window



                if app.calculationSettings.SampleEntropyTime.doCalculate
                    % if not 'global' is chosen, this is just a copy of the
                    % regular Y values
                    currYDataForSampleEntropyTime=currYDataExcerpt;
                    if      strcmp(app.calculationSettings.SampleEntropyTime.normalizationHorizont,'global/selection based')...
                            && ~strcmp(app.calculationSettings.SampleEntropyTime.normalizationMethod,'none')

                        normMethod=app.calculationSettings.SampleEntropyTime.normalizationMethod;
                        currYDataForSampleEntropyTime=normalize(currYDataForSampleEntropyTime,normMethod);
                    end


                    sampEnNormHorz=app.calculationSettings.SampleEntropyTime.normalizationHorizont;
                    sampEnNormMethod=app.calculationSettings.SampleEntropyTime.normalizationMethod;
                    sampEnTemplateLengthMethod=app.calculationSettings.SampleEntropyTime.templateLengthMethod;
                    sampEnTemplateLengthFixed=app.calculationSettings.SampleEntropyTime.templateLengthFixed;
                    sampEnDistanceStdThreshold=app.calculationSettings.SampleEntropyTime.distanceSTDthreshold;
                    sampleEntropyTimeDomain=nan(1,numel(startTimes));

                    parfor windowNr=1:numel(startTimes)
                        currWindowYDataForSampleEntropyTime=currYDataForSampleEntropyTime(currXDataExcerpt >= startTimes(windowNr) & ...
                            currXDataExcerpt <= endTimes(windowNr));

                        if          ~strcmp(sampEnNormHorz,'global/selection based')...
                                && ~strcmp(sampEnNormMethod,'none')

                            normMethod=sampEnNormMethod;
                            if ~isscalar(unique(currWindowYDataForSampleEntropyTime))
                                currWindowYDataForSampleEntropyTime=normalize(currWindowYDataForSampleEntropyTime,normMethod);
                            end
                        end

                        if contains(sampEnTemplateLengthMethod,'log10')
                            templateLength=round(log10(numel(currWindowYDataForSampleEntropyTime)));
                        else
                            templateLength=sampEnTemplateLengthFixed;
                        end
                        if templateLength>numel(currWindowYDataForSampleEntropyTime)-2
                            templateLength=numel(currWindowYDataForSampleEntropyTime)-2;
                        end
                        if templateLength<1
                            templateLength=1;
                        end

                        stdThreshold=sampEnDistanceStdThreshold;


                        sampleEntropyTimeDomain(windowNr)=calculateSampleEntropy(currWindowYDataForSampleEntropyTime,templateLength,stdThreshold);

                    end

                    app.calculationResults.channelResults(channelNr).sampleEntropyTimeDomain=sampleEntropyTimeDomain;
                    app.calculationResults.channelResults(channelNr).sampleEntropyTimeDomain_Unit="-";
                end



                %waitbar(channelNr/nChannels,progDialog,sprintf('%i of %i channels complete',channelNr,nChannels))

                if ~app.batchMode
                    progDialog.Value=channelNr/nChannels;
                    progDialog.Message=sprintf('%i of %i channels complete',channelNr,nChannels);
                    drawnow limitrate;
                end
                

            end

            if ~app.batchMode
                delete(progDialog);
            end

            if ~isdeployed && app.doProfiling
                %#exclude profile
                profile viewer;
            end



            % if progressbar aborted or closed %% edit: commented out
            % becuase I think it is also nice to see results when it is
            % aborted
            % if channelNr~=nChannels
            %     app.calculationResults=struct();
            %     if app.calculationSettings.cycleDuration.showSeparate1overCycleDurationPlot==1
            %         delete(foFig);
            %     end
            %     return;
            % end


            % separate 1/cycleDuration plot
            if app.calculationSettings.cycleDuration.showSeparate1overCycleDurationPlot==1
                title(tl,'1/(cycle length)');
                xlabel(tl,'time (s)');

                if numel(foAxs)>0 % e.g. if only raw channels are available
                    linkaxes([foAxs lastAx]);

                    lg=legend(lastAx,'Orientation','horizontal');
                    lg.Layout.Tile='south';

                    showXLims=[selectionStart selectionEnd];
                    xlim([foAxs lastAx],showXLims+[-1 +1]*0.1*range(showXLims));


                    foFig.Visible='on';
                else
                    delete(foFig);
                end
            end

            if app.calculationCalledAsPreview==0
                app.populateResultsTable();

                
                app.TabGroup.SelectedTab=app.ResultsTab;
                

                app.filterParameterResultsTable();

                if app.batchMode==0

                    if channelNr==nChannels % if complete runthrough
                        uialert(app.UIFigure,'Parameter Calculation complete','Complete','Icon','success');
                    else
                        uialert(app.UIFigure,['Parameter incomplete starting from channel ' num2str(channelNr)],'Complete','Icon','warning');
                    end
                end

            end



        end

        
        function saveResults(app,excelFilePath)
            persistent lastPath;

            if nargin<2 || isempty(excelFilePath)

                fakefig=uifigure('Visible','off');
    
                [file,path]=uiputfile([lastPath 'VocaliscopeResults.xlsx'],'Where to save the values');
    
                close(fakefig);
                if isequal(file,0)
                    return;
                else
                    lastPath=path;
                end

                excelFilePath=fullfile(path,file);

                calledViaButton=1;
            else
                calledViaButton=0;
            end



            progDlg=uiprogressdlg(app.UIFigure,"Indeterminate","on","Message",'Writing results to xlsx...','Title','Saving in progress');

            %% write to excel
            nWindows=app.calculationResults.numberOfWindows;
            nChannels=numel(app.calculationResults.channelResults);
            windowStartTimes=app.calculationResults.windowStartTimes;

            %% write general info sheet
            progDlg.Message='Writing general info...';

            % i want that the channel name is clickable and refers to the
            % corresponding sheet

            channelNamesAsLink=cell(size(app.calculationResults.channelNames));

            for nr=1:numel(channelNamesAsLink)
                channelNamesAsLink{nr}=sprintf('=HYPERLINK("#%i!A1"; "%s")',nr,app.calculationResults.channelNames{nr});
            end

            % we write the excel file to a local temp file and copy to the
            % destination laster, since writing repeatedly to e.g. a one drive
            % folder may cause problems connected to file access permission.
            localTempFile=[tempname '.xlsx'];

            generalInfo = [{'Channel Name'}            app.calculationResults.channelNames(:)';...
                {'Channel short Name'}      app.shortenNames(app.calculationResults.channelNames(:)');...
                {'Channel Source'}          app.calculationResults.channelSource;...
                {'Sample Rate (Hz)'}        num2cell(app.calculationResults.channelSampleRates);...
                {'Applied lag (s)'}         num2cell(app.calculationResults.appliedChannelLag);...
                {'Selection start (s)'}     {app.calculationResults.selectionStart} repelem({''},nChannels-1);...
                {'Selection end (s)'}       {app.calculationResults.selectionEnd} repelem({''},nChannels-1);...
                {'Cycle border values (s)'} repelem({''},nChannels)];


            if isfile(excelFilePath)
                delete(excelFilePath);
            end
            % here, the file is replaced!
            writecell(generalInfo',localTempFile,"Sheet",'General','WriteMode','replacefile','Range','A1','AutoFitWidth',true);


            writecell({sprintf('Vocaliscope Version %s',app.currentAppVersion)},                       localTempFile,"Sheet",'General','WriteMode','inplace','Range',['A'  num2str(nChannels+2,'%i')],'AutoFitWidth',true);



            for channelNr=1:nChannels
                cycleBorders=num2cell(app.calculationResults.channelResults(channelNr).cycleBorderVals);
                if size(cycleBorders,1)==1
                    cycleBorders=cycleBorders';
                end
                writecell(cycleBorders',localTempFile,"Sheet",'General','WriteMode','inplace','Range',['G' num2str(1+channelNr)],'AutoFitWidth',true);
            end


            %% organize by channel nr

            progDlg.Message='Writing calculated parameters';

            parameterNames=fieldnames(app.calculationResults.channelResults);

            parameterNames(contains(parameterNames,{'curr'},"IgnoreCase",true))=[];
            parameterNames(ismember(parameterNames,{'cycleBorderVals' 'cycleDurations' 'allOQBorders' 'allClQBorders'}))=[];
            parameterNames(contains(parameterNames,'_Unit'))=[];

            TableHeader={'Parameter','Parameter Unit','Median','Mean','STD','Min','Max'};
            windowHeaders=arrayfun(@(x) ['window ' num2str(x)], 1:nWindows, 'UniformOutput', false);
            TableHeader=[TableHeader windowHeaders];

            for channelNr=1:nChannels

                tableData=[[{'channel name',                                'channel source',                        '','','','','Window start time'} num2cell(app.calculationResults.channelResults(channelNr).currWindowStartTime)];...
                    [{app.calculationResults.channelNames{channelNr},app.calculationResults.channelSource{channelNr},'','','','','Window end time'} num2cell(app.calculationResults.channelResults(channelNr).currWindowEndTime)];...
                    [{'',                                            '',                                             '','','Total number of cycles in selection',numel(app.calculationResults.channelResults(channelNr).cycleDurations),'number of cycles in this window'} cellfun(@numel,app.calculationResults.channelResults(channelNr).currWindowCycleDurations,'UniformOutput',false)];...
                    TableHeader];
                for parameterNr=1:numel(parameterNames)

                    windowValues={app.calculationResults.channelResults(channelNr).(parameterNames{parameterNr})}';

                    if isempty(windowValues{1})
                        sprintf('the parametter %s in channel %i is empty. skipping...',parameterNames{parameterNr},channelNr);
                        continue;
                    end

                    medians=cellfun(@(in) median(in,"omitmissing"),windowValues,'UniformOutput',false);
                    means=cellfun(@(in) mean(in,'omitmissing'),windowValues,'UniformOutput',false);
                    stds=cellfun(@(in) std(in,'omitmissing'),windowValues,'UniformOutput',false);
                    mins=cellfun(@(in) min(in,[],'omitmissing'),windowValues,'UniformOutput',false);
                    maxs=cellfun(@(in) max(in,[],'omitmissing'),windowValues,'UniformOutput',false);

                    parameterUnit=cellstr(vertcat(app.calculationResults.channelResults(channelNr).([parameterNames{parameterNr} '_Unit'])));

                    tableData=[tableData;...
                        parameterNames(parameterNr) parameterUnit medians means stds mins maxs num2cell(cell2mat(windowValues))];

                end

                % sort parameters alphabetically
                tableData(5:end,:)=sortrows(tableData(5:end,:),1);

                % do some number replacements, e.g. infinity values and NaN
                whereIsInf=cellfun(@(in) isequal(in,inf),tableData);
                tableData(whereIsInf)={'∞'};
                whereIsMinusInf=cellfun(@(in) isequal(in,-inf),tableData);
                tableData(whereIsMinusInf)={'-∞'};
                whereIsNaN=cellfun(@(in) isequal(in,NaN),tableData);
                tableData(whereIsNaN)={'NaN'};

                writecell(tableData,localTempFile,"Sheet",num2str(channelNr),'WriteMode','overwritesheet','Range','A1');

            end

            try % if excel is installed, we want to create hyperlinks here
                writecell(channelNamesAsLink(:),localTempFile,"Sheet",'General','WriteMode','inplace','Range','A2','AutoFitWidth',true,'UseExcel',true);

                linkback={sprintf('=HYPERLINK("#%s!A1"; "%s")','General','(click here to go back to ''General'')')};
                for channelNr=1:nChannels
                    writecell(linkback,localTempFile,"Sheet",num2str(channelNr),'WriteMode','inplace','Range','A3','UseExcel',true,'AutoFitWidth',true);
                end
            catch ME
                disp(ME.getReport);
            end

            %% freeze panels, only possible with excel instaled

            try
                progDlg.Message='Freezing Panels in Parameter Sheets';

                % Freeze four rows and one column
                % Define the full file path to your Excel file

                % Create an Excel COM server instance
                excelApp = actxserver('Excel.Application');
                %excelApp.Visible = true;  % Set to true so you can see what's happening

                % Open the workbook
                workbook = excelApp.Workbooks.Open(localTempFile);

                % Get the collection of sheets
                sheets = workbook.Sheets;
                numSheets = sheets.Count;

                % Loop through each sheet
                for idx = 1:numSheets
                    sheet = sheets.Item(idx);

                    % Skip the sheet named 'General'
                    if strcmp(sheet.Name, 'General')
                        continue;
                    end

                    % Activate the sheet
                    sheet.Activate;

                    % To freeze the first 4 rows and the first column,
                    % select cell B5 (since freeze panes locks rows above and columns to the left)
                    sheet.Range('C5').Select;

                    % Freeze the panes by setting FreezePanes to true on the active window
                    excelApp.ActiveWindow.FreezePanes = true;
                end

                % Activate the "General" sheet so it's the active sheet when opening the file
                generalSheet = sheets.Item('General');
                generalSheet.Activate;

                % Save the changes if needed
                workbook.Save;

                % Optionally, close the workbook and quit Excel
                workbook.Close;

                excelApp.Quit;
                delete(excelApp);

            catch ME
                disp('Error Freezing panel: probably no excel is installed');
                disp(ME.getReport());

            end

            %% add settings in additional tab

            progDlg.Message='Writing calculation settings...';

            settingsAsTwoColumns=app.struct2cell2col;

            writecell(settingsAsTwoColumns,localTempFile,"Sheet",'lastSettings','WriteMode','overwritesheet','Range','A1');

            %% add written channel data in additional tab

            if app.savechanneldatatoxlsxCheckBox.Value==1
                progDlg.Message='Writing external and interal channel data to xlsx...';

                sheetName='channelData';
                if unique(cellfun(@numel,app.channelYValues))>1 % if channels have different number of values, write time and y values for each channel
                    headerCell=cell(2,nChannels*2);
                    headerCell(1,1:2:end)={'time (s)'};
                    headerCell(1,2:2:end)=app.channelNames;
                    headerCell(2,2:2:end)=app.shortenNames(app.channelNames);



                    newcell=cell(0,0);
                    for channelNr=1:numel(app.channelYValues)
                        toBeAdded=num2cell([app.channelXValues{channelNr}(:) app.channelYValues{channelNr}(:)]);
                        newcell(1:size(toBeAdded,1),((channelNr-1)*2+1)+[0 1])=toBeAdded;
                    end

                    writecell([headerCell;newcell],localTempFile,"Sheet",sheetName,'Range','A1','AutoFitWidth',false);



                else
                    headerCell=cell(2,nChannels+1);
                    headerCell(1,1)={'time (s)'};
                    headerCell(1,2:end)=app.channelNames;
                    headerCell(2,2:end)=app.shortenNames(app.channelNames);


                    newcell=num2cell(app.channelXValues{1}(:));
                    for channelNr=1:numel(app.channelYValues)
                        toBeAdded=num2cell(app.channelYValues{channelNr}(:));
                        newcell(1:size(toBeAdded,1),channelNr+1)=toBeAdded;
                    end


                end
                writecell([headerCell;newcell],localTempFile,"Sheet",sheetName,'Range','A1','AutoFitWidth',false);
            end

            %% writing wav file
            if ~app.batchMode && app.savewavandchannelnamestypesCheckBox.Value==1
                progDlg.Message='Saving multi channel wav file...';
                app.exportChannelsToWAV(1,0,strrep(excelFilePath,'.xlsx','_channelData.wav'));
            end


            progDlg.Message='Copying last calculation settings file...';
            if isfile('lastVocaliscopesettings.mat')
                copyfile('lastVocaliscopesettings.mat',strrep(excelFilePath,'.xlsx','_lastVocaliscopesettings.mat'),'f');
            end

            % here the file is copied from the temp direction to the
            % destination

            try
                copyfile(localTempFile,excelFilePath,'f');
            catch

                uialert(app.UIFigure,'Excel file probably opened already, please close to proceed saving excel file','Please close excel file','Icon','warning','CloseFcn',@(~,~) uiresume(app.UIFigure));
                uiwait(app.UIFigure);

                try
                    copyfile(localTempFile,excelFilePath,'f');
                catch ME
                    uialert(app.UIFigure,['Could not move excel file from temp directory to target directory. You can find the file in ' localTempFile],'Error moving excel file to target direction','Icon','error');
                    disp(ME.getReport());
                    if isvalid(progDlg)
                        close(progDlg);
                    end
                    return;
                end
            end
            delete(localTempFile);

            if isvalid(progDlg)
                close(progDlg);
            end

            if calledViaButton==1
                uialert(app.UIFigure,'Save successfull','Success','Icon','success');
    
                if app.openfileaftersavingCheckBox.Value==1
                    winopen(excelFilePath);
                end
            end
            
        end
        
         function S = setDoCalculateAccordingSecondStruct(app,S,refStruct)
            % Recursively traverse struct (including struct arrays) and set
            % any field named 'doCalculate' to 1.

            if ~isstruct(S)
                return
            end

            % Handle struct arrays
            for idx = 1:numel(S)
                fn = fieldnames(S(idx));
                for k = 1:numel(fn)
                    name = fn{k};
                    val  = S(idx).(name);

                    % If field name is 'doCalculate', set it according the
                    % second struct
                    if strcmp(name, 'doCalculate')
                        S(idx).(name) = refStruct(idx).(name);
                        continue
                    end

                    % If the field itself is a struct, recurse
                    if isstruct(val)
                        S(idx).(name) = app.setDoCalculateAccordingSecondStruct(val,refStruct(idx).(name));
                    end
                end
            end
        end
        
        
        function diversifyParameterTimeSequence(app,data,time,paramName,channelNr,windowNr,startTimes,endTimes,parameterUnit)

            if nargin<9 || isempty(parameterUnit)
                parameterUnit="-";
            end

            if ischar(parameterUnit)
                parameterUnit=string(parameterUnit);
            end

            whereData = time >= startTimes(windowNr) & time <= endTimes(windowNr);
            currExcerpt = data(whereData);

            fieldNames = {'median','mean','iqr','std','rms'};

            if ~any(whereData)
                fieldValues = nan(1,numel(fieldNames));
            else
                notNaN = ~isnan(currExcerpt);

                if ~any(notNaN)
                    fieldValues = nan(1,numel(fieldNames));
                else
                    validData = currExcerpt(notNaN);
                    fieldValues = [ ...
                        median(validData), ...
                        mean(validData), ...
                        iqr(validData), ...
                        std(validData), ...
                        rms(validData)];
                end
            end

            for k = 1:numel(fieldNames)
                fullFieldName = [paramName '_' fieldNames{k}];
                app.calculationResults.channelResults(channelNr).(fullFieldName)(windowNr) = fieldValues(k);
                if windowNr==1
                    app.calculationResults.channelResults(channelNr).([fullFieldName '_Unit'])=parameterUnit;
                end
            end

        end

        
        function win = windowGenerator(~,windowType,Nwin)
            switch windowType
                case "hamming"
                    win = hamming(Nwin);
                case {"hann","hanning"}
                    win=hann(Nwin);
                case "barthannwin"
                    win=barthannwin(Nwin);
                case "bartlett"
                    win=bartlett(Nwin);
                case "blackman"
                    win=blackman(Nwin);
                case "blackmanharris"
                    win=blackmanharris(Nwin);
                case "bohmanwin"
                    win=bohmanwin(Nwin);
                case "chebwin"
                    win=chebwin(Nwin);
                case "flattopwin"
                    win=flattopwin(Nwin);
                case "gausswin"
                    win=gausswin(Nwin);
                case "nuttallwin"
                    win=nuttallwin(Nwin);
                case "parzenwin"
                    win=parzenwin(Nwin);
                case "triang"
                    win=triang(Nwin);
                otherwise % also called rectangular
                    win=ones(Nwin,1);
            end
            
        end
        
        function results = interpolateSpectrumUsingNearestBinAndTwoNeighbors(~,spectrum,fVector,fq,interpMethod)
            % assuming spectrum to be already in log space

            [~, idx] = min(abs(fVector - fq)); 

            % 3 Bins around fq:

            width=3;

            searchRange=idx-((width-1)/2):idx+((width-1)/2);
            searchRange(searchRange<1 | searchRange>numel(fVector))=[];

            f_neighbors = fVector(searchRange);
            A_neighbors = spectrum(searchRange);
            
            
            % interpolation at point given by fq
            results = interp1(f_neighbors,A_neighbors,fq,interpMethod,'extrap');
            
        end
        
        function [gawdata,importFs,closedByApply] = openPVGimportApp(~,currFile)
            fig=uifigure("WindowStyle","normal",'Units','normalized','Position',[0.1 0.1 0.8 0.8],'Name','Importing PVG image to as GAW');
            gl=uigridlayout(fig,[6,2],'RowSpacing',1,'ColumnSpacing',1,'Padding',[0 0 0 0],'RowHeight',{'1x' '1x' '1x' '1x' 'fit' 'fit'});

            axImageInput=uiaxes(gl);
            axImageInput.Layout.Row=1;
            axImageInput.Layout.Column=1:2;

            axLeftVFImage=uiaxes(gl);
            axLeftVFImage.Layout.Row=2;
            axLeftVFImage.Layout.Column=1;

            axLeftVFPlot=uiaxes(gl);
            axLeftVFPlot.Layout.Row=2;
            axLeftVFPlot.Layout.Column=2;

            axRightVFImage=uiaxes(gl);
            axRightVFImage.Layout.Row=3;
            axRightVFImage.Layout.Column=1;

            axRightVFPlot=uiaxes(gl);
            axRightVFPlot.Layout.Row=3;
            axRightVFPlot.Layout.Column=2;

            axAllGAWplots=uiaxes(gl);
            axAllGAWplots.Layout.Row=4;
            axAllGAWplots.Layout.Column=1:2;

            

            sampleRateLabel=uilabel(gl,"Text",'Use this sample rate:','WordWrap','on','HorizontalAlignment','right');
            sampleRateLabel.Layout.Row=5;
            sampleRateLabel.Layout.Column=1;

            importFs=20000;

            sampleRateEditField=uieditfield(gl,'numeric','Limits',[1 inf],'Value',importFs,'RoundFractionalValues','on','ValueDisplayFormat','%i Hz','HorizontalAlignment','left');
            sampleRateEditField.Layout.Row=5;
            sampleRateEditField.Layout.Column=2;

            applyButton=uibutton(gl,'Text','Apply','ButtonPushedFcn',@closeAndApply);
            applyButton.Layout.Row=6;
            applyButton.Layout.Column=2;

            closedByApply=0;


            function closeAndApply(~,~)
                closedByApply=1;
                importFs=sampleRateEditField.Value;

                close(fig);


            end




            data=imread(currFile);
            
            image(axImageInput,data); title(axImageInput,'input image');

            if mod(size(data,1),2)==1
                leftIdx=1:((size(data,1)-1)/2);
                rightIdx=((size(data,1)-1)/2+1):size(data,1);
            else
                leftIdx=1:size(data,1)/2;
                rightIdx=(size(data,1)/2+1):size(data,1);
            end

            leftData=data(leftIdx,:,:);

            rightData=data(rightIdx,:,:);


            image(axLeftVFImage,leftData); title(axLeftVFImage,'left (upper part)');
            image(axRightVFImage,flipud(rightData)); title(axRightVFImage,'right (lower part)');

            if size(data,3)==3
                rightGAW=sum(rightData(:,:,1))-sum(leftData(:,:,3));
                leftGAW=sum(leftData(:,:,1))-sum(rightData(:,:,3)); % the blue colors indicate that the edge of the VF goes on the other side of the midline. as consequence the other VF must be farer away from the midline at the same vertical position, but it has some offset value, making the color value higher.
            else
                rightGAW=sum(rightData(:,:,1));
                leftGAW=sum(leftData(:,:,1));
            end

            plot(axRightVFPlot,rightGAW,'DisplayName','right');
            plot(axLeftVFPlot,leftGAW,'DisplayName','left');

            plot(axAllGAWplots,rightGAW,'DisplayName','right');
            hold(axAllGAWplots,'on');
            plot(axAllGAWplots,leftGAW,'DisplayName','left');
            plot(axAllGAWplots,leftGAW+rightGAW,'DisplayName','sum');
            hold(axAllGAWplots,'off');
            legend(axAllGAWplots);

            gawdata=[leftGAW(:) rightGAW(:) leftGAW(:)+rightGAW(:)];


            

            linkprop([axLeftVFPlot axRightVFPlot axAllGAWplots axLeftVFImage axRightVFImage axImageInput],'XLim');
            linkprop([axLeftVFPlot axRightVFPlot],'YLim');


            %linkaxes([axLeftVFImage axRightVFImage axImageInput],'x');
            %drawnow;
            %axis([axLeftVFImage axRightVFImage axImageInput],'tight');


            waitfor(fig);

           

            
        end
        
        function openAaltoAparat(app,channelNr)

            y=app.channelYValues{channelNr};
            t=app.channelXValues{channelNr};
            fs=app.channelSampleRates(channelNr);

            excerpt=t>=app.SelectedAreaStartEditField.Value & t<=app.SelectedAreaEndEditField.Value;
            y=y(excerpt);
            t=t(excerpt);

            if ~isdeployed
                addpath('InverseFilteringMethods\AaltoAparat\');
            end

            settingsfig=aparat();

            % settingsfig.Children :
            % 1 UIControl    (text26)
            % 2 UIControl    (popupmenuIFmethod)
            % 3 Panel        (uipanel1)
            % 4 Menu         (menu_Help)
            % 5 Menu         (menu_Window)
            % 6 UIControl    (text20)
            % 7 UIControl    (listFiles)
            % 8 Panel        (IAIFsettings)
            % 9 Panel        (QCPsettings)
            %10 Menu         (menu_Options)
            %11 Menu         (menu_File)

            % 6 is "files" text, 7 the box to choose the file. we set only visibility
            % instead of deletion
            set(settingsfig.Children([6 7 10 11]),'Visible','off');

            settingsfig.Children(3).Position([1 3])=settingsfig.Children(9).Position([1 3]);

            if isfile('wavFileForApparat.wav')
                delete('wavFileForApparat.wav');
            end
            audiowrite('wavFileForApparat.wav',y,fs,'BitsPerSample',64);

            listfilesObj=settingsfig.Children(7);

            sigfig=findall(0,'type','figure','HandleVisibility','callback');
            set(sigfig,'HandleVisibility','on');

            % sigfig.Children
            % 01 UIControl    (pushbuttonSaveWav)
            % 02 UIControl    (pushbuttonSave)
            % 03 Panel        (panelMeta)
            % 04 Panel        (panelSelection)
            % 05 Panel        (panelSignal)
            % 06 Axes         (dflowAxes)
            % 07 Axes         (flowAxes)
            % 08 Axes         (signalAxes)

            

            % hide the resample popup and text in the signal panel
            % 01 UIControl    (popupmenuResample)
            % 02 UIControl    (pushbuttonSelectAll)
            % 03 UIControl    (text2)
            % 04 UIControl    (checkFlip)
            set(sigfig.Children(5).Children([1 3]),'Visible','off');

            aparat('listFiles_Callback',listfilesObj,[],guidata(listfilesObj));

            figHandles = findall(0,'-property','Theme');
            theme(figHandles, "light");

            %% link lower two axes

            linkaxes(sigfig.Children(6:7),'x');

            %% move upper axis a bit downward to see the axtoolbar completly


            %% move the two figures side by side

            movegui(settingsfig,'west');
            

            sigfig.OuterPosition(1:2)=[sum(settingsfig.OuterPosition([1 3])) settingsfig.OuterPosition(2)];


            % set(settingsfig,'Units','normalized','OuterPosition',[0 0.25 1/3 0.5]);
            % set(sigfig,'Units','normalized','OuterPosition',[0 0.25 2/3 0.5]);


            %% we need to edit the callback of the save wav mat such that we get the data for vocaliscope
            % first to children are
            % UIControl    (pushbuttonSaveWav)
            % UIControl    (pushbuttonSave)

            sigfig.Children(1).String='Export flow';
            sigfig.Children(2).Visible='off';

            % children 6 and 7 are
            % Axes         (dflowAxes)
            % Axes         (flowAxes)

            % children 8 is the signal axis
            
            % the orange flow is
            % sigfig.Children(7).Children(1)

            

            % if settingsfig is closed, the other one is also closed
            % -> callback after exporting

            sigfig.Children(1).Callback=@(~,~) pullOutAndCloseFcn(app);

            set([sigfig settingsfig],'CloseRequestFcn',@(~,~) delete([sigfig settingsfig]));

            set(sigfig,'HandleVisibility','callback');

            function pullOutAndCloseFcn(app)
                set([sigfig settingsfig],'Visible','off');
                
                dataLine=sigfig.Children(7).Children(1);

                currentMethod=settingsfig.Children(2).String{settingsfig.Children(2).Value};
                signalFlipped = sigfig.Children(5).Children(4).Value;

                if signalFlipped
                    signalFlipped='(flipped) ';
                else
                    signalFlipped='';
                end

                % inverse filtering settings
                % settingsfig.Children(3).Children :
                % 01 UIControl    (checkCausality)
                % 02 UIControl    (pushbuttonPickLiprad)
                % 03 UIControl    (pushbuttonPickFormants)
                % 04 UIControl    (btnDecHpfreq2)
                % 05 UIControl    (btnDecHpfreq1)
                % 06 UIControl    (btnIncHpfreq2)
                % 07 UIControl    (btnIncHpfreq1)
                % 08 UIControl    (btnDecLiprad2)
                % 09 UIControl    (btnDecLiprad1)
                % 10 UIControl    (btnIncLiprad2)
                % 11 UIControl    (btnIncLiprad1)
                % 12 UIControl    (btnDecFormnum2)
                % 13 UIControl    (btnDecFormnum1)
                % 14 UIControl    (btnIncFormnum2)
                % 15 UIControl    (btnIncFormnum1)
                % 16 UIControl    (checkAutohpfreq)
                % 17 UIControl    (editHpfreq)
                % 18 UIControl    (text24)
                % 19 UIControl    (editLiprad)
                % 20 UIControl    (text5)
                % 21 UIControl    (editFormnum)
                % 22 UIControl    (textFormnum)
                nFormants=settingsfig.Children(3).Children(21).String;
                lipRadiation=settingsfig.Children(3).Children(19).String;
                lipRadiationCausality=settingsfig.Children(3).Children(1).Value;
                if lipRadiationCausality
                    lipRadiationCausality='causality checked';
                else
                    lipRadiationCausality='causality not checked';
                end
                
                hpCutFreq=settingsfig.Children(3).Children(17).String;
                %hpCutAuto=settingsfig.Children(3).Children(16).Value;

                % QCP settings % settingsfig.Children(9)
                % settingsfig.Children(9).Children
                %
                % 01 UIControl    (pushbuttonPickNramp)
                % 02 UIControl    (pushbuttonPickPQ)
                % 03 UIControl    (pushbuttonPickDQ)
                % 04 UIControl    (btnIncNramp2)
                % 05 UIControl    (btnIncPQ2)
                % 06 UIControl    (btnIncDQ2)
                % 07 UIControl    (btnIncNramp)
                % 08 UIControl    (btnIncPQ)
                % 09 UIControl    (btnIncDQ)
                % 10 UIControl    (editNramp)
                % 11 UIControl    (editPQ)
                % 12 UIControl    (editDQ)
                % 13 UIControl    (btnDecNramp)
                % 14 UIControl    (btnDecPQ)
                % 15 UIControl    (btnDecDQ)
                % 16 UIControl    (text30)
                % 17 UIControl    (text29)
                % 18 UIControl    (text28)
                % 19 UIControl    (btnDecNramp2)
                % 20 UIControl    (btnDecPQ2)
                % 21 UIControl    (btnDecDQ2)
                qcpDurationQuotient = settingsfig.Children(9).Children(12).String;
                qcpPositionQuotient = settingsfig.Children(9).Children(11).String;
                qcpRampLength       = settingsfig.Children(9).Children(10).String;

                % IAIF settings % settingsfig.Children(8)
                % settingsfig.Children(8).Children
                %
                % 01 UIControl    (btnDecG1)
                % 02 UIControl    (popupARMethod)
                % 03 UIControl    (pushbutton55)
                % 04 UIControl    (btnIncG2)
                % 05 UIControl    (btnIncG1)
                % 06 UIControl    (editG)
                % 07 UIControl    (text33)
                % 08 UIControl    (text31)
                % 09 UIControl    (btnDecG2)
                iaifModellingMethod    = settingsfig.Children(8).Children(2).String{settingsfig.Children(8).Children(2).Value};
                iaifGlottisFilterOrder = settingsfig.Children(8).Children(6).String;


                if strcmpi(currentMethod,'QCP')
                    newChannelName=sprintf('%s %s, interval %f s to %f s inverse filtered via Aalto Aparat (%s). %s formants, lip radiation %s (%s), HP with cutoff %s Hz, duration quotient %s, position quotient %s, ramp length %s samples',app.channelNames{channelNr}, signalFlipped, dataLine.XData(1),dataLine.XData(end),currentMethod, nFormants, lipRadiation, lipRadiationCausality, hpCutFreq, qcpDurationQuotient, qcpPositionQuotient,qcpRampLength);
                else
                    newChannelName=sprintf('%s %s, interval %f s to %f s inverse filtered via Aalto Aparat (%s). %s formants, lip radiation %s (%s), HP with cutoff %s Hz, modelling method %s, glottis filter order %s',app.channelNames{channelNr}, signalFlipped, dataLine.XData(1), dataLine.XData(end), currentMethod, nFormants, lipRadiation, lipRadiationCausality, hpCutFreq, iaifModellingMethod, iaifGlottisFilterOrder);
                end

                % (app,newY,newX,nameOfNewChannel,typeOfNewChannel,skipStuff)
                app.addSingleChannelData(dataLine.YData,...
                                         dataLine.XData+t(1),...
                                         newChannelName,...
                                         'Raw');

                close(settingsfig);

            end

           
        end
        
        function openInverseFilteringApp(app,channelNr)
            if ~isdeployed
                addpath(fullfile('InverseFilteringMethods','GFM-IAIF_OLAF'));
                addpath(fullfile('InverseFilteringMethods','IOP-IAIF_OLAF'));
                addpath(fullfile('InverseFilteringMethods','MCLP'))
                addpath(fullfile('InverseFilteringMethods','GFM-IAIF'));
            end

            windowClosedByApply=0;

            % Persistent settings
            persistent inverseFilteringMethod vocalTractOrder glottalSourceOrder windowLength overlap leakyIntegrationCoeff iopiaif_doHighpassFilter mclp_preemphasisCoeff mclp_thr1 mclp_thr2
            if isempty(inverseFilteringMethod)
                inverseFilteringMethod = 'GFM-IAIF';
                vocalTractOrder = 48;
                glottalSourceOrder = 3;
                windowLength = 0.03;
                overlap = 0.5;
                leakyIntegrationCoeff = 0.99;
                iopiaif_doHighpassFilter = 1;
                mclp_preemphasisCoeff=0.99;
                mclp_thr1=00.0001;
                mclp_thr2=0.00001;
            end

            fs = app.channelSampleRates(channelNr);
            y = app.channelYValues{channelNr};
            t = app.channelXValues{channelNr};

            excerpt=t>=app.SelectedAreaStartEditField.Value & t<=app.SelectedAreaEndEditField.Value;
            y=y(excerpt);
            t=t(excerpt);

            % --- Figure & GridLayout ---
            fig = uifigure('Units','normalized','Position',[0 0.25 1 0.5],'Visible','off','Name','Inverse Filtering','Theme','light');
            drawnow;
            fig.Visible = 'on';
            gl = uigridlayout(fig, [8 3], 'ColumnWidth', {'1x','fit','2x'}, 'RowSpacing', 3, 'Padding', 10);

            % --- Controls ---
            methodLabel = uilabel(gl, 'Text', 'Inverse Filtering Method', 'FontWeight', 'bold','Interpreter','tex');
            methodLabel.Layout.Row = 1; methodLabel.Layout.Column = 1;
            methodDropdown = uidropdown(gl, 'Items',{      'Glottal Flow Model-based (GFM) Iterative Adaptive Inverse Filtering (IAIF)','Iterative Optimal Pre-emphasis (IOP) Iterative Adaptive Inverse Filtering','Maximum Correntropy Linear Prediction (MCLP)'},...
                'ItemsData',                       {'GFM-IAIF',                            'IOP-IAIF', 'MCLP'}, 'Value', inverseFilteringMethod);
            methodDropdown.Layout.Row = 1; methodDropdown.Layout.Column = 2;

            vocalTractOrderLabel = uilabel(gl, 'Text', 'vocal tract order', 'FontWeight', 'bold','Interpreter','tex');
            vocalTractOrderLabel.Layout.Row = 2; vocalTractOrderLabel.Layout.Column = 1;
            vocalTractOrderEdit = uieditfield(gl,'numeric','Value',vocalTractOrder,'ValueDisplayFormat','%i','RoundFractionalValues','on','Limits',[1 100]);
            vocalTractOrderEdit.Layout.Row = 2; vocalTractOrderEdit.Layout.Column = 2;

            glottalSourceOrderLabel = uilabel(gl, 'Text', 'glottal source order', 'FontWeight', 'bold','Interpreter','tex');
            glottalSourceOrderLabel.Layout.Row = 3; glottalSourceOrderLabel.Layout.Column = 1;
            glottalSourceOrderEdit = uieditfield(gl,'numeric','Value',glottalSourceOrder,'ValueDisplayFormat','%i','RoundFractionalValues','on','Limits',[1 100]);
            glottalSourceOrderEdit.Layout.Row = 3; glottalSourceOrderEdit.Layout.Column = 2;

            hint={'GFM-IAIF proposes Glottal Order = 3 and Vocal Tract Order = 48',...
                sprintf('IOP-IAIF proposes Glottal Order = 2*round(fs/4000) and Vocal Tract Order = 2*round(fs/2000)+4. With sample rate %i it is %i and %i',fs,2*round(fs/4000),2*round(fs/2000)+4),...
                'MCLP uses Vocal Tract Order 11 in its demo file'};
            set([vocalTractOrderLabel vocalTractOrderEdit glottalSourceOrderLabel glottalSourceOrderEdit],'Tooltip',hint);

            windowLabel = uilabel(gl, 'Text', 'Window Length (s)', 'FontWeight', 'bold','Interpreter','tex');
            windowLabel.Layout.Row = 4; windowLabel.Layout.Column = 1;
            windowEdit = uieditfield(gl,'numeric','Value',windowLength,'Limits',[0.005 numel(y)/fs],'ValueDisplayFormat','%.3f');
            windowEdit.Layout.Row = 4; windowEdit.Layout.Column = 2;

            overlapLabel = uilabel(gl, 'Text', 'Overlap (% / 100)', 'FontWeight', 'bold','Interpreter','tex');
            overlapLabel.Layout.Row = 5; overlapLabel.Layout.Column = 1;
            ovverlapEdit = uieditfield(gl,'numeric','Value',overlap,'Limits',[0 0.95],'ValueDisplayFormat','%.2f');
            ovverlapEdit.Layout.Row = 5; ovverlapEdit.Layout.Column = 2;

            leakyIntegrationLabel = uilabel(gl, 'Text', 'Leaky Integration Coefficient', 'FontWeight', 'bold','Interpreter','tex');
            leakyIntegrationLabel.Layout.Row = 6; leakyIntegrationLabel.Layout.Column = 1;
            leakyIntegrationEdit = uieditfield(gl,'numeric','Value',leakyIntegrationCoeff,'Limits',[0.01 0.99],'ValueDisplayFormat','%.2f');
            leakyIntegrationEdit.Layout.Row = 6; leakyIntegrationEdit.Layout.Column = 2;

            hpCheckbox = uicheckbox(gl,'Text','Use highpass filter','Value',iopiaif_doHighpassFilter,'Visible','off');
            hpCheckbox.Layout.Row = 7; hpCheckbox.Layout.Column = [1 2];

            %%% for MCLP

            mclp_Thr1Label = uilabel(gl, 'Text', 'Algorithm Threshold 1', 'FontWeight', 'bold','Interpreter','tex','Visible','off');
            mclp_Thr1Label.Layout.Row = 6; mclp_Thr1Label.Layout.Column = 1;
            mclp_Thr1Edit = uieditfield(gl,'numeric','Value',mclp_thr1,'Limits',[0.000001 0.99],'ValueDisplayFormat','%.5f');
            mclp_Thr1Edit.Layout.Row = 6; mclp_Thr1Edit.Layout.Column = 2;

            mclp_Thr2Label = uilabel(gl, 'Text', 'Algorithm Threshold 2', 'FontWeight', 'bold','Interpreter','tex','Visible','off');
            mclp_Thr2Label.Layout.Row = 7; mclp_Thr2Label.Layout.Column = 1;
            mclp_Thr2Edit = uieditfield(gl,'numeric','Value',mclp_thr2,'Limits',[0.000001 0.99],'ValueDisplayFormat','%.5f');
            mclp_Thr2Edit.Layout.Row = 7; mclp_Thr2Edit.Layout.Column = 2;

            mclp_preemphasisLabel = uilabel(gl, 'Text', 'Preemphasis filter coefficient', 'FontWeight', 'bold','Interpreter','tex','Visible','off');
            mclp_preemphasisLabel.Layout.Row = 3; mclp_preemphasisLabel.Layout.Column = 1;
            mclp_preemphasisEdit = uieditfield(gl,'numeric','Value',mclp_preemphasisCoeff,'ValueDisplayFormat','%.3f','Limits',[0.001 0.999],'Visible','off');
            mclp_preemphasisEdit.Layout.Row = 3; mclp_preemphasisEdit.Layout.Column = 2;

            %%%

            applyBtn = uibutton(gl, 'Text', 'Apply', 'FontWeight', 'bold','Interpreter','tex');
            applyBtn.Layout.Row = 8; applyBtn.Layout.Column = 2;

            % --- Plots ---
            pnl = uipanel(gl, 'BorderType', 'none','Visible','off');
            pnl.Layout.Column = 3; pnl.Layout.Row = [1 8];
            tl = tiledlayout(pnl, 2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
            axOriginal = nexttile(tl, 1);
            plot(axOriginal,t,y); title(axOriginal,'Original Data'); xlabel(axOriginal,'Time (s)');
            axGlottalFlow = nexttile(tl, 2);
            title(axGlottalFlow,'Glottal flow','Interpreter','tex'); xlabel(axGlottalFlow,'Time (s)'); ylabel(axGlottalFlow,'Frequency (Hz)');
            linkaxes([axOriginal axGlottalFlow],'x');

            xlabel(axOriginal,'time (s)');

            glottalFlow=[];

        
            updatePitch();
            

            function updatePitch(~,~)
                    


                method = methodDropdown.Value;
                vtOrder = vocalTractOrderEdit.Value; gsOrder = glottalSourceOrderEdit.Value;
                winLen = windowEdit.Value; ovrlp = ovverlapEdit.Value;
                winSamples = round(winLen * fs);
                overlapSamples = round(ovrlp * winSamples);
                leakCoeff=leakyIntegrationEdit.Value;
                doHP=hpCheckbox.Value;
                preemph=mclp_preemphasisEdit.Value;


                %% some gui visuals
                if strcmpi(method,'GFM-IAIF')
                    set([glottalSourceOrderLabel glottalSourceOrderEdit leakyIntegrationLabel leakyIntegrationEdit],'Visible','on');
                    hpCheckbox.Visible='off';
                    set([mclp_Thr1Label mclp_Thr1Edit mclp_Thr2Label mclp_Thr2Edit mclp_preemphasisLabel mclp_preemphasisEdit],'Visible','off');

                elseif strcmpi(method,'IOP-IAIF')
                    set([glottalSourceOrderLabel glottalSourceOrderEdit leakyIntegrationLabel leakyIntegrationEdit],'Visible','on');
                    hpCheckbox.Visible='on';
                    set([mclp_Thr1Label mclp_Thr1Edit mclp_Thr2Label mclp_Thr2Edit mclp_preemphasisLabel mclp_preemphasisEdit],'Visible','off');

                elseif strcmpi(method,'MCLP')
                    set([glottalSourceOrderLabel glottalSourceOrderEdit leakyIntegrationLabel leakyIntegrationEdit],'Visible','off');
                    hpCheckbox.Visible='off';
                    set([mclp_Thr1Label mclp_Thr1Edit mclp_Thr2Label mclp_Thr2Edit mclp_preemphasisLabel mclp_preemphasisEdit],'Visible','on');

                end


                %% calculations

                % try
                    tMarks=1:(winSamples-overlapSamples):(numel(y)-winSamples+1);
                    tMarks=[tMarks; tMarks+winLen*fs-1];
                    win=hann(winSamples);

                    persistent hp oldfs% persistent variable for the hp object for reusing. of course only when the fs is the same
                    
                    dlg=uiprogressdlg(fig,"Indeterminate","on","Message","Doing inverse filtering....");

                    
                    if strcmpi(method,'GFM-IAIF')
                        %[glottalFlow,~,~,~,~] = gfmiaif_olaf(y,fs,vtOrder,gsOrder,leakCoeff,tMarks,win);
                        [a_vt,~,~] = gfmiaif(y(:),vtOrder,gsOrder,leakCoeff);
                        glottalFlow=filter(a_vt,1,y);
                    elseif strcmpi(method,'IOP-IAIF')                        
                        if isempty(hp) || (~isempty(oldfs) && fs~=oldfs)
                            [glottalFlow,~,~,~,hp,~] = iop_iaif_olaf(y,fs,vtOrder,gsOrder,leakCoeff,doHP,tMarks,[]);
                        else
                            [glottalFlow,~,~,~,hp,~] = iop_iaif_olaf(y,fs,vtOrder,gsOrder,leakCoeff,doHP,tMarks,hp);
                        end
                        oldfs=fs;
                    elseif strcmpi(method,'MCLP')
                        [a_vt1,~]=MCLP(y(:),vtOrder,mclp_Thr1Edit.Value,mclp_Thr2Edit.Value,preemph);

                        a_vt= remove_spurious_poles(a_vt1);
                        glottalFlow=filter(a_vt,1,y); %Inverse filtering

                    end

                    delete(dlg);
                    %cla(axGlottalFlow);
                    plot(axGlottalFlow, t, glottalFlow, '-');
                    ylim(axGlottalFlow, 'padded');
                    title(axGlottalFlow, ['Glottal flow (' method ')']);

                    enableDefaultInteractivity(axGlottalFlow);
                % catch ME
                %     cla(axGlottalFlow);
                %     text(0.5,0.5,['Error: ' ME.message], 'Parent',axGlottalFlow, 'HorizontalAlignment','center', 'FontSize',12);
                % end
            end

            methodDropdown.ValueChangedFcn      = @updatePitch;
            windowEdit.ValueChangedFcn    = @updatePitch;
            vocalTractOrderEdit.ValueChangedFcn    = @updatePitch;
            glottalSourceOrderEdit.ValueChangedFcn    = @updatePitch;
            ovverlapEdit.ValueChangedFcn     = @updatePitch;
            hpCheckbox.ValueChangedFcn = @updatePitch;
            applyBtn.ButtonPushedFcn   = @(src, event) saveAndClose();

            ylabel(axGlottalFlow,'Glottal flow','Interpreter','tex');
            xlabel(axGlottalFlow,'time (s)');

            drawnow; pnl.Visible='on';

            function saveAndClose()
                inverseFilteringMethod   = methodDropdown.Value;
                vocalTractOrder         = vocalTractOrderEdit.Value;
                glottalSourceOrder         = glottalSourceOrderEdit.Value;
                windowLength  = windowEdit.Value;
                overlap       = ovverlapEdit.Value;
                leakyIntegrationCoeff = leakyIntegrationEdit.Value;
                iopiaif_doHighpassFilter=hpCheckbox.Value;
                
                mclp_preemphasisCoeff=mclp_preemphasisEdit.Value;
                mclp_thr1=mclp_Thr1Edit.Value;
                mclp_thr2=mclp_Thr2Edit.Value;


                windowClosedByApply=1;
                delete(fig);
            end

            uiwait(fig);

            if ~windowClosedByApply
                return;
            end

            winSamples     = round(windowLength * fs);
            overlapSamples = round(overlap * winSamples);

            switch inverseFilteringMethod
                case 'GFM-IAIF'
                    newTitle = [app.channelNames{channelNr} ' Inverse Filtered (' inverseFilteringMethod ') ' ...
                        ', vocal tract order: ' num2str(vocalTractOrder,'%i') ', glottal source order: ' num2str(glottalSourceOrder,'%i') ...
                        ', leaky integration coefficient: ' num2str(leakyIntegrationCoeff,'%f') ...
                        ', Win:' num2str(windowLength,'%.3f s') ', Overlap:' num2str(overlap*windowLength,'%.3f s')];
                case 'IOP-IAIF'
                    if iopiaif_doHighpassFilter==1
                        newTitle = [app.channelNames{channelNr} ' Inverse Filtered (' inverseFilteringMethod ') ' ...
                            ', vocal tract order: ' num2str(vocalTractOrder,'%i') ', glottal source order: ' num2str(glottalSourceOrder,'%i') ...
                            ', leaky integration coefficient: ' num2str(leakyIntegrationCoeff,'%f') ...
                            ', Win:' num2str(windowLength,'%.3f s') ', Overlap:' num2str(overlap*windowLength,'%.3f s') ...
                            ', highpass applied'];
                    else
                        newTitle = [app.channelNames{channelNr} ' Inverse Filtered (' inverseFilteringMethod ') ' ...
                            ', vocal tract order: ' num2str(vocalTractOrder,'%i') ', glottal source order: ' num2str(glottalSourceOrder,'%i') ...
                            ', leaky integration coefficient: ' num2str(leakyIntegrationCoeff,'%f') ...
                            ', Win:' num2str(windowLength,'%.3f s') ', Overlap:' num2str(overlap*windowLength,'%.3f s') ...
                            ', highpass not applied'];
                    end
                case 'MCLP'
                    newTitle = [app.channelNames{channelNr} ' Inverse Filtered (' inverseFilteringMethod ') ' ...
                        ', vocal tract order: ' num2str(vocalTractOrder,'%i') ', threshold 1: ' num2str(mclp_thr1,'%.6f') ', threshold 2: ' num2str(mclp_thr2,'%.6f') ', pre emphasis coefficient: ' num2str(mclp_preemphasisCoeff,'%.3f')];
            end
            
            
            
            app.addSingleChannelData(glottalFlow, t, newTitle, 'Raw');


            %%% old copied from fo calculation window


        end
        
       

        function loadCustomChannelColors(app)
            filepath = fullfile(pwd,'lastCustomChannelColors.mat');
            if ~isfile(filepath), return; end
            try
                S = load(filepath,'channelColors','channelSources');
                if isequal(app.channelSourcePossibilities, S.channelSources)
                    app.customChannelColors = S.channelColors;
                    if ~isempty(app.timePlotHandles)
                        for k = 1:numel(app.channelSource)
                            idx = find(strcmp(S.channelSources,app.channelSource{k}),1);
                            if ~isempty(idx) && isvalid(app.timePlotHandles(k))
                                app.timePlotHandles(k).Color = S.channelColors(idx,:);
                            end
                        end
                    end
                end
            catch
            end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            progDialog=uiprogressdlg(app.UIFigure,'Title','Starting up....',...
                'Message','Doing some startup stuff...','Indeterminate','on');

            app.tlTime=tiledlayout(app.plottingPanel,'vertical','TileSpacing','tight','Padding','tight','Visible','on');
            app.tlSpectral=tiledlayout(app.plottingPanelSpectral,'vertical','TileSpacing','tight','Padding','tight','Visible','on');

            drawnow;
            app.TabGroup.SelectedTab=app.TimeSpectralViewTab;

            drawnow;
            app.TabGroup.SelectedTab=app.TimeViewTab;

            app.availableChannelsTable.Data={};
            app.availableChannelsTable.ColumnFormat= {[], app.channelSourcePossibilities};

            app.ResultsTab.Parent=[];

            app.loadCustomChannelColors();

            %drawnow;
            %pause(0.5);

            set([app.plottingPanelContainer app.plottingPanel app.plottingPanelContainerSpectral app.plottingPanelSpectral],'Units','normalized');
            app.plottingPanel.OuterPosition=[0 0 0.97 1];
            app.plottingPanelSpectral.OuterPosition=[0 0 0.97 1];

            drawnow;
            set(app.tlTime,'Units','normalized','OuterPosition',[0 0 1 1]);
            set(app.tlSpectral,'Units','normalized','OuterPosition',[0 0 1 1]);


            drawnow;
            set(app.UIFigure,'Units','Normalized','Position',[0 0.05 1 0.9]);
            fontsize(app.UIFigure,'Scale',1.2);


            app.titleTimer=timer('ExecutionMode','fixedSpacing','Period',1,'TimerFcn',@(~,~) app.updateChannelName()); %
            
            if ~app.batchMode
                app.titleTimer.start();
            end

            set(0, 'DefaultLineLineWidth', 1);


            if ~isdeployed
                version=getVersionFromMlapp('Vocaliscope.mlapp');
            else
                load('currentAppVersion.mat','version');
            end
            app.currentAppVersion=version;

            if isdeployed
                app.UIFigure.Name=['Vocaliscope V' app.currentAppVersion ' (running from exe)'];
            else
                app.UIFigure.Name=['Vocaliscope V' app.currentAppVersion ' (running from mlapp)'];
            end

            progDialog.Message='Preparing parallel computing...';
            app.createPoolIfNonexistent();
            delete(progDialog);

            %%% download praat % not needed anymore since we integrated praat via the
            %%% mex file
            % neededFilesForPraat='Praat.exe';
            % if ~isfile(neededFilesForPraat)
            %     answer=uiconfirm(app.UIFigure,'Praat.exe not found. Donwload it?','Praat.exe missing');
            % 
            %     if isequal(answer,'OK')
            %         success=app.downloadPraatIfNonExistent();
            %         if success
            %             disp('Praat download successfull')
            %         else % user aborted download
            %             disp('Praat download failed')
            %         end             
            %     else
            %         disp('Praat download request denied')
            % 
            %     end
            % else
            %     disp('Praat found locally')
            % end
        end

        % Menu selected function: ImportappendchanneldatafromfilesMenu
        function importDataFromFileButtonCallback(app, event)
            app.importDataFromFile();
        end

        % Button pushed function: CalculateParametersButton
        function CalculateParametersButtonPushed(app, event)
            app.calculateParameters();
        end

        % Value changed function: showngraphswithoutscrollingDropDown
        function changeNumberOfGraphsWithoutScrolling(app, event)
            app.rescaleTimeAndSpectralPlotTilesVerticallyPanel(1);
        end

        % Selection changed function: availableChannelsTable
        function changeDisplayedChannels(app, event)

            % % if there are less channels selected than before, but all of
            % % them very already plotted before
            % if numel(event.PreviousSelection)>numel(event.Selection) && all(ismember(event.Selection,event.PreviousSelection))
            %     delete(app.channelAxes(event.PreviousSelection(~ismember(event.PreviousSelection,event.Selection))));
            %     app.rescaleTimePlotTilesVerticallyPanel(0);
            %     return;
            % end

            app.refreshTimeAndSpectralPlotDataVisibility();



            % return;
            %
            %
            % persistent SelectionDebounceTimer;
            % if ~isempty(SelectionDebounceTimer) && isvalid(SelectionDebounceTimer)
            %     stop(SelectionDebounceTimer);
            % end
            % % Timer neu starten (z.B. mit 0.4 Sek. Verzögerung)
            % SelectionDebounceTimer = timer( ...
            %     'StartDelay', 0.5, ...
            %     'ExecutionMode', 'singleShot', ...
            %     'TimerFcn', @(~,~) app.refreshTimeAndSpectralPlotData());
            % start(SelectionDebounceTimer);



            %app.refreshTimeAndSpectralPlotData();
        end

        % Cell edit callback: availableChannelsTable
        function adjustDataSourceOnTableEdit(app, event)
            % when the source gets changed, also save that info in the
            % internal data source

            indices = event.Indices;
            newData = event.NewData;

            app.channelSource{indices(1)}=newData;
            ylabel(app.channelAxes(indices(1)),newData);

            app.timePlotHandles(indices(1)).Color=app.channelSourcePossibilitiesColor(ismember(app.channelSourcePossibilities,newData),:);


        end

        % Button pushed function: SelectallButton
        function SelectallButtonPushed(app, event)
            if ~isempty(app.availableChannelsTable.Data)
                app.availableChannelsTable.Selection=1:size(app.availableChannelsTable.Data,1);
                app.refreshTimeAndSpectralPlotDataVisibility();
            end
        end

        % Button pushed function: DeselectallButton
        function DeselectallButtonPushed(app, event)
            if ~isempty(app.availableChannelsTable.Data)
                app.xlimBeforeDeletion=app.channelAxes(1).XLim;
                app.availableChannelsTable.Selection=[];
                app.refreshTimeAndSpectralPlotDataVisibility();
            end
        end

        % Button pushed function: DeleteselectedsignalsButton
        function DeleteselectedsignalsButtonPushed(app, event)
            selection=app.availableChannelsTable.Selection;
            app.deleteSignals(selection);
        end

        % Selection changed function: InteractionModeButtonGroup, 
        % ...and 1 other component
        function InteractionModeButtonGroupSelectionChanged(app, event)
            if event.Source==app.InteractionModeButtonGroupSpectralTab

                % coming from spectral view interaction mode
                if contains(app.InteractionModeButtonGroupSpectralTab.SelectedObject.Text,'normal','IgnoreCase',true)
                    app.InteractionModeButtonGroup.SelectedObject=app.normalButton;
                elseif contains(app.InteractionModeButtonGroupSpectralTab.SelectedObject.Text,'Mark','IgnoreCase',true)
                    app.InteractionModeButtonGroup.SelectedObject=app.MarkAreaButton;
                else
                    app.InteractionModeButtonGroup.SelectedObject=app.MoveGraphButton;
                end

            else
                % coming from time view interaction mode
                if contains(app.InteractionModeButtonGroup.SelectedObject.Text,'normal','IgnoreCase',true)
                    app.InteractionModeButtonGroupSpectralTab.SelectedObject=app.normalButtonSpectral;
                elseif contains(app.InteractionModeButtonGroup.SelectedObject.Text,'Mark','IgnoreCase',true)
                    app.InteractionModeButtonGroupSpectralTab.SelectedObject=app.MarkAreaButtonSpectral;
                else
                    app.InteractionModeButtonGroupSpectralTab.SelectedObject=app.MoveGraphButtonSpectral;
                end

            end

            app.refreshInteractionMode();
        end

        % Button pushed function: uOupenShiftToolButton
        function uOupenShiftToolButtonPushed(app, event)
            app.openShiftTool();
        end

        % Button pushed function: UndoallshiftsButton, 
        % ...and 1 other component
        function UndoallshiftsButtonPushed(app, event)
            app.setChannelShiftToZero(1:numel(app.channelAxes));
        end

        % Button pushed function: StopSoundButton
        function StopSoundButtonPushed(app, event)
            if ~isempty(app.audioPlayerObj) %&& app.audioPlayerObj.isplaying
                stop(app.audioPlayerObj);
            end
            set(app.PlaySoundButton,'Text','Play Sound');
            delete(app.playbackPositionXLines);
            delete(app.playbackPositionXLinesSpectral);
        end

        % Button pushed function: PlaySoundButton
        function PlaySoundButtonPushed(app, event)
            if isempty(app.availableChannelsTable.Selection)
                return;
            end


            if ~isempty(app.audioPlayerObj) && isplaying(app.audioPlayerObj)
                pause(app.audioPlayerObj);
                set(app.PlaySoundButton,'Text','Resume...')
                return;
            end



            if isempty(app.audioPlayerObj) || app.audioPlayerObj.CurrentSample==1
                app.audioPlayerObj=audioplayer(app.SoundVolumeSlider.Value*app.audioPlayerData,max(app.channelSampleRates(app.availableChannelsTable.Selection)));

                app.audioPlayerObj.TimerFcn=@app.updateAudioPlayerIndicator;
                app.audioPlayerObj.StartFcn=@(~,~) delete([app.playbackPositionXLines app.playbackPositionXLinesSpectral]);
                app.audioPlayerObj.StopFcn=@(~,~) set(app.PlaySoundButton,'Text','Play Sound');

                play(app.audioPlayerObj);
            else
                resume(app.audioPlayerObj);
            end

            app.PlaySoundButton.Text='Click to pause...';
        end

        % Value changed function: weightchannelsevenlyCheckBox
        function weightchannelsevenlyCheckBoxValueChanged(app, event)
            app.createAudioPlayerData();

        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            figure(app.UIFigure); % useful e.g. if we close the window in the task view, then we jump to the app window for the confirm dialog

            answer=uiconfirm(app.UIFigure,'Do you really want to close Vocaliscope?','Confirm closing');

            if ~strcmp(answer,'OK')
                return;
            end

            if app.keepVocaliscopeSettingsOverSession~=1 && isfile("lastVocaliscopesettings.mat")
                delete('lastVocaliscopesettings.mat');
            end

            app.titleTimer.stop();

            delete(app)

        end

        % Value changed function: SelectedAreaStartEditField
        function SelectedAreaStartEditFieldValueChanged(app, event)
            if isempty(app.availableChannelsTable.Data)
                return;
            end

            if app.SelectedAreaStartEditField.Value>=app.SelectedAreaEndEditField.Value
                app.SelectedAreaEndEditField.Value=app.SelectedAreaStartEditField.Value;
            end



            % also change displayed rectangles, if displayed
            if ~isempty(app.DraggingData.CurrentRectangles)
                delete(app.DraggingData.CurrentRectangles);
                app.DraggingData.CurrentRectangles=[];

                delete(app.spectralRectangles);
                app.spectralRectangles=[];
            end

            app.DraggingData.StartX=app.SelectedAreaStartEditField.Value;
            app.DraggingData.EndX=app.SelectedAreaEndEditField.Value;
            timeRects=gobjects(1,numel(app.channelAxes));
            specRects=gobjects(1,numel(app.channelAxes));

            for rectNr=1:numel(app.channelAxes)
                % xlimits=xlim(app.channelAxes(rectNr));
                % excerpt=app.channelYValues{rectNr}(app.channelXValues{rectNr}>=xlimits(1) & app.channelXValues{rectNr}<=xlimits(2));
                % ylimits=[min(excerpt) max(excerpt)];

                ylimits=[min(app.channelYValues{rectNr}) max(app.channelYValues{rectNr})];
                ylim(app.channelAxes(rectNr),'manual');

                ylimits=ylimits+[-1 1]*app.timePlotPadPercentage*range(ylimits);
                yMin=ylimits(1);
                yMax=ylimits(2);
                timeRects(rectNr)=rectangle(app.channelAxes(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.5,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
                %app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.SelectedAreaStartEditField.Value,app.SelectedAreaDurationEditField.Value];


                yMin=min(app.spectralPlotHandles(rectNr).YData);
                yMax=max(app.spectralPlotHandles(rectNr).YData);
                specRects(rectNr)=rectangle(app.channelAxesSpectral(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.2,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');

            end
            app.DraggingData.CurrentRectangles=timeRects;
            arrayfun(@(in) uistack(in,'bottom'),app.DraggingData.CurrentRectangles);

            app.spectralRectangles=specRects;
            arrayfun(@(in) uistack(in,'top'),app.spectralRectangles);


            app.updateSelectionAreaEditFieldsLimits();


        end

        % Value changed function: SelectedAreaEndEditField
        function SelectedAreaEndEditFieldValueChanged(app, event)
            if isempty(app.availableChannelsTable.Data)
                return;
            end

            if app.SelectedAreaEndEditField.Value<=app.SelectedAreaStartEditField.Value
                app.SelectedAreaStartEditField.Value=app.SelectedAreaEndEditField.Value;
            end


            % also change displayed rectangles, if displayed
            if ~isempty(app.DraggingData.CurrentRectangles)
                delete(app.DraggingData.CurrentRectangles);
                app.DraggingData.CurrentRectangles=[];

                delete(app.spectralRectangles);
                app.spectralRectangles=[];
            end

            app.DraggingData.StartX=app.SelectedAreaStartEditField.Value;
            app.DraggingData.EndX=app.SelectedAreaEndEditField.Value;
            rectsTime=gobjects(1,numel(app.channelAxes));
            rectsSpec=gobjects(1,numel(app.channelAxes));
            for rectNr=1:numel(app.channelAxes)
                % xlimits=xlim(app.channelAxes(rectNr));
                % excerpt=app.channelYValues{rectNr}(app.channelXValues{rectNr}>=xlimits(1) & app.channelXValues{rectNr}<=xlimits(2));
                % ylimits=[min(excerpt) max(excerpt)];

                ylimits=[min(app.channelYValues{rectNr}) max(app.channelYValues{rectNr})];
                ylim(app.channelAxes(rectNr),'manual');

                ylimits=ylimits+[-1 1]*app.timePlotPadPercentage*range(ylimits);
                yMin=ylimits(1);
                yMax=ylimits(2);
                rectsTime(rectNr)=rectangle(app.channelAxes(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.5,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
                %app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.SelectedAreaStartEditField.Value,app.SelectedAreaDurationEditField.Value];


                yMin=min(app.spectralPlotHandles(rectNr).YData);
                yMax=max(app.spectralPlotHandles(rectNr).YData);
                rectsSpec(rectNr)=rectangle(app.channelAxesSpectral(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.2,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
            end
            app.DraggingData.CurrentRectangles=rectsTime;
            arrayfun(@(in) uistack(in,'bottom'),app.DraggingData.CurrentRectangles);

            app.spectralRectangles=rectsSpec;
            arrayfun(@(in) uistack(in,'top'),app.spectralRectangles);

            app.updateSelectionAreaEditFieldsLimits();


        end

        % Value changed function: SelectedAreaDurationEditField
        function SelectedAreaDurationEditFieldValueChanged(app, event)
            if isempty(app.availableChannelsTable.Data)
                return;
            end

            app.SelectedAreaEndEditField.Value=app.SelectedAreaStartEditField.Value+app.SelectedAreaDurationEditField.Value;

            % also change displayed rectangles, if displayed
            if ~isempty(app.DraggingData.CurrentRectangles)
                delete(app.DraggingData.CurrentRectangles);
                app.DraggingData.CurrentRectangles=[];

                delete(app.spectralRectangles);
                app.spectralRectangles=[];
            end

            app.DraggingData.StartX=app.SelectedAreaStartEditField.Value;
            app.DraggingData.EndX=app.SelectedAreaEndEditField.Value;
            rectsTime=gobjects(1,numel(app.channelAxes));
            rectsSpec=gobjects(1,numel(app.channelAxes));
            for rectNr=1:numel(app.channelAxes)
                % xlimits=xlim(app.channelAxes(rectNr));
                % excerpt=app.channelYValues{rectNr}(app.channelXValues{rectNr}>=xlimits(1) & app.channelXValues{rectNr}<=xlimits(2));
                % ylimits=[min(excerpt) max(excerpt)];

                ylimits=[min(app.channelYValues{rectNr}) max(app.channelYValues{rectNr})];
                ylim(app.channelAxes(rectNr),'manual');

                ylimits=ylimits+[-1 1]*app.timePlotPadPercentage*range(ylimits);
                yMin=ylimits(1);
                yMax=ylimits(2);
                rectsTime(rectNr)=rectangle(app.channelAxes(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.5,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
                %app.DraggingData.CurrentRectangles(rectNr).Position([1 3])=[app.SelectedAreaStartEditField.Value,app.SelectedAreaDurationEditField.Value];

                yMin=min(app.spectralPlotHandles(rectNr).YData);
                yMax=max(app.spectralPlotHandles(rectNr).YData);
                rectsSpec(rectNr)=rectangle(app.channelAxesSpectral(rectNr), ...
                    'Position', [app.DraggingData.StartX, yMin, app.DraggingData.EndX-app.DraggingData.StartX, yMax - yMin], ...
                    'FaceColor', [0.8, 0.8, 1, 0.5], ...
                    'FaceAlpha',0.2,...
                    'EdgeColor', 'none', ...
                    'PickableParts', 'none');
            end
            app.DraggingData.CurrentRectangles=rectsTime;
            arrayfun(@(in) uistack(in,'bottom'),app.DraggingData.CurrentRectangles);

            app.spectralRectangles=rectsSpec;
            arrayfun(@(in) uistack(in,'top'),app.spectralRectangles);

            app.updateSelectionAreaEditFieldsLimits();
        end

        % Value changed function: HidecyclesbordersButton
        function HidecyclesbordersButtonValueChanged(app, event)
            value = app.HidecyclesbordersButton.Value;

            if ~isempty(app.cycleBorderHandles)
                if value==1
                    set(app.cycleBorderHandles(app.isvalidhandle(app.cycleBorderHandles)),'Visible','off');
                else
                    set(app.cycleBorderHandles(app.isvalidhandle(app.cycleBorderHandles)),'Visible','on');
                end


            end

        end

        % Cell selection callback: parameterResultsUITable
        function parameterResultsUITableCellSelection(app, event)
            if isempty(event.Indices)
                return;
            end

            % first style is the centered style of columns 2 and 3. keep
            % that one
            numOfStyles=size(app.parameterResultsUITable.StyleConfigurations,1);
            if numOfStyles>1
                removeStyle(app.parameterResultsUITable,2:numOfStyles);
            end

            % Get the selected row and first column value
            selectedRow = event.Indices(1);
            selectedValue = app.parameterResultsUITable.Data{selectedRow, 1};

            matchRows = cellfun(@(x) isequal(x, selectedValue), app.parameterResultsUITable.Data(:, 1)); % Matches in first column
            %nonMatchRows = ~matchRows; % Complement of matching rows

            % Define styles
            highlightedStyle = uistyle('BackgroundColor', 'yellow');
            %defaultStyle = uistyle('BackgroundColor', 'white');

            % Apply styles in two calls
            addStyle(app.parameterResultsUITable, highlightedStyle, 'row', find(matchRows)); % Apply to matching rows



            % to remove that weird color
            %app.parameterResultsUITable.Selection=[];
        end

        % Menu selected function: CopyleftclickedCellMenu
        function CopyleftclickedCellMenuSelected(app, event)
            if isempty(app.ResultsTab.Parent) || isempty(app.parameterResultsUITable.Selection)
                return;
            end
            clipboard("copy",app.parameterResultsUITable.Data{app.parameterResultsUITable.Selection(1),app.parameterResultsUITable.Selection(2)});

            h=msgbox('Copied to Clipboard successfully...','Success','help');
            pause(1);
            if isvalid(h)
                close(h);
            end
        end

        % Button pushed function: SaveResultsButton
        function SaveResultsButtonPushed(app, event)
            app.saveResults();

        end

        % Value changed function: HideOQareasButton
        function HideOQareasButtonValueChanged(app, event)
            value = app.HideOQareasButton.Value;

            if ~isempty(app.cycleOQHandle)
                if value==1
                    set(app.cycleOQHandle(ishandle(app.cycleOQHandle)),'Visible','off');
                else
                    set(app.cycleOQHandle(ishandle(app.cycleOQHandle)),'Visible','on');
                end
            end

            if value==1
                app.HideOQareasButton.Text='OQ areas are hidden';
            else
                app.HideOQareasButton.Text='Hide OQ areas';
            end
        end

        % Value changed function: ClQareasarehiddenButton
        function ClQareasarehiddenButtonValueChanged(app, event)
            value = app.ClQareasarehiddenButton.Value;

            if ~isempty(app.cycleOQHandle)
                if value==1
                    set(app.cycleClQHandle(ishandle(app.cycleClQHandle)),'Visible','off');
                else
                    set(app.cycleClQHandle(ishandle(app.cycleClQHandle)),'Visible','on');
                end
            end

            if value==1
                app.ClQareasarehiddenButton.Text='ClQ areas are hidden';
            else
                app.ClQareasarehiddenButton.Text='Hide ClQ areas';
            end
        end

        % Menu selected function: SelectallMenu
        function SelectallMenuSelected(app, event)
            if ~isempty(app.availableChannelsTable.Data) && ~isequal(app.availableChannelsTable.Selection,1:size(app.availableChannelsTable.Data,1))
                app.availableChannelsTable.Selection=1:size(app.availableChannelsTable.Data,1);
                app.refreshTimeAndSpectralPlotDataVisibility();
            end
        end

        % Menu selected function: to1multichannelMenu
        function to1multichannelMenuSelected(app, event)
            if size(app.availableChannelsTable.Data,1)==0
                return;
            end

            toMultiChannel=1;
            selectedChannelsOnly=0;
            path=app.exportChannelsToWAV(toMultiChannel,selectedChannelsOnly);

            if ~isequal(path,0)
                uialert(app.UIFigure,'WAV(s) saved successfully.','Success','Icon','success');
            end
        end

        % Menu selected function: tomultiplesinglechannelMenu
        function tomultiplesinglechannelMenuSelected(app, event)
            if size(app.availableChannelsTable.Data,1)==0
                return;
            end

            toMultiChannel=0;
            selectedChannelsOnly=0;
            app.exportChannelsToWAV(toMultiChannel,selectedChannelsOnly);
            uialert(app.UIFigure,'WAV(s) saved successfully.','Success','Icon','success');

        end

        % Menu selected function: to1multichannelMenu_2
        function to1multichannelMenu_2Selected(app, event)
            if size(app.availableChannelsTable.Data,1)==0
                return;
            end

            toMultiChannel=1;
            selectedChannelsOnly=1;
            app.exportChannelsToWAV(toMultiChannel,selectedChannelsOnly);
            uialert(app.UIFigure,'WAV(s) saved successfully.','Success','Icon','success');

        end

        % Menu selected function: tomultiplesinglechannelMenu_2
        function tomultiplesinglechannelMenu_2Selected(app, event)
            if size(app.availableChannelsTable.Data,1)==0
                return;
            end

            toMultiChannel=0;
            selectedChannelsOnly=1;
            app.exportChannelsToWAV(toMultiChannel,selectedChannelsOnly);
            uialert(app.UIFigure,'WAV(s) saved successfully.','Success','Icon','success');

        end

        % Menu selected function: copyMenu
        function CopywindowdatafromrowofleftclickedcellMenuSelected(app, event)

            app.RowWindowdataMenu.Enable="on";
            app.copycompleterowMenu.Enable="on";
            if ~isempty(event.InteractionInformation.Row)% && ~isempty(event.InteractionInformation.Column)
                rowNumber=event.InteractionInformation.Row;
            elseif ~isempty(app.parameterResultsUITable.Selection(1))
                rowNumber=app.parameterResultsUITable.Selection(1);
            else
                app.RowWindowdataMenu.Enable="off";
                app.copycompleterowMenu.Enable="off";

            end


            completeRow=cell2mat(app.parameterResultsUITable.Data(app.parameterResultsUITable.Selection(1),10:end-1));

            clipboard("copy",completeRow);

            h=msgbox('Copied successfully...','Success','help');
            pause(1);
            if isvalid(h)
                close(h);
            end
        end

        % Menu selected function: plotMenu
        function PlotwindowdatafromrowofleftclickedcellMenuSelected(app, event)
            completeRow=cell2mat(app.parameterResultsUITable.Data(app.parameterResultsUITable.Selection(1),10:end-1));

            figure('Theme','light'); tl=tiledlayout(2,1);
            ax1=nexttile(tl,1);
            middleOfWindows=(app.calculationResults.windowStartTimes+app.calculationResults.windowEndTimes)/2;
            %plot(ax1,linspace(app.calculationResults.selectionStart,app.calculationResults.selectionEnd,numel(completeRow)),completeRow);

            if isscalar(completeRow)
                marker='o';
            else
                marker='none';
            end

            plot(ax1,middleOfWindows,completeRow,'Marker',marker);
            title(ax1,app.parameterResultsUITable.Data{app.parameterResultsUITable.Selection(1),2},'Interpreter','none');


            ax2=nexttile(tl,2);
            sourceNr=app.currentResultsTableChannelSourcesFiltered(app.parameterResultsUITable.Selection(1));
            sourceYData=app.channelYValues{sourceNr};
            sourceXData=app.channelXValues{sourceNr};

            %excerpt=sourceXData>=app.calculationResults.selectionStart & sourceXData<=app.calculationResults.selectionEnd;
            excerpt=sourceXData>=app.calculationResults.windowStartTimes(1) & sourceXData<=app.calculationResults.windowEndTimes(end);
            sourceYData=sourceYData(excerpt);
            sourceXData=sourceXData(excerpt);
            plot(ax2,sourceXData,sourceYData);
            title(ax2,{'source data',app.parameterResultsUITable.Data{app.parameterResultsUITable.Selection(1),1}},'Interpreter','none');

            linkaxes([ax1 ax2],'x');


            xlabel(tl,'time (s)')


            ylim([ax1 ax2],'padded');

            %nexttile(tl,2); plot()
        end

        % Menu selected function: withoutcolumnheaderMenu
        function withoutcolumnheaderMenuSelected(app, event)
            copyHeader=0;
            app.copyCompleteRowToClipboard(copyHeader);
        end

        % Menu selected function: withcolumnheaderMenu
        function withcolumnheaderMenuSelected(app, event)
            copyHeader=1;
            app.copyCompleteRowToClipboard(copyHeader);
        end

        % Context menu opening function: ParameterResultsTableContextMenu
        function ParameterResultsTableContextMenuOpening(app, event)
            app.RowWindowdataMenu.Enable="on";
            app.copycompleterowMenu.Enable="on";
            if ~isempty(event.InteractionInformation.DisplayRow) && ~isempty(event.InteractionInformation.DisplayColumn)
                app.parameterResultsUITable.Selection=[event.InteractionInformation.DisplayRow event.InteractionInformation.DisplayColumn];
            elseif ~isempty(app.parameterResultsUITable.Selection) && ~isempty(event.InteractionInformation.DisplayColumn)
                app.parameterResultsUITable.Selection(2)=event.InteractionInformation.DisplayColumn;
            elseif ~isempty(app.parameterResultsUITable.Selection) && ~isempty(event.InteractionInformation.DisplayRow)
                app.parameterResultsUITable.Selection(1)=event.InteractionInformation.DisplayRow;
            else
                app.RowWindowdataMenu.Enable="off";
                app.copycompleterowMenu.Enable="off";
            end

            % app.parameterResultsUITable.Enable='inactive';
            % drawnow;
            % app.parameterResultsUITable.Enable='on';
            % drawnow;
            % scroll(app.parameterResultsUITable,'cell',app.parameterResultsUITable.Selection);
            %
            % disp('scroll position'); disp(app.parameterResultsUITable.Selection);
            %% select also all rows of the same source
            numOfStyles=size(app.parameterResultsUITable.StyleConfigurations,1);
            if numOfStyles>1
                removeStyle(app.parameterResultsUITable,2:numOfStyles);
            end

            % Get the selected row and first column value
            selectedRow = app.parameterResultsUITable.Selection(1);
            selectedValue = app.parameterResultsUITable.DisplayData{selectedRow, 1};

            matchRows = cellfun(@(x) isequal(x, selectedValue), app.parameterResultsUITable.Data(:, 1)); % Matches in first column

            % Define styles
            highlightedStyle = uistyle('BackgroundColor', 'yellow');

            % Apply styles in two calls
            addStyle(app.parameterResultsUITable, highlightedStyle, 'row', find(matchRows)); % Apply to matching rows


            %% mark the selected cell


            if size(app.parameterResultsUITable.StyleConfigurations,1)>2
                removeStyle(app.parameterResultsUITable,3);
            end
            addStyle(app.parameterResultsUITable,uistyle("BackgroundColor", [0 0.7 1]),'cell',app.parameterResultsUITable.Selection);
            drawnow;
        end

        % Button pushed function: InvertselectionButton
        function InvertselectionButtonPushed(app, event)
            if size(app.availableChannelsTable.Data,1)==0
                return;
            end

            app.availableChannelsTable.Selection=find(~ismember(1:size(app.availableChannelsTable.Data,1),app.availableChannelsTable.Selection));
            app.refreshTimeAndSpectralPlotDataVisibility();
        end

        % Size changed function: plottingPanelContainer
        function plottingPanelContainerSizeChanged(app, event)
            persistent debounceTimer;

            if ~isempty(debounceTimer) && isvalid(debounceTimer)
                stop(debounceTimer);
            else
                debounceTimer=timer("ExecutionMode","singleShot",'StartDelay',0.5,'TimerFcn',@(~,~) set(app.tlTime,'OuterPosition',[0 0 1 1]));
            end


            start(debounceTimer)


        end

        % Menu selected function: PianoMenu
        function PianoMenuSelected(app, event)
            persistent pianoFig

            if isempty(pianoFig) || ~isvalid(pianoFig)
                pianoFig=pianoGUI();
            else
                figure(pianoFig);
            end
        end

        % Menu selected function: 
        % SavechannelnamessourcetypesandselectedareatoFileMenu
        function SavechannelnamessourcetypesandselectedareatoFileMenuSelected(app, event)
            app.saveChannelNamesTypesAndSelectedArea();
        end

        % Menu selected function: 
        % LoadchannelnamessourcetypesandselectedareafromFileMenu
        function LoadchannelnamessourcetypesandselectedareafromFileMenuSelected(app, event)
            app.loadChannelNamesTypesAndSelectedArea();
        end

        % Menu selected function: IncreasepressMenu
        function IncreasepressMenuSelected(app, event)
            fontsize(app.UIFigure,'increase');
        end

        % Menu selected function: DecreasepressMenu
        function DecreasepressMenuSelected(app, event)
            fontsize(app.UIFigure,'decrease');
        end

        % Button pushed function: DeletenonselectedsignalsButton
        function DeletenonselectedsignalsButtonPushed(app, event)
            selection=1:numel(app.channelAxes);
            selection(app.availableChannelsTable.Selection)=[];
            app.deleteSignals(selection);
        end

        % Key press function: UIFigure
        function UIFigureKeyPress(app, event)

            if strcmp(event.Character,'+')
                fontsize(app.UIFigure,'increase');
            elseif strcmp(event.Character,'-')
                fontsize(app.UIFigure,'decrease');
            elseif strcmpi(event.Character,'o')
                app.openShiftTool();
            end


        end

        % Menu selected function: ShowSelectionEvaluationsMenu
        function ShowSelectionEvaluationsMenuSelected(app, event)
            app.ShowSelectionEvaluationsMenu.Checked='on';
            app.HideSelectionEvaluationsMenu.Checked="off";
            set(app.selectionEvaluationTexts,'Visible','on');

        end

        % Menu selected function: HideSelectionEvaluationsMenu
        function HideSelectionEvaluationsMenuSelected(app, event)
            app.HideSelectionEvaluationsMenu.Checked='on';
            app.ShowSelectionEvaluationsMenu.Checked="off";
            set(app.selectionEvaluationTexts,'Visible','off');

        end

        % Menu selected function: ShowMaxMenu, ShowMeanMenu, 
        % ...and 4 other components
        function SelectionCalculationsSelectedParametersChanged(app, event)
            if strcmp(event.Source.Checked,'on')
                event.Source.Checked='off';
            else
                event.Source.Checked='on';
            end

            app.refreshSelectionEvaluationText();
        end

        % Menu selected function: LagEstimatorofselectionMenu
        function LagEstimatorofselectionMenuSelected(app, event)
            if numel(app.channelAxes)<2
                return;
            end

            lagEstimationFig=uifigure("NumberTitle","off",'Name','Lag Estimator','Position',[100 100 900 700],'Theme','light');

            gl=uigridlayout(lagEstimationFig,[7 4],'Padding',[0 0 0 0],'RowSpacing',5,'ColumnSpacing',5,'RowHeight',{'1x' '1x' '1x' '3x' '3x' '3x' '1x'});

            signal1DropdownLabel=uilabel(gl,"Text",'1. signal');
            signal1DropdownLabel.Layout.Row=1;
            signal1DropdownLabel.Layout.Column=1;

            signal1Dropdown=uidropdown(gl,"Items",app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes));
            signal1Dropdown.Layout.Row=2;
            signal1Dropdown.Layout.Column=1;

            signal2DropdownLabel=uilabel(gl,"Text",'2. signal');
            signal2DropdownLabel.Layout.Row=1;
            signal2DropdownLabel.Layout.Column=2;

            signal2Dropdown=uidropdown(gl,"Items",app.shortenNames(app.channelNames),'ItemsData',1:numel(app.channelAxes),'Value',2);
            signal2Dropdown.Layout.Row=2;
            signal2Dropdown.Layout.Column=2;

            alignMethodDropdownLabel=uilabel(gl,"Text",'Estimation Method');
            alignMethodDropdownLabel.Layout.Row=1;
            alignMethodDropdownLabel.Layout.Column=3;

            persistent lastMethod lastLowerBound lastUpperBound doInvert;

            alignMethodDropdown=uidropdown(gl,"Items",{'Cross Correlation' 'Generalized Cross Correlation'},'ItemsData',{'xcorr' 'gcc'});
            alignMethodDropdown.Layout.Row=2;
            alignMethodDropdown.Layout.Column=3;

            if ~isempty(lastMethod)
                alignMethodDropdown.Value=lastMethod;
            end

            minimumLagEditFieldLabel=uilabel(gl,'Text','Minimum absolute lag for seach (s)','WordWrap','on');
            minimumLagEditFieldLabel.Layout.Row=3;
            minimumLagEditFieldLabel.Layout.Column=1;

            minimumLagEditField=uieditfield(gl,'numeric','Limits',[0 inf],'Value',0.01,'ValueDisplayFormat','%g s');
            minimumLagEditField.Layout.Row=3;
            minimumLagEditField.Layout.Column=2;

            if ~isempty(lastLowerBound)
                minimumLagEditField.Value=lastLowerBound;
            end

            maximumLagEditFieldLabel=uilabel(gl,'Text','Maximum absolute lag for seach (s)','WordWrap','on');
            maximumLagEditFieldLabel.Layout.Row=3;
            maximumLagEditFieldLabel.Layout.Column=3;

            maximumLagEditField=uieditfield(gl,'numeric','Limits',[0 inf],'Value',1,'ValueDisplayFormat','%g s');
            maximumLagEditField.Layout.Row=3;
            maximumLagEditField.Layout.Column=4;

            if ~isempty(lastUpperBound)
                maximumLagEditField.Value=lastUpperBound;
            end

            invertSignal2Checkbox=uicheckbox(gl,"Value",0,"Text",'invert signal 2');
            invertSignal2Checkbox.Layout.Row=2;
            invertSignal2Checkbox.Layout.Column=4;

            if ~isempty(doInvert)
                invertSignal2Checkbox.Value=doInvert;
            end


            plotsPanel=uipanel(gl,"Title",'','BorderType','none');
            plotsPanel.Layout.Row=[4 6];
            plotsPanel.Layout.Column=[1 4];

            copyAsMsButton=uibutton(gl,'Text','Copy shift as ms');
            copyAsMsButton.Layout.Row=7;
            copyAsMsButton.Layout.Column=1;
            copyAsMsButton.UserData.value='0';
            copyAsMsButton.ButtonPushedFcn=@copyAndSuccessFcn;

            copyAsSButton=uibutton(gl,'Text','Copy shift as s');
            copyAsSButton.Layout.Row=7;
            copyAsSButton.Layout.Column=2;
            copyAsSButton.UserData.value='0';
            copyAsSButton.ButtonPushedFcn=@copyAndSuccessFcn;

            copyAsSamplesButton=uibutton(gl,'Text','Copy shift as samples');
            copyAsSamplesButton.Layout.Row=7;
            copyAsSamplesButton.Layout.Column=3;
            copyAsSamplesButton.UserData.value='0';
            copyAsSamplesButton.ButtonPushedFcn=@copyAndSuccessFcn;

            copyStateLabel=uilabel(gl,'Text','','WordWrap','on','FontColor','red');
            copyStateLabel.Layout.Row=7;
            copyStateLabel.Layout.Column=4;


            tl=tiledlayout(plotsPanel,3,1,"Padding","tight","TileSpacing","compact");
            axOriginal=nexttile(tl,1);
            axLags=nexttile(tl,2);
            axAligned=nexttile(tl,3);

            linkaxes([axOriginal axAligned]);

            set([signal1Dropdown signal2Dropdown alignMethodDropdown minimumLagEditField maximumLagEditField invertSignal2Checkbox],'ValueChangedFcn',@(~,~) refreshLagPlot(app));

            refreshLagPlot(app);

            function refreshLagPlot(app)
                signal1=app.channelYValues{signal1Dropdown.Value}(:);
                signal2=app.channelYValues{signal2Dropdown.Value}(:);

                if invertSignal2Checkbox.Value==1
                    signal2=-signal2;
                end

                fs1=app.channelSampleRates(signal1Dropdown.Value);
                fs2=app.channelSampleRates(signal2Dropdown.Value);


                % if there is a part selected, we analyze only the
                % selection
                if ~isempty(app.DraggingData.StartX)
                    signal1=signal1(app.channelXValues{signal1Dropdown.Value}>=app.DraggingData.StartX & app.channelXValues{signal1Dropdown.Value}<=app.DraggingData.EndX);
                    signal2=signal2(app.channelXValues{signal2Dropdown.Value}>=app.DraggingData.StartX & app.channelXValues{signal2Dropdown.Value}<=app.DraggingData.EndX);
                end

                % remove mean for correlation analysis
                signal1=signal1-mean(signal1);
                signal2=signal2-mean(signal2);

                % check if equal sampling frequency, if not, upsample
                % signal with lower sampling frequency
                if fs1~=fs2
                    [maxFs,idx]=max([fs1 fs2]);

                    if idx==1
                        signal2=resample(signal2,maxFs,fs2);
                    else
                        signal1=resample(signal1,maxFs,fs1);
                    end
                else
                    maxFs=fs1;
                end

                % pad shorter signal if signals do not have equal length
                if numel(signal1)>numel(signal2)
                    signal2=[signal2;zeros(abs(numel(signal1)-numel(signal2)),1)];
                elseif numel(signal1)<numel(signal2)
                    signal1=[signal1;zeros(abs(numel(signal1)-numel(signal2)),1)];

                end

                plot(axOriginal,(1:numel(signal1))./maxFs,rescale(signal1,-1, 1),'DisplayName','signal 1');
                hold(axOriginal,'on');
                plot(axOriginal,(1:numel(signal2))./maxFs,rescale(signal2,-1, 1),'DisplayName','signal 2');
                hold(axOriginal,'off');

                legend(axOriginal);

                % calculate correlation either with normal xcorr or GCC
                if strcmpi(alignMethodDropdown.Value,'xcorr')
                    [corrVal,lag]=xcorr(signal1,signal2);
                else
                    [~, corrVal, lag] = gccphat(signal1,signal2,1);
                    % Output: bestLag (seconds), corrVal (amplitude), lagMS (seconds)

                    corrVal=abs(corrVal);

                end



                plot(axLags,lag/maxFs,corrVal,'k');
                title(axLags,'Lag of signal 1 in reference to signal 2');
                xlabel(axLags,'lag (s)');

                limits=[-1 1]*maximumLagEditField.Value;

                xls=xline(axLags,[-maximumLagEditField.Value maximumLagEditField.Value minimumLagEditField.Value -minimumLagEditField.Value],'LineStyle','--','Color','r');
                arrayfun(@(in) uistack(in,'bottom'),xls);

                xlim(axLags,limits+[-1 1]*0.1*range(limits));

                corrVal((abs(lag)/maxFs)<minimumLagEditField.Value | (abs(lag)/maxFs)>maximumLagEditField.Value)=0;

                [~,bestLagIdx]=max(abs(corrVal));

                bestLag=lag(bestLagIdx);

                % delay 'earlier' signal
                if bestLag>0
                    signal2=[zeros(abs(bestLag),1);signal2];
                else
                    signal1=[zeros(abs(bestLag),1);signal1];
                end

                plot(axAligned,(1:numel(signal1))./maxFs,rescale(signal1,-1, 1),'DisplayName','signal 1');
                hold(axAligned,'on');
                plot(axAligned,(1:numel(signal2))./maxFs,rescale(signal2,-1, 1),'DisplayName','signal 2');
                hold(axAligned,'off');
                legend(axAligned);

                if bestLag>0
                    title(axAligned,sprintf('Added lag to signal 2: %i samples or %f s',abs(bestLag),abs(bestLag)/maxFs));
                else
                    title(axAligned,sprintf('Added lag to signal 1: %i samples or %f s',abs(bestLag),abs(bestLag)/maxFs));
                end

                copyAsMsButton.UserData.value=num2str(abs(bestLag)/maxFs*1000,'%.2f');
                copyAsSButton.UserData.value=num2str(abs(bestLag)/maxFs,'%.2f');
                copyAsSamplesButton.UserData.value=num2str(abs(bestLag),'%i');

                lastMethod=alignMethodDropdown.Value;
                lastLowerBound=minimumLagEditField.Value;
                lastUpperBound=maximumLagEditField.Value;
                doInvert=invertSignal2Checkbox.Value;
            end

            function copyAndSuccessFcn(src,~)
                clipboard("copy",src.UserData.value);
                copyStateLabel.Text='Copied successfully to clipboard!';
                pause(1);
                copyStateLabel.Text='';

            end

        end

        % Callback function: CasesensitiveCheckBox, ChannelnameCheckBox, 
        % ...and 3 other components
        function FilterResultsTableEditFieldValueChanging(app, event)
            app.filterParameterResultsTable(event.Value);
        end

        % Button pushed function: choosesettingsandrecalculatespectraButton
        function choosesettingsandrecalculatespectraButtonPushed(app, event)

            if numel(app.channelAxes)==0
                return;
            end

            fig=uifigure('Name','Spectrum recalculation settings','Units','normalized','Position',[0.25 0.1 0.5 0.7],'Theme','light');

            gl=uigridlayout(fig,[6 2],"ColumnSpacing",5,"RowSpacing",5,'ColumnWidth',{'fit','1x'});

            minFreqLabel=uilabel(gl,"Text",'Minimum Frequency (Hz)');
            minFreqLabel.Layout.Column=1;
            minFreqLabel.Layout.Row=1;

            minFreqEditField=uieditfield(gl,'numeric','Value',app.spectrumCalculationSettings.minFreq,'Limits',[0.01 inf]);
            minFreqEditField.Layout.Column=2;
            minFreqEditField.Layout.Row=1;

            maxFreqLabel=uilabel(gl,"Text",'Maximum Frequency (Hz)');
            maxFreqLabel.Layout.Column=1;
            maxFreqLabel.Layout.Row=2;

            maxFreqEditField=uieditfield(gl,'numeric','Value',app.spectrumCalculationSettings.maxFreq,'Limits',[0.01 inf]);
            maxFreqEditField.Layout.Column=2;
            maxFreqEditField.Layout.Row=2;

            valsPerOctaveLabel=uilabel(gl,"Text",'Calculated values per octave');
            valsPerOctaveLabel.Layout.Column=1;
            valsPerOctaveLabel.Layout.Row=3;

            valsPerOctaveEditField=uieditfield(gl,'numeric','Value',app.spectrumCalculationSettings.frequencyValuesPerOctave,'Limits',[1 200]);
            valsPerOctaveEditField.Layout.Column=2;
            valsPerOctaveEditField.Layout.Row=3;

            frequencyPrecisionLabel=uilabel(gl,"Text",{'Frequency precision vs time precision' sprintf('Value: %.2f',app.spectrumCalculationSettings.spectralPrecision)});
            frequencyPrecisionLabel.Layout.Column=1;
            frequencyPrecisionLabel.Layout.Row=4;

            frequencyPrecisionSlider=uislider(gl,'Value',app.spectrumCalculationSettings.spectralPrecision,'Limits',[0.5 8],'MajorTicks',1:8,'ValueChangingFcn',@setFreqPrecVal);
            frequencyPrecisionSlider.MajorTickLabels{1}='more time precision';
            frequencyPrecisionSlider.MajorTickLabels{end}='more freqency precision';
            frequencyPrecisionSlider.MajorTickLabels(2:end-1)={''};
            frequencyPrecisionSlider.MinorTicks=frequencyPrecisionSlider.MajorTicks;
            frequencyPrecisionSlider.Layout.Column=2;
            frequencyPrecisionSlider.Layout.Row=4;

            syncSampleRateAndUpperFreqCheckbox = uicheckbox(gl,'Text','Sync requested upper frequency and cwt time resolution','Value',app.spectrumCalculationSettings.syncUpperFreqAndTimeResolution,'Tooltip','If enabled, the signal is resampled to upperFreq*2 to reduce calculation time. But this also reduces timer resolution, which might be unwanted e.g. when you are interested in low frequency content, but want high time resoltion.');
            syncSampleRateAndUpperFreqCheckbox.Layout.Column=[1 2];
            syncSampleRateAndUpperFreqCheckbox.Layout.Row=5;

            % syncUpperFreqAndTimeResolution

            refreshCalculationButton=uibutton(gl,'Text','Recalculate all spectra','ButtonPushedFcn',@setAndRecalc,'BackgroundColor',[245, 182, 66]./255);
            refreshCalculationButton.Layout.Column=2;
            refreshCalculationButton.Layout.Row=6;

            function setFreqPrecVal(~,evt)
                frequencyPrecisionLabel.Text{2}=sprintf('Value: %.2f',evt.Value);
            end

            function setAndRecalc(~,~)

                tmp.maxFreq=maxFreqEditField.Value;
                tmp.minFreq=minFreqEditField.Value;
                tmp.frequencyValuesPerOctave=valsPerOctaveEditField.Value;
                tmp.spectralPrecision=frequencyPrecisionSlider.Value;
                tmp.syncUpperFreqAndTimeResolution=syncSampleRateAndUpperFreqCheckbox.Value;

                app.spectrumCalculationSettings=tmp;

                wb=uiprogressdlg(app.UIFigure,"Cancelable","off","Indeterminate","on","Title",'In progress','Message','Recalculating spectra...');
                app.refreshSpectralPlots();

                app.refreshSelectionEvaluationText();

                delete(wb);
            end


        end

        % Menu selected function: RestartVocaliscopeMenu
        function RestartVocaliscopeMenuSelected(app, event)

            %drawnow;
            close(app.UIFigure);

            if ~isvalid(app) || ~isvalid(app.UIFigure)
                newInstance=Vocaliscope;
            end
        end

        % Menu selected function: 
        % RecalculateallmatfileswithallparametersMenu
        function RecalculateallmatfileswithallparametersMenuSelected(app, event)
            

            pathsOut=fileListApp();

            if isempty(pathsOut)
                disp('no files were selected for path processing. aborting batch process');
                return;
            end

            %%
            
            settingsApp=VocaliscopeCalculationSettings(1);
            drawnow;
            allObjs=findall(settingsApp.UIFigure,'Type','uibutton','-or','Type','uistatebutton','-or','Type','uidropdown','-or','Type','uieditfield','-or','Type','uiswitch','-or','Type','uicheckbox','-or','Type','uinumericeditfield','-or','Type','uislider');
            set(allObjs,'Enable','off');

            allObjsInTree=findall(settingsApp.ParametersTree,'-property','Enable');
            set(allObjsInTree,'Enable','on');
            settingsApp.loadSettingsfromfileButton.Enable='on';
            settingsApp.FilterParameterToCalculateEditField.Enable='on';
            settingsApp.ExpandallnodesButton.Enable='on';
            settingsApp.CollapseallnodesButton.Enable='on';
            settingsApp.CheckallButton.Enable='on';
            settingsApp.UncheckallButton.Enable='on';
            settingsApp.calculateparametersButton.Enable='on';

            cm = uicontextmenu(settingsApp.UIFigure);
            m1 = uimenu(cm,'Text','Enable and overwrite this property for all files in batch mode','MenuSelectedFcn',@(a,b)setUserDataAndEnable(a,b,1));
            m2 = uimenu(cm,'Text','Disable and use individual property for all files in batch mode','MenuSelectedFcn',@(a,b)setUserDataAndEnable(a,b,0));

            
            set(allObjs(~ismember(allObjs,[allObjsInTree settingsApp.UsemaskCheckBox settingsApp.FilterParameterToCalculateEditField settingsApp.previewcyclesButton settingsApp.ExpandallnodesButton settingsApp.CollapseallnodesButton settingsApp.CheckallButton settingsApp.UncheckallButton settingsApp.showseparateplotof1cycledurationCheckBox settingsApp.calculateparametersButton settingsApp.loadSettingsfromfileButton settingsApp.KeepSettingsoverSessionsCheckBox])),'ContextMenu',cm);

            % the preview will not be shown in batch mode, to many figures
            % then....
            settingsApp.showseparateplotof1cycledurationCheckBox.Value=0;

            % disable the callback of some buttons since those anable some
            % other buttons, but without setting the UserData Propert which
            % marks the entries to be overwritten later

            settingsApp.useUpperFoPredictionStateButton.ValueChangedFcn='';
            settingsApp.WindowedAnalysisCheckBox.ValueChangedFcn='';
            settingsApp.CyclePeakProminenceTypeSwitch.ValueChangedFcn='';

            function setUserDataAndEnable(~,MenuSelectedData,doEnable)

                if doEnable
                    MenuSelectedData.ContextObject.Enable='on';
                    MenuSelectedData.ContextObject.UserData.OverwriteSetting=true;
                else
                    MenuSelectedData.ContextObject.Enable='off';
                    MenuSelectedData.ContextObject.UserData.OverwriteSetting=false;
                end
            end
            
            waitfor(settingsApp,'outputSettings');

            if ~isvalid(settingsApp) % if window was closed via top right x

                disp('User closed parameter selection screen via X. Aborting batch mode.');
                return;
            end

           % settingForParameterSelection=settingsApp.outputSettings;

            settingsApp.saveCurrentAppState('VocaliscopesettingsForBatchMode.mat');

            delete(settingsApp);
            
            %%


            progDiag=uiprogressdlg(app.UIFigure,"Cancelable","off","Message",'Batch Mode File Progress','Value',0,'ShowPercentage','on');

            app.TabGroup.Visible="off";
            app.availableChannelsTable.Visible="off";
            app.batchMode=1;

            if isfile('batchModeLog.txt')
                delete('batchModeLog.txt');
            end
            diary('batchModeLog.txt');
            

            % this fakefig exists because when deleting the settings app, the focus
            % autmaticcaly shifts to the last uifigure, which interrupts if
            % you try to do other things while batch mode is running
            fakefig=uifigure('Units','normalized','Position',[5 5 0.01 0.01],'NumberTitle','off','Name','','CloseRequestFcn','');

            try
                % list of files and on each we want to recalculate the
                % parameters
                for fileNr=1:size(pathsOut,1)
                    disp(['starting file ' pathsOut{fileNr,1}]);

                    app.executeXLimListener=0; % have to set it in every loop since it set to 1 after loading the data
                    progDiag.Value=(fileNr-1)/size(pathsOut,1);
    
                    
    
                    probableSettingsFilename=replace([pathsOut{fileNr,1}],...
                                                    {'_channelNameTypeHistoryAndSelectedArea.mat','_fullSessionData.mat'},...
                                                    '_lastVocaliscopesettings.mat');
    
                    % if a settings file does not exist, skip!
                    if ~isfile(probableSettingsFilename)
                        disp(['skipping file ' pathsOut{fileNr,1}])
                        continue;
                    end

    
                    drawnow;
                    app.importDataFromFile([pathsOut{fileNr,1}]);

    
                    settingsApp=VocaliscopeCalculationSettings(0);

                    set(settingsApp.UIFigure,'Units','normalized','Position',[-1 1 0.01 0.01]);
    
                    settingsApp.loadAppState(probableSettingsFilename,1);


                    drawnow;

                    % overwrite checked nodes via temp settings file
                    settingsApp.loadAppState('VocaliscopesettingsForBatchMode.mat',1,1);

                    drawnow;

  

                    % when saving later the settings file is copied from
                    % lastVocaliscopeSettings
                    settingsApp.saveCurrentAppState('lastVocaliscopesettings.mat');
    
                    settingsApp.collectSettings();
    
                    app.calculationSettings=settingsApp.outputSettings;
                    app.calculationCalledAsPreview=0;
    
                    % we do not want to display the cycle block in batch mode
                    app.calculationSettings.cycleDuration.showSeparate1overCycleDurationPlot=0;
    
                    
                    %app.calculationSettings=app.setDoCalculateAccordingSecondStruct(app.calculationSettings,settingForParameterSelection);
    
                    
                    % move focus to the offscreen figure since such that
                    % deleting the setting app moved focus to the offscreen
                    % figure, which does not interrupt your work when doing
                    % something else while batch mode is running
                    figure(fakefig);
                    
                    disp('pausing before delete')
                    pause(2);
    
                    delete(settingsApp);

                    

    
                    app.calculateParameters();

    
                    if contains(pathsOut{fileNr,1},{'_channelNameTypeHistoryAndSelectedArea.mat','_fullSessionData.mat'})
                        excelFilePath=replace([pathsOut{fileNr,1}],...
                                                    {'_channelNameTypeHistoryAndSelectedArea.mat','_fullSessionData.mat'},...
                                                    '_BatchMode.xlsx');
                    else
                         excelFilePath=replace([pathsOut{fileNr,1}],...
                                                    {'.mat','.mat'},...
                                                    'BatchMode.xlsx');
                    end
    
                    app.saveResults(excelFilePath);


                    try
                        copyfile(pathsOut{fileNr,1},replace(pathsOut{fileNr,1},{'_channelNameTypeHistoryAndSelectedArea.mat','_fullSessionData.mat'},{'_BatchMode_channelNameTypeHistoryAndSelectedArea.mat','_BatchMode_fullSessionData.mat'}));
                    catch ME
                        disp(['error trying to copy ' pathsOut{fileNr,1}]);
                        disp(ME.getReport);
                        disp('skipping copying');
                    end

                    if ~isempty(app.channelAxes)
                        channelsToDelete=1:numel(app.channelAxes);
                        app.deleteSignals(channelsToDelete);
                    end
        
                end
    
                
    
                app.TabGroup.Visible="on";
                app.availableChannelsTable.Visible="on";
                delete(progDiag);
                app.batchMode=0;
                diary off;

                delete(fakefig);
                uialert(app.UIFigure,'Batch mode finished','Complete','Icon','info');

            catch ME
                app.TabGroup.Visible="on";
                app.availableChannelsTable.Visible="on";
                delete(progDiag);
                app.batchMode=0;
                diary off;

                delete(fakefig);
                rethrow(ME);

            end

            


        end

        % Menu selected function: ChangechannelcolorsMenu
        function ChangechannelcolorsMenuSelected(app, event)

            if numel(app.channelAxes) == 0
                return;
            end

            defaultColors = [  255     0.0      0.0     245   128       128            220          0.0;...
                225     130      130     130   0.0       0.0            190          0.0;...
                25     200      200      48   0.0       0.0            255          0.0]'/255;

            if ~isempty(app.customChannelColors)
                currentColors = app.customChannelColors;
            else
                currentColors = app.channelSourcePossibilitiesColor;
            end

            originalColors = currentColors;
            sourceNames = app.channelSourcePossibilities;
            nSources = numel(sourceNames);

            fig = uifigure('Name','Channel Color Settings', ...
                'Position',[100 100 420 60+nSources*45], ...
                'CloseRequestFcn',@(~,~) dismissCB());

            fig.UserData.app            = app;
            fig.UserData.defaultColors  = defaultColors;
            fig.UserData.originalColors = originalColors;
            fig.UserData.currentColors  = currentColors;
            fig.UserData.sourceNames    = sourceNames;
            fig.UserData.colorLabels    = gobjects(nSources,1);

            gl = uigridlayout(fig,[nSources+1 3]);
            gl.RowHeight    = [repmat({40},1,nSources) 40];
            gl.ColumnWidth  = {'1x','fit','1x'};
            gl.Padding      = [10 10 10 10];
            gl.RowSpacing   = 5;
            gl.ColumnSpacing = 10;

            for i = 1:nSources
                row = i;

                lbl = uilabel(gl,'Text',sourceNames{i},'FontSize',11);
                lbl.Layout.Row = row;
                lbl.Layout.Column = 1;
                lbl.HorizontalAlignment = 'right';

                colorPatch = uilabel(gl);
                colorPatch.Layout.Row = row;
                colorPatch.Layout.Column = 2;
                colorPatch.BackgroundColor = currentColors(i,:);
                colorPatch.Text = '';
                colorPatch.Tooltip = sourceNames{i};

                btn = uibutton(gl,'Text','Choose Color...');
                btn.Layout.Row = row;
                btn.Layout.Column = 3;
                idx = i;
                btn.ButtonPushedFcn = @(~,~) chooseColor(idx);

                fig.UserData.colorLabels(i) = colorPatch;
            end

            btnRow = nSources + 1;

            resetBtn = uibutton(gl,'Text','Reset to Default');
            resetBtn.Layout.Row = btnRow;
            resetBtn.Layout.Column = 1;
            resetBtn.ButtonPushedFcn = @(~,~) resetCB();

            dismissBtn = uibutton(gl,'Text','Dismiss');
            dismissBtn.Layout.Row = btnRow;
            dismissBtn.Layout.Column = 2;
            dismissBtn.ButtonPushedFcn = @(~,~) dismissCB();

            applyBtn = uibutton(gl,'Text','Apply');
            applyBtn.Layout.Row = btnRow;
            applyBtn.Layout.Column = 3;
            applyBtn.BackgroundColor = [0.2 0.6 0.2];
            applyBtn.ButtonPushedFcn = @(~,~) applyCB();

            % --- nested helpers ---------------------------------------------------

            function chooseColor(srcIdx)
                c = uisetcolor(fig.UserData.currentColors(srcIdx,:), ...
                    "Select Color for " + fig.UserData.sourceNames{srcIdx});
                if numel(c)==3
                    fig.UserData.currentColors(srcIdx,:) = c;
                    fig.UserData.colorLabels(srcIdx).BackgroundColor = c;
                    refreshPlots(fig.UserData.currentColors);
                end
            end

            function resetCB()
                fig.UserData.currentColors = fig.UserData.defaultColors;
                for j = 1:nSources
                    fig.UserData.colorLabels(j).BackgroundColor = fig.UserData.defaultColors(j,:);
                end
                refreshPlots(fig.UserData.defaultColors);
            end

            function dismissCB()
                if ~isvalid(fig), return; end
                refreshPlots(fig.UserData.originalColors);
                delete(fig);
            end

            function applyCB()
                a = fig.UserData.app;
                a.customChannelColors = fig.UserData.currentColors;
                channelColors  = fig.UserData.currentColors;
                channelSources = fig.UserData.sourceNames;
                save(fullfile(pwd,'lastCustomChannelColors.mat'), ...
                    'channelColors','channelSources');
                refreshPlots(fig.UserData.currentColors);
                delete(fig);
            end

            function refreshPlots(colors)
                a = fig.UserData.app;
                sn = fig.UserData.sourceNames;
                if isempty(a.timePlotHandles) || isempty(a.channelSource), return; end
                for k = 1:numel(a.channelSource)
                    idx = find(strcmp(sn,a.channelSource{k}),1);
                    if ~isempty(idx) && isvalid(a.timePlotHandles(k))
                        a.timePlotHandles(k).Color = colors(idx,:);
                    end
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1228 640];
            app.UIFigure.Name = 'Vocaliscope';
            app.UIFigure.Theme = 'light';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.UIFigure.KeyPressFcn = createCallbackFcn(app, @UIFigureKeyPress, true);

            % Create FileimportappendexportMenu
            app.FileimportappendexportMenu = uimenu(app.UIFigure);
            app.FileimportappendexportMenu.Text = '&File import/append/export';

            % Create ImportappendchanneldatafromfilesMenu
            app.ImportappendchanneldatafromfilesMenu = uimenu(app.FileimportappendexportMenu);
            app.ImportappendchanneldatafromfilesMenu.MenuSelectedFcn = createCallbackFcn(app, @importDataFromFileButtonCallback, true);
            app.ImportappendchanneldatafromfilesMenu.Text = '&Import/append channel data from files';

            % Create SavechanneldatatowavandmatMenu
            app.SavechanneldatatowavandmatMenu = uimenu(app.FileimportappendexportMenu);
            app.SavechanneldatatowavandmatMenu.Text = '&Save channel data to wav and mat...';

            % Create allavailablechannelsMenu
            app.allavailablechannelsMenu = uimenu(app.SavechanneldatatowavandmatMenu);
            app.allavailablechannelsMenu.Text = 'all available channels';

            % Create to1multichannelMenu
            app.to1multichannelMenu = uimenu(app.allavailablechannelsMenu);
            app.to1multichannelMenu.MenuSelectedFcn = createCallbackFcn(app, @to1multichannelMenuSelected, true);
            app.to1multichannelMenu.Text = 'to 1 multi channel';

            % Create tomultiplesinglechannelMenu
            app.tomultiplesinglechannelMenu = uimenu(app.allavailablechannelsMenu);
            app.tomultiplesinglechannelMenu.MenuSelectedFcn = createCallbackFcn(app, @tomultiplesinglechannelMenuSelected, true);
            app.tomultiplesinglechannelMenu.Text = 'to multiple single channel';

            % Create selectedchannelsonlyMenu
            app.selectedchannelsonlyMenu = uimenu(app.SavechanneldatatowavandmatMenu);
            app.selectedchannelsonlyMenu.Text = 'selected channels only';

            % Create to1multichannelMenu_2
            app.to1multichannelMenu_2 = uimenu(app.selectedchannelsonlyMenu);
            app.to1multichannelMenu_2.MenuSelectedFcn = createCallbackFcn(app, @to1multichannelMenu_2Selected, true);
            app.to1multichannelMenu_2.Text = 'to 1 multi channel';

            % Create tomultiplesinglechannelMenu_2
            app.tomultiplesinglechannelMenu_2 = uimenu(app.selectedchannelsonlyMenu);
            app.tomultiplesinglechannelMenu_2.MenuSelectedFcn = createCallbackFcn(app, @tomultiplesinglechannelMenu_2Selected, true);
            app.tomultiplesinglechannelMenu_2.Text = 'to multiple single channel';

            % Create SavechannelnamessourcetypesandselectedareatoFileMenu
            app.SavechannelnamessourcetypesandselectedareatoFileMenu = uimenu(app.FileimportappendexportMenu);
            app.SavechannelnamessourcetypesandselectedareatoFileMenu.MenuSelectedFcn = createCallbackFcn(app, @SavechannelnamessourcetypesandselectedareatoFileMenuSelected, true);
            app.SavechannelnamessourcetypesandselectedareatoFileMenu.Visible = 'off';
            app.SavechannelnamessourcetypesandselectedareatoFileMenu.Text = 'S&ave channel names, source types and selected area to File';

            % Create LoadchannelnamessourcetypesandselectedareafromFileMenu
            app.LoadchannelnamessourcetypesandselectedareafromFileMenu = uimenu(app.FileimportappendexportMenu);
            app.LoadchannelnamessourcetypesandselectedareafromFileMenu.MenuSelectedFcn = createCallbackFcn(app, @LoadchannelnamessourcetypesandselectedareafromFileMenuSelected, true);
            app.LoadchannelnamessourcetypesandselectedareafromFileMenu.Visible = 'off';
            app.LoadchannelnamessourcetypesandselectedareafromFileMenu.Text = '&Load channel names, source types and selected area from File';

            % Create ViewMenu
            app.ViewMenu = uimenu(app.UIFigure);
            app.ViewMenu.Text = '&View';

            % Create FontSizeMenu
            app.FontSizeMenu = uimenu(app.ViewMenu);
            app.FontSizeMenu.Text = 'Font Size...';

            % Create IncreasepressMenu
            app.IncreasepressMenu = uimenu(app.FontSizeMenu);
            app.IncreasepressMenu.MenuSelectedFcn = createCallbackFcn(app, @IncreasepressMenuSelected, true);
            app.IncreasepressMenu.Tooltip = {'Font Size can also be controlled by pressing + or -'};
            app.IncreasepressMenu.Text = 'Increase (press +)';

            % Create DecreasepressMenu
            app.DecreasepressMenu = uimenu(app.FontSizeMenu);
            app.DecreasepressMenu.MenuSelectedFcn = createCallbackFcn(app, @DecreasepressMenuSelected, true);
            app.DecreasepressMenu.Tooltip = {'Font Size can also be controlled by pressing + or -'};
            app.DecreasepressMenu.Text = 'Decrease (press -)';

            % Create SelectionevaluationsMenu
            app.SelectionevaluationsMenu = uimenu(app.ViewMenu);
            app.SelectionevaluationsMenu.Text = 'Selection evaluations...';

            % Create ShowSelectionEvaluationsMenu
            app.ShowSelectionEvaluationsMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowSelectionEvaluationsMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowSelectionEvaluationsMenuSelected, true);
            app.ShowSelectionEvaluationsMenu.Checked = 'on';
            app.ShowSelectionEvaluationsMenu.Text = 'Show';

            % Create HideSelectionEvaluationsMenu
            app.HideSelectionEvaluationsMenu = uimenu(app.SelectionevaluationsMenu);
            app.HideSelectionEvaluationsMenu.MenuSelectedFcn = createCallbackFcn(app, @HideSelectionEvaluationsMenuSelected, true);
            app.HideSelectionEvaluationsMenu.Text = 'Hide';

            % Create ShowMeanMenu
            app.ShowMeanMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowMeanMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowMeanMenu.Separator = 'on';
            app.ShowMeanMenu.Checked = 'on';
            app.ShowMeanMenu.Text = 'Show Mean';

            % Create ShowMedianMenu
            app.ShowMedianMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowMedianMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowMedianMenu.Checked = 'on';
            app.ShowMedianMenu.Text = 'Show Median';

            % Create ShowMinMenu
            app.ShowMinMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowMinMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowMinMenu.Checked = 'on';
            app.ShowMinMenu.Text = 'Show Min';

            % Create ShowMaxMenu
            app.ShowMaxMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowMaxMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowMaxMenu.Checked = 'on';
            app.ShowMaxMenu.Text = 'Show Max';

            % Create ShowRangeMenu
            app.ShowRangeMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowRangeMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowRangeMenu.Checked = 'on';
            app.ShowRangeMenu.Text = 'Show Range';

            % Create ShowStandardDeviationMenu
            app.ShowStandardDeviationMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowStandardDeviationMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectionCalculationsSelectedParametersChanged, true);
            app.ShowStandardDeviationMenu.Checked = 'on';
            app.ShowStandardDeviationMenu.Text = 'Show Standard Deviation';

            % Create ShowRootMeanSquareMenu
            app.ShowRootMeanSquareMenu = uimenu(app.SelectionevaluationsMenu);
            app.ShowRootMeanSquareMenu.Checked = 'on';
            app.ShowRootMeanSquareMenu.Text = 'Show Root-Mean-Square';

            % Create Show1selectiondurationMenu
            app.Show1selectiondurationMenu = uimenu(app.SelectionevaluationsMenu);
            app.Show1selectiondurationMenu.Checked = 'on';
            app.Show1selectiondurationMenu.Text = 'Show 1/(selection duration)';

            % Create ChangechannelcolorsMenu
            app.ChangechannelcolorsMenu = uimenu(app.ViewMenu);
            app.ChangechannelcolorsMenu.MenuSelectedFcn = createCallbackFcn(app, @ChangechannelcolorsMenuSelected, true);
            app.ChangechannelcolorsMenu.Text = 'Change channel colors...';

            % Create ExtrasMenu
            app.ExtrasMenu = uimenu(app.UIFigure);
            app.ExtrasMenu.Text = '&Extras';

            % Create PianoMenu
            app.PianoMenu = uimenu(app.ExtrasMenu);
            app.PianoMenu.MenuSelectedFcn = createCallbackFcn(app, @PianoMenuSelected, true);
            app.PianoMenu.Text = 'Piano';

            % Create LagEstimatorofselectionMenu
            app.LagEstimatorofselectionMenu = uimenu(app.ExtrasMenu);
            app.LagEstimatorofselectionMenu.MenuSelectedFcn = createCallbackFcn(app, @LagEstimatorofselectionMenuSelected, true);
            app.LagEstimatorofselectionMenu.Text = 'Lag Estimator (of selection)';

            % Create RecalculateallmatfileswithallparametersMenu
            app.RecalculateallmatfileswithallparametersMenu = uimenu(app.ExtrasMenu);
            app.RecalculateallmatfileswithallparametersMenu.MenuSelectedFcn = createCallbackFcn(app, @RecalculateallmatfileswithallparametersMenuSelected, true);
            app.RecalculateallmatfileswithallparametersMenu.Text = 'Recalculate all mat files with all parameters';

            % Create RestartVocaliscopeMenu
            app.RestartVocaliscopeMenu = uimenu(app.ExtrasMenu);
            app.RestartVocaliscopeMenu.MenuSelectedFcn = createCallbackFcn(app, @RestartVocaliscopeMenuSelected, true);
            app.RestartVocaliscopeMenu.Visible = 'off';
            app.RestartVocaliscopeMenu.Text = 'Restart Vocaliscope';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', 'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 1;
            app.GridLayout.RowSpacing = 3;
            app.GridLayout.Padding = [1 1 1 1];

            % Create uOupenShiftToolButton
            app.uOupenShiftToolButton = uibutton(app.GridLayout, 'push');
            app.uOupenShiftToolButton.ButtonPushedFcn = createCallbackFcn(app, @uOupenShiftToolButtonPushed, true);
            app.uOupenShiftToolButton.WordWrap = 'on';
            app.uOupenShiftToolButton.Layout.Row = 1;
            app.uOupenShiftToolButton.Layout.Column = 1;
            app.uOupenShiftToolButton.Interpreter = 'html';
            app.uOupenShiftToolButton.Text = '<u>O</u>pen Shift Tool';

            % Create CalculateParametersButton
            app.CalculateParametersButton = uibutton(app.GridLayout, 'push');
            app.CalculateParametersButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateParametersButtonPushed, true);
            app.CalculateParametersButton.WordWrap = 'on';
            app.CalculateParametersButton.Layout.Row = 1;
            app.CalculateParametersButton.Layout.Column = 3;
            app.CalculateParametersButton.Text = 'Calculate Parameters';

            % Create SaveResultsButton
            app.SaveResultsButton = uibutton(app.GridLayout, 'push');
            app.SaveResultsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveResultsButtonPushed, true);
            app.SaveResultsButton.WordWrap = 'on';
            app.SaveResultsButton.Enable = 'off';
            app.SaveResultsButton.Layout.Row = 1;
            app.SaveResultsButton.Layout.Column = 4;
            app.SaveResultsButton.Text = 'Save Results';

            % Create openfileaftersavingCheckBox
            app.openfileaftersavingCheckBox = uicheckbox(app.GridLayout);
            app.openfileaftersavingCheckBox.Text = 'open file after saving';
            app.openfileaftersavingCheckBox.WordWrap = 'on';
            app.openfileaftersavingCheckBox.Layout.Row = 1;
            app.openfileaftersavingCheckBox.Layout.Column = 5;

            % Create savewavandchannelnamestypesCheckBox
            app.savewavandchannelnamestypesCheckBox = uicheckbox(app.GridLayout);
            app.savewavandchannelnamestypesCheckBox.Text = {'save wav'; 'and channel'; 'names/types'};
            app.savewavandchannelnamestypesCheckBox.WordWrap = 'on';
            app.savewavandchannelnamestypesCheckBox.Layout.Row = 1;
            app.savewavandchannelnamestypesCheckBox.Layout.Column = 6;
            app.savewavandchannelnamestypesCheckBox.Value = true;

            % Create savechanneldatatoxlsxCheckBox
            app.savechanneldatatoxlsxCheckBox = uicheckbox(app.GridLayout);
            app.savechanneldatatoxlsxCheckBox.Text = 'save channel data to xlsx';
            app.savechanneldatatoxlsxCheckBox.WordWrap = 'on';
            app.savechanneldatatoxlsxCheckBox.Layout.Row = 1;
            app.savechanneldatatoxlsxCheckBox.Layout.Column = 7;

            % Create PlaySoundButton
            app.PlaySoundButton = uibutton(app.GridLayout, 'push');
            app.PlaySoundButton.ButtonPushedFcn = createCallbackFcn(app, @PlaySoundButtonPushed, true);
            app.PlaySoundButton.WordWrap = 'on';
            app.PlaySoundButton.Tooltip = {'Play channels as audio'; 'The channels'' MEAN is subtracted'};
            app.PlaySoundButton.Layout.Row = 1;
            app.PlaySoundButton.Layout.Column = 9;
            app.PlaySoundButton.Text = 'Play Sound';

            % Create weightchannelsevenlyCheckBox
            app.weightchannelsevenlyCheckBox = uicheckbox(app.GridLayout);
            app.weightchannelsevenlyCheckBox.ValueChangedFcn = createCallbackFcn(app, @weightchannelsevenlyCheckBoxValueChanged, true);
            app.weightchannelsevenlyCheckBox.Text = {'weight'; 'channels'; 'evenly'};
            app.weightchannelsevenlyCheckBox.WordWrap = 'on';
            app.weightchannelsevenlyCheckBox.Layout.Row = 1;
            app.weightchannelsevenlyCheckBox.Layout.Column = 10;
            app.weightchannelsevenlyCheckBox.Value = true;

            % Create StopSoundButton
            app.StopSoundButton = uibutton(app.GridLayout, 'push');
            app.StopSoundButton.ButtonPushedFcn = createCallbackFcn(app, @StopSoundButtonPushed, true);
            app.StopSoundButton.WordWrap = 'on';
            app.StopSoundButton.Layout.Row = 1;
            app.StopSoundButton.Layout.Column = 11;
            app.StopSoundButton.Text = 'Stop Sound';

            % Create SoundVolumeSlider
            app.SoundVolumeSlider = uislider(app.GridLayout);
            app.SoundVolumeSlider.Limits = [0 1];
            app.SoundVolumeSlider.MajorTicks = [0 0.5 1];
            app.SoundVolumeSlider.Tooltip = {'Sound Volume'; 'No effect while playing'};
            app.SoundVolumeSlider.Layout.Row = 1;
            app.SoundVolumeSlider.Layout.Column = [12 14];
            app.SoundVolumeSlider.Value = 0.5;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = [2 23];
            app.TabGroup.Layout.Column = [1 10];

            % Create TimeViewTab
            app.TimeViewTab = uitab(app.TabGroup);
            app.TimeViewTab.Title = 'Time View';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.TimeViewTab);
            app.GridLayout4.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout4.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout4.RowSpacing = 5;
            app.GridLayout4.Padding = [0 0 0 0];

            % Create InteractionModeButtonGroup
            app.InteractionModeButtonGroup = uibuttongroup(app.GridLayout4);
            app.InteractionModeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @InteractionModeButtonGroupSelectionChanged, true);
            app.InteractionModeButtonGroup.BorderType = 'none';
            app.InteractionModeButtonGroup.Title = 'Interaction Mode';
            app.InteractionModeButtonGroup.Layout.Row = 1;
            app.InteractionModeButtonGroup.Layout.Column = [1 5];

            % Create normalButton
            app.normalButton = uiradiobutton(app.InteractionModeButtonGroup);
            app.normalButton.Text = 'normal';
            app.normalButton.Position = [71 11 101 22];
            app.normalButton.Value = true;

            % Create MarkAreaButton
            app.MarkAreaButton = uiradiobutton(app.InteractionModeButtonGroup);
            app.MarkAreaButton.Text = 'Mark Area';
            app.MarkAreaButton.Position = [182 11 110 22];

            % Create MoveGraphButton
            app.MoveGraphButton = uiradiobutton(app.InteractionModeButtonGroup);
            app.MoveGraphButton.Text = 'Move Graph';
            app.MoveGraphButton.Position = [299 11 140 22];

            % Create UndoallshiftsButton
            app.UndoallshiftsButton = uibutton(app.GridLayout4, 'push');
            app.UndoallshiftsButton.ButtonPushedFcn = createCallbackFcn(app, @UndoallshiftsButtonPushed, true);
            app.UndoallshiftsButton.Layout.Row = 1;
            app.UndoallshiftsButton.Layout.Column = [8 9];
            app.UndoallshiftsButton.Text = 'Undo all shifts';

            % Create plottingPanelContainer
            app.plottingPanelContainer = uipanel(app.GridLayout4);
            app.plottingPanelContainer.AutoResizeChildren = 'off';
            app.plottingPanelContainer.BorderType = 'none';
            app.plottingPanelContainer.SizeChangedFcn = createCallbackFcn(app, @plottingPanelContainerSizeChanged, true);
            app.plottingPanelContainer.Layout.Row = [2 9];
            app.plottingPanelContainer.Layout.Column = [1 9];
            app.plottingPanelContainer.Scrollable = 'on';

            % Create plottingPanel
            app.plottingPanel = uipanel(app.plottingPanelContainer);
            app.plottingPanel.AutoResizeChildren = 'off';
            app.plottingPanel.BorderColor = [1 0 0];
            app.plottingPanel.HighlightColor = [1 0 0];
            app.plottingPanel.BorderType = 'none';
            app.plottingPanel.BorderWidth = 2;
            app.plottingPanel.Position = [2 2 738 498];

            % Create TimeSpectralViewTab
            app.TimeSpectralViewTab = uitab(app.TabGroup);
            app.TimeSpectralViewTab.Title = 'Time-Spectral View';

            % Create GridLayout4_2
            app.GridLayout4_2 = uigridlayout(app.TimeSpectralViewTab);
            app.GridLayout4_2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout4_2.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout4_2.RowSpacing = 5;
            app.GridLayout4_2.Padding = [0 0 0 0];

            % Create InteractionModeButtonGroupSpectralTab
            app.InteractionModeButtonGroupSpectralTab = uibuttongroup(app.GridLayout4_2);
            app.InteractionModeButtonGroupSpectralTab.SelectionChangedFcn = createCallbackFcn(app, @InteractionModeButtonGroupSelectionChanged, true);
            app.InteractionModeButtonGroupSpectralTab.BorderType = 'none';
            app.InteractionModeButtonGroupSpectralTab.Title = 'Interaction Mode';
            app.InteractionModeButtonGroupSpectralTab.Layout.Row = 1;
            app.InteractionModeButtonGroupSpectralTab.Layout.Column = [1 5];

            % Create normalButtonSpectral
            app.normalButtonSpectral = uiradiobutton(app.InteractionModeButtonGroupSpectralTab);
            app.normalButtonSpectral.Text = 'normal';
            app.normalButtonSpectral.Position = [71 11 101 22];
            app.normalButtonSpectral.Value = true;

            % Create MarkAreaButtonSpectral
            app.MarkAreaButtonSpectral = uiradiobutton(app.InteractionModeButtonGroupSpectralTab);
            app.MarkAreaButtonSpectral.Text = 'Mark Area';
            app.MarkAreaButtonSpectral.Position = [182 11 110 22];

            % Create MoveGraphButtonSpectral
            app.MoveGraphButtonSpectral = uiradiobutton(app.InteractionModeButtonGroupSpectralTab);
            app.MoveGraphButtonSpectral.Text = 'Move Graph';
            app.MoveGraphButtonSpectral.Position = [299 11 140 22];

            % Create choosesettingsandrecalculatespectraButton
            app.choosesettingsandrecalculatespectraButton = uibutton(app.GridLayout4_2, 'push');
            app.choosesettingsandrecalculatespectraButton.ButtonPushedFcn = createCallbackFcn(app, @choosesettingsandrecalculatespectraButtonPushed, true);
            app.choosesettingsandrecalculatespectraButton.WordWrap = 'on';
            app.choosesettingsandrecalculatespectraButton.Layout.Row = 1;
            app.choosesettingsandrecalculatespectraButton.Layout.Column = [6 7];
            app.choosesettingsandrecalculatespectraButton.Text = 'choose settings and recalculate spectra...';

            % Create UndoallshiftsButtonSpectralTab
            app.UndoallshiftsButtonSpectralTab = uibutton(app.GridLayout4_2, 'push');
            app.UndoallshiftsButtonSpectralTab.ButtonPushedFcn = createCallbackFcn(app, @UndoallshiftsButtonPushed, true);
            app.UndoallshiftsButtonSpectralTab.Layout.Row = 1;
            app.UndoallshiftsButtonSpectralTab.Layout.Column = [8 9];
            app.UndoallshiftsButtonSpectralTab.Text = 'Undo all shifts';

            % Create plottingPanelContainerSpectral
            app.plottingPanelContainerSpectral = uipanel(app.GridLayout4_2);
            app.plottingPanelContainerSpectral.AutoResizeChildren = 'off';
            app.plottingPanelContainerSpectral.BorderType = 'none';
            app.plottingPanelContainerSpectral.Layout.Row = [2 9];
            app.plottingPanelContainerSpectral.Layout.Column = [1 9];
            app.plottingPanelContainerSpectral.Scrollable = 'on';

            % Create plottingPanelSpectral
            app.plottingPanelSpectral = uipanel(app.plottingPanelContainerSpectral);
            app.plottingPanelSpectral.AutoResizeChildren = 'off';
            app.plottingPanelSpectral.BorderType = 'none';
            app.plottingPanelSpectral.Position = [2 0 746 500];

            % Create ResultsTab
            app.ResultsTab = uitab(app.TabGroup);
            app.ResultsTab.Title = 'Results';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.ResultsTab);
            app.GridLayout5.ColumnWidth = {'1x', '1x', '1x', 'fit', '1x', '1x', '1x'};
            app.GridLayout5.RowHeight = {'fit', '1x'};
            app.GridLayout5.ColumnSpacing = 0;
            app.GridLayout5.RowSpacing = 5;
            app.GridLayout5.Padding = [0 0 0 5];

            % Create FilterResultsTableEditField
            app.FilterResultsTableEditField = uieditfield(app.GridLayout5, 'text');
            app.FilterResultsTableEditField.ValueChangingFcn = createCallbackFcn(app, @FilterResultsTableEditFieldValueChanging, true);
            app.FilterResultsTableEditField.Placeholder = 'Type here to filter results table';
            app.FilterResultsTableEditField.Layout.Row = 1;
            app.FilterResultsTableEditField.Layout.Column = [1 2];

            % Create CasesensitiveCheckBox
            app.CasesensitiveCheckBox = uicheckbox(app.GridLayout5);
            app.CasesensitiveCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterResultsTableEditFieldValueChanging, true);
            app.CasesensitiveCheckBox.Text = 'Case sensitive';
            app.CasesensitiveCheckBox.Layout.Row = 1;
            app.CasesensitiveCheckBox.Layout.Column = 3;

            % Create SearchinthesecolumnsLabel
            app.SearchinthesecolumnsLabel = uilabel(app.GridLayout5);
            app.SearchinthesecolumnsLabel.Layout.Row = 1;
            app.SearchinthesecolumnsLabel.Layout.Column = 4;
            app.SearchinthesecolumnsLabel.Text = 'Search in these columns:';

            % Create ChannelnameCheckBox
            app.ChannelnameCheckBox = uicheckbox(app.GridLayout5);
            app.ChannelnameCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterResultsTableEditFieldValueChanging, true);
            app.ChannelnameCheckBox.Text = 'Channel name';
            app.ChannelnameCheckBox.Layout.Row = 1;
            app.ChannelnameCheckBox.Layout.Column = 5;
            app.ChannelnameCheckBox.Value = true;

            % Create ParameternameCheckBox
            app.ParameternameCheckBox = uicheckbox(app.GridLayout5);
            app.ParameternameCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterResultsTableEditFieldValueChanging, true);
            app.ParameternameCheckBox.Text = 'Parameter name';
            app.ParameternameCheckBox.Layout.Row = 1;
            app.ParameternameCheckBox.Layout.Column = 6;
            app.ParameternameCheckBox.Value = true;

            % Create SourcetypeCheckBox
            app.SourcetypeCheckBox = uicheckbox(app.GridLayout5);
            app.SourcetypeCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterResultsTableEditFieldValueChanging, true);
            app.SourcetypeCheckBox.Text = 'Source type';
            app.SourcetypeCheckBox.Layout.Row = 1;
            app.SourcetypeCheckBox.Layout.Column = 7;
            app.SourcetypeCheckBox.Value = true;

            % Create parameterResultsUITable
            app.parameterResultsUITable = uitable(app.GridLayout5);
            app.parameterResultsUITable.ColumnName = {'Channel name'; 'Parameter'; 'Source'; 'Median'; 'Mean'; 'STD'; 'Min'; 'Max'};
            app.parameterResultsUITable.ColumnWidth = {'1x', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
            app.parameterResultsUITable.RowName = {};
            app.parameterResultsUITable.ColumnSortable = [true true true true true true true true];
            app.parameterResultsUITable.CellSelectionCallback = createCallbackFcn(app, @parameterResultsUITableCellSelection, true);
            app.parameterResultsUITable.Multiselect = 'off';
            app.parameterResultsUITable.Layout.Row = 2;
            app.parameterResultsUITable.Layout.Column = [1 7];

            % Create availableChannelsTable
            app.availableChannelsTable = uitable(app.GridLayout);
            app.availableChannelsTable.ColumnName = {'Channel name'; 'source'};
            app.availableChannelsTable.ColumnWidth = {'1x', '1x'};
            app.availableChannelsTable.ColumnSortable = [false false];
            app.availableChannelsTable.SelectionType = 'row';
            app.availableChannelsTable.ColumnEditable = [false true];
            app.availableChannelsTable.CellEditCallback = createCallbackFcn(app, @adjustDataSourceOnTableEdit, true);
            app.availableChannelsTable.SelectionChangedFcn = createCallbackFcn(app, @changeDisplayedChannels, true);
            app.availableChannelsTable.Layout.Row = [2 8];
            app.availableChannelsTable.Layout.Column = [11 14];

            % Create SelectallButton
            app.SelectallButton = uibutton(app.GridLayout, 'push');
            app.SelectallButton.ButtonPushedFcn = createCallbackFcn(app, @SelectallButtonPushed, true);
            app.SelectallButton.FontWeight = 'bold';
            app.SelectallButton.Layout.Row = 9;
            app.SelectallButton.Layout.Column = [11 14];
            app.SelectallButton.Text = 'Select all';

            % Create DeselectallButton
            app.DeselectallButton = uibutton(app.GridLayout, 'push');
            app.DeselectallButton.ButtonPushedFcn = createCallbackFcn(app, @DeselectallButtonPushed, true);
            app.DeselectallButton.FontWeight = 'bold';
            app.DeselectallButton.Layout.Row = 10;
            app.DeselectallButton.Layout.Column = [11 14];
            app.DeselectallButton.Text = 'Deselect all';

            % Create InvertselectionButton
            app.InvertselectionButton = uibutton(app.GridLayout, 'push');
            app.InvertselectionButton.ButtonPushedFcn = createCallbackFcn(app, @InvertselectionButtonPushed, true);
            app.InvertselectionButton.WordWrap = 'on';
            app.InvertselectionButton.FontWeight = 'bold';
            app.InvertselectionButton.Layout.Row = 11;
            app.InvertselectionButton.Layout.Column = [11 14];
            app.InvertselectionButton.Text = 'Invert selection';

            % Create HidecyclesbordersButton
            app.HidecyclesbordersButton = uibutton(app.GridLayout, 'state');
            app.HidecyclesbordersButton.ValueChangedFcn = createCallbackFcn(app, @HidecyclesbordersButtonValueChanged, true);
            app.HidecyclesbordersButton.Text = 'Hide cycles borders';
            app.HidecyclesbordersButton.WordWrap = 'on';
            app.HidecyclesbordersButton.FontWeight = 'bold';
            app.HidecyclesbordersButton.Layout.Row = 12;
            app.HidecyclesbordersButton.Layout.Column = [11 14];

            % Create HideOQareasButton
            app.HideOQareasButton = uibutton(app.GridLayout, 'state');
            app.HideOQareasButton.ValueChangedFcn = createCallbackFcn(app, @HideOQareasButtonValueChanged, true);
            app.HideOQareasButton.Tooltip = {'If activated, the OQ and ClQ areas are hidden. OQ and ClQ areas are calculated only for GAW and EGG signals.'};
            app.HideOQareasButton.Text = 'Hide OQ areas';
            app.HideOQareasButton.WordWrap = 'on';
            app.HideOQareasButton.FontWeight = 'bold';
            app.HideOQareasButton.Layout.Row = 13;
            app.HideOQareasButton.Layout.Column = [11 12];

            % Create ClQareasarehiddenButton
            app.ClQareasarehiddenButton = uibutton(app.GridLayout, 'state');
            app.ClQareasarehiddenButton.ValueChangedFcn = createCallbackFcn(app, @ClQareasarehiddenButtonValueChanged, true);
            app.ClQareasarehiddenButton.Tooltip = {'If activated, the OQ and ClQ areas are hidden. OQ and ClQ areas are calculated only for GAW and EGG signals.'};
            app.ClQareasarehiddenButton.Text = 'ClQ areas are hidden';
            app.ClQareasarehiddenButton.WordWrap = 'on';
            app.ClQareasarehiddenButton.FontWeight = 'bold';
            app.ClQareasarehiddenButton.Layout.Row = 13;
            app.ClQareasarehiddenButton.Layout.Column = [13 14];
            app.ClQareasarehiddenButton.Value = true;

            % Create DeleteselectedsignalsButton
            app.DeleteselectedsignalsButton = uibutton(app.GridLayout, 'push');
            app.DeleteselectedsignalsButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteselectedsignalsButtonPushed, true);
            app.DeleteselectedsignalsButton.BackgroundColor = [0.9608 0.8745 0.6431];
            app.DeleteselectedsignalsButton.FontWeight = 'bold';
            app.DeleteselectedsignalsButton.Layout.Row = 14;
            app.DeleteselectedsignalsButton.Layout.Column = [11 14];
            app.DeleteselectedsignalsButton.Text = 'Delete selected signals';

            % Create DeletenonselectedsignalsButton
            app.DeletenonselectedsignalsButton = uibutton(app.GridLayout, 'push');
            app.DeletenonselectedsignalsButton.ButtonPushedFcn = createCallbackFcn(app, @DeletenonselectedsignalsButtonPushed, true);
            app.DeletenonselectedsignalsButton.WordWrap = 'on';
            app.DeletenonselectedsignalsButton.BackgroundColor = [0.9608 0.8745 0.6431];
            app.DeletenonselectedsignalsButton.FontWeight = 'bold';
            app.DeletenonselectedsignalsButton.Layout.Row = 15;
            app.DeletenonselectedsignalsButton.Layout.Column = [11 14];
            app.DeletenonselectedsignalsButton.Text = 'Delete non selected signals';

            % Create showngraphswithoutscrollingDropDownLabel
            app.showngraphswithoutscrollingDropDownLabel = uilabel(app.GridLayout);
            app.showngraphswithoutscrollingDropDownLabel.VerticalAlignment = 'top';
            app.showngraphswithoutscrollingDropDownLabel.FontWeight = 'bold';
            app.showngraphswithoutscrollingDropDownLabel.Layout.Row = 17;
            app.showngraphswithoutscrollingDropDownLabel.Layout.Column = [11 14];
            app.showngraphswithoutscrollingDropDownLabel.Text = 'shown graphs without scrolling';

            % Create showngraphswithoutscrollingDropDown
            app.showngraphswithoutscrollingDropDown = uidropdown(app.GridLayout);
            app.showngraphswithoutscrollingDropDown.Items = {'1', '2', '3', '4', '5', '6', '7', '8'};
            app.showngraphswithoutscrollingDropDown.ValueChangedFcn = createCallbackFcn(app, @changeNumberOfGraphsWithoutScrolling, true);
            app.showngraphswithoutscrollingDropDown.Layout.Row = 18;
            app.showngraphswithoutscrollingDropDown.Layout.Column = [11 14];
            app.showngraphswithoutscrollingDropDown.Value = '4';

            % Create SelectedAreaLabel
            app.SelectedAreaLabel = uilabel(app.GridLayout);
            app.SelectedAreaLabel.FontWeight = 'bold';
            app.SelectedAreaLabel.Layout.Row = 20;
            app.SelectedAreaLabel.Layout.Column = [11 12];
            app.SelectedAreaLabel.Text = 'Selected Area:';

            % Create SelectionstartLabel
            app.SelectionstartLabel = uilabel(app.GridLayout);
            app.SelectionstartLabel.HorizontalAlignment = 'right';
            app.SelectionstartLabel.WordWrap = 'on';
            app.SelectionstartLabel.FontWeight = 'bold';
            app.SelectionstartLabel.Layout.Row = 21;
            app.SelectionstartLabel.Layout.Column = 11;
            app.SelectionstartLabel.Text = 'Start:';

            % Create SelectedAreaStartEditField
            app.SelectedAreaStartEditField = uieditfield(app.GridLayout, 'numeric');
            app.SelectedAreaStartEditField.ValueDisplayFormat = '%30.16g s';
            app.SelectedAreaStartEditField.ValueChangedFcn = createCallbackFcn(app, @SelectedAreaStartEditFieldValueChanged, true);
            app.SelectedAreaStartEditField.Editable = 'off';
            app.SelectedAreaStartEditField.Layout.Row = 21;
            app.SelectedAreaStartEditField.Layout.Column = [12 14];
            app.SelectedAreaStartEditField.Value = -Inf;

            % Create SelectionendLabel
            app.SelectionendLabel = uilabel(app.GridLayout);
            app.SelectionendLabel.HorizontalAlignment = 'right';
            app.SelectionendLabel.WordWrap = 'on';
            app.SelectionendLabel.FontWeight = 'bold';
            app.SelectionendLabel.Layout.Row = 22;
            app.SelectionendLabel.Layout.Column = 11;
            app.SelectionendLabel.Text = 'End:';

            % Create SelectedAreaEndEditField
            app.SelectedAreaEndEditField = uieditfield(app.GridLayout, 'numeric');
            app.SelectedAreaEndEditField.ValueDisplayFormat = '%30.16g s';
            app.SelectedAreaEndEditField.ValueChangedFcn = createCallbackFcn(app, @SelectedAreaEndEditFieldValueChanged, true);
            app.SelectedAreaEndEditField.Editable = 'off';
            app.SelectedAreaEndEditField.Layout.Row = 22;
            app.SelectedAreaEndEditField.Layout.Column = [12 14];
            app.SelectedAreaEndEditField.Value = Inf;

            % Create DurationEditFieldLabel
            app.DurationEditFieldLabel = uilabel(app.GridLayout);
            app.DurationEditFieldLabel.HorizontalAlignment = 'right';
            app.DurationEditFieldLabel.WordWrap = 'on';
            app.DurationEditFieldLabel.FontWeight = 'bold';
            app.DurationEditFieldLabel.Layout.Row = 23;
            app.DurationEditFieldLabel.Layout.Column = 11;
            app.DurationEditFieldLabel.Text = 'Duration:';

            % Create SelectedAreaDurationEditField
            app.SelectedAreaDurationEditField = uieditfield(app.GridLayout, 'numeric');
            app.SelectedAreaDurationEditField.Limits = [0 Inf];
            app.SelectedAreaDurationEditField.ValueDisplayFormat = '%30.16g s';
            app.SelectedAreaDurationEditField.ValueChangedFcn = createCallbackFcn(app, @SelectedAreaDurationEditFieldValueChanged, true);
            app.SelectedAreaDurationEditField.Editable = 'off';
            app.SelectedAreaDurationEditField.Layout.Row = 23;
            app.SelectedAreaDurationEditField.Layout.Column = [12 14];

            % Create ParameterResultsTableContextMenu
            app.ParameterResultsTableContextMenu = uicontextmenu(app.UIFigure);
            app.ParameterResultsTableContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @ParameterResultsTableContextMenuOpening, true);

            % Create CopyleftclickedCellMenu
            app.CopyleftclickedCellMenu = uimenu(app.ParameterResultsTableContextMenu);
            app.CopyleftclickedCellMenu.MenuSelectedFcn = createCallbackFcn(app, @CopyleftclickedCellMenuSelected, true);
            app.CopyleftclickedCellMenu.Accelerator = 'C';
            app.CopyleftclickedCellMenu.Text = 'Copy left-clicked Cell';

            % Create RowWindowdataMenu
            app.RowWindowdataMenu = uimenu(app.ParameterResultsTableContextMenu);
            app.RowWindowdataMenu.Text = 'Row Window data...';

            % Create copyMenu
            app.copyMenu = uimenu(app.RowWindowdataMenu);
            app.copyMenu.MenuSelectedFcn = createCallbackFcn(app, @CopywindowdatafromrowofleftclickedcellMenuSelected, true);
            app.copyMenu.Accelerator = 'v';
            app.copyMenu.Text = 'copy';

            % Create plotMenu
            app.plotMenu = uimenu(app.RowWindowdataMenu);
            app.plotMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotwindowdatafromrowofleftclickedcellMenuSelected, true);
            app.plotMenu.Accelerator = 'p';
            app.plotMenu.Text = 'plot';

            % Create copycompleterowMenu
            app.copycompleterowMenu = uimenu(app.ParameterResultsTableContextMenu);
            app.copycompleterowMenu.Text = 'copy complete row...';

            % Create withoutcolumnheaderMenu
            app.withoutcolumnheaderMenu = uimenu(app.copycompleterowMenu);
            app.withoutcolumnheaderMenu.MenuSelectedFcn = createCallbackFcn(app, @withoutcolumnheaderMenuSelected, true);
            app.withoutcolumnheaderMenu.Accelerator = 'b';
            app.withoutcolumnheaderMenu.Text = 'without column header';

            % Create withcolumnheaderMenu
            app.withcolumnheaderMenu = uimenu(app.copycompleterowMenu);
            app.withcolumnheaderMenu.MenuSelectedFcn = createCallbackFcn(app, @withcolumnheaderMenuSelected, true);
            app.withcolumnheaderMenu.Text = 'with column header';
            
            % Assign app.ParameterResultsTableContextMenu
            app.parameterResultsUITable.ContextMenu = app.ParameterResultsTableContextMenu;

            % Create channelTableContextMenu
            app.channelTableContextMenu = uicontextmenu(app.UIFigure);

            % Create SelectallMenu
            app.SelectallMenu = uimenu(app.channelTableContextMenu);
            app.SelectallMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectallMenuSelected, true);
            app.SelectallMenu.Accelerator = 'A';
            app.SelectallMenu.Text = 'Select all';
            
            % Assign app.channelTableContextMenu
            app.availableChannelsTable.ContextMenu = app.channelTableContextMenu;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Vocaliscope

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
