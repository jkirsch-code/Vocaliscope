function c = reverse(a)

% reverse the signal

% $Id: reverse.m 56 2005-01-05 11:20:04Z mairas $

c = signal(fliplr(a.s),a.time);
