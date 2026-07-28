function update(c,event)
% phaseview update

%disp(['phaseview/update ' event]);

switch event
 case {'init', 'glottal_flow'}
  plotphase(c);
 case 'destroy'
  try
    fig = get(c.axes1,'Parent');
    delete(fig);
  catch
  end
 otherwise
end


function plotphase(c)

flow = get(deref(c.model),'glottal_flow');
dflow = get(deref(c.model),'glottal_pressure');
ddflow = filter([1 -1],1,dflow);

if isa(flow,'signal') & isa(dflow,'signal') & (length(flow.s) > 50)
    if length(flow.s) == 0
        axes(c.axes1);
        cla
        return
    end
        

  % generate averaging filter
  flowfilt = fir1(20,3500/flow.fs);
  startskip = length(flowfilt)+1;

  % filter flow and dflow
  len = min(length(flow.s), length(dflow.s));
  dflow = filter([1 -1],1,flow);
  dflows = filter(flowfilt,1,dflow);
  flows = filter(flowfilt,1,flow);
  flows = flows.s;
  dflows = dflows.s;

  % plot phase-plane
  axes(c.axes1);
  plot(flows(startskip:len),dflows(startskip:len));
  xlabel('Flow');
  ylabel('DFlow');
  
  % calculate number of cycles vs. f0
  dx =  flows(startskip+1:len) - flows(startskip:len-1);
  dy =  dflows(startskip+1:len) - dflows(startskip:len-1);
  ix = find(dy == 0);
  len = len - length(ix);
  dx(ix) = [];
  dy(ix) = [];
  
  % phase in angles
  ang(startskip:len-1) = atan(dx./dy);
  
  % unwrap from [-pi,pi] to (0,+-infty)
  for k = (startskip+1):len-1
      dang = abs(ang(k-1)-ang(k));
      if dang > abs(ang(k-1)-ang(k)+pi)
          ang(k:end) = ang(k:end)-pi;
      elseif dang > abs(ang(k-1)-ang(k)-pi)
          ang(k:end) = ang(k:end)+pi;
      end
  end

  % calculate ratio of cycles and periods
  f0 = get(deref(c.model),'f0');
  fs = flow.fs;
  if f0~=0 % avoid divide by zero
      cycles = abs(ang(len-1)-ang(startskip))/(2*pi);
      f0samp = fs/f0;
      periods = len/f0samp;
      
      A = subcycle(flows(startskip:len-1), dflows(startskip:len-1), f0, fs);
      if length(A) > 0
          A = mean(A);
      end

      maxpos = [max(flows(startskip:len)) max(dflows(startskip:len))];
      minpos = [min(flows(startskip:len)) min(dflows(startskip:len))];

      text((maxpos(1)+2*minpos(1))/3, (maxpos(2)+minpos(2))/2, ...
          ['Cycles per period: ' num2str(cycles/periods)]);
      text((maxpos(1)+2*minpos(1))/3, (.7*maxpos(2)+minpos(2))/1.7, ...
          ['Mean subcycle length: ' num2str(A)]);
      text((maxpos(1)+2*minpos(1))/3, (.5*maxpos(2)+minpos(2))/1.5, ...
          ['Modelling error: ' num2str(get(deref(c.model),'iferror'))]);
      text((maxpos(1)+2*minpos(1))/3, (.3*maxpos(2)+minpos(2))/1.3, ...
          ['Kurtosis: ' num2str(kurtosis(flow.s))]);
  end
  
  
end





