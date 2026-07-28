function t = time(varargin)
% TIME Construct a time object
% should accept at least following input
% beg end fs
% beg end num
% beg num fs
% beg num step
% vec


% $Id: time.m 49 2004-09-21 07:48:16Z mairas $

t.vec=[];
t.beg=0;
t.num=0;
t.fs=0;
if nargin==1
  if isnumeric(varargin{1})
    % time is a vector, assume uniform sampling
    vec = reshape(varargin{1},1,[]);
    t.beg = vec(1);
    t.num = length(vec);
    t.fs = 1/(vec(2)-vec(1));
  elseif isstruct(varargin{1})
    % time is a struct
    s = varargin{1};
    if isfield(s,'beg')
      t.beg = s.beg;
    else
      t.beg = s.begin;
    end
    if isfield(s,'num') & isfield(s,'fs')
      t.num = s.num;
      t.fs = s.fs;
    elseif isfield(s,'num') & isfield(s,'tstep')
      t.num = s.num;
      t.fs = 1/s.tstep;
    end
  end
else
  t.beg = varargin{1};
  t.num = varargin{2};
  t.fs = varargin{3};
end


t = class(t,'time');
