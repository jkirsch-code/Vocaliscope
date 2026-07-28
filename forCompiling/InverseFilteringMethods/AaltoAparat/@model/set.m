function a = set(a,varargin)

while length(varargin) >= 2
  prop = varargin{1};
  val = varargin{2};
  varargin = varargin(3:end);
  switch prop
    case 'speech_pressure'
      if ~iscell(val)
        a.orig_sppres = {val};
      else
        a.orig_sppres = val;
      end
      a.notes = '';
      a = updateSignal(a);
    case 'sppres_selection'
      a.sppres_selection = val;
      a = updateSel(a);
      notify(a,'sppres_selection');
    case 'glottal_selection'
      a.glottal_selection = val;
      store(a);
      a = parametrise(a);
      notify(a,'params');
      notify(a,'lffit');
      notify(a,'glottal_selection');
   case 'ifopts'
     % perform some sanity checks for the input values
     if val.p<4
       val.p = 4;
       msgbox('Number of formants must be between 2 ... 30','Out of bounds', ...
         'warn');
     elseif val.p>60
       val.p = 60;
       msgbox('Number of formants must be between 2 ... 30','Out of bounds', ...
         'warn');
     end
%      if val.r<4
%        val.r = 4;
%        msgbox('R value must be between 4 ... 60','Out of bounds', ...
%          'warn');
%      elseif val.r>60
%        val.r = 60;
%        msgbox('R value must be between 4 ... 60','Out of bounds', ...
%          'warn');
%      end
     if val.rho<0.9
       val.rho = 0.9;
       msgbox('Integration coefficient must be between 0.9 ... 1','Out of bounds', ...
         'warn');
     elseif val.rho>1
       val.rho = 1;
       msgbox('Integration coefficient must be between 0.9 ... 1','Out of bounds', ...
         'warn');
     end
     if val.dq<0.1
       val.dq = 0.1;
       msgbox('DQ value must be between 0.1 ... 1','Out of bounds', ...
         'warn');
     elseif val.dq>1
       val.dq = 1;
       msgbox('DQ value must be between 0.1 ... 1','Out of bounds', ...
         'warn');
     end
     if val.pq<0
       val.pq = 0;
       msgbox('PQ value must be between 0 ... 0.15','Out of bounds', ...
         'warn');
     elseif val.pq>0.15
       val.pq = 0.15;
       msgbox('PQ value must be between 0 ... 0.15','Out of bounds', ...
         'warn');
     end
     if val.nramp<1
       val.nramp = 1;
       msgbox('Nramp value must be between 1 ... 20','Out of bounds', ...
         'warn');
     elseif val.nramp>20
       val.nramp = 20;
       msgbox('Nramp value must be between 1 ... 20','Out of bounds', ...
         'warn');
     end
     if val.g<2
       val.g = 2;
       msgbox('G value must be between 2 ... 8','Out of bounds', ...
         'warn');
     elseif val.g>8
       val.g = 8;
       msgbox('G value must be between 2 ... 8','Out of bounds', ...
         'warn');
     end
      a.ifopts = val;
      a = ifsignal(a);
      a = parametrise(a);
      notify(a,'ifopts')
      notify(a,'params');
      notify(a,'lffit');
      notify(a,'glottal_flow');
      notify(a,'glottal_pressure');
      notify(a,'glottal_selection');
    case 'ifmethod'
      a.ifmethod = val;
      a = ifsignal(a);
      a = parametrise(a);
      notify(a,'params');
      notify(a,'lffit');
      notify(a,'glottal_flow');
      notify(a,'glottal_pressure');
      notify(a,'glottal_selection');
    case 'ifwinsize'
      a.ifwinsize = val;
      if isfield(a.sppres_selection,'left') && ...
            isfield(a.sppres_selection,'right')
        a.sppres_selection.right = a.sppres_selection.left+val;
%         mid = (a.sppres_selection.right+a.sppres_selection.left)/2;
%         a.sppres_selection.left = mid-val/2;
%         a.sppres_selection.right = mid+val;
      end
      a = updateSel(a);
    case 'ifwinplace'
      if isfield(a.sppres_selection,'left') && ...
            isfield(a.sppres_selection,'right')
        diff = a.sppres_selection.left-val;
        a.sppres_selection.left = val;
        a.sppres_selection.right = a.sppres_selection.right-diff;
