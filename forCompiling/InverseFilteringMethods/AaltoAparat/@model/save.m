function save(m,tag)
% function save(m,tag)
% m is the @model object and tag optional file tag "filename.tag.mat"

% $Id: save.m 175 2006-11-27 10:44:57Z mairas $

if nargin < 2
    tag = [];
end

% data to save:
filename = fullfile(m.directory, m.filelist(m.curfile).name);
%curchannel = m.curchannel;
%cut_sppres = m.cut_sppres;
%glottal_flow = m.glottal_flow;
%cut_glotflow = m.cut_glotflow;
%cut_glotpres = m.cut_glotpres;
%naq = m.naq;
%hpfreq = m.hpfreq;
%fs = m.fs;
%ifwinsize = m.ifwinsize;
%ifopts = m.ifopts;
%flipped = m.flipped;
%ifquality = m.ifquality;
%notes = m.notes;
%hvt = m.hvt;
%hg = m.hg;
%iferror = m.iferror;

% file to save in
[pathstr,name,ext] = fileparts(filename);
savefilename = fullfile(pathstr, [name tag '.mat']);

sm = struct(m);
save(savefilename,'-struct','sm');

%save(savefilename, ...
%     'curchannel', 'cut_sppres','glottal_flow','cut_glotflow', ...
%     'cut_glotpres','naq','hpfreq','f0','ifwinsize', ...
%     'ifopts','flipped','filename', ...
%     'ifquality','notes','hvt2','hg2','iferror');

% set(m,'curfile',m.curfile+1); didn't work -- why?
m.filelist = getwavfiles(m.directory);
store(m);
notify(m,'filelist');
%notify(m,'curfile');