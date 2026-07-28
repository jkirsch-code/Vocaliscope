function y = signal(s,tdef)
% SIGNAL  Construct a signal object
%
%    Y=SIGNAL(S,FS)
%    Y=SIGNAL(S,T)
%    Y=SIGNAL(S,TIME)
%
%    Construct a signal object from signal vector S. Time may be
%    defined by sampling frequency (FS>1) or step size (T<1) or as
%    a time object TIME.

% assumptions:
% 
% if tdef<1,  tstep = tdef
% if tdef>=1, fs = tdef

% $Id: signal.m 53 2005-01-05 11:17:56Z mairas $

% introduce member variables

y.time = [];
y.s = [];
% Defining fs here is a mistake. However, it cannot be removed, as
% that would break all saved signal objects.
y.fs = []; 
y.valid = 0;

if nargin >= 1
    y.s = s(:)'; % make the signal always a row vector
    y.valid = 1;
else
    y.s = [];
    y.valid = 0;
    tdef = 0;
end

if isa(tdef,'time')
  if length(y.s)~=tdef.num
    error('Mismatch between lengths of signal and time.');
  end
  y.time = tdef;
  y.fs  = y.time.fs;
elseif length(tdef)>1
  y.time = time(tdef);
elseif (tdef<1) && (tdef~=0)
  y.time = time(struct('begin',0,'num',length(y.s),'tstep',tdef));
else % tdef >= 1
  y.time = time(struct('begin',0,'num',length(y.s),'fs',tdef));
end

y = class(y,'signal');
