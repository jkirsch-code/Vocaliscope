function [h,f] = ZeroPaddedSpectrum(a,Nfft,Fs)
%Brad Story; last updated: 01-23-08
%This function is called by ThreeDSpectrumX.m and others

N = length(a);
a = a(:);

%Zero padding 
if(N < Nfft)
    Npad = round((Nfft-N)/2);
    b = [zeros(Npad,1); a; zeros(Npad,1)];
    else
    b = a;
end;

h = fft(b,Nfft);
f  = [0:Fs/Nfft:(Nfft-1)*(Fs/Nfft)];

