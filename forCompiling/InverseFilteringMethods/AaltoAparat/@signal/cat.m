function y = cat(varargin)
% CAT  Concatenate vectors and signal objects
%
%    Y=CAT(...) concatenates all arguments into a one signal. The
%    arguments may be either signal objects or regular vectors.

% $Id: cat.m 53 2005-01-05 11:17:56Z mairas $

y_ = [];

fs = [];
t = [];
I_t = [];
isset = false;

for i=1:length(varargin)
  cur = varargin{i};
  if isa(cur,'signal') & ~isset
    fs = cur.time.fs;
    t = cur.time.t(1);
    I_t = length(y_)+1;
    isset = true;
    y_ = [y_ cur.s];
  elseif isa(cur,'signal') & fs ~= cur.time.fs
    error('Mismatch in fs!');
  elseif isa(cur,'signal')
    y_ = [y_ cur.s];
  else
    y_ = [y_ cur];
  end
end

y = signal(y_,time(struct('begin',t-(I_t-1)/fs,'num',length(y_),'fs',fs)));
