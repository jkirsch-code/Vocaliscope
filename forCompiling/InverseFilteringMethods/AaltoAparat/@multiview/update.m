function update(c,event)

switch event
 case {'init'}
  plotdata(c);
 case 'destroy'
  try
    delete(c.fig);
  catch
  end
 otherwise
end


function plotdata(c)

ifopts = call('get',c.model,'ifopts');
N=7;
if strcmp(c.parname,'p')
   mid = ifopts.p;
   c.param = 2*(mid/2-3:mid/2+3);
%   fs = call('get',c.model,'fs');
%   mid = round(fs/2000);
%   c.param = 2*(mid-3:mid+3);
elseif strcmp(c.parname,'rho')
  N=5;
  c.param = linspace(1,0.9,N);
elseif strcmp(c.parname,'dq') %for QCP only
  c.param = linspace(1,0.1,N);
elseif strcmp(c.parname,'pq') %for QCP only
  N = 6;
  c.param = linspace(0.15,0,N);
elseif strcmp(c.parname, 'nramp') %for QCP only
  c.param = linspace(19,1,N);  
elseif strcmp(c.parname,'r') %for IAIF only
  N = 6;
  c.param = linspace(59,4,N);
elseif strcmp(c.parname, 'g') %for IAIF only
  c.param = linspace(8,2,N);   
else
  error('Invalid parameter');
end
%sanity check for c.param?

c.data = call('getmulti',c.model,c.parname,c.param);
figure(c.fig);
clf;
axes('Position',[.095,.12,.86,.8]);
% str = sprintf('text here %c',c.parname);
% title(str);
title(['The curves with different {\color{red}' upper(c.parname) '} values']);
hold on;
for i=1:N
  c.data{i} = c.data{i}/max(c.data{i})+0.7*(N-i);
  plot(c.data{i});
end
axis tight;
set(gca,'YTick',[0.1 N*0.7/2 N*0.7]);
%set(gca,'YTickLabel',{'Min','Mid','Max'});
set(gca,'YTickLabel',{num2str(c.param(end)),num2str(c.param(round(end/2))),num2str(c.param(1))});
ylabel(upper(c.parname));
xlabel('Time (s)')
hold off;
store(c);
