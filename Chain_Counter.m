function [Chain_ID]= Chain_Counter(input_name,MDL_num)
% If the pdb file is of NMR type, then MDL_num is the number of desired
% model.
% input: input_name: Address and name of the PDB file.
%        MDL_num: If the pdb file is of crystallographic kind, the
%        MDL_num is -1.
% Output: Chain_ID: a matrix which includes the name of protein chains.
% TMU bioinformatics group, Last updated: February 07, 2015

fid_c=fopen(input_name,'r');
if fid_c==-1, error('Cannot open PDB file')
end
tline = fgetl(fid_c);
A={};
i=0;

% Parse pdb file (CA atom of each amino acid)
while(ischar(tline) && MDL_num == -1)
    
    if (strcmp(tline(1:4),'ATOM')==1 && (strcmp(tline(14:15),'CA')==1) )
        
        i=i+1;
        A{i,1}=tline(22);
        
    end
    tline = fgetl(fid_c);    
end

while(ischar(tline) && MDL_num ~= -1)
    
    if (strcmp(tline(1:4),'ATOM')==1 && (strcmp(tline(14:15),'CA')==1) )
        
        i=i+1;
        A{i,1}=tline(22);
		elseif strcmp(tline(1:5),'MODEL')==1 && strcmp(tline(13:14), num2str(MDL_num))==1
		break;        
    end
    tline = fgetl(fid_c);    
end

k=0;
Chain_ID=[];
for j=1:length(A)
    if j==length(A)
        Chain_ID=[Chain_ID;A{j,1}];
    elseif strcmp(A{j,1},A{(j+1),1})~=1
        Chain_ID=[Chain_ID;A{j,1}];
    end
end
