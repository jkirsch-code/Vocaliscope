function [y,zf] = filter(b,a,X,varargin)
% FILTER One-dimensional digital filter.
%    Y = FILTER(B,A,X) filters the data in vector X with the
%    filter described by vectors A and B to create the filtered
%    data Y.
%
%    Y = FILTER(B,A,X,'noncausal') performs noncausal filtering,
%    i.e. the time information is shifted to match the mean group delay
%    of the filter.
%
%    Y = FILTER(B,A,X,'noncausal,'f0',F0) performs noncausal filtering,
%    adjusting the time delay to match the group delay at frequency F0.
%
%    Y = FILTER(B,A,X,'causal') performs causal filtering (default),
%
%    Y = FILTER(B,A,X,'backwards') performs filtering on the time reversed
%    signal, i.e. it flips the signal backwards before filtering and flips
%    the filtered signal to obtain original time orientation

% $Id: filter.m 127 2007-11-07 14:22:23Z mairas $

causal = 1;
backw = 0;
f0 = [];
while length(varargin)
    if (strcmp(varargin{1},'noncausal') ... %noncausal
            || strcmp(varargin{1},'nc'))
        causal=0;
        varargin=varargin(2:end);
    elseif strcmp(varargin{1},'f0')
        f0 = varargin{2};
        varargin=varargin(3:end);
    elseif (strcmp(varargin{1},'causal')) %causal
        causal=1;
        varargin=varargin(2:end);
    elseif strcmp(varargin{1},'backwards')
        % reverse time
        backw = 1;
        X.s = flipud(X.s(:));
        varargin=varargin(2:end);
    end
end

[y_,zf] = filter(b,a,X.s,varargin{1:end});

% set time vector

tobj = X.time;
if causal
  t = tobj;
else
  if isempty(f0)
    grpdel_ = grpdelay(b,a);
    grpdel  = grpdel_(abs(grpdel_)~=Inf);
    t = tobj-mean(grpdel)/tobj.fs;
  else
    gd_f0 = grpdelay(b,a,[0 f0],X.time.fs);
    t = tobj-gd_f0(2)/tobj.fs;
  end
end
y = signal(y_,t);

% set region of validity

y.valid = X.valid;
y.valid(1) = X.valid(1)+limpz(b,a);

% turn back time
if backw
    y.s = flipud(y.s(:))';
end
