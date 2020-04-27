function varargout = PDB2Graph(varargin)
% PDB2GRAPH M-file for PDB2Graph.fig
%      PDB2GRAPH, by itself, creates a new PDB2GRAPH or raises the existing
%      singleton*.
%
%      H = PDB2GRAPH returns the handle to a new PDB2GRAPH or the handle to
%      the existing singleton*.
%
%      PDB2GRAPH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PDB2GRAPH.M with the given input arguments.
%
%      PDB2GRAPH('Property','Value',...) creates a new PDB2GRAPH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PDB2Graph_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PDB2Graph_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% TMU bioinformatics group, Last updated: February 07, 2015

% Edit the above text to modify the response to help PDB2Graph

% Last Modified by GUIDE v2.5 22-Jun-2015 16:50:11

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PDB2Graph_OpeningFcn, ...
                   'gui_OutputFcn',  @PDB2Graph_OutputFcn, ...
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


% --- Executes just before PDB2Graph is made visible.
function PDB2Graph_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PDB2Graph (see VARARGIN)


% Choose default command line output for PDB2Graph
handles.output = hObject;
warning('off','MATLAB:dispatcher:InexactCaseMatch');

set(handles.text32,'ForegroundColor',[0 0 0]);
set(handles.text32,'String','Please define the PDB file path');%STATUS
set(handles.slider1,'Value',1);
set(handles.slider2,'Value',7);


% Update handles structure
guidata(hObject, handles);

% Set waiting flag in appdata
 setappdata(handles.figure1,'waiting',1)
% UIWAIT makes changeme_main wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PDB2Graph_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% Now destroy yourself
delete(hObject);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check appdata flag to see if the main GUI is in a wait state
if getappdata(handles.figure1,'waiting')
    % The GUI is still in UIWAIT, so call UIRESUME and return
    uiresume(hObject);
    setappdata(handles.figure1,'waiting',0)
else
    % The GUI is no longer waiting, so destroy it now.
    delete(hObject);
end

%=============================Make Matrix==================================
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, ~, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text32,'ForegroundColor',[0 0 1]);
set(handles.text32,'String','Please Wait: Parsing PDB file...');%STATUS
guidata(hObject,handles)
%======================Matrix Initialization===============================
cutoff = get(handles.slider2,'Value');
handles.cutoff = cutoff;
set(handles.text53,'String',cutoff); 

str1 = get(handles.popupmenu15,'String');
val1 = get(handles.popupmenu15,'Value');
switch str1{val1};
 case 'CA' 
    Graph_Type = 'CA';
 case 'CB'
    Graph_Type = 'CB';
 case 'Side Chain GC'
    Graph_Type = 'gc';
 case 'All Atom GC'
    Graph_Type = 'gc_all';
end

str2 = get(handles.popupmenu16,'String');
val2 = get(handles.popupmenu16,'Value');
str3 = get(handles.popupmenu17,'String');
val3 = get(handles.popupmenu17,'Value');
Chain_ID = str2(val2);
handles.chain_id = Chain_ID;
MDL = str2double(str3(val3));

