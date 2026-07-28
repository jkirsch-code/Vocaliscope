function update(c,event)

%disp(['sigview/update ' num2str(c.this) ' ' event]);

switch event
  case 'init'
    % get data to be plotted
    
    update_sppres(c);
    update_flow(c);
    update_dflow(c);
    
    % clear selection
    %setappdata(c.signalAxes,'sel',struct);
    %set(deref(c.model,'sel',struct));
    
    %showSel(c);

    setSelSizeWidgets(c);
    setFs(c);
    setChannels(c);
    
  case 'speech_pressure'
    update_sppres(c);
 
  case 'glottal_flow'
    update_flow(c);
    
    %setappdata(c.signalAxes,'sel',struct);
    %set(m,'sel',struct);
    
    %showSel(c);
  case 'glottal_pressure'
    update_dflow(c);

  case 'lffit'
    update_LF(c);
    
  case {'fixedifwinsize','sppres_selection'}
    updateSelAppData(c);
    setSelSizeWidgets(c);
    showSel(c,c.signalAxes);
  
  case 'glottal_selection'
    updateSelAppData(c);
    %showSel(c,c.flowAxes);
    %showSel(c,c.dflowAxes);
    
  case 'cut_sppres'
    setFs(c);
    
  case 'orig_fs'
    setOrigFs(c);

  case 'curchannel'
    setChannels(c);

  case 'flipped'
    setFlipped(c);
  case 'ifquality'
    setIFQuality(c);
  case 'notes'
    setNotes(c);
  case 'f0'
    setF0(c);
    
  case 'destroy'
    delete(c.hObject);
  case 'params'
    update_params(c);
  otherwise
end


%%%%
function update_sppres(c)

m = deref(c.model);

sig = get(m,'speech_pressure');


axes(c.signalAxes);

% never mind errors in here
%try
%  sh=get(m,'cutsignal');
%  ifopts=get(m,'ifopts');
%  shf=filter(1,[1 -ifopts.rho],sh,'noncausal');
%  shf=scale(shf,min(s),max(s));
%  plot(shf,'Color',[0.7 0.7 0.7]);
%  hold on;
plot(sig,'Color', [0.0 0.447 0.741]);
%plot(sig,'b');
%  hold off;
%catch
%end

axis tight;
set(gca,'YTickLabel',[]);
ylabel('Signal amplitude');
xlabel('Time (s)');



%%%%
function update_flow(c);

m = deref(c.model);

flow = get(m,'glottal_flow');
axes(c.flowAxes);
if isobject(flow)
  ifopts = get(m,'ifopts');
  % FIXME: this view is dependent on IAIF parameters (should be
  % independent of the IF method)
  cuts = get(m,'cut_sppres');
  cuts = filter(1,[1 -ifopts.rho],cuts,'noncausal');
  cuts = scale(cuts,min(flow),max(flow));
  plot(cuts,'Color',[0.85 0.85 0.85]);
  hold on;
  if get(m,'egginother') 
      egg = get(m,'cut_egg');
      if length(egg)>0
          plot(scale(egg,min(flow),max(flow)),'Color',[0.85 0.5 0.5]);
      end
  end
  plot(flow);
  hold off;
else
  cla;
end
axis tight;
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
ylabel('Flow amplitude');


%%%%
function update_dflow(c);

m = deref(c.model);

cuts = get(m,'cut_sppres');
dflow = get(m,'glottal_pressure');
axes(c.dflowAxes);
if isobject(dflow) & isobject(cuts)
  ifopts = get(m,'ifopts');
  % FIXME: this view is dependent on IAIF parameters (should be
  % independent of the IF method)
  cuts = scale(cuts,min(dflow),max(dflow));
  plot(cuts,'Color',[0.85 0.85 0.85]);
  hold on;
  if get(m,'egginother') 
      egg = get(m,'cut_egg');
      if length(egg)>0
          plot(scale(diff(egg),min(dflow),max(dflow)),'Color',[0.85 0.5 0.5]);
      end
  end
  plot(dflow);
  hold off;
else
  cla;
end
  axis tight;
  set(gca,'YTickLabel',[]);
xlabel('Time (s)');
ylabel('Flow deriv. amp.');


%%%%
function update_params(c);

m = deref(c.model);

p = get(m,'params');
sp = get(m,'shown_params');
flow = get(m,'glottal_flow');
dflow = get(m,'glottal_pressure');

update_flow(c);
update_dflow(c);

axes(c.flowAxes);
if isobject(flow) & isfield(p,'t')
  hold on;
  % primary opening
  if isTrue(sp,'OQ1') | isTrue(sp,'SQ1')
    plot([p.t.t_po],flow.at([p.t.t_po]),'go');
  end
  % secondary opening
  if isTrue(sp,'OQ2') | isTrue(sp,'SQ2')
    plot([p.t.t_so],flow.at([p.t.t_so]),'gs');
  end
  % peak
  if isTrue(sp,'SQ1') | isTrue(sp,'SQ2') | isTrue(sp,'NAQ') | ...
      isTrue(sp,'AQ') | isTrue(sp,'ClQ')
    plot([p.t.t_max],flow.at([p.t.t_max]),'ko');
  end
  % closing instant
  if isTrue(sp,'OQ1') | isTrue(sp,'OQ2') | isTrue(sp,'SQ1') | ...
      isTrue(sp,'SQ2') | isTrue(sp,'ClQ')
    plot([p.t.t_c],flow.at([p.t.t_c]),'ro');
  end
  % minimum
  if isTrue(sp,'NAQ') | isTrue(sp,'AQ') | isTrue(sp,'OQa')
    plot([p.t.t_min],flow.at([p.t.t_min]),'ko');
  end
  % derivative minimum
  if isTrue(sp,'NAQ') | isTrue(sp,'AQ') | isTrue(sp,'OQa')
    plot([p.t.t_dmin],flow.at([p.t.t_dmin]),'rx');
  end
  % derivative maximum
  if isTrue(sp,'OQa')
    plot([p.t.t_dmax],flow.at([p.t.t_dmax]),'gx');
  end
  % quasi opening and closing time
  if isTrue(sp,'QOQ')
    plot([p.t.t_qo],flow.at([p.t.t_qo]),'gv');
    plot([p.t.t_qc],flow.at([p.t.t_qc]),'rv');
  end
    
  hold off;
