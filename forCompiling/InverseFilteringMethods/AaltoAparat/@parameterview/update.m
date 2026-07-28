function update(c,event)

switch event
 case 'init'
  setParams(c);
  setLFParams(c);
  setGrouping(c);
 case 'params'
  setParams(c);
 case 'lffit'
  setLFParams(c);
 case 'param_grouping_func'
  setGrouping(c);
 case 'destroy'
   try
     fig = c.hObject;
     delete(fig);
   catch
   end
 otherwise
end


function setParams(c)

grpfunc = get(deref(c.model),'param_grouping_func');

p = get(deref(c.model),'params');

if length(fieldnames(p))>0
  set(findobj(c.hObject,'Tag','editNAQ'),...
    'String',setOutput(grpfunc,[p.t.NAQ]));
  set(findobj(c.hObject,'Tag','editAQ'),...
    'String',setOutput(grpfunc,1000*[p.t.AQ]));
  set(findobj(c.hObject,'Tag','editClQ'),...
    'String',setOutput(grpfunc,[p.t.ClQ]));
  set(findobj(c.hObject,'Tag','editOQ1'),...
    'String',setOutput(grpfunc,[p.t.OQ1]));
  set(findobj(c.hObject,'Tag','editOQ2'),...
    'String',setOutput(grpfunc,[p.t.OQ2]));
  set(findobj(c.hObject,'Tag','editOQa'),...
    'String',setOutput(grpfunc,[p.t.OQa]));
  set(findobj(c.hObject,'Tag','editQOQ'),...
    'String',setOutput(grpfunc,[p.t.QOQ]));
  set(findobj(c.hObject,'Tag','editSQ1'),...
    'String',setOutput(grpfunc,[p.t.SQ1]));
  set(findobj(c.hObject,'Tag','editSQ2'),...
    'String',setOutput(grpfunc,[p.t.SQ2]));
  
  set(findobj(c.hObject,'Tag','editDH12'),...
    'String',setOutput(grpfunc,p.f.DH12));
  set(findobj(c.hObject,'Tag','editPSP'),...
    'String',setOutput(grpfunc,p.f.PSP));
  set(findobj(c.hObject,'Tag','editHRF'),...
    'String',setOutput(grpfunc,p.f.HRF));
end

function setLFParams(c)

grpfunc = get(deref(c.model),'param_grouping_func');

p = get(deref(c.model),'params');

if length(fieldnames(p))>0 && length(fieldnames(p.lf))>0
  set(findobj(c.hObject,'Tag','editTp'),...
      'String',setOutput(grpfunc,1000*[p.lf.tp]));
  set(findobj(c.hObject,'Tag','editTe'),...
      'String',setOutput(grpfunc,1000*[p.lf.te]));
  set(findobj(c.hObject,'Tag','editTa'),...
      'String',setOutput(grpfunc,1000*[p.lf.ta]));
  set(findobj(c.hObject,'Tag','editEe'),...
      'String',setOutput(grpfunc,[p.lf.Ee]));
else
  set(findobj(c.hObject,'Tag','editTp'),...
      'String','');
  set(findobj(c.hObject,'Tag','editTe'),...
      'String','');
  set(findobj(c.hObject,'Tag','editTa'),...
      'String','');
  set(findobj(c.hObject,'Tag','editEe'),...
      'String','');
end  

function setGrouping(c)

setParams(c)


function b=setOutput(grpfunc,a)

if length(a)>0
  b=sprintf('%.3f', grpfunc(a));
else
  b='';
end
  
  
%function setHPFreq(c)

%freq = get(deref(c.model),'hpfreq');
%set(findobj(c.hObject,'Tag','textHpfreq'),'String',num2str(freq));


%function setIaifOpts(c)

%ifopts = get(deref(c.model),'ifopts');

%if isfield(ifopts,'rho')
%  set(findobj(c.hObject,'Tag','editRho'),'String', ...
%		    num2str(ifopts.rho));
%end
%if isfield(ifopts,'p')
%  set(findobj(c.hObject,'Tag','editP'),'String', ...
%		    num2str(ifopts.p));
%end
%if isfield(ifopts,'g')
%  set(findobj(c.hObject,'Tag','editG'),'String', ...
%		    num2str(ifopts.g));
%end
%if isfield(ifopts,'r')
%  set(findobj(c.hObject,'Tag','editR'),'String', ...
%		    num2str(ifopts.r));
%end
