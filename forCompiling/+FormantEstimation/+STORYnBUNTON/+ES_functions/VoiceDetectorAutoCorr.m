function [v, F0est, T0est, A] = VoiceDetectorAutoCorr(sig,fs,F0max);
%VoiceDetectorAutoCorr.m
%02.28.15
%B. Story
%Function that uses autocorrelation of short time segments to find F0

if(size(sig,1) == 1)
    sig = sig';
end


F0est = 0;
T0est = 0;
A = 0;
threshold = 0.5; %set by trial and error

%--Set up filter coefficients, for later filtering of the autocorrelation
%--function. The number of coeffs is 0.45 percent of the sampling freq
Ncf = round(0.0045*fs);
b = fir1(Ncf,[40 F0max]/(fs/2));

%--Compute the normalized (to 1.0) autocorrelation of the input segment
autocorr = xcorr(sig,'coeff');
N = length(autocorr);

%--Filter the autocorr function
autocorr = filtfilt(b,1,autocorr);

%--Normalize
autocorr = autocorr/max(autocorr);

%--Now eliminate the first half of the autocorr function (it is redundant)
autocorr = autocorr(round(N/2):end);
tshift = 0;

%--Check to see that the autocorr function oscillates above and below zero.
%--If not, the segment cannot be voiced; move on
[ix,jx] = find(autocorr<0);
if(isempty(ix) == 1)
    v = 0;
elseif(length(ix)/length(autocorr) < 0.1)
    v = 0;
else
    tm = [0:1/fs:(length(autocorr)-1)/fs];
    [tmpks, pks, index] = FormantEstimation.STORYnBUNTON.ES_functions.FindPeaksRaw(autocorr, tm, 6);
    [i,j] = sort(pks(:),'descend');
    
    if(isempty(pks) == 0)
        if(pks(j(1)) > threshold)
            v = 1;
            A = pks(j(1));
            T0est = tmpks(j(1))+tshift;
        else
            v = 0;
        end
    else
        v = 0;
    end
end

if(T0est<1/F0max)
    T0est = 0;
    F0est = 0;
else
    F0est = 1/T0est;
end



