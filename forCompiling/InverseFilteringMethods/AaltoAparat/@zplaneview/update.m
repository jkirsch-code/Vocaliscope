function update(c,event)

switch event
 case {'init','glottal_flow'}
  plotzplane(c);
 case 'destroy'
  try
    fig = get(c.axes,'Parent');
    delete(fig);
  catch
  end
 otherwise
end


function plotzplane(c)

hvt = get(deref(c.model),'hvt');
hg = get(deref(c.model),'hg');
rhg = roots(hg);
aropts = get(deref(c.model),'ifopts');
rho = aropts.rho;

try 
  axes(c.axes);
  hold off
  plot(roots(hvt)+eps*i,'xr');
  hold on
  plot(real(rhg),imag(rhg),'.k');
  plot(rho,0,'o');
  ix = (0:100)/100;
  plot(sin(2*ix*pi),cos(2*ix*pi),'--');
  plot(10*[-1 1],0*[-1 1],'--');
  plot(0*[-1 1],10*[-1 1],'--');
  xlabel('Real Part');
  ylabel('Complex Part');
  legend('Vocal tract','Glottis','Lip radiation');
  axis(1.15*[-1 1 -1 1]);
  set(gca,'dataaspectratiomode','manual');
  set(gca,'dataaspectratio',[1 1 1]);
catch
  destroy(c);
end
