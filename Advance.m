function varargout = Advance(varargin)
% Advance M-file for Advance.fig
%      Advance, by itself, creates a new Advance or raises the existing
%      singleton*.
%
%      H = Advance returns the handle to a new Advance or the handle to
%      the existing singleton*.
%
%      Advance('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Advance.M with the given input arguments.
%
%      Advance('Property','Value',...) creates a new Advance or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Advance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Advance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% TMU bioinformatics group, Last updated: February 22, 2015

% Edit the above text to modify the response to help Advance

% Last Modified by GUIDE v2.5 27-Jan-2016 09:14:45
% Copyright 1984-2008 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Advance_OpeningFcn, ...
                   'gui_OutputFcn',  @Advance_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
% End initialization code - DO NOT EDIT
end


% --- Executes just before Advance is made visible.
function Advance_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Advance (see VARARGIN)

handles.AMatrix = varargin{(find(strcmp(varargin, 'AMatrix')))+1};
handles.Resid = varargin{(find(strcmp(varargin, 'Resid')))+1};
handles.XYPOS = varargin{(find(strcmp(varargin, 'XY_POS')))+1};
handles.cutoff = varargin{(find(strcmp(varargin, 'cutoff')))+1};
handles.filename = varargin{(find(strcmp(varargin, 'filename')))+1};
handles.bios = varargin{(find(strcmp(varargin, 'bios')))+1};

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
    
    set(handles.slider1,'Value',0.4)
    set(handles.text8,'String','0.4');
    
    uipanel3_title = strcat('Node Degree v. Residue',':',handles.filename);
    set(handles.uipanel3,'Title',uipanel3_title)  % Rename uipanel3
    
    % Set the default data on the table.
   % [betw]=node_betweenness_faster(handles.AMatrix);
   % X = (1:length(handles.Resid))+handles.bios;
   % Y=betw';
   %  handles.table(:,1) = X;
   %  handles.table(:,2) = Y;
   % set(handles.poplabel,'String','Betweenness');
   % table = handles.table;
   % set(handles.data_table,'Data',table)
   % refreshDisplays(table, handles, 1)
    
	%     % Set the default data on the table. : 'Node Degree v. Residue'
	[deg,indeg,outdeg]=degrees(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = deg';
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Node Degree');
     table = handles.table;
    set(handles.data_table,'Data',table)
    refreshDisplays(table, handles, 1)
	
	
    figname = strcat('Protein Name:', num2str(handles.filename));
    figcutoff = strcat('Cut-off:', num2str(handles.cutoff));
    set(handles.text1, 'String', figname);
    set(handles.text2, 'String', figcutoff);
    
    % % Choose default command line output for Advance
    handles.output = hObject;
    % Declare cache for selection, which starts out empty
    handles.currSelection = [];
    % Update handles structure
    guidata(hObject, handles);
    
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


% --- Outputs from this function are returned to the command line.
function varargout = Advance_OutputFcn(hObject, ~, ~) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];
delete(hObject);


% --- Executes when selected cell(s) is changed in data_table.
function data_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to data_table (see GCBO)
% eventdata  structure with the following field (see UITABLE)
%  Indices:  row and column indices of the cell(s) currently selected
% handles    structure with handles and user data (see GUIDATA)

% ---- Customized as follows ----
% Obtain 1st column of current selection indices from data;
% this contains row indices. We don't need column indices.
selection = eventdata.Indices(:,1);
% Remove duplicate row IDs
selection = unique(selection);
% Don't process less than a minimum nuber of observations
if size(selection) < 10
    return
end
% Obtain the data table
table = get(hObject,'Data');
handles.currSelection = selection;
guidata(hObject,handles)
% Update the stats and plot for new selection
refreshDisplays(table(selection,:), handles, 2)


% --- Executes on selection change in plot_type.
function plot_type_Callback(hObject, ~, handles)
% hObject    handle to plot_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ---- Customized as follows ----
% Determine state of the pop-up and assign the appropriate string
% to the plot panel label
val = get(hObject,'Value');
str = get(hObject,'String');
uipanel3_title = strcat(str(val),':',handles.filename);
set(handles.uipanel3,'Title',uipanel3_title)  % Rename uipanel3

switch str{val};
 case 'Betweenness v. Residue'
    [betw]=node_betweenness_faster(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = betw';
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Betweenness');
 case 'Closeness v. Residue'
    [C]=closeness(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = C';
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Closeness');
 case 'Cluster Coefficient v. Residue'
    [C1,C2,C] = clust_coeff(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = C;
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Cluster Coefficient');
 case 'Average Neighbor Degree v. Residue'
    ave_n_deg = ave_neighbor_deg(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = ave_n_deg'; 
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Average Neighbor Degree');
 case 'Node Degree v. Residue'
    [deg,indeg,outdeg]=degrees(handles.AMatrix);
    X = (1:length(handles.Resid))+handles.bios;
    Y = deg';
    handles.table(:,1) = X;
    handles.table(:,2) = Y;
    set(handles.poplabel,'String','Node Degree');
end

table = handles.table;
set(handles.data_table,'Data',table)
refreshDisplays(table, handles, 1)

selection = handles.currSelection;
if length(selection) > 10  % If more than 10 rows selected
    refreshDisplays(table(selection,:), handles, 2)
else
    % Do nothing; insufficient observations for statistics
end
guidata(hObject,handles)

                  
% --- Executes during object creation, after setting all properties.
function plot_type_CreateFcn(hObject, ~, ~)
% hObject    handle to plot_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    

% --- Executes on button press in quit.
function quit_Callback(~, ~, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --------------------------------------------------------------------
function plot_ax1_Callback(hObject, ~, handles)
% hObject    handle to plot_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Displays contents of axes1 at larger size in a new figure

% Create a figure to receive this axes' data
axes1fig = figure;
% Copy the axes and size it to the figure
axes1copy = copyobj(handles.axes1,axes1fig);
set(axes1copy,'Units','Normalized',...
              'Position',[.05,.20,.90,.60])
% Assemble a title for this new figure
str = get(handles.uipanel3,'Title');
title(str,'Fontweight','bold')

handles.axes1fig = axes1fig;
handles.axes1copy = axes1copy;
guidata(hObject,handles);

% --------------------------------------------------------------------
function plot_ax2_Callback(hObject, ~, handles)
% hObject    handle to plot_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Displays contents of axes2 at larger size in a new figure

% Create a figure to receive this axes' data
axes2fig = figure;
% Copy the axes and size it to the figure
axes2copy = copyobj(handles.axes2,axes2fig);
set(axes2copy,'Units','Normalized',...
              'Position',[.05,.20,.90,.60])
% Assemble a title for this new figure
str = [get(handles.uipanel3,'Title') ' for ' ...
       get(handles.sellabel,'String')];
title(str,'Fontweight','bold')

handles.axes1fig = axes2fig;
handles.axes1copy = axes2copy;
guidata(hObject,handles);


function refreshDisplays(table, handles, item)
% Updates the statistics table and one of the plots.
% Called from several Advance GUI callbacks.
%   table    The data 
%            it has only one column
%   handles  The handles structure
%   item     Which column and corresponsing plot to update

% Choose appropriate axes
if isequal(item,1)
    ax = handles.axes1;
elseif isequal(item,2)
    ax = handles.axes2;
end
% Generate appropriate plot; return val peak is used by setStats
plotPeriod(ax, table);
% Get the stats table from the gui
stats = get(handles.data_stats, 'Data');
% Generate the stats for the selection
stats = setStats(table, stats, item);
% Replace the stats in the gui with the updated ones
set(handles.data_stats, 'Data', stats);


function stats = setStats(table, stats, col)
% Computes basic statistics for data table.
%   table  The data to summarize (a population or selection)
%   stats  Array of statistics to update
%   col    Which column of the array to update

stats{1,col} = size(table,1);      % Number of rows
stats{2,col} = min(table(:,2));
stats{3,col} = max(table(:,2));
stats{4,col} = mean(table(:,2));
stats{5,col} = median(table(:,2));
stats{6,col} = std(table(:,2));


function plotPeriod(ax, table)

plot(ax,table(:,1),table(:,2),'LineWidth',2);


% --------------------------------------------------------------------
function plot_Axes1_Callback(~, ~, ~)
% hObject    handle to plot_Axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% UNUSED - For parent of uicontextmenu plot_ax1

% --------------------------------------------------------------------
function plot_Axes2_Callback(~, ~, ~)
% hObject    handle to plot_Axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% UNUSED - For parent of uicontextmenu plot_ax2


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(~, ~, ~)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Draw Graph based on node centrality.
table = handles.table;
table_min = min(table(:,2));
table_max = max(table(:,2));
%%===============================Drawing===================================
bg = biograph(handles.AMatrix,handles.Resid);
nofnode = size(bg.nodes);
%==============================Graph Coloring==============================
valp = get(handles.popupmenu2,'Value');
strp = get(handles.popupmenu2,'String');

precm = colormap(jet(nofnode(1)));
temp = colormap(strp{valp});
cm = temp(1:nofnode(1),:);

wait = waitbar(0,'Please wait...'); % Wait Bar

for j=1:nofnode(1)
    f = (table(j,2)- table_min)/(table_max - table_min);
    colorID = max(1, sum(f > [0:1/length(cm(:,1)):1])); 
    bg.nodes(j).Color = cm(colorID, :); % returns the color
    bg.nodes(j).LineColor = cm(colorID, :);
end
%==========================================================================
bg.LayoutType = 'hierarchical'; 
bg.EdgeType = 'Curved';
set(bg.Nodes,'Shape','Circle');
bg.ShowArrows = 'off';        

dolayout(bg);
stepwait = 0.75/nofnode(1);
for j = 1:nofnode(1)
   set(bg.Nodes(j),'Position',...
   [round((handles.XYPOS{j,1}(1,1)*100)),...
   round((handles.XYPOS{j,2}(1,1)*100))])
   waitbar(0.5+(j*stepwait)) % Wait Bar
end
dolayout(bg,'PathsOnly',true)
layout_scale = get(handles.slider1,'Value');
if (layout_scale == 0)
    layout_scale = 0.1;
end;
waitbar(1); % Wait Bar
bg.Scale = layout_scale;
close(wait); % Wait Bar
view(bg);    % Draw the graph
guidata(hObject,handles)


% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text8,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, ~, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text10,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, ~, ~)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(~, ~, ~)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
