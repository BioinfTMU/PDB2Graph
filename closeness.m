% Computes the closeness centrality for every vertex: 1/average(dist to all other nodes)
% INPUTs: graph representation (adjacency matrix nxn)
% OUTPUTs: vector of centralities, nx1
% Source: social networks literature
% Other routines used: simple_dijkstra.m 
% GB, Last updated: October 9, 2009

function C=closeness(adj)

C=zeros(length(adj),1);  % initialize closeness vector

for i=1:length(adj); C(i)=1/mean( simple_dijkstra(adj,i) ); end
