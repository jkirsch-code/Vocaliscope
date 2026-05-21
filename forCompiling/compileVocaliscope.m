function compileVocaliscope(version)

if nargin<1 || isempty(version)
    version=getVersionFromMlapp('Vocaliscope.mlapp');
elseif isnumeric(version)
    version=num2str(version,'%3.1f');
end

save('currentAppVersion.mat',"version");

if isfolder('VocaliscopestandaloneApplication')
    delete('VocaliscopestandaloneApplication\*.exe');
end

splashName='mySplash.png';
iconName='myIcon.png';
compileObj=compiler.build.standaloneApplication('Vocaliscope.mlapp',...
    'ExecutableVersion',version,...
    'ExecutableSplashScreen',splashName,...
    'ExecutableIcon',iconName,...
    'AdditionalFiles',{'+FCWT\fCWT.mexw64','+FCWT\fCWT.dll','+FCWT\fftw3f.dll',},...
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



totalList=[fListApp fListAdditional fListCompilation LicenseFiles ReadmeFiles {splashName iconName}];

totalList=unique(totalList);

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

% also copy this script
copyfile(currentScriptName,[compiledPath currentScriptName]);

disp('copy finished')

end


