function varargout=glottal_lf(f0,fs,num,varargin)
% GLOTTAL_LF  Liljencrants-Fant glottal flow model
%    U=GLOTTAL_LF(F0,FS,NUM)
%    U=GLOTTAL_LF(F0,FS,NUM,PARAMS)
%
%    GLOTTAL_LF gives a synthetic glottis pulse, when given fundamental
%    frequency F0, sampling frequency FS, number of cycles NUM and
%    optionally a parameter structure PARAMS.

% see Fant, Liljencrants & Lin (1985) for parameter details

% $Id: glottal_lf.m 202 2008-01-24 13:40:21Z mairas $

T0 = 1/f0;

% t0: the relative beginning of the opening phase

t0_ = 0;

% tp: time instant of the signal peak

tp = 0.38*T0;

% te: time instant of the derivative minimum peak

te = 0.53*T0;

% ta: the effective duration of the return phase

ta = 0.06*T0;

% Ee: the amplitude of the negative peak of the glottal pressure
% waveform 

Ee = 50;

if nargin>3
  p = varargin{1};
  if isfield(p,'t0')
    t0_ = p.t0;
  end
  if isfield(p,'tp')
    tp = p.tp-t0_;
  end
  if isfield(p,'te')
    te = p.te-t0_;
  end
  if isfield(p,'ta')
    ta = p.ta;
  end
  if isfield(p,'Ee')
    Ee = p.Ee;
  end
end  

t0 = 0;

% tc: the instant of the glottal closure
% note: this is always 1 when relative measures are used

tc = T0;

%T=t0:1/fs:(tc-1/fs);
T1 = t0:1/fs:te;
T2 = T1(end)+1/fs:1/fs:tc-1/fs;
%T1 = T(find(T<=te));
%T2 = T(find(T>te));

%disp([length(T1) length(T2) t0 tp te ta Ee tc]);

% solve epsilon

e = exp(1);

feps = @(epsi) epsi*ta-(1-exp(-epsi*(tc-te)));
epsi0=1/ta;
options=optimset('Display','off','TolFun',1e-18,'TolX',1e-18);
%epsi = fsolve(feps,epsi0,options);
epsi = lsqnonlin(feps,epsi0,0,50000,options);


%disp(['[epsi tc Ee te ta Uc] [' num2str([epsi tc Ee te ta Uc]) ']']);

% solve alpha - analytical solutions be damned!

global fa;

g2 = -Ee/(epsi*ta)*(exp(-epsi*(T2-te))-exp(-epsi*(tc-te)));

R = sum(g2);

a0 = 400;

fa = @(a) R+sum(-Ee/(sin(pi*te/tp)*exp(a*te))*exp(a*T1).*sin(pi*T1/tp));

options=optimset('Display','off','TolFun',1e-10,'TolX',1e-10);
%options=optimset('Display','iter','TolFun',1e-18,'TolX',1e-18);
%a = fsolve(fa,a0,options);
a = lsqnonlin(fa,a0,[-inf],[inf],options);
%a = 419;

g1 = -Ee/(sin(pi*te/tp)*exp(a*te))*exp(a*T1).*sin(pi*T1/tp);

g = [g1 g2];

g = signal(repmat(g,1,num),fs);

g = shift(g,t0_);

u = filter(1,[1 -1],g,'noncausal')./g.fs;

if nargout>1
  varargout={u,g};
else
  varargout=u;
end
