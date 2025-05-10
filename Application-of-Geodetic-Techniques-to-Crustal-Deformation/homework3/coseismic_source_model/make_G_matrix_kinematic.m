%pm is patch model for slip patches\
%all other parameters generated in make_baseline_rates_KE.m\
%build strike-slip (Gss) and dip-slip (Gds) matrices that relate slip on dislocation to baseline elongations\
G=[];
for k=1:size(data,2)
    if datatype{k}==1
        [Gss,Gds] = Get_Gs_horizontal(pm,xy{k});
    elseif datatype{k}==2
        [Gss,Gds] = Get_Gs_vertical(pm,xy{k});
    elseif datatype{k}==3
        [Gss,Gds] = Get_Gs_insar(pm,xy{k},look{k});
    end
    G=[G;[Gss,Gds]];
end
