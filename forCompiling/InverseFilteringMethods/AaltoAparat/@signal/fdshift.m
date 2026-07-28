function fds = fdshift(s,fdratio,method)
% function fds = fdtimeshift(s,fdratio,method)
% Fractional delay time shift - shift a signal in sub-sample-step steps
% using fractional delay filtering. In this method, the signal is assumed
% to be band-limited, whereby ideal impulses are converted to
% sinc-functions that are continuous and can thus be shifted in time.
%
% s - input signal
% fds - time shifted signal
% fdratio - fractional delay amount 0...1 of subsample shifting
% method - approximation method:
%           * 'default' - not yet available
%           * 'ideal' - in theory, an infinitely long sinc function, but in
%                practice requires that input signal is windowed such that
%                it starts and ends from zero. Computationally, this method
%                is very expensive for long signals (e.g. > 1000 samples).
%

% 3.10.2005 Tom Bäckström, written for the Matsig package, LGPL licence

if strcmp(method, 'ideal') == 0
    error('No other methods than ''ideal'' are supported as of yet.');
end
fs = s.time.fs;

len = length(s.s);
fd = sinc((-len:len) + fdratio);

fds0 = filter(fd,1,[s.s(:);zeros(len*2,1)]);
fds = signal(fds0(len+(1:len)),fs);

xt=s.time;
xt=set(xt,'begin',xt.begin+fdratio/fs);
%xt=set(xt,'end',xt.end+fdratio/fs);
fds=set(fds,'time',xt);
