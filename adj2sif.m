function adj2sif(amat,Residu_ID,Graph_Type)
% Save the Adjacency Matrix in .sif format
% input: amat: Adjacency Matrix.
%        Residu_ID: Name of amino acids.
%        Graph_Type:
% Output: .sif file save in directory.
% TMU bioinformatics group, Last updated: February 07, 2015

int=['contact:' Graph_Type '-' Graph_Type];
Fid = fopen('net.sif','w');

for i=1:length(Residu_ID)
    for j=1:length(Residu_ID)
        if amat(i,j)==1
            T= Residu_ID{1,i}(1,1:end);
            U= Residu_ID{1,j}(1,1:end);
            fprintf(Fid,'%s\t%s\t%s\n',T,int,U);
            
        end
    end
end

fclose(Fid);
