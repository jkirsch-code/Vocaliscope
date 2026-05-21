
%
%A function to generate nice looking spectrograms
%
%Inputs: (TheSignal,Fs,WindowDuration,FFTbins,Overlap)
%Outputs: The Spectrogram data & figure
%
%Usage: spec=aspect(y,fs,windur,bins,overlap) 
%
%Where the (hanning) window duration is in seconds, bins the number of bins for
%the FFT of each window and the overlap given in percent of the window.
function varargout=aspect(y,fs,windur,Npoint,overlap,newfig)
if newfig=='y'
figure
end

n=length(y);

dur=n/fs;          

t=0:fs^-1:dur;

%windur=0.1;             %A window of 0.01 seconds or 10 msec. 
                                  %The longer it is, the better the resolution on the frequency domain. The smaller it is, the better the resolution on the time domain. 
                                  %A good spectrogram should have reasonably good resolution in both domains so we need to find by trial and error the proper window length.
                                  %Try 0.01, 0.03, 0.1 and 0.5 sec to see the difference. You'll notice that by increasing the
                                  %window length up to 0.1 we get clearly resolved the harmonics of the voice. If we
                                  %increase more, the harmonics lines will
                                  %get thinner (in the stationary parts)
                                  %but their evolution in time will start
                                  %getting blurred.
                                  
Nw=floor(windur*fs);   %Number of samples of the window of duration windur. 
                                 
win=hann(Nw);            %The actual window of the STFT. In this case we use a hanning window.
                                      

                                   
overlappoints=floor(overlap*Nw);     %Number of samples of overlap between adjacent windows. It must be less than the window length. 
                                         %The smaller it is, the more "chunky" the spectrogram looks.
                                         %90% of the window produces a quite smooth looking spectrogram.
                                        
[spect,f1,t1]=spectrogram(y,win,overlappoints,Npoint,fs,'yaxis');

spectrogram(y,win,overlappoints,Npoint,fs,'yaxis');
set(gcf, 'renderer', 'zbuffer');
xlabel('Time (sec)')
xlim([0 dur])
ylim([0 fs/2])                
caxis([-110 -20])
axis tight

switch nargout
    case 1
        varargout={spect};
    case 2
        varargout={spect,f1};
    case 3
        varargout={spect,f1,t1};
end
                                                                                                                                                                                                                                                                                                                            