function soundsc(s)

% $Id: soundsc.m 93 2005-10-24 13:54:45Z bassus $

s1 = s.s/(1.01*max(max(abs(s.s))));

if isunix
  wavwrite(s1,s.time.fs,'/tmp/wave.wav');
  !play /tmp/wave.wav
  !rm /tmp/wave.wav
else
  soundsc(s1,s.time.fs);
end
