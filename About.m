function varargout = About(varargin)
% ABOUT M-file for About.fig
%      ABOUT, by itself, creates a new ABOUT or raises the existing
%      singleton*.
%
%      H = ABOUT returns the handle to a new ABOUT or the handle to
%      the existing singleton*.
%
%      ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUT.M with the given input arguments.
%
%      ABOUT('Property','Value',...) creates a new ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before About_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to About_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% TMU bioinformatics group, Last updated: February 07, 2015

% Edit the above text to modify the response to help About

% Last Modified by GUIDE v2.5 10-Oct-2014 12:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @About_OpeningFcn, ...
                   'gui_OutputFcn',  @About_OutputFcn, ...
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


% --- Executes just before About is made visible.
function About_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to About (see VARARGIN)

% Choose default command line output for About
handles.output = hObject;

imshow('logo.png', 'Parent', handles.axes1)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes About wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = About_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://bioinf.modares.ac.ir/');
