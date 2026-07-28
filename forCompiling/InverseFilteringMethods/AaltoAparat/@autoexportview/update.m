function update(c,event)

%disp(['autoexportview/update ' num2str(c.this) ' ' event]);

switch event
 case 'init'
 case {'speech_pressure','cut_sppres','glottal_flow', ...
       'cut_glotpres','params','lffit'}
  assignin('base','aprt',struct(deref(c.model)));
 otherwise
end
