% output observation, calculation, and residual files
for  k=1:size(data,2)
    BaseEnds_ll=xy2ll_BaseEnds(BaseEnds{k},origin);
    fid=fopen(['info_baseline_' int2str(k) '.dat'],'w');
    fprintf(fid,'%9.4f %9.4f %9.4f %9.4f\r\n',BaseEnds_ll');
    fclose(fid);
    fid=fopen(['info_obs_' int2str(k) '.dat'],'w');
    fprintf(fid,'%9.4f\r\n',obs{k});
    fclose(fid);
    fid=fopen(['info_cal_' int2str(k) '.dat'],'w');
    fprintf(fid,'%9.4f\r\n',cal{k});
    fclose(fid);
    fid=fopen(['info_res_' int2str(k) '.dat'],'w');
    fprintf(fid,'%9.4f\r\n',res{k});
    fclose(fid);
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
