function varargout = spectra(varargin)
% SPECTRA M-file for spectra.fig
%      SPECTRA, by itself, creates a new SPECTRA or raises the existing
%      singleton*.
%
%      H = SPECTRA returns the handle to a new SPECTRA or the handle to
%      the existing singleton*.
%
%      SPECTRA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRA.M with the given input arguments.
%
%      SPECTRA('Property','Value',...) creates a new SPECTRA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectra_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectra_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectra

% Last Modified by GUIDE v2.5 25-Jun-2015 17:05:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectra_OpeningFcn, ...
                   'gui_OutputFcn',  @spectra_OutputFcn, ...
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


% --- Executes just before spectra is made visible.
function spectra_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectra (see VARARGIN)

% Choose default command line output for spectra
handles.output = hObject;

handles.model = varargin{1};
handles.hAxes = findobj(hObject, 'Tag', 'spectrumAxes');





vw = spectrumview(handles.model,hObject,handles.hAxes);
handles.vw = get(vw,'this');

% store radio button handles
handles.hLinRadioButton = findobj(hObject, 'Tag', 'linRadioButton');
handles.hLogRadioButton = findobj(hObject, 'Tag', 'logRadioButton');

% store data for the window resizing handler
axesPosition = get(handles.hAxes, 'Position');
figPosition = get(hObject, 'Position');
handles.axesSizeDiff = figPosition(3:4) - axesPosition(3:4);
componentPosition = get(findobj(hObject, 'Tag', 'filterCheckbox'), 'Position');
handles.checkboxOffsetY = figPosition(4) - componentPosition(2);
componentPosition = get(findobj(hObject, 'Tag', 'radioButtonFrame'), 'Position');
handles.frameOffsetX = figPosition(3) - componentPosition(1);
componentPosition = get(findobj(hObject, 'Tag', 'linRadioButton'), 'Position');
handles.linRadioButtonOffsetX = figPosition(3) - componentPosition(1);
componentPosition = get(findobj(hObject, 'Tag', 'logRadioButton'), 'Position');
handles.logRadioButtonOffsetX = figPosition(3) - componentPosition(1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spectra wait for user response (see UIRESUME)
% uiwait(handles.spectrumfig);


% --- Outputs from this function are returned to the command line.
function varargout = spectra_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when spectrumfig window is resized.
function spectrumfig_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to spectrumfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% this function is called in the opening phase when handles is not set.
% in that case, do nothing.
if ~isstruct(handles)
  return
end


figPosition = get(hObject, 'Position');
%handles.checkboxOffsetY = figPosition(4) - componentPosition(2);
hCheckboxes = findobj(hObject, 'Style', 'checkbox');


for i=1:length(hCheckboxes)
    pos = get(hCheckboxes(i), 'Position');
    pos(2) = figPosition(4) - handles.checkboxOffsetY;
    set(hCheckboxes(i), 'Position', pos);
end
% radio buttons
hFrame = findobj(hObject, 'Tag', 'radioButtonFrame');
pos = get(hFrame, 'Position');
pos(1) = figPosition(3) - handles.frameOffsetX;
set(hFrame, 'Position', pos);
hButton = findobj(hObject, 'Tag', 'linRadioButton');
pos = get(hButton, 'Position');
pos(1) = figPosition(3) - handles.linRadioButtonOffsetX;
set(hButton, 'Position', pos);
hButton = findobj(hObject, 'Tag', 'logRadioButton');
pos = get(hButton, 'Position');
pos(1) = figPosition(3) - handles.logRadioButtonOffsetX;
set(hButton, 'Position', pos);
% spectrum axes
axesPosition = get(handles.hAxes, 'Position');
axesPosition = [axesPosition(1:2) figPosition(3:4) - handles.axesSizeDiff];
set(handles.hAxes, 'Position', axesPosition);
plotspectra(deref(handles.vw));


% --- Executes on button press in filterCheckbox.
function filterCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to filterCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filterCheckbox
plotspectra(deref(handles.vw));


% --- Executes on button press in pressureCheckbox.
function pressureCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to pressureCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pressureCheckbox
plotspectra(deref(handles.vw));


% --- Executes on button press in flowCheckbox.
function flowCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to flowCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flowCheckbox
plotspectra(deref(handles.vw));

% --- Executes on button press in gfilterCheckbox.
function gfilterCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to gfilterCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gfilterCheckbox
plotspectra(deref(handles.vw));

% --- Executes on button press in formantsCheckbox.
function formantsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to formantsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of formantsCheckbox
plotspectra(deref(handles.vw));


% --- Executes on mouse motion over figure - except title and menu.
function spectrumfig_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to spectrumfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hText = findobj(hObject, 'Tag', 'frequencyText');
point = get(handles.hAxes,'CurrentPoint');
xlim = get(handles.hAxes,'XLim');
ylim = get(handles.hAxes,'YLim');
if isoveraxes(point,xlim,ylim)
  set(hText, 'String', sprintf('%.0f Hz, %.1f dB', point(1,1), point(1,2)));
end


% --- Executes on button press in linRadioButton.
function linRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to linRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linRadioButton
set(hObject, 'Value', 1);
set(handles.hLogRadioButton, 'Value', 0);
plotspectra(deref(handles.vw));


% --- Executes on button press in logRadioButton.
function logRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to logRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logRadioButton
set(hObject, 'Value', 1);
set(handles.hLinRadioButton, 'Value', 0);
plotspectra(deref(handles.vw));