%=====================Calculating the Adjacancy Matrix=====================
[BMatrix,handles.IDs,handles.XYpos,handles.AAType, handles.bios] = pdb2mat_ver3(handles.current_address,Chain_ID,Graph_Type,MDL,handles.cutoff);
[handles.HelixMat handles.SheetMat] = helixsheet(handles.current_address, handles.bios);
handles.AMatrix = triu(BMatrix);
handles.BMatrix = BMatrix;
%Save Adjacancy Matrix to the same directory
% n=size(handles.AMatrix,1);
% fid = fopen('ADmatrix.txt','w');
% b=[];
% for i = 1:n
% b=strcat(b,'%4u');
% end
% fprintf(fid,strcat(b,'\n'),handles.AMatrix');
% fclose(fid);
save('ADmatrix.mat','BMatrix');
%==========================================================================
set(handles.text32,'ForegroundColor',[0 0.5 0]);
set(handles.text32,'String','The adjacency matrix is made.');%STATUS
%===========================Enable All parts===============================
set(handles.popupmenu3,'Enable','on');
set(handles.popupmenu6,'Enable','on');
set(handles.popupmenu7,'Enable','on');
set(handles.popupmenu8,'Enable','on');
set(handles.popupmenu11,'Enable','on');

set(handles.slider1,'Enable','on'); 
set(handles.pushbutton14,'Enable','on');
set(handles.pushbutton16,'Enable','on');
set(handles.pushbutton30,'Enable','on'); %Advance Analysis

set(handles.molviewer7,'Enable','on');
set(handles.GraphFeature8,'Enable','on');
set(handles.advance_analyze14,'Enable','on');
set(handles.degreedis,'Enable','on'); % Degree Distribution Pushtool
set(handles.PDBinfo9,'Enable','on');
set(handles.circulargraph10,'Enable','on');
set(handles.Dotmatrix12,'Enable','on');
set(handles.uipushtool13,'Enable','on');
set(handles.Save_menu,'Enable','on');
set(handles.dotmatrix_menu,'Enable','on'); % Dot Matirix Menu
set(handles.ddplot_menu,'Enable','on'); % Degree Distribution Menu
set(handles.advance_menu,'Enable','on'); %Advance Analysis Menu
set(handles.molviewer_menu,'Enable','on'); %Molviewer Menu
set(handles.cgraph_menu,'Enable','on'); %Circular Graph Menu
set(handles.dmview,'Enable','on'); %Distance Matrix menu

set(handles.text54,'String','1');

set(handles.PDBinfo,'Enable','on');
set(handles.graphfeature,'Enable','on');

guidata(hObject,handles)

%===============================Draw Graph=================================
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, ~, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    wait = waitbar(0,'Please wait...'); % Wait Bar
    tic;
    
    bg = biograph(handles.AMatrix,handles.IDs');
    nofnode = size(bg.nodes);

    str1 = get(handles.popupmenu6,'String');
    val1 = get(handles.popupmenu6,'Value');
    str2 = get(handles.popupmenu7,'String');
    val2 = get(handles.popupmenu7,'Value');
    str3 = get(handles.popupmenu8,'String');
    val3 = get(handles.popupmenu8,'Value');        
    str5 = get(handles.popupmenu11,'String');
    val5 = get(handles.popupmenu11,'Value');

    %===================Graph Coloring=====================
    %======================================================
    if (strcmp(str5(val5),'Secondary Structure'))
        set(handles.text32,'ForegroundColor',[0 0 1]);
        set(handles.text32,'String','Please Wait: Drawing the graph...');%STATUS
        helixsize = size(handles.HelixMat);
        sheetsize = size(handles.SheetMat);
        for j=1:nofnode(1)
		    bg.nodes(j).color = [0.12 0.9 0.25];
            bg.nodes(j).LineColor =[0.12 0.9 0.25];
            if (j+1 <= nofnode(1))                                              %|
                edge_id = getedgesbynodeid(bg,handles.IDs(j),handles.IDs(j+1)); %|- for edge coloring
                set(edge_id,'LineColor',[0.12 0.9 0.25]);                       %|
            end                                                                 %|
            for i=1:helixsize(1)
                if (handles.HelixMat(i,1)<= j) && (j <= handles.HelixMat(i,2))
				    bg.nodes(j).Color = [1 0.1 0];
					bg.nodes(j).LineColor = [1 0.1 0]; 
                    if (j+1 <= nofnode(1))                                              %|
                        edge_id = getedgesbynodeid(bg,handles.IDs(j),handles.IDs(j+1)); %|- for edge coloring
                        set(edge_id,'LineColor',[1 0.1 0]);                             %| 
                    end                                                                 %|
                end
            end
            waitbar(0.25); % Wait Bar
            for s=1:sheetsize(1)
			
                if (handles.SheetMat(s,1)<= j) && (j <= handles.SheetMat(s,2))
                    bg.nodes(j).Color = [0.25 0.75 1];
					bg.nodes(j).LineColor = [0.25 0.75 1];
                    if (j+1 <= nofnode(1))                                              %|
                        edge_id = getedgesbynodeid(bg,handles.IDs(j),handles.IDs(j+1)); %|- for edge coloring
                        set(edge_id,'LineColor',[0.25 0.75 1]);                         %|
                    end                                                                 %|
                end
            end
        end
        waitbar(0.5); % Wait Bar
    end
    if (strcmp(str5(val5),'Amino Acids'))
        set(handles.text32,'ForegroundColor',[0 0 1]);
        set(handles.text32,'String','Please Wait: Drawing the graph...');%STATUS
        for j=1:nofnode(1)
            if (strcmp(handles.AAType{j,1},'CYS'))
                bg.nodes(j).Color = [0 0 1];
            elseif(strcmp(handles.AAType{j,1},'SER'))
                bg.nodes(j).Color = [0 1 0];
            elseif(strcmp(handles.AAType{j,1},'LEU'))
                bg.nodes(j).Color = [1 0 0];
            elseif(strcmp(handles.AAType{j,1},'MET'))
                bg.nodes(j).Color = [1 1 0];                    
            elseif(strcmp(handles.AAType{j,1},'ASP'))
                bg.nodes(j).Color = [1 0 1];
            elseif(strcmp(handles.AAType{j,1},'LYS'))
                bg.nodes(j).Color = [0 1 1];
            elseif(strcmp(handles.AAType{j,1},'GLU'))
                bg.nodes(j).Color = [0.5 1 0.5];
            elseif(strcmp(handles.AAType{j,1},'VAL'))
                bg.nodes(j).Color = [0.4 0.4 0.4];
            elseif(strcmp(handles.AAType{j,1},'TYR'))
                bg.nodes(j).Color = [0.5 0.6 0.9];
            elseif(strcmp(handles.AAType{j,1},'PHE'))
                bg.nodes(j).Color = [0.5 0 1];
            elseif(strcmp(handles.AAType{j,1},'HIS'))
                bg.nodes(j).Color = [0 0.5 0.5];
            elseif(strcmp(handles.AAType{j,1},'THR'))
                bg.nodes(j).Color = [0 0 0.5];
            elseif(strcmp(handles.AAType{j,1},'PRO'))
                bg.nodes(j).Color = [0 0.5 0];
            elseif(strcmp(handles.AAType{j,1},'ILE'))
                bg.nodes(j).Color = [0.5 0 0];
            elseif(strcmp(handles.AAType{j,1},'ALA'))
                bg.nodes(j).Color = [0.5 0 0.5];
            elseif(strcmp(handles.AAType{j,1},'ARG'))
                bg.nodes(j).Color = [0.5 0.5 0];
            elseif(strcmp(handles.AAType{j,1},'ASN'))
                bg.nodes(j).Color = [0.1 0.3 1];
            elseif(strcmp(handles.AAType{j,1},'TRP'))
                bg.nodes(j).Color = [0.2 0.3 0.4];
            elseif(strcmp(handles.AAType{j,1},'GLY'))
                bg.nodes(j).Color = [0.5 0.7 0.3];
            else
                bg.nodes(j).Color = [0 0 0];
            end;
        end
        waitbar(0.5); % Wait Bar
    end
    if (strcmp(str5(val5),'Hubs'))
        % Finding hubs
        AMsum = sum(handles.BMatrix);
        %maxhub = max(AMsum);
        n = length(handles.AMatrix); %number of nodes
        m = sum(sum(handles.AMatrix)); %number of edges
        Z_mean = 2*m/n;
        maxhub = 3*Z_mean/2;
        
        set(handles.text32,'ForegroundColor',[0 0 1]);
        set(handles.text32,'String','Please Wait: Finding the Hubs...');%STATUS
        for p=1:length(AMsum)
            if (AMsum(p) >= maxhub)
                set(bg.nodes(p),'Color',[0.9 0.5 1.0],'size',[50 50],'LineColor',[0.9 0.5 1.0]);
            else
                bg.nodes(p).Color = [0.3 0.71 1];
				bg.nodes(p).LineColor = [0.3 0.71 1.0];
            end
        end
        waitbar(0.5); % Wait Bar
    end
    if (strcmp(str5(val5),'Mono Color'))
        % Do nothing!
        set(handles.text32,'ForegroundColor',[0 0 1]);
		set(handles.text32,'String','Please Wait: Drawing the graph...');%STATUS
		for b=1:nofnode(1)
			bg.nodes(b).Color = [0.3 0.71 1];
			bg.nodes(b).LineColor = [0.3 0.71 1.0];
		end
		
		waitbar(0.5); % Wait Bar
    end
    %======================================================================
    
    switch str1{val1};
        case 'Real X-Y Position'      
            bg.LayoutType = 'hierarchical'; 
            bg.EdgeType = str3{val3};
            set(bg.Nodes,'Shape',str2{val2});
            bg.ShowArrows = 'off';        

            dolayout(bg);
            stepwait = 0.5/nofnode(1);
            for j = 1:nofnode(1)
               set(bg.Nodes(j),'Position',...
               [round((handles.XYpos{j,1}(1,1)*100)),...
               round((handles.XYpos{j,2}(1,1)*100))])
               waitbar(0.5+(j*stepwait)) % Wait Bar
            end
            dolayout(bg,'PathsOnly',true)
        otherwise,
            bg.LayoutType = str1{val1};
    end
    
    bg.EdgeType = str3{val3};
    set(bg.Nodes,'Shape',str2{val2});
    bg.ShowArrows = 'off';

    waitbar(1); % Wait Bar
    layout_scale = get(handles.slider1,'Value');
    if (layout_scale == 0)
    layout_scale = 0.1;
    end;
    bg.Scale = layout_scale;    
    
    telapsed = toc; %Elapsed time to draw graph
    
    close(wait); % Wait Bar
    
    %Enable Shortest Path Section 
    set(handles.pushbutton25,'Enable','on');
    set(handles.popupmenu18,'Enable','on');
    set(handles.popupmenu19,'Enable','on');
    set(handles.popupmenu18,'String',handles.IDs');
    set(handles.popupmenu19,'String',handles.IDs');
    
    statusstr = strcat ('Elapsed time = ', num2str(telapsed),' seconds');
    set(handles.text32,'ForegroundColor',[0 0 1]);
    set(handles.text32,'String',statusstr);%STATUS
    
    handles.bg = bg;
    view(bg);    % Draw the graph
    guidata(hObject,handles)

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(~, ~, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 set(handles.text32,'ForegroundColor',[0 0 1]);
 set(handles.text32,'String','Please Wait: Creating the tree...');%STATUS

 str = get(handles.popupmenu3,'String');
 val = get(handles.popupmenu3,'Value');

 switch str{val};
     case 'MST'
        tr = min_span_tree(handles.BMatrix);
        bg = biograph (tr,handles.IDs');
        view(bg)
     case 'BFS'
        al = adj2adjL(handles.AMatrix);
        TL=BFS(al,1);
        T=adjL2adj(TL);
        bg = biograph (T,handles.IDs');
        view(bg)
 end
 
 set(handles.text32,'String','');%STATUS

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(~, ~, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text32,'ForegroundColor',[0 0 1]);
set(handles.text32,'String','Please Wait: Finding the Shortest Path...');%STATUS

bg = handles.bg;

% Reset for each call
set(bg.edges,'LineColor',[0.5 0.5 0.5])
set(bg.edges,'LineWidth',1)
set(bg.nodes,'size',[30 30])
layout_scale = get(handles.slider1,'Value');
if (layout_scale == 0)
    layout_scale = 0.1;
end;
bg.Scale = layout_scale;
    
% find the nodes Start and end
str1 = get(handles.popupmenu18,'String');
val1 = get(handles.popupmenu18,'Value');
str2 = get(handles.popupmenu19,'String');
val2 = get(handles.popupmenu19,'Value');

if val1 == val2
    set(handles.text32,'ForegroundColor',[1 0 0]);
    set(handles.text32,'String','The <Start Node> and <End Node> should be different. Please try again.');%STATUS
else
    
    if val1<val2
        startnode = str1{val1};
        endnode = str2{val2};
    else
        startnode = str2{val2};
        endnode = str1{val1};
    end
    StartNode = find(strcmp(startnode, handles.IDs));
    EndNode = find(strcmp(endnode,handles.IDs));

    [dist,path,pred] = shortestpath(bg,StartNode,EndNode);

    %Color the nodes and edges of the shortest path
    set(bg.nodes(StartNode),'size',[50 30]);
    set(bg.nodes(EndNode),'size',[50 30]);
    
    edges = getedgesbynodeid(bg,get(bg.Nodes(path),'ID'));
%     set(edges,'LineColor',[0 1 0])
    set(edges,'LineColor',[1 0.90 0])
    set(edges,'LineWidth',3)

    set(handles.text36,'String',dist);

    set(handles.text32,'String','');%STATUS

    view(bg)
end

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(~, ~, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%========================Advance Analyze===================================
% Call the figure
% Call the figure
Advance('PDB2Graph', handles.figure1,...
        'AMatrix'  , handles.BMatrix,...
        'Resid'    , handles.IDs,...
        'XY_POS'   , handles.XYpos,...
        'cutoff'   , handles.cutoff,...
        'filename' , handles.name,...
        'bios'     , handles.bios);

%%#########################################################################
%%#########################################################################
%%=========================================================================
%%=================================MENU====================================
%%=========================================================================

%%#########################################################################
%%################################<<FILE>>#################################
%%#########################################################################
function File_1_Callback(~, ~, ~)
% hObject    handle to File_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%==================================NEW====================================
function New_3_Callback(hObject, ~, handles)
% hObject    handle to New_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu3,'Enable','off');
set(handles.popupmenu6,'Enable','off');
set(handles.popupmenu7,'Enable','off');
set(handles.popupmenu8,'Enable','off');
set(handles.popupmenu11,'Enable','off');
set(handles.slider2,'Enable','off');
set(handles.popupmenu15,'Enable','off');
set(handles.popupmenu16,'Enable','off');
set(handles.popupmenu17,'Enable','off');

set(handles.slider1,'Enable','off');

set(handles.pushbutton4,'Enable','off');
set(handles.pushbutton14,'Enable','off');
set(handles.pushbutton16,'Enable','off');
set(handles.pushbutton25,'Enable','off');
set(handles.pushbutton30,'Enable','off'); %Advance Analysis

set(handles.popupmenu18,'String','AA');
set(handles.popupmenu19,'String','AA');
set(handles.popupmenu18,'Enable','off');
set(handles.popupmenu19,'Enable','off');

set(handles.molviewer7,'Enable','off');
set(handles.GraphFeature8,'Enable','off');
set(handles.advance_analyze14,'Enable','off'); %Advance Analysis Pushtool
set(handles.degreedis,'Enable','off'); % Degree Distribution Pushtool
set(handles.PDBinfo9,'Enable','off');
set(handles.circulargraph10,'Enable','off');
set(handles.Dotmatrix12,'Enable','off');
set(handles.uipushtool13,'Enable','off');
set(handles.Save_menu,'Enable','off');
set(handles.dotmatrix_menu,'Enable','off'); % Dot Matirix Menu
set(handles.ddplot_menu,'Enable','off'); % Degree Distribution Menu
set(handles.advance_menu,'Enable','off'); %Advance Analysis Menu
set(handles.molviewer_menu,'Enable','off'); %Molviewer Menu
set(handles.cgraph_menu,'Enable','off'); %Circular Graph Menu
set(handles.dmview,'Enable','off'); %Distance Matrix menu

set(handles.PDBinfo,'Enable','off');
set(handles.graphfeature,'Enable','off');

set(handles.text36,'String','');

set(handles.text32,'ForegroundColor',[0 0 0]);
set(handles.text32,'String','Please define the PDB file path');%STATUS
guidata(hObject,handles)
%%=================================OPEN====================================
function Open_4_Callback(hObject, ~, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.pdb', 'Protein Data Bank (*.pdb)'});
handles.name = filename;
if(filename~=0)
    handles.current_address = strcat(pathname,filename);
    set(handles.pushbutton4,'Enable','on');
    set(handles.slider2,'Enable','on');
    set(handles.popupmenu15,'Enable','on');
    set(handles.popupmenu16,'Enable','on');
    set(handles.popupmenu17,'Enable','on');
%====================== Defining Chain Number and MDL======================    
    [mdl_num, mdl_flag] = MDL_Counter(handles.current_address);
    if length(mdl_num)==1
        set(handles.popupmenu17,'Enable','off');
    end
    if mdl_num ~= -1
        set(handles.popupmenu17,'String',mdl_num);
    else
        set(handles.popupmenu17,'String',1);
    end
    chain_num = Chain_Counter(handles.current_address,mdl_flag);    
    if mdl_flag ~= -1
        temp = length(chain_num)/length(mdl_num);
        if temp<1;temp = 1; end
        set(handles.popupmenu16,'String',chain_num(1:temp));
    else
        set(handles.popupmenu16,'String',chain_num);
    end
%==========================================================================    
    set(handles.text53,'String','7');
    statusstr = strcat ('Please define the initialization parameters to create adjacency matrix. [', filename, ']');
    set(handles.text32,'ForegroundColor',[0 0 0]);
    set(handles.text32,'String',statusstr);%STATUS
else
    set(handles.text32,'ForegroundColor',[0.5 0 0]);
    set(handles.text32,'String','Please enter a correct address.');%STATUS
end
guidata(hObject,handles)
%%================================LOAD=====================================
function loadpdb_Callback(hObject, ~, handles)
% hObject    handle to loadpdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Call the figure
filename = loadpdb('PDB2Graph'   , handles.figure1);
handles.name = filename;
if(filename~=0)
    [a b] = fileattrib(filename);
    handles.current_address = b.Name;
    set(handles.pushbutton4,'Enable','on');
    set(handles.slider2,'Enable','on');
    set(handles.popupmenu15,'Enable','on');
    set(handles.popupmenu16,'Enable','on');
    set(handles.popupmenu17,'Enable','on');
%====================== Defining Chain Number and MDL======================    
    [mdl_num, mdl_flag] = MDL_Counter(handles.current_address);
    if length(mdl_num)==1
        set(handles.popupmenu17,'Enable','off');
    end
    if mdl_num ~= -1
        set(handles.popupmenu17,'String',mdl_num);
    else
        set(handles.popupmenu17,'String',1);
    end
    chain_num = Chain_Counter(handles.current_address,mdl_flag);    
    if mdl_flag ~= -1
        temp = length(chain_num)/length(mdl_num);
        if temp<1;temp = 1; end
        set(handles.popupmenu16,'String',chain_num(1:temp));
    else
        set(handles.popupmenu16,'String',chain_num);
    end
%==========================================================================    
    statusstr = strcat ('Please define the initialization parameters to create adjacency matrix. [', filename, ']');
    set(handles.text32,'ForegroundColor',[0 0 0]);
    set(handles.text32,'String',statusstr);%STATUS
else
    set(handles.text32,'ForegroundColor',[0.5 0 0]);
    set(handles.text32,'String','Please enter a correct name.');%STATUS
end
guidata(hObject,handles)
%%===============================SAVE AS===================================
function Save_menu_Callback(~, ~, handles)
% hObject    handle to Save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uiputfile( ...
       {'*.net','Pajek Format (*.net)';...
       '*.sif','Cytoscape Format (*.sif)';...
       '*.dl','Ucinet Format (*.dl)'}, ...
       'Save as');
if(filename~=0)
    set(handles.text32,'ForegroundColor',[0 0 1]);
    set(handles.text32,'String','Please Wait: Creating output format...');%STATUS
    Output_adr = strcat(pathname,filename);
    switch filterindex;
        case 1 
            adj2pajek(handles.AMatrix,Output_adr);
        case 2
            el = adj2edgeL(handles.AMatrix);
            edgeL2cyto(el,Output_adr);
        case 3
            adj2dl(handles.AMatrix,Output_adr);
    end
    set(handles.text32,'ForegroundColor',[0 0.5 0]);
    set(handles.text32,'String','The file is made.');%STATUS
else
    % Do Nothing!
end
%%================================CLOSE====================================
function Close_7_Callback(~, ~, ~)
% hObject    handle to Close_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


%%#########################################################################
%%###########################<<VISUALIZATION>>#############################
%%#########################################################################
function visualize_menu_Callback(~, ~, ~)
% hObject    handle to visualize_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%===============================MOLVIEWER=================================
function molviewer_menu_Callback(~, ~, handles)
% hObject    handle to molviewer_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text32,'ForegroundColor',[0 0 1]);
set(handles.text32,'String','Please Wait: Opening the Molviwer...');%STATUS

pdb_address = handles.current_address;
pdb = pdbread(pdb_address);
molviewer(pdb);

set(handles.text32,'String','');%STATUS
%%============================CIRCULAR GRAPH===============================
function cgraph_menu_Callback(hObject, ~, handles)
% hObject    handle to cgraph_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text32,'ForegroundColor',[0 0 1]);
set(handles.text32,'String','Please Wait: Drawing the figure...');%STATUS
guidata(hObject,handles)
figure();
draw_circ_graph(handles.AMatrix);
set(handles.text32,'String','');%STATUS
guidata(hObject,handles)
%%===========================DISTANCE MATRIX===============================
function dmview_Callback(~, ~, handles)
% hObject    handle to dmview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DisMat = DisMatrix_Maker(handles.current_address,handles.chain_id);
figure();contourf(DisMat);title('Distance Map Contour View');
save('Dis_Matrix.mat','DisMat');
%%#########################################################################
%%##############################<<ANALYSIS>>###############################
%%#########################################################################
function analysis_menu_Callback(~, ~, ~)
% hObject    handle to analysis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%=============================PDB INFORMATION=============================
function PDBinfo_Callback(~, ~, handles)
% hObject    handle to PDBinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%==========================================================================
[Header,Title,EXPDTA,NumAA_i,NumAA_f,strseq]= HeaderParser(handles.current_address);
%==========================================================================

% Call the figure
pdbinformation('PDB2Graph'   , handles.figure1,...
               'Header'         , Header,...
               'Title'          , Title,...
               'strseq'         , strseq,...
               'ExperimentData' , EXPDTA);
%%=============================GRAPH FEATURES==============================
function graphfeature_Callback(~, ~, handles)
% hObject    handle to graphfeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%==========================================================================
NofNodes = numnodes(handles.AMatrix);
NofEdges = numedges(handles.AMatrix);
NofLoops = num_loops(handles.AMatrix);
LinkD = link_density(handles.AMatrix);
AverageD = average_degree(handles.AMatrix);
NofCC = num_conn_comp(handles.AMatrix);
 
%n = length(handles.AMatrix); %number of nodes
%m = sum(sum(handles.AMatrix)); %number of edges
AMsum = sum(handles.BMatrix);
maxhub = max(AMsum);

Pearson_coeff = pearson(handles.BMatrix);
apl = ave_path_length(handles.BMatrix);
%==========================================================================
% Call the figure
graphfeature('PDB2Graph', handles.figure1,...
             'NofNodes' , NofNodes,...
             'NofEdges' , NofEdges,...
             'NofLoops' , NofLoops,...
             'LinkD'    , LinkD,...
             'AverageD' , AverageD,...
             'NofCC'    , NofCC,...
             'maxhub'   , maxhub,...
             'Pearson_c', Pearson_coeff,...
             'apl'      , apl,...
             'filename' , handles.name);
%%===============================DOT MATRIX================================
function dotmatrix_menu_Callback(hObject, ~, handles)
% hObject    handle to dotmatrix_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text32,'ForegroundColor',[0 0 1]);
set(handles.text32,'String','Please Wait: Drawing the figure...');%STATUS
guidata(hObject,handles)
figure();
dot_matrix_plot(handles.BMatrix);
hold on;figure();contour(handles.BMatrix);title('Dot Matrix Contour View');
set(handles.text32,'String','');%STATUS
guidata(hObject,handles)
%%==============================DEGREE PLOT================================
function ddplot_menu_Callback(~, ~, handles)
% hObject    handle to ddplot_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[deg,indeg,outdeg]=degrees(handles.BMatrix);
[val,idx]=sort(deg','descend');
figure();
subplot(111);
hist(val);
h1 = findobj(gca,'Type','patch');
set(h1,'FaceColor',[0.19,0.81,1],'EdgeColor','w');
title('Degree Distribution'); xlabel('Degree');ylabel('Num. of nodes with same degree');
%%================================ADVANCED=================================
function advance_menu_Callback(~, ~, handles)
% hObject    handle to advance_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Call the figure
Advance('PDB2Graph', handles.figure1,...
        'AMatrix'  , handles.BMatrix,...
        'Resid'    , handles.IDs,...
        'XY_POS'   , handles.XYpos,...
        'cutoff'   , handles.cutoff,...
        'filename' , handles.name,...
        'bios'     , handles.bios);

         
%%#########################################################################
%%################################<<HELP>>#################################
%%#########################################################################
function Help_Callback(~, ~, ~)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%==============================ABOUT PDBGRAPH=============================
function About_Callback(~, ~, ~)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
About();

%%#########################################################################
%%#########################################################################
%%=========================================================================
%%===============================TOOLBAR===================================
%%=========================================================================

%%==================================NEW====================================
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
New_3_Callback(hObject,eventdata,handles);
%%=================================OPEN====================================
 function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Open_4_Callback(hObject,eventdata,handles);
%%=================================LOAD====================================
function loadPDB_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to loadPDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadpdb_Callback(hObject,eventdata,handles);
%%===============================SAVE AS===================================
function uipushtool13_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Save_menu_Callback(hObject,eventdata,handles);
%%===============================MOLVIEWER=================================
function molviewer7_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to molviewer7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
molviewer_menu_Callback(hObject,eventdata,handles);
%%============================CIRCULAR GRAPH===============================
function circulargraph10_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to circulargraph10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cgraph_menu_Callback(hObject,eventdata,handles);
%%=============================PDB INFORMATION=============================
function PDBinfo9_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to PDBinfo9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PDBinfo_Callback(hObject,eventdata,handles);
%%=============================GRAPH FEATURES==============================
function GraphFeature8_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to GraphFeature8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphfeature_Callback(hObject,eventdata,handles);
%%===============================DOT MATRIX================================
function Dotmatrix12_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Dotmatrix12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dotmatrix_menu_Callback(hObject,eventdata,handles);
%%==============================DEGREE PLOT================================
function degreedis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to degreedis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ddplot_menu_Callback(hObject,eventdata,handles);
%%================================ADVANCED=================================
function advance_analyze14_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to advance_analyze14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
advance_menu_Callback(hObject,eventdata,handles);
%%#########################################################################
%%#########################################################################
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(~, ~, ~)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(~, ~, ~)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(~, ~, ~)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text54,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit12_Callback(~, ~, ~)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, ~, ~)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(~, ~, ~)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu11.
function popupmenu3_Callback(~, ~, ~)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Untitled_1_Callback(~, ~, ~)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(~, ~, ~)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15

% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(~, ~, ~)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16

% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(~, ~, ~)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17

% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(~, ~, ~)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(~, ~, ~)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19

% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider2_Callback(hObject, ~, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text53,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, ~, ~)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

