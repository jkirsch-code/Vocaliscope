function a = parametrise(a)

if isa(a.glottal_flow,'signal') && isfield(a.glottal_selection,'left') && ...
      isfield(a.glottal_selection,'right') && len(a.glottal_flow) >= 2
  a.cut_glotflow = trim(a.glottal_flow,a.glottal_selection.left,a.glottal_selection.right);
  a.cut_glotpres = deriv(a.cut_glotflow);
  f0 = find_f0(a.cut_glotflow);
  if f0>0
    a.params.t = glottaltimeparams(a.cut_glotflow,f0);
    a.params.f = glottalfreqparams(a.cut_glotflow,f0);
    a.params.lf = struct;
  else
    a.params = struct;
  end
else
  a.params = struct;
end
store(a);
