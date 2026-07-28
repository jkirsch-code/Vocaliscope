function compileVocaliscope(version)

if nargin<1 || isempty(version)
    version=getVersionFromMlapp('Vocaliscope.mlapp');
elseif isnumeric(version)
    version=num2str(version,'%3.1f');
end

% make sure we are in the directory of this file
cd(fileparts(mfilename("fullpath")));

save('currentAppVersion.mat',"version");

%% Export .mlapp files to plain-text .m references
mlappFiles = {'Vocaliscope.mlapp', 'VocaliscopeCalculationSettings.mlapp', ...
              'SampEnApp.mlapp', 'maskCreator.mlapp', 'interactiveFiltering.mlapp'};
mlappSourceDir = 'mlapp_source';
if ~isfolder(mlappSourceDir)
    mkdir(mlappSourceDir);
end
for k = 1:numel(mlappFiles)
    if isfile(mlappFiles{k})
        [~, name] = fileparts(mlappFiles{k});
        output = evalc(sprintf('type(''%s'')', mlappFiles{k}));
        fid = fopen(fullfile(mlappSourceDir, [name '.m']), 'w', 'n', 'UTF-8');
        fprintf(fid, '%s', output);
        fclose(fid);
        
    end
end

if isfolder('VocaliscopestandaloneApplication')
    delete('VocaliscopestandaloneApplication\*.exe');
end