end

axes(c.dflowAxes);
if isobject(dflow) & isfield(p,'t')
  hold on;
  % derivative minimum
  if isTrue(sp,'NAQ') | isTrue(sp,'AQ') | isTrue(sp,'OQa')
    plot([p.t.t_dmin],dflow.at([p.t.t_dmin]),'rx');
  end
  % derivative maximum
  if isTrue(sp,'OQa')
    plot([p.t.t_dmax],dflow.at([p.t.t_dmax]),'gx');
  end
  
  hold off;
end
  

%%%%
function update_LF(c);

m = deref(c.model);
p = get(m,'params');

if isfield(p,'lf') && length(fieldnames(p.lf))>0
  update_params(c);

  for lf=p.lf
    cgf = get(m,'cut_glotflow');
    lf.tp = lf.tp+lf.t0;
    lf.te = lf.te+lf.t0;
    [u,g] = glottal_lf(get(m,'f0'),cgf.time.fs,1,lf);
    axes(c.flowAxes);
    hold on;
    plot(u,'Color', [0	0.4	0]);
    hold off;
    axes(c.dflowAxes);
    hold on;
    plot(g,'Color', [0	0.4	0]);
    hold off;
  end
end

%%%%
function r=isTrue(s,k)

r=isfield(s,k) && s.(k);

  
%%%%
function setOrigFs(c)

sfs = '';

fs = call('get',c.model,'orig_fs');
sfs = num2str(fs);
o = findobj(c.hObject,'Tag','popupmenuResample');
menu = get(o,'String');
menu{1} = [ 'Original (' sfs ')' ];

set(findobj(c.hObject,'Tag','popupmenuResample'),'String',menu);

%%%%
function setFs(c)

m = deref(c.model);
sp = get(m,'speech_pressure');
% only update the fields if a signal is loaded
if isa(sp,'signal')
  origfs = get(m,'orig_fs');
  o = findobj(c.hObject,'Tag', 'popupmenuResample');

  fs = sp.time.fs;
  if origfs==fs
    % first item is 'No'
    set(o,'Value',1)
  else
    % set the menu to closest matching item
    vals = str2double(get(o,'String'));
    [foo,idx] = min(abs(vals-fs));
    set(o,'Value',idx);
  end
end


function updateSelAppData(c)

sppres_sel = get(deref(c.model),'sppres_selection');
setappdata(c.signalAxes,'sel',sppres_sel);

glottal_sel = get(deref(c.model),'glottal_selection');
setappdata(c.flowAxes,'sel',glottal_sel);
setappdata(c.dflowAxes,'sel',glottal_sel);

%%% KIRSCH: i want some exploration possibility
arrayfun(@(in)axtoolbar(in,'default'),[c.flowAxes c.dflowAxes c.signalAxes]);
%%%



function setSelSizeWidgets(c)

sel = get(deref(c.model),'sppres_selection');
if isfield(sel,'left') && isfield(sel,'right')
  selsize = sel.right-sel.left;
else
  selsize = 0;
end
speech_pressure = get(deref(c.model),'speech_pressure');

set(findobj(c.hObject,'Tag','editSelSizeMs'),'String', ...
		  num2str(round(selsize)));
if isobject(speech_pressure)
  set(findobj(c.hObject,'Tag','editSelSizeSamp'),'String', ...
    num2str(round(sel.left)));
end


function setChannels(c)

set(findobj(c.hObject,'Tag','radioCh1'),'Value', ...
		  get(deref(c.model),'curchannel')==1);
set(findobj(c.hObject,'Tag','radioCh2'),'Value', ...
		  get(deref(c.model),'curchannel')==2);



function setChannelVisibility(c)

%if length(get(deref(c.model),'orig_sppres'))==1
%  set(findobj(c.hObject,'Tag','radioCh2'),'Visible','off');
%else
%  set(findobj(c.hObject,'Tag','radioCh2'),'Visible','on');
%end

function setFlipped(c)

set(findobj(c.hObject,'Tag','checkFlipped'),'Value', ...
		  get(deref(c.model),'flipped'));


function setIFQuality(c)
quality = get(deref(c.model),'ifquality');
set(findobj(c.hObject,'Tag','editQuality'),'String',num2str(quality));

function setNotes(c)

set(findobj(c.hObject,'Tag','editNotes'),'String', ...
		  char(get(deref(c.model),'notes')));

function setF0(c)

set(findobj(c.hObject,'Tag','textF0'),'String', ...
		  num2str(round(get(deref(c.model),'f0'))));

function setCurfile(c)

n=get(deref(c.model),'curfile');
if length(n)>0
  set(findobj(c.hObject,'Tag','listFiles'),'Value', ...
		    get(deref(c.model),'curfile'));
end
