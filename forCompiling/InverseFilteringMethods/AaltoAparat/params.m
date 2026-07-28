function varargout = params(varargin)
% PARAMS M-file for params.fig
%      PARAMS, by itself, creates a new PARAMS or raises the existing
%      singleton*.
%
%      H = PARAMS returns the handle to a new PARAMS or the handle to
%      the existing singleton*.
%
%      PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMS.M with the given input arguments.
%
%      PARAMS('Property','Value',...) creates a new PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before params_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help params

% Last Modified by GUIDE v2.5 09-Jun-2006 14:30:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @params_OpeningFcn, ...
                   'gui_OutputFcn',  @params_OutputFcn, ...
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


% --- Executes just before params is made visible.
function params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to params (see VARARGIN)

% Choose default command line output for params
handles.output = hObject;



handles.model = varargin{1};

view = parameterview(handles.model,hObject);

handles.view = get(view,'this');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes params wait for user response (see UIRESUME)
% uiwait(handles.params);


% --- Outputs from this function are returned to the command line.
function varargout = params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenuGrouping.
function popupmenuGrouping_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuGrouping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuGrouping contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuGrouping

v = get(hObject,'Value');

if v==1
  grpfunc = @mean;
elseif v==2
  grpfunc = @median;
elseif v==3
  grpfunc = @min;
elseif v==4
  grpfunc = @max;
elseif v==5
  grpfunc = @(x) x(1);
elseif v==6
  grpfunc = @(x) x(floor((1+length(x))/2));
elseif v==7
  grpfunc = @(x) x(end);
end

set(deref(handles.model),'param_grouping_func',grpfunc);


% --- Executes during object creation, after setting all properties.
function popupmenuGrouping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuGrouping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNAQ_Callback(hObject, eventdata, handles)
% hObject    handle to editNAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNAQ as text
%        str2double(get(hObject,'String')) returns contents of editNAQ as a double


% --- Executes during object creation, after setting all properties.
function editNAQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAQ_Callback(hObject, eventdata, handles)
% hObject    handle to editAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAQ as text
%        str2double(get(hObject,'String')) returns contents of editAQ as a double


% --- Executes during object creation, after setting all properties.
function editAQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editClQ_Callback(hObject, eventdata, handles)
% hObject    handle to editClQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editClQ as text
%        str2double(get(hObject,'String')) returns contents of editClQ as a double


% --- Executes during object creation, after setting all properties.
function editClQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editClQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOQ1_Callback(hObject, eventdata, handles)
% hObject    handle to editOQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOQ1 as text
%        str2double(get(hObject,'String')) returns contents of editOQ1 as a double


% --- Executes during object creation, after setting all properties.
function editOQ1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOQ2_Callback(hObject, eventdata, handles)
% hObject    handle to editOQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOQ2 as text
%        str2double(get(hObject,'String')) returns contents of editOQ2 as a double


% --- Executes during object creation, after setting all properties.
function editOQ2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSQ1_Callback(hObject, eventdata, handles)
% hObject    handle to editSQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSQ1 as text
%        str2double(get(hObject,'String')) returns contents of editSQ1 as a double


% --- Executes during object creation, after setting all properties.
function editSQ1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSQ2_Callback(hObject, eventdata, handles)
% hObject    handle to editSQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSQ2 as text
%        str2double(get(hObject,'String')) returns contents of editSQ2 as a double


% --- Executes during object creation, after setting all properties.
function editSQ2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDH12_Callback(hObject, eventdata, handles)
% hObject    handle to editDH12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDH12 as text
%        str2double(get(hObject,'String')) returns contents of editDH12 as a double


% --- Executes during object creation, after setting all properties.
function editDH12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDH12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxShowNAQ.
function checkboxShowNAQ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowNAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowNAQ

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.NAQ = v;
set(deref(handles.model),'shown_params',sp);

% --- Executes on button press in checkboxShowAQ.
function checkboxShowAQ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowAQ

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.AQ = v;
set(deref(handles.model),'shown_params',sp);

% --- Executes on button press in checkboxShowClQ.
function checkboxShowClQ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowClQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowClQ

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.ClQ = v;
set(deref(handles.model),'shown_params',sp);


% --- Executes on button press in checkboxShowOQ1.
function checkboxShowOQ1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowOQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowOQ1

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.OQ1 = v;
set(deref(handles.model),'shown_params',sp);


% --- Executes on button press in checkboxShowOQ2.
function checkboxShowOQ2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowOQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowOQ2

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.OQ2 = v;
set(deref(handles.model),'shown_params',sp);


% --- Executes on button press in checkboxShowSQ1.
function checkboxShowSQ1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowSQ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowSQ1

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.SQ1 = v;
set(deref(handles.model),'shown_params',sp);

% --- Executes on button press in checkboxShowSQ2.
function checkboxShowSQ2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowSQ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowSQ2

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.SQ2 = v;
set(deref(handles.model),'shown_params',sp);

% --- Executes on button press in checkboxShowDH12.
function checkboxShowDH12_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowDH12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowDH12

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.DH12 = v;
set(deref(handles.model),'shown_params',sp);



function editOQa_Callback(hObject, eventdata, handles)
% hObject    handle to editOQa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOQa as text
%        str2double(get(hObject,'String')) returns contents of editOQa as a double


% --- Executes during object creation, after setting all properties.
function editOQa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOQa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxShowOQa.
function checkboxShowOQa_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowOQa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowOQa

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.OQa = v;
set(deref(handles.model),'shown_params',sp);



function editQOQ_Callback(hObject, eventdata, handles)
% hObject    handle to editQOQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQOQ as text
%        str2double(get(hObject,'String')) returns contents of editQOQ as a double


% --- Executes during object creation, after setting all properties.
function editQOQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQOQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxShowQOQ.
function checkboxShowQOQ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShowQOQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShowQOQ

v = get(hObject,'Value');

sp = get(deref(handles.model),'shown_params');
sp.QOQ = v;
set(deref(handles.model),'shown_params',sp);



function editPSP_Callback(hObject, eventdata, handles)
% hObject    handle to editPSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPSP as text
%        str2double(get(hObject,'String')) returns contents of editPSP as a double


% --- Executes during object creation, after setting all properties.
function editPSP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editHRF_Callback(hObject, eventdata, handles)
% hObject    handle to editHRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHRF as text
%        str2double(get(hObject,'String')) returns contents of editHRF as a double


% --- Executes during object creation, after setting all properties.
function editHRF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonFitLF.
function pushbuttonFitLF_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFitLF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curf = gcf;
set(curf,'Pointer','watch');
  
m = deref(handles.model);
h = waitbar(0,'Fitting the LF model parameters...');
makelffit(m,h);
set(curf,'Pointer','arrow');

close(h)

function editTp_Callback(hObject, eventdata, handles)
% hObject    handle to editTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTp as text
%        str2double(get(hObject,'String')) returns contents of editTp as a double


% --- Executes during object creation, after setting all properties.
function editTp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTe_Callback(hObject, eventdata, handles)
% hObject    handle to editTe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTe as text
%        str2double(get(hObject,'String')) returns contents of editTe as a double


% --- Executes during object creation, after setting all properties.
function editTe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTa_Callback(hObject, eventdata, handles)
% hObject    handle to editTa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTa as text
%        str2double(get(hObject,'String')) returns contents of editTa as a double


% --- Executes during object creation, after setting all properties.
function editTa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEe_Callback(hObject, eventdata, handles)
% hObject    handle to editEe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEe as text
%        str2double(get(hObject,'String')) returns contents of editEe as a double


% --- Executes during object creation, after setting all properties.
function editEe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


