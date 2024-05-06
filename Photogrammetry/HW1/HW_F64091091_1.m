format short;

%%% Rotation Matrix %%%
syms omega psi kappa;

R_omega = [1 0 0 ; 0 cos(omega) sin(omega) ; 0 -sin(omega) cos(omega)];
R_psi = [cos(psi) 0 -sin(psi) ; 0 1 0 ; sin(psi) 0 cos(psi)];
R_kappa = [cos(kappa) sin(kappa) 0 ; -sin(kappa) cos(kappa) 0 ; 0 0 1];
R = R_kappa * R_psi * R_omega;

%%% Initial Data %%%
[header data_init] = xlsread("input.xlsx", "A1: B7");
Xp = str2double(data_init{2,2});
Yp = str2double(data_init{3,2});
Zp = str2double(data_init{4,2});
f = str2double(data_init{5,2});
X0 = str2double(data_init{6,2});
Y0 = str2double(data_init{7,2});

%%% Set Output Data Title %%%
xlswrite("output.xlsx", {'Xp', 'Yp'}, 1, "B1: C1");
xlswrite("output.xlsx", {'A1'; 'A2'; 'A3'; 'B1'; 'B2'; 'B3'; 'C1'; 'C2'; 'C3'; 'D1'; 'D2'; 'D3'}, 1, "A2: A13");
xlswrite("output.xlsx", {'NO.', 'Random', 'Mean', 'Std'}, 1, "E1: H1");

%%% Data_A %%%
data_A_ang = xlsread("input.xlsx", "D6: G9");
R_A = rotation_matrix(R, data_A_ang, omega, psi, kappa);

data_A_cor = xlsread("input.xlsx", "D1: G4");
for i = 1: 3
    data_A{i, 1} = double(collinearity(X0, Y0, f, Xp, Yp, Zp, data_A_cor(i, 2), data_A_cor(i, 3), data_A_cor(i, 4), R_A));
end

A = cell2mat(data_A)
xlswrite("output.xlsx", A, 1, "B2: C4");

%%% Data_B %%%
data_B_ang = xlsread("input.xlsx", "I6: L9");
R_B = rotation_matrix(R, data_B_ang, omega, psi, kappa);

data_B_cor = xlsread("input.xlsx", "I1: L4");
for i = 1: 3
    data_B{i, 1} = double(collinearity(X0, Y0, f, Xp, Yp, Zp, data_B_cor(i, 2), data_B_cor(i, 3), data_B_cor(i, 4), R_B));
end

B = cell2mat(data_B)
xlswrite("output.xlsx", B, 1, "B5: C7");

%%% Data_C %%%
data_C_ang = xlsread("input.xlsx", "D17: G20");
R_C = rotation_matrix(R, data_C_ang, omega, psi, kappa);

data_C_cor = xlsread("input.xlsx", "D12: G15");
for i = 1: 3
    data_C{i, 1} = double(collinearity(X0, Y0, f, Xp, Yp, Zp, data_C_cor(i, 2), data_C_cor(i, 3), data_C_cor(i, 4), R_C));
end

C = cell2mat(data_C)
xlswrite("output.xlsx", C, 1, "B8: C10");

%%% Data_D %%%
data_D_ang = xlsread("input.xlsx", "I17: L20");
R_D = rotation_matrix(R, data_D_ang, omega, psi, kappa);

data_D_cor = xlsread("input.xlsx", "I12: L25");
for i = 1: 3
    data_D{i, 1} = double(collinearity(X0, Y0, f, Xp, Yp, Zp, data_D_cor(i, 2), data_D_cor(i, 3), data_D_cor(i, 4), R_D));
end

D = cell2mat(data_D)
xlswrite("output.xlsx", D, 1, "B11: C13");

%%% Random Number %%%
%rng('shuffle');
random_ = (0 + 20*randn(1, 744))';
tmp = [(1: 744)', random_];

mean_ =  mean(random_)
std_ = std(random_)
xlswrite("output.xlsx", tmp, 1, "E2: F745");
xlswrite("output.xlsx", mean_, 1, "G2");
xlswrite("output.xlsx", std_, 1, "H2");

%%% Histogram %%%
hist(random_);


function output = rotation_matrix(R, data_ang, omega, psi, kappa)
    tmp = zeros(1, 3);
    for i = 1: 3
        tmp(i) = dms2rad([data_ang(i,1), data_ang(i,2), data_ang(i,3)]);
    end
    output = subs(R,[omega, psi, kappa], tmp);
end

function output = collinearity(X0, Y0, f, Xp, Yp, Zp, XL, YL, ZL, R)
    fun1 = R(1, 1)*(Xp - XL) + R(1, 2)*(Yp - YL) + R(1, 3)*(Zp - ZL);
    fun2 = R(2, 1)*(Xp - XL) + R(2, 2)*(Yp - YL) + R(2, 3)*(Zp - ZL);
    fun3 = R(3, 1)*(Xp - XL) + R(3, 2)*(Yp - YL) + R(3, 3)*(Zp - ZL);

    output = [X0 - f*fun1/fun3, Y0 - f*fun2/fun3];
end