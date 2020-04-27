function [ HelixMat, SheetMat ] = helixsheet( input_addr, bios )
% Detailed explanation goes here

% [INPUT] input_addr is the address of the .pdb file
%         
% [OUTPUT] HelixMat is a matrix which define the alpha helix parts in pdb
%          SheetMat is a matrix which define the betta sheet parts in pdb
% TMU bioinformatics group, Last updated: February 07, 2015

pdb_address = input_addr;
FID2 = fopen(pdb_address,'r');
File_Name = fgetl(FID2);

if FID2==-1, error('Cannot open .pdb file'),
end
    
tline = fgetl(FID2);

HelixMat=[];
SheetMat=[];

i=0;
k=0;
% Parse pdb file (CA atom of each amino acid)
while ischar(tline)

    if (strcmp(tline(1:3),'ATOM')==1)
        break
    end
        
    y=str2num(tline(24:27));
        
    if (strcmp(tline(1:5),'HELIX')==1) & (strcmp(tline(20),'A')==1)
        
        i=i+1;
        starthelix = str2num(tline(23:25));
        endhelix   = str2num(tline(35:37));
        
        HelixMat(i,1) = starthelix-bios;
        HelixMat(i,2) = endhelix-bios;
        
    elseif (strcmp(tline(1:5),'SHEET')==1) & (strcmp(tline(22),'A')==1)    
        
        k=k+1;
        startsheet = str2num(tline(24:26));
        endsheet   = str2num(tline(35:37));
        
        SheetMat(k,1) = startsheet-bios;
        SheetMat(k,2) = endsheet-bios;
   
    end  
        tline = fgetl(FID2);
end
fclose(FID2);

end
