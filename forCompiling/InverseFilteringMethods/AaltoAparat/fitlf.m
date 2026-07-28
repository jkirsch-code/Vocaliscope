function p=fitlf(g,f0,t0,tp,te,ta)
% FITLF Fit a synthetic LF-model glottal pulse to a real signal


% $Id: fitlf.m 200 2007-09-10 12:32:40Z mairas $

% set the initial guesses
Ee = -g.at(te);

fopt = @(x) lfdiff(g,f0,x);

rtp0 = tp-t0;
rte0 = te-tp;
rtc0 = t0+1/f0-te;

x0 = [t0 rtp0 rte0 ta rtc0 Ee];
lb = [0 1/g.fs 1/g.fs 0 1/g.fs eps];
ub = [inf inf inf inf inf inf];

options=optimset('LargeScale','on','Display','off','MaxIter',10,...
  'TolFun',1e-18,'TolX',1e-18);
x = lsqnonlin(fopt,x0,lb,ub,options);

% normalize output
R=x(2)+x(3)+x(5);
t0=x(1);
Ee=x(6);
ta=x(4);
tp=t0+x(2)/R/f0;
te=tp+x(3)/R/f0;

p=[t0 tp te ta Ee];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d=lfdiff(g,f0,x)
t0  = x(1);
rtp = x(2);
rte = x(3);
ta  = x(4);
rtc = x(5);
Ee  = x(6);

R = rtp+rte+rtc;
tp= t0+rtp/R/f0;
te= tp+rte/R/f0;

%[lfu,lfg]=glottal_lf(f0,g.fs,1,struct('tp',tp-t0,'te',te-t0,'ta',ta,'Ee',Ee));
[lfu,lfg]=glottal_lf(f0,g.fs,1,struct('t0',t0,'tp',tp,'te',te,'ta',ta,'Ee',Ee));
lfg=shift(lfg,-0.5/g.fs);
g_per = trim(g,lfg.t(1),lfg.t(end));

% lfg sometimes extends beyond the end of g_per - take necessary steps
% to eliminate that
%if len(g_per) < len(lfg)
if len(lfg)~=45
  d=1e5*ones(1,len(lfg));
else
  d=g_per.s-lfg.s;
end
