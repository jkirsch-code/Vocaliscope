function m = refilter(m)

if isa(m.orig_sppres{1},'signal')
  origsignal = m.orig_sppres{m.curchannel};
  if m.flipped
    origsignal = -1.*origsignal;
  end
  
  m.orig_fs = origsignal.time.fs;
  
  if m.fs~=0 && m.fs~=m.orig_fs
    origsignal = resample(origsignal,m.fs);
  else
    m.fs = m.orig_fs;
  end
  
  if m.prefilter
    fs = origsignal.fs;
    Wp = m.hpfreq/(fs/2);
    Ws = 2/8*m.hpfreq/(fs/2);
    Rp = 1;
    Rs = 20;
    
%    [n,Wn] = cheb2ord(Wp,Ws,Rp,Rs);
%    [b,a] = cheby2(n,Rs,Wn,'high');

%    [n,Wn] = buttord(Wp,Ws,Rp,Rs);
%    [b,a] = butter(6,Wn,'high');

    fcuts = [0 Ws Wp 1];
    mags = [0 0 1 1];

    b = firpm(400,fcuts,mags);
    
    m.speech_pressure = valid(filter(b,1,origsignal,'noncausal'));
    store(m);
  else
    m.speech_pressure = origsignal;
    store(m);
  end
end
