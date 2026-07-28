function data = aggregate(varargin)
% AGGREGATE Read and combine TKK Aparat save files to tabular format.
%
% AGGREGATE() Read all .mat files in the current directory and 
%             return the data in a cell array.
% AGGREGATE(FILENAME)
%             Save the contents of .mat files to FILENAME in a tabular
%             format.
% AGGREGATE(FILENAME,['parsefunc',@parsefunc][,'grpfunc',@grpfunc],
%                    ['longnames',1|0])
%             As above, but parse the filenames to separate fields using
%             @parsefunc and group the results using @grpfunc (mean, median,
%             etc.)

% $Id: aggregate.m 209 2008-01-25 14:59:57Z mairas $

% parse input

%parsefunc = @(x) struct('Filename',x);
parsefunc = @filenameparser;
grpfunc = @median;
filename = '';
longnames = 0;

if nargin>0
  fileoutput=true;
  filename = varargin{1};
  varargin = {varargin{2:end}};
else
  fileoutput=false;
end

while length(varargin)>1
  [key,val] = varargin{1:2};
  varargin = {varargin{3:end}};
  eval([key '=val;']); % ugly
end

if fileoutput
  fid = fopen(filename,'w');
end

% loop through all mat files

files = dir('*.mat');
for j=1:length(files)
  disp(['Current file: ' files(j).name]);
  
  names = {'Filename'};
  fields = {files(j).name};
  
  ff = fullfile('.',files(j).name);
  this=load(ff);
  origfile = [ff(1:end-3) 'wav'];
  filefields = parsefunc(files(j).name);
  
  filefieldnames = fieldnames(filefields);
  for i = 1:length(filefieldnames)
    n = filefieldnames{i};
    names = {names{:} n};
    fields = {fields{:} filefields.(n)};
  end

  names = {names{:} 'f0'};
  fields = {fields{:} this.f0};
  
  names = {names{:} 'fs'};
  fields = {fields{:} this.fs};
  
  names = {names{:} 'iferror'};
  fields = {fields{:} this.iferror};
  
  names = {names{:} 'ifmethod'};
  fields = {fields{:} this.ifmethod};
  
  ifoptfields = fieldnames(this.ifopts);
  for i = 1:length(ifoptfields)
    n = ifoptfields{i};
    if ~isnumeric(this.ifopts.(n)) | length(this.ifopts.(n))==1
      if longnames
        names = {names{:} ['ifopts_' n]};
      else
        names = {names{:} n};
      end
      fields = {fields{:} this.ifopts.(n)};
    end
  end
  
  names = {names{:} 'ifquality'};
  fields = {fields{:} this.ifquality};
  
  names = {names{:} 'ifwinsize'};
  fields = {fields{:} this.ifwinsize};
  
  paramstfields = fieldnames(this.params.t);
  for i = 1:length(paramstfields)
    n = paramstfields{i};
    if ~strcmp('t_',n(1:2))
      val = grpfunc([this.params.t.(n)]);
      if longnames
        names = {names{:} ['params_t_' n]};
      else
        names = {names{:} n};
      end
      fields = {fields{:} val};
    end
  end

  paramsffields = fieldnames(this.params.f);
  for i = 1:length(paramsffields)
    n = paramsffields{i};
    val = grpfunc([this.params.f.(n)]);
    if longnames
      names = {names{:} ['params_f_' n]};
    else
      names = {names{:} n};
    end
    fields = {fields{:} val};
  end

  paramslffields = fieldnames(this.params.lf);
  for i = 1:length(paramslffields)
    n = paramslffields{i};
    val = grpfunc([this.params.lf.(n)]);
    if longnames
      names = {names{:} ['params_lf_' n]};
    else
      names = {names{:} n};
    end
    fields = {fields{:} val};
  end

  cur = struct;
  
  if j==1
    orignames = names;
    for i=1:length(names)
      n = names{i};
      if fileoutput
        fprintf(fid,'%s ',n);
      end
    end
    if fileoutput
      fprintf(fid,'\n');
    end
  else
    if length(names) ~= length(orignames) || ...
      ~all(strcmp(names,orignames))
      error(['Field names differ from previous files in file ' files(j).name]);
    end
  end

  for i=1:length(fields)
    v = fields{i};
    cur.(names{i}) = v;
    if fileoutput
      if isstr(v)
        fprintf(fid,'%s ',v);
      elseif mod(v,1)==0
        fprintf(fid,'%d ',v);
      else
        fprintf(fid,'%.15f ',v);
      end
    end
  end
  if fileoutput
    fprintf(fid,'\n');
  end
  res(j)=cur;
end
if fileoutput
  fclose(fid);
end

if nargout>0
  data = res;
end