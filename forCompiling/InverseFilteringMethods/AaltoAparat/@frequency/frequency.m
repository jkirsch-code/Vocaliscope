function f=frequency(varargin)

% should accept at least the following input
% begin num fs
% vector
%
% initially supports "dense" equidistant frequency vectors only

% $Id: frequency.m 119 2006-09-26 12:28:25Z mairas $

f.vec=[];
f.begin=0;
f.num=0;
f.fs=0;

if nargin==1
  if isnumeric(varargin{1})
    % frequency is a vector
    %vec = reshape(varargin{1},1,prod(size(varargin{1})));
    vec = varargin{1};
    f.begin = vec(1);
    f.num = length(vec);
    f.fs = (vec(2)-vec(1))*f.num;
  end
else
  f.begin = varargin{1};
  f.num = varargin{2};
  f.fs = varargin{3};
end

f = class(f,'frequency');
