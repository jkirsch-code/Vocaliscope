function [filelist] = getwavfiles(directory)

%%% KIRSCH
filelist=struct('name','wavFileForApparat.wav','saved',0);
return
%%%

l = dir(fullfile(directory,'*.wav'));
wavfiles = {l.name};
wavbase = wavfiles;
for i=1:length(wavfiles)
  [path,name,ext] = fileparts(wavfiles{i});
  wavbase{i} = name;
end
s = dir(fullfile(directory,'*.mat'));
matfiles = {s.name};
matbase = matfiles;
for i=1:length(s)
  [path,name,ext] = fileparts(matfiles{i});
  matbase{i} = name;
end

filelist = struct('name','','saved',0);
for i=1:length(wavfiles)
  filelist(i).name = l(i).name;
  filelist(i).saved = any(strcmp(wavbase{i},matbase));
end
