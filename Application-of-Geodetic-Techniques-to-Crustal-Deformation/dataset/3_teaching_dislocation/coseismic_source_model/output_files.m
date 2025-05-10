% output observation, calculation, and residual files
for  k=1:size(data,2)
    if datatype{k}==1
        fid=fopen(['calh_' int2str(k) '.gmt'],'w');
        fprintf(fid,'%13.9f  %13.10f  %10.6f  %10.6f\r\n',[data{k}(:,1) data{k}(:,2) dhat_set{k}(1:size(data{k},1)) dhat_set{k}(size(data{k},1)+1:2*size(data{k},1))]');
        fclose(fid);
    elseif datatype{k}==2
        fid=fopen(['calu_' int2str(k) '.gmt'],'w');
        fprintf(fid,'%13.9f  %13.10f  %10.6f\r\n',[data{k}(:,1) data{k}(:,2) dhat_set{k}]');
        fclose(fid);
    elseif datatype{k}==3
        fid=fopen(['callos_' int2str(k) '.gmt'],'w');
        fprintf(fid,'%13.9f  %13.10f  %10.6f\r\n',[data{k}(:,1) data{k}(:,2) dhat_set{k}]');
        fclose(fid);
    end
end

% output fault geometry and slip distribution
for k=1:size(fault_x,2)
    fid=fopen(['fault_info_' int2str(k) '.dat'],'w');
    fprintf(fid,'%8.4f %7.4f\r\n',fliplr(origin));
    fprintf(fid,'%i\r\n',nhe{k});
    fprintf(fid,'%i\r\n',nve{k});
    fclose(fid);
    
    fid=fopen(['pm_' int2str(k) '.dat'],'w');
    fprintf(fid,'%10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\r\n',pm_pre{k}');
    fclose(fid);
    
    outputpatchslip3D_vectors(pm_pre{k},s_pre{k}',nve{k},k)
end
