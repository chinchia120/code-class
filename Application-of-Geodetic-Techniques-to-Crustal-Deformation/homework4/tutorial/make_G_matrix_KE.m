%pm is patch model for slip patches\
%all other parameters generated in make_baseline_rates_KE.m\
%build strike-slip (Gss) and dip-slip (Gds) matrices that relate slip on dislocation to baseline elongations\
G=[];
for k=1:size(data,2)
    if datatype{k}==1
        [Gss,Gds] = Get_Gs_baselines_elongation(pm,xy{k},baselines{k},Vec_unit{k},crossind{k},L{k});
    elseif datatype{k}==2
        [Gss,Gds] = Get_Gs_baselines_tilt(pm,xy{k},baselines{k},Vec_unit{k},crossind{k},L{k});
    elseif datatype{k}==3
        [Gss,Gds] = Get_Gs_baselines_tilt_insar(pm,xy{k},baselines{k},Vec_unit{k},crossind{k},L{k},look{k});
    end
    G=[G;[Gss,Gds]];
end
