function y = imag(x)
% IMAG   Complex imaginary part.
%    IMAG(X) is the imaginary part of X.
%    See I or J to enter complex numbers.
% 
%    See also real, isreal, conj, angle, abs.
%
%    Overloaded functions or methods (ones with the same name in other directories)
%       help spectrum/imag.m
%       help frd/imag.m
%       help iddata/imag.m
%       help sym/imag.m
%
%    Reference page in Help browser
%       doc imag


y = signal(imag(x.s),x.time);