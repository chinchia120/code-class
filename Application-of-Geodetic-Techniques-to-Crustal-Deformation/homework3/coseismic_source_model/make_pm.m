function [pm,nhe,nve,strike_all]=make_pm(fault_x,fault_y,dep,dp,origin)

faulttrace=[fault_y;fault_x];
faulttrace=ll2xy(faulttrace,origin);

nhe=size(fault_x,2)-1;  %number horizontal elements 
nve=size(dep,2)-1;  %number vertical elements

strike_all=atan2((faulttrace(end,1)-faulttrace(1,1)),(faulttrace(end,2)-faulttrace(1,2)))*180/pi;
fault_node_x=faulttrace(:,1);
fault_node_y=faulttrace(:,2);
for k=2:nve
    offset=(dep(k)-dep(k-1))/tan(dp(k-1)*pi/180);
    e_off=offset*cos(strike_all*pi/180);
    n_off=offset*sin(strike_all*pi/180);
    fault_node_x(:,k)=[fault_node_x(:,end)+e_off];
    fault_node_y(:,k)=[fault_node_y(:,end)-n_off];
end

npatches=0;
for k1=1:nhe
    for k2=1:nve
        npatches=npatches+1;
        length=sqrt((fault_node_x(k1+1,k2)-fault_node_x(k1,k2))^2+(fault_node_y(k1+1,k2)-fault_node_y(k1,k2))^2);
        width=(dep(k2+1)-dep(k2))/sin(dp(k2)*pi/180);
        depth=dep(k2);
        dip=dp(k2);
        strike=atan2((fault_node_x(k1+1,k2)-fault_node_x(k1,k2)),(fault_node_y(k1+1,k2)-fault_node_y(k1,k2)))*180/pi;
        if strike<0; strike=strike+360; end
        centerx=(fault_node_x(k1+1,k2)+fault_node_x(k1,k2))/2;
        centery=(fault_node_y(k1+1,k2)+fault_node_y(k1,k2))/2;
        fault(npatches,:)=[length width depth dip strike centerx centery];
    end
end

%create fault patches
for k=1:size(fault,1)
    pm(k,:) = movefault(fault(k,:));
end
