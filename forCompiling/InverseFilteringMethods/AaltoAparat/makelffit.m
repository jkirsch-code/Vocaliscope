function [glf,lf]=makelffit(g)
% MAKELFFIT Fit a series of LF-model pulses to a glottal flow waveform.
%   [GLF,LF]=MAKELFFIT(G)
%   G is a glottal flow waveform, acquired e.g. using IAIF or DIF.
%   GLF is a cell array of fitted LF pulse waveforms.
%   LF is a cell array of the LF-model parameters.
%
%   Please refer to GLOTTAL_LF and Fant, Liljencrants & Lin (1985)
%   for parameter details.

% $Id: makelffit.m 138 2006-09-01 07:56:53Z mairas $

q = glottaltimeparams(g);
f0 = find_f0(g);

for j=1:length(q)

  t0_ = q(j).t_po;
  tp_ = q(j).t_max;
  te_ = q(j).t_dmin;
  ta = 0.2e-3;

  % acquire the fit
  p=fitlf(g,f0,t0_,tp_,te_,ta);

  %t0_ = p(1)+1/t.f0;
  %tp_ = p(2)+1/t.f0;
  %te_ = p(3)+1/t.f0;

  lf(j).t0 = p(1);
  lf(j).tp = p(2)-lf(j).t0;
  lf(j).te = p(3)-lf(j).t0;
  lf(j).ta = p(4);
  lf(j).Ee = p(5);


  [u,du]=glottal_lf(f0,g.fs,1,struct('tp',lf(j).tp,'te', ...
                                       lf(j).te,'ta', ...
                                       lf(j).ta,'Ee',lf(j).Ee));
  us{j} = shift(u,lf(j).t0);
  
end

glf = us;
