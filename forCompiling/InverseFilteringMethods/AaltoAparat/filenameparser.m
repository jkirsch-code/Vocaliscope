function fields = filenameparser(fn)
%
% FILENAMEPARSER Split filenames into pieces.
% A default filename parsing function, which splits the filenames into
% smaller sections along the characters '.-_'.

% $Id$

names = {};
for i=100:-1:1
  names{i}=['fn' num2str(i)];
end

d=dir('fieldnames.txt');
if length(d)==1
  fh = fopen('fieldnames.txt');
  fld = textscan(fh,'%s');
  names = fld{1};
end

names{end+1}='mat';

fields = split(fn,names);
names = fieldnames(fields);

% delete the 'mat' entry
fields=rmfield(fields,names(end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = split(s,names)

c = struct;

remain = s;
i=1;
while true
  [str, remain] = strtok(remain, '.-_');
  if isempty(str),  break;  end
  c.(names{i}) = str;
  i=i+1;
end
