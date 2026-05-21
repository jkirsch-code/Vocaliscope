function E = TrackChildFmts(sig,fs,F0max,smthfactor,doPlot,nFormants,windowOverlap);
%----TrackChildFmts.m---
%Formant tracker for high-F0 speech
%B. Story
%University of Arizona
%
%
%INPUTS:
%sig = audio signal (assumes prior reading of audio signal)
%fs = sampling frequency
%F0max = maximum F0 expected in signal
%smthfactor = coefficient that determines normalized cepstral cutoff point;
%   the default value is 1.12 (see p. 101 in Story/Bunton (2016))
%   can be decreased or increased slightly if necessary to enhance
%   spectrogram.
%
%OUTPUTS:
%E = structure with output data
%Contents of E:
% E =
%
%        Sa: Smoothed envelope spectrogram (matrix)
%         S: Narrow band spectrogram (matrix)
%      Senv: Raw envelope spectrogram
%        Sz: Narrow band spectrogram (linear scale)
%         f: frequency vector
%        tm: time vector
%         F: Time-varying formants tracked from the raw env spectrogram
%        Fa: Time-varying formants tracked from the raw env spectrogram
%        F0: Time-varying F0
%         p: structure of parameters
%     F0est: Estimate of maximum F0 in signal (F0max in input)

%%% added by Jonas Kirsch 2026.03.18
if nargin<5 || isempty(doPlot)
    doPlot=0;
end
%%%

E = [];

%make signal is one channel only
if(size(sig,2) == 2)
    sig = sig(:,1);  %assume the channel to analyzed is channel 1
else
    sig = sig(:);  %assure that sig is a column vector
end

sig = sig/max(abs(sig)); %normalize signal amplitude


%=======Analysis=============

%---set analysis window size--------
if(fs > 40000)
    Nwind = 4096;  %Not Story and Bunton used Nwind =4410
else
    Nwind = 2048;
end

p = FormantEstimation.STORYnBUNTON.ES_functions.SetTypicalParams_ES;
p.WL = Nwind/fs;
p.ovrlp = 25;
p.preemp = 1;

%%% added by Jonas Kirsch 2026.03.18
    if nargin>=4 && ~isempty(smthfactor)
        p.smthfactor = smthfactor;
    end
    
    
    if nargin>=5 && ~isempty(nFormants)
        p.Nfmts = nFormants;
    end

    if nargin>=6 && ~isempty(windowOverlap)
        p.ovrlp = windowOverlap;
    end
%%%

E = FormantEstimation.STORYnBUNTON.ES_functions.EnvelopeSpectrogram(sig,fs,F0max,p);
E.F0est = F0max;


%----Set alternative color maps------
pinkr = pink;
pinkr = pinkr(end:-1:1,:);
grayr = gray;
grayr = grayr(end:-1:1,:);

if(isempty(E) == 0)
    if doPlot
    
    %==========Plottting ==============
    
    %----Plot the narrow spectrogram---------
    figure(1)
    clf
    surf(E.tm,E.f,E.S(:,:)')
    hold on
    shading interp
    view(0,90);
    mx = max(max(E.S));
    mn = min(min(E.S));
    caxis([mx-50 mx]);
    set(gca,'PlotBoxAspectRatio',[1 .5 1],'FontSize',12);
    xlabel('Time (sec)');
    ylabel('Frequency (Hz)');
    title('Narrow-band spectrogram')
    axis([0 E.tm(end) 0 7000 mn mx]);
    colormap(parula);
    
    %----Plot the raw envelope spectrogram---------
    figure(2)
    clf
    surf(E.tm,E.f,E.Senv(:,:)')
    hold on
    shading interp
    view(0,90);
    mx = max(max(E.Senv));
    caxis([mx-30 mx]);
    plot3(E.tm,E.F(:,1:3),(mx+10)+0*E.tm,'.');
    set(gca,'PlotBoxAspectRatio',[1 .5 1],'FontSize',12);
    xlabel('Time (sec)');
    ylabel('Frequency (Hz)');
    title('Raw Envelope Spectrogram')
    axis([0 E.tm(end) 0 7000 min(min(E.Senv)) mx+11]);
    colormap(parula);
    
    %----Plot the smoothed envelope spectrogram---------
    figure(3)
    clf
    surf(E.tm,E.f,E.Sa(:,:)');
    hold on
    shading interp
    view(0,90);
    mx = max(max(E.Sa));
    caxis([mx-20 mx]);
    plot3(E.tm,E.Fa(:,1:3),(mx+10)+0*E.tm,'.');
    set(gca,'PlotBoxAspectRatio',[1 .5 1],'FontSize',12);
    xlabel('Time (sec)');
    ylabel('Frequency (Hz)');
    title('Smoothed Envelope Spectrogram');
    axis([0 E.tm(end) 0 7000 min(min(E.Sa)) mx+11]);
    colormap(parula);
    end
else
    disp('Algorithm did not run - check signal quality');
end


