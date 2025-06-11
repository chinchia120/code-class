%% plot results %%%%
for k=1:size(data,2)
    %plot obsevations
    figure; hold on;
    for j=1:size(BaseEnds{k},1)
        obs{k}(j)=Vbase{k}(j)/L{k}(j);
        cline([BaseEnds{k}(j,1) BaseEnds{k}(j,3)],[BaseEnds{k}(j,2) BaseEnds{k}(j,4)],[obs{k}(j) obs{k}(j)])
    end
    for j=1:size(SegEnds,1);  plot([SegEnds(j,1) SegEnds(j,3)],[SegEnds(j,2) SegEnds(j,4)],'k'); end
    
    if datatype{k}==1
        title('Observations (Horizontal elongation rate)')
    elseif datatype{k}==2
        title('Observations (Vertical tilt rate)')
    elseif datatype{k}==3
        title('Observations (LOS tilt rate)')
    end
    colorbar
    caxis([-1 1])
    axis equal

    %plot calculations
    figure; hold on;
    for j=1:size(BaseEnds{k},1)
        cal{k}(j)=dhat_set{k}(j)/L{k}(j);
        cline([BaseEnds{k}(j,1) BaseEnds{k}(j,3)],[BaseEnds{k}(j,2) BaseEnds{k}(j,4)],[cal{k}(j) cal{k}(j)])
    end
    for j=1:size(SegEnds,1);  plot([SegEnds(j,1) SegEnds(j,3)],[SegEnds(j,2) SegEnds(j,4)],'k'); end
    
    if datatype{k}==1
        title('Calculations (Horizontal elongation rate)')
    elseif datatype{k}==2
        title('Calculations (Vertical tilt rate)')
    elseif datatype{k}==3
        title('Calculations (LOS tilt rate)')
    end
    colorbar
    caxis([-1 1])
    axis equal

    %plot residuals
    figure; hold on;
    for j=1:size(BaseEnds{k},1)
        res{k}(j)=(Vbase{k}(j)-dhat_set{k}(j))/L{k}(j);
        cline([BaseEnds{k}(j,1) BaseEnds{k}(j,3)],[BaseEnds{k}(j,2) BaseEnds{k}(j,4)],[res{k}(j) res{k}(j)])
    end
    for j=1:size(SegEnds,1);  plot([SegEnds(j,1) SegEnds(j,3)],[SegEnds(j,2) SegEnds(j,4)],'k'); end
    
    if datatype{k}==1
        title('Residuals (Horizontal elongation rate)')
    elseif datatype{k}==2
        title('Residuals (Vertical tilt rate)')
    elseif datatype{k}==3
        title('Residuals (LOS tilt rate)')
    end
    colorbar
    caxis([-1 1])
    axis equal
end

%plot fault geometry and slip distribution
for k=1:size(fault_x,2)
    ss_pre{k}=s(np{k}+1:np{k+1});
    ds_pre{k}=s(npatches+np{k}+1:npatches+np{k+1});
    s_pre{k}=[ss_pre{k};ds_pre{k}];
end

figure
for k=1:size(fault_x,2)
    plotpatchslip3D_vectors(pm_pre{k},s_pre{k}',nve{k});hold on
    %for k2=1:size(SegEnds_pre{k},1);  plot([SegEnds_pre{k}(k2,1) SegEnds_pre{k}(k2,3)],[SegEnds_pre{k}(k2,2) SegEnds_pre{k}(k2,4)],'k'); end
end
