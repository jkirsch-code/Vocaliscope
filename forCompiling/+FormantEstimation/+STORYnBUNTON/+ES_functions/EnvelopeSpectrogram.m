function E = EnvelopeSpectrogram(sig,Fs,F0est,p)
%EnvelopeSpectrogram.m
%Author: B. Story
%Last Updated: 01.31.17
%Function to generate an envelope spectrogram
%Based on:
%Story, B.H., and Bunton, K., (2016). Formant measurement in children?s speech based on spectral filtering,
%Speech Communication, 76, 93-111, [http://dx.doi.org/10.1016/j.specom.2015.11.001]
%
%INPUTS:
%sig = audio signal
%Fs = sampling frequency
%F0est = maximum F0 expected in signal
%p = structure of parameters
%
%OUTPUTS:
%E = structure with output data


if(isempty(p) == 1)
    p = FormantEstimation.STORYnBUNTON.ES_functions.SetTypicalParams_ES;
end

Stmp2 = 0;

%Unwrap the parameter structure
WL = p.WL;
ovrlp = p.ovrlp;
threshold = p.threshold;
WT = p.WT;
TRK = p.TRK;
img = p.img;
cmap = p.cmap;

cmap = cmap(1:3);

%----Set alternative color maps------
pinkr = pink;
pinkr = pinkr(end:-1:1,:);
grayr = gray;
grayr = grayr(end:-1:1,:);


if(size(sig,1) == 1)
    sig = sig';
end

%====PREAMBLE - parameters---

if(p.preemp == 1)
    sig = FormantEstimation.STORYnBUNTON.ES_functions.preemphasis(sig); %---preemphasize signal
    %disp('Input signal pre-emphasized...')
elseif(p.preemp == 2)
    [b,a] = butter(6,70/(Fs/2),'high');
    sig = filtfilt(b,a,sig);
    %disp('Input signal high pass filtered but NOT pre-emphasized...')
elseif(p.preemp == 3)
    sig = FormantEstimation.STORYnBUNTON.ES_functions.preemphasis(sig); %---preemphasize signal
    sig = FormantEstimation.STORYnBUNTON.ES_functions.preemphasis(sig); %---preemphasize signal
    %disp('Input signal pre-emphasized twice...')
end


sig = sig/max(abs(sig)); %---normalize signal
N = ovrlp; %---Overlap factor

k = 1;

inc = round((WL*Fs)/N);

S_size = ceil(length(sig)/inc);

%----set window type------

if(WT == 1)
    w = hamming(1+inc*N);
    %disp('Hamming window');
elseif(WT == 2);
    w = hanning(1+inc*N);
    %disp('Hanning window');
elseif(WT == 3)
    w = gausswin(1+inc*N,5);
    %disp('Gaussian 5 window');
elseif(WT == 4)
    w = gausswin(1+inc*N,2.5);
    %disp('Gaussian 2.5 window');
else
    w = ones(1+inc*N,1);
end


%----FFT size-----
Nfft = 8192/2;
%Nfft = 8820; %Use when df = 5 Hz is desired.
%Nfft = ceil(p.WL*Fs);

if(isfield(p,'maxF')==1)
    maxF = p.maxF;
else
    maxF = 7000;
end

j=1;


f  = [0:Fs/Nfft:(Nfft-1)*(Fs/Nfft)];
[ii,jj] = min(abs(f-maxF));
f = f(1:jj);

S = zeros(S_size,length(f));
Senv = S;
Sz = S;

flagcount = 1;
secondz = 0;

F0 = [];

for i = 1:inc:length(sig)-inc*N
    
    if(flagcount >= 5*Fs)
        flagcount = 0;
        secondz = secondz + 5;
        disp(['Duration analyzed = ' num2str(secondz) ' seconds']);
    end
    flagcount = flagcount + inc;
    
    aud = w.*sig(i:i+inc*N);
    
    %-----FFT spectrum-----------
    %Nfft = length(aud);
    [h,f] = FormantEstimation.STORYnBUNTON.ES_functions.ZeroPaddedSpectrum(aud,Nfft,Fs);
    z = abs(h);
    
    %[ii,jj] = min(abs(f-maxF));
    z = z(1:jj);
    f = f(1:jj);
    
    %----Raw 20log10 spectrum-----------
    h = 20*log10(z);
    
    if(isempty(p.dynrange) == 0)
        h = h - max(h) + p.dynrange;
        h(h<0) = 0;
    end
    
    %     h = h-mean(h);
    %     h(h<0) = 0;
    
    %---Assignments to be used later for display purposes
    S(j,:) = h;
    Sz(j,:) = z;
    
    %----Make the filter cutoff dependent on F0----
    df = f(2)-f(1);
    F0min = 40;
    F0max = F0est;
    
    %----Save some things for later viewing------
    seg = sig(i:i+inc*N);
    
    
    %---Voicing detector-------

    %%% if seg is all zero, this function crashses. so we need an if; added
    %%% by Jonas Kirsch, 2026.03.18
    if any(seg~=0)
        [V, F0estX] = FormantEstimation.STORYnBUNTON.ES_functions.VoiceDetectorAutoCorr(seg,Fs,F0max);
    else
        [V, F0estX]=deal(0); % set to zero
    end

    if(V>0)
        F0(j) = F0estX;
    else
        if(j>1)
            F0(j) = F0(j-1);
        else
            F0(j) = 500;
        end
    end
    
    %----Note the cutoff = 1.1 NOT 0.95 (05.29.15)-----
    if(F0(j) > F0min)
        smthX = p.smthfactor*df/F0(j);
    else
        smthX = 1.*df/F0min;
    end
    
    if(isfield(p,'smthX')==1)
        smthX = p.smthX;
    end
    
    
    %=====Generate Envelope Spectrogram===========
    %-----6th order Butterworth filter ----------
    [b,a] = butter(6,smthX);
    
    %     if(i==1)
    %         disp('Using 6th order butterworth');
    %
    %     end

    %%% this can be all inf if zero vector was incoming. if added by Jonas
    %%% Kirsch 2026.03.18
    if all(~isinf(h))
    
        %---Run the filter backwards to avoid pre-F1 hump---
        htmp = filtfilt(b,a,h(end:-1:1));
        %----Reverse the order to get back to f=0...7000 Hz
        Qf1 = htmp(end:-1:1);
        
        %-----forward version ---------
        Qf2 = filtfilt(b,a,h);
        
        %----average Qf1 and Qf2 -----
        
        tmp = (10.^(Qf1/20)+10.^(Qf2/20))/2;
        Qf = 20*log10(tmp);

    else
        Qf= nan(size(h));
    end
    
    %----Assign new spectral envelope to envelope matrix--
    Senv(j,:) = Qf;
    j = j+1;
    
end;

if(isempty(F0) == 0)
    
    Senv = Senv(1:length(F0),:);
    S = S(1:length(F0),:);
    tmp = size(S);
    tmp = tmp(1)-1;
    tm = (WL/2)+[0:inc/Fs:(tmp*inc)/Fs];
    
    F0 = medfilt1(F0,100);
    F0 = smooth(F0,15);
    
    
    
    
    for i=1:size(Senv,1)
        if(sum(isnan(Senv(i,:))) > 0)
            Senv(i,:) = 0;
        end
    end
    
    
    %-----Generate smoothed spectrogram----------
    
    Sa = Senv;
    for i=1:size(Sa,1)
        mp = polyfit(f,Sa(i,:),1);
        Sa(i,:) = Sa(i,:)-polyval(mp,f);
        Sa(i,:) = Sa(i,:) - max(Sa(i,:)) + 40;
        tmp =Sa(i,:);
        tmp(tmp<0) = 0;
        Sa(i,:) = tmp;
        
    end
    
    dt = inc/Fs;

    %%% commented out, i guess that should be depending on the overlap
    %%% which was set to 25 (%) by default in the "typical" setting. since we
    %%% want to be flexible, we have to use p.ovrlp instead of 25
    %%% Jonas Kirsch 2026.03.18
    %[bx,ax] = butter(2,25/((1/dt)/2));

    [bx,ax] = butter(2,p.ovrlp/((1/dt)/2));

    %%%





    %[bx,ax] = butter(2,50/((1/dt)/2));
    for i=1:size(Sa,2)
        Sa(:,i) = filtfilt(bx,ax,Sa(:,i));
    end
    
    Sa = Sa-max(max(Sa))+40;
    Sa(Sa<0) = 0;
    
    E.Sa = Sa;
    
    %----------------------------
    
    
    
    %-----Find Spectral Peaks (formants) from raw Senv---------
    F = zeros(size(Senv,1),4);
    H = zeros(size(Senv,1),4);
    
    [ii,jj] = min(abs(f-maxF));
    f = f(1:jj);
    
    
    for n=1:size(Senv,1)
        
        if(p.formantid == 1)
            
            [fmts, hts, index]   = FormantEstimation.STORYnBUNTON.ES_functions.formantid_XT( Senv(n,:), f,p.Nfmts,F0(n));
            
        else
            [fmts, hts, index, Sbal] = FormantEstimation.STORYnBUNTON.ES_functions.formantid_polybalance( Senv(n,:), f,p.Nfmts);
            Stmp2(n,:) = Sbal*3;
        end
        
        fmts = round(fmts);
        
        %-----assign formants from Senv------
        if(length(fmts)>=1)
            F(n,1) = fmts(1);
            H(n,1) = hts(1);
        end
        if(length(fmts)>=2)
            F(n,1:2) = fmts(1:2);
            H(n,1:2) = hts(1:2);
        end
        if(length(fmts)>=3)
            F(n,1:3) = fmts(1:3);
            H(n,1:3) = hts(1:3);
        end
        if(length(fmts)>=4)
            F(n,1:4) = fmts(1:4);
            H(n,1:4) = hts(1:4);
        end
    end
    
    
    
    %-----Find Spectral Peaks (formants) from smoothed Sa---------
    Fa = zeros(size(Sa,1),4);
    Ha = zeros(size(Sa,1),4);
    
    [ii,jj] = min(abs(f-maxF));
    f = f(1:jj);
    
    
    for n=1:size(Senv,1)
        
        if(p.formantid == 1)
            
            [fmts, hts, index]   = FormantEstimation.STORYnBUNTON.ES_functions.formantid_XT( Sa(n,:), f,p.Nfmts,F0(n));
            
        else
            [fmts, hts, index, Sbal] = FormantEstimation.STORYnBUNTON.ES_functions.formantid_polybalance( Sa(n,:), f,p.Nfmts);
            Stmp2(n,:) = Sbal*3;
        end
        
        fmts = round(fmts);
        
        %-----assign formants from Senv------
        if(length(fmts)>=1)
            Fa(n,1) = fmts(1);
            Ha(n,1) = hts(1);
        end
        if(length(fmts)>=2)
            Fa(n,1:2) = fmts(1:2);
            Ha(n,1:2) = hts(1:2);
        end
        if(length(fmts)>=3)
            Fa(n,1:3) = fmts(1:3);
            Ha(n,1:3) = hts(1:3);
        end
        if(length(fmts)>=4)
            Fa(n,1:4) = fmts(1:4);
            Ha(n,1:4) = hts(1:4);
        end
    end
    
   
    
else
    S = [];
    Senv = [];
    Sz = [];
    f = [];
    tm = [];
    F = [];
    F0 = [];
end

%---Now put everything in the "r" matrix for output

E.S = S;
E.Senv = Senv;
E.Sz = Sz;
E.f = f;  %frequency vector
E.tm = tm; %time vector from time-varying spectrum
E.F = F;
E.Fa = Fa;

E.F0 = F0;  %F0 track
E.p = p; %input parameters;


