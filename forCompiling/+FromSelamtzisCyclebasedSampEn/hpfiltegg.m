
function egg=hpfiltegg(egg,fs)

[b,a]=butter(3,[80/(fs/2) 7000/(fs/2)]);

egg=filtfilt(b,a,egg);

end
