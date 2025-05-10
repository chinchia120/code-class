function [Gss,Gds] = Get_Gs_insar(pm,xystats,insar_look)

insar_look(1)=insar_look(1)-270;
insar_look=insar_look*pi/180; %convert to radians
insar_vector(1)=-sin(insar_look(1))*sin(insar_look(2)); %E
insar_vector(2)=-cos(insar_look(1))*sin(insar_look(2)); %N
insar_vector(3)= cos(insar_look(2));                    %U

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%backslip 
for k=1:size(pm,1)
         
        m_ss=[pm(k,:) 1 0 0];    
        [Uss,Ddummy,S]=disloc3d(m_ss',[xystats';zeros(1,size(xystats',2))],1,.25);
        Vlos_ss=Uss(1,:)'*insar_vector(1) + Uss(2,:)'*insar_vector(2) + Uss(3,:)'*insar_vector(3);

        m_ds=[pm(k,:) 0 1 0];    
        [Uds,Ddummy,S]=disloc3d(m_ds',[xystats';zeros(1,size(xystats',2))],1,.25);
        Vlos_ds=Uds(1,:)'*insar_vector(1) + Uds(2,:)'*insar_vector(2) + Uds(3,:)'*insar_vector(3);

        Gss(:,k)=Vlos_ss;
        Gds(:,k)=Vlos_ds;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
