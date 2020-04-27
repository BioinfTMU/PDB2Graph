function varargout = graphfeature(varargin)
% GRAPHFEATURE MATLAB code for graphfeature.fig
%      GRAPHFEATURE, by itself, creates a new GRAPHFEATURE or raises the existing
%      singleton*.
%
%      H = GRAPHFEATURE returns the handle to a new GRAPHFEATURE or the handle to
%      the existing singleton*.
%
%      GRAPHFEATURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHFEATURE.M with the given input arguments.
%
%      GRAPHFEATURE('Property','Value',...) creates a new GRAPHFEATURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graphfeature_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graphfeature_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graphfeature
% TMU bioinformatics group, Last updated: February 07, 2015

% Last Modified by GUIDE v2.5 22-Jun-2015 14:54:04

% Begin initialization code - DO NOT EDIT

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graphfeature_OpeningFcn, ...
                   'gui_OutputFcn',  @graphfeature_OutputFcn, ...
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


% --- Executes just before graphfeature is made visible.
function graphfeature_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graphfeature (see VARARGIN)

NofNodes = varargin{(find(strcmp(varargin, 'NofNodes')))+1};
NofEdges = varargin{(find(strcmp(varargin, 'NofEdges')))+1};
NofLoops = varargin{(find(strcmp(varargin, 'NofLoops')))+1};
LinkD = varargin{(find(strcmp(varargin, 'LinkD')))+1};
AverageD = varargin{(find(strcmp(varargin, 'AverageD')))+1};
NofCC = varargin{(find(strcmp(varargin, 'NofCC')))+1};
maxhub = varargin{(find(strcmp(varargin, 'maxhub')))+1};
Pearson_c = varargin{(find(strcmp(varargin, 'Pearson_c')))+1};
apl = varargin{(find(strcmp(varargin, 'apl')))+1};
pdbname = varargin{(find(strcmp(varargin, 'filename')))+1};

dontOpen = false;
mainGuiInput = find(strcmp(varargin, 'PDB2Graph'));
if (isempty(mainGuiInput)) ...
    || (length(varargin) <= mainGuiInput) ...
    || (~ishandle(varargin{mainGuiInput+1}))
    dontOpen = true;
else
    % Remember the handle, and adjust our position
    handles.pdbgraphguiMain = varargin{mainGuiInput+1};
    
    % Obtain handles using GUIDATA with the caller's handle 
    mainHandles = guidata(handles.pdbgraphguiMain);
    
    %==============Display in GUI====================
    set(handles.text37,'String',num2str(NofNodes));
    set(handles.text38,'String',num2str(NofEdges));
    set(handles.text39,'String',num2str(NofLoops));
    set(handles.text40,'String',num2str(LinkD));
    set(handles.text41,'String',num2str(AverageD));
    set(handles.text42,'String',num2str(NofCC));
    set(handles.text44,'String',num2str(maxhub));
    set(handles.text46,'String',num2str(Pearson_c));
    set(handles.text48,'String',num2str(apl));
    %================================================
    set(handles.text49,'String',pdbname);
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

% UIWAIT makes graphfeature wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = graphfeature_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];
delete(hObject);


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
uiresume(hObject);

