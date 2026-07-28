function X = hilbert(Xr)
%  HILBERT  Discrete-time analytic signal via Hilbert transform.
%    X = HILBERT(Xr) computes the so-called discrete-time analytic signal
%    X = Xr + i*Xi such that Xi is the Hilbert transform of real vector Xr.
%    If the input Xr is complex, then only the real part is used: Xr=real(Xr).
%    If Xr is a matrix, then HILBERT operates along the columns of Xr.
% 
%    HILBERT(Xr,N) computes the N-point Hilbert transform.  Xr is padded with 
%    zeros if it has less than N points, and truncated if it has more.  
% 
%    For a discrete-time analytic signal X, the last half of fft(X) is zero, 
%    and the first (DC) and center (Nyquist) elements of fft(X) are purely real.
% 
%    Example:
%      Xr = [1 2 3 4];
%      X = hilbert(Xr)
%    produces X=[1+1i 2-1i 3-1i 4+1i] such that Xi=imag(X)=[1 -1 -1 1] is the
%    Hilbert transform of Xr, and Xr=real(X)=[1 2 3 4].  Note that the last half
%    of fft(X)=[10 -4+4i -2 0] is zero (in this example, the last half is just
%    the last element).  Also note that the DC and Nyquist elements of fft(X)
%    (10 and -2) are purely real.
% 
%    See also fft, ifft.
%
%    Overloaded functions or methods (ones with the same name in other directories)
%       help fdesign/hilbert.m
%
%    Reference page in Help browser
%       doc hilbert
%


X = signal(hilbert(Xr.s), Xr.time);