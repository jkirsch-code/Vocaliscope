function y = filtfilt(b,a,x)
% FILTFILT Zero-phase forward and reverse digital filtering.
%    Y = FILTFILT(B, A, X) filters the data in vector X with the
%    filter described by vectors A and B to create the filtered data
%    Y.
%    
%    After filtering in the forward direction, the filtered sequence
%    is then reversed and run back through the filter; Y is the time
%    reverse of the output of the second filtering operation. The
%    result has precisely zero phase distortion and magnitude modified
%    by the square of the filter's magnitude response. Care is taken
%    to minimize startup and ending transients by matching initial
%    conditions.

% $Id: filtfilt.m 3 2004-02-04 12:57:04Z mairas $

y_ = filtfilt(b,a,x.s);
t = x.time;

y = signal(y_,t);

% set region of validity

y.valid = x.valid;

l = limpz(b,a,0.999,1024);
y.valid(1) = x.valid(1)+l;
if length(y.valid)==1
  y.valid(2) = len(y)-l;
else
  y.valid(2) = x.valid(2)-l;
end
