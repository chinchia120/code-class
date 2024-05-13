function [Scale, Bias] = helperCalirate(UpwardData, DownwardData, TrueValue)
    A = [TrueValue, 1; -TrueValue, 1];
    L = [UpwardData; DownwardData];
    Parameter = (A'*A)\A'*L;
    
    Scale = Parameter(1);
    Bias = Parameter(2);
end

