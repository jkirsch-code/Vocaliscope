function sigwavwrite(y,varargin)
% SIGWAVWRITE Write wave (".wav") sound file.
%    SIGWAVWRITE(Y,NBITS,WAVEFILE) Writes data Y to a wave file
%    specified by the file name WAVEFILE, with NBITS number of
%    bits. NBITS must be 8, 16, 24, or 32. Stereo data should be
%    specified as a cell array. For NBITS<32, amplitude values
%    outside the range [-1,+1] are clipped.
%
%    SIGWAVWRITE(Y,WAVEFILE) Assumes NBITS=16 bits.

% $Id: sigwavwrite.m 44 2004-08-16 12:39:22Z mairas $

if iscell(y)
  m=(y{1}.s)';
  fs=y{1}.fs;
  for i=2:length(y)
    m(:,end+1)=(y{i}.s)';
  end
else
  m=(y.s)';
  fs=y.fs;
end

wavwrite(m,fs,varargin{:});
