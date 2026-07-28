
classdef VocaliscopeCalculationSettings < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        KeepSettingsoverSessionsCheckBox  matlab.ui.control.CheckBox
        calculateparametersButton       matlab.ui.control.Button
        previewcyclesButton             matlab.ui.control.Button
        TabGroup                        matlab.ui.container.TabGroup
        GeneralTab                      matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        UncheckallButton                matlab.ui.control.Button
        CheckallButton                  matlab.ui.control.Button
        CollapseallnodesButton          matlab.ui.control.Button
        ExpandallnodesButton            matlab.ui.control.Button
        FilterParameterToCalculateEditField  matlab.ui.control.EditField
        parameterExplanation            matlab.ui.control.Label
        ParametersTree                  matlab.ui.container.CheckBoxTree
        FundamentalFrequencyMeasuresNode  matlab.ui.container.TreeNode
        FundamentalFrequencyHzNode      matlab.ui.container.TreeNode
        CycleDurationmsNode             matlab.ui.container.TreeNode
        MaximumHarmonicHzNode           matlab.ui.container.TreeNode
        MinimumSubharmonicHzNode        matlab.ui.container.TreeNode
        AmplitudePerturbationMeasuresNode  matlab.ui.container.TreeNode
        MeanShimmerdBNode               matlab.ui.container.TreeNode
        ShimmerNode                     matlab.ui.container.TreeNode
        AmplitudePerturbationQuotientAPQNode  matlab.ui.container.TreeNode
        AmplitudePerturbationFactorAPFNode  matlab.ui.container.TreeNode
        AmplitudeVariabilityIndexdBAVINode  matlab.ui.container.TreeNode
        PeriodPerturbationMeasuresNode  matlab.ui.container.TreeNode
        MeanJittermsNode                matlab.ui.container.TreeNode
        JitterNode                      matlab.ui.container.TreeNode
        JitterRatioNode                 matlab.ui.container.TreeNode
        JitterFactorNode                matlab.ui.container.TreeNode
        PeriodPerturbationQuotientPPQNode  matlab.ui.container.TreeNode
        PeriodPerturbationFactorPPFNode  matlab.ui.container.TreeNode
        RelativeAveragePerturbationV1RAPNode  matlab.ui.container.TreeNode
        RelativeAveragePerturbationV2RAPNode  matlab.ui.container.TreeNode
        PeriodVariabilityIndexPVINode   matlab.ui.container.TreeNode
        EnergyPerturbationMeasuresNode  matlab.ui.container.TreeNode
        EnergyPerturbationQuotientEPQNode  matlab.ui.container.TreeNode
        EnergyPerturbationFactorEPFNode  matlab.ui.container.TreeNode
        NoiseMeasuresNode               matlab.ui.container.TreeNode
        HarmonicsIntensityNode          matlab.ui.container.TreeNode
        HarmonicstoNoiseRatiodBHNRNode  matlab.ui.container.TreeNode
        NormalizedNoiseEnergydBNNENode  matlab.ui.container.TreeNode
        SpectralFlatnessNode            matlab.ui.container.TreeNode
        GlottaltoNoiseExcitationRatioGNEv1Node  matlab.ui.container.TreeNode
        WaveformMatchingCoefcientWMCNode  matlab.ui.container.TreeNode
        MeanWaveformMatchingCoefcientNode  matlab.ui.container.TreeNode
        SignaltoNoiseRatioV1dBSNRNode   matlab.ui.container.TreeNode
        SignaltoNoiseRatioV2dBSNRNode   matlab.ui.container.TreeNode
        CepstralPeakProminenceIdBCPPNode  matlab.ui.container.TreeNode
        CepstralPeakProminenceIIdBCPPNode  matlab.ui.container.TreeNode
        MechanicalMeasuresNode          matlab.ui.container.TreeNode
        Stiffness1sNode                 matlab.ui.container.TreeNode
        PeakClosingVelocitypxsNode      matlab.ui.container.TreeNode
        PeakAccelerationpxs2Node        matlab.ui.container.TreeNode
        AmplitudetoLengthRatioNode      matlab.ui.container.TreeNode
        GlottalAreaMeasuresNode         matlab.ui.container.TreeNode
        OpenQuotientOQNode              matlab.ui.container.TreeNode
        ClosingQuotientClQNode          matlab.ui.container.TreeNode
        SpeedQuotientSQNode             matlab.ui.container.TreeNode
        SpeedIndexSINode                matlab.ui.container.TreeNode
        RateQuotientNode                matlab.ui.container.TreeNode
        AsymmetryQuotientNode           matlab.ui.container.TreeNode
        GlottisGapIndexGGINode          matlab.ui.container.TreeNode
        PlateauQuotientNode             matlab.ui.container.TreeNode
        GlottalAreaIndexGAINode         matlab.ui.container.TreeNode
        GlottalAreaPeriodicityMeasuresNode  matlab.ui.container.TreeNode
        AmplitudePeriodicityNode        matlab.ui.container.TreeNode
        TimePeriodicityNode             matlab.ui.container.TreeNode
        GlottalAreaDerivativeMeasuresNode  matlab.ui.container.TreeNode
        MaximumAreaDeclinationRateMpxsMADRNode  matlab.ui.container.TreeNode
        AmplitudeQuotientsNode          matlab.ui.container.TreeNode
        GlottalAreaSymmetryMeasuresNode  matlab.ui.container.TreeNode
        PhaseAsymmetryIndexNode         matlab.ui.container.TreeNode
        SpatialSymmetryIndexNode        matlab.ui.container.TreeNode
        DynamicRangeSymmetryIndexNode   matlab.ui.container.TreeNode
        AmplitudeSymmetryIndexNode      matlab.ui.container.TreeNode
        WaveformSymmetryIndexNode       matlab.ui.container.TreeNode
        PhaseAsymmetryNode              matlab.ui.container.TreeNode
        SpatialSymmetryNode             matlab.ui.container.TreeNode
        DynamicRangeSymmetryNode        matlab.ui.container.TreeNode
        AmplitudeSymmetryNode           matlab.ui.container.TreeNode
        BasicmeasurementsNode           matlab.ui.container.TreeNode
        SumNode                         matlab.ui.container.TreeNode
        MeanarithmeticharmonicgeometricNode  matlab.ui.container.TreeNode
        standarddeviationSTDNode        matlab.ui.container.TreeNode
        MedianNode                      matlab.ui.container.TreeNode
        InterquartilerangeIQRNode       matlab.ui.container.TreeNode
        MinimumMaximumNode              matlab.ui.container.TreeNode
        roommeansquareRMSNode           matlab.ui.container.TreeNode
        ModeNode                        matlab.ui.container.TreeNode
        Quantilesfrom5in5stepsto95Node  matlab.ui.container.TreeNode
        SkewnessNode                    matlab.ui.container.TreeNode
        KurtosisNode                    matlab.ui.container.TreeNode
        SumofsquarevaluesNode           matlab.ui.container.TreeNode
        AdditionalspectraldescriptorsNode  matlab.ui.container.TreeNode
        spectralCrestNode               matlab.ui.container.TreeNode
        spectralFluxNode                matlab.ui.container.TreeNode
        spectralSpreadNode              matlab.ui.container.TreeNode
        spectralSkewnessspectralTiltNode  matlab.ui.container.TreeNode
        spectralKurtosisNode            matlab.ui.container.TreeNode
        spectralCentroidNode            matlab.ui.container.TreeNode
        spectralEntropyNode             matlab.ui.container.TreeNode
        spectralSlopeNode               matlab.ui.container.TreeNode
        spectralDecreaseNode            matlab.ui.container.TreeNode
        spectralRolloffPointNode        matlab.ui.container.TreeNode
        harmonicRatioNode               matlab.ui.container.TreeNode
        HarmonictoNoiseRatioHNRviabiasedxcorrNode  matlab.ui.container.TreeNode
        SignaltoNoiseRatiodBcarrierSNRNode  matlab.ui.container.TreeNode
        PsychoacousticMeasuresNode      matlab.ui.container.TreeNode
        AcousticLoudnessNode            matlab.ui.container.TreeNode
        AcousticFluctuationNode         matlab.ui.container.TreeNode
        AcousticSharpnessNode           matlab.ui.container.TreeNode
        AcousticRoughnessNode           matlab.ui.container.TreeNode
        OthersNode                      matlab.ui.container.TreeNode
        zerocrossrateNode               matlab.ui.container.TreeNode
        sampleentropytimedomainNode     matlab.ui.container.TreeNode
        cyclebasedspectralsampleentropyNode  matlab.ui.container.TreeNode
        SoundPressureLevelSPLdBAdBCdBZNode  matlab.ui.container.TreeNode
        RelativeaverageperturbationRAPforcycleenergyNode  matlab.ui.container.TreeNode
        RelativeaverageperturbationRAPforcyclerangeNode  matlab.ui.container.TreeNode
        EnergyVariabilityIndexPVINode   matlab.ui.container.TreeNode
        GlottaltoNoiseExcitationRatioGNEv2Node  matlab.ui.container.TreeNode
        CepstralPeakProminenceSmoothedv3dBCPPsNode  matlab.ui.container.TreeNode
        upperFoPredictionFactorDropdown  matlab.ui.control.DropDown
        upperFoPredictionAlgorithmDropdown  matlab.ui.control.DropDown
        useUpperFoPredictionStateButton  matlab.ui.control.StateButton
        ChosenChannelEditField          matlab.ui.control.NumericEditField
        WindowOverlapmsEditField        matlab.ui.control.NumericEditField
        WindowOverlapmsEditFieldLabel   matlab.ui.control.Label
        minimumcycledurationmsEditField  matlab.ui.control.NumericEditField
        minimumcycledurationmsEditFieldLabel  matlab.ui.control.Label
        maximumfoHzEditField            matlab.ui.control.NumericEditField
        maximumifisubosubHzEditFieldLabel  matlab.ui.control.Label
        channelusedasmaskLabel          matlab.ui.control.Label
        WindowLengthmsEditField         matlab.ui.control.NumericEditField
        WindowLengthmsEditFieldLabel    matlab.ui.control.Label
        maximumcycledurationmsEditField  matlab.ui.control.NumericEditField
        maximumcycledurationmsEditFieldLabel  matlab.ui.control.Label
        minimumfoHzEditField            matlab.ui.control.NumericEditField
        minimumifisubosubHzEditFieldLabel  matlab.ui.control.Label
        UsemaskCheckBox                 matlab.ui.control.CheckBox
        WindowedAnalysisCheckBox        matlab.ui.control.CheckBox
        ifisubosubandcycledurationrangeLabel  matlab.ui.control.Label
        CyclesTab                       matlab.ui.container.Tab
        GridLayout3                     matlab.ui.container.GridLayout
        relativepeakprominenceinreferencetowindowmaximumEditField  matlab.ui.control.NumericEditField
        relativepeakprominenceinreferencetowindowmaximumEditFieldLabel  matlab.ui.control.Label
        absoluitepeakprominenceEditFieldLabel  matlab.ui.control.Label
        absoluitepeakprominenceEditField  matlab.ui.control.NumericEditField
        CyclePeakProminenceTypeSwitch   matlab.ui.control.Switch
        GAWopenthresholdinoflocalmaximumEditField  matlab.ui.control.NumericEditField
        GAWopenthresholdinoflocalmaximumEditFieldLabel  matlab.ui.control.Label
        PlateauQuotientThresholdEditField  matlab.ui.control.NumericEditField
        PlateauQuotientThresholdEditFieldLabel  matlab.ui.control.Label
        showseparateplotof1cycledurationCheckBox  matlab.ui.control.CheckBox
        foTab                           matlab.ui.container.Tab
        GridLayout4                     matlab.ui.container.GridLayout
        MinimumsubharmonicfouriercoefficientvalueEditField  matlab.ui.control.NumericEditField
        MinimumsubharmonicfouriercoefficientvalueEditFieldLabel  matlab.ui.control.Label
        MaximumnumberofsubharmonicstolookforEditField  matlab.ui.control.NumericEditField
        MaximumnumberofsubharmonicstolookforEditFieldLabel  matlab.ui.control.Label
        MaximumnumberofharmonicstolookforEditField  matlab.ui.control.NumericEditField
        MaximumnumberofharmonicstolookforEditFieldLabel  matlab.ui.control.Label
        SpectruminterpolationmethodDropDown  matlab.ui.control.DropDown
        SpectruminterpolationmethodDropDownLabel  matlab.ui.control.Label
        RequestedminimumFFTfrequencyresolutionEditField  matlab.ui.control.NumericEditField
        RequestedminimumFFTfrequencyresolutionEditFieldLabel  matlab.ui.control.Label
        generalFFTwindow                matlab.ui.control.DropDown
        WindowTypeDropDownLabel_2       matlab.ui.control.Label
        FFTandsubharmonicssettingsLabel  matlab.ui.control.Label
        PitchAnalysisWindowOverlapEditField  matlab.ui.control.NumericEditField
        PitchanalysistimewindowoverlapSlider  matlab.ui.control.Slider
        PitchanalysistimewindowoverlapSliderLabel  matlab.ui.control.Label
        pitchAnalysisTimeLengthEditField  matlab.ui.control.NumericEditField
        PitchanalysistimewindowSlider   matlab.ui.control.Slider
        PitchanalysistimewindowLabel    matlab.ui.control.Label
        ifisubosubsettingsLabel         matlab.ui.control.Label
        showseparateplotof1cycledurationCheckBox_2  matlab.ui.control.CheckBox
        SampleEntropyTab                matlab.ui.container.Tab
        GridLayout5                     matlab.ui.container.GridLayout
        SampEnFDnumberofharmonicstobeusedEditField  matlab.ui.control.NumericEditField
        NumberofharmonicstobeusedLabel  matlab.ui.control.Label
        SampEnFDfinalcombinationmethodDropDown  matlab.ui.control.DropDown
        FinalcombinationmethodofSampleEntropyDropDownLabel  matlab.ui.control.Label
        SampEnTimeNormalizationhorizontDropDown  matlab.ui.control.DropDown
        normalizationhorizontDropDownLabel  matlab.ui.control.Label
        PlotrawsampleentropyCheckBox    matlab.ui.control.CheckBox
        SampEnFDuserelativeFourierDescriptorsDropDown  matlab.ui.control.DropDown
        UserelativeFourierDescriptorsDropDownLabel  matlab.ui.control.Label
        SampEnTimeNormalizationmethodDropDown  matlab.ui.control.DropDown
        normalizationmethodDropDownLabel  matlab.ui.control.Label
        ScaleSampEntorange0to1CheckBox  matlab.ui.control.CheckBox
        SampEnFDtemplatefixedlengthsamplesEditField  matlab.ui.control.NumericEditField
        TemplatefixedlengthsamplesEditField_2Label  matlab.ui.control.Label
        SampEnTimeTemplatefixedlengthsamplesEditField  matlab.ui.control.NumericEditField
        TemplatefixedlengthsamplesEditFieldLabel  matlab.ui.control.Label
        RawSelamtzisSexSwitchLabel      matlab.ui.control.Label
        SampEnFDtemplatelengthmethodDropDown  matlab.ui.control.DropDown
        SampEntemplatelengthmethodDropDown_2Label  matlab.ui.control.Label
        SampEnTimeTemplatelengthmethodDropDown  matlab.ui.control.DropDown
        SampEntemplatelengthmethodDropDownLabel  matlab.ui.control.Label
        SampEnFDPhaseTemplatedistancethresholdofstdEditField  matlab.ui.control.NumericEditField
        SampEntemplatedistancethresholdofstdEditField_2Label_2  matlab.ui.control.Label
        RawSelamtzisSexSwitch           matlab.ui.control.Switch
        SampEnFDMagnitudeTemplatedistancethresholdofstdEditField  matlab.ui.control.NumericEditField
        SampEntemplatedistancethresholdofstdEditField_2Label  matlab.ui.control.Label
        SampEnTimeTemplatedistancethresholdofstdEditField  matlab.ui.control.NumericEditField
        SampEntemplatedistancethresholdofstdEditFieldLabel  matlab.ui.control.Label
        SampleEntropyinSpectralDomainLabel  matlab.ui.control.Label
        SampleEntropyinTimeDomainLabel  matlab.ui.control.Label
        CPPTab                          matlab.ui.container.Tab
        GridLayout6                     matlab.ui.container.GridLayout
        CPPsQuefrencySmoothingWindowsEditField  matlab.ui.control.NumericEditField
        CPPsQuefrencySmoothingWindowsEditFieldLabel  matlab.ui.control.Label
        CPPsTimeSmoothingWindowsEditField  matlab.ui.control.NumericEditField
        CPPsTimeSmoothingWindowsEditFieldLabel  matlab.ui.control.Label
        WindowHopSizesEditField         matlab.ui.control.NumericEditField
        WindowHopSizesEditFieldLabel    matlab.ui.control.Label
        WindowSizesEditField            matlab.ui.control.NumericEditField
        WindowSizesEditFieldLabel       matlab.ui.control.Label
        ResamplingFrequencyHzEditField  matlab.ui.control.NumericEditField
        ResamplingFrequencyHzEditFieldLabel  matlab.ui.control.Label
        UsePreemphasisDropDown          matlab.ui.control.DropDown
        UsePreemphasisDropDownLabel     matlab.ui.control.Label
        individualsettingsforcustomWindowSizeCPPsv3Label  matlab.ui.control.Label
        RobustfittingmethodDropDown     matlab.ui.control.DropDown
        RobustfittingmethodDropDownLabel  matlab.ui.control.Label
        BaselinefittingtypeDropDown     matlab.ui.control.DropDown
        BaselinefittingtypeDropDownLabel  matlab.ui.control.Label
        CepstrumWindowTypeDropDown      matlab.ui.control.DropDown
        WindowTypeDropDownLabel         matlab.ui.control.Label
        Searchinginitfrm_orangeLabel    matlab.ui.control.Label
        CepstrumMaxInFitRegionOnlyDropDown  matlab.ui.control.DropDown
        SearchCepstrummaximuminfitregiononlyDropDownLabel  matlab.ui.control.Label
        UpperQuefrencyLimitsEditField   matlab.ui.control.NumericEditField
        UpperQuefrencyLimitsEditFieldLabel  matlab.ui.control.Label
        LowerQuefrencyLimitsEditField   matlab.ui.control.NumericEditField
        LowerQuefrencyLimitsEditFieldLabel  matlab.ui.control.Label
        SettingsapplyingforbothLabel    matlab.ui.control.Label
        CPPandCPPswithcustomWindowSizeCPPsv3Label  matlab.ui.control.Label
        CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel  matlab.ui.control.Label
        loadSettingsfromfileButton      matlab.ui.control.Button
        SettingsLabel                   matlab.ui.control.Label
    end

    
    properties (Access = public)
        outputSettings = []; % allSettings
        calledAsPreview = 0;
        keepVocaliscopeSettingsOverSession = 1;
        channelsSuitableAsMask = 1;
    end
    
    properties (Access = private)
        batchMode = 0; % Description
    end
    

    
    methods (Access = private)
        
       
        function assignParameterDescriptionToNodeData(app)
            
            % since it is not accurate yet, we skip it for now
            return;

            parameterInfo=readcell("parameterDescriptionReworked.xlsx");
            parameterInfo(6:6:end,:)=[];
            parameterInfo(:,1)=append('\bf',parameterInfo(:,1),':\rm ',parameterInfo(:,2));
            parameterInfo(:,2)=[];

            allNodes = findobj(app.ParametersTree, 'Type', 'uitreenode');
            allNodes(arrayfun(@(in)~isempty(in.Children),allNodes))=[];

            for nodeNr=1:numel(parameterInfo)/5
                allNodes(nodeNr).NodeData=parameterInfo((1:5)+5*(nodeNr-1));
            end

            
        end
        
        

        
        function addFilterPossibility(app)

            txtFilterEditField=app.FilterParameterToCalculateEditField;

            checkboxUItree=app.ParametersTree;

            mainNodes=app.ParametersTree.Children;

            app.ParametersTree.UserData.MainNodes=mainNodes;

            for i = 1:numel(mainNodes)
                mainNodes(i).UserData.ChildNodes=gobjects(size(mainNodes(i).Children));

                for j = 1:numel(mainNodes(i).Children)
                    subNode=mainNodes(i).Children(j);

                    if ismember(subNode,app.CycleDurationmsNode)
                        subNode.UserData.Checked=true;
                    else
                        subNode.UserData.Checked=false;
                    end


                    mainNodes(i).UserData.ChildNodes(j)=subNode;

                end
            end

            txtFilterEditField.ValueChangingFcn = @(~, event) filterTreeNodes(checkboxUItree,event.Value);

            checkboxUItree.CheckedNodesChangedFcn=@(src,evt)keepTrackOfCheckedNotes(app,src,evt);

            function filterTreeNodes(tree,filterText)
                filterText = strtrim(filterText);
        
                checkboxUItree.CheckedNodes=[];
        
                allMainNodes = tree.UserData.MainNodes;
                set(allMainNodes,'Parent',tree);
                for mainNodeNr = 1:numel(allMainNodes)
                    currMainNode=allMainNodes(mainNodeNr);

                    %mainNodeMatches=contains(currMainNode.Text,filterText,'IgnoreCase',true);

                    if ~isempty(filterText)
                        mainNodeMatches=~isempty(regexpi(currMainNode.Text,replace(filterText,'*','.*'), 'once'));
                    else
                        mainNodeMatches=true;
                    end
                    
                    if mainNodeMatches==1
                        
                        set(currMainNode.Children,'Parent',[]);
        
                        set(currMainNode.UserData.ChildNodes,'Parent',currMainNode);

                        expand(currMainNode);
        
                    else
                        %subMatches=arrayfun(@(in) contains(in.Text,filterText,'IgnoreCase',true),currMainNode.UserData.ChildNodes);
                        
                        if ~isempty(filterText)
                            subMatches=~cellfun(@isempty,regexpi({currMainNode.UserData.ChildNodes.Text},replace(filterText,'*','.*'),'once'));
                        else
                            subMatches=true(size(currMainNode.UserData.ChildNodes));
                        end

            
                        set(currMainNode.UserData.ChildNodes(~subMatches),'Parent',[]);
                        set(currMainNode.UserData.ChildNodes(subMatches),'Parent',currMainNode);

                        if any(subMatches)
                            expand(currMainNode);
                        else% maybe not that useful or even getting on the nerves; we will see
                            %collapse(currMainNode);
                            currMainNode.Parent=[];
                        end
                    end
                    
                    for childNr=1:numel(currMainNode.Children)
                        if currMainNode.UserData.ChildNodes(currMainNode.UserData.ChildNodes==currMainNode.Children(childNr)).UserData.Checked
                            checkboxUItree.CheckedNodes=[checkboxUItree.CheckedNodes; currMainNode.Children(childNr)];
                        end
                    end
                    
                end
            end
        
            function keepTrackOfCheckedNotes(app,src,~)
                
                comingFromMainNode=ismember(src.SelectedNodes,mainNodes);
        
                nodeWasChecked=ismember(src.SelectedNodes,src.CheckedNodes);
        
                if comingFromMainNode
                    for nodeNr=1:numel(src.SelectedNodes.UserData.ChildNodes)
                        src.SelectedNodes.UserData.ChildNodes(nodeNr).UserData.Checked=nodeWasChecked;
                    end
                else
                    src.SelectedNodes.UserData.Checked=nodeWasChecked;
                end

                for chNr=1:numel(app.FundamentalFrequencyMeasuresNode.Children)
                    currChild=app.FundamentalFrequencyMeasuresNode.Children(chNr);
                    if ~ismember(currChild,app.ParametersTree.CheckedNodes) && ismember(currChild,app.CycleDurationmsNode)
                        app.ParametersTree.CheckedNodes=[app.ParametersTree.CheckedNodes; currChild];
                    end
                end

        
            end
            
        end
        
        function update_cpp_limits(app)
            % UPDATE_CPP_LIMITS  Update CPP/CPPS limits AppDesigner-style
            %   Limits from UI fields → safe clamping
            %
         
            fs = app.ResamplingFrequencyHzEditField.Value;
            signal_duration = app.WindowLengthmsEditField.Limits(2)/1000;  % Current signal

            % Exact minima (fs-dependent)
            MIN_WINDOW   = 256 / fs;        % FFT minimum
            MIN_STEP     = 1 / fs;          % 1 sample hop
            MIN_SMOOTH   = 1 / fs;          % 1 sample smooth

            % 1. WindowLength Limits
            app.WindowSizesEditField.Limits(1) = MIN_WINDOW;
            app.WindowSizesEditField.Limits(2) = signal_duration - MIN_STEP;
            WindowLength = max(MIN_WINDOW, min(app.WindowSizesEditField.Value, app.WindowSizesEditField.Limits(2)));

            % 2. TimeStep Limits
            app.WindowHopSizesEditField.Limits(1) = MIN_STEP;
            app.WindowHopSizesEditField.Limits(2) = WindowLength;
            TimeStep = max(MIN_STEP, min(app.WindowHopSizesEditField.Value, WindowLength));

            % 3. TimeAvgWin Limits
            nframes_est = floor((signal_duration - WindowLength)/TimeStep) + 1;
            app.CPPsTimeSmoothingWindowsEditField.Limits(1) = TimeStep;
            app.CPPsTimeSmoothingWindowsEditField.Limits(2) = min(WindowLength, nframes_est * TimeStep);
            TimeAvgWin = max(TimeStep, min(app.CPPsTimeSmoothingWindowsEditField.Value, app.CPPsTimeSmoothingWindowsEditField.Limits(2)));

            % 4. QuefrAvgWin Limits
            app.CPPsQuefrencySmoothingWindowsEditField.Limits(1) = MIN_SMOOTH;
            app.CPPsQuefrencySmoothingWindowsEditField.Limits(2) = WindowLength / 2;
            QuefrAvgWin = max(MIN_SMOOTH, min(app.CPPsQuefrencySmoothingWindowsEditField.Value, WindowLength / 2));

            % 5. Final nframes & update UI
            nframes = floor((signal_duration - WindowLength) / TimeStep) + 1;
            

            % Update Values (sync UI)
            app.WindowSizesEditField.Value = WindowLength;
            app.WindowHopSizesEditField.Value = TimeStep;
            app.CPPsTimeSmoothingWindowsEditField.Value = TimeAvgWin;
            app.CPPsQuefrencySmoothingWindowsEditField.Value = QuefrAvgWin;
        end

    end
        
    methods (Access = public)

        function saveCurrentAppState(app,path)
            if nargin<2
                path='lastVocaliscopesettings.mat';
            end

            state = struct();
            props = properties(app);
            for i = 1:length(props)
                name = props{i};
                comp = app.(name);
                c = string(class(comp));

                if isprop(comp, 'Value')
                    state.(name).Value = comp.Value;
                end

                if isprop(comp, 'Enable')
                    state.(name).Enable = comp.Enable;
                end

                if ~isnumeric(comp) && isprop(comp,'UserData') && isfield(comp.UserData,'OverwriteSetting')
                    state.(name).OverwriteSetting=comp.UserData.OverwriteSetting;
                end


                if c == "matlab.ui.container.CheckBoxTree"
                    checkedNodes = comp.CheckedNodes;
                    tags = arrayfun(@(node) string(node.Text), checkedNodes, 'UniformOutput', false);
                    state.(name).CheckedNodes = tags;
                elseif c== "matlab.ui.container.TabGroup"
                    state.(name).SelectedTabIdx=find(comp.Children==comp.SelectedTab);
                end
            end

            save(path, 'state');

        end

        function loadAppState(app,path,skipLoadingOfLastTab,loadOnlyCheckedNodesAndEnabledPropertiesOnly)
            if nargin<2
                path='lastVocaliscopesettings.mat';
            end

            if nargin<3
                skipLoadingOfLastTab=0;
            end

            if nargin<4 || isempty(loadOnlyCheckedNodesAndEnabledPropertiesOnly)
                loadOnlyCheckedNodesAndEnabledPropertiesOnly=0;
            end
        
            if isfile(path)
                load(path, 'state');
        
                fields = fieldnames(state);
                for i = 1:length(fields)
                    name = fields{i};
                    try
                        comp = app.(name);
                        
                        if isfield(state.(name), 'Value') && isprop(comp, 'Value') && (isfield(state.(name),'OverwriteSetting') && state.(name).OverwriteSetting==true || ~loadOnlyCheckedNodesAndEnabledPropertiesOnly)
                            comp.Value = state.(name).Value;
                        end
                        
                        if isfield(state.(name), 'Enable') && isprop(comp, 'Enable') && (isfield(state.(name),'OverwriteSetting') && state.(name).OverwriteSetting==true || ~loadOnlyCheckedNodesAndEnabledPropertiesOnly)
                            comp.Enable = state.(name).Enable;
                        end

                        if isfield(state.(name), 'CheckedNodes') && strcmp(class(comp), "matlab.ui.container.CheckBoxTree")
                            tags = state.(name).CheckedNodes;
                            checkedNodes = [];
                            for ii = 1:numel(tags)
                                node = findall(comp, 'Text', tags{ii});
                                if ~isempty(node)
                                    checkedNodes = [checkedNodes; node];
                                end
                            end
                            comp.CheckedNodes = checkedNodes;
                        end

                        if isfield(state.(name), 'SelectedTabIdx') && strcmp(class(comp), "matlab.ui.container.TabGroup") && ~skipLoadingOfLastTab && ~loadOnlyCheckedNodesAndEnabledPropertiesOnly
                            comp.SelectedTab=comp.Children(state.(name).SelectedTabIdx);
                        end
                    catch err
                        disp(['Did not use saved field ', name, ': ', err.identifier])
                    end
                end
            end
            
            if app.WindowedAnalysisCheckBox.Value==1 % we want windowed mode
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Value);
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Value);
            elseif ~isinf(app.WindowLengthmsEditField.Limits(2))
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
            end
            %app.pitchAnalysisTimeLengthEditField.Value=app.WindowLengthmsEditField.Value;

            app.PitchanalysistimewindowoverlapSlider.Limits(2)=app.PitchanalysistimewindowSlider.Value-1;
            app.PitchAnalysisWindowOverlapEditField.Limits(2)=app.PitchanalysistimewindowSlider.Value-1;
            %app.PitchAnalysisWindowOverlapEditField.Value=app.WindowLengthmsEditField.Value-1;

            if app.useUpperFoPredictionStateButton.Value==1
                app.useUpperFoPredictionStateButton.BackgroundColor=[0.29,0.86,0.25];
                app.useUpperFoPredictionStateButton.Text='Use time dependent maximum <i>f</i><sub>o</sub>  (active)';
            else
                app.useUpperFoPredictionStateButton.BackgroundColor=[0.96,0.96,0.96];
                app.useUpperFoPredictionStateButton.Text='Use time dependent maximum <i>f</i><sub>o</sub>  (inactive)';
            end


            %% set node checked User Data after setting the nodes checked state
            mainNodes=app.ParametersTree.Children;

            for nr=1:numel(mainNodes)
                for subNr=1:numel(mainNodes(nr).UserData.ChildNodes)
                    mainNodes(nr).UserData.ChildNodes(subNr).UserData.Checked=ismember(mainNodes(nr).UserData.ChildNodes(subNr),app.ParametersTree.CheckedNodes);
                end
            end

            %% filter text shall always be empty
            app.FilterParameterToCalculateEditField.Value='';

        end


        
        function setMaximumWindowLength(app,val)
            if val*1000<=app.WindowOverlapmsEditField.Value
                app.WindowOverlapmsEditField.Value=val*1000-1;
            end

            app.WindowLengthmsEditField.Limits(2)=val*1000;
            app.WindowOverlapmsEditField.Limits(2)=val*1000-1;

            if app.WindowedAnalysisCheckBox==1 % we want windowed mode
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Value);
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Value);
            else
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
            end

            app.update_cpp_limits();
            
        end
        
        function checkIfAnyChannelCanBeUsedAsMask(app)

            if isempty(app.channelsSuitableAsMask)
                app.UsemaskCheckBox.Value=0;
                set([app.UsemaskCheckBox app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','off');
                app.ChosenChannelEditField.Value=[];
            else
                set([app.UsemaskCheckBox app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','on');

                % we allow only to keep the mask channel value if the
                % channel is part of channelsSuitableAsMask, if not, remove
                % the entry and uncheck
                if ~ismember(app.ChosenChannelEditField.Value,app.channelsSuitableAsMask)
                    app.ChosenChannelEditField.Value=[];
                    app.UsemaskCheckBox.Value=0;
                    set([app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','off');
                end
            end
            
        end

        function collectSettings(app)
            %allSubnodes=get([app.ParametersTree.Children],'Children');

            %allSubnodes=vertcat(allSubnodes{:});



            app.outputSettings.useWindows=app.WindowedAnalysisCheckBox.Value;
            app.outputSettings.useMask=app.UsemaskCheckBox.Value;
            app.outputSettings.maskChannelNumber=app.ChosenChannelEditField.Value;
            app.outputSettings.windowLength=app.WindowLengthmsEditField.Value/1000; % to s
            app.outputSettings.windowOverlap=app.WindowOverlapmsEditField.Value/1000; % to s
            app.outputSettings.windowHopLength=(app.WindowLengthmsEditField.Value-app.WindowOverlapmsEditField.Value)/1000;

            app.outputSettings.fo.Min=app.minimumfoHzEditField.Value;
            app.outputSettings.fo.Max=app.maximumfoHzEditField.Value;
            app.outputSettings.fo.useAbsoluteCyclePeakProminence=app.CyclePeakProminenceTypeSwitch.Value;
            app.outputSettings.fo.absoluteCyclePeakProminence=app.absoluitepeakprominenceEditField.Value;
            app.outputSettings.fo.relativeCyclePeakProminence=app.relativepeakprominenceinreferencetowindowmaximumEditField.Value;

            app.outputSettings.pitch.timeWindow=app.PitchanalysistimewindowSlider.Value/1000;
            app.outputSettings.pitch.timeWindowOverlap=app.PitchanalysistimewindowoverlapSlider.Value/1000;
            app.outputSettings.pitch.useTimeDependentUpperMax=app.useUpperFoPredictionStateButton.Value;
            app.outputSettings.pitch.timeDependentUpperMaxAlgorithm=app.upperFoPredictionAlgorithmDropdown.Value;
            app.outputSettings.pitch.timeDependentUpperMaxMarginFactor=app.upperFoPredictionFactorDropdown.Value;
            app.outputSettings.pitch.doCalculate=app.FundamentalFrequencyHzNode.UserData.Checked;

            app.outputSettings.generalFFT.windowType=app.generalFFTwindow.Value;
            app.outputSettings.generalFFT.minimumFreqRes=app.RequestedminimumFFTfrequencyresolutionEditField.Value;
            app.outputSettings.generalFFT.interpolationMethod=app.SpectruminterpolationmethodDropDown.Value;

            app.outputSettings.harmonics.maxOrder=app.MaximumnumberofharmonicstolookforEditField.Value;
            app.outputSettings.harmonics.percentageThreshold = app.MinimumsubharmonicfouriercoefficientvalueEditField.Value/100;
            app.outputSettings.harmonics.doCalculate = app.MaximumHarmonicHzNode.UserData.Checked;


            app.outputSettings.subharmonics.maxOrder=app.MaximumnumberofsubharmonicstolookforEditField.Value;
            app.outputSettings.subharmonics.percentageThreshold = app.MinimumsubharmonicfouriercoefficientvalueEditField.Value/100;
            app.outputSettings.subharmonics.doCalculate = app.MinimumSubharmonicHzNode.UserData.Checked;

            app.outputSettings.cycleDuration.Min=app.minimumcycledurationmsEditField.Value/1000;
            app.outputSettings.cycleDuration.Max=app.maximumcycledurationmsEditField.Value/1000;
            app.outputSettings.cycleDuration.showSeparate1overCycleDurationPlot=app.showseparateplotof1cycledurationCheckBox.Value;

            app.outputSettings.plateauQuotientThreshold=app.PlateauQuotientThresholdEditField.Value/100;
            app.outputSettings.GAWopenThresholdPercentage=app.GAWopenthresholdinoflocalmaximumEditField.Value/100;

            app.outputSettings.SampleEntropyTime.distanceSTDthreshold=app.SampEnTimeTemplatedistancethresholdofstdEditField.Value/100;
            app.outputSettings.SampleEntropyTime.templateLengthMethod=app.SampEnTimeTemplatelengthmethodDropDown.Value;
            app.outputSettings.SampleEntropyTime.templateLengthFixed=app.SampEnTimeTemplatefixedlengthsamplesEditField.Value;
            app.outputSettings.SampleEntropyTime.normalizationMethod=app.SampEnTimeNormalizationmethodDropDown.Value;
            app.outputSettings.SampleEntropyTime.normalizationHorizont=app.SampEnTimeNormalizationhorizontDropDown.Value;
            app.outputSettings.SampleEntropyTime.doCalculate = app.sampleentropytimedomainNode.UserData.Checked;

            app.outputSettings.SampleEntropyFD.distanceSTDthresholdMagnitude=app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Value/100;
            app.outputSettings.SampleEntropyFD.distanceSTDthresholdPhase=app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Value/100;
            app.outputSettings.SampleEntropyFD.templateLengthMethod=app.SampEnFDtemplatelengthmethodDropDown.Value;
            app.outputSettings.SampleEntropyFD.templateLengthFixed=app.SampEnFDtemplatefixedlengthsamplesEditField.Value;
            app.outputSettings.SampleEntropyFD.useRelativeFD=strcmpi(app.SampEnFDuserelativeFourierDescriptorsDropDown.Value,'Yes');
            app.outputSettings.SampleEntropyFD.combinationMethod=app.SampEnFDfinalcombinationmethodDropDown.Value;
            app.outputSettings.SampleEntropyFD.numberOfHarmonics=app.SampEnFDnumberofharmonicstobeusedEditField.Value;
            app.outputSettings.SampleEntropyFD.sex=app.RawSelamtzisSexSwitch.Value;
            app.outputSettings.SampleEntropyFD.doCalculate = app.cyclebasedspectralsampleentropyNode.UserData.Checked;


            app.outputSettings.SampleEntropyFDfixedNumberOfCycles.sex=app.RawSelamtzisSexSwitch.Value;
            app.outputSettings.SampleEntropyFDfixedNumberOfCycles.showInternalCycleDetection =app.PlotrawsampleentropyCheckBox.Value;
            app.outputSettings.SampleEntropyFDfixedNumberOfCycles.doNormalizeSampEn=app.ScaleSampEntorange0to1CheckBox.Value;
            app.outputSettings.SampleEntropyFDfixedNumberOfCycles.doCalculate = app.spectralEntropyNode.UserData.Checked;

            app.outputSettings.CPPv1.windowType=app.CepstrumWindowTypeDropDown.Value;
            app.outputSettings.CPPv1.lowerQuefrencyLimit=app.LowerQuefrencyLimitsEditField.Value;
            app.outputSettings.CPPv1.upperQuefrencyLimit=app.UpperQuefrencyLimitsEditField.Value;
            app.outputSettings.CPPv1.maxInFitRegion=app.CepstrumMaxInFitRegionOnlyDropDown.Value;
            app.outputSettings.CPPv1.fitMethod=app.BaselinefittingtypeDropDown.Value;
            app.outputSettings.CPPv1.robustMethod=app.RobustfittingmethodDropDown.Value;
            app.outputSettings.CPPv1.doCalculate = app.CepstralPeakProminenceIdBCPPNode.UserData.Checked;


            app.outputSettings.CPPv3.resamplingFrequency = app.ResamplingFrequencyHzEditField.Value;
            app.outputSettings.CPPv3.windowType=app.CepstrumWindowTypeDropDown.Value;
            app.outputSettings.CPPv3.usePreemphasis = app.UsePreemphasisDropDown.Value==1;
            app.outputSettings.CPPv3.windowLength = app.WindowSizesEditField.Value;
            app.outputSettings.CPPv3.windowHopLength = app.WindowHopSizesEditField.Value;
            app.outputSettings.CPPv3.TimeSmoothingWindowLength=app.CPPsTimeSmoothingWindowsEditField.Value;
            app.outputSettings.CPPv3.QuefrencySmoothingWindowLength=app.CPPsQuefrencySmoothingWindowsEditField.Value;
            app.outputSettings.CPPv3.lowerQuefrencyLimit=app.LowerQuefrencyLimitsEditField.Value;
            app.outputSettings.CPPv3.upperQuefrencyLimit=app.UpperQuefrencyLimitsEditField.Value;
            app.outputSettings.CPPv3.lowerFo=app.minimumfoHzEditField.Value;
            app.outputSettings.CPPv3.upperFo=app.maximumfoHzEditField.Value;
            app.outputSettings.CPPv3.fitMethod=app.BaselinefittingtypeDropDown.Value;
            app.outputSettings.CPPv3.robustMethod=app.RobustfittingmethodDropDown.Value;
            app.outputSettings.CPPv3.doCalculate = app.CepstralPeakProminenceSmoothedv3dBCPPsNode.UserData.Checked;




            app.outputSettings.SPL.doCalculate = app.SoundPressureLevelSPLdBAdBCdBZNode.UserData.Checked;

            %% Raw data node settings
            app.outputSettings.signalMean.doCalculate = app.MeanarithmeticharmonicgeometricNode.UserData.Checked;
            app.outputSettings.signalStd.doCalculate = app.standarddeviationSTDNode.UserData.Checked;
            app.outputSettings.signalMedian.doCalculate = app.MedianNode.UserData.Checked;
            app.outputSettings.signalMode.doCalculate = app.ModeNode.UserData.Checked;
            app.outputSettings.signalMinMax.doCalculate = app.MinimumMaximumNode.UserData.Checked;
            app.outputSettings.signalIQR.doCalculate = app.InterquartilerangeIQRNode.UserData.Checked;
            app.outputSettings.signalKurtosis.doCalculate = app.KurtosisNode.UserData.Checked;
            app.outputSettings.signalSkewness.doCalculate = app.SkewnessNode.UserData.Checked;
            app.outputSettings.signalSummedSquares.doCalculate = app.SumofsquarevaluesNode.UserData.Checked;
            app.outputSettings.signalRMS.doCalculate = app.roommeansquareRMSNode.UserData.Checked;
            app.outputSettings.signalQuantiles.doCalculate = app.Quantilesfrom5in5stepsto95Node.UserData.Checked;

            %% node data of spectral descriptors like spectral crest, skewness etc
            app.outputSettings.spectralCrest.doCalculate = app.spectralCrestNode.UserData.Checked;
            app.outputSettings.spectralFlux.doCalculate = app.spectralFluxNode.UserData.Checked;
            app.outputSettings.spectralSpread.doCalculate = app.spectralSpreadNode.UserData.Checked;
            app.outputSettings.spectralSkewness.doCalculate = app.spectralSkewnessspectralTiltNode.UserData.Checked;
            app.outputSettings.spectralKurtosis.doCalculate = app.spectralKurtosisNode.UserData.Checked;
            app.outputSettings.spectralCentroid.doCalculate = app.spectralCentroidNode.UserData.Checked;
            app.outputSettings.spectralEntropy.doCalculate = app.spectralEntropyNode.UserData.Checked;
            app.outputSettings.spectralSlope.doCalculate = app.spectralSlopeNode.UserData.Checked;
            app.outputSettings.spectralDecrease.doCalculate = app.spectralDecreaseNode.UserData.Checked;
            app.outputSettings.spectralRolloffPoint.doCalculate = app.spectralRolloffPointNode.UserData.Checked;
            app.outputSettings.spectralFlatness.doCalculate = app.SpectralFlatnessNode.UserData.Checked;
            app.outputSettings.harmonicRatio.doCalculate = app.harmonicRatioNode.UserData.Checked;
            app.outputSettings.zeroCrossingRate.doCalculate = app.zerocrossrateNode.UserData.Checked;
            app.outputSettings.SNRdBcarrier.doCalculate = app.SignaltoNoiseRatiodBcarrierSNRNode.UserData.Checked;
            app.outputSettings.HNRXCorrBiased.doCalculate = app.HarmonictoNoiseRatioHNRviabiasedxcorrNode.UserData.Checked;

            %% amplitude perturbation
            app.outputSettings.meanShimmer.doCalculate = app.MeanShimmerdBNode.UserData.Checked;
            app.outputSettings.shimmerInPercent.doCalculate = app.ShimmerNode.UserData.Checked;
            app.outputSettings.APQ.doCalculate = app.AmplitudePerturbationQuotientAPQNode.UserData.Checked;
            app.outputSettings.APF.doCalculate = app.AmplitudePerturbationFactorAPFNode.UserData.Checked;
            app.outputSettings.AVI.doCalculate = app.AmplitudeVariabilityIndexdBAVINode.UserData.Checked;
            app.outputSettings.RAPforCycleRange.doCalculate = app.RelativeaverageperturbationRAPforcyclerangeNode.UserData.Checked;

            %% Period Perturbation
            app.outputSettings.meanJitter.doCalculate = app.MeanJittermsNode.UserData.Checked;
            app.outputSettings.jitterInPercent.doCalculate = app.JitterNode.UserData.Checked;
            app.outputSettings.jitterRatio.doCalculate = app.JitterRatioNode.UserData.Checked;
            app.outputSettings.jitterFactor.doCalculate = app.JitterFactorNode.UserData.Checked;
            app.outputSettings.PPQ.doCalculate = app.PeriodPerturbationQuotientPPQNode.UserData.Checked;
            app.outputSettings.PPF.doCalculate = app.PeriodPerturbationFactorPPFNode.UserData.Checked;
            app.outputSettings.PVI.doCalculate = app.PeriodVariabilityIndexPVINode.UserData.Checked;
            app.outputSettings.RAPv1.doCalculate = app.RelativeAveragePerturbationV1RAPNode.UserData.Checked;
            app.outputSettings.RAPv2.doCalculate = app.RelativeAveragePerturbationV2RAPNode.UserData.Checked;

            %% Energy Perturbation
            app.outputSettings.EPQ.doCalculate = app.EnergyPerturbationQuotientEPQNode.UserData.Checked;
            app.outputSettings.EPF.doCalculate = app.EnergyPerturbationFactorEPFNode.UserData.Checked;
            app.outputSettings.EVI.doCalculate = app.EnergyVariabilityIndexPVINode.UserData.Checked;
            app.outputSettings.RAPforCycleEnergy.doCalculate = app.RelativeaverageperturbationRAPforcycleenergyNode.UserData.Checked;

            %% Noise measures
            app.outputSettings.GNEv2.doCalculate = app.GlottaltoNoiseExcitationRatioGNEv2Node.UserData.Checked; % according T. Tsanas

            %% psychoacoustic measures

            app.outputSettings.acousticLoudness.doCalculate = app.AcousticLoudnessNode.UserData.Checked;
            app.outputSettings.acousticFluctuation.doCalculate = app.AcousticFluctuationNode.UserData.Checked;
            app.outputSettings.acousticRoughness.doCalculate = app.AcousticRoughnessNode.UserData.Checked;
            app.outputSettings.acousticSharpness.doCalculate = app.AcousticSharpnessNode.UserData.Checked;



            %% if settings shall be deleted or not when vocaliscope is closed
            app.keepVocaliscopeSettingsOverSession=app.KeepSettingsoverSessionsCheckBox.Value;

        end


    end % end public access
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, batchMode)
            if nargin<2 || isempty(batchMode)
                app.batchMode=0;
            else
                app.batchMode=1;
            end

%             expand(app.ParametersTree,'all');
            collapse(app.ParametersTree,'all');

            if ~app.batchMode
                movegui(app.UIFigure,'center');
            end

            app.parameterExplanation.Interpreter='tex';

            % get parameter discription and assign to node data
            app.assignParameterDescriptionToNodeData();

           


            %% remove nodes that are not implemented yet
            % we have to keep that synchron to the actual calculated
            % parameters

            % noise measurements
            app.HarmonicsIntensityNode.Parent=[];
            app.HarmonicstoNoiseRatiodBHNRNode.Parent=[];
            app.NormalizedNoiseEnergydBNNENode.Parent=[];
            app.WaveformMatchingCoefcientWMCNode.Parent=[];
            app.MeanWaveformMatchingCoefcientNode.Parent=[];
            app.SignaltoNoiseRatioV1dBSNRNode.Parent=[];
            app.SignaltoNoiseRatioV2dBSNRNode.Parent=[];
            app.CepstralPeakProminenceIIdBCPPNode.Parent=[];

            % mechanical
            app.MechanicalMeasuresNode.Parent=[]; % the main node and their children

            app.Stiffness1sNode.Parent=[];
            app.PeakClosingVelocitypxsNode.Parent=[];
            app.PeakAccelerationpxs2Node.Parent=[];
            app.AmplitudetoLengthRatioNode.Parent=[];

            % glottal area symmetry measurements
            app.GlottalAreaSymmetryMeasuresNode.Parent=[];


            %%
            app.addFilterPossibility();

            

            
        end

        % Value changed function: minimumfoHzEditField
        function minimumfoHzEditFieldValueChanged(app, event)
            value = app.minimumfoHzEditField.Value;

            if value>app.maximumfoHzEditField.Value
                app.maximumfoHzEditField.Value=value;
                app.minimumcycledurationmsEditField.Value=1/value*1000;
            end

            calcval=1/value*1000;
            if calcval~=app.maximumcycledurationmsEditField.Value
                app.maximumcycledurationmsEditField.Value=calcval;
            end
        end

        % Value changed function: maximumfoHzEditField
        function maximumfoHzEditFieldValueChanged(app, event)
            value = app.maximumfoHzEditField.Value;

            if value<app.minimumfoHzEditField.Value
                app.minimumfoHzEditField.Value=value;
                app.maximumcycledurationmsEditField.Value=1/value*1000;
            end

            calcval=1/value*1000;
            if calcval~=app.minimumcycledurationmsEditField.Value
                app.minimumcycledurationmsEditField.Value=calcval;
            end

            app.LowerQuefrencyLimitsEditField.Limits(2)=1/value;
        end

        % Value changed function: maximumcycledurationmsEditField
        function maximumcycledurationmsEditFieldValueChanged(app, event)
            value = app.maximumcycledurationmsEditField.Value;

            if value<app.minimumcycledurationmsEditField.Value
                app.minimumcycledurationmsEditField.Value=value;
                app.maximumfoHzEditField.Value=1/(value/1000);
            end
            
            calcval=1/(value/1000);
            if calcval~=app.minimumfoHzEditField.Value
                app.minimumfoHzEditField.Value=calcval;
            end
        end

        % Value changed function: minimumcycledurationmsEditField
        function minimumcycledurationmsEditFieldValueChanged(app, event)
            value = app.minimumcycledurationmsEditField.Value;

            if value>app.maximumcycledurationmsEditField.Value
                app.maximumcycledurationmsEditField.Value=value;
                app.minimumfoHzEditField.Value=1/(value/1000);
            end
            
            calcval=1/(value/1000);
            if calcval~=app.maximumfoHzEditField.Value
                app.maximumfoHzEditField.Value=calcval;
            end

            app.LowerQuefrencyLimitsEditField.Limits(2)=value/1000;
        end

        % Callback function: ParametersTree
        function ParametersTreeCheckedNodesChanged(app, event)
            % keep fundamental frequencies checked like in msa
            for chNr=1:numel(app.FundamentalFrequencyMeasuresNode.Children)
                currChild=app.FundamentalFrequencyMeasuresNode.Children(chNr);
                if ~ismember(currChild,app.ParametersTree.CheckedNodes) && (currChild ~= app.MaximumHarmonicHzNode && currChild ~= app.MinimumSubharmonicHzNode)
                    app.ParametersTree.CheckedNodes=[app.ParametersTree.CheckedNodes; currChild];
                end
            end

            

            
        end

        % Selection changed function: ParametersTree
        function ParametersTreeSelectionChanged(app, event)
            selectedNodes = app.ParametersTree.SelectedNodes;
            if isempty(app.ParametersTree.SelectedNodes.NodeData)
                app.parameterExplanation.Text='';
            else
                app.parameterExplanation.Text=app.ParametersTree.SelectedNodes.NodeData;
            end

        end

        % Button pushed function: ExpandallnodesButton
        function ExpandallnodesButtonPushed(app, event)
            expand(app.ParametersTree,'all');
        end

        % Button pushed function: CollapseallnodesButton
        function CollapseallnodesButtonPushed(app, event)
            collapse(app.ParametersTree,'all');
        end

        % Button pushed function: CheckallButton
        function CheckallButtonPushed(app, event)
            mainNodes=app.ParametersTree.Children;

            for nr=1:numel(mainNodes)
                app.ParametersTree.CheckedNodes=[app.ParametersTree.CheckedNodes; mainNodes(nr)];

                for subNr=1:numel(mainNodes(nr).UserData.ChildNodes)
                    mainNodes(nr).UserData.ChildNodes(subNr).UserData.Checked=true;
                end
            end

        end

        % Button pushed function: UncheckallButton
        function UncheckallButtonPushed(app, event)
            if ~isempty(app.CycleDurationmsNode.Parent)
                app.ParametersTree.CheckedNodes=[app.CycleDurationmsNode];
            end

            mainNodes=app.ParametersTree.Children;
            for nr=1:numel(mainNodes)

                for subNr=1:numel(mainNodes(nr).UserData.ChildNodes)
                    mainNodes(nr).UserData.ChildNodes(subNr).UserData.Checked=false;
                end
            end

            % keep cycle duration checked, at least the Meta data
            app.CycleDurationmsNode.UserData.Checked=true;
        end

        % Value changed function: WindowLengthmsEditField
        function WindowLengthmsEditFieldValueChanged(app, event)
            value = app.WindowLengthmsEditField.Value;
            if app.WindowOverlapmsEditField.Value>=value
                app.WindowOverlapmsEditField.Value=value-1;
            end

            app.PitchanalysistimewindowSlider.Limits(2)=app.WindowLengthmsEditField.Value;
        end

        % Value changed function: WindowedAnalysisCheckBox
        function WindowedAnalysisCheckBoxValueChanged(app, event)
            value = app.WindowedAnalysisCheckBox.Value;
            
            set([app.WindowLengthmsEditField app.WindowOverlapmsEditField app.WindowLengthmsEditFieldLabel app.WindowOverlapmsEditFieldLabel],'Enable',value);

            if value==1
                app.UsemaskCheckBox.Value=0;
                app.ChosenChannelEditField.Value=[];
                set([app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','off')
            end

            % setting the pitch window size limits
            if value==1 % we want windowed mode
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Value);
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Value);
            elseif ~isinf(app.WindowLengthmsEditField.Limits(2))
                app.PitchanalysistimewindowSlider.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
                app.pitchAnalysisTimeLengthEditField.Limits(2)=floor(app.WindowLengthmsEditField.Limits(2));
            end
            
        end

        % Button pushed function: previewcyclesButton
        function previewcyclesButtonPushed(app, event)
            app.calledAsPreview = 1;
            app.collectSettings();
        end

        % Value changed function: showseparateplotof1cycledurationCheckBox
        function showseparateplotof1cycledurationCheckBoxValueChanged(app, event)
            value = app.showseparateplotof1cycledurationCheckBox.Value;
            app.showseparateplotof1cycledurationCheckBox_2.Value=value;
        end

        % Value changed function: 
        % showseparateplotof1cycledurationCheckBox_2
        function showseparateplotof1cycledurationCheckBox_2ValueChanged(app, event)
            value = app.showseparateplotof1cycledurationCheckBox_2.Value;
            app.showseparateplotof1cycledurationCheckBox.Value=value;
        end

        % Button pushed function: calculateparametersButton
        function calculateparametersButtonPushed(app, event)
            app.calledAsPreview = 0;
            app.collectSettings();
        end

        % Value changed function: WindowOverlapmsEditField
        function WindowOverlapmsEditFieldValueChanged(app, event)
            value = app.WindowOverlapmsEditField.Value;

            
            if value>=app.WindowLengthmsEditField.Value
                app.WindowLengthmsEditField.Value=value+1;
            end
        end

        % Value changed function: SampEnTimeTemplatelengthmethodDropDown
        function SampEnTimeTemplatelengthmethodDropDownValueChanged(app, event)
            value = app.SampEnTimeTemplatelengthmethodDropDown.Value;
            if strcmp(value,'fixed length')
                app.SampEnTimeTemplatefixedlengthsamplesEditField.Enable='on';
            else
                app.SampEnTimeTemplatefixedlengthsamplesEditField.Enable='off';
            end
        end

        % Value changed function: SampEnTimeNormalizationmethodDropDown
        function SampEnTimeNormalizationmethodDropDownValueChanged(app, event)
            value = app.SampEnTimeNormalizationmethodDropDown.Value;
            if strcmp(value,'none')
                app.SampEnTimeNormalizationhorizontDropDown.Enable="off";
            else
                app.SampEnTimeNormalizationhorizontDropDown.Enable="on";
            end
        end

        % Value changed function: SampEnFDtemplatelengthmethodDropDown
        function SampEnFDtemplatelengthmethodDropDownValueChanged(app, event)
            value = app.SampEnFDtemplatelengthmethodDropDown.Value;
            if strcmp(value,'fixed length')
                app.SampEnFDtemplatefixedlengthsamplesEditField.Enable='on';
            else
                app.SampEnFDtemplatefixedlengthsamplesEditField.Enable='off';
            end
            
        end

        % Value changed function: CyclePeakProminenceTypeSwitch
        function CyclePeakProminenceTypeSwitchValueChanged(app, event)
            value = app.CyclePeakProminenceTypeSwitch.Value;
            
            if value
                app.absoluitepeakprominenceEditField.Enable="on";
                app.absoluitepeakprominenceEditFieldLabel.Enable='on';
                app.relativepeakprominenceinreferencetowindowmaximumEditField.Enable='off';
                app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Enable='off';
            else
                app.absoluitepeakprominenceEditField.Enable="off";
                app.absoluitepeakprominenceEditFieldLabel.Enable='off';
                app.relativepeakprominenceinreferencetowindowmaximumEditField.Enable='on';
                app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Enable='on';
            end
        end

        % Value changing function: PitchanalysistimewindowSlider
        function PitchanalysistimewindowSliderValueChanging(app, event)
            changingValue = event.Value;
            app.pitchAnalysisTimeLengthEditField.Value=changingValue;

            if app.PitchanalysistimewindowoverlapSlider.Value>changingValue-1
                app.PitchanalysistimewindowoverlapSlider.Value=changingValue-1;
                app.PitchAnalysisWindowOverlapEditField.Value=changingValue-1;
            end
            app.PitchanalysistimewindowoverlapSlider.Limits(2)=changingValue-1;
        end

        % Value changing function: PitchanalysistimewindowoverlapSlider
        function PitchanalysistimewindowoverlapSliderValueChanging(app, event)
            changingValue = event.Value;
            app.PitchAnalysisWindowOverlapEditField.Value=changingValue;
        end

        % Value changed function: UsemaskCheckBox
        function UsemaskCheckBoxValueChanged(app, event)
            value = app.UsemaskCheckBox.Value;
            
            set([app.WindowLengthmsEditField app.WindowOverlapmsEditField app.WindowLengthmsEditFieldLabel app.WindowOverlapmsEditFieldLabel],'Enable','off');

            if value==1
                app.WindowedAnalysisCheckBox.Value=0;
                

                [chosenChannelIdx,tf] = listdlg('PromptString',{'Choose channel' 'containing mask'},...
                'SelectionMode','single','ListString',strsplit(num2str(app.channelsSuitableAsMask)));

                if tf==0 % if user aborts selection
                    app.UsemaskCheckBox.Value=0;
                    app.ChosenChannelEditField.Value=[];
                    set([app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','off')
                    return;
                end

                app.ChosenChannelEditField.Value=app.channelsSuitableAsMask(chosenChannelIdx);
                set([app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','on')
            else
                app.ChosenChannelEditField.Value=[];
                set([app.channelusedasmaskLabel app.ChosenChannelEditField],'Enable','off')
            end


        end

        % Button pushed function: loadSettingsfromfileButton
        function loadSettingsfromfileButtonPushed(app, event)
            persistent lastPath;
                
            [file,folder]=uigetfile('lastVocaliscopesettings.mat','load settings from file',lastPath);

            if isequal(file,0)
                return;
            end

            lastPath=folder;

            path=fullfile(folder,file);
            availableVars=who(matfile(path));
            if ismember({'state'},availableVars)
                skipLastTabLoading=1;
                app.loadAppState(path,skipLastTabLoading);
                uialert(app.UIFigure,'Loading settings successfull','Success','Icon','success');
            else
                uialert(app.UIFigure,'No app state saved in this mat file','Error','Icon','error');
            end
        end

        % Value changed function: useUpperFoPredictionStateButton
        function useUpperFoPredictionStateButtonValueChanged(app, event)
            % this function enables and disables the dropdowns to set the
            % prediction values

            value = app.useUpperFoPredictionStateButton.Value;
            
            if value==1
                app.useUpperFoPredictionStateButton.Text=strrep(app.useUpperFoPredictionStateButton.Text,'inactive','active');
                app.useUpperFoPredictionStateButton.BackgroundColor=[0.29,0.86,0.25];

                set([app.upperFoPredictionAlgorithmDropdown app.upperFoPredictionFactorDropdown],'Enable','on')
            else
                app.useUpperFoPredictionStateButton.Text=strrep(app.useUpperFoPredictionStateButton.Text,'active','inactive');
                app.useUpperFoPredictionStateButton.BackgroundColor=[0.96,0.96,0.96];

                set([app.upperFoPredictionAlgorithmDropdown app.upperFoPredictionFactorDropdown],'Enable','off')

            end
        end

        % Value changed function: CPPsQuefrencySmoothingWindowsEditField, 
        % ...and 4 other components
        function updateCppLimitsCallback(app, event)
            app.update_cpp_limits();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 801 506];
            app.UIFigure.Name = 'Vocaliscope Settings';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {35, '1x', 'fit'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 5;
            app.GridLayout.Padding = [0 1 0 0];

            % Create SettingsLabel
            app.SettingsLabel = uilabel(app.GridLayout);
            app.SettingsLabel.HorizontalAlignment = 'center';
            app.SettingsLabel.FontSize = 25;
            app.SettingsLabel.FontWeight = 'bold';
            app.SettingsLabel.Layout.Row = 1;
            app.SettingsLabel.Layout.Column = [1 4];
            app.SettingsLabel.Text = 'Settings';

            % Create loadSettingsfromfileButton
            app.loadSettingsfromfileButton = uibutton(app.GridLayout, 'push');
            app.loadSettingsfromfileButton.ButtonPushedFcn = createCallbackFcn(app, @loadSettingsfromfileButtonPushed, true);
            app.loadSettingsfromfileButton.Layout.Row = 1;
            app.loadSettingsfromfileButton.Layout.Column = 4;
            app.loadSettingsfromfileButton.Text = 'load Settings from file';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 2;
            app.TabGroup.Layout.Column = [1 4];

            % Create GeneralTab
            app.GeneralTab = uitab(app.TabGroup);
            app.GeneralTab.Title = 'General';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GeneralTab);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', 'fit', '1x'};
            app.GridLayout2.ColumnSpacing = 5;
            app.GridLayout2.RowSpacing = 5;
            app.GridLayout2.Padding = [5 5 5 5];

            % Create ifisubosubandcycledurationrangeLabel
            app.ifisubosubandcycledurationrangeLabel = uilabel(app.GridLayout2);
            app.ifisubosubandcycledurationrangeLabel.Layout.Row = 1;
            app.ifisubosubandcycledurationrangeLabel.Layout.Column = [1 2];
            app.ifisubosubandcycledurationrangeLabel.Interpreter = 'html';
            app.ifisubosubandcycledurationrangeLabel.Text = '<i>f</i><sub>o</sub> and cycle duration range';

            % Create WindowedAnalysisCheckBox
            app.WindowedAnalysisCheckBox = uicheckbox(app.GridLayout2);
            app.WindowedAnalysisCheckBox.ValueChangedFcn = createCallbackFcn(app, @WindowedAnalysisCheckBoxValueChanged, true);
            app.WindowedAnalysisCheckBox.Text = 'Windowed Analysis';
            app.WindowedAnalysisCheckBox.WordWrap = 'on';
            app.WindowedAnalysisCheckBox.Layout.Row = 1;
            app.WindowedAnalysisCheckBox.Layout.Column = 6;
            app.WindowedAnalysisCheckBox.Value = true;

            % Create UsemaskCheckBox
            app.UsemaskCheckBox = uicheckbox(app.GridLayout2);
            app.UsemaskCheckBox.ValueChangedFcn = createCallbackFcn(app, @UsemaskCheckBoxValueChanged, true);
            app.UsemaskCheckBox.Text = 'Use mask';
            app.UsemaskCheckBox.WordWrap = 'on';
            app.UsemaskCheckBox.Layout.Row = 1;
            app.UsemaskCheckBox.Layout.Column = 8;

            % Create minimumifisubosubHzEditFieldLabel
            app.minimumifisubosubHzEditFieldLabel = uilabel(app.GridLayout2);
            app.minimumifisubosubHzEditFieldLabel.HorizontalAlignment = 'right';
            app.minimumifisubosubHzEditFieldLabel.WordWrap = 'on';
            app.minimumifisubosubHzEditFieldLabel.Layout.Row = 2;
            app.minimumifisubosubHzEditFieldLabel.Layout.Column = 1;
            app.minimumifisubosubHzEditFieldLabel.Interpreter = 'html';
            app.minimumifisubosubHzEditFieldLabel.Text = 'minimum <i>f</i><sub>o</sub> (Hz)';

            % Create minimumfoHzEditField
            app.minimumfoHzEditField = uieditfield(app.GridLayout2, 'numeric');
            app.minimumfoHzEditField.Limits = [0 Inf];
            app.minimumfoHzEditField.ValueChangedFcn = createCallbackFcn(app, @minimumfoHzEditFieldValueChanged, true);
            app.minimumfoHzEditField.Layout.Row = 2;
            app.minimumfoHzEditField.Layout.Column = 2;
            app.minimumfoHzEditField.Value = 50;

            % Create maximumcycledurationmsEditFieldLabel
            app.maximumcycledurationmsEditFieldLabel = uilabel(app.GridLayout2);
            app.maximumcycledurationmsEditFieldLabel.HorizontalAlignment = 'right';
            app.maximumcycledurationmsEditFieldLabel.WordWrap = 'on';
            app.maximumcycledurationmsEditFieldLabel.Layout.Row = 2;
            app.maximumcycledurationmsEditFieldLabel.Layout.Column = 3;
            app.maximumcycledurationmsEditFieldLabel.Text = 'maximum cycle duration (ms)';

            % Create maximumcycledurationmsEditField
            app.maximumcycledurationmsEditField = uieditfield(app.GridLayout2, 'numeric');
            app.maximumcycledurationmsEditField.Limits = [0 Inf];
            app.maximumcycledurationmsEditField.ValueChangedFcn = createCallbackFcn(app, @maximumcycledurationmsEditFieldValueChanged, true);
            app.maximumcycledurationmsEditField.Layout.Row = 2;
            app.maximumcycledurationmsEditField.Layout.Column = 4;
            app.maximumcycledurationmsEditField.Value = 20;

            % Create WindowLengthmsEditFieldLabel
            app.WindowLengthmsEditFieldLabel = uilabel(app.GridLayout2);
            app.WindowLengthmsEditFieldLabel.HorizontalAlignment = 'center';
            app.WindowLengthmsEditFieldLabel.WordWrap = 'on';
            app.WindowLengthmsEditFieldLabel.Layout.Row = 2;
            app.WindowLengthmsEditFieldLabel.Layout.Column = 6;
            app.WindowLengthmsEditFieldLabel.Text = 'Window Length (ms)';

            % Create WindowLengthmsEditField
            app.WindowLengthmsEditField = uieditfield(app.GridLayout2, 'numeric');
            app.WindowLengthmsEditField.Limits = [1 Inf];
            app.WindowLengthmsEditField.ValueChangedFcn = createCallbackFcn(app, @WindowLengthmsEditFieldValueChanged, true);
            app.WindowLengthmsEditField.Layout.Row = 2;
            app.WindowLengthmsEditField.Layout.Column = 7;
            app.WindowLengthmsEditField.Value = 100;

            % Create channelusedasmaskLabel
            app.channelusedasmaskLabel = uilabel(app.GridLayout2);
            app.channelusedasmaskLabel.WordWrap = 'on';
            app.channelusedasmaskLabel.Enable = 'off';
            app.channelusedasmaskLabel.Layout.Row = 2;
            app.channelusedasmaskLabel.Layout.Column = 8;
            app.channelusedasmaskLabel.Text = 'channel used as mask:';

            % Create maximumifisubosubHzEditFieldLabel
            app.maximumifisubosubHzEditFieldLabel = uilabel(app.GridLayout2);
            app.maximumifisubosubHzEditFieldLabel.HorizontalAlignment = 'right';
            app.maximumifisubosubHzEditFieldLabel.WordWrap = 'on';
            app.maximumifisubosubHzEditFieldLabel.Layout.Row = 3;
            app.maximumifisubosubHzEditFieldLabel.Layout.Column = 1;
            app.maximumifisubosubHzEditFieldLabel.Interpreter = 'html';
            app.maximumifisubosubHzEditFieldLabel.Text = 'maximum <i>f</i><sub>o</sub> (Hz)';

            % Create maximumfoHzEditField
            app.maximumfoHzEditField = uieditfield(app.GridLayout2, 'numeric');
            app.maximumfoHzEditField.Limits = [0 Inf];
            app.maximumfoHzEditField.ValueChangedFcn = createCallbackFcn(app, @maximumfoHzEditFieldValueChanged, true);
            app.maximumfoHzEditField.Layout.Row = 3;
            app.maximumfoHzEditField.Layout.Column = 2;
            app.maximumfoHzEditField.Value = 250;

            % Create minimumcycledurationmsEditFieldLabel
            app.minimumcycledurationmsEditFieldLabel = uilabel(app.GridLayout2);
            app.minimumcycledurationmsEditFieldLabel.HorizontalAlignment = 'right';
            app.minimumcycledurationmsEditFieldLabel.WordWrap = 'on';
            app.minimumcycledurationmsEditFieldLabel.Layout.Row = 3;
            app.minimumcycledurationmsEditFieldLabel.Layout.Column = 3;
            app.minimumcycledurationmsEditFieldLabel.Text = 'minimum cycle duration (ms)';

            % Create minimumcycledurationmsEditField
            app.minimumcycledurationmsEditField = uieditfield(app.GridLayout2, 'numeric');
            app.minimumcycledurationmsEditField.Limits = [0 Inf];
            app.minimumcycledurationmsEditField.ValueChangedFcn = createCallbackFcn(app, @minimumcycledurationmsEditFieldValueChanged, true);
            app.minimumcycledurationmsEditField.Layout.Row = 3;
            app.minimumcycledurationmsEditField.Layout.Column = 4;
            app.minimumcycledurationmsEditField.Value = 4;

            % Create WindowOverlapmsEditFieldLabel
            app.WindowOverlapmsEditFieldLabel = uilabel(app.GridLayout2);
            app.WindowOverlapmsEditFieldLabel.HorizontalAlignment = 'center';
            app.WindowOverlapmsEditFieldLabel.WordWrap = 'on';
            app.WindowOverlapmsEditFieldLabel.Layout.Row = 3;
            app.WindowOverlapmsEditFieldLabel.Layout.Column = 6;
            app.WindowOverlapmsEditFieldLabel.Text = 'Window Overlap (ms)';

            % Create WindowOverlapmsEditField
            app.WindowOverlapmsEditField = uieditfield(app.GridLayout2, 'numeric');
            app.WindowOverlapmsEditField.Limits = [0 Inf];
            app.WindowOverlapmsEditField.ValueChangedFcn = createCallbackFcn(app, @WindowOverlapmsEditFieldValueChanged, true);
            app.WindowOverlapmsEditField.Layout.Row = 3;
            app.WindowOverlapmsEditField.Layout.Column = 7;
            app.WindowOverlapmsEditField.Value = 90;

            % Create ChosenChannelEditField
            app.ChosenChannelEditField = uieditfield(app.GridLayout2, 'numeric');
            app.ChosenChannelEditField.ValueDisplayFormat = '%i';
            app.ChosenChannelEditField.AllowEmpty = 'on';
            app.ChosenChannelEditField.Editable = 'off';
            app.ChosenChannelEditField.Enable = 'off';
            app.ChosenChannelEditField.Layout.Row = 3;
            app.ChosenChannelEditField.Layout.Column = 8;
            app.ChosenChannelEditField.Value = [];

            % Create useUpperFoPredictionStateButton
            app.useUpperFoPredictionStateButton = uibutton(app.GridLayout2, 'state');
            app.useUpperFoPredictionStateButton.ValueChangedFcn = createCallbackFcn(app, @useUpperFoPredictionStateButtonValueChanged, true);
            app.useUpperFoPredictionStateButton.Text = 'Use time dependent maximum <i>f</i><sub>o</sub>  (inactive)';
            app.useUpperFoPredictionStateButton.WordWrap = 'on';
            app.useUpperFoPredictionStateButton.Layout.Row = 4;
            app.useUpperFoPredictionStateButton.Layout.Column = [1 2];
            app.useUpperFoPredictionStateButton.Interpreter = 'html';

            % Create upperFoPredictionAlgorithmDropdown
            app.upperFoPredictionAlgorithmDropdown = uidropdown(app.GridLayout2);
            app.upperFoPredictionAlgorithmDropdown.Items = {'Normalized Correlation Function', 'Pitch Estimation Filter', 'Cepstrum Pitch Determination', 'Log-Harmonic Summation', 'Summation of Residual Harmonics', 'SWIPE''', 'SHR'};
            app.upperFoPredictionAlgorithmDropdown.ItemsData = {'NCF', 'PEF', 'CEP', 'LHS', 'SRH', 'SWIPE''', 'SHR'};
            app.upperFoPredictionAlgorithmDropdown.Enable = 'off';
            app.upperFoPredictionAlgorithmDropdown.Tooltip = {'pitch algorithm used for pitch prediction. Further input parameters can be changed by the minimum and maximum fo in the "General" Tab and Window Size and Overlap in the "fo" Tab'};
            app.upperFoPredictionAlgorithmDropdown.Layout.Row = 4;
            app.upperFoPredictionAlgorithmDropdown.Layout.Column = 3;
            app.upperFoPredictionAlgorithmDropdown.Value = 'NCF';

            % Create upperFoPredictionFactorDropdown
            app.upperFoPredictionFactorDropdown = uidropdown(app.GridLayout2);
            app.upperFoPredictionFactorDropdown.Items = {'Factor 0.8', 'Factor 0.9', 'Factor 1', 'Factor 1.1', 'Factor 1.2', 'Factor 1.3', 'Factor 1.4', 'Factor 1.5', 'Factor 2'};
            app.upperFoPredictionFactorDropdown.ItemsData = [0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 2];
            app.upperFoPredictionFactorDropdown.Enable = 'off';
            app.upperFoPredictionFactorDropdown.Tooltip = {'This factor is applied to the prediceted pitch function output, e.g. the give some upwards margin to the prediction'};
            app.upperFoPredictionFactorDropdown.Layout.Row = 4;
            app.upperFoPredictionFactorDropdown.Layout.Column = 4;
            app.upperFoPredictionFactorDropdown.Value = 1.2;

            % Create ParametersTree
            app.ParametersTree = uitree(app.GridLayout2, 'checkbox');
            app.ParametersTree.SelectionChangedFcn = createCallbackFcn(app, @ParametersTreeSelectionChanged, true);
            app.ParametersTree.Layout.Row = [5 8];
            app.ParametersTree.Layout.Column = [1 4];

            % Create FundamentalFrequencyMeasuresNode
            app.FundamentalFrequencyMeasuresNode = uitreenode(app.ParametersTree);
            app.FundamentalFrequencyMeasuresNode.Text = 'Fundamental Frequency Measures';

            % Create FundamentalFrequencyHzNode
            app.FundamentalFrequencyHzNode = uitreenode(app.FundamentalFrequencyMeasuresNode);
            app.FundamentalFrequencyHzNode.Text = 'Fundamental Frequency (Hz)';

            % Create CycleDurationmsNode
            app.CycleDurationmsNode = uitreenode(app.FundamentalFrequencyMeasuresNode);
            app.CycleDurationmsNode.Text = 'Cycle Duration (ms)';

            % Create MaximumHarmonicHzNode
            app.MaximumHarmonicHzNode = uitreenode(app.FundamentalFrequencyMeasuresNode);
            app.MaximumHarmonicHzNode.Text = 'Maximum Harmonic (Hz)';

            % Create MinimumSubharmonicHzNode
            app.MinimumSubharmonicHzNode = uitreenode(app.FundamentalFrequencyMeasuresNode);
            app.MinimumSubharmonicHzNode.Text = 'Minimum Subharmonic (Hz)';

            % Create AmplitudePerturbationMeasuresNode
            app.AmplitudePerturbationMeasuresNode = uitreenode(app.ParametersTree);
            app.AmplitudePerturbationMeasuresNode.Text = 'Amplitude Perturbation Measures';

            % Create MeanShimmerdBNode
            app.MeanShimmerdBNode = uitreenode(app.AmplitudePerturbationMeasuresNode);
            app.MeanShimmerdBNode.Text = 'Mean Shimmer (dB)';

            % Create ShimmerNode
            app.ShimmerNode = uitreenode(app.AmplitudePerturbationMeasuresNode);
            app.ShimmerNode.Text = 'Shimmer (%)';

            % Create AmplitudePerturbationQuotientAPQNode
            app.AmplitudePerturbationQuotientAPQNode = uitreenode(app.AmplitudePerturbationMeasuresNode);
            app.AmplitudePerturbationQuotientAPQNode.Text = 'Amplitude Perturbation Quotient (APQ)';

            % Create AmplitudePerturbationFactorAPFNode
            app.AmplitudePerturbationFactorAPFNode = uitreenode(app.AmplitudePerturbationMeasuresNode);
            app.AmplitudePerturbationFactorAPFNode.Text = 'Amplitude Perturbation Factor (APF)';

            % Create AmplitudeVariabilityIndexdBAVINode
            app.AmplitudeVariabilityIndexdBAVINode = uitreenode(app.AmplitudePerturbationMeasuresNode);
            app.AmplitudeVariabilityIndexdBAVINode.Text = 'Amplitude Variability Index (dB) (AVI)';

            % Create PeriodPerturbationMeasuresNode
            app.PeriodPerturbationMeasuresNode = uitreenode(app.ParametersTree);
            app.PeriodPerturbationMeasuresNode.Text = 'Period Perturbation Measures';

            % Create MeanJittermsNode
            app.MeanJittermsNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.MeanJittermsNode.Text = 'Mean Jitter (ms)';

            % Create JitterNode
            app.JitterNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.JitterNode.Text = 'Jitter (%)';

            % Create JitterRatioNode
            app.JitterRatioNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.JitterRatioNode.Text = 'Jitter Ratio';

            % Create JitterFactorNode
            app.JitterFactorNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.JitterFactorNode.Text = 'Jitter-Factor';

            % Create PeriodPerturbationQuotientPPQNode
            app.PeriodPerturbationQuotientPPQNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.PeriodPerturbationQuotientPPQNode.Text = 'Period Perturbation Quotient (PPQ)';

            % Create PeriodPerturbationFactorPPFNode
            app.PeriodPerturbationFactorPPFNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.PeriodPerturbationFactorPPFNode.Text = 'Period Perturbation Factor (PPF)';

            % Create RelativeAveragePerturbationV1RAPNode
            app.RelativeAveragePerturbationV1RAPNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.RelativeAveragePerturbationV1RAPNode.Text = 'Relative Average Perturbation V1 (RAP)';

            % Create RelativeAveragePerturbationV2RAPNode
            app.RelativeAveragePerturbationV2RAPNode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.RelativeAveragePerturbationV2RAPNode.Text = 'Relative Average Perturbation V2 (RAP)';

            % Create PeriodVariabilityIndexPVINode
            app.PeriodVariabilityIndexPVINode = uitreenode(app.PeriodPerturbationMeasuresNode);
            app.PeriodVariabilityIndexPVINode.Text = 'Period Variability Index (PVI)';

            % Create EnergyPerturbationMeasuresNode
            app.EnergyPerturbationMeasuresNode = uitreenode(app.ParametersTree);
            app.EnergyPerturbationMeasuresNode.Text = 'Energy Perturbation Measures';

            % Create EnergyPerturbationQuotientEPQNode
            app.EnergyPerturbationQuotientEPQNode = uitreenode(app.EnergyPerturbationMeasuresNode);
            app.EnergyPerturbationQuotientEPQNode.Text = 'Energy Perturbation Quotient (EPQ)';

            % Create EnergyPerturbationFactorEPFNode
            app.EnergyPerturbationFactorEPFNode = uitreenode(app.EnergyPerturbationMeasuresNode);
            app.EnergyPerturbationFactorEPFNode.Text = 'Energy Perturbation Factor (EPF)';

            % Create NoiseMeasuresNode
            app.NoiseMeasuresNode = uitreenode(app.ParametersTree);
            app.NoiseMeasuresNode.Text = 'Noise Measures';

            % Create HarmonicsIntensityNode
            app.HarmonicsIntensityNode = uitreenode(app.NoiseMeasuresNode);
            app.HarmonicsIntensityNode.Text = 'Harmonics Intensity';

            % Create HarmonicstoNoiseRatiodBHNRNode
            app.HarmonicstoNoiseRatiodBHNRNode = uitreenode(app.NoiseMeasuresNode);
            app.HarmonicstoNoiseRatiodBHNRNode.Text = 'Harmonics-to-Noise Ratio (dB) (HNR)';

            % Create NormalizedNoiseEnergydBNNENode
            app.NormalizedNoiseEnergydBNNENode = uitreenode(app.NoiseMeasuresNode);
            app.NormalizedNoiseEnergydBNNENode.Text = 'Normalized Noise Energy (dB)  (NNE)';

            % Create SpectralFlatnessNode
            app.SpectralFlatnessNode = uitreenode(app.NoiseMeasuresNode);
            app.SpectralFlatnessNode.Text = 'Spectral Flatness';

            % Create GlottaltoNoiseExcitationRatioGNEv1Node
            app.GlottaltoNoiseExcitationRatioGNEv1Node = uitreenode(app.NoiseMeasuresNode);
            app.GlottaltoNoiseExcitationRatioGNEv1Node.Text = 'Glottal-to-Noise Excitation Ratio (GNE) v1';

            % Create WaveformMatchingCoefcientWMCNode
            app.WaveformMatchingCoefcientWMCNode = uitreenode(app.NoiseMeasuresNode);
            app.WaveformMatchingCoefcientWMCNode.Text = 'Waveform Matching Coefﬁcient (WMC)';

            % Create MeanWaveformMatchingCoefcientNode
            app.MeanWaveformMatchingCoefcientNode = uitreenode(app.NoiseMeasuresNode);
            app.MeanWaveformMatchingCoefcientNode.Text = 'Mean Waveform Matching Coefﬁcient';

            % Create SignaltoNoiseRatioV1dBSNRNode
            app.SignaltoNoiseRatioV1dBSNRNode = uitreenode(app.NoiseMeasuresNode);
            app.SignaltoNoiseRatioV1dBSNRNode.Text = 'Signal-to-Noise Ratio V1 (dB) (SNR)';

            % Create SignaltoNoiseRatioV2dBSNRNode
            app.SignaltoNoiseRatioV2dBSNRNode = uitreenode(app.NoiseMeasuresNode);
            app.SignaltoNoiseRatioV2dBSNRNode.Text = 'Signal-to-Noise Ratio V2 (dB) (SNR)';

            % Create CepstralPeakProminenceIdBCPPNode
            app.CepstralPeakProminenceIdBCPPNode = uitreenode(app.NoiseMeasuresNode);
            app.CepstralPeakProminenceIdBCPPNode.Text = 'Cepstral Peak Prominence I (dB) (CPP)';

            % Create CepstralPeakProminenceIIdBCPPNode
            app.CepstralPeakProminenceIIdBCPPNode = uitreenode(app.NoiseMeasuresNode);
            app.CepstralPeakProminenceIIdBCPPNode.Text = 'Cepstral Peak Prominence II (dB) (CPP)';

            % Create MechanicalMeasuresNode
            app.MechanicalMeasuresNode = uitreenode(app.ParametersTree);
            app.MechanicalMeasuresNode.Text = 'Mechanical Measures';

            % Create Stiffness1sNode
            app.Stiffness1sNode = uitreenode(app.MechanicalMeasuresNode);
            app.Stiffness1sNode.Text = 'Stiffness (1/s)';

            % Create PeakClosingVelocitypxsNode
            app.PeakClosingVelocitypxsNode = uitreenode(app.MechanicalMeasuresNode);
            app.PeakClosingVelocitypxsNode.Text = 'Peak Closing Velocity (px/s)';

            % Create PeakAccelerationpxs2Node
            app.PeakAccelerationpxs2Node = uitreenode(app.MechanicalMeasuresNode);
            app.PeakAccelerationpxs2Node.Text = 'Peak Acceleration (px/s^2)';

            % Create AmplitudetoLengthRatioNode
            app.AmplitudetoLengthRatioNode = uitreenode(app.MechanicalMeasuresNode);
            app.AmplitudetoLengthRatioNode.Text = 'Amplitude-to-Length Ratio';

            % Create GlottalAreaMeasuresNode
            app.GlottalAreaMeasuresNode = uitreenode(app.ParametersTree);
            app.GlottalAreaMeasuresNode.Text = 'Glottal Area Measures';

            % Create OpenQuotientOQNode
            app.OpenQuotientOQNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.OpenQuotientOQNode.Text = 'Open Quotient  (OQ)';

            % Create ClosingQuotientClQNode
            app.ClosingQuotientClQNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.ClosingQuotientClQNode.Text = 'Closing Quotient (ClQ)';

            % Create SpeedQuotientSQNode
            app.SpeedQuotientSQNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.SpeedQuotientSQNode.Text = 'Speed Quotient (SQ)';

            % Create SpeedIndexSINode
            app.SpeedIndexSINode = uitreenode(app.GlottalAreaMeasuresNode);
            app.SpeedIndexSINode.Text = 'Speed-Index (SI)';

            % Create RateQuotientNode
            app.RateQuotientNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.RateQuotientNode.Text = 'Rate Quotient';

            % Create AsymmetryQuotientNode
            app.AsymmetryQuotientNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.AsymmetryQuotientNode.Text = 'Asymmetry Quotient';

            % Create GlottisGapIndexGGINode
            app.GlottisGapIndexGGINode = uitreenode(app.GlottalAreaMeasuresNode);
            app.GlottisGapIndexGGINode.Text = 'Glottis Gap Index  (GGI)';

            % Create PlateauQuotientNode
            app.PlateauQuotientNode = uitreenode(app.GlottalAreaMeasuresNode);
            app.PlateauQuotientNode.Text = 'Plateau Quotient';

            % Create GlottalAreaIndexGAINode
            app.GlottalAreaIndexGAINode = uitreenode(app.GlottalAreaMeasuresNode);
            app.GlottalAreaIndexGAINode.Text = 'Glottal Area Index (GAI)';

            % Create GlottalAreaPeriodicityMeasuresNode
            app.GlottalAreaPeriodicityMeasuresNode = uitreenode(app.ParametersTree);
            app.GlottalAreaPeriodicityMeasuresNode.Text = 'Glottal Area Periodicity Measures';

            % Create AmplitudePeriodicityNode
            app.AmplitudePeriodicityNode = uitreenode(app.GlottalAreaPeriodicityMeasuresNode);
            app.AmplitudePeriodicityNode.Text = 'Amplitude-Periodicity';

            % Create TimePeriodicityNode
            app.TimePeriodicityNode = uitreenode(app.GlottalAreaPeriodicityMeasuresNode);
            app.TimePeriodicityNode.Text = 'Time-Periodicity';

            % Create GlottalAreaDerivativeMeasuresNode
            app.GlottalAreaDerivativeMeasuresNode = uitreenode(app.ParametersTree);
            app.GlottalAreaDerivativeMeasuresNode.Text = 'Glottal Area Derivative Measures';

            % Create MaximumAreaDeclinationRateMpxsMADRNode
            app.MaximumAreaDeclinationRateMpxsMADRNode = uitreenode(app.GlottalAreaDerivativeMeasuresNode);
            app.MaximumAreaDeclinationRateMpxsMADRNode.Text = 'Maximum Area Declination Rate (Mpx/s) (MADR)';

            % Create AmplitudeQuotientsNode
            app.AmplitudeQuotientsNode = uitreenode(app.GlottalAreaDerivativeMeasuresNode);
            app.AmplitudeQuotientsNode.Text = 'Amplitude Quotient (s)';

            % Create GlottalAreaSymmetryMeasuresNode
            app.GlottalAreaSymmetryMeasuresNode = uitreenode(app.ParametersTree);
            app.GlottalAreaSymmetryMeasuresNode.Text = 'Glottal Area Symmetry Measures';

            % Create PhaseAsymmetryIndexNode
            app.PhaseAsymmetryIndexNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.PhaseAsymmetryIndexNode.Text = 'Phase Asymmetry Index';

            % Create SpatialSymmetryIndexNode
            app.SpatialSymmetryIndexNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.SpatialSymmetryIndexNode.Text = 'Spatial Symmetry Index';

            % Create DynamicRangeSymmetryIndexNode
            app.DynamicRangeSymmetryIndexNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.DynamicRangeSymmetryIndexNode.Text = 'Dynamic Range Symmetry Index';

            % Create AmplitudeSymmetryIndexNode
            app.AmplitudeSymmetryIndexNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.AmplitudeSymmetryIndexNode.Text = 'Amplitude Symmetry Index';

            % Create WaveformSymmetryIndexNode
            app.WaveformSymmetryIndexNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.WaveformSymmetryIndexNode.Text = 'Waveform Symmetry Index';

            % Create PhaseAsymmetryNode
            app.PhaseAsymmetryNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.PhaseAsymmetryNode.Text = 'Phase Asymmetry';

            % Create SpatialSymmetryNode
            app.SpatialSymmetryNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.SpatialSymmetryNode.Text = 'Spatial Symmetry';

            % Create DynamicRangeSymmetryNode
            app.DynamicRangeSymmetryNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.DynamicRangeSymmetryNode.Text = 'Dynamic Range Symmetry';

            % Create AmplitudeSymmetryNode
            app.AmplitudeSymmetryNode = uitreenode(app.GlottalAreaSymmetryMeasuresNode);
            app.AmplitudeSymmetryNode.Text = 'Amplitude Symmetry';

            % Create BasicmeasurementsNode
            app.BasicmeasurementsNode = uitreenode(app.ParametersTree);
            app.BasicmeasurementsNode.Text = 'Basic measurements';

            % Create SumNode
            app.SumNode = uitreenode(app.BasicmeasurementsNode);
            app.SumNode.Text = 'Sum';

            % Create MeanarithmeticharmonicgeometricNode
            app.MeanarithmeticharmonicgeometricNode = uitreenode(app.BasicmeasurementsNode);
            app.MeanarithmeticharmonicgeometricNode.Text = 'Mean (arithmetic, harmonic, geometric)';

            % Create standarddeviationSTDNode
            app.standarddeviationSTDNode = uitreenode(app.BasicmeasurementsNode);
            app.standarddeviationSTDNode.Text = 'standard deviation STD';

            % Create MedianNode
            app.MedianNode = uitreenode(app.BasicmeasurementsNode);
            app.MedianNode.Text = 'Median';

            % Create InterquartilerangeIQRNode
            app.InterquartilerangeIQRNode = uitreenode(app.BasicmeasurementsNode);
            app.InterquartilerangeIQRNode.Text = 'Inter-quartile-range IQR';

            % Create MinimumMaximumNode
            app.MinimumMaximumNode = uitreenode(app.BasicmeasurementsNode);
            app.MinimumMaximumNode.Text = 'Minimum / Maximum';

            % Create roommeansquareRMSNode
            app.roommeansquareRMSNode = uitreenode(app.BasicmeasurementsNode);
            app.roommeansquareRMSNode.Text = 'room-mean-square RMS';

            % Create ModeNode
            app.ModeNode = uitreenode(app.BasicmeasurementsNode);
            app.ModeNode.Text = 'Mode';

            % Create Quantilesfrom5in5stepsto95Node
            app.Quantilesfrom5in5stepsto95Node = uitreenode(app.BasicmeasurementsNode);
            app.Quantilesfrom5in5stepsto95Node.Text = 'Quantiles from 5% in 5% steps to 95%';

            % Create SkewnessNode
            app.SkewnessNode = uitreenode(app.BasicmeasurementsNode);
            app.SkewnessNode.Text = 'Skewness';

            % Create KurtosisNode
            app.KurtosisNode = uitreenode(app.BasicmeasurementsNode);
            app.KurtosisNode.Text = 'Kurtosis';

            % Create SumofsquarevaluesNode
            app.SumofsquarevaluesNode = uitreenode(app.BasicmeasurementsNode);
            app.SumofsquarevaluesNode.Text = 'Sum of square values';

            % Create AdditionalspectraldescriptorsNode
            app.AdditionalspectraldescriptorsNode = uitreenode(app.ParametersTree);
            app.AdditionalspectraldescriptorsNode.Text = 'Additional spectral descriptors';

            % Create spectralCrestNode
            app.spectralCrestNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralCrestNode.Text = 'spectral Crest';

            % Create spectralFluxNode
            app.spectralFluxNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralFluxNode.Text = 'spectral Flux';

            % Create spectralSpreadNode
            app.spectralSpreadNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralSpreadNode.Text = 'spectral Spread';

            % Create spectralSkewnessspectralTiltNode
            app.spectralSkewnessspectralTiltNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralSkewnessspectralTiltNode.Text = 'spectral Skewness (spectral Tilt)';

            % Create spectralKurtosisNode
            app.spectralKurtosisNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralKurtosisNode.Text = 'spectral Kurtosis';

            % Create spectralCentroidNode
            app.spectralCentroidNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralCentroidNode.Text = 'spectral Centroid';

            % Create spectralEntropyNode
            app.spectralEntropyNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralEntropyNode.Text = 'spectral Entropy';

            % Create spectralSlopeNode
            app.spectralSlopeNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralSlopeNode.Text = 'spectral Slope';

            % Create spectralDecreaseNode
            app.spectralDecreaseNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralDecreaseNode.Text = 'spectral Decrease';

            % Create spectralRolloffPointNode
            app.spectralRolloffPointNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.spectralRolloffPointNode.Text = 'spectral Rolloff Point';

            % Create harmonicRatioNode
            app.harmonicRatioNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.harmonicRatioNode.Text = 'harmonic Ratio';

            % Create HarmonictoNoiseRatioHNRviabiasedxcorrNode
            app.HarmonictoNoiseRatioHNRviabiasedxcorrNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.HarmonictoNoiseRatioHNRviabiasedxcorrNode.Text = 'Harmonic-to-Noise Ratio (HNR) via biased xcorr';

            % Create SignaltoNoiseRatiodBcarrierSNRNode
            app.SignaltoNoiseRatiodBcarrierSNRNode = uitreenode(app.AdditionalspectraldescriptorsNode);
            app.SignaltoNoiseRatiodBcarrierSNRNode.Text = 'Signal-to-Noise Ratio (dBcarrier) (SNR)';

            % Create PsychoacousticMeasuresNode
            app.PsychoacousticMeasuresNode = uitreenode(app.ParametersTree);
            app.PsychoacousticMeasuresNode.Text = 'Psychoacoustic Measures';

            % Create AcousticLoudnessNode
            app.AcousticLoudnessNode = uitreenode(app.PsychoacousticMeasuresNode);
            app.AcousticLoudnessNode.Text = 'Acoustic Loudness (Zwicker, ISO 532-1)';

            % Create AcousticFluctuationNode
            app.AcousticFluctuationNode = uitreenode(app.PsychoacousticMeasuresNode);
            app.AcousticFluctuationNode.Text = 'Acoustic Fluctuation';

            % Create AcousticSharpnessNode
            app.AcousticSharpnessNode = uitreenode(app.PsychoacousticMeasuresNode);
            app.AcousticSharpnessNode.Text = 'Acoustic Sharpness';

            % Create AcousticRoughnessNode
            app.AcousticRoughnessNode = uitreenode(app.PsychoacousticMeasuresNode);
            app.AcousticRoughnessNode.Text = 'Acoustic Roughness';

            % Create OthersNode
            app.OthersNode = uitreenode(app.ParametersTree);
            app.OthersNode.Text = 'Others';

            % Create zerocrossrateNode
            app.zerocrossrateNode = uitreenode(app.OthersNode);
            app.zerocrossrateNode.Text = 'zero cross rate';

            % Create sampleentropytimedomainNode
            app.sampleentropytimedomainNode = uitreenode(app.OthersNode);
            app.sampleentropytimedomainNode.Text = 'sample entropy (time domain)';

            % Create cyclebasedspectralsampleentropyNode
            app.cyclebasedspectralsampleentropyNode = uitreenode(app.OthersNode);
            app.cyclebasedspectralsampleentropyNode.Text = 'cycle based spectral sample entropy';

            % Create SoundPressureLevelSPLdBAdBCdBZNode
            app.SoundPressureLevelSPLdBAdBCdBZNode = uitreenode(app.OthersNode);
            app.SoundPressureLevelSPLdBAdBCdBZNode.Text = 'Sound Pressure Level (SPL , dB(A), dB(C), dB(Z))';

            % Create RelativeaverageperturbationRAPforcycleenergyNode
            app.RelativeaverageperturbationRAPforcycleenergyNode = uitreenode(app.OthersNode);
            app.RelativeaverageperturbationRAPforcycleenergyNode.Text = 'Relative average perturbation (RAP) for cycle energy';

            % Create RelativeaverageperturbationRAPforcyclerangeNode
            app.RelativeaverageperturbationRAPforcyclerangeNode = uitreenode(app.OthersNode);
            app.RelativeaverageperturbationRAPforcyclerangeNode.Text = 'Relative average perturbation (RAP) for cycle range';

            % Create EnergyVariabilityIndexPVINode
            app.EnergyVariabilityIndexPVINode = uitreenode(app.OthersNode);
            app.EnergyVariabilityIndexPVINode.Text = 'Energy Variability Index (PVI)';

            % Create GlottaltoNoiseExcitationRatioGNEv2Node
            app.GlottaltoNoiseExcitationRatioGNEv2Node = uitreenode(app.OthersNode);
            app.GlottaltoNoiseExcitationRatioGNEv2Node.Text = 'Glottal-to-Noise Excitation Ratio (GNE) v2';

            % Create CepstralPeakProminenceSmoothedv3dBCPPsNode
            app.CepstralPeakProminenceSmoothedv3dBCPPsNode = uitreenode(app.OthersNode);
            app.CepstralPeakProminenceSmoothedv3dBCPPsNode.Text = 'Cepstral Peak Prominence (Smoothed) v3 (dB) (CPP(s))';

            % Assign Checked Nodes
            app.ParametersTree.CheckedNodes = [app.FundamentalFrequencyHzNode, app.CycleDurationmsNode, app.MaximumHarmonicHzNode, app.MinimumSubharmonicHzNode, app.MeanShimmerdBNode, app.ShimmerNode, app.AmplitudePerturbationQuotientAPQNode, app.AmplitudePerturbationFactorAPFNode, app.AmplitudeVariabilityIndexdBAVINode, app.MeanJittermsNode, app.JitterNode, app.JitterRatioNode, app.JitterFactorNode, app.PeriodPerturbationQuotientPPQNode, app.PeriodPerturbationFactorPPFNode, app.RelativeAveragePerturbationV1RAPNode, app.RelativeAveragePerturbationV2RAPNode, app.PeriodVariabilityIndexPVINode, app.EnergyPerturbationQuotientEPQNode, app.EnergyPerturbationFactorEPFNode, app.Stiffness1sNode, app.PeakClosingVelocitypxsNode, app.PeakAccelerationpxs2Node, app.AmplitudetoLengthRatioNode, app.OpenQuotientOQNode, app.ClosingQuotientClQNode, app.SpeedQuotientSQNode, app.SpeedIndexSINode, app.RateQuotientNode, app.AsymmetryQuotientNode, app.GlottisGapIndexGGINode, app.PlateauQuotientNode, app.GlottalAreaIndexGAINode, app.AmplitudePeriodicityNode, app.TimePeriodicityNode, app.MaximumAreaDeclinationRateMpxsMADRNode, app.AmplitudeQuotientsNode, app.PhaseAsymmetryIndexNode, app.SpatialSymmetryIndexNode, app.DynamicRangeSymmetryIndexNode, app.AmplitudeSymmetryIndexNode, app.WaveformSymmetryIndexNode, app.PhaseAsymmetryNode, app.SpatialSymmetryNode, app.DynamicRangeSymmetryNode, app.AmplitudeSymmetryNode, app.SumNode, app.MeanarithmeticharmonicgeometricNode, app.standarddeviationSTDNode, app.MedianNode, app.InterquartilerangeIQRNode, app.MinimumMaximumNode, app.roommeansquareRMSNode, app.ModeNode, app.Quantilesfrom5in5stepsto95Node, app.SkewnessNode, app.KurtosisNode, app.SumofsquarevaluesNode, app.spectralCrestNode, app.spectralFluxNode, app.spectralSpreadNode, app.spectralSkewnessspectralTiltNode, app.spectralKurtosisNode, app.spectralCentroidNode, app.spectralEntropyNode, app.spectralSlopeNode, app.spectralDecreaseNode, app.spectralRolloffPointNode, app.harmonicRatioNode, app.HarmonictoNoiseRatioHNRviabiasedxcorrNode, app.SignaltoNoiseRatiodBcarrierSNRNode, app.AcousticLoudnessNode, app.AcousticFluctuationNode, app.AcousticSharpnessNode, app.AcousticRoughnessNode, app.HarmonicsIntensityNode, app.HarmonicstoNoiseRatiodBHNRNode, app.NormalizedNoiseEnergydBNNENode, app.SpectralFlatnessNode, app.WaveformMatchingCoefcientWMCNode, app.MeanWaveformMatchingCoefcientNode, app.SignaltoNoiseRatioV1dBSNRNode, app.SignaltoNoiseRatioV2dBSNRNode, app.CepstralPeakProminenceIdBCPPNode, app.CepstralPeakProminenceIIdBCPPNode, app.zerocrossrateNode, app.SoundPressureLevelSPLdBAdBCdBZNode, app.RelativeaverageperturbationRAPforcycleenergyNode, app.RelativeaverageperturbationRAPforcyclerangeNode, app.EnergyVariabilityIndexPVINode, app.CepstralPeakProminenceSmoothedv3dBCPPsNode, app.FundamentalFrequencyMeasuresNode, app.AmplitudePerturbationMeasuresNode, app.PeriodPerturbationMeasuresNode, app.EnergyPerturbationMeasuresNode, app.MechanicalMeasuresNode, app.GlottalAreaMeasuresNode, app.GlottalAreaPeriodicityMeasuresNode, app.GlottalAreaDerivativeMeasuresNode, app.GlottalAreaSymmetryMeasuresNode, app.BasicmeasurementsNode, app.AdditionalspectraldescriptorsNode, app.PsychoacousticMeasuresNode];
            % Assign Checked Nodes
            app.ParametersTree.CheckedNodesChangedFcn = createCallbackFcn(app, @ParametersTreeCheckedNodesChanged, true);

            % Create parameterExplanation
            app.parameterExplanation = uilabel(app.GridLayout2);
            app.parameterExplanation.BackgroundColor = [1 1 1];
            app.parameterExplanation.VerticalAlignment = 'top';
            app.parameterExplanation.WordWrap = 'on';
            app.parameterExplanation.Layout.Row = [5 8];
            app.parameterExplanation.Layout.Column = [5 8];
            app.parameterExplanation.Text = '';

            % Create FilterParameterToCalculateEditField
            app.FilterParameterToCalculateEditField = uieditfield(app.GridLayout2, 'text');
            app.FilterParameterToCalculateEditField.Placeholder = 'Type to filter nodes...';
            app.FilterParameterToCalculateEditField.Layout.Row = 9;
            app.FilterParameterToCalculateEditField.Layout.Column = [1 4];

            % Create ExpandallnodesButton
            app.ExpandallnodesButton = uibutton(app.GridLayout2, 'push');
            app.ExpandallnodesButton.ButtonPushedFcn = createCallbackFcn(app, @ExpandallnodesButtonPushed, true);
            app.ExpandallnodesButton.WordWrap = 'on';
            app.ExpandallnodesButton.Layout.Row = 10;
            app.ExpandallnodesButton.Layout.Column = 1;
            app.ExpandallnodesButton.Text = 'Expand all nodes';

            % Create CollapseallnodesButton
            app.CollapseallnodesButton = uibutton(app.GridLayout2, 'push');
            app.CollapseallnodesButton.ButtonPushedFcn = createCallbackFcn(app, @CollapseallnodesButtonPushed, true);
            app.CollapseallnodesButton.WordWrap = 'on';
            app.CollapseallnodesButton.Layout.Row = 10;
            app.CollapseallnodesButton.Layout.Column = 2;
            app.CollapseallnodesButton.Text = 'Collapse all nodes';

            % Create CheckallButton
            app.CheckallButton = uibutton(app.GridLayout2, 'push');
            app.CheckallButton.ButtonPushedFcn = createCallbackFcn(app, @CheckallButtonPushed, true);
            app.CheckallButton.WordWrap = 'on';
            app.CheckallButton.Layout.Row = 10;
            app.CheckallButton.Layout.Column = 3;
            app.CheckallButton.Text = 'Check all';

            % Create UncheckallButton
            app.UncheckallButton = uibutton(app.GridLayout2, 'push');
            app.UncheckallButton.ButtonPushedFcn = createCallbackFcn(app, @UncheckallButtonPushed, true);
            app.UncheckallButton.WordWrap = 'on';
            app.UncheckallButton.Layout.Row = 10;
            app.UncheckallButton.Layout.Column = 4;
            app.UncheckallButton.Text = 'Uncheck all';

            % Create CyclesTab
            app.CyclesTab = uitab(app.TabGroup);
            app.CyclesTab.Title = 'Cycles';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.CyclesTab);
            app.GridLayout3.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create showseparateplotof1cycledurationCheckBox
            app.showseparateplotof1cycledurationCheckBox = uicheckbox(app.GridLayout3);
            app.showseparateplotof1cycledurationCheckBox.ValueChangedFcn = createCallbackFcn(app, @showseparateplotof1cycledurationCheckBoxValueChanged, true);
            app.showseparateplotof1cycledurationCheckBox.Text = {'show separate plot of'; '1/(cycle duration)'};
            app.showseparateplotof1cycledurationCheckBox.WordWrap = 'on';
            app.showseparateplotof1cycledurationCheckBox.Layout.Row = 1;
            app.showseparateplotof1cycledurationCheckBox.Layout.Column = 3;
            app.showseparateplotof1cycledurationCheckBox.Value = true;

            % Create PlateauQuotientThresholdEditFieldLabel
            app.PlateauQuotientThresholdEditFieldLabel = uilabel(app.GridLayout3);
            app.PlateauQuotientThresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.PlateauQuotientThresholdEditFieldLabel.Tooltip = {'For calculation of the plateau quotient:In which amount of time the data is above this threshold, e.g. at 95% how many data points are in the upper 5% of the cycles data.'};
            app.PlateauQuotientThresholdEditFieldLabel.Layout.Row = 2;
            app.PlateauQuotientThresholdEditFieldLabel.Layout.Column = 1;
            app.PlateauQuotientThresholdEditFieldLabel.Text = 'Plateau Quotient Threshold';

            % Create PlateauQuotientThresholdEditField
            app.PlateauQuotientThresholdEditField = uieditfield(app.GridLayout3, 'numeric');
            app.PlateauQuotientThresholdEditField.Limits = [1 99];
            app.PlateauQuotientThresholdEditField.RoundFractionalValues = 'on';
            app.PlateauQuotientThresholdEditField.ValueDisplayFormat = '%i';
            app.PlateauQuotientThresholdEditField.Tooltip = {'For calculation of the plateau quotient:In which amount of time the data is above this threshold, e.g. at 95% how many data points are in the upper 5% of the cycles data.'};
            app.PlateauQuotientThresholdEditField.Layout.Row = 2;
            app.PlateauQuotientThresholdEditField.Layout.Column = 2;
            app.PlateauQuotientThresholdEditField.Value = 95;

            % Create GAWopenthresholdinoflocalmaximumEditFieldLabel
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel = uilabel(app.GridLayout3);
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.HorizontalAlignment = 'right';
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.WordWrap = 'on';
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.Tooltip = {'When to consider the glottis open when computing from GAW channel. Normally, this is 0. Value in percentage of local max.'};
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.Layout.Row = 3;
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.Layout.Column = 1;
            app.GAWopenthresholdinoflocalmaximumEditFieldLabel.Text = 'GAW open threshold in % of local maximum';

            % Create GAWopenthresholdinoflocalmaximumEditField
            app.GAWopenthresholdinoflocalmaximumEditField = uieditfield(app.GridLayout3, 'numeric');
            app.GAWopenthresholdinoflocalmaximumEditField.Limits = [0 99];
            app.GAWopenthresholdinoflocalmaximumEditField.RoundFractionalValues = 'on';
            app.GAWopenthresholdinoflocalmaximumEditField.ValueDisplayFormat = '%i';
            app.GAWopenthresholdinoflocalmaximumEditField.Tooltip = {'When to consider the glottis open when computing from GAW channel. Normally, this is 0. Value in percentage of local max.'};
            app.GAWopenthresholdinoflocalmaximumEditField.Layout.Row = 3;
            app.GAWopenthresholdinoflocalmaximumEditField.Layout.Column = 2;

            % Create CyclePeakProminenceTypeSwitch
            app.CyclePeakProminenceTypeSwitch = uiswitch(app.GridLayout3, 'slider');
            app.CyclePeakProminenceTypeSwitch.Items = {' ', ' '};
            app.CyclePeakProminenceTypeSwitch.ItemsData = [1 0];
            app.CyclePeakProminenceTypeSwitch.ValueChangedFcn = createCallbackFcn(app, @CyclePeakProminenceTypeSwitchValueChanged, true);
            app.CyclePeakProminenceTypeSwitch.Layout.Row = 5;
            app.CyclePeakProminenceTypeSwitch.Layout.Column = [2 3];
            app.CyclePeakProminenceTypeSwitch.Value = 1;

            % Create absoluitepeakprominenceEditField
            app.absoluitepeakprominenceEditField = uieditfield(app.GridLayout3, 'numeric');
            app.absoluitepeakprominenceEditField.Limits = [0 Inf];
            app.absoluitepeakprominenceEditField.Layout.Row = 6;
            app.absoluitepeakprominenceEditField.Layout.Column = 1;

            % Create absoluitepeakprominenceEditFieldLabel
            app.absoluitepeakprominenceEditFieldLabel = uilabel(app.GridLayout3);
            app.absoluitepeakprominenceEditFieldLabel.HorizontalAlignment = 'right';
            app.absoluitepeakprominenceEditFieldLabel.Layout.Row = 6;
            app.absoluitepeakprominenceEditFieldLabel.Layout.Column = 2;
            app.absoluitepeakprominenceEditFieldLabel.Text = 'absoluite peak prominence';

            % Create relativepeakprominenceinreferencetowindowmaximumEditFieldLabel
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel = uilabel(app.GridLayout3);
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.HorizontalAlignment = 'right';
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Enable = 'off';
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Layout.Row = 6;
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Layout.Column = 3;
            app.relativepeakprominenceinreferencetowindowmaximumEditFieldLabel.Text = {'relative peak prominence'; 'in reference to window maximum'};

            % Create relativepeakprominenceinreferencetowindowmaximumEditField
            app.relativepeakprominenceinreferencetowindowmaximumEditField = uieditfield(app.GridLayout3, 'numeric');
            app.relativepeakprominenceinreferencetowindowmaximumEditField.Limits = [0 1];
            app.relativepeakprominenceinreferencetowindowmaximumEditField.Enable = 'off';
            app.relativepeakprominenceinreferencetowindowmaximumEditField.Layout.Row = 6;
            app.relativepeakprominenceinreferencetowindowmaximumEditField.Layout.Column = 4;

            % Create foTab
            app.foTab = uitab(app.TabGroup);
            app.foTab.Title = 'fo+fft';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.foTab);
            app.GridLayout4.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout4.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create showseparateplotof1cycledurationCheckBox_2
            app.showseparateplotof1cycledurationCheckBox_2 = uicheckbox(app.GridLayout4);
            app.showseparateplotof1cycledurationCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @showseparateplotof1cycledurationCheckBox_2ValueChanged, true);
            app.showseparateplotof1cycledurationCheckBox_2.Text = {'show separate plot of'; '1/(cycle duration)'};
            app.showseparateplotof1cycledurationCheckBox_2.WordWrap = 'on';
            app.showseparateplotof1cycledurationCheckBox_2.Layout.Row = 1;
            app.showseparateplotof1cycledurationCheckBox_2.Layout.Column = 3;
            app.showseparateplotof1cycledurationCheckBox_2.Value = true;

            % Create ifisubosubsettingsLabel
            app.ifisubosubsettingsLabel = uilabel(app.GridLayout4);
            app.ifisubosubsettingsLabel.FontWeight = 'bold';
            app.ifisubosubsettingsLabel.Layout.Row = 2;
            app.ifisubosubsettingsLabel.Layout.Column = 1;
            app.ifisubosubsettingsLabel.Interpreter = 'html';
            app.ifisubosubsettingsLabel.Text = '<i>f</i><sub>o</sub> settings';

            % Create PitchanalysistimewindowLabel
            app.PitchanalysistimewindowLabel = uilabel(app.GridLayout4);
            app.PitchanalysistimewindowLabel.HorizontalAlignment = 'right';
            app.PitchanalysistimewindowLabel.Layout.Row = 3;
            app.PitchanalysistimewindowLabel.Layout.Column = 1;
            app.PitchanalysistimewindowLabel.Text = 'Pitch analysis time window';

            % Create PitchanalysistimewindowSlider
            app.PitchanalysistimewindowSlider = uislider(app.GridLayout4);
            app.PitchanalysistimewindowSlider.Limits = [2 100];
            app.PitchanalysistimewindowSlider.ValueChangingFcn = createCallbackFcn(app, @PitchanalysistimewindowSliderValueChanging, true);
            app.PitchanalysistimewindowSlider.Step = 1;
            app.PitchanalysistimewindowSlider.Layout.Row = 3;
            app.PitchanalysistimewindowSlider.Layout.Column = 2;
            app.PitchanalysistimewindowSlider.Value = 52;

            % Create pitchAnalysisTimeLengthEditField
            app.pitchAnalysisTimeLengthEditField = uieditfield(app.GridLayout4, 'numeric');
            app.pitchAnalysisTimeLengthEditField.ValueDisplayFormat = '%i ms';
            app.pitchAnalysisTimeLengthEditField.Editable = 'off';
            app.pitchAnalysisTimeLengthEditField.Layout.Row = 3;
            app.pitchAnalysisTimeLengthEditField.Layout.Column = 3;
            app.pitchAnalysisTimeLengthEditField.Value = 52;

            % Create PitchanalysistimewindowoverlapSliderLabel
            app.PitchanalysistimewindowoverlapSliderLabel = uilabel(app.GridLayout4);
            app.PitchanalysistimewindowoverlapSliderLabel.HorizontalAlignment = 'right';
            app.PitchanalysistimewindowoverlapSliderLabel.Layout.Row = 4;
            app.PitchanalysistimewindowoverlapSliderLabel.Layout.Column = 1;
            app.PitchanalysistimewindowoverlapSliderLabel.Text = 'Pitch analysis time window overlap';

            % Create PitchanalysistimewindowoverlapSlider
            app.PitchanalysistimewindowoverlapSlider = uislider(app.GridLayout4);
            app.PitchanalysistimewindowoverlapSlider.Limits = [0 51];
            app.PitchanalysistimewindowoverlapSlider.ValueChangingFcn = createCallbackFcn(app, @PitchanalysistimewindowoverlapSliderValueChanging, true);
            app.PitchanalysistimewindowoverlapSlider.Step = 1;
            app.PitchanalysistimewindowoverlapSlider.Layout.Row = 4;
            app.PitchanalysistimewindowoverlapSlider.Layout.Column = 2;
            app.PitchanalysistimewindowoverlapSlider.Value = 42;

            % Create PitchAnalysisWindowOverlapEditField
            app.PitchAnalysisWindowOverlapEditField = uieditfield(app.GridLayout4, 'numeric');
            app.PitchAnalysisWindowOverlapEditField.RoundFractionalValues = 'on';
            app.PitchAnalysisWindowOverlapEditField.ValueDisplayFormat = '%i ms';
            app.PitchAnalysisWindowOverlapEditField.Editable = 'off';
            app.PitchAnalysisWindowOverlapEditField.Layout.Row = 4;
            app.PitchAnalysisWindowOverlapEditField.Layout.Column = 3;
            app.PitchAnalysisWindowOverlapEditField.Value = 42;

            % Create FFTandsubharmonicssettingsLabel
            app.FFTandsubharmonicssettingsLabel = uilabel(app.GridLayout4);
            app.FFTandsubharmonicssettingsLabel.WordWrap = 'on';
            app.FFTandsubharmonicssettingsLabel.FontWeight = 'bold';
            app.FFTandsubharmonicssettingsLabel.Layout.Row = 5;
            app.FFTandsubharmonicssettingsLabel.Layout.Column = 1;
            app.FFTandsubharmonicssettingsLabel.Interpreter = 'html';
            app.FFTandsubharmonicssettingsLabel.Text = 'FFT and (sub)harmonics settings';

            % Create WindowTypeDropDownLabel_2
            app.WindowTypeDropDownLabel_2 = uilabel(app.GridLayout4);
            app.WindowTypeDropDownLabel_2.HorizontalAlignment = 'right';
            app.WindowTypeDropDownLabel_2.WordWrap = 'on';
            app.WindowTypeDropDownLabel_2.Tooltip = {'Why Use Windows?'; 'In both digital filter design and spectral estimation, the choice of a windowing function can play an important role in determining the quality of overall results. The main role of the window is to damp out the effects of the Gibbs phenomenon that results from truncation of an infinite series.'};
            app.WindowTypeDropDownLabel_2.Layout.Row = 6;
            app.WindowTypeDropDownLabel_2.Layout.Column = 1;
            app.WindowTypeDropDownLabel_2.Text = 'Window Type';

            % Create generalFFTwindow
            app.generalFFTwindow = uidropdown(app.GridLayout4);
            app.generalFFTwindow.Items = {'none (rectangular)', 'Hann', 'Hamming', 'Bartlett-Hann', 'Bartlett', 'Blackman', 'Blackman-Harris', 'Bohman', 'Chebyshev', 'Flat Top', 'Gaussian', 'Nuttall''s Blackman-Harris', 'Parzen', 'Triangular'};
            app.generalFFTwindow.ItemsData = {'rectwin', 'hann', 'hamming', 'barthannwin', 'bartlett', 'blackman', 'blackmanharris', 'bohmanwin', 'chebwin', 'flattopwin', 'gausswin', 'nuttallwin', 'parzenwin', 'triang'};
            app.generalFFTwindow.Tooltip = {'Why Use Windows?'; 'In both digital filter design and spectral estimation, the choice of a windowing function can play an important role in determining the quality of overall results. The main role of the window is to damp out the effects of the Gibbs phenomenon that results from truncation of an infinite series.'};
            app.generalFFTwindow.Layout.Row = 6;
            app.generalFFTwindow.Layout.Column = 2;
            app.generalFFTwindow.Value = 'hann';

            % Create RequestedminimumFFTfrequencyresolutionEditFieldLabel
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel = uilabel(app.GridLayout4);
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel.HorizontalAlignment = 'right';
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel.WordWrap = 'on';
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel.Layout.Row = 6;
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel.Layout.Column = 3;
            app.RequestedminimumFFTfrequencyresolutionEditFieldLabel.Text = 'Requested minimum FFT frequency resolution';

            % Create RequestedminimumFFTfrequencyresolutionEditField
            app.RequestedminimumFFTfrequencyresolutionEditField = uieditfield(app.GridLayout4, 'numeric');
            app.RequestedminimumFFTfrequencyresolutionEditField.LowerLimitInclusive = 'off';
            app.RequestedminimumFFTfrequencyresolutionEditField.Limits = [0 100];
            app.RequestedminimumFFTfrequencyresolutionEditField.ValueDisplayFormat = '%11.4g Hz';
            app.RequestedminimumFFTfrequencyresolutionEditField.Layout.Row = 6;
            app.RequestedminimumFFTfrequencyresolutionEditField.Layout.Column = 4;
            app.RequestedminimumFFTfrequencyresolutionEditField.Value = 3;

            % Create SpectruminterpolationmethodDropDownLabel
            app.SpectruminterpolationmethodDropDownLabel = uilabel(app.GridLayout4);
            app.SpectruminterpolationmethodDropDownLabel.HorizontalAlignment = 'right';
            app.SpectruminterpolationmethodDropDownLabel.WordWrap = 'on';
            app.SpectruminterpolationmethodDropDownLabel.Layout.Row = 7;
            app.SpectruminterpolationmethodDropDownLabel.Layout.Column = 1;
            app.SpectruminterpolationmethodDropDownLabel.Text = 'Spectrum interpolation method';

            % Create SpectruminterpolationmethodDropDown
            app.SpectruminterpolationmethodDropDown = uidropdown(app.GridLayout4);
            app.SpectruminterpolationmethodDropDown.Items = {'Modified Akima cubic Hermite', 'linear', 'nearest'};
            app.SpectruminterpolationmethodDropDown.ItemsData = {'makima', 'linear', 'nearest'};
            app.SpectruminterpolationmethodDropDown.Tooltip = {'the frequency vector has specific evaluation points, e.g. [1, 2, 3, 4] Hz. When requesting the spectrum value at e.g. 2.7, interpolation is done on the nearest bin and its two neighbors. Interpolation is done in log space of the absolute spectrum.'};
            app.SpectruminterpolationmethodDropDown.Layout.Row = 7;
            app.SpectruminterpolationmethodDropDown.Layout.Column = 2;
            app.SpectruminterpolationmethodDropDown.Value = 'makima';

            % Create MaximumnumberofharmonicstolookforEditFieldLabel
            app.MaximumnumberofharmonicstolookforEditFieldLabel = uilabel(app.GridLayout4);
            app.MaximumnumberofharmonicstolookforEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumnumberofharmonicstolookforEditFieldLabel.WordWrap = 'on';
            app.MaximumnumberofharmonicstolookforEditFieldLabel.Tooltip = {'0 means f_o frequency only, 1 means f_o and first harmonic and so on...'};
            app.MaximumnumberofharmonicstolookforEditFieldLabel.Layout.Row = 8;
            app.MaximumnumberofharmonicstolookforEditFieldLabel.Layout.Column = 1;
            app.MaximumnumberofharmonicstolookforEditFieldLabel.Text = 'Maximum number of harmonics to look for';

            % Create MaximumnumberofharmonicstolookforEditField
            app.MaximumnumberofharmonicstolookforEditField = uieditfield(app.GridLayout4, 'numeric');
            app.MaximumnumberofharmonicstolookforEditField.Limits = [1 50];
            app.MaximumnumberofharmonicstolookforEditField.RoundFractionalValues = 'on';
            app.MaximumnumberofharmonicstolookforEditField.ValueDisplayFormat = '%i';
            app.MaximumnumberofharmonicstolookforEditField.Tooltip = {'1 means f_o frequency only, 2 means f_o and second harmonic (2*fo) and so on...'; 'Harmonics'' fourier coefficients have to have a minimum value defined by the percentage set below'};
            app.MaximumnumberofharmonicstolookforEditField.Layout.Row = 8;
            app.MaximumnumberofharmonicstolookforEditField.Layout.Column = 2;
            app.MaximumnumberofharmonicstolookforEditField.Value = 5;

            % Create MaximumnumberofsubharmonicstolookforEditFieldLabel
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel = uilabel(app.GridLayout4);
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.WordWrap = 'on';
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.Tooltip = {'0 means f_o frequency only, 1 means f_o and first harmonic and so on...'};
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.Layout.Row = 8;
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.Layout.Column = 3;
            app.MaximumnumberofsubharmonicstolookforEditFieldLabel.Text = 'Maximum number of subharmonics to look for';

            % Create MaximumnumberofsubharmonicstolookforEditField
            app.MaximumnumberofsubharmonicstolookforEditField = uieditfield(app.GridLayout4, 'numeric');
            app.MaximumnumberofsubharmonicstolookforEditField.Limits = [1 50];
            app.MaximumnumberofsubharmonicstolookforEditField.RoundFractionalValues = 'on';
            app.MaximumnumberofsubharmonicstolookforEditField.ValueDisplayFormat = '%i';
            app.MaximumnumberofsubharmonicstolookforEditField.Tooltip = {'1 means f_o frequency only, 2 means f_o and second subharmonic fo/2 and so on...'; 'Subharmonics'' fourier coefficients have to have a minimum value defined by the percentage set below'};
            app.MaximumnumberofsubharmonicstolookforEditField.Layout.Row = 8;
            app.MaximumnumberofsubharmonicstolookforEditField.Layout.Column = 4;
            app.MaximumnumberofsubharmonicstolookforEditField.Value = 2;

            % Create MinimumsubharmonicfouriercoefficientvalueEditFieldLabel
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel = uilabel(app.GridLayout4);
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel.WordWrap = 'on';
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel.Layout.Row = 9;
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel.Layout.Column = 1;
            app.MinimumsubharmonicfouriercoefficientvalueEditFieldLabel.Text = 'Minimum (sub)harmonic fourier coefficient value';

            % Create MinimumsubharmonicfouriercoefficientvalueEditField
            app.MinimumsubharmonicfouriercoefficientvalueEditField = uieditfield(app.GridLayout4, 'numeric');
            app.MinimumsubharmonicfouriercoefficientvalueEditField.Limits = [0 100];
            app.MinimumsubharmonicfouriercoefficientvalueEditField.RoundFractionalValues = 'on';
            app.MinimumsubharmonicfouriercoefficientvalueEditField.ValueDisplayFormat = '%i %%';
            app.MinimumsubharmonicfouriercoefficientvalueEditField.Layout.Row = 9;
            app.MinimumsubharmonicfouriercoefficientvalueEditField.Layout.Column = 2;
            app.MinimumsubharmonicfouriercoefficientvalueEditField.Value = 10;

            % Create SampleEntropyTab
            app.SampleEntropyTab = uitab(app.TabGroup);
            app.SampleEntropyTab.Title = 'Sample Entropy';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.SampleEntropyTab);
            app.GridLayout5.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};
            app.GridLayout5.RowHeight = {'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout5.ColumnSpacing = 1;
            app.GridLayout5.RowSpacing = 1;
            app.GridLayout5.Padding = [0 0 0 0];

            % Create SampleEntropyinTimeDomainLabel
            app.SampleEntropyinTimeDomainLabel = uilabel(app.GridLayout5);
            app.SampleEntropyinTimeDomainLabel.HorizontalAlignment = 'center';
            app.SampleEntropyinTimeDomainLabel.FontWeight = 'bold';
            app.SampleEntropyinTimeDomainLabel.Tooltip = {'Fabris et al. 2013 "Voice disorders assessed by (cross-) Sample Entropy of '; 'electroglottogram and microphone signals"'};
            app.SampleEntropyinTimeDomainLabel.Layout.Row = 1;
            app.SampleEntropyinTimeDomainLabel.Layout.Column = [1 2];
            app.SampleEntropyinTimeDomainLabel.Text = 'Sample Entropy in Time Domain';

            % Create SampleEntropyinSpectralDomainLabel
            app.SampleEntropyinSpectralDomainLabel = uilabel(app.GridLayout5);
            app.SampleEntropyinSpectralDomainLabel.HorizontalAlignment = 'center';
            app.SampleEntropyinSpectralDomainLabel.FontWeight = 'bold';
            app.SampleEntropyinSpectralDomainLabel.Layout.Row = 1;
            app.SampleEntropyinSpectralDomainLabel.Layout.Column = [3 5];
            app.SampleEntropyinSpectralDomainLabel.Text = 'Sample Entropy in Spectral Domain';

            % Create SampEntemplatedistancethresholdofstdEditFieldLabel
            app.SampEntemplatedistancethresholdofstdEditFieldLabel = uilabel(app.GridLayout5);
            app.SampEntemplatedistancethresholdofstdEditFieldLabel.HorizontalAlignment = 'right';
            app.SampEntemplatedistancethresholdofstdEditFieldLabel.WordWrap = 'on';
            app.SampEntemplatedistancethresholdofstdEditFieldLabel.Layout.Row = 2;
            app.SampEntemplatedistancethresholdofstdEditFieldLabel.Layout.Column = 1;
            app.SampEntemplatedistancethresholdofstdEditFieldLabel.Text = 'SampEn template distance threshold (% of std)';

            % Create SampEnTimeTemplatedistancethresholdofstdEditField
            app.SampEnTimeTemplatedistancethresholdofstdEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnTimeTemplatedistancethresholdofstdEditField.Limits = [10 30];
            app.SampEnTimeTemplatedistancethresholdofstdEditField.RoundFractionalValues = 'on';
            app.SampEnTimeTemplatedistancethresholdofstdEditField.ValueDisplayFormat = '%i';
            app.SampEnTimeTemplatedistancethresholdofstdEditField.Tooltip = {'Fabris et al. (2013): "To determine m and r, the same empirical suggestions made for '; 'ApEn in [16,17,35], i.e. choose m such that 10m is of the order of '; 'N and r between 0.1 and 0.25 times the sample signal standard '; 'deviation (SD), can be used."'; 'For window based analysis with 41ms and 2ms overlap, Selamtzis used 0.1'};
            app.SampEnTimeTemplatedistancethresholdofstdEditField.Layout.Row = 2;
            app.SampEnTimeTemplatedistancethresholdofstdEditField.Layout.Column = 2;
            app.SampEnTimeTemplatedistancethresholdofstdEditField.Value = 25;

            % Create SampEntemplatedistancethresholdofstdEditField_2Label
            app.SampEntemplatedistancethresholdofstdEditField_2Label = uilabel(app.GridLayout5);
            app.SampEntemplatedistancethresholdofstdEditField_2Label.HorizontalAlignment = 'right';
            app.SampEntemplatedistancethresholdofstdEditField_2Label.WordWrap = 'on';
            app.SampEntemplatedistancethresholdofstdEditField_2Label.Layout.Row = 2;
            app.SampEntemplatedistancethresholdofstdEditField_2Label.Layout.Column = 3;
            app.SampEntemplatedistancethresholdofstdEditField_2Label.Text = {'SampEn template distance threshold for Magnitude of Fourier Descriptors'; '(% of std)'};

            % Create SampEnFDMagnitudeTemplatedistancethresholdofstdEditField
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Limits = [10 90];
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.RoundFractionalValues = 'on';
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.ValueDisplayFormat = '%i';
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Tooltip = {'Selamtzis et al. (2014): "The matching tolerance r was '; 'adjusted by experimentation to be 0.2 for the amplitudes and '; '0.4 for the phases."'};
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Layout.Row = 2;
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Layout.Column = 4;
            app.SampEnFDMagnitudeTemplatedistancethresholdofstdEditField.Value = 20;

            % Create RawSelamtzisSexSwitch
            app.RawSelamtzisSexSwitch = uiswitch(app.GridLayout5, 'slider');
            app.RawSelamtzisSexSwitch.Items = {'female', 'male'};
            app.RawSelamtzisSexSwitch.Orientation = 'vertical';
            app.RawSelamtzisSexSwitch.Layout.Row = [2 3];
            app.RawSelamtzisSexSwitch.Layout.Column = 5;
            app.RawSelamtzisSexSwitch.Value = 'male';

            % Create SampEntemplatedistancethresholdofstdEditField_2Label_2
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2 = uilabel(app.GridLayout5);
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2.HorizontalAlignment = 'right';
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2.WordWrap = 'on';
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2.Layout.Row = 3;
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2.Layout.Column = 3;
            app.SampEntemplatedistancethresholdofstdEditField_2Label_2.Text = {'SampEn template distance threshold for Phase of Fourier Descriptors'; '(% of std)'};

            % Create SampEnFDPhaseTemplatedistancethresholdofstdEditField
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Limits = [10 90];
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.RoundFractionalValues = 'on';
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.ValueDisplayFormat = '%i';
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Tooltip = {'Selamtzis et al. (2014): "The matching tolerance r was '; 'adjusted by experimentation to be 0.2 for the amplitudes and '; '0.4 for the phases."'};
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Layout.Row = 3;
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Layout.Column = 4;
            app.SampEnFDPhaseTemplatedistancethresholdofstdEditField.Value = 40;

            % Create SampEntemplatelengthmethodDropDownLabel
            app.SampEntemplatelengthmethodDropDownLabel = uilabel(app.GridLayout5);
            app.SampEntemplatelengthmethodDropDownLabel.HorizontalAlignment = 'right';
            app.SampEntemplatelengthmethodDropDownLabel.WordWrap = 'on';
            app.SampEntemplatelengthmethodDropDownLabel.Layout.Row = 4;
            app.SampEntemplatelengthmethodDropDownLabel.Layout.Column = 1;
            app.SampEntemplatelengthmethodDropDownLabel.Text = 'SampEn template length method';

            % Create SampEnTimeTemplatelengthmethodDropDown
            app.SampEnTimeTemplatelengthmethodDropDown = uidropdown(app.GridLayout5);
            app.SampEnTimeTemplatelengthmethodDropDown.Items = {'log10(windowLength)', 'fixed length'};
            app.SampEnTimeTemplatelengthmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @SampEnTimeTemplatelengthmethodDropDownValueChanged, true);
            app.SampEnTimeTemplatelengthmethodDropDown.Tooltip = {'Selamtzis used log10(windowLength) with window of 41ms and 2ms overlap'};
            app.SampEnTimeTemplatelengthmethodDropDown.Layout.Row = 4;
            app.SampEnTimeTemplatelengthmethodDropDown.Layout.Column = 2;
            app.SampEnTimeTemplatelengthmethodDropDown.Value = 'log10(windowLength)';

            % Create SampEntemplatelengthmethodDropDown_2Label
            app.SampEntemplatelengthmethodDropDown_2Label = uilabel(app.GridLayout5);
            app.SampEntemplatelengthmethodDropDown_2Label.HorizontalAlignment = 'right';
            app.SampEntemplatelengthmethodDropDown_2Label.WordWrap = 'on';
            app.SampEntemplatelengthmethodDropDown_2Label.Layout.Row = 4;
            app.SampEntemplatelengthmethodDropDown_2Label.Layout.Column = 3;
            app.SampEntemplatelengthmethodDropDown_2Label.Text = 'SampEn template length method';

            % Create SampEnFDtemplatelengthmethodDropDown
            app.SampEnFDtemplatelengthmethodDropDown = uidropdown(app.GridLayout5);
            app.SampEnFDtemplatelengthmethodDropDown.Items = {'log10(signalLength)', 'fixed length'};
            app.SampEnFDtemplatelengthmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @SampEnFDtemplatelengthmethodDropDownValueChanged, true);
            app.SampEnFDtemplatelengthmethodDropDown.Tooltip = {'Selamtzis used fixed length of 1 for whole signal analysis'};
            app.SampEnFDtemplatelengthmethodDropDown.Layout.Row = 4;
            app.SampEnFDtemplatelengthmethodDropDown.Layout.Column = 4;
            app.SampEnFDtemplatelengthmethodDropDown.Value = 'fixed length';

            % Create RawSelamtzisSexSwitchLabel
            app.RawSelamtzisSexSwitchLabel = uilabel(app.GridLayout5);
            app.RawSelamtzisSexSwitchLabel.HorizontalAlignment = 'center';
            app.RawSelamtzisSexSwitchLabel.Layout.Row = 4;
            app.RawSelamtzisSexSwitchLabel.Layout.Column = 5;
            app.RawSelamtzisSexSwitchLabel.Text = {'Number of cycles to be considered'; '(male=10, overlap 9'; 'female=20, overlap 19)'};

            % Create TemplatefixedlengthsamplesEditFieldLabel
            app.TemplatefixedlengthsamplesEditFieldLabel = uilabel(app.GridLayout5);
            app.TemplatefixedlengthsamplesEditFieldLabel.HorizontalAlignment = 'right';
            app.TemplatefixedlengthsamplesEditFieldLabel.WordWrap = 'on';
            app.TemplatefixedlengthsamplesEditFieldLabel.Layout.Row = 5;
            app.TemplatefixedlengthsamplesEditFieldLabel.Layout.Column = 1;
            app.TemplatefixedlengthsamplesEditFieldLabel.Text = 'Template fixed length (samples)';

            % Create SampEnTimeTemplatefixedlengthsamplesEditField
            app.SampEnTimeTemplatefixedlengthsamplesEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnTimeTemplatefixedlengthsamplesEditField.Limits = [1 Inf];
            app.SampEnTimeTemplatefixedlengthsamplesEditField.RoundFractionalValues = 'on';
            app.SampEnTimeTemplatefixedlengthsamplesEditField.Enable = 'off';
            app.SampEnTimeTemplatefixedlengthsamplesEditField.Layout.Row = 5;
            app.SampEnTimeTemplatefixedlengthsamplesEditField.Layout.Column = 2;
            app.SampEnTimeTemplatefixedlengthsamplesEditField.Value = 1;

            % Create TemplatefixedlengthsamplesEditField_2Label
            app.TemplatefixedlengthsamplesEditField_2Label = uilabel(app.GridLayout5);
            app.TemplatefixedlengthsamplesEditField_2Label.HorizontalAlignment = 'right';
            app.TemplatefixedlengthsamplesEditField_2Label.WordWrap = 'on';
            app.TemplatefixedlengthsamplesEditField_2Label.Layout.Row = 5;
            app.TemplatefixedlengthsamplesEditField_2Label.Layout.Column = 3;
            app.TemplatefixedlengthsamplesEditField_2Label.Text = 'Template fixed length (samples)';

            % Create SampEnFDtemplatefixedlengthsamplesEditField
            app.SampEnFDtemplatefixedlengthsamplesEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnFDtemplatefixedlengthsamplesEditField.Limits = [1 Inf];
            app.SampEnFDtemplatefixedlengthsamplesEditField.RoundFractionalValues = 'on';
            app.SampEnFDtemplatefixedlengthsamplesEditField.Tooltip = {'Selamtzis used 1 when using no windows'};
            app.SampEnFDtemplatefixedlengthsamplesEditField.Layout.Row = 5;
            app.SampEnFDtemplatefixedlengthsamplesEditField.Layout.Column = 4;
            app.SampEnFDtemplatefixedlengthsamplesEditField.Value = 1;

            % Create ScaleSampEntorange0to1CheckBox
            app.ScaleSampEntorange0to1CheckBox = uicheckbox(app.GridLayout5);
            app.ScaleSampEntorange0to1CheckBox.Visible = 'off';
            app.ScaleSampEntorange0to1CheckBox.Text = 'Scale SampEn to range 0 to 1';
            app.ScaleSampEntorange0to1CheckBox.Layout.Row = 5;
            app.ScaleSampEntorange0to1CheckBox.Layout.Column = 5;

            % Create normalizationmethodDropDownLabel
            app.normalizationmethodDropDownLabel = uilabel(app.GridLayout5);
            app.normalizationmethodDropDownLabel.HorizontalAlignment = 'right';
            app.normalizationmethodDropDownLabel.WordWrap = 'on';
            app.normalizationmethodDropDownLabel.Layout.Row = 6;
            app.normalizationmethodDropDownLabel.Layout.Column = 1;
            app.normalizationmethodDropDownLabel.Text = 'normalization method';

            % Create SampEnTimeNormalizationmethodDropDown
            app.SampEnTimeNormalizationmethodDropDown = uidropdown(app.GridLayout5);
            app.SampEnTimeNormalizationmethodDropDown.Items = {'none', 'zscore', 'norm', 'scale', 'range', 'center', 'medianiqr'};
            app.SampEnTimeNormalizationmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @SampEnTimeNormalizationmethodDropDownValueChanged, true);
            app.SampEnTimeNormalizationmethodDropDown.Tooltip = {'''zscore'''; 'z-score with mean 0 and standard deviation 1.'; ''; '''norm'''; '2-norm.'; ''; '''scale'''; 'Scale by standard deviation.'; ''; '''range'''; 'Rescale range of data to [0,1].'; ''; '''center'''; 'Center data to have mean 0.'; ''; '''medianiqr'''; 'Center and scale data to have median 0 and interquartile range 1.'};
            app.SampEnTimeNormalizationmethodDropDown.Layout.Row = 6;
            app.SampEnTimeNormalizationmethodDropDown.Layout.Column = 2;
            app.SampEnTimeNormalizationmethodDropDown.Value = 'zscore';

            % Create UserelativeFourierDescriptorsDropDownLabel
            app.UserelativeFourierDescriptorsDropDownLabel = uilabel(app.GridLayout5);
            app.UserelativeFourierDescriptorsDropDownLabel.HorizontalAlignment = 'right';
            app.UserelativeFourierDescriptorsDropDownLabel.WordWrap = 'on';
            app.UserelativeFourierDescriptorsDropDownLabel.Tooltip = {'Selamtzis Doctoral thesis:'; '"To avoid dependencies on the amplitude of the EGG waveform, '; 'due to changes in electrode position, the relative FD levels can be used, i.e., the diﬀerence between the level of the harmonics and the level of the fundamental '; '(∆Ln). Similarly, the phase diﬀerences relative to the phase of the fundamental '; '(∆φn) can be considered, to eliminate possible dependency on speciﬁc trigger points '; 'of the glottal cycle waveforms."'};
            app.UserelativeFourierDescriptorsDropDownLabel.Layout.Row = 6;
            app.UserelativeFourierDescriptorsDropDownLabel.Layout.Column = 3;
            app.UserelativeFourierDescriptorsDropDownLabel.Text = 'Use relative Fourier Descriptors';

            % Create SampEnFDuserelativeFourierDescriptorsDropDown
            app.SampEnFDuserelativeFourierDescriptorsDropDown = uidropdown(app.GridLayout5);
            app.SampEnFDuserelativeFourierDescriptorsDropDown.Items = {'Yes', 'No'};
            app.SampEnFDuserelativeFourierDescriptorsDropDown.Tooltip = {'Selamtzis Doctoral thesis:'; '"To avoid dependencies on the amplitude of the EGG waveform, '; 'due to changes in electrode position, the relative FD levels can be used, i.e., the diﬀerence between the level of the harmonics and the level of the fundamental '; '(∆Ln). Similarly, the phase diﬀerences relative to the phase of the fundamental '; '(∆φn) can be considered, to eliminate possible dependency on speciﬁc trigger points '; 'of the glottal cycle waveforms."'};
            app.SampEnFDuserelativeFourierDescriptorsDropDown.Layout.Row = 6;
            app.SampEnFDuserelativeFourierDescriptorsDropDown.Layout.Column = 4;
            app.SampEnFDuserelativeFourierDescriptorsDropDown.Value = 'No';

            % Create PlotrawsampleentropyCheckBox
            app.PlotrawsampleentropyCheckBox = uicheckbox(app.GridLayout5);
            app.PlotrawsampleentropyCheckBox.Visible = 'off';
            app.PlotrawsampleentropyCheckBox.Text = 'Plot raw sample entropy';
            app.PlotrawsampleentropyCheckBox.Layout.Row = 6;
            app.PlotrawsampleentropyCheckBox.Layout.Column = 5;

            % Create normalizationhorizontDropDownLabel
            app.normalizationhorizontDropDownLabel = uilabel(app.GridLayout5);
            app.normalizationhorizontDropDownLabel.HorizontalAlignment = 'right';
            app.normalizationhorizontDropDownLabel.WordWrap = 'on';
            app.normalizationhorizontDropDownLabel.Layout.Row = 7;
            app.normalizationhorizontDropDownLabel.Layout.Column = 1;
            app.normalizationhorizontDropDownLabel.Text = 'normalization horizont';

            % Create SampEnTimeNormalizationhorizontDropDown
            app.SampEnTimeNormalizationhorizontDropDown = uidropdown(app.GridLayout5);
            app.SampEnTimeNormalizationhorizontDropDown.Items = {'window based', 'global/selection based'};
            app.SampEnTimeNormalizationhorizontDropDown.Tooltip = {'How to Decide:'; 'Global Comparisons Across Segments: If your goal is to compare entropy across windows, normalize the entire signal once to ensure uniform scaling.'; ''; 'Local Feature Analysis: If you’re more interested in the dynamics within each window and how they differ, normalize each window separately.'; ''; 'Recommendations:'; 'For signals with significant variability between segments (e.g., changing trends or amplitudes), normalizing each window separately is often preferred. However, if the signal is relatively consistent, normalizing the entire signal once can provide cleaner comparisons across windows without additional noise.'};
            app.SampEnTimeNormalizationhorizontDropDown.Layout.Row = 7;
            app.SampEnTimeNormalizationhorizontDropDown.Layout.Column = 2;
            app.SampEnTimeNormalizationhorizontDropDown.Value = 'window based';

            % Create FinalcombinationmethodofSampleEntropyDropDownLabel
            app.FinalcombinationmethodofSampleEntropyDropDownLabel = uilabel(app.GridLayout5);
            app.FinalcombinationmethodofSampleEntropyDropDownLabel.HorizontalAlignment = 'right';
            app.FinalcombinationmethodofSampleEntropyDropDownLabel.WordWrap = 'on';
            app.FinalcombinationmethodofSampleEntropyDropDownLabel.Layout.Row = 7;
            app.FinalcombinationmethodofSampleEntropyDropDownLabel.Layout.Column = 3;
            app.FinalcombinationmethodofSampleEntropyDropDownLabel.Text = 'Final combination method of Sample Entropy';

            % Create SampEnFDfinalcombinationmethodDropDown
            app.SampEnFDfinalcombinationmethodDropDown = uidropdown(app.GridLayout5);
            app.SampEnFDfinalcombinationmethodDropDown.Items = {'add', 'max', 'min'};
            app.SampEnFDfinalcombinationmethodDropDown.Tooltip = {'For each fourier descriptor (FD) a sample entropy is calculated for the magitude and the phase. This results into 4 separate sample entropies (or 2 if using relative sample entropy) and needs to be combined to get one value. Selamtzis et al. summed up the sample entropies to get the final sample entropy called SampEn.'};
            app.SampEnFDfinalcombinationmethodDropDown.Layout.Row = 7;
            app.SampEnFDfinalcombinationmethodDropDown.Layout.Column = 4;
            app.SampEnFDfinalcombinationmethodDropDown.Value = 'add';

            % Create NumberofharmonicstobeusedLabel
            app.NumberofharmonicstobeusedLabel = uilabel(app.GridLayout5);
            app.NumberofharmonicstobeusedLabel.HorizontalAlignment = 'right';
            app.NumberofharmonicstobeusedLabel.Tooltip = {'Selamtzis et al. used e.g. 2 here, i.e. fo and 2*fo'; '"Here, the Sample Entropy '; 'was calculated with a MATLAB routine (Lake et al.) for the '; 'amplitudes and phases of the ﬁrst two harmonics D[1,c] and '; 'D[2,c]."'};
            app.NumberofharmonicstobeusedLabel.Layout.Row = 8;
            app.NumberofharmonicstobeusedLabel.Layout.Column = 3;
            app.NumberofharmonicstobeusedLabel.Text = {'Number of harmonics'; 'to be used'};

            % Create SampEnFDnumberofharmonicstobeusedEditField
            app.SampEnFDnumberofharmonicstobeusedEditField = uieditfield(app.GridLayout5, 'numeric');
            app.SampEnFDnumberofharmonicstobeusedEditField.Limits = [2 50];
            app.SampEnFDnumberofharmonicstobeusedEditField.RoundFractionalValues = 'on';
            app.SampEnFDnumberofharmonicstobeusedEditField.ValueDisplayFormat = '%i';
            app.SampEnFDnumberofharmonicstobeusedEditField.Tooltip = {'Selamtzis et al. used e.g. 2 here, i.e. fo and 2*fo'; '"Here, the Sample Entropy '; 'was calculated with a MATLAB routine (Lake et al.) for the '; 'amplitudes and phases of the ﬁrst two harmonics D[1,c] and '; 'D[2,c]."'; 'The more harmonics used, the higher threshold should be used for Magnitude and  (especially) phase tolerance'};
            app.SampEnFDnumberofharmonicstobeusedEditField.Layout.Row = 8;
            app.SampEnFDnumberofharmonicstobeusedEditField.Layout.Column = 4;
            app.SampEnFDnumberofharmonicstobeusedEditField.Value = 2;

            % Create CPPTab
            app.CPPTab = uitab(app.TabGroup);
            app.CPPTab.Title = 'CPP(s)';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.CPPTab);
            app.GridLayout6.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout6.RowHeight = {'1x', 'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout6.RowSpacing = 1;

            % Create CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel = uilabel(app.GridLayout6);
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.HorizontalAlignment = 'center';
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.WordWrap = 'on';
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.FontWeight = 'bold';
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.Layout.Row = 1;
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.Layout.Column = [1 2];
            app.CepstrumBaselinefittingwindowsizeequaltoanalysiswindowsizeLabel.Text = {'Cepstrum Baseline fitting'; '(window size equal to analysis window size)'};

            % Create CPPandCPPswithcustomWindowSizeCPPsv3Label
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label = uilabel(app.GridLayout6);
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.BackgroundColor = [0.8392 0.9804 0.749];
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.HorizontalAlignment = 'center';
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.WordWrap = 'on';
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.FontWeight = 'bold';
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.Layout.Row = 1;
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.Layout.Column = [3 4];
            app.CPPandCPPswithcustomWindowSizeCPPsv3Label.Text = 'CPP and CPPs with custom Window Size (CPP(s) v3)';

            % Create SettingsapplyingforbothLabel
            app.SettingsapplyingforbothLabel = uilabel(app.GridLayout6);
            app.SettingsapplyingforbothLabel.HorizontalAlignment = 'center';
            app.SettingsapplyingforbothLabel.FontSize = 18;
            app.SettingsapplyingforbothLabel.FontWeight = 'bold';
            app.SettingsapplyingforbothLabel.Layout.Row = 2;
            app.SettingsapplyingforbothLabel.Layout.Column = [1 4];
            app.SettingsapplyingforbothLabel.Text = 'Settings applying for both:';

            % Create LowerQuefrencyLimitsEditFieldLabel
            app.LowerQuefrencyLimitsEditFieldLabel = uilabel(app.GridLayout6);
            app.LowerQuefrencyLimitsEditFieldLabel.HorizontalAlignment = 'right';
            app.LowerQuefrencyLimitsEditFieldLabel.WordWrap = 'on';
            app.LowerQuefrencyLimitsEditFieldLabel.Layout.Row = 3;
            app.LowerQuefrencyLimitsEditFieldLabel.Layout.Column = [1 2];
            app.LowerQuefrencyLimitsEditFieldLabel.Text = 'Lower Quefrency Limit (s)';

            % Create LowerQuefrencyLimitsEditField
            app.LowerQuefrencyLimitsEditField = uieditfield(app.GridLayout6, 'numeric');
            app.LowerQuefrencyLimitsEditField.Limits = [0 0.004];
            app.LowerQuefrencyLimitsEditField.ValueDisplayFormat = '%11.4g s';
            app.LowerQuefrencyLimitsEditField.Tooltip = {'Default would be 0.001s, but the upper border should be smaller than 1/maxFo becuase otherwise the fit regions does not cover the fundamental frequency'};
            app.LowerQuefrencyLimitsEditField.Layout.Row = 3;
            app.LowerQuefrencyLimitsEditField.Layout.Column = [3 4];
            app.LowerQuefrencyLimitsEditField.Value = 0.001;

            % Create UpperQuefrencyLimitsEditFieldLabel
            app.UpperQuefrencyLimitsEditFieldLabel = uilabel(app.GridLayout6);
            app.UpperQuefrencyLimitsEditFieldLabel.HorizontalAlignment = 'right';
            app.UpperQuefrencyLimitsEditFieldLabel.WordWrap = 'on';
            app.UpperQuefrencyLimitsEditFieldLabel.Layout.Row = 4;
            app.UpperQuefrencyLimitsEditFieldLabel.Layout.Column = [1 2];
            app.UpperQuefrencyLimitsEditFieldLabel.Text = 'Upper Quefrency Limit (s)';

            % Create UpperQuefrencyLimitsEditField
            app.UpperQuefrencyLimitsEditField = uieditfield(app.GridLayout6, 'numeric');
            app.UpperQuefrencyLimitsEditField.Limits = [0 Inf];
            app.UpperQuefrencyLimitsEditField.ValueDisplayFormat = '%11.4g s';
            app.UpperQuefrencyLimitsEditField.Layout.Row = 4;
            app.UpperQuefrencyLimitsEditField.Layout.Column = [3 4];
            app.UpperQuefrencyLimitsEditField.Value = Inf;

            % Create SearchCepstrummaximuminfitregiononlyDropDownLabel
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel = uilabel(app.GridLayout6);
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel.HorizontalAlignment = 'right';
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel.WordWrap = 'on';
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel.Layout.Row = 5;
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel.Layout.Column = 1;
            app.SearchCepstrummaximuminfitregiononlyDropDownLabel.Text = 'Search Cepstrum maximum in fit region only';

            % Create CepstrumMaxInFitRegionOnlyDropDown
            app.CepstrumMaxInFitRegionOnlyDropDown = uidropdown(app.GridLayout6);
            app.CepstrumMaxInFitRegionOnlyDropDown.Items = {'No', 'Yes'};
            app.CepstrumMaxInFitRegionOnlyDropDown.ItemsData = {'0', '1'};
            app.CepstrumMaxInFitRegionOnlyDropDown.Layout.Row = 5;
            app.CepstrumMaxInFitRegionOnlyDropDown.Layout.Column = 2;
            app.CepstrumMaxInFitRegionOnlyDropDown.Value = '0';

            % Create Searchinginitfrm_orangeLabel
            app.Searchinginitfrm_orangeLabel = uilabel(app.GridLayout6);
            app.Searchinginitfrm_orangeLabel.HorizontalAlignment = 'center';
            app.Searchinginitfrm_orangeLabel.WordWrap = 'on';
            app.Searchinginitfrm_orangeLabel.Layout.Row = 5;
            app.Searchinginitfrm_orangeLabel.Layout.Column = [3 4];
            app.Searchinginitfrm_orangeLabel.Interpreter = 'tex';
            app.Searchinginitfrm_orangeLabel.Text = 'Searching in \itf\rm_o range';

            % Create WindowTypeDropDownLabel
            app.WindowTypeDropDownLabel = uilabel(app.GridLayout6);
            app.WindowTypeDropDownLabel.HorizontalAlignment = 'right';
            app.WindowTypeDropDownLabel.WordWrap = 'on';
            app.WindowTypeDropDownLabel.Tooltip = {'Why Use Windows?'; 'In both digital filter design and spectral estimation, the choice of a windowing function can play an important role in determining the quality of overall results. The main role of the window is to damp out the effects of the Gibbs phenomenon that results from truncation of an infinite series.'};
            app.WindowTypeDropDownLabel.Layout.Row = 6;
            app.WindowTypeDropDownLabel.Layout.Column = [1 2];
            app.WindowTypeDropDownLabel.Text = 'Window Type';

            % Create CepstrumWindowTypeDropDown
            app.CepstrumWindowTypeDropDown = uidropdown(app.GridLayout6);
            app.CepstrumWindowTypeDropDown.Items = {'none (rectangular)', 'Hann', 'Hamming', 'Bartlett-Hann', 'Bartlett', 'Blackman', 'Blackman-Harris', 'Bohman', 'Chebyshev', 'Flat Top', 'Gaussian', 'Nuttall''s Blackman-Harris', 'Parzen', 'Triangular'};
            app.CepstrumWindowTypeDropDown.ItemsData = {'rectwin', 'hann', 'hamming', 'barthannwin', 'bartlett', 'blackman', 'blackmanharris', 'bohmanwin', 'chebwin', 'flattopwin', 'gausswin', 'nuttallwin', 'parzenwin', 'triang'};
            app.CepstrumWindowTypeDropDown.Tooltip = {'Why Use Windows?'; 'In both digital filter design and spectral estimation, the choice of a windowing function can play an important role in determining the quality of overall results. The main role of the window is to damp out the effects of the Gibbs phenomenon that results from truncation of an infinite series.'};
            app.CepstrumWindowTypeDropDown.Layout.Row = 6;
            app.CepstrumWindowTypeDropDown.Layout.Column = [3 4];
            app.CepstrumWindowTypeDropDown.Value = 'hann';

            % Create BaselinefittingtypeDropDownLabel
            app.BaselinefittingtypeDropDownLabel = uilabel(app.GridLayout6);
            app.BaselinefittingtypeDropDownLabel.HorizontalAlignment = 'right';
            app.BaselinefittingtypeDropDownLabel.WordWrap = 'on';
            app.BaselinefittingtypeDropDownLabel.Layout.Row = 7;
            app.BaselinefittingtypeDropDownLabel.Layout.Column = [1 2];
            app.BaselinefittingtypeDropDownLabel.Text = 'Baseline fitting type';

            % Create BaselinefittingtypeDropDown
            app.BaselinefittingtypeDropDown = uidropdown(app.GridLayout6);
            app.BaselinefittingtypeDropDown.Items = {'linear', 'parabolic', 'exponential'};
            app.BaselinefittingtypeDropDown.ItemsData = {'poly1', 'poly2', 'exp1'};
            app.BaselinefittingtypeDropDown.Layout.Row = 7;
            app.BaselinefittingtypeDropDown.Layout.Column = [3 4];
            app.BaselinefittingtypeDropDown.Value = 'poly1';

            % Create RobustfittingmethodDropDownLabel
            app.RobustfittingmethodDropDownLabel = uilabel(app.GridLayout6);
            app.RobustfittingmethodDropDownLabel.HorizontalAlignment = 'right';
            app.RobustfittingmethodDropDownLabel.WordWrap = 'on';
            app.RobustfittingmethodDropDownLabel.Layout.Row = 8;
            app.RobustfittingmethodDropDownLabel.Layout.Column = [1 2];
            app.RobustfittingmethodDropDownLabel.Text = 'Robust fitting method';

            % Create RobustfittingmethodDropDown
            app.RobustfittingmethodDropDown = uidropdown(app.GridLayout6);
            app.RobustfittingmethodDropDown.Items = {'bisquare weights', 'least absolute residual', 'none'};
            app.RobustfittingmethodDropDown.ItemsData = {'bisquare', 'LAR', 'off'};
            app.RobustfittingmethodDropDown.Layout.Row = 8;
            app.RobustfittingmethodDropDown.Layout.Column = [3 4];
            app.RobustfittingmethodDropDown.Value = 'off';

            % Create individualsettingsforcustomWindowSizeCPPsv3Label
            app.individualsettingsforcustomWindowSizeCPPsv3Label = uilabel(app.GridLayout6);
            app.individualsettingsforcustomWindowSizeCPPsv3Label.BackgroundColor = [0.8392 0.9804 0.749];
            app.individualsettingsforcustomWindowSizeCPPsv3Label.HorizontalAlignment = 'center';
            app.individualsettingsforcustomWindowSizeCPPsv3Label.WordWrap = 'on';
            app.individualsettingsforcustomWindowSizeCPPsv3Label.FontSize = 18;
            app.individualsettingsforcustomWindowSizeCPPsv3Label.FontWeight = 'bold';
            app.individualsettingsforcustomWindowSizeCPPsv3Label.Layout.Row = 9;
            app.individualsettingsforcustomWindowSizeCPPsv3Label.Layout.Column = [1 4];
            app.individualsettingsforcustomWindowSizeCPPsv3Label.Text = 'individual settings for custom Window Size (CPP(s) v3):';

            % Create UsePreemphasisDropDownLabel
            app.UsePreemphasisDropDownLabel = uilabel(app.GridLayout6);
            app.UsePreemphasisDropDownLabel.HorizontalAlignment = 'right';
            app.UsePreemphasisDropDownLabel.WordWrap = 'on';
            app.UsePreemphasisDropDownLabel.Layout.Row = 10;
            app.UsePreemphasisDropDownLabel.Layout.Column = 1;
            app.UsePreemphasisDropDownLabel.Text = 'Use Preemphasis';

            % Create UsePreemphasisDropDown
            app.UsePreemphasisDropDown = uidropdown(app.GridLayout6);
            app.UsePreemphasisDropDown.Items = {'Yes', 'No'};
            app.UsePreemphasisDropDown.ItemsData = [1 0];
            app.UsePreemphasisDropDown.Layout.Row = 10;
            app.UsePreemphasisDropDown.Layout.Column = 2;
            app.UsePreemphasisDropDown.Value = 1;

            % Create ResamplingFrequencyHzEditFieldLabel
            app.ResamplingFrequencyHzEditFieldLabel = uilabel(app.GridLayout6);
            app.ResamplingFrequencyHzEditFieldLabel.HorizontalAlignment = 'right';
            app.ResamplingFrequencyHzEditFieldLabel.Layout.Row = 10;
            app.ResamplingFrequencyHzEditFieldLabel.Layout.Column = 3;
            app.ResamplingFrequencyHzEditFieldLabel.Text = 'Resampling Frequency (Hz)';

            % Create ResamplingFrequencyHzEditField
            app.ResamplingFrequencyHzEditField = uieditfield(app.GridLayout6, 'numeric');
            app.ResamplingFrequencyHzEditField.Limits = [1 Inf];
            app.ResamplingFrequencyHzEditField.RoundFractionalValues = 'on';
            app.ResamplingFrequencyHzEditField.ValueDisplayFormat = '%11i Hz';
            app.ResamplingFrequencyHzEditField.ValueChangedFcn = createCallbackFcn(app, @updateCppLimitsCallback, true);
            app.ResamplingFrequencyHzEditField.Layout.Row = 10;
            app.ResamplingFrequencyHzEditField.Layout.Column = 4;
            app.ResamplingFrequencyHzEditField.Value = 22050;

            % Create WindowSizesEditFieldLabel
            app.WindowSizesEditFieldLabel = uilabel(app.GridLayout6);
            app.WindowSizesEditFieldLabel.HorizontalAlignment = 'right';
            app.WindowSizesEditFieldLabel.WordWrap = 'on';
            app.WindowSizesEditFieldLabel.Layout.Row = 11;
            app.WindowSizesEditFieldLabel.Layout.Column = 1;
            app.WindowSizesEditFieldLabel.Text = 'Window Size (s)';

            % Create WindowSizesEditField
            app.WindowSizesEditField = uieditfield(app.GridLayout6, 'numeric');
            app.WindowSizesEditField.LowerLimitInclusive = 'off';
            app.WindowSizesEditField.Limits = [0 Inf];
            app.WindowSizesEditField.ValueDisplayFormat = '%11.4g s';
            app.WindowSizesEditField.ValueChangedFcn = createCallbackFcn(app, @updateCppLimitsCallback, true);
            app.WindowSizesEditField.Layout.Row = 11;
            app.WindowSizesEditField.Layout.Column = 2;
            app.WindowSizesEditField.Value = 0.04644;

            % Create WindowHopSizesEditFieldLabel
            app.WindowHopSizesEditFieldLabel = uilabel(app.GridLayout6);
            app.WindowHopSizesEditFieldLabel.HorizontalAlignment = 'right';
            app.WindowHopSizesEditFieldLabel.WordWrap = 'on';
            app.WindowHopSizesEditFieldLabel.Layout.Row = 11;
            app.WindowHopSizesEditFieldLabel.Layout.Column = 3;
            app.WindowHopSizesEditFieldLabel.Text = 'Window Hop Size (s)';

            % Create WindowHopSizesEditField
            app.WindowHopSizesEditField = uieditfield(app.GridLayout6, 'numeric');
            app.WindowHopSizesEditField.LowerLimitInclusive = 'off';
            app.WindowHopSizesEditField.Limits = [0 Inf];
            app.WindowHopSizesEditField.ValueDisplayFormat = '%11.4g s';
            app.WindowHopSizesEditField.ValueChangedFcn = createCallbackFcn(app, @updateCppLimitsCallback, true);
            app.WindowHopSizesEditField.Layout.Row = 11;
            app.WindowHopSizesEditField.Layout.Column = 4;
            app.WindowHopSizesEditField.Value = 0.002;

            % Create CPPsTimeSmoothingWindowsEditFieldLabel
            app.CPPsTimeSmoothingWindowsEditFieldLabel = uilabel(app.GridLayout6);
            app.CPPsTimeSmoothingWindowsEditFieldLabel.HorizontalAlignment = 'right';
            app.CPPsTimeSmoothingWindowsEditFieldLabel.WordWrap = 'on';
            app.CPPsTimeSmoothingWindowsEditFieldLabel.Layout.Row = 12;
            app.CPPsTimeSmoothingWindowsEditFieldLabel.Layout.Column = 1;
            app.CPPsTimeSmoothingWindowsEditFieldLabel.Text = 'CPPs Time Smoothing Window (s)';

            % Create CPPsTimeSmoothingWindowsEditField
            app.CPPsTimeSmoothingWindowsEditField = uieditfield(app.GridLayout6, 'numeric');
            app.CPPsTimeSmoothingWindowsEditField.LowerLimitInclusive = 'off';
            app.CPPsTimeSmoothingWindowsEditField.Limits = [0.002 Inf];
            app.CPPsTimeSmoothingWindowsEditField.ValueDisplayFormat = '%11.4g s';
            app.CPPsTimeSmoothingWindowsEditField.ValueChangedFcn = createCallbackFcn(app, @updateCppLimitsCallback, true);
            app.CPPsTimeSmoothingWindowsEditField.Layout.Row = 12;
            app.CPPsTimeSmoothingWindowsEditField.Layout.Column = 2;
            app.CPPsTimeSmoothingWindowsEditField.Value = 0.01;

            % Create CPPsQuefrencySmoothingWindowsEditFieldLabel
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel = uilabel(app.GridLayout6);
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel.HorizontalAlignment = 'right';
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel.WordWrap = 'on';
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel.Layout.Row = 12;
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel.Layout.Column = 3;
            app.CPPsQuefrencySmoothingWindowsEditFieldLabel.Text = 'CPPs Quefrency Smoothing Window (s)';

            % Create CPPsQuefrencySmoothingWindowsEditField
            app.CPPsQuefrencySmoothingWindowsEditField = uieditfield(app.GridLayout6, 'numeric');
            app.CPPsQuefrencySmoothingWindowsEditField.LowerLimitInclusive = 'off';
            app.CPPsQuefrencySmoothingWindowsEditField.Limits = [0 0.02322];
            app.CPPsQuefrencySmoothingWindowsEditField.ValueDisplayFormat = '%11.4g s';
            app.CPPsQuefrencySmoothingWindowsEditField.ValueChangedFcn = createCallbackFcn(app, @updateCppLimitsCallback, true);
            app.CPPsQuefrencySmoothingWindowsEditField.Layout.Row = 12;
            app.CPPsQuefrencySmoothingWindowsEditField.Layout.Column = 4;
            app.CPPsQuefrencySmoothingWindowsEditField.Value = 0.001;

            % Create previewcyclesButton
            app.previewcyclesButton = uibutton(app.GridLayout, 'push');
            app.previewcyclesButton.ButtonPushedFcn = createCallbackFcn(app, @previewcyclesButtonPushed, true);
            app.previewcyclesButton.Layout.Row = 3;
            app.previewcyclesButton.Layout.Column = 1;
            app.previewcyclesButton.Text = 'preview cycles';

            % Create calculateparametersButton
            app.calculateparametersButton = uibutton(app.GridLayout, 'push');
            app.calculateparametersButton.ButtonPushedFcn = createCallbackFcn(app, @calculateparametersButtonPushed, true);
            app.calculateparametersButton.Layout.Row = 3;
            app.calculateparametersButton.Layout.Column = 2;
            app.calculateparametersButton.Text = 'calculate parameters';

            % Create KeepSettingsoverSessionsCheckBox
            app.KeepSettingsoverSessionsCheckBox = uicheckbox(app.GridLayout);
            app.KeepSettingsoverSessionsCheckBox.Tooltip = {'When unchecked, the "lastVocaliscopesettings.mat" file, which stores the settings, is deleted when the main window is closed'};
            app.KeepSettingsoverSessionsCheckBox.Text = 'Keep Settings over Sessions';
            app.KeepSettingsoverSessionsCheckBox.WordWrap = 'on';
            app.KeepSettingsoverSessionsCheckBox.Layout.Row = 3;
            app.KeepSettingsoverSessionsCheckBox.Layout.Column = 4;
            app.KeepSettingsoverSessionsCheckBox.Value = true;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = VocaliscopeCalculationSettings(varargin)

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
