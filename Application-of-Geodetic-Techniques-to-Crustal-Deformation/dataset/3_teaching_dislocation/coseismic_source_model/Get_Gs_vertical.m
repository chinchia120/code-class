function [Gss,Gds] = Get_Gs_vertical(pm,xystats)

for k=1:size(pm,1)
         
        m_ss=[pm(k,:) 1 0 0];    
        [Uss,Ddummy,S]=disloc3d(m_ss',[xystats';zeros(1,size(xystats',2))],1,.25);
        Dup_ss=Uss(3,:)';
        
        m_ds=[pm(k,:) 0 1 0];    
        [Uds,Ddummy,S]=disloc3d(m_ds',[xystats';zeros(1,size(xystats',2))],1,.25);
        Dup_ds=Uds(3,:)';

        Gss(:,k)=Dup_ss;
        Gds(:,k)=Dup_ds;
end
