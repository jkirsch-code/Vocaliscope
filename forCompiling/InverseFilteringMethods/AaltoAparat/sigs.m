function varargout = sigs(varargin)
% SIGS M-file for sigs.fig
%      SIGS, by itself, creates a new SIGS or raises the existing
%      singleton*.
%
%      H = SIGS returns the handle to a new SIGS or the handle to
%      the existing singleton*.
%
%      SIGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGS.M with the given input arguments.
%
%      SIGS('Property','Value',...) creates a new SIGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sigs_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sigs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sigs

% Last Modified by GUIDE v2.5 14-Sep-2015 16:19:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sigs_OpeningFcn, ...
                   'gui_OutputFcn',  @sigs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sigs is made visible.
function sigs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sigs (see VARARGIN)

% Choose default command line output for sigs
handles.output = hObject;

handles.model = varargin{1};

vw = sigview(handles.model,hObject);
handles.vw = get(vw,'this');

%%
% find user interface elements and store their positions for
% resizing the screen

setappdata(hObject,'origPosition',get(hObject,'Position'));

tags = {'panelSignal','panelSelection','panelMeta', ...
	'pushbuttonSave', 'pushbuttonSaveWav','signalAxes','flowAxes','dflowAxes'};
for s=tags
  h = findobj(hObject, 'Tag',s{:});
  setappdata(h,'origPosition',get(h,'Position'));
end

handles.sa = findobj(hObject,'Tag','signalAxes');
handles.fa = findobj(hObject,'Tag','flowAxes');
handles.da = findobj(hObject,'Tag','dflowAxes');

% Update handles structure
guidata(hObject, handles);

linkaxes([handles.fa handles.da],'x');

% UIWAIT makes sigs wait for user response (see UIRESUME)
% uiwait(handles.sigfig);


% --- Outputs from this function are returned to the command line.
function varargout = sigs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function sigfig_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ax = overaxes(hObject);
call('event',handles.vw,'btn_down',ax);

% --- Executes on mouse motion over figure - except title and menu.
function sigfig_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ax = overaxes(hObject);
call('event',handles.vw,'motion',ax);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function sigfig_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curf = gcf;
set(curf,'Pointer','watch');
drawnow;

ax = overaxes(hObject);
call('event',handles.vw,'btn_up',ax);

set(curf,'Pointer','arrow');


% --- Executes during object creation, after setting all properties.
function editSelSizeMs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSelSizeMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function editSelSizeSamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSelSizeSamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editQuality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editquality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editNotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkFixedSelSize.
function checkFixedSelSize_Callback(hObject, eventdata, handles)
% hObject    handle to checkFixedSelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkFixedSelSize

%set(deref(handles.model),'fixedifwinsize',get(hObject,'Value'));
call('set',handles.model,'fixedifwinsize',get(hObject,'Value'));



