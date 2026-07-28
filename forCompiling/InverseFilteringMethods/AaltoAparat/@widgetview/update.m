function update(c,event)

switch event
 case 'init'
  setIFWidgets(c);
  setHpfreq(c);
  setAutohpfreq(c);
  setFilelist(c);
  setChannels(c);
 case 'ifopts'
  setIFWidgets(c);
 case 'hpfreq'
  setHpfreq(c);
 case 'f0'
  highlightHpfreq(c);
 case 'filelist'
  setFilelist(c);
 case 'curchannel'
  setChannels(c);
 case 'curfile'
  setCurfile(c);
 case 'flipped'
  setFlipped(c);
 case 'autohpfreq'
  setAutohpfreq(c);
 case 'prefilter'
  setPrefilter(c);
 otherwise
end


function setIFWidgets(c)

method = call('get',c.model,'ifmethod');
switch method
    case 'qcp'
        metVal = 1;
    case 'iaif'
        metVal = 2;
    otherwise
        metVal = 3;
end
set(findobj(c.hObject,'Tag','popupmenuIFmethod'),'Value',metVal);

ifopts = call('get',c.model,'ifopts');
set(findobj(c.hObject,'Tag','editFormnum'),'String',num2str(ifopts.p/2));
set(findobj(c.hObject,'Tag','editLiprad'),'String',num2str(ifopts.rho));
set(findobj(c.hObject,'Tag','editDQ'),'String',num2str(ifopts.dq));
set(findobj(c.hObject,'Tag','editPQ'),'String',num2str(ifopts.pq));
set(findobj(c.hObject,'Tag','editNramp'),'String',num2str(ifopts.nramp));
switch ifopts.arfunc
     case 'dap'
        arVal = 1;
     case 'lpc'
         arVal = 2;
     otherwise
         arVal = 3;
end
set(findobj(c.hObject,'Tag','popupARMethod'),'Value',arVal);
%set(findobj(c.hObject,'Tag','editR'),'String',num2str(ifopts.r));
set(findobj(c.hObject,'Tag','editG'),'String',num2str(ifopts.g));


function setHpfreq(c)

freq = call('get',c.model,'hpfreq');
set(findobj(c.hObject,'Tag','editHpfreq'),'String',num2str(freq));

function highlightHpfreq(c)

fhp = call('get',c.model,'hpfreq');
f0 = call('get',c.model,'f0');

if f0<fhp
  set(findobj(c.hObject,'Tag','editHpfreq'),'BackgroundColor',[1 0 0]);
  msgbox('Cutoff frequency is higher than f0.','Cutoff frequency too high', ...
         'warn');
else
  set(findobj(c.hObject,'Tag','editHpfreq'),'BackgroundColor',[1 1 1]);
end

function setAutohpfreq(c)

enabled = call('get',c.model,'autohpfreq');

if enabled
  set(findobj(c.hObject,'Tag','editHpfreq'),'Enable','inactive');
else
  set(findobj(c.hObject,'Tag','editHpfreq'),'Enable','on');
end

set(findobj(c.hObject,'Tag','autoHpfreq'),'Value', enabled);


function setFilelist(c)

fl = call('get',c.model,'filelist');
list = {'foo'};
for i=1:length(fl)
  if fl(i).saved
    list{i} = ['* ' fl(i).name];
  else
    list{i} = fl(i).name;
  end
end
set(findobj(c.hObject,'Tag','listFiles'),'String', list);

function setPrefilter(c)

v = call('get',c.model,'prefilter');
if v==0
  ch = 'off';
else
  ch = 'on';
end
  
set(findobj(c.hObject,'Tag','menuApplyPrefilter'),'Checked', ch);

function setChannels(c)

set(findobj(c.hObject,'Tag','radioChannelOne'),'Value', ...
		  call('get',c.model,'curchannel')==1);
set(findobj(c.hObject,'Tag','radioChannelTwo'),'Value', ...
		  call('get',c.model,'curchannel')==2);


function setFlipped(c)

set(findobj(c.hObject,'Tag','checkFlipped'),'Value', ...
		  call('get',c.model,'flipped'));

function setIFQuality(c)
quality = get(deref(c.model),'ifquality');
set(findobj(c.hObject,'Tag','editQuality'),'String', ...
		  num2str(quality));

function setCurfile(c)

n=call('get',c.model,'curfile');
if length(n)>0
  set(findobj(c.hObject,'Tag','listFiles'),'Value', ...
		    call('get',c.model,'curfile'));
end
