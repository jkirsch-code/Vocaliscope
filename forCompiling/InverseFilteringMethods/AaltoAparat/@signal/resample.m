function y = resample(x,fs)
% Y = RESAMPLE(X,FS)  Change the sampling rate of a signal.
%
% This differs from the original resample in that only one
% argument, which is the new sampling rate of a signal, is given.

% $Id: resample.m 103 2006-02-07 10:24:32Z bassus $

oldfs = x.time.fs;
if fs<1
  oldfs = oldfs/fs;
  fs=1;
end

y_ = resample(x.s,fs,oldfs);
y = signal(y_,time(x.time.begin,length(y_),fs));
