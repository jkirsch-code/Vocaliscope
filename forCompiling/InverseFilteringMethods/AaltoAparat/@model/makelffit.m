function m = makelffit(m,h)

%
%
%
% $Id: makelffit.m 184 2007-04-03 11:35:43Z mairas $

% get initial LF model parameters

q = m.params.t;

if nargin<2
  h=0;
end

for j=1:length(q)
  t0_ = q(j).t_po;
  tp_ = q(j).t_max;
  te_ = q(j).t_dmin;
  ta_ = 0.2e-3; % a reasonable guess
  
  % acquire the fit
  p=fitlf(m.cut_glotpres,m.f0,t0_,tp_,te_,ta_);

  lf(j).t0 = p(1);
  lf(j).tp = p(2)-lf(j).t0;
  lf(j).te = p(3)-lf(j).t0;
  lf(j).ta = p(4);
  lf(j).Ee = p(5);
  
  lf(j).Ra = lf(j).ta*m.f0;
  lf(j).Rg = 1/m.f0/(2*lf(j).tp);
  lf(j).Rk = (lf(j).te - lf(j).tp)/lf(j).tp;
  lf(j).OQ = lf(j).te*m.f0;
  lf(j).Rd = (0.5+1.2*lf(j).Rk)*(lf(j).Rk/(4*lf(j).Rg)+lf(j).Ra)/0.11;

  if ~isempty(h)
    waitbar(j/length(q),h);
  end
end

m.params.lf = lf;
store(m);
notify(m,'lffit');

