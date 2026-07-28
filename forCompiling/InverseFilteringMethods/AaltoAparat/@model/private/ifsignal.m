function a = ifsignal(a,nonotify)

if isa(a.cut_sppres,'signal')
  a.ifopts.f0 = a.f0;
  if strcmp(a.ifmethod,'qcp') % QCP, former experimental
      [a.glottal_flow,a.hvt,a.iferror,a.hg] = ...
         qcp(a.cut_sppres,a.ifopts);
      a.glottal_pressure = deriv(a.glottal_flow);
      store(a);
  elseif strcmp(a.ifmethod,'iaif')% IAIF
      [a.glottal_flow,a.hvt,a.iferror,a.hg] = ...
        iaif(a.cut_sppres,a.ifopts);
      a.glottal_pressure = deriv(a.glottal_flow);
      store(a);
  end
else
  a.glottal_flow = []; a.hvt = []; a.iferror = []; a.hg = [];
  store(a);
end
