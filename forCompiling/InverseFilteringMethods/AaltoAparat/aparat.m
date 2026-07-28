function varargout = aparat(varargin)
% APARAT M-file for aparat.fig
%      APARAT, by itself, creates a new APARAT or raises the existing
%      singleton*.
%
%      H = APARAT returns the handle to a new APARAT or the handle to
%      the existing singleton*.
%
%      APARAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APARAT.M with the given input arguments.
%
%      APARAT('Property','Value',...) creates a new APARAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aparat_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aparat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to menu_help aparat

% Last Modified by GUIDE v2.5 20-May-2015 12:35:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aparat_OpeningFcn, ...
                   'gui_OutputFcn',  @aparat_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before aparat is made visible.
function aparat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aparat (see VARARGIN)

% Choose default command line output for aparat
handles.output = hObject;

sig = [];
ifopts = struct;
if nargin>3
  sig = varargin{1};
  if nargin>4
    ifopts = varargin{2};
  end
end

%%%%%%% MVC stuff

% init model

mdl = model(sig,ifopts);
handles.model = get(mdl,'this');

% init views

sigs(handles.model);

% widget view
vw4 = widgetview(handles.model,hObject);

% autoexportview
vw5 = autoexportview(handles.model);


% Update handles structure
guidata(hObject, handles);

% open the current directory
call('set',handles.model,'directory',pwd);

% UIWAIT makes aparat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = aparat_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function editFormnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFormnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editFormnum_Callback(hObject, eventdata, handles)
% hObject    handle to editFormnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFormnum as text
%        str2double(get(hObject,'String')) returns contents of editFormnum as a double

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  n = round(str2double(get(hObject,'String')));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.p = 2*n;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end



% --- Executes during object creation, after setting all properties.
function editLiprad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLiprad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLiprad_Callback(hObject, eventdata, handles)
% hObject    handle to editLiprad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLiprad as text
%        str2double(get(hObject,'String')) returns contents of editLiprad as a double

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  rho = str2double(get(hObject,'String'));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.rho = rho;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in checkCausality.
function checkCausality_Callback(hObject, eventdata, handles)
% hObject    handle to checkCausality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkausality

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;
  
  causality = get(hObject,'Value');

  ifopts = call('get',handles.model,'ifopts');
  ifopts.causality = causality;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --------------------------------------------------------------------
function menuFileExit_Callback(hObject, eventdata, handles)
% hObject    handle to menuFileExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  call('destroy',handles.model);
catch
  % ignore errors
end
% Close the figure
close(handles.output);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  % fig1 won't close if we use the call syntax here
  destroy(deref(handles.model));
catch
  % ignore errors
end

% Hint: delete(hObject) closes the figure
delete(hObject);

%% --- All Callbacks under Menu -> File
% --- Executes on click on File -> Open Directory
function menuFileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuFileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = uigetdir(call('get',handles.model,'directory'));

if d
  call('set',handles.model,'directory',d);
end

% --- Executes on click on File -> Save as .mat -file
function menuSaveMat_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

m = deref(handles.model);
fname = get(m,'curfilename');
[pathstr,name,ext] = fileparts(fname);

save(deref(handles.model));
msgbox(['All data saved to the file "' name '.mat"' '.'],'File saved');

% --- Executes on click on File -> Export as .wav.
function menuSaveWav_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m = deref(handles.model);
fname = get(m,'curfilename');
[pathstr,name,ext] = fileparts(fname);

call('wavsave',handles.model);


