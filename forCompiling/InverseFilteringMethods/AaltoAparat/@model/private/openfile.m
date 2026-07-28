function a=openfile(a)

% $Id: openfile.m 200 2007-09-10 12:32:40Z mairas $

wavpath = fullfile(a.directory, a.filelist(a.curfile).name);
matpath = wavpath; matpath(end-3:end)='.mat';

s=openwav(wavpath);

%%% added by KIRSCH to circumvent default behavior
matpath='';


if ~isempty(s)
  if ~iscell(s)
    s = {s};
  end
%  if s{1}.fs>22050
%    disp('Sample rate too high, resampling...');
%    for i=1:length(s)
%      s{i} = resample(s{i},22050);
%    end
%  end
  if (a.egginother) && (length(s)>1)
      a.orig_sppres = {s{1}};
      a.orig_egg = s{2};
      a.egg = shift(a.orig_egg,a.eggdelay/1000);
  else
      a.orig_sppres = s;
      a.orig_egg = [];
      a.egg = [];
      a.cut_egg = [];
  end

  if length(dir(matpath))>0
    l=load(matpath);
    % is this an old or a new saved file?
    if isfield(l,'cutsignal')
      a.sppres_selection.left=l.cutsignal.time.begin;
      a.sppres_selection.right=l.cutsignal.time.end;
      if isa(l.ifcutflow,'signal')
        a.glottal_selection.left=l.ifcutflow.time.begin;
        a.glottal_selection.right=l.ifcutflow.time.end;
      end
      a.ifopts = l.iaifopts;
      if isfield(l,'ifmethod')
        a.ifmethod = l.ifmethod;
      else
        a.ifmethod = 'qcp';
      end
      a.hpfreq = l.hpfreq;
      a.ifquality = l.ifquality;
      a.notes = l.notes;
      % old files used an internal sampling frequency of 22050 Hz
      if a.fs==0
        a.fs=22050;
      end
    else
      a.sppres_selection=l.sppres_selection;
      a.glottal_selection=l.glottal_selection;
      if isfield(l,'iaifopts')
        a.ifopts = l.iaifopts;
      else
        a.ifopts = l.ifopts;
      end
      a.hpfreq = l.hpfreq;
      a.ifquality = l.ifquality;
      a.notes = l.notes;
      a.fs=l.fs;
      a.ifmethod = l.ifmethod;
    end  
    if isfield(l,'prefilter')
      a.prefilter = l.prefilter;
    end
  end

  % clear derivatives of previous signal
  a.speech_pressure = signal([],s{1}.fs);
  a.cut_sppres = signal([],s{1}.fs);
  a.glottal_flow = signal([],s{1}.fs);
  a.cut_glotflow = signal([],s{1}.fs);
  a.cut_glotpres = signal([],s{1}.fs);

  % clean ifopts
%   if isfield(a.ifopts,'r') && a.ifopts.p==a.ifopts.r
%     a.ifopts = rmfield(a.ifopts,'r');
%   end
  
end
store(a);
