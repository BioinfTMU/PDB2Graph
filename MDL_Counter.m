function [mdl_num, mdl_flag]= MDL_Counter(input_name)
% MDL_COUNTER parses the .pdb file and return the number of models.
% [INPUT]: pdb files
% [OUTPUT]: mdl_num return the number of models.
%           mdl-flag is used to show the results in GUI.
% TMU bioinformatics group, Last updated: February 02, 2015

% Initialization

pdb_name = input_name;
mdl_num = 0;
mdl_flag = 0;

FID = fopen(pdb_name,'r');
if FID==-1, error('Cannot open PDB file')
end
tline = fgetl(FID);

while ischar(tline)
    if strcmp('HELIX',tline(1:5))==1
        break;
    end
    if strcmp('NUMMDL',tline(1:6))==1
       temp = tline(11:13);
       mdl_num = (1:str2double(temp));
       mdl_flag = 0;
    end
    tline = fgetl(FID);
end

if mdl_num == 0
    mdl_num = -1;
    mdl_flag = -1;
end

end
