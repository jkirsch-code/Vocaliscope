function [cycper, kurt, mean_circ] = iaif_quality(flow, f0, dflow, cutoff)
% function [cycles, kurt] = iaif_quality(flow, f0, dflow, cutoff)
%   Calculate objective quality measures for inverse filtered signal
%   'flow' and the optional flow derivative signal 'dflow'. Use the
%   optional fundamental frequency 'f0'. Signals flow and dflow are assumed
%   to be of class signal. Signals are low-pass filtered with the optional
%   corner frequency 'cutoff'.
%   - 'cycles' is the estimated number of cycles per fundamental period in
%   phase plane. Values of approx > 2 indicate existence of higher order
%   residuals.
%   - 'kurt' is the kurtosis estimate (biased). Low values indicate good
%   inverse filtering result. The minimum value is 0 and a gaussian
%   distribution has the value 3.
%   


% check input
if nargin < 2
    % no F0 given, use estimate
    f0 = find_f0(flow);
end
if nargin < 3
    % no dflow give, use estimate
    dflow = filter([1 -1],1,flow);
end
if nargin < 4
    % no cutoff frequency given, use default constant
    cutoff = 3500;
end


% generate averaging filter
flowfilt = fir1(20,cutoff/flow.fs);
startskip = length(flowfilt)+1;

% filter flow and dflow
len = min(length(flow.s), length(dflow.s));
dflow = filter([1 -1],1,flow);
dflows = filter(flowfilt,1,dflow);
flows = filter(flowfilt,1,flow);

% normalise signals
flows = flows.s;
dflows = dflows.s;
flows = flows/(max(flows)-min(flows));
dflows = dflows/(max(dflows)-min(dflows));



% calculate number of cycles vs. f0
dx =  flows(startskip+1:len) - flows(startskip:len-1);
dy =  dflows(startskip+1:len) - dflows(startskip:len-1);
% remove possible overlaping points to avoid divide-by-zero
ix = find(dy == 0);
len = len - length(ix);
dx(ix) = [];
dy(ix) = [];
  
% phase in radians
ang(startskip:len-1) = atan(dx./dy);

% unwrap from [-pi,pi] to (-pi,+-infty)
for k = (startskip+1):len-1
    dang = abs(ang(k-1)-ang(k));
    if dang > abs(ang(k-1)-ang(k)+pi)
        ang(k:end) = ang(k:end)-pi;
    elseif dang > abs(ang(k-1)-ang(k)-pi)
        ang(k:end) = ang(k:end)+pi;
    end
end

% calculate ratio of cycles and periods
fs = flow.fs;
if f0~=0 % avoid divide by zero
    cycles = abs(ang(len-1)-ang(startskip))/(2*pi);
    f0samp = fs/f0;
    periods = len/f0samp;
end
cycper = cycles/periods;

% calculate mean length of subcycles
if cycper >= 1.3
    A = subcycle(flows(startskip+1:len-1), dflows(startskip+1:len-1), f0, fs);
    if length(A) > 0
        mean_circ = mean(A.^2)*cycper;
    else
        mean_circ = 0;
    end
else
    mean_circ = 0;
end

% calculate kurtosis
kurt = kurtosis(flow.s);