splashName='mySplash.png';
iconName='myIcon.png';
compileObj=compiler.build.standaloneApplication('Vocaliscope.mlapp',...
    'ExecutableVersion',version,...
    'ExecutableSplashScreen',splashName,...
    'ExecutableIcon',iconName,...
    'AdditionalFiles',{'+FCWT\fCWT.mexw64','+FCWT\fCWT.dll','+FCWT\fftw3f.dll','InverseFilteringMethods\','filedownloadGUI\','+praatMEX\praatmex.mexw64'},...
    'SupportPackages','none');

disp('compiling finished');

disp(compileObj)
disp(compileObj.Files)
disp(compileObj.RuntimeDependencies)

disp('copying dependencies...');

if isfile('VocaliscopestandaloneApplication\Vocaliscope.exe')
    movefile('VocaliscopestandaloneApplication\Vocaliscope.exe',['VocaliscopestandaloneApplication\Vocaliscope_V' strrep(version,'.','_') '.exe']);
end


compiledPath='VocaliscopestandaloneApplication\forCompiling\';

if isfolder(compiledPath)
    rmdir(compiledPath,"s")
    mkdir(compiledPath);
else
    mkdir(compiledPath);
end

[fListApp] = matlab.codetools.requiredFilesAndProducts('Vocaliscope.mlapp');

fListAdditional=compileObj.Options.AdditionalFiles';

currentScriptName=[mfilename '.m'];
[fListCompilation] = matlab.codetools.requiredFilesAndProducts(currentScriptName);

LicenseFiles=SUBDIR.subdir('*License*');
LicenseFiles=fullfile({LicenseFiles.folder},{LicenseFiles.name});
LicenseFiles(~contains(LicenseFiles,[filesep '+']))=[];

ReadmeFiles=SUBDIR.subdir('*Readme*');
ReadmeFiles=fullfile({ReadmeFiles.folder},{ReadmeFiles.name});
ReadmeFiles(~contains(ReadmeFiles,[filesep '+']))=[];

% remove folders subfiles which are in a folder in the additional compile
% list

fListApp(contains(fListApp,fListAdditional(isfolder(fListAdditional))))=[];




totalList=[fListApp fListAdditional fListCompilation LicenseFiles ReadmeFiles {splashName iconName}];

totalList=unique(totalList);

% remove some m files which seem to be interpreted as beeing necessary
% from the compiler since those exist with an appropriate app signature. of
% course those functions are inside vocaliscope already
totalList(contains(totalList,{'openOnsetAnalysisWindow.m','openPraatAnalysisWindow.m','openVibratoAnalysisWindow.m'}))=[];


% move lastly compiled version of the mex to the subpackage main directory
% to be up to date
if isfolder("+praatMEX\build\Release\")
    clear praatmex; % to avoid blocking by running matlab application
    copyfile("+praatMEX\build\Release\praatmex.mexw64","+praatMEX\praatmex.mexw64","f");
end

% remove files from compilation source of praatMEX
totalList(contains(totalList,'+praatMEX\praat\'))=[];



for nr=1:numel(totalList)
    
    [~,name,ext]=fileparts(totalList{nr});
    if isempty(strfind(totalList{nr},[filesep '+']))
        copyfile(totalList{nr},[compiledPath name ext]);
    else % to preserve folder structure if i want to compile it separately later
        containingFolder=extractBetween(totalList{nr},[filesep '+'],[name ext]); containingFolder=containingFolder{1}; containingFolder=['+' containingFolder];

        if ~isfolder([compiledPath containingFolder])
            mkdir([compiledPath containingFolder]);
        end
        copyfile(totalList{nr},[compiledPath containingFolder name ext]);
    end
end

% Copy mlapp_source to forCompiling
if isfolder(mlappSourceDir)
    mlappSourceFiles = dir(fullfile(mlappSourceDir, '*.m'));
    copyTarget = fullfile(compiledPath, mlappSourceDir);
    if ~isfolder(copyTarget)
        mkdir(copyTarget);
    end
    for k = 1:numel(mlappSourceFiles)
        copyfile(fullfile(mlappSourceFiles(k).folder, mlappSourceFiles(k).name), ...
                 fullfile(copyTarget, mlappSourceFiles(k).name));
    end
end

% Copy release notes to VocaliscopestandaloneApplication and forCompiling
releaseNotesFile = 'ReleaseNotes.md';
if isfile(releaseNotesFile)
    copyfile(releaseNotesFile, fullfile('VocaliscopestandaloneApplication', releaseNotesFile));
    copyfile(releaseNotesFile, fullfile(compiledPath, releaseNotesFile));
end

% not needed anymore since we use the C code
% % we also need to copy the praat scripts since those are only used
% % inidrectly via cmd and Praat.exe
% praatFiles=dir('+usePraatViaMatlab\*.praat');
% praatFiles=append({praatFiles.folder},filesep, {praatFiles.name});
% 
% % we also need the praat files in the folder of the compiled exe, so we
% % delete the folder of it already exists to make sure that only the newest
% % files are there
% if isfolder('VocaliscopestandaloneApplication\+usePraatViaMatlab')
%     rmdir('VocaliscopestandaloneApplication\+usePraatViaMatlab','s');
% end
% 
% for nr=1:numel(praatFiles)
% 
%     [~,name,ext]=fileparts(praatFiles{nr});
% 
%     containingFolder=extractBetween(praatFiles{nr},[filesep '+'],[name ext]); containingFolder=containingFolder{1}; containingFolder=['+' containingFolder];
% 
%     if ~isfolder([compiledPath containingFolder])
%         mkdir([compiledPath containingFolder]);
%     end
%     copyfile(praatFiles{nr},[compiledPath containingFolder name ext]);
% 
%     % also copy praat files in the direction of the vocaliscope exe since
%     % we need to have the praat files there
%     if ~isfolder([erase(compiledPath,'\forCompiling') containingFolder])
%         mkdir([erase(compiledPath,'\forCompiling') containingFolder]);
%     end
%     copyfile(praatFiles{nr},[erase(compiledPath,'\forCompiling') containingFolder name ext]);
% 
% end

% not needed anymore since we do not need the praat scripts anymore
% % create a zip which contains the exe and the praat files folder
% appExe=dir('VocaliscopestandaloneApplication/Vocaliscope*.exe');
% appExe=fullfile(appExe.folder, appExe.name);
% zipFileName = strrep(appExe,'.exe','.zip');
% if isfile(zipFileName)
%     delete(zipFileName);
% end
% zip(zipFileName, {appExe, 'VocaliscopestandaloneApplication\+usePraatViaMatlab' 'ReleaseNotes.md'});




% also copy this script
copyfile(currentScriptName,[compiledPath currentScriptName]);



disp('copy finished')

end


