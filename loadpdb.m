function varargout = loadpdb(varargin)
% LOADPDB M-file for loadpdb.fig
%      LOADPDB, by itself, creates a new LOADPDB or raises the existing
%      singleton*.
%
%      H = LOADPDB returns the handle to a new LOADPDB or the handle to
%      the existing singleton*.
%
%      LOADPDB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADPDB.M with the given input arguments.
%
%      LOADPDB('Property','Value',...) creates a new LOADPDB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before loadpdb_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to loadpdb_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% TMU bioinformatics group, Last updated: February 07, 2015

% Edit the above text to modify the response to help loadpdb

% Last Modified by GUIDE v2.5 12-Feb-2015 11:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loadpdb_OpeningFcn, ...
                   'gui_OutputFcn',  @loadpdb_OutputFcn, ...
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


% --- Executes just before loadpdb is made visible.
function loadpdb_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loadpdb (see VARARGIN)
handles.filename = '';
dontOpen = false;
mainGuiInput = find(strcmp(varargin, 'PDB2Graph'));
if (isempty(mainGuiInput)) ...
    || (length(varargin) <= mainGuiInput) ...
    || (~ishandle(varargin{mainGuiInput+1}))
    dontOpen = true;
else
    % Remember the handle, and adjust our position
    handles.pdbgraphguiMain = varargin{mainGuiInput+1};
    
    set(handles.text2,'String','Enter a PDB file name (4 characters).');%STATUS
    handles.output = hObject;
    
end

% Update handles structure
guidata(hObject, handles);

if dontOpen
   disp('-----------------------------------------------------');
   disp('Improper input arguments.') 
   disp('-----------------------------------------------------');
else
   uiwait(hObject);
end

% UIWAIT makes loadpdb wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = loadpdb_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.filename;
delete(hObject);


function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pdbname = get(handles.edit1,'String');

if isempty(pdbname)
    set(handles.text2,'ForegroundColor',[0.5 0 0]);
    set(handles.text2,'String','<<<Error>>> PDB file name is not valid.');%STATUS
elseif length(pdbname) ~= 4
    set(handles.text2,'ForegroundColor',[0.5 0 0]);
    set(handles.text2,'String','<<<Error>>> PDB file name is not valid.');%STATUS
else
    filename = strcat(pdbname,'.pdb');
    pdb = getpdb(pdbname,'tofile',filename);
    set(handles.text2,'ForegroundColor',[0 0.5 0]);
    set(handles.text2,'String','The PDB file is loaded correctly.');%STATUS
    handles.filename = filename;
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);
