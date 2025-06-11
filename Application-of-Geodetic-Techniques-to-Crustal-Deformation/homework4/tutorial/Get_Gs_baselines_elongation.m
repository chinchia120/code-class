function [Gss,Gds] = Get_Gs_baselines_elongation(pm,xystats,baselines,Vec_unit,crossind,L)

alpha = atan2(Vec_unit(:,2),Vec_unit(:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%backslip 
for k=1:size(pm,1)
     
         
        m_ss=[pm(k,:) 1 0 0];    
        [Uss,Ddummy,S]=disloc3d(m_ss',[xystats';zeros(1,size(xystats',2))],1,.25);
       
   
        
        Veast=Uss(1,:)'; Vnorth=Uss(2,:)';
        Vbase2 = Veast(baselines(:,2)).*Vec_unit(:,1) + Vnorth(baselines(:,2)).*Vec_unit(:,2);
        Vbase1 = Veast(baselines(:,1)).*Vec_unit(:,1) + Vnorth(baselines(:,1)).*Vec_unit(:,2);
        Vbase_ss = Vbase1 - Vbase2;

        
        
        m_ds=[pm(k,:) 0 1 0];    
        [Uds,Ddummy,S]=disloc3d(m_ds',[xystats';zeros(1,size(xystats',2))],1,.25);
       
        Veast=Uds(1,:)'; Vnorth=Uds(2,:)';
        Vbase2 = Veast(baselines(:,2)).*Vec_unit(:,1) + Vnorth(baselines(:,2)).*Vec_unit(:,2);
        Vbase1 = Veast(baselines(:,1)).*Vec_unit(:,1) + Vnorth(baselines(:,1)).*Vec_unit(:,2);
        Vbase_ds = Vbase1 - Vbase2;

     
       
        
        %integrate strain rates along line for baselines that cross faults
        %(avoid velocity discontinuity)
	N = 100;  %number of integration points
        for j=1:size(baselines,1)
            if crossind(j)==1
                xs = xystats(baselines(j,2),1) + cos(alpha(j))*( L(j)/N/2:L(j)/N:L(j) );
                ys = xystats(baselines(j,2),2) + sin(alpha(j))*( L(j)/N/2:L(j)/N:L(j) );
                
                [Udummy,Dds,S]=disloc3d(m_ds',[[xs;ys];zeros(1,length(xs))],1,.25);
                [Udummy,Dss,S]=disloc3d(m_ss',[[xs;ys];zeros(1,length(xs))],1,.25);
                
                Exx_ss = sum(Dss(1,:));
                Exy_ss = sum(.5*(Dss(2,:)+Dss(4,:)));
                Eyy_ss = sum(Dss(5,:));

                Exx_ds = sum(Dds(1,:));
                Exy_ds = sum(.5*(Dds(2,:)+Dds(4,:)));
                Eyy_ds = sum(Dds(5,:));
        

                Vcenters_ss(j) = L(j)/N*(Exx_ss*cos(alpha(j))^2 + Exy_ss*2*cos(alpha(j))*sin(alpha(j)) + Eyy_ss*sin(alpha(j))^2);  %equation 1.21, Segall text
                Vcenters_ds(j) = L(j)/N*(Exx_ds*cos(alpha(j))^2 + Exy_ds*2*cos(alpha(j))*sin(alpha(j)) + Eyy_ds*sin(alpha(j))^2);  %equation 1.21, Segall text
           
            else
                
                Vcenters_ss(j) = 0; Vcenters_ds(j) = 0;
            
            end
        end
        
        Vbase_ss(crossind)=Vcenters_ss(crossind);
        Vbase_ds(crossind)=Vcenters_ds(crossind);
        
        Gss(:,k)=Vbase_ss;
        Gds(:,k)=Vbase_ds;

       

            
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




