function val = get(c,prop)

if nargin < 2
    % display members
    disp('Member names:');
    names = fieldnames(c);
    for k = 1:length(names)
        disp(['   ' names{k}])
    end
end

switch prop
 case 'this'
  val = c.this;
 case 'orig_sppres'
  val = c.orig_sppres;
 case 'speech_pressure'
  val = c.speech_pressure;
 case 'cut_sppres'
  val = c.cut_sppres;
 case 'glottal_flow'
  val = c.glottal_flow;
 case 'glottal_pressure'
  val = c.glottal_pressure;
 case 'cut_glotpres'
  val = c.cut_glotpres;
 case 'cut_glotflow'
  val = c.cut_glotflow;
 case 'params'
  val = c.params;
 case 'param_grouping_func'
  val = c.param_grouping_func;
 case 'shown_params'
  val = c.shown_params;
 case 'iferror'
  val = c.iferror;
 case 'sppres_selection'
  val = c.sppres_selection;
 case 'glottal_selection'
  val = c.glottal_selection;
 case 'ifopts'
  val = c.ifopts;
 case 'ifwinsize'
  val = c.ifwinsize;
 case 'ifmethod'
  val = c.ifmethod;
 case 'hpfreq'
  val = c.hpfreq;
 case 'prefilter'
  val = c.prefilter;
 case 'directory'
  val = c.directory;
 case 'filelist'
  val = c.filelist;
 case 'curfile'
  val = c.curfile;
 case 'curfilename'
  val = c.filelist(c.curfile).name;
 case 'ifquality'
  val = c.ifquality;
 case 'curchannel'
  val = c.curchannel;
 case 'flipped'
  val = c.flipped;
 case 'autohpfreq'
  val = c.autohpfreq;
 case 'notes'
  val = c.notes;
 case 'f0'
  val = c.f0;
 case 'hvt'
  val = c.hvt;
 case 'hg'
  val = c.hg;
 case 'fs'
  val = c.fs;
 case 'orig_fs'
  val = c.orig_fs;
 case 'eggdelay'
  val = c.eggdelay;
 case 'egg'
  val = c.egg;
 case 'orig_egg'
  val = c.orig_egg;
 case 'cut_egg'
  val = c.cut_egg;
 case 'egginother'
  val = c.egginother;
 otherwise
  error(['"' prop '" is not a valid property name']);
end
