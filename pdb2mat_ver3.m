function [amat,Residu_ID, XYPOS, AAType, bios] = pdb2mat_ver3(input_name,Chain_id,Graph_Type,MDL_num,cut_off)
%  PDB2MAT is a pdb parser which reads the X-ray crystallography or NMR
%  files and parse them then make an adjacency matrix from the requested
%  part of the pdb file.

% [Input] Parameters:
% input_addr: The address of PDB files
% Chain_id: The name of desired PDB Chain
% Graph_Type: The name of the atom for making graph: 'CA','CB' or 'gc'r 'gc_all' o for geometry center
% MDL_num: in NMR pdb files, it determines the number of desired Model. If
% the pdb file is from X-ray type, choose MDL_num=-1
% cut_off can be in the rang of 5.0-7.0
% [OUTPUT] amat is the Adjacancy Matrix of the .pdb file
% Residu_ID is a list of IDs for graphs' node
% XYPOS used to draw graph in real X-Y position
% bios used to put nodes in their correct position
% TMU bioinformatics group, Last updated: February 07, 2015

cutoff=cut_off;
pdb_name = input_name;
FID2 = fopen(pdb_name,'r');

if FID2==-1, error('Cannot open PDB file'),
end
tline = fgetl(FID2);
A={};
i=0;

%gc function execution
if strcmp(Graph_Type,'gc')==1
    Geometry_Center2
end

if strcmp(Graph_Type,'gc_all')==1
    Geometric_Center_All
end

% Parse pdb file (CA atom of each amino acid)
while(ischar(tline) && MDL_num == -1 && strcmp(Graph_Type,'gc')==0 && strcmp(Graph_Type,'gc_all')==0)
    
    if strcmp(Graph_Type,'CB')==1 && strcmp(tline(18:20),'GLY')==1
        Graph_type2='CA';
    else
        Graph_type2=Graph_Type;
    end
    
    if (strcmp(tline(1:4),'ATOM')==1 && strcmp(tline(22),Chain_id)==1 && (strcmp(tline(14:15),Graph_type2)==1)) && strcmp(tline(17),'B')==0
    
        
        
        i=i+1;
        res_id(i)=str2double(tline(23:26));
        if (i==1)
            bios = res_id(i)-1; % bios is used to label graph nodes correctly.
        end
        A{i,1}=str2double(tline(23:26));
        A{i,2}=tline(18:20);
        A{i,3}=str2double(tline(31:38));
        A{i,4}=str2double(tline(39:46));
        A{i,5}=str2double(tline(47:54));
        
    end
    tline = fgetl(FID2);
    if ((strcmp(Chain_id,tline(22))==1) && (strcmp(tline(1:3),'TER')==1 || strcmp(tline(1:3),'END')==1))
        
        break;
        
    end
end

if strcmp('MODEL',tline(1:5)==1) && isequal(MDL_num,str2double(tline(13:14)))==1
    
    tline = fgetl(FID2);
end

while (ischar(tline) && MDL_num~=-1 && strcmp(Graph_Type,'gc')==0 && strcmp(Graph_Type,'gc_all')==0)
    
    if (strcmp(Chain_id,tline(22))==1) && (strcmp(tline(1:3),'TER')==1 || strcmp(tline(1:6),'ENDMDL')==1)
        
        break;
        
    end
    
    if strcmp(Graph_Type,'CB')==1 && strcmp(tline(18:20),'GLY')==1
        Graph_type2='CA';
    else
        Graph_type2=Graph_Type;
    end    
    
    if (strcmp(tline(22),Chain_id)==1) && strcmp(tline(1:4),'ATOM')==1 && (strcmp(tline(14:15),Graph_type2)==1) && y>=1 && isspace(tline(27))==1 && strcmp(tline(17),'B')==0
        
        i=i+1;
        res_id(i)=str2double(tline(23:26));
        if (i==1)
            bios = res_id(i)-1; % bios is used to label graph nodes correctly.
        end
        A{i,1}=str2double(tline(23:26));
        A{i,2}=tline(18:20);
        A{i,3}=str2double(tline(31:38));
        A{i,4}=str2double(tline(39:46));
        A{i,5}=str2double(tline(47:54));
    end
    
    tline = fgetl(FID2);
    y=str2double(tline(24:27));
end
fclose(FID2);

emptyCells = cellfun('isempty', A);
A(all(emptyCells,2),:) = [];
XYPOS(:,1) = A(:,3);
XYPOS(:,2) = A(:,4);
AAType = A(:,2);

% Make adjacency matrix
%B=zeros(i,i);
v=length(A);
B=size(v,v);

for k=1:length(A)    
    Res = strcat(A{k,2},num2str(A{k,1}));
     Residu_ID{1,k}=Res;
end

for i=1:length(A)
    for j=1:length(A)
        B(i,j)=((A{i,3}-A{j,3})^2 + (A{i,4}-A{j,4})^2 + (A{i,5}-A{j,5})^2 )^0.5;
        if B(i,j)<=cutoff && B(i,j)~=0
            B(i,j)=1;
        elseif B(i,j)>cutoff
            B(i,j)=0;
        end
    end
end
amat = B; %for MST