% % --- Former IAIF settings on Tool bar menu
% function menuWindowParams_Callback(hObject, eventdata, handles)
% % hObject    handle to menuWindowParams (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% aparatopts(handles.model);


% --- Executes during object creation, after setting all properties.
function listFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listFiles.
function listFiles_Callback(hObject, eventdata, handles)
% hObject    handle to listFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFiles

curf = gcf;
set(curf,'Pointer','watch');
drawnow;

call('set',handles.model,'curfile',get(hObject,'Value'));

%If the chosen .wav -file already has a saved .mat -file the calculation
%method is taken from this saved file. In this case let's check if methods
%settings should be visible or not
if strcmp(call('get',handles.model,'ifmethod'),'qcp')
    set( findall(handles.QCPsettings, '-property', 'Visible'), 'Visible', ...
    'on');
    set( findall(handles.IAIFsettings, '-property', 'Visible'), 'Visible', ...
    'off');
elseif strcmp(call('get',handles.model,'ifmethod'),'iaif')
    set( findall(handles.IAIFsettings, '-property', 'Visible'), 'Visible', ...
    'on');
    set( findall(handles.QCPsettings, '-property', 'Visible'), 'Visible', ...
    'off');
end

if length(call('get',handles.model,'orig_sppres')) > 0
  set(handles.menuRightChannel,'Enable','on');
  set(handles.menuLeftChannel,'Enable','on');
  set(handles.menuEGGinOther,'Enable','on');
  set(handles.menuEGGdelay,'Enable','on');
else
  set(handles.menuRightChannel,'Enable','off');
  set(handles.menuLeftChannel,'Enable','on');
  set(handles.menuEGGinOther,'Enable','off');
  set(handles.menuEGGdelay,'Enable','off');
end
set(curf,'Pointer','arrow');



% --------------------------------------------------------------------
function menuApplyPrefilter_Callback(hObject, eventdata, handles)
% hObject    handle to menuApplyPrefilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cur = call('get',handles.model,'prefilter');
call('set',handles.model,'prefilter',~cur);
if cur
  set(hObject,'Checked','off');
else
  set(hObject,'Checked','on');
end

% --------------------------------------------------------------------
function menuShowZPlane_Callback(hObject, eventdata, handles)
% hObject    handle to menuShowZPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zplaneh = figure('Name','Z-Plane','NumberTitle','off');
zplaneh1 = axes;
vw3 = zplaneview(handles.model,zplaneh1);
guidata(zplaneh, handles);

% --------------------------------------------------------------------
function menuShowVocalTract_Callback(hObject, eventdata, handles)
% hObject    handle to menuShowVocalTract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vocaltracth = figure('Name','Vocal Tract','NumberTitle','off');
vocaltracth1 = axes;
vw4 = vocaltractview(handles.model,vocaltracth1);
guidata(vocaltracth, handles);


% --------------------------------------------------------------------
function menuShowPhaseplane_Callback(hObject, eventdata, handles)
% hObject    handle to menuShowPhaseplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

phaseh = figure('Name','Phase-plane','NumberTitle','off');
phaseh1 = subplot(1,1,1);
vw6 = phaseview(handles.model,phaseh1);
guidata(phaseh, handles);

% --------------------------------------------------------------------
function menuShowParams_Callback(hObject, eventdata, handles)
% hObject    handle to menuShowParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

params(handles.model);

% --------------------------------------------------------------------
function menuShowSpectra_Callback(hObject, eventdata, handles)
% hObject    handle to menuShowSpectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spectra(handles.model);


% --- Executes during object creation, after setting all properties.
function editHpfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHpfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editHpfreq_Callback(hObject, eventdata, handles)
% hObject    handle to editHpfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHpfreq as text
%        str2double(get(hObject,'String')) returns contents of editHpfreq as a double

freq = str2double(get(hObject,'String'));
call('set',handles.model,'hpfreq',freq);



% --- Executes on button press in checkAutohpfreq.
function checkAutohpfreq_Callback(hObject, eventdata, handles)
% hObject    handle to checkAutohpfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkAutohpfreq

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;
  
  call('set',handles.model,'autohpfreq',get(hObject,'Value'));
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on selection change in popupmenuIFmethod.
function popupmenuIFmethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIFmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuIFmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuIFmethod

ss = get(hObject,'String');

curf = gcf;
set(curf,'Pointer','watch');
drawnow;

v = lower(ss(get(hObject,'Value')));
ifmethod = call('get',handles.model,'ifmethod');
ifmethod = v{1};

if strcmp(ifmethod,'qcp') 
    set( findall(handles.QCPsettings, '-property', 'Visible'), 'Visible', ...
    'on');
    set( findall(handles.IAIFsettings, '-property', 'Visible'), 'Visible', ...
    'off');
elseif strcmp(ifmethod,'iaif')
    set( findall(handles.IAIFsettings, '-property', 'Visible'), 'Visible', ...
    'on');
    set( findall(handles.QCPsettings, '-property', 'Visible'), 'Visible', ...
    'off');
end

call('set',handles.model,'ifmethod',ifmethod);
set(curf,'Pointer','arrow');


% --- Executes during object creation, after setting all properties.
function popupmenuIFmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIFmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',{'QCP','IAIF'});

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuLeftChannel_Callback(hObject, eventdata, handles)
% hObject    handle to menuLeftChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

call('set',handles.model,'curchannel',1);
set(handles.menuRightChannel,'Checked','off');
set(handles.menuLeftChannel,'Checked','on');


% --------------------------------------------------------------------
function menuRightChannel_Callback(hObject, eventdata, handles)
% hObject    handle to menuRightChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

call('set',handles.model,'curchannel',2);
set(handles.menuRightChannel,'Checked','on');
set(handles.menuLeftChannel,'Checked','off');



% --------------------------------------------------------------------
function menuEGGinOther_Callback(hObject, eventdata, handles)
% hObject    handle to menuEGGinOther (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if call('get',handles.model,'egginother')
    set(handles.menuEGGinOther,'Checked','off');
    call('set',handles.model,'egginother',0);
else
    set(handles.menuEGGinOther,'Checked','on');
    call('set',handles.model,'egginother',1);
    s = call('get',handles.model,'orig_sppres');
    call('set',handles.model,'orig_egg',s{2});
    ego = shift(call('get',handles.model,'orig_egg'), ...
                call('get',handles.model,'eggdelay')/1000);
    call('set',handles.model,'egg',ego);
end

% --------------------------------------------------------------------
function menuEGGdelay_Callback(hObject, eventdata, handles)
% hObject    handle to menuEGGdelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

EGGdelay = num2str(call('get',handles.model,'eggdelay'));
answer = inputdlg('Give EGG delay (milliseconds)','EGG delay', 1, {EGGdelay});
if length(answer) ~= 0
    EGGdelay = str2num(answer{:});
    ego = shift(call('get',handles.model,'orig_egg'),EGGdelay/1000);
    call('set',handles.model,'egg',ego);
end
call('set',handles.model,'eggdelay',EGGdelay);    


% --------------------------------------------------------------------
function menuEGGdelaycm_Callback(hObject, eventdata, handles)
% hObject    handle to menuEGGdelaycm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


EGGdelay = call('get',handles.model,'eggdelay');
EGGcm = num2str((EGGdelay*350/10)-17);
answer = inputdlg({'Give mouth-to-microphone distance (centimeters)','Speed of sound (m/s)'},'EGG delay', 1, {EGGcm,num2str(350)});
if length(answer) ~= 0
    EGGcm = str2num(answer{1})+17;  % distance from mouth to microphone plus ...
                                    % distance from glottis to mouth (17cm)
    sos = str2num(answer{2});
    EGGdelay = 10*EGGcm/sos;
    ego = shift(call('get',handles.model,'orig_egg'),EGGdelay/1000);
    call('set',handles.model,'egg',ego);
end
call('set',handles.model,'eggdelay',EGGdelay);    


% --------------------------------------------------------------------
function menuEGG_Callback(hObject, eventdata, handles)
% hObject    handle to menuEGG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% % --------------------------------------------------------------------
% function menu_Tools_Callback(hObject, eventdata, handles)
% % hObject    handle to menu_Tools (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --------------------------------------------------------------------
% function menuAutoIAIF_Callback(hObject, eventdata, handles)
% % hObject    handle to menuAutoIAIF (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
%   
%   call('set',handles.model,'automodel',0);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end


% --- Executes on button press in btnIncFormnum1.
function btnIncFormnum1_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncFormnum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.p = ifopts.p+2;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on button press in btnIncFormnum2.
function btnIncFormnum2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncFormnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.p = ifopts.p+4;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecFormnum1.
function btnDecFormnum1_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecFormnum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.p = ifopts.p-2;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecFormnum2.
function btnDecFormnum2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecFormnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.p = ifopts.p-4;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on button press in btnIncLiprad1.
function btnIncLiprad1_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncLiprad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.rho = ifopts.rho+0.005;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncLiprad2.
function btnIncLiprad2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncLiprad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.rho = ifopts.rho+0.01;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecLiprad1.
function btnDecLiprad1_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecLiprad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.rho = ifopts.rho-0.005;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecLiprad2.
function btnDecLiprad2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecLiprad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.rho = ifopts.rho-0.01;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncHpfreq1.
function btnIncHpfreq1_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncHpfreq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  f = call('get',handles.model,'hpfreq');
  f = f+10;
  
  call('set',handles.model,'hpfreq',f);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncHpfreq2.
function btnIncHpfreq2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncHpfreq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  f = call('get',handles.model,'hpfreq');
  f = f+50;
  
  call('set',handles.model,'hpfreq',f);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecHpfreq1.
function btnDecHpfreq1_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecHpfreq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  f = call('get',handles.model,'hpfreq');
  f = f-10;
  
  call('set',handles.model,'hpfreq',f);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecHpfreq2.
function btnDecHpfreq2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecHpfreq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  f = call('get',handles.model,'hpfreq');
  f = f-50;
  
  call('set',handles.model,'hpfreq',f);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on button press in pushbuttonPickFormants.
function pushbuttonPickFormants_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickFormants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'p');
guidata(multih, handles);


% --- Executes on button press in pushbuttonPickLiprad.
function pushbuttonPickLiprad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickLiprad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'rho');
guidata(multih, handles);


% --------------------------------------------------------------------
function menuCombineMatFiles_Callback(hObject, eventdata, handles)
% hObject    handle to menuCombineMatFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = call('get',handles.model,'directory');
curdir = chdir;
chdir(d);
aggregate('combined.tab');
chdir(curdir);


% --------------------------------------------------------------------
function menuRemoveRealPoles_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveRealPoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ifopts = call('get',handles.model,'ifopts');

if isfield(ifopts,'remove_real_poles') & ifopts.remove_real_poles
  set(handles.menuRemoveRealPoles,'Checked','off');
  ifopts.remove_real_poles = 0;
else
  set(handles.menuRemoveRealPoles,'Checked','on');
  ifopts.remove_real_poles = 1;
end
call('set',handles.model,'ifopts',ifopts);


% --------------------------------------------------------------------
function menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuAbout_Callback(hObject, eventdata, handles)
% hObject    handle to menuAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%r = globalrev;
r = '2';

msg = {'', ...
  'Aalto Aparat:', ...
  'Aalto Voice Source Analysis and Parameterization Toolkit', ...
    '', ...
  'See http://www.aalto.fi/aparat for FAQ and Manual',...
  '', ...
  ['Revision: ' r], ...
  '', ...
  'Copyright 2003-2008, Matti Airas and others.', ...
  '                2015, Hilla Pohjalainen and others.', ...
  '', ...
  'Aalto Aparat is licenced under GNU LGPL v 2.1. See the COPYING file for details.', ...
   };

msgbox(msg,'About Aalto Aparat','help');

  
%% Update from 2015 starts here
% The following functions are ONLY for QCP method, and not supposed to be visible when using 
% other methods. Later down there's a similar set for IAIF as well.


% --- Executes during object creation, after setting all properties.
function editDQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDQ_Callback(hObject, eventdata, handles)
% hObject    handle to editDQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDQ as text
%        str2double(get(hObject,'String')) returns contents of editDQ as a double
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  dq = str2double(get(hObject,'String'));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.dq = dq;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in pushbuttonPickDQ.
function pushbuttonPickDQ_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickFormants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'dq');
guidata(multih, handles);

% --- Executes on button press in btnDecDQ.
function btnDecDQ_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecDQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.dq = ifopts.dq-0.05;
  
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
  
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncDQ.
function btnIncDQ_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncDQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.dq = ifopts.dq+0.05;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
  
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecDQ2.
function btnDecDQ2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecDQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.dq = ifopts.dq-0.1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
  
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncDQ2.
function btnIncDQ2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncDQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.dq = ifopts.dq+0.1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
  
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes during object creation, after setting all properties.
function editPQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editPQ_Callback(hObject, eventdata, handles)
% hObject    handle to editPQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDQ as text
%        str2double(get(hObject,'String')) returns contents of editDQ as a double
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  pq = str2double(get(hObject,'String'));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.pq = pq;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in pushbuttonPickPQ.
function pushbuttonPickPQ_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickFormants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'pq');
guidata(multih, handles);

