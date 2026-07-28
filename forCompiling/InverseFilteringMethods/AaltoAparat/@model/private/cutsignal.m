function a = cutsignal(a)

if isfield(a.sppres_selection,'left') && ...
      isfield(a.sppres_selection,'right') && ... 
      a.sppres_selection.left~=a.sppres_selection.right && ...
      a.sppres_selection.left<a.speech_pressure.time.end
  a.cut_sppres = trim(a.speech_pressure,a.sppres_selection.left, ...
                      a.sppres_selection.right);
  if length(a.egg) > 0 && isobject(a)
      a.cut_egg = trim(a.egg, a.sppres_selection.left, a.sppres_selection.right);
  end
  a.glottal_selection.left=a.cut_sppres.time.begin;
  a.glottal_selection.right=a.cut_sppres.time.end;
else
  a.cut_sppres=[];
  a.glottal_selection = struct;
end
store(a);
