function [Gss,Gds] = Get_Gs_horizontal(pm,xystats)

for k=1:size(pm,1)
        m_ss=[pm(k,:) 1 0 0];    
        [Uss,Ddummy,S]=disloc3d(m_ss',[xystats';zeros(1,size(xystats',2))],1,.25);
        Deast_ss=Uss(1,:)'; Dnorth_ss=Uss(2,:)';

        m_ds=[pm(k,:) 0 1 0];    
        [Uds,Ddummy,S]=disloc3d(m_ds',[xystats';zeros(1,size(xystats',2))],1,.25);
        Deast_ds=Uds(1,:)'; Dnorth_ds=Uds(2,:)';

        Gss(:,k)=[Deast_ss;Dnorth_ss];
        Gds(:,k)=[Deast_ds;Dnorth_ds];
end
