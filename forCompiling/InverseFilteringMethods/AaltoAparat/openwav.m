function [Y]=openwav(varargin)

% get the file name and path using the file dialog


persistent lastpath;

if ~nargin

  prevpath = pwd;

  if lastpath
    cd(lastpath);
  end

  [FileName,PathName]=uigetfile('*.wav','Open audio file');

  if PathName
    lastpath = PathName;
  end
  cd(prevpath);

  if FileName==0
    Y=0;
    return
  end
  fname=[PathName FileName];
else
  fname=varargin{1};
end

[y,fs] = audioread(fname);

if size(y,2)==1
  Y = signal(y,fs);
else
  for i=1:size(y,2)
    Y{i} = signal(y(:,i),fs);
  end
end


