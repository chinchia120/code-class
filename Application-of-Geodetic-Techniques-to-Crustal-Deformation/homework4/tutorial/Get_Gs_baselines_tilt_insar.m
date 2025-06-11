function [Gss,Gds] = Get_Gs_baselines_tilt_insar(pm,xystats,baselines,Vec_unit,crossind,L,insar_look)

alpha = atan2(Vec_unit(:,2),Vec_unit(:,1));

insar_look(1)=180-insar_look(1);
insar_look=insar_look*pi/180; %convert to radians
insar_vector(1)= sin(insar_look(1))*sin(insar_look(2)); %E
insar_vector(2)=-cos(insar_look(1))*sin(insar_look(2)); %N
insar_vector(3)= cos(insar_look(2));                    %U

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%backslip 
for k=1:size(pm,1)
         
        m_ss=[pm(k,:) 1 0 0];    
        [Uss,Ddummy,S]=disloc3d(m_ss',[xystats';zeros(1,size(xystats',2))],1,.25);

        Vlos=Uss(1,:)'*insar_vector(1) + Uss(2,:)'*insar_vector(2) + Uss(3,:)'*insar_vector(3);
        Vbase2 = Vlos(baselines(:,2));Vbase1 = Vlos(baselines(:,1));
        Vbase_ss = Vbase1 - Vbase2;

        
        m_ds=[pm(k,:) 0 1 0];    
        [Uds,Ddummy,S]=disloc3d(m_ds',[xystats';zeros(1,size(xystats',2))],1,.25);
       
        Vlos=Uds(1,:)'*insar_vector(1) + Uds(2,:)'*insar_vector(2) + Uds(3,:)'*insar_vector(3);
        Vbase2 = Vlos(baselines(:,2));Vbase1 = Vlos(baselines(:,1));
        Vbase_ds = Vbase1 - Vbase2;

        %integrate tilt rates along line for baselines that cross faults
        %(avoid velocity discontinuity)
	N = 2000;  %number of integration points
        for j=1:size(baselines,1)
            if crossind(j)==1
                centers_patches = [pm(k,6)-pm(k,2).*cos(pm(k,4)*pi/180).*cos(pm(k,5)*pi/180) pm(k,7)+pm(k,2).*cos(pm(k,4)*pi/180).*sin(pm(k,5)*pi/180)];
                PatchEnds = [centers_patches(1,1)+.5*pm(k,1).*cos( (90-pm(k,5))*pi/180) centers_patches(1,2)+.5*pm(k,1).*sin( (90-pm(k,5))*pi/180) centers_patches(1,1)-.5*pm(k,1).*cos( (90-pm(k,5))*pi/180) centers_patches(1,2)-.5*pm(k,1).*sin( (90-pm(k,5))*pi/180)];
                is_surface = abs(pm(k,3)-pm(k,2).*sin(pm(k,4)*pi/180))<10^-3;
                
                int = intersectEdges([xystats(baselines(j,1),1),xystats(baselines(j,1),2),xystats(baselines(j,2),1),xystats(baselines(j,2),2)], PatchEnds(is_surface,:));
                crosssegind_1 = sum(sum(~isnan(int)))>0;

                if crosssegind_1 == 0
                    Vseg_ss_all(j) = Vbase_ss(j); Vseg_ds_all(j) = Vbase_ds(j);
                    continue
                else
                    xs = xystats(baselines(j,1),1) - cos(alpha(j))*(0:L(j)/N:L(j));
                    ys = xystats(baselines(j,1),2) - sin(alpha(j))*(0:L(j)/N:L(j));
                    
                    for i=1:N
                        int = intersectEdges([xs(i),ys(i),xs(i+1),ys(i+1)], PatchEnds(is_surface,:));
                        crosssegind(i) = sum(sum(~isnan(int)))>0;
                    end
                    
                    [Ddummy,b]=max(crosssegind);
                    if b==1
                        xs_n=[xs(b+1),xs(end)];
                        ys_n=[ys(b+1),ys(end)];
                        [Uss,Ddummy,S]=disloc3d(m_ss',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ss=Uss(1,:)'*insar_vector(1) + Uss(2,:)'*insar_vector(2) + Uss(3,:)'*insar_vector(3);
                        Vseg_ss_all(j) = Vlos_ss(1)-Vlos_ss(2);
                        [Uds,Ddummy,S]=disloc3d(m_ds',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ds=Uds(1,:)'*insar_vector(1) + Uds(2,:)'*insar_vector(2) + Uds(3,:)'*insar_vector(3);
                        Vseg_ds_all(j) = Vlos_ds(1)-Vlos_ds(2);
                        
                    elseif b==N
                        xs_n=[xs(1),xs(b)];
                        ys_n=[ys(1),ys(b)];
                        [Uss,Ddummy,S]=disloc3d(m_ss',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ss=Uss(1,:)'*insar_vector(1) + Uss(2,:)'*insar_vector(2) + Uss(3,:)'*insar_vector(3);
                        Vseg_ss_all(j) = Vlos_ss(1)-Vlos_ss(2);
                        [Uds,Ddummy,S]=disloc3d(m_ds',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ds=Uds(1,:)'*insar_vector(1) + Uds(2,:)'*insar_vector(2) + Uds(3,:)'*insar_vector(3);
                        Vseg_ds_all(j) = Vlos_ds(1)-Vlos_ds(2);
                        
                    else
                        xs_n=[xs(1),xs(b),xs(b+1),xs(end)];
                        ys_n=[ys(1),ys(b),ys(b+1),ys(end)];
                        [Uss,Ddummy,S]=disloc3d(m_ss',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ss=Uss(1,:)'*insar_vector(1) + Uss(2,:)'*insar_vector(2) + Uss(3,:)'*insar_vector(3);
                        Vseg_ss_all(j) = (Vlos_ss(1)-Vlos_ss(2))+(Vlos_ss(3)-Vlos_ss(4));
                        [Uds,Ddummy,S]=disloc3d(m_ds',[[xs_n;ys_n];zeros(1,length(xs_n))],1,.25);
                        Vlos_ds=Uds(1,:)'*insar_vector(1) + Uds(2,:)'*insar_vector(2) + Uds(3,:)'*insar_vector(3);
                        Vseg_ds_all(j) = (Vlos_ds(1)-Vlos_ds(2))+(Vlos_ds(3)-Vlos_ds(4));
                    end
                    
                end
           
            else
                
                Vseg_ss_all(j) = 0; Vseg_ds_all(j) = 0;
            
            end
        end
        
        Vbase_ss(crossind)=Vseg_ss_all(crossind);
        Vbase_ds(crossind)=Vseg_ds_all(crossind);

        Gss(:,k)=Vbase_ss;
        Gds(:,k)=Vbase_ds;

        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




