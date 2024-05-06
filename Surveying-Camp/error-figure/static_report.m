%% Static Report %%
function output = static_report(data_XY, data_Z)
    X = data_XY(:, 3);
    Y = data_XY(:, 4);
    Z = data_Z(:, 5);

    fid = fopen('Error_Report.txt', 'w');

    fprintf(fid, '<< ----- Easting Static Report ----- >>\n');
    static = static_calculate(X);
    fprintf(fid, 'avg = %7.4f (m)\n', static(1));
    fprintf(fid, 'std = %7.4f (m)\n', static(2));
    fprintf(fid, 'max = %7.4f (m)\n', static(3));
    fprintf(fid, 'min = %7.4f (m)\n\n', static(4));

    fprintf(fid, '<< ----- Notrhing Static Report ----- >>\n');
    static = static_calculate(Y);
    fprintf(fid, 'avg = %7.4f (m)\n', static(1));
    fprintf(fid, 'std = %7.4f (m)\n', static(2));
    fprintf(fid, 'max = %7.4f (m)\n', static(3));
    fprintf(fid, 'min = %7.4f (m)\n\n', static(4));

    fprintf(fid, '<< ----- Elevation Static Report ----- >>\n');
    static = static_calculate(Z);
    fprintf(fid, 'avg = %7.4f (m)\n', static(1));
    fprintf(fid, 'std = %7.4f (m)\n', static(2));
    fprintf(fid, 'max = %7.4f (m)\n', static(3));
    fprintf(fid, 'min = %7.4f (m)\n\n', static(4));
    
    fclose(fid);

    output = [];
end