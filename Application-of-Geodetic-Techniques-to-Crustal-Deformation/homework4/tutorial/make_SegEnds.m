function SegEnds=make_SegEnds(fault_x,fault_y,origin)

faulttrace=[fault_y;fault_x];
faulttrace=ll2xy(faulttrace,origin);

nhe=size(fault_x,2)-1;  %number horizontal elements 

fault_node_x=faulttrace(:,1);
fault_node_y=faulttrace(:,2);
for k=1:nhe
    SegEnds(k,:)=[fault_node_x(k,1),fault_node_y(k,1),fault_node_x(k+1,1),fault_node_y(k+1,1)];
end
