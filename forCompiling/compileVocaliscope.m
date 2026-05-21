function compileVocaliscope(version)

if nargin<1 || isempty(version)
    version=getVersionFromMlapp('Vocaliscope.mlapp');
elseif isnumeric(version)
    version=num2str(version,'%3.1f');
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
    'AdditionalFiles',{'fCWT.mexw64','fCWT.dll','fftw3f.dll'});

disp('compiling finished');

disp(compileObj)
disp(compileObj.Files)
disp(compileObj.RuntimeDependencies)

disp('copying dependencies...');

if isfile('VocaliscopestandaloneApplication\Vocaliscope.exe')
    movefile('VocaliscopestandaloneApplication\Vocaliscope.exe',['VocaliscopestandaloneApplication\Vocaliscope_V' strrep(version,'.','_') '.exe']);
end


compiledPath='VocaliscopestandaloneApplication\forCompiling\';

if ~isfolder(compiledPath)
    mkdir(compiledPath);
end

[fListApp] = matlab.codetools.requiredFilesAndProducts('Vocaliscope.mlapp');

fListAdditional=compileObj.Options.AdditionalFiles';

currentScriptName=[mfilename '.m'];
[fListCompilation] = matlab.codetools.requiredFilesAndProducts(currentScriptName);

totalList=[fListApp fListAdditional fListCompilation {splashName iconName}];

for nr=1:numel(totalList)
    
    [~,name,ext]=fileparts(totalList{nr});
    copyfile(totalList{nr},[compiledPath name ext]);
end

% also copy this script

copyfile(currentScriptName,[compiledPath currentScriptName]);

disp('copy finished')

end


