function update(c,event)
% spectrumview update

%disp(['spectrumview/update ' num2str(c.this) ' ' event]);

switch event
  case {'glottal_flow'}
    plotspectra(c);
  case 'destroy'
    try
      delete(c.hObject);
    catch
    end
  otherwise
end
