function q=glottalfreqparams(g,f0)
% GLOTTALFREQPARAMS Frequency-based parameterisation of the glottal flow
% Q=GLOTTALFREQPARAMS(G,F0) returns a structure containing multiple
% frequency-based parameters of the glottal flow.
%
% Description of the fields:
%
% DH12
%
% delta H_12 is more commonly known as H1-H2. It is the difference
% of the first two formants in decibels. See:
%
% I. Titze and J. Sundberg. Vocal intensity in speakers and
% singers. Journal of the Acoustical Society of America,
% 91(5):2936-2946, May 1992.
%
% PSP
%
% The parabolic spectrum parameter matches a second order
% polynomial to the flow spectrum computed over a single glottal
% cycle. See:
%
% P. Alku, H. Strik, and E. Vilkman. Parabolic spectral parameter
% -- a new method for quantifiction of the glottal flow. Speech
% Communication, 22:67-79.
%
% HRF
%
% Harmonic richness factor is the ratio of higher harmonics to the
% first harmonic. For more information, see:
%
% D. G. Childers and C. K. Lee. Vocal quality factors: Analysis,
% synthesis, and perception. Journal of the Acoustical Society of
% America, 90(5): 2394-2410.


% $Id: glottalfreqparams.m 127 2006-02-17 08:40:08Z mairas $

if nargin<2
  f0 = find_f0(g);
end

% get the fft of g

G = fft(g);

DH12 = dh12(G,f0);

PSP = psp(g,f0);

HRF = hrf(g,G,f0);

q.DH12 = DH12;
q.PSP = PSP;
q.HRF = HRF;



%%%%

function y=dh12(G,f0)

H1 = 20*log10(abs(G.at(f0)));
H2 = 20*log10(abs(G.at(2*f0)));

y = H1-H2;



%%%%
function PSP=psp(g,f0)

tp = glottaltimeparams(g,f0);
T0 = 1/f0;

n0 = round(g.fs/f0);

gmax = signal(1/n0*ones(1,n0),g.fs);
gmax_zp = gmax; gmax_zp(2048)=0;
ws=warning('off','MATLAB:log:logOfZero');
Xmax = 20*log10(half1(abs(fft(gmax_zp))));
warning(ws);
amax = pspa(Xmax);

PSP = [];
for i=1:length(tp)
  g_p = trim(g,tp(i).t_c-T0,tp(i).t_c);
  g_p0 = g_p-min(g_p);
  E_gp = sum(g_p.^2);
  g_pe = g_p0./(sqrt(E_gp));
  g_zp = g_pe; g_zp(2048)=0;
  X = 20*log10(half1(abs(fft(g_zp))));
  a = pspa(X);
  PSP(i)=a/amax;
end


%%%%
function a=pspa(X)

nel = 0.01;

done = 0;

N = 3;
while ~done
  k = 0:N-1;
  anum = N*sum(X.s(k+1).*k.^2)-sum(X.s(k+1)).*sum(k.^2);
  aden = N*sum(k.^4)-(sum(k.^2)).^2;
  a = anum / aden;
  
  b = 1/N*sum(X.s(k+1)-a*k.^2);
  
  NEnum = sum((X.s(k+1)-a*k.^2-b).^2);
  NEden = sum(X.s(k+1).^2);
  
  NE = NEnum/NEden;
  
  if NE<nel
    N = N+1;
  else
    done = 1;
  end
end

%%%%
function HRF=hrf(g,G,f0)

Ga = abs(G);
nh = get_harmonics(Ga,f0);

HRF = 20*log10(sum(Ga(nh(2:end)))/Ga.s(nh(1)));

% we can't calculate NRH unless we know the original window length

%%%%
function nh=get_harmonics(Xabs,f0)

% get N (vector of harmonics to get)
N = 1:floor((Xabs.frequency.fs/2)/f0);

nh=N;
for i=N
  % for each harmonic, find the local maximum in the region
  [f,n]=localmax(Xabs,f0,i);
  nh(i)=n;
end

%%%%
function [f,n]=localmax(Xabs,f0,N)
% LOCALMAX Find a largest spectral peak around N*f0
%   F=LOCALMAX(XABS,FX,F0,N) returns the frequency, at which XABS
%   gains its largest value. XABS is the absolute magnitude
%   spectrum, FX are the corresponding frequency points, F0 is the
%   assumed fundamental frequency and N is the order of harmonics.

fmin=(N-0.5)*f0;
fmax=(N+0.5)*f0;

Imin=at(Xabs,fmin);
Imax=at(Xabs,fmax);

[foo,I]=max(Xabs(Imin:Imax));

n=Imin-1+I;
f=Xabs.frequency.f(n);