%         mid = (a.sppres_selection.right+a.sppres_selection.left)/2;
%         a.sppres_selection.left = mid-val/2;
%         a.sppres_selection.right = mid+val;
      end
      a = updateSel(a);
    case 'hpfreq'
      a.hpfreq = val;
      a = updateSignal(a);
      notify(a,'hpfreq');
    case 'prefilter'
      a.prefilter = val;
      a = updateSignal(a);
      notify(a,'prefilter');
    case 'directory'
      a.directory = val;
      a.filelist = getwavfiles(a.directory);
      a.curfile = [];
      store(a);
      notify(a,'directory');
      notify(a,'filelist');
      notify(a,'curfile');
    case 'filelist'
      a.filelist = val;
      a.curfile = [];
      store(a);
      notify(a,'filelist');
      notify(a,'curfile');
    case 'curfile'
      a.curfile = val;
      a.notes = '';

      a = openfile(a);
      a = updateSignal(a);
      store(a);
      notify(a,'curfile');
      notify(a,'notes');
      notify(a,'ifquality');
      notify(a,'ifopts');
      notify(a,'hpfreq');
      notify(a,'prefilter');
      %a = updateSel(a);
    case 'ifquality'
      if val >= 5
          val = 5;
      elseif val <= 0;
          val = 0;
      end;
      a.ifquality = val;
      store(a);
      notify(a,'ifquality');
    case 'notes'
      a.notes = val;
      store(a);
      notify(a,'notes');
    case 'curchannel'
      a.curchannel = val;
      a = updateSignal(a);
      notify(a,'curchannel');
    case 'flipped'
      a.flipped = val;
      a = updateSignal(a);
      notify(a,'flipped');
    case 'param_grouping_func'
      a.param_grouping_func = val;
      store(a);
      notify(a,'param_grouping_func');
    case 'shown_params'
      a.shown_params = val;
      store(a);
      notify(a,'params');
      notify(a,'lffit');
      notify(a,'glottal_selection');
    case 'autohpfreq'
      a.autohpfreq = val;
      store(a);
      if a.autohpfreq
        updateSel(a);
      end
      notify(a,'autohpfreq');
    case 'automodel'
      if isa(a.cut_sppres,'signal') && (~isempty(a.cut_sppres.s))
        a.ifopts.automodel = true;
      else
        a.ifopts.automodel = false;
      end
      store(a);
      a = updateSel(a);
      store(a);
      notify(a,'automodel');
      notify(a,'ifopts');
    case 'fs'
      a.fs = val;
      a = updateSignal(a);
    case 'egginother'
      a.egginother = val;
      a = updateSignal(a);
      store(a);
    case 'egg'
      a.egg = val;
      a = updateSignal(a);
      store(a);
    case 'cut_egg'
      a.cut_egg = val;
      a = updateSignal(a);
      store(a);
    case 'orig_egg'
      a.orig_egg = val;
      store(a);
    case 'eggdelay'
      a.eggdelay = val;
      a = updateSignal(a);
      store(a);
    otherwise
      error(['"' prop '" is not a valid property name']);
  end
end

function a = updateSignal(a)
a = refilter(a);
notify(a,'speech_pressure');
notify(a,'orig_fs');
a = updateSel(a);

function a = updateSel(a)
refiltered = 0;
%a = resetSel(a);

% if no selection exists, pick a 50 ms window in the middle of the file
if ~isfield(a.sppres_selection,'left') || ...
      ~isfield(a.sppres_selection,'right')
  mid = (a.speech_pressure.time.end+a.speech_pressure.time.begin)/2;
  a.sppres_selection.left = mid-0.025;
  a.sppres_selection.right = mid+0.025;
end

a = cutsignal(a);
if isa(a.cut_sppres,'signal');
  a.f0 = find_f0(a.cut_sppres);
  if a.autohpfreq && (abs(a.hpfreq-0.92*a.f0)/a.hpfreq > 0.01)
    a.hpfreq = round(0.92*a.f0);
    a = refilter(a);
    refiltered = 1;
    a = cutsignal(a);
  end
else
  a.f0 = 0;
end
a = ifsignal(a);
a = parametrise(a);
store(a);
if refiltered
  notify(a,'speech_pressure');
  notify(a,'hpfreq');
end
notify(a,'cut_sppres');
notify(a,'glottal_flow');
notify(a,'glottal_pressure');
notify(a,'sppres_selection');
notify(a,'params');
notify(a,'lffit');
notify(a,'glottal_selection');
notify(a,'f0');

