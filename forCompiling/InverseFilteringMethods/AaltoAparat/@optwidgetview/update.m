function update(c,event)

switch event
 case 'init'
  setHPFreq(c);
  setIfopts(c);
 case 'hpfreq'
  setHPFreq(c);
 case 'ifopts'
  setIfopts(c);
 case 'destroy'
   try
     fig = c.hObject;
     delete(fig);
   catch
   end
 otherwise
end



function setHPFreq(c)

freq = get(deref(c.model),'hpfreq');
set(findobj(c.hObject,'Tag','textHpfreq'),'String',num2str(freq));


function setIfopts(c)

ifopts = get(deref(c.model),'ifopts');

if isfield(ifopts,'rho')
  set(findobj(c.hObject,'Tag','editRho'),'String', ...
		    num2str(ifopts.rho));
end
if isfield(ifopts,'p')
  set(findobj(c.hObject,'Tag','editP'),'String', ...
		    num2str(ifopts.p));
end
if isfield(ifopts,'g')
  set(findobj(c.hObject,'Tag','editG'),'String', ...
		    num2str(ifopts.g));
end
if isfield(ifopts,'r')
  set(findobj(c.hObject,'Tag','editR'),'String', ...
		    num2str(ifopts.r));
end
