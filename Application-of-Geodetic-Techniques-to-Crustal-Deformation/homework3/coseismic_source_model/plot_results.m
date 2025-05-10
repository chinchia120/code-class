%% plot results %%%%

%plot fault geometry and slip distribution
for k=1:size(fault_x,2)
    ss_pre{k}=s(np{k}+1:np{k+1});
    ds_pre{k}=s(npatches+np{k}+1:npatches+np{k+1});
    s_pre{k}=[ss_pre{k};ds_pre{k}];
end

for  k=1:size(data,2)
    if datatype{k}==1
        figure
        for i=1:size(fault_x,2)
            plotpatchslip3D_vectors(pm_pre{i},s_pre{i}',nve{i});hold on
        end
        quiver(xy{k}(:,1),xy{k}(:,2),data{k}(:,3),data{k}(:,4),'b')
        quiver(xy{k}(:,1),xy{k}(:,2),dhat_set{k}(1:size(data{k},1)),dhat_set{k}(size(data{k},1)+1:2*size(data{k},1)),'r')
    elseif datatype{k}==2
        figure
        for i=1:size(fault_x,2)
            plotpatchslip3D_vectors(pm_pre{i},s_pre{i}',nve{i});hold on
        end
        quiver3(xy{k}(:,1),xy{k}(:,2),0*xy{k}(:,1),zeros(size(data{k},1),1),zeros(size(data{k},1),1),data{k}(:,3),'k')
        quiver3(xy{k}(:,1),xy{k}(:,2),0*xy{k}(:,1),zeros(size(data{k},1),1),zeros(size(data{k},1),1),dhat_set{k},'g')
    elseif datatype{k}==3
        figure
        for i=1:size(fault_x,2)
            plotpatchslip3D_vectors(pm_pre{i},s_pre{i}',nve{i});hold on
        end
        quiver3(xy{k}(:,1),xy{k}(:,2),0*xy{k}(:,1),zeros(size(data{k},1),1),zeros(size(data{k},1),1),data{k}(:,3),'k')
        quiver3(xy{k}(:,1),xy{k}(:,2),0*xy{k}(:,1),zeros(size(data{k},1),1),zeros(size(data{k},1),1),dhat_set{k},'g')
    end
end
axis equal