% --- Executes on button press in btnDecPQ.
function btnDecPQ_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecPQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.pq = ifopts.pq-0.01;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncPQ.
function btnIncPQ_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncPQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.pq = ifopts.pq+0.01;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecPQ2.
function btnDecPQ2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecPQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.pq = ifopts.pq-0.02;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncPQ2.
function btnIncPQ2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncPQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.pq = ifopts.pq+0.02;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes during object creation, after setting all properties.
function editNramp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNramp_Callback(hObject, eventdata, handles)
% hObject    handle to editNramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDQ as text
%        str2double(get(hObject,'String')) returns contents of editDQ as a double
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  nramp = str2double(get(hObject,'String'));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.nramp = nramp;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in pushbuttonPickNramp.
function pushbuttonPickNramp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickNramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'nramp');
guidata(multih, handles);


% --- Executes on button press in btnDecNramp.
function btnDecNramp_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecNramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.nramp = ifopts.nramp-1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncNramp.
function btnIncNramp_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncNramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.nramp = ifopts.nramp+1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecNramp2.
function btnDecNramp2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecNramp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.nramp = ifopts.nramp-3;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnIncNramp2.
function btnIncNramp2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncNramp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.nramp = ifopts.nramp+3;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


