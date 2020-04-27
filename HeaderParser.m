function [Header,Title,EXPDTA,NumAA_i,NumAA_f,Seq3]= HeaderParser(input_name)
%  The program Header_Parser reads a pdb hearder and retreive the
%  information about the expermental method of structure determination, if
%  it is a NMR file, the number of models in pdb file, the number and name
%  of the avialable chains in pdb and the number of amino acids in each
%  one.
% Input Data:
% The address of required PDB file
% OUTPUT:
% 1. EXPDTA: The experimental method of structure determination
% 2. NUMMDL: The number of models in NMR files
% 3. NumChains: The number and name of the chains in pdb file/
% 4. NumAA: The range and number of amino acids in each chain
%    NumAA_i: The initial amino acid in each chain
%    NumAA_f: The final amino acid in each chain
% 5. Seq3: The sequence of protein from pdb file header
% TMU bioinformatics group, Last updated: February 07, 2015

pdb_name = input_name;
FID = fopen(pdb_name,'r');

if FID==-1, error('Cannot open PDB file')
end
tline = fgetl(FID);

% Parse pdb header`s file
Header={};
Title={};
%NumChains=[];
NumAA_i=[];
NumAA_f=[];
Seq={};
i=0;
titlectr=0;
while ischar(tline)
    if strcmp('HELIX',tline(1:5))==1
        break;
    end
    if strcmp('HEADER',tline(1:6))==1
        Header=tline(11:40);
    end
    
    if strcmp('TITLE',tline(1:5))==1
        %Title={Title;tline(11:80)}
        titlectr = titlectr+1;
        Title(titlectr,1)={tline(11:80)};
    end
        
    
    if (strcmp('EXPDTA',tline(1:6))==1)
        EXPDTA=tline(10:28);
    end
    
%     if (strcmp('X-RAY DIFFRACTION',tline(11:27))==1)
%         NUMMDL=num2str(1);
%     end
    
%     if strcmp('NUMMDL',tline(1:6))==1
%        NUMMDL = tline(11:13);
%     end
    
    if strcmp('DBREF',tline(1:5))
%        NumChains=[NumChains;tline(13)];
        NumAA_i=[NumAA_i;str2num(tline(18))];
        NumAA_f=[NumAA_f;str2num(tline(22:26))];
    end
    
    if strcmp('SEQRES',tline(1:6))==1
        i=i+1;
        Seq(i,1)={tline(20:70)};
    end
    
    
    tline = fgetl(FID);
end
Seq_2=strrep(Seq,' ','');
Seq3=[];

for j=1:length(Seq_2)
    for k=1:3:length(Seq_2{j,1})
        switch Seq_2{j,1}(1,k:k+2)
            case {'ALA'};
                Seq3=[Seq3,'A'];
            case {'ARG'};
                Seq3=[Seq3,'R'];
            case {'ASN'};
                Seq3=[Seq3,'N'];
            case {'ASP'};
                Seq3=[Seq3,'D'];
            case {'CYS'};
                Seq3=[Seq3,'C'];
            case {'GLN'};
                Seq3=[Seq3,'Q'];
            case {'GLU'};
                Seq3=[Seq3,'E'];
            case {'GLY'};
                Seq3=[Seq3,'G'];
            case {'HIS'};
                Seq3=[Seq3,'H'];
            case {'ILE'};
                Seq3=[Seq3,'I'];
            case {'LEU'};
                Seq3=[Seq3,'L'];
            case {'LYS'};
                Seq3=[Seq3,'K'];
            case {'MET'};
                Seq3=[Seq3,'M'];
            case {'PHE'};
                Seq3=[Seq3,'F'];
            case {'PRO'};
                Seq3=[Seq3,'P'];
            case {'SER'};
                Seq3=[Seq3,'S'];
            case {'THR'};
                Seq3=[Seq3,'T'];
            case {'TRP'};
                Seq3=[Seq3,'W'];
            case {'TYR'};
                Seq3=[Seq3,'Y'];
            case {'VAL'};
                Seq3=[Seq3,'V'];
                
        end
    end
end

Ftitle = '';
for k=1:length(Title)
    Ftitle = strcat(Ftitle,Title{k,1}(:,:));
end

Title = Ftitle;

