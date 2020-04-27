
function [betw_normal] = between_normal(betweenness)

C= max(betweenness);
D=min(betweenness);
betw_normal=size(1,length(betweenness));

for i = 1:length(betweenness)
    
    betw_normal(i,1)= (betweenness(1,i)-D)/(C-D)
end
  
    