function editSelSizeMs_Callback(hObject, eventdata, handles)
% hObject    handle to editWinsizems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWinsizems as text
%        str2double(get(hObject,'String')) returns contents of editWinsizems as a double

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  %set(deref(handles.model),'ifwinsize',str2double(get(hObject,'String'))/
  %...
  call('set',handles.model,'ifwinsize',str2double(get(hObject,'String')));
  
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


function editSelSizeSamp_Callback(hObject, eventdata, handles)
% hObject    handle to editWinsizesamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWinsizesamp as text
%        str2double(get(hObject,'String')) returns contents of editWinsizesamp as a double

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  %s = call('get',handles.model,'speech_pressure');
  %set(deref(handles.model),'ifwinsize',str2double(get(hObject,'String'))/s.fs);
  call('set',handles.model,'ifwinplace',str2double(get(hObject,'String')));

set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

function editQuality_Callback(hObject, eventdata, handles)
% hObject    handle to editQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQuality as text
%        str2double(get(hObject,'String')) returns contents of editQuality as a double

%set(deref(handles.model),'notes',round(get(hObject,'String')));
call('set',handles.model,'ifquality',round(str2double(get(hObject,'String'))));

function editNotes_Callback(hObject, eventdata, handles)
% hObject    handle to editNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNotes as text
%        str2double(get(hObject,'String')) returns contents of editNotes as a double

%set(deref(handles.model),'notes',round(get(hObject,'String')));
call('set',handles.model,'notes',get(hObject,'String'));

% --- Executes on button press in btnSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

m = deref(handles.model);
fname = get(m,'curfilename');
[pathstr,name,ext] = fileparts(fname);

save(deref(handles.model));
msgbox(['All data saved to the file ' name '.mat' '.'],'File saved');

% --- Executes on button press in pushbuttonSaveWav.
function pushbuttonSaveWav_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m = deref(handles.model);
fname = get(m,'curfilename');
[pathstr,name,ext] = fileparts(fname);

%pura play-napin tapaan waveiksi
call('wavsave',handles.model);


% --- Executes on button press in checkFlip.
function checkFlip_Callback(hObject, eventdata, handles)
% hObject    handle to checkFlip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkFlip

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  %set(deref(handles.model),'flipped',get(hObject,'Value'));
  call('set',handles.model,'flipped',get(hObject,'Value'));

  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on button press in btnPlay.
function pushbuttonPlay_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%play(deref(handles.model));
call('play',handles.model);


% --- Executes on button press in btnSelectAll.
function pushbuttonSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  %selectall(deref(handles.model));
  call('selectall',handles.model);

  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes when sigfig is resized.
function sigfig_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

origfigPosition = getappdata(hObject,'origPosition');

% dirty hack to avoid problems due to changed functionality in Matlab 7.1
if numel(origfigPosition)==0
  return
end

origfigWidth = origfigPosition(3);
origfigHeight = origfigPosition(4);

figPosition = get(hObject,'Position');
figWidth = figPosition(3);
figHeight = figPosition(4);

figWidthDiff = figWidth-origfigWidth;
figHeightDiff = figHeight-origfigHeight;


% these elements are bound to upper right corner

urtags = {'panelSignal','panelSelection','panelMeta', ...
	  'pushbuttonSave','pushbuttonSaveWav'};
for s=urtags
  h = findobj(hObject,'Tag',s{:});
  origpos = getappdata(h,'origPosition');
  pos = get(h,'Position');
  pos(1) = origpos(1)+figWidthDiff;
  pos(2) = origpos(2)+figHeightDiff;
  set(h,'Position',pos);
end

% figure axes are scaled proportionally

% couldn't use the method above for findíng out the signal handles, since
% the axes are no longer returned by findobj. Why?? I hate MATLAB.

sa = handles.sa;
fa = handles.fa;
da = handles.da;

origsapos=getappdata(sa,'origPosition');
origfapos=getappdata(fa,'origPosition');
origdapos=getappdata(da,'origPosition');

sapos = get(sa,'Position');
fapos = get(fa,'Position');
dapos = get(da,'Position');

width = origsapos(3)+figWidthDiff;

yoff = origdapos(2);

origtotalheight = origsapos(2)+origsapos(4)-origdapos(2);
newtotalheight = origsapos(2)+origsapos(4)+figHeightDiff-origdapos(2);
yratio = newtotalheight/origtotalheight;

sapos(3) = width;
fapos(3) = width;
dapos(3) = width;

sapos(2) = yratio*(origsapos(2)-yoff)+yoff;
fapos(2) = yratio*(origfapos(2)-yoff)+yoff;

sapos(4) = yratio*origsapos(4);
fapos(4) = yratio*origfapos(4);
dapos(4) = yratio*origdapos(4);

%%% KIRSCH: I added an axtoolbar to the axes and the toolbar of the signal
%%% axes is cutoff a bit
sapos(2)=sapos(2)-0.6;
%%%

set(sa,'Position',sapos);
set(fa,'Position',fapos);
set(da,'Position',dapos);



% --- Executes on selection change in popupmenuResample.
function popupmenuResample_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuResample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuResample contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuResample

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  contents = get(hObject,'String');
  sel = contents{get(hObject,'Value')};
  seln= str2double(sel);
  if isnan(seln)
    seln=0;
  end
  %set(deref(handles.model),'fs',seln);
  call('set',handles.model,'fs',seln);
  
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes during object creation, after setting all properties.
function popupmenuResample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuResample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function multiview_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pt = get(gca,'CurrentPoint');
vw = getappdata(gcf,'view');

parname = call('get',vw,'parname');
par = call('findclosest',vw,pt(1,1:2));

m = handles.model;

ifopts = call('get',m,'ifopts');
ifopts.(parname) = par;

call('set',m,'ifopts',ifopts);


% --- Executes when user attempts to close sigfig.
function sigfig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to sigfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
