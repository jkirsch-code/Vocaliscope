function compileMSAreplacement(version)

if nargin==0
    version='1.2';
end

if isnumeric(version)
    version=num2str(version,'%3.1f');
end

compiler.build.standaloneApplication('MSAreplacement.mlapp','ExecutableVersion',version)

disp('compiling finished');
end