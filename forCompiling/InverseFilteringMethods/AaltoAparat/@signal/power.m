function c = power(a,b)

% overloading of operator .^

% $Id: power.m 83 2005-08-19 11:05:34Z mairas $

if ~(isa(a,'signal') & isnumeric(b))
  error('The base must be a signal object and the exponent a numeric value');
end

c = signal(a.s.^b,a.time);
