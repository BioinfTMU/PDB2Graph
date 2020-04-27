% This is an script for constructing a graph from geometric center of each
% amino acid in a pdb file. This is called in the function
% GUI_PDB2MAT_ver3. The inputs are the inputs of that function. In this
% script MDL_num and Chain_id are used. The output is A which is a cell
% with information of name, chain_id, MDL_num of each amino acid as well as
% the XY position of the geometric center of that amino acid. 
% TMU bioinformatics group, Last updated: February 07, 2015

A_temp={};
i=0;

% Parse pdb file (CA atom of each amino acid)
while(ischar(tline) && MDL_num == -1)
    
    if (strcmp(tline(1:4),'ATOM')==1 && strcmp(tline(22),Chain_id)==1 && strcmp(tline(17),'B')==0 )
        
        i=i+1;
        res_id(i)=str2double(tline(23:26));
        if (i==1)
            bios = res_id(i)-1; % bios is used to label graph node correctly.
        end        
        A_temp{i,1}=str2double(tline(23:26));
        A_temp{i,2}=tline(18:20);
        A_temp{i,3}=str2double(tline(31:38));
        A_temp{i,4}=str2double(tline(39:46));
        A_temp{i,5}=str2double(tline(47:54));
        A_temp{i,6}(1,1:3)=tline(14:16);
        
    end
    tline = fgetl(FID2);
    if ( (strcmp(Chain_id,tline(22))==1) && (strcmp(tline(1:3),'TER')==1 || strcmp(tline(1:3),'END')==1))
        
        break;
        
    end
end

if strcmp('MODEL',tline(1:5)==1) && isequal(MDL_num,str2double(tline(13:14)))==1
    
    tline = fgetl(FID2);
end

while (ischar(tline) && MDL_num~=-1)
    
    if (strcmp(Chain_id,tline(22))==1) && (strcmp(tline(1:3),'TER')==1 || strcmp(tline(1:6),'ENDMDL')==1)
        
        break;
        
    end
    
    if (strcmp(tline(22),Chain_id)==1) && strcmp(tline(1:4),'ATOM')==1 && isspace(tline(27))==1
        
        i=i+1;
        res_id(i)=str2double(tline(23:26));
        if (i==1)
            bios = res_id(i)-1; % bios is used to label graph node correctly.
        end        
        A_temp{i,1}=str2double(tline(23:26));
        A_temp{i,2}=tline(18:20);
        A_temp{i,3}=str2double(tline(31:38));
        A_temp{i,4}=str2double(tline(39:46));
        A_temp{i,5}=str2double(tline(47:54));
        A_temp{i,6}(1,1:3)=tline(14:16);
    end
    
    tline = fgetl(FID2);
    y=str2double(tline(24:27));
end
% fclose(FID2);
emptyCells = cellfun('isempty', A_temp);
A_temp(all(emptyCells,2),:) = [];
k=1;

h=0;
m=1;
A_temp2=[];
for g=1:length(A_temp)
    
    
    if g==length(A_temp)
        A_temp2(m,1)= A_temp{g,3};
        A_temp2(m,2)= A_temp{g,4};
        A_temp2(m,3)= A_temp{g,5};
        h=h+1;
        A{h,1}=A_temp{g,1};
        A{h,2}(1,:)=A_temp{g,2}(1,1:3);
        A{h,3}=A_temp2(m,1);
        A{h,4}=A_temp2(m,2);
        A{h,5}=A_temp2(m,3);
        break;
    end
    
    if A_temp{g,1}==A_temp{(g+1),1}
        A_temp2(m,1)= A_temp{g,3};
        A_temp2(m,2)= A_temp{g,4};
        A_temp2(m,3)= A_temp{g,5};
        m=m+1;
        continue;
    else
        A_temp2(m,1)= A_temp{g,3};
        A_temp2(m,2)= A_temp{g,4};
        A_temp2(m,3)= A_temp{g,5};
        h=h+1;
        A{h,1}=A_temp{g,1};
        A{h,2}(1,:)=A_temp{g,2}(1,1:3);
        M=mean(A_temp2);
        A{h,3}=M(1,1);
        A{h,4}=M(1,2);
        A{h,5}=M(1,3);
        A_temp2=[];
        m=1;
        M=[];
    end
    continue;
end




