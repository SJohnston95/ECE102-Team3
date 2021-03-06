%%%GUI #2- User selects security detection systems to be on
%Created by Nick Sherbert and Stephen Johnston
%For ECE102 
%03/12/2019/
%LabJack GUI testcode


function varargout = GUI_team3codeDisplay(varargin)
% GUI_TEAM3CODEDISPLAY MATLAB code for GUI_team3codeDisplay.fig
%      GUI_TEAM3CODEDISPLAY, by itself, creates a new GUI_TEAM3CODEDISPLAY or raises the existing
%      singleton*.
%
%      H = GUI_TEAM3CODEDISPLAY returns the handle to a new GUI_TEAM3CODEDISPLAY or the handle to
%      the existing singleton*.
%
%      GUI_TEAM3CODEDISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEAM3CODEDISPLAY.M with the given input arguments.
%
%      GUI_TEAM3CODEDISPLAY('Property','Value',...) creates a new GUI_TEAM3CODEDISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_team3codeDisplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_team3codeDisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_team3codeDisplay

% Last Modified by GUIDE v2.5 15-Mar-2019 13:31:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_team3codeDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_team3codeDisplay_OutputFcn, ...
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


% --- Executes just before GUI_team3codeDisplay is made visible.
function GUI_team3codeDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_team3codeDisplay (see VARARGIN)

% Choose default command line output for GUI_team3codeDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_team3codeDisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_team3codeDisplay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val_checkbox1 = get(handles.checkbox1,'Value')
ljud_LoadDriver
ljud_Constants
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
[Error] = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error);
% Set all pin assignments to the factory default condition

if val_checkbox1 == 1
for i = 1:3
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 1, 2.6, 1); %For optimal sound and lighting use voltage between 2.4 volts and 3.2 volts(Best is 2.6 Volts)
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 0, 0, 0);
      pause(0.5)
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 1, 0, 1); %For optimal sound and lighting use voltage between 2.4 volts and 3.2 volts(Best is 2.6 Volts)
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 0, 0, 1);
      pause(0.5)
end
elseif val_checkbox1 == 0
 Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 1, 0, 0);  
end


% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) %%%where 1 for checked and 0 for unchecked.
val_checkbox2 = get(handles.checkbox2,'Value');
ljud_LoadDriver
ljud_Constants
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
[Error] = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error);
% Set all pin assignments to the factory default condition

if val_checkbox2 == 1
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 1, 0, 0); %keep DAC1 alarm sysyem low and off
      Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 0, 4.9, 1);  %if checked, White LEDs turned on
elseif val_checkbox2 == 0
 Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 1, 0, 0);  %%keep DAC1 alarm sysyem low and off
 Error = ljud_ePut (ljHandle, LJ_ioPUT_DAC, 0, 0, 0);  %%if unchecked, White LEDs turned off
end
% Hint: get(hObject,'Value') returns toggle state of checkbox2

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
push_button = get(handles.pushbutton1,'Value');
if push_button == 1;
close(GUI_team3codeDisplay); %%closes GUI display and saves state of secuiryt detection feautres (test this with the team)
end
