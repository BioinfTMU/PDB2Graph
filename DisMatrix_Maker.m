function [Distance_Mat]= DisMatrix_Maker(pdb1,chain1)

A={};
i=0;
name = pdb1;
chain_id = chain1;
FID = fopen(name,'r');

if FID==-1, error('Cannot open pdb file');
end
File_Name = fgetl(FID);

while ischar(File_Name)
    % Parse pdb file (CA atom of each amino acid)
    
    if (strcmp(File_Name(1:3),'TER')==1 & strcmp(File_Name(22),chain_id)==1)
        break;
    end
    y=str2num(File_Name(24:27));
    
    if (strcmp(File_Name(1:4),'ATOM')==1) & (strcmp(File_Name(14:15),'CA')==1) & strcmp(File_Name(22),chain_id)==1 & y>=1 & isspace(File_Name(27))==1
        
        i=i+1;
        res_id(i)=str2num(File_Name(23:26));
        
        A{res_id(i),1}=str2num(File_Name(23:26));
        A{res_id(i),2}=File_Name(18:20);
        A{res_id(i),3}=str2num(File_Name(31:38));
        A{res_id(i),4}=str2num(File_Name(39:46));
        A{res_id(i),5}=str2num(File_Name(47:54));
        
    end
    
    File_Name = fgetl(FID);
end

fclose(FID);
emptyCells = cellfun('isempty', A);
A(all(emptyCells,2),:) = [];
% Make adjacency matrix
B=zeros(i,i);


for i=1:length(A)
    for j=1:length(A)
        B(i,j)=((A{i,3}-A{j,3})^2 + (A{i,4}-A{j,4})^2 + (A{i,5}-A{j,5})^2 )^0.5;
        
    end
    
end
Distance_Mat=B;
name2 = [pdb1(1:4) '_Dist_Mat.mat'];
% xlswrite(name2,Distance_Mat);
save(name2,'Distance_Mat');
