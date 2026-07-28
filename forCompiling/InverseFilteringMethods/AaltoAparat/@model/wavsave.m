function wavsave(m)
%WAVSAVE Saves selected wav-files
%   Saves both sound pressure and glottal flow

% m = deref(handles.model);
% fname = get(m,'curfilename');
% [pathstr,name,ext] = fileparts(fname);

fname = get(m,'curfilename');
[pathstr,name,ext] = fileparts(fname);

s = m.cut_sppres;
s1 = s.s/(1.01*max(max(abs(s.s))));

t = m.cut_glotflow;
t1 = t.s/(1.01*max(max(abs(t.s))));

if ~exist('exportWavs/')
    mkdir('exportWavs/');
end

audiowrite(strcat('exportWavs/',name,'Pressure.wav'),s1,s.time.fs);
audiowrite(strcat('exportWavs/',name,'Flow.wav'),t1,t.time.fs);

msgbox(['The "' name 'Pressure.wav" and "' name 'Flow.wav" files have been created and saved to a folder "exportWavs".'],'File saved');

m.filelist = getwavfiles(m.directory);
store(m);
notify(m,'filelist');
%notify(m,'curfile');

end

