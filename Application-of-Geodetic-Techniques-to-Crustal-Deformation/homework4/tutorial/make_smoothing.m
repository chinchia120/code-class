%NOTE: slip is smoothed to zero at surface
for k=1:size(fault_x,2)
    if ~isnan(isSurf{k})
        [Lap{k},Lap_inv]=modelwt(nve{k},nhe{k},pm_pre{k}(1,1),pm_pre{k}(1,2),isSurf{k}); %Lap = Laplacian operator (discrete)
    end
end
%strike-slip component
Lapp_ss_all=[];
for k1=1:size(fault_x,2) %smoothing seg.
    if isnan(isSurf{k1})
        continue
    else
        Lapp_ss=[];
        for k2=1:size(fault_x,2) %non-smoothing seg.
            if k1==k2
                Lapp_ss=[Lapp_ss,Lap{k1}];
            else
                Lapp_ss=[Lapp_ss,zeros(size(pm_pre{k1},1),size(pm_pre{k2},1))];
            end
        end
        Lapp_ss_all=[Lapp_ss_all;Lapp_ss];
    end
end
Lapp=[[Lapp_ss_all,zeros(size(Lapp_ss_all))];[zeros(size(Lapp_ss_all)),Lapp_ss_all]];
