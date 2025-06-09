function [] = WriteOutFile(point, output, time, iter, points_array, method, outputfile)
%% ========== Open OutputFile ========== %%
fid = fopen(outputfile, 'a+');

%% ========== Output Data ========== %%
fprintf(fid, '%% ========== %s ========== %% \r\n', method);
fprintf(fid, 'Initial Value = [%8.4f, %8.4f]\r\n', points_array(1, :));
fprintf(fid, 'Optimal Point = [%8.4f, %8.4f]\r\n', point);
fprintf(fid, 'Optimal Value = %.4e\r\n', output);
fprintf(fid, 'Iterations    = %d\r\n', iter);
fprintf(fid, 'CPU Time      = %.4f (s)\r\n\r\n', time);

%% ========== Close OutputFile ========== %%
fclose(fid);
end