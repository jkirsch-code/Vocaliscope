function m = model(orig_sppres,ifopts)

m.this = ref;

if ~iscell(orig_sppres)
  m.orig_sppres = {orig_sppres};
else
  m.orig_sppres = orig_sppres;
end
m.orig_fs = 0;
m.curchannel = 1;
m.speech_pressure = [];
m.cut_sppres = [];
m.glottal_flow = [];
m.glottal_pressure = [];
m.orig_egg = [];
m.egg = [];
m.cut_egg = [];
m.egginother = 0;
m.eggdelay = 0;
m.hvt = [];
m.hg = [];
m.iferror = [];
m.cut_glotflow = [];
m.cut_glotpres = [];
m.params = struct;
m.param_grouping_func = @mean;
m.shown_params = struct;
m.hpfreq = 60;
m.autohpfreq = 0;
m.prefilter = 1;
m.f0 = 0;
m.oldf0 = 0;
m.fs = 0;
m.ifwinsize = 0;
m.ifmethod = 'qcp';
m.sppres_selection = struct;
m.glottal_selection = struct;
m.ifopts = struct;
m.flipped = false;

m.directory = '';
m.filelist = [];
m.curfile = [];

m.ifquality = '';
m.notes = '';

m = class(m,'model',subject);

m = refilter(m);

defopts = struct('rho',0.99);
if isa(m.orig_sppres{1},'signal')
  defopts.p = get_if_order(m.orig_sppres{1}.fs);
else
  defopts.p = 10;
end
defopts.r = 10;
defopts.g = 2;
defopts.arfunc = 'dap';
defopts.automodel = false;
defopts.dq = 0.7;
defopts.pq = 0.1;
defopts.nramp = 7;
defopts.causality = 'causal';

m.ifopts = mergestruct(defopts,ifopts);

% store this object
store(m);