%% IAIF special parameter settings start here
%In the first release of Aparat these were hidden behind programm menu, now
%they show up when choosing IAIF as a method

% --- Executes during object creation, after setting all properties.
function popupARMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupARMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',{'DAP','LPC','MVDR'});

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupARMethod.
function popupARMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupARMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupARMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupARMethod

ss = get(hObject,'String');
try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  arfunc = lower(ss(get(hObject,'Value')));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.arfunc = arfunc{1};
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% % --- Executes during object creation, after setting all properties.
% function editR_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to editR (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% function editR_Callback(hObject, eventdata, handles)
% % hObject    handle to editR (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of editR as text
% %        str2double(get(hObject,'String')) returns contents of editR as a double
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
% 
%   r = str2double(get(hObject,'String'));
% 
%   ifopts = call('get',handles.model,'ifopts');
%   ifopts.r = r;
%   
%   call('set',handles.model,'ifopts',ifopts);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end
% 
% % --- Executes on button press in pushbuttonPickR.
% function pushbuttonPickR_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbuttonPickR (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% multih = figure('Name','Pick the best waveform','NumberTitle','off');
% vw = multiview(handles.model,multih,'r');
% guidata(multih, handles);
% 
% % --- Executes on button press in btnIncR1.
% function btnIncR1_Callback(hObject, eventdata, handles)
% % hObject    handle to btnIncR1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
% 
%   ifopts = call('get',handles.model,'ifopts');
%   ifopts.r = ifopts.r+1;
%   
%   call('set',handles.model,'ifopts',ifopts);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end
% 
% 
% % --- Executes on button press in btnIncR2.
% function btnIncR2_Callback(hObject, eventdata, handles)
% % hObject    handle to btnIncR2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
% 
%   ifopts = call('get',handles.model,'ifopts');
%   ifopts.r = ifopts.r+2;
%   
%   call('set',handles.model,'ifopts',ifopts);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end
% 
% % --- Executes on button press in btnDecR1.
% function btnDecR1_Callback(hObject, eventdata, handles)
% % hObject    handle to btnDecR1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
% 
%   ifopts = call('get',handles.model,'ifopts');
%   ifopts.r = ifopts.r-1;
%   
%   call('set',handles.model,'ifopts',ifopts);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end
% 
% % --- Executes on button press in btnDecR2.
% function btnDecR2_Callback(hObject, eventdata, handles)
% % hObject    handle to btnDecR2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% try
%   curf = gcf;
%   set(curf,'Pointer','watch');
%   drawnow;
% 
%   ifopts = call('get',handles.model,'ifopts');
%   ifopts.r = ifopts.r-2;
%   
%   call('set',handles.model,'ifopts',ifopts);
%   set(curf,'Pointer','arrow');
% catch
%   set(curf,'Pointer','arrow');
%   rethrow(lasterror);
% end

% --- Executes during object creation, after setting all properties.
function editG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editG_Callback(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editG as text
%        str2double(get(hObject,'String')) returns contents of editG as a double

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  g = str2double(get(hObject,'String'));

  ifopts = call('get',handles.model,'ifopts');
  ifopts.g = g;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in pushbuttonPickG.
function pushbuttonPickG_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPickG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

multih = figure('Name','Pick the best waveform','NumberTitle','off');
vw = multiview(handles.model,multih,'g');
guidata(multih, handles);

% --- Executes on button press in btnIncG1.
function btnIncG1_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.g = ifopts.g+1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end


% --- Executes on button press in btnIncG2.
function btnIncG2_Callback(hObject, eventdata, handles)
% hObject    handle to btnIncG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.g = ifopts.g+2;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecG1.
function btnDecG1_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.g = ifopts.g-1;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end

% --- Executes on button press in btnDecG2.
function btnDecG2_Callback(hObject, eventdata, handles)
% hObject    handle to btnDecG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
  curf = gcf;
  set(curf,'Pointer','watch');
  drawnow;

  ifopts = call('get',handles.model,'ifopts');
  ifopts.g = ifopts.g-2;
  
  call('set',handles.model,'ifopts',ifopts);
  set(curf,'Pointer','arrow');
catch
  set(curf,'Pointer','arrow');
  rethrow(lasterror);
end