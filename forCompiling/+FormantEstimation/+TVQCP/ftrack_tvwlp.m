function [Fi,Ak,formantTimeVector] = ftrack_tvwlp(s,fs,lptype,nwin,nshift,p,q,npeaks,PREEMP,fint,freqBounds,PLOT_FLAG)

%%%%%%%%%%%%%%%%%%%%%%
% Usage: [Fi,Ak] = ftrack_tvwlp(s,fs,lptype,nwin,nshift,p,q,npeaks,PREEMP,fint,PLOT_FLAG)
%
%   Computes the continuous time-varying formant tracks at every sample
% shift. Uses the GLOAT gci detection tool kit (http://tcts.fpms.ac.be/~drugman/Toolbox/GLOAT.zip).
%
% INPUTS:
%   s       - speech signal (will be always converted to 8kHz)
%   fs      - sampling rate
%   lptype  - one of {'tvwlp_l2','tvwlp_l1','tvlp_l2','tvlp_l1'} [default 'tvwlp_l2']
%   nwin    - window or block size for TVLP analysis in samples (@ given fs)
%                [default 1600] @ 8kHz (200ms)
%   nshift  - window shift for TVLP [default 1600 or 200ms]
%   p       - LP or TVLP order [default 8]
%   q       - polynomial order [default 3]
%   npeaks  - number of formants to track [default 3]
%   PREEMP  - preemphasis factor [default 0.97]
%   fint    - formant interval in samples; 8000Hz/fint gives the output formant rate  [default 80] (10 ms)
%   PLOT_FLAG - plot flag [default 0]
%
% OUTPUTS:
%   Fi      - Formant tracks [npeaks x Ns] where Ns is signal length
%   Ak      - Time-varying LPCs [p+1 x Ns]
%
% Eg: [s,fs]=audioread('test-dr8-mjln0-sx279.wav');
%     [Fi,Ak] = ftrack_tvwlp(s,fs);
%     OR
%     [Fi,Ak] = ftrack_tvwlp(s,fs,'tvwlp_l2',3200,3200,8,3,3,0.5,1);
%
% Author: D.Gowda, 24 Oct, 2016
%%%%%%%%%%%%%%%%%%%%%
% if ~isdeployed
%     addpath('./GLOAT/');
% end


fs_ref=8000;
n1ms=floor(fs_ref/1000);

if nargin<3 || isempty(lptype)
    lptype='tvwlp_l2';
end
if nargin<4 || isempty(nwin)
    nwin=200*n1ms;
end
if nargin<5 || isempty(nshift)
    nshift=200*n1ms;
end
if nargin<6 || isempty(p)
    p=8;
end
if nargin<7 || isempty(q)
    q=3;
end
if nargin<8 || isempty(npeaks)
    npeaks=3;
end
if nargin<9 || isempty(PREEMP)
    PREEMP=0.97;
end
if nargin<10 || isempty(fint)
    fint = 80;
end

%%% this is newly added
if nargin<11 || isempty(freqBounds)
    f0min=60;
    f0max=600;
else
    f0min=freqBounds(1);
    f0max=freqBounds(2);
end
%%% this is newly added


if nargin<12 || isempty(PLOT_FLAG)
    PLOT_FLAG = 1;
end

if(fs ~= fs_ref)
    s=resample(s,fs_ref,fs);
    nwin=floor(nwin*fs_ref/fs);
    nshift=floor(nshift*fs_ref/fs);
    fs=fs_ref;
end

if(exist('PREEMP','var'))
    shat=filter([1 -PREEMP],1,s);
else
    shat=s;
end
Ns=length(shat);

switch lower(lptype)
    case {'tvwlp_l2','tvwlp_l1'}
        %%% QCP weight function computation
        %%% GCI detection using SEDREAMS
        wmin = 0.00001; % Minimum value of weighting function
        DQ = 0.7; % Duration Quotient (relative to fundamental period)
        PQ = 0.05; % Position Quotient (relative to fundamental period)
        Nramp = 3; % Length of linear ramp (in samples)

        % f0min=60;
        % f0max=600;
        % Pitch tracking using a method based on the Summation of the Residual Harmonics
        [f0,VUV] = FormantEstimation.TVQCP.GLOAT.SRH_PitchTracking(s,fs,f0min,f0max);
        f0_tmp=f0.*VUV;
        pos= (f0_tmp~=0);
        f0_tmp=f0_tmp(pos);
        f0mean=mean(f0_tmp);
        % Oscillating Moment-based Polarity Detection
        %pol = OMPD_PolarityDetection(s,fs,f0mean,VUV);
        % Speech Event Detection using the Residual Excitation And a Mean-based Signal
        %[gc] = SEDREAMS_GCIDetection(pol*s,fs,f0mean);
        [gc] = FormantEstimation.TVQCP.GLOAT.SEDREAMS_GCIDetection(s,fs,f0mean);
        w = qcp_wt(s,p,DQ,PQ,wmin,Nramp,gc,fs);
    otherwise
        w=ones(size(s)); % just dummy as of now no use
end

Fi=zeros(npeaks,floor((nwin-nshift)/2));
Ak=zeros(p+1,floor((nwin-nshift)/2));
for j=0:nshift:Ns-nwin

    if(j<=Ns-nwin-nshift)
        x=shat(j+(1:nwin));%.*hamming(nwin);
        wj=w(j+(1:nwin));
    else % last window
        x=shat(j+1:end);%take all samples
        wj=w(j+1:end);
    end

    switch lower(lptype)
        case {'tvlp_l2'}
            [aki]=FormantEstimation.TVQCP.tvlp_l2(x,p,q);
        case {'tvwlp_l2'}
            [aki]=FormantEstimation.TVQCP.tvwlp_l2(x,p,q,wj);
        case {'tvlp_l1'}
            [aki]=FormantEstimation.TVQCP.tvlp_l1(x,p,q);
        case {'tvwlp_l1'}
            [aki]=FormantEstimation.TVQCP.tvwlp_l1(x,p,q,wj);
        otherwise
            disp('Unknown method.')
    end

    Nx=length(x);
    [fi,ak]=FormantEstimation.TVQCP.tvlptoformants_akitofi(aki,Nx,npeaks,fs);

    if(j==0)
        Fi=fi(1:floor((nwin-nshift)/2),1:npeaks);
    end

    Fi = [Fi;fi(floor((nwin-nshift)/2)+(1:nshift),1:npeaks)];
    Ak = [Ak ak(:,floor((nwin-nshift)/2)+(1:nshift))];

    if(j>Ns-nwin-nshift)
        Fi=[Fi;fi(nshift+floor((nwin-nshift)/2)+1:end,1:npeaks)];
    end
end

Fi(end+1:Ns,:)=0;
Ak(:,end+1:Ns)=0;

Fi=Fi(fint:fint:end,:)';
Fi=medfilt1(Fi,5,[],2);

formantTimeVector=(fint:fint:Ns)/fs;
if(PLOT_FLAG)
    n1ms=floor(fs/1000);
    [S,f,t]=spectrogram(s,20*n1ms,15*n1ms,2^10,fs);
    figure;
    tiledlayout(3,1); ax1=nexttile(1);
    imagesc(t,f/1000,20*log10(abs(S)));axis xy;colorbar; colormap gray;
    xlabel('Time (s)');ylabel('Freq (kHz)');
    hold(ax1,'on');
    plot(ax1,formantTimeVector,Fi'/1000,'.');

    [vadProb, timeVec] = estimateVAD(s, fs);
    ax2=nexttile(2); plot(ax2,timeVec,vadProb);
    xlabel(ax2,'Time (s)'); title(ax2,'Voice Activity Probability');
    ylim(ax2,'padded');
    xlim(ax2,'tight');

    ax3=nexttile(3);
    imagesc(t,f/1000,20*log10(abs(S)));axis xy;colorbar; colormap gray;
    xlabel('Time (s)');ylabel('Freq (kHz)');
    hold(ax3,'on');
    resampledProb=interp1(timeVec,vadProb,formantTimeVector,"pchip");

    formantTimeVector(resampledProb<0.98)=NaN;
    plot(ax3,formantTimeVector,Fi'/1000,'.');

    linkaxes([ax1 ax2 ax3],'x')

end

end

function [ w ] = qcp_wt( x, p, DQ, PQ, d, Nramp, gci_ins, fs )
%   Create a AME weight function for frame x for LPC order p
%   DQ = duration quotient (from 0 to 1)
%   PQ = Position Quotient (from 0 to 1)
%   d = minimum value of the weight function
%   Nramp = length of the linear ramp (in samples)
%   gci_ins = Glottal Closure Instants of the frame x

N = length(x);
%Nramp = 1;
if Nramp > 0
    UPramp = linspace(d,1,2+Nramp);
    UPramp = UPramp(2:end-1);
    DOWNramp = UPramp(end:-1:1);
end

if DQ+PQ > 1
    DQ = 1-PQ;
end

w = d.*ones(1,N+p);

for i = 1:length(gci_ins)-1
    T = gci_ins(i+1)-gci_ins(i);
    T1 = round(DQ*T);
    T2 = round(PQ*T);
    while T1+T2 > T
        T1 = T1-1;
    end
    w(gci_ins(i)+T2:gci_ins(i)+T2+T1-1) = 1;
    if Nramp > 0
        w(gci_ins(i)+T2:gci_ins(i)+T2+Nramp-1) = UPramp;
        if gci_ins(i)+T2+T1-Nramp > 0
            w(gci_ins(i)+T2+T1-Nramp:gci_ins(i)+T2+T1-1) = DOWNramp;
        end
    end
end

Nend = N-(T2+gci_ins(i+1));

if T2+gci_ins(i+1) < N
    if T1+T2 < Nend
        w(gci_ins(i+1)+T2:gci_ins(i+1)+T2+T1-1) = 1;
        if Nramp > 0
            w(gci_ins(i+1)+T2:gci_ins(i+1)+T2+Nramp-1) = UPramp;
            w(gci_ins(i+1)+T2+T1-Nramp:gci_ins(i+1)+T2+T1-1) = DOWNramp;
        end
    else
        T1 = Nend-T2;
        w(gci_ins(i+1)+T2:gci_ins(i+1)+T2+T1-1) = 1;
        if Nramp > 0
            w(gci_ins(i+1)+T2:gci_ins(i+1)+T2+Nramp-1) = UPramp;
        end
    end
end

end

function [vadProb, timeVec] = estimateVAD(signal, fs)
% estimateVAD - Frame-wise voice activity probability using voiceActivityDetector
% Inputs:
%   signal - input audio signal (vector)
%   fs     - sampling rate in Hz
% Outputs:
%   vadProb - vector of voice activity probabilities per frame
%   timeVec - time vector corresponding to each frame center

signal=signal(:);

% Parameters
frameDuration = 0.02; % 20 ms
frameLength = round(frameDuration * fs);
overlapLength = round(0.5 * frameLength); % 50% overlap
hopLength = frameLength - overlapLength;

% Pad signal to fit full frames
numFrames = ceil((length(signal) - overlapLength) / hopLength);
padLength = (numFrames - 1) * hopLength + frameLength - length(signal);
signal = [signal; zeros(padLength, 1)];

% Create VAD object
%VAD = voiceActivityDetector("SilenceToSpeechProbability",0.1,"SpeechToSilenceProbability",0.5);
VAD = voiceActivityDetector();
% Initialize output
vadProb = zeros(numFrames, 1);
timeVec = zeros(numFrames, 1);

% Frame-wise detection
for i = 1:numFrames
    startIdx = (i - 1) * hopLength + 1;
    endIdx = startIdx + frameLength - 1;
    frame = signal(startIdx:endIdx);
    vadProb(i) = VAD(frame);
    timeVec(i) = (startIdx + endIdx) / (2 * fs); % frame center time
end

end

