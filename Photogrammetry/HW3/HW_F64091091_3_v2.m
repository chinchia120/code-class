format short;

%%% Rotation Matrix %%%
syms omega psi kappa;

R_omega = [1 0 0 ; 0 cos(omega) sin(omega) ; 0 -sin(omega) cos(omega)];
R_psi = [cos(psi) 0 -sin(psi) ; 0 1 0 ; sin(psi) 0 cos(psi)];
R_kappa = [cos(kappa) sin(kappa) 0 ; -sin(kappa) cos(kappa) 0 ; 0 0 1];
R = R_kappa * R_psi * R_omega;

%%% Initial Data %%%
[header data_init] = xlsread("input.xlsx", "A1: B7");
Xp0 = str2double(data_init{2,2});
Yp0 = str2double(data_init{3,2});
Zp0 = str2double(data_init{4,2});
f = str2double(data_init{5,2});
x0 = str2double(data_init{6,2});
y0 = str2double(data_init{7,2});

Xp = Xp0;
Yp = Yp0;
Zp = Zp0;

%%% Set Output Data Title %%%
xlswrite("output.xlsx", {'xp', 'yp'}, 1, "B1: C1");
xlswrite("output.xlsx", {'A1'; 'A2'; 'A3'; 'B1'; 'B2'; 'B3'; 'C1'; 'C2'; 'C3'; 'D1'; 'D2'; 'D3'}, 1, "A2: A13");
xlswrite("output.xlsx", {'NO.', 'Random', 'Mean', 'Std'}, 1, "E1: H1");

%%% Data_A %%%
data_A_ang = xlsread("input.xlsx", "D6: G9");
R_A = rotation_matrix(R, data_A_ang, omega, psi, kappa);

data_A_cor = xlsread("input.xlsx", "D1: G4");
for i = 1: 3
    data_A{i, 1} = double(collinearity(x0, y0, f, Xp0, Yp0, Zp0, data_A_cor(i, 2), data_A_cor(i, 3), data_A_cor(i, 4), R_A));
end

A = cell2mat(data_A);
xlswrite("output.xlsx", A, 1, "B2: C4");

%%% Data_B %%%
data_B_ang = xlsread("input.xlsx", "I6: L9");
R_B = rotation_matrix(R, data_B_ang, omega, psi, kappa);

data_B_cor = xlsread("input.xlsx", "I1: L4");
for i = 1: 3
    data_B{i, 1} = double(collinearity(x0, y0, f, Xp0, Yp0, Zp0, data_B_cor(i, 2), data_B_cor(i, 3), data_B_cor(i, 4), R_B));
end

B = cell2mat(data_B);
xlswrite("output.xlsx", B, 1, "B5: C7");

%%% Data_C %%%
data_C_ang = xlsread("input.xlsx", "D17: G20");
R_C = rotation_matrix(R, data_C_ang, omega, psi, kappa);

data_C_cor = xlsread("input.xlsx", "D12: G15");
for i = 1: 3
    data_C{i, 1} = double(collinearity(x0, y0, f, Xp0, Yp0, Zp0, data_C_cor(i, 2), data_C_cor(i, 3), data_C_cor(i, 4), R_C));
end

C = cell2mat(data_C);
xlswrite("output.xlsx", C, 1, "B8: C10");

%%% Data_D %%%
data_D_ang = xlsread("input.xlsx", "I17: L20");
R_D = rotation_matrix(R, data_D_ang, omega, psi, kappa);

data_D_cor = xlsread("input.xlsx", "I12: L25");
for i = 1: 3
    data_D{i, 1} = double(collinearity(x0, y0, f, Xp0, Yp0, Zp0, data_D_cor(i, 2), data_D_cor(i, 3), data_D_cor(i, 4), R_D));
end

D = cell2mat(data_D);
xlswrite("output.xlsx", D, 1, "B11: C13");

%%% Random Number %%%
%rng('shuffle');
random_ = (0 + 20*randn(1, 744))';
T = [(1: 744)', random_];

mean_ =  mean(random_);
std_ = std(random_);
xlswrite("output.xlsx", T, 1, "E2: F745");
xlswrite("output.xlsx", mean_, 1, "G2");
xlswrite("output.xlsx", std_, 1, "H2");

%%% Histogram %%%
hist(random_);
xlabel('Random Number(\mum)');
ylabel('Count');
title('Random Historgam');
tmp_str = sprintf("./picture//Random_Histogram.png");
saveas(gcf, tmp_str);

%%% Add Random %%%
observed = {zeros(372, 3)};
list = [A(1, 1), A(1, 2), A(2, 1), A(2, 2), A(3, 1), A(3, 2), ...
        B(1, 1), B(1, 2), B(2, 1), B(2, 2), B(3, 1), B(3, 2), ...
        C(1, 1), C(1, 2), C(2, 1), C(2, 2), C(3, 1), C(3, 2), ...
        D(1, 1), D(1, 2), D(2, 1), D(2, 2), D(3, 1), D(3, 2)];
list_name = ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3", "D1", "D2", "D3"];

cnt = 0;
for i = 1: 372
    if mod(i, 31) == 1
        cnt = cnt + 1;
        T = 2*cnt - 1;
    end
    observed{i, 1} = list(1, T) + random_(i, 1)*10^(-3);
    observed{i, 2} = list(1, T+1) + random_(745-i, 1)*10^(-3);
    observed{i, 3} = list_name(1, cnt);
end 

%%% Initial Data %%%
cnt = 0;
cnt_list = 0;
list = ["A", "B", "C", "D"];
case_number = {zeros(744, 1)};

cor_ture = [A; B; C; D];
cor_A = data_A_cor(1:3, 2:4);
cor_B = data_B_cor(1:3, 2:4);
cor_C = data_C_cor(1:3, 2:4);
cor_D = data_D_cor(1:3, 2:4);
cor_ABCD = [cor_A; cor_B; cor_C; cor_D];

rotation_matrix_ABCD = [R_A; R_B; R_C; R_D];
sigma = 20*10^(-6);
door = sigma/100;

precision_max_min = [1: 122; zeros(2, 122)]';
error_max_min = [1: 122; zeros(2, 122)]';
ratio_X_Y_Z = [1: 122; zeros(3, 122)]';

file = fopen('case_output2.txt', 'w');

cnt_A1 = 1;
cnt_A2 = 1;
cnt_A3 = 1;

cnt_B1 = 1;
cnt_B2 = 1;
cnt_B3 = 1;

cnt_C1 = 1;
cnt_C2 = 1;
cnt_C3 = 1;

cnt_D1 = 1;
cnt_D2 = 1;
cnt_D3 = 1;

tmp_cnt1 = 0;
tmp_cnt2 = 0;
tmp_cnt3 = 0;
tmp_cnt4 = 0;

%%% Two %%%
cnt_case_num = 1;
for num = 1:4
    cnt_list = cnt_list + 1;
    for i = 1: 2
        for j = (i+1): 3
            if num == 1 && i == 1 && j == 2
                tmp_cnt1 = cnt_A1;
                tmp_cnt2 = cnt_A2; 
                cnt_A1 = cnt_A1 + 1;
                cnt_A2 = cnt_A2 + 1;
            elseif num == 1 && i == 1 && j == 3
                tmp_cnt1 = cnt_A1;
                tmp_cnt2 = cnt_A3;
                cnt_A1 = cnt_A1 + 1;
                cnt_A3 = cnt_A3 + 1;
            elseif num == 1 && i == 2 && j == 3
                tmp_cnt1 = cnt_A2;
                tmp_cnt2 = cnt_A3;
                cnt_A2 = cnt_A2 + 1;
                cnt_A3 = cnt_A3 + 1;
            elseif num == 2 && i == 1 && j == 2
                tmp_cnt1 = cnt_B1;
                tmp_cnt2 = cnt_B2;
                cnt_B1 = cnt_B1 + 1;
                cnt_B2 = cnt_B2 + 1;
            elseif num == 2 && i == 1 && j == 3
                tmp_cnt1 = cnt_B1;
                tmp_cnt2 = cnt_B3;
                cnt_B1 = cnt_B1 + 1;
                cnt_B3 = cnt_B3 + 1;
            elseif num == 2 && i == 2 && j == 3
                tmp_cnt1 = cnt_B2;
                tmp_cnt2 = cnt_B3;
                cnt_B2 = cnt_B2 + 1;
                cnt_B3 = cnt_B3 + 1;
            elseif num == 3 && i == 1 && j == 2
                tmp_cnt1 = cnt_C1;
                tmp_cnt2 = cnt_C2;
                cnt_C1 = cnt_C1 + 1;
                cnt_C2 = cnt_C2 + 1;
            elseif num == 3 && i == 1 && j == 3
                tmp_cnt1 = cnt_C1;
                tmp_cnt2 = cnt_C3;
                cnt_C1 = cnt_C1 + 1;
                cnt_C3 = cnt_C3 + 1;
            elseif num == 3 && i == 2 && j == 3
                tmp_cnt1 = cnt_C2;
                tmp_cnt2 = cnt_C3;
                cnt_C2 = cnt_C2 + 1;
                cnt_C3 = cnt_C3 + 1;
            elseif num == 4 && i == 1 && j == 2
                tmp_cnt1 = cnt_D1;
                tmp_cnt2 = cnt_D2;
                cnt_D1 = cnt_D1 + 1;
                cnt_D2 = cnt_D2 + 1;
            elseif num == 4 && i == 1 && j == 3
                tmp_cnt1 = cnt_D1;
                tmp_cnt2 = cnt_D3;
                cnt_D1 = cnt_D1 + 1;
                cnt_D3 = cnt_D3 + 1;
            elseif num == 4 && i == 2 && j == 3
                tmp_cnt1 = cnt_D2;
                tmp_cnt2 = cnt_D3;
                cnt_D2 = cnt_D2 + 1;
                cnt_D3 = cnt_D3 + 1;
            end

            cnt = cnt + 1;
            str = "Case %2d: %s%d %s%d";
            case_number{cnt, 1} = sprintf(str, cnt, list(1, cnt_list), i, list(1, cnt_list), j);
            
            fprintf(file, '%s\n\n', case_number{cnt_case_num, 1});
            
            init_XYZ = get_init_XYZ(f, cor_ABCD(i + 3*(num-1), 1), cor_ABCD(i + 3*(num-1), 2), cor_ABCD(i + 3*(num-1), 3), ...
                                       cor_ABCD(j + 3*(num-1), 1), cor_ABCD(j + 3*(num-1), 2), cor_ABCD(j + 3*(num-1), 3), ...
                                       cell2mat(observed(93*(num-1) + tmp_cnt1 + 31*(i-1), 1)), ...
                                       cell2mat(observed(93*(num-1) + tmp_cnt2 + 31*(j-1), 1)), ...
                                       cell2mat(observed(93*(num-1) + tmp_cnt2 + 31*(j-1), 2)));

            P = diag([zeros(1, 4) + 1/sigma^2]);
            iteration = 0;
            while true
                iteration = iteration + 1;
                if iteration == 1
                    Xp_ = init_XYZ(1, 1);
                    Yp_ = init_XYZ(1, 2);
                    Zp_ = init_XYZ(1, 3);
                end
                
                A = get_A_matrix(2, f, [1 + (num-1)*3, 1 + (num-1)*3],  Xp_, Yp_, Zp_, [i + 3*(num-1), j + 3*(num-1)], rotation_matrix_ABCD, cor_ABCD);

                tmp1 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(i + 3*(num-1), 1), cor_ABCD(i + 3*(num-1), 2), cor_ABCD(i + 3*(num-1), 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
                tmp2 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(j + 3*(num-1), 1), cor_ABCD(j + 3*(num-1), 2), cor_ABCD(j + 3*(num-1), 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
            
                L = [observed(93*(num-1) + tmp_cnt1 + 31*(i-1), 1) - tmp1(1, 1); 
                     observed(93*(num-1) + tmp_cnt1 + 31*(i-1), 2) - tmp1(1, 2);
                     observed(93*(num-1) + tmp_cnt2 + 31*(j-1), 1) - tmp2(1, 1); 
                     observed(93*(num-1) + tmp_cnt2 + 31*(j-1), 2) - tmp2(1, 2)];
            
                X_ = get_X_hat(A'*P*A, A'*P*L);

                print_iteration(iteration, X_, file);

                Xp_ = Xp_ + X_(1, 1);
                Yp_ = Yp_ + X_(2, 1);
                Zp_ = Zp_ + X_(3, 1);
                if max(abs(X_)) < door
                    V = (A*X_-L);
                    r = (2*2-3) / (2*2);
                    sigma_naught = sqrt(V.'*P*V/(4-3));
                    fprintf(file, '觀測數個數 n = 4, 未知數個數 u = 3, 自由度df = 1\n');
                    fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);

                    for tmp_case = 1: 2
                        if tmp_case == 1
                            obs_cor = observed(93*(num-1) + tmp_cnt1 + 31*(i-1), 1: 2);
                            photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(i + 3*(num-1), 1), cor_ABCD(i + 3*(num-1), 2), cor_ABCD(i + 3*(num-1), 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));     
                            tmp_cor_ture = i + 3*(num-1);
                            tmp_case_num2 = i;
                        elseif tmp_case == 2
                            obs_cor = observed(93*(num-1) + tmp_cnt1 + 31*(j-1), 1: 2);
                            photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(j + 3*(num-1), 1), cor_ABCD(j + 3*(num-1), 2), cor_ABCD(j + 3*(num-1), 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
                            tmp_cor_ture = j + 3*(num-1);
                            tmp_case_num2 = j;
                        end
                        fprintf(file, '片號 %s%d\n', list(1, num), tmp_case_num2);
                        fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                        fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                        fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', cell2mat(obs_cor(1, 1)), cell2mat(obs_cor(1, 2)), ...
                                V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_cor_ture, 1) - cell2mat(obs_cor(1, 1)), cor_ture(tmp_cor_ture, 2) - cell2mat(obs_cor(1, 2)));
                    end
                    sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
                    
                    fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
                    fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
                    fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
                    fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
                    fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);
                    
                    get_3D_ellipsoid(sigma_xx, cnt_case_num, file);

                    fprintf(file, '\n\n');

                    precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
                    error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
                    ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];
                    break
                end   
            end
            cnt_case_num = cnt_case_num + 1;      
        end 
    end
end

%%% Three %%%
cnt_list = 0;
for num = 1: 4
    if num == 1
        tmp_cnt1 = cnt_A1;
        tmp_cnt2 = cnt_A2;
        tmp_cnt3 = cnt_A3;
        cnt_A1 = cnt_A1 + 1;
        cnt_A2 = cnt_A2 + 1;
        cnt_A3 = cnt_A3 + 1;
    elseif num == 2
        tmp_cnt1 = cnt_B1;
        tmp_cnt2 = cnt_B2;
        tmp_cnt3 = cnt_B3;
        cnt_B1 = cnt_B1 + 1;
        cnt_B2 = cnt_B2 + 1;
        cnt_B3 = cnt_B3 + 1;
    elseif num == 3
        tmp_cnt1 = cnt_C1;
        tmp_cnt2 = cnt_C2;
        tmp_cnt3 = cnt_C3;
        cnt_C1 = cnt_C1 + 1;
        cnt_C2 = cnt_C2 + 1;
        cnt_C3 = cnt_C3 + 1;
    elseif num == 4
        tmp_cnt1 = cnt_D1;
        tmp_cnt2 = cnt_D2;
        tmp_cnt3 = cnt_D3;
        cnt_D1 = cnt_D1 + 1;
        cnt_D2 = cnt_D2 + 1;
        cnt_D3 = cnt_D3 + 1;
    end
    
    cnt_list = cnt_list + 1;
    cnt = cnt + 1;
    str = "Case %2d: %s1 %s2 %s3";
    case_number{cnt, 1} = sprintf(str, cnt, list(1, cnt_list), list(1, cnt_list), list(1, cnt_list));
    fprintf(file, '%s\n\n', case_number{cnt_case_num, 1});
            
    init_XYZ = get_init_XYZ(f, cor_ABCD(1 + (num-1)*3 + 0, 1), cor_ABCD(1 + (num-1)*3 + 0, 2), cor_ABCD(1 + (num-1)*3 + 0, 3), ...
                               cor_ABCD(1 + (num-1)*3 + 1, 1), cor_ABCD(1 + (num-1)*3 + 1, 2), cor_ABCD(1 + (num-1)*3 + 1, 3), ...
                               cell2mat(observed(tmp_cnt1 + 93*(num-1) + 00, 1)), ...
                               cell2mat(observed(tmp_cnt2 + 93*(num-1) + 31, 1)), ...
                               cell2mat(observed(tmp_cnt2 + 93*(num-1) + 31, 2)));

    P = diag([zeros(1, 6) + 1/sigma^2]);
    iteration = 0;
    while true
        iteration = iteration + 1;
        if iteration == 1
            Xp_ = init_XYZ(1, 1);
            Yp_ = init_XYZ(1, 2);
            Zp_ = init_XYZ(1, 3);
        end

        A = get_A_matrix(3, f, [1 + (num-1)*3, 1 + (num-1)*3, 1 + (num-1)*3], Xp_, Yp_, Zp_, [1 + (num-1)*3 + 0, 1 + (num-1)*3 + 1, 1 + (num-1)*3 + 2], rotation_matrix_ABCD, cor_ABCD);

        tmp1 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 0, 1), cor_ABCD(1 + (num-1)*3 + 0, 2), cor_ABCD(1 + (num-1)*3 + 0, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
        tmp2 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 1, 1), cor_ABCD(1 + (num-1)*3 + 1, 2), cor_ABCD(1 + (num-1)*3 + 1, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
        tmp3 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 2, 1), cor_ABCD(1 + (num-1)*3 + 2, 2), cor_ABCD(1 + (num-1)*3 + 2, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
    
        L = [observed(tmp_cnt1 + 93*(num-1) + 00, 1) - tmp1(1, 1); 
             observed(tmp_cnt1 + 93*(num-1) + 00, 2) - tmp1(1, 2);
             observed(tmp_cnt2 + 93*(num-1) + 31, 1) - tmp2(1, 1); 
             observed(tmp_cnt2 + 93*(num-1) + 31, 2) - tmp2(1, 2);
             observed(tmp_cnt3 + 93*(num-1) + 62, 1) - tmp3(1, 1);
             observed(tmp_cnt3 + 93*(num-1) + 62, 2) - tmp3(1, 2)];
    
        X_ = get_X_hat(A'*P*A, A'*P*L);

        print_iteration(iteration, X_, file);

        Xp_ = Xp_ + X_(1, 1);
        Yp_ = Yp_ + X_(2, 1);
        Zp_ = Zp_ + X_(3, 1);
        if max(abs(X_)) < door
            V = (A*X_-L);
            r = (2*3-3) / (2*3);
            sigma_naught = sqrt(V.'*P*V/(6-3));
            fprintf(file, '觀測數個數 n = 6, 未知數個數 u = 3, 自由度df = 3\n');
            fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);
            for tmp_case = 1: 3
                if tmp_case == 1
                    obs_cor = observed(tmp_cnt1 + 93*(num-1) + 00, 1: 2);
                    photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 0, 1), cor_ABCD(1 + (num-1)*3 + 0, 2), cor_ABCD(1 + (num-1)*3 + 0, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));     
                    tmp_cor_ture = 1 + (num-1)*3 + 0;
                elseif tmp_case == 2
                    obs_cor = observed(tmp_cnt2 + 93*(num-1) + 31, 1: 2) ;
                    photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 1, 1), cor_ABCD(1 + (num-1)*3 + 1, 2), cor_ABCD(1 + (num-1)*3 + 1, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
                    tmp_cor_ture = 1 + (num-1)*3 + 1;
                elseif tmp_case == 3
                    obs_cor = observed(tmp_cnt3 + 93*(num-1) + 62, 1: 2);
                    photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1 + (num-1)*3 + 2, 1), cor_ABCD(1 + (num-1)*3 + 2, 2), cor_ABCD(1 + (num-1)*3 + 2, 3), rotation_matrix_ABCD(1 + (num-1)*3: 1 + (num-1)*3 + 2, 1:3)));
                    tmp_cor_ture = 1 + (num-1)*3 + 2;
                end
                fprintf(file, '片號 %s%d\n', list(1, num), tmp_case);
                fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', cell2mat(obs_cor(1, 1)), cell2mat(obs_cor(1, 2)), ...
                        V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_cor_ture, 1) - cell2mat(obs_cor(1, 1)), cor_ture(tmp_cor_ture, 2) -cell2mat(obs_cor(1, 2)));
            end
            sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
            fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
            fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
            fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
            fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
            fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);

            get_3D_ellipsoid(sigma_xx, cnt_case_num, file);

            fprintf(file, '\n\n');

            precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
            error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
            ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)]; 

            break
        end
    end
    cnt_case_num = cnt_case_num + 1;
end

%%% Four %%%
for i = 1: 3
    for j = 1: 3
        for k = 1: 3
            for l = 1: 3
                if i == 1
                    tmp_cnt1 = cnt_A1;
                    cnt_A1 = cnt_A1 + 1;
                elseif i == 2
                    tmp_cnt1 = cnt_A2;
                    cnt_A2 = cnt_A2 + 1;
                elseif i == 3
                    tmp_cnt1 = cnt_A3;
                    cnt_A3 = cnt_A3 + 1;
                end
                if j == 1
                    tmp_cnt2 = cnt_B1;
                    cnt_B1 = cnt_B1 + 1;
                elseif j == 2
                    tmp_cnt2 = cnt_B2;
                    cnt_B2 = cnt_B2 + 1;
                elseif j == 3
                    tmp_cnt2 = cnt_B3;
                    cnt_B3 = cnt_B3 + 1;
                end
                if k == 1
                    tmp_cnt3 = cnt_C1;
                    cnt_C1 = cnt_C1 + 1;
                elseif k == 2
                    tmp_cnt3 = cnt_C2;
                    cnt_C2 = cnt_C2 + 1;
                elseif k == 3
                    tmp_cnt3 = cnt_C3;
                    cnt_C3 = cnt_C3 + 1;
                end
                if l == 1
                    tmp_cnt4 = cnt_D1;
                    cnt_D1 = cnt_D1 + 1;
                elseif l == 2
                    tmp_cnt4 = cnt_D2;
                    cnt_D2 = cnt_D2 + 1;
                elseif l == 3
                    tmp_cnt4 = cnt_D3;
                    cnt_D3 = cnt_D3 + 1;
                end
                
                cnt = cnt + 1;
                str = "Case %2d: A%d B%d C%d D%d";
                case_number{cnt, 1} = sprintf(str, cnt, i, j, k, l);
                fprintf(file, '%s\n\n', case_number{cnt_case_num, 1});

                init_XYZ = get_init_XYZ(f, cor_ABCD(01, 1), cor_ABCD(01, 2), cor_ABCD(01, 3), ...
                                           cor_ABCD(10, 1), cor_ABCD(10, 2), cor_ABCD(10, 3), ...
                                           cell2mat(observed(004, 1)), ...
                                           cell2mat(observed(283, 1)), ...
                                           cell2mat(observed(283, 2)));
                
                if(i == 1 && j == 1 && k == 1 && l== 1)
                    Xp0 = init_XYZ(1, 1);
                    Yp0 = init_XYZ(1, 2);
                    Zp0 = init_XYZ(1, 3);
                end

                P = diag([zeros(1, 8) + 1/sigma^2]);
                iteration = 0;
                while true
                    iteration = iteration + 1;
                    if iteration == 1
                        Xp_ = Xp0;
                        Yp_ = Yp0;
                        Zp_ = Zp0;
                    end

                    A = get_A_matrix(4, f, [1, 4, 7, 10], Xp_, Yp_, Zp_, [i + 0, j + 3, k + 6, l + 9], rotation_matrix_ABCD, cor_ABCD);
                
                    tmp1 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(i + 0, 1), cor_ABCD(i + 0, 2), cor_ABCD(i + 0, 3), R_A));
                    tmp2 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(j + 3, 1), cor_ABCD(j + 3, 2), cor_ABCD(j + 3, 3), R_B));
                    tmp3 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(k + 6, 1), cor_ABCD(k + 6, 2), cor_ABCD(k + 6, 3), R_C));
                    tmp4 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(l + 9, 1), cor_ABCD(l + 9, 2), cor_ABCD(l + 9, 3), R_D));
                
                    L = [observed(tmp_cnt1 + 31*(i-1) + 000, 1) - tmp1(1, 1); 
                         observed(tmp_cnt1 + 31*(i-1) + 000, 2) - tmp1(1, 2);
                         observed(tmp_cnt2 + 31*(j-1) + 093, 1) - tmp2(1, 1); 
                         observed(tmp_cnt2 + 31*(j-1) + 093, 2) - tmp2(1, 2);
                         observed(tmp_cnt3 + 31*(k-1) + 186, 1) - tmp3(1, 1); 
                         observed(tmp_cnt3 + 31*(k-1) + 186, 2) - tmp3(1, 2);
                         observed(tmp_cnt4 + 31*(l-1) + 279, 1) - tmp4(1, 1); 
                         observed(tmp_cnt4 + 31*(l-1) + 279, 2) - tmp4(1, 2)];
                
                    X_ = get_X_hat(A'*P*A, A'*P*L);

                    print_iteration(iteration, X_, file);

                    Xp_ = Xp_ + X_(1, 1);
                    Yp_ = Yp_ + X_(2, 1);
                    Zp_ = Zp_ + X_(3, 1);
                    if max(abs(X_)) < door
                        V = (A*X_-L);
                        r = (2*4-3) / (2*4);
                        sigma_naught = sqrt(V.'*P*V/(8-3));
                        fprintf(file, '觀測數個數 n = 8, 未知數個數 u = 3, 自由度df = 5\n');
                        fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);
                        for tmp_case = 1: 4
                            if tmp_case == 1
                                obs_cor = observed(tmp_cnt1 + 31*(i-1) + 000, 1: 2);
                                photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(i + 0, 1), cor_ABCD(i + 0, 2), cor_ABCD(i + 0, 3), R_A));     
                                tmp_cor_ture = i + 0;
                                tmp_case_num2 = i;
                            elseif tmp_case == 2
                                obs_cor = observed(tmp_cnt2 + 31*(j-1) + 093, 1: 2);
                                photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(j + 3, 1), cor_ABCD(j + 3, 2), cor_ABCD(j + 3, 3), R_B));
                                tmp_cor_ture = j + 3;
                                tmp_case_num2 = j;
                            elseif tmp_case == 3
                                obs_cor = observed(tmp_cnt3 + 31*(k-1) + 186, 1: 2);
                                photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(k + 6, 1), cor_ABCD(k + 6, 2), cor_ABCD(k + 6, 3), R_C));
                                tmp_cor_ture = k + 6;
                                tmp_case_num2 = k;
                            elseif tmp_case == 4
                                obs_cor = observed(tmp_cnt4 + 31*(l-1) + 279, 1: 2);
                                photo_cor = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(l + 9, 1), cor_ABCD(l + 9, 2), cor_ABCD(l + 9, 3), R_D));
                                tmp_cor_ture = l + 9;
                                tmp_case_num2 = l;
                            end
                            fprintf(file, '片號 %s%d\n', list(1, tmp_case), tmp_case_num2);
                            fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                            fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                            fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', cell2mat(obs_cor(1, 1)), cell2mat(obs_cor(1, 2)), ...
                                    V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_cor_ture, 1) - cell2mat(obs_cor(1, 1)), cor_ture(tmp_cor_ture, 2) - cell2mat(obs_cor(1, 2)));
                        end
                        sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
                        fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
                        fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
                        fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
                        fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
                        fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);
                        

                        get_3D_ellipsoid(sigma_xx, cnt_case_num, file);

                        fprintf(file, '\n\n');

                        precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
                        error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
                        ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];

                        break
                    end 
                end
                cnt_case_num = cnt_case_num + 1;
            end
        end
    end
end

%%% Twelve %%%
case_number{cnt+1, 1} = sprintf("Case %2d: A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3", cnt+1);
fprintf(file, '%s\n\n', case_number{cnt_case_num, 1});
            
init_XYZ = get_init_XYZ(f, cor_ABCD(1, 1), cor_ABCD(1, 2), cor_ABCD(1, 3), ...
                           cor_ABCD(2, 1), cor_ABCD(2, 2), cor_ABCD(2, 3), ...
                           cell2mat(observed(031, 1)), ...
                           cell2mat(observed(372, 1)), ...
                           cell2mat(observed(372, 2)));

P = diag([zeros(1, 24) + 1/sigma^2]);
iteration = 0;
while true
    iteration = iteration + 1;
    if iteration == 1
        Xp_ = init_XYZ(1, 1);
        Yp_ = init_XYZ(1, 2);
        Zp_ = init_XYZ(1, 3);
    end

    A = get_A_matrix(12, f, [1, 1, 1, 4, 4, 4, 7, 7, 7, 10, 10, 10], Xp_, Yp_, Zp_, [1: 12], rotation_matrix_ABCD, cor_ABCD);

    tmp01 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(01, 1), cor_ABCD(01, 2), cor_ABCD(01, 3), R_A));
    tmp02 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(02, 1), cor_ABCD(02, 2), cor_ABCD(02, 3), R_A));
    tmp03 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(03, 1), cor_ABCD(03, 2), cor_ABCD(03, 3), R_A));
    tmp04 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(04, 1), cor_ABCD(04, 2), cor_ABCD(04, 3), R_B));
    tmp05 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(05, 1), cor_ABCD(05, 2), cor_ABCD(05, 3), R_B));
    tmp06 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(06, 1), cor_ABCD(06, 2), cor_ABCD(06, 3), R_B));
    tmp07 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(07, 1), cor_ABCD(07, 2), cor_ABCD(07, 3), R_C));
    tmp08 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(08, 1), cor_ABCD(08, 2), cor_ABCD(08, 3), R_C));
    tmp09 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(09, 1), cor_ABCD(09, 2), cor_ABCD(09, 3), R_C));
    tmp10 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(10, 1), cor_ABCD(10, 2), cor_ABCD(10, 3), R_D));
    tmp11 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(11, 1), cor_ABCD(11, 2), cor_ABCD(11, 3), R_D));
    tmp12 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(12, 1), cor_ABCD(12, 2), cor_ABCD(12, 3), R_D));

    L = [observed(031, 1) - tmp01(1, 1); 
         observed(031, 2) - tmp01(1, 2);
         observed(062, 1) - tmp02(1, 1); 
         observed(062, 2) - tmp02(1, 2);
         observed(093, 1) - tmp03(1, 1); 
         observed(093, 2) - tmp03(1, 2);
         observed(124, 1) - tmp04(1, 1); 
         observed(124, 2) - tmp04(1, 2);
         observed(155, 1) - tmp05(1, 1); 
         observed(155, 2) - tmp05(1, 2);
         observed(186, 1) - tmp06(1, 1); 
         observed(186, 2) - tmp06(1, 2);
         observed(217, 1) - tmp07(1, 1); 
         observed(217, 2) - tmp07(1, 2);
         observed(248, 1) - tmp08(1, 1); 
         observed(248, 2) - tmp08(1, 2);
         observed(279, 1) - tmp09(1, 1); 
         observed(279, 2) - tmp09(1, 2);
         observed(310, 1) - tmp10(1, 1); 
         observed(310, 2) - tmp10(1, 2);
         observed(341, 1) - tmp11(1, 1); 
         observed(341, 2) - tmp11(1, 2);
         observed(372, 1) - tmp12(1, 1); 
         observed(372, 2) - tmp12(1, 2)];

    X_ = get_X_hat(A'*P*A, A'*P*L);

    print_iteration(iteration, X_, file);

    Xp_ = Xp_ + X_(1, 1);
    Yp_ = Yp_ + X_(2, 1);
    Zp_ = Zp_ + X_(3, 1);

    if max(abs(X_)) < door
        V = (A*X_-L);
        r = (2*12-3) / (2*12);
        sigma_naught = sqrt(V.'*P*V/(24-3));
        fprintf(file, '觀測數個數 n = 24, 未知數個數 u = 3, 自由度df = 21\n');
        fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);
        for tmp_case = 1: 12
            if mod(tmp_case, 3) == 0
                tmp_case_num2 = 3;
            else
                tmp_case_num2 = mod(tmp_case, 3);
            end

            fprintf(file, '片號 %s%d\n', list(1, ceil(tmp_case/3)), tmp_case_num2);
            fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
            fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
            fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', cell2mat(observed(31*tmp_case, 1)), cell2mat(observed(31*tmp_case, 2)), ...
                    V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_case, 1) - cell2mat(observed(31*tmp_case, 1)), cor_ture(tmp_case, 2) - cell2mat(observed(31*tmp_case, 2)));
        end

        sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
        fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
        fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
        fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
        fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
        fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);

        get_3D_ellipsoid(sigma_xx, cnt_case_num, file);

        fprintf(file, '\n\n');

        precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
        error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
        ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];

        break
    end    
end

%%% Error %%%
list_error = [3, 5, 10, 100, 3, 5, 10, 100] * 20*10^(-3);
error = [3, 0; 5, 0; 10, 0; 100, 0; 0, 3; 0, 5; 0, 10; 0, 100] * 20*10^(-3);
cnt = 99;

%%% Two %%%
cor_two = [cor_ture(1: 2, 1: 2)];
cor_error = get_cor_add_error(2, cor_two, error);
for i = 1: 8
    fprintf(file, 'Case %d: A1 A2\n\n', cnt);
    cnt = cnt + 1;
    init_XYZ = get_init_XYZ(f, cor_ABCD(1, 1), cor_ABCD(1, 2), cor_ABCD(1, 3), cor_ABCD(2, 1), cor_ABCD(2, 2), cor_ABCD(2, 3), cor_error(i*2-1, 1), cor_error(i*2, 1), cor_error(i*2, 2));
    P = diag([zeros(1, 4) + 1/sigma^2]);

    iteration = 0;
    while true
        iteration = iteration + 1;
        if iteration == 1
            Xp_ = init_XYZ(1, 1);
            Yp_ = init_XYZ(1, 2);
            Zp_ = init_XYZ(1, 3);
        end

        A = get_A_matrix(2, f, [1, 1], Xp_, Yp_, Zp_, [1, 2], rotation_matrix_ABCD, cor_ABCD);

        tmp1 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(1, 1), cor_ABCD(1, 2), cor_ABCD(1, 3), R_A));
        tmp2 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(2, 1), cor_ABCD(2, 2), cor_ABCD(2, 3), R_A));

        L = [cor_error(i*2 - 1, 1) - tmp1(1, 1);
             cor_error(i*2 - 1, 2) - tmp1(1, 2);
             cor_error(i*2 + 0, 1) - tmp2(1, 1);
             cor_error(i*2 + 0, 2) - tmp2(1, 2)];

        X_ = get_X_hat(A'*P*A, A'*P*L);

        print_iteration(iteration, X_, file);
        Xp_ = Xp_ + X_(1, 1);
        Yp_ = Yp_ + X_(2, 1);
        Zp_ = Zp_ + X_(3, 1);

        if max(abs(X_)) < door
            V = (A*X_-L);
            r = (2*2-3) / (2*2);
            sigma_naught = sqrt(V.'*P*V/(4-3));

            fprintf(file, '觀測數個數 n = 4, 未知數個數 u = 3, 自由度df = 1\n');
            fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);

            for num = 1: 2
                if num == 1
                    str_case = 'A1';
                    obs_cor = cor_error(i*2 - 1, 1:2);
                    vi = V(1 + 2*(num-1) + ceil(i/4)-1, 1);
                elseif num == 2
                    str_case = 'A2'; 
                    obs_cor = cor_error(i*2 + 0, 1:2);
                end
                fprintf(file, '片號 %s\n', str_case);
                fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', obs_cor(1, 1), obs_cor(1, 2), ...
                        V(1 + 2*(num-1), 1), V(1 + 2*(num-1) + 1, 1), cor_ture(num, 1) - obs_cor(1, 1), cor_ture(num, 2) - obs_cor(1, 2));
            end
            fprintf(file, '加錯的觀測值之 v / ε = %6.3f(mm)\n\n', vi / list_error(1, i));

            sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
            fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
            fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
            fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
            fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
            fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);

            fprintf(file, '\n\n');

            precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
            error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
            ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];
            break
        end
    end
end

%%% Four %%%
cor_four = [cor_ture(1, 1: 2); cor_ture(6, 1: 2); cor_ture(7, 1: 2); cor_ture(10, 1: 2)];
cor_error = get_cor_add_error(4, cor_four, error);
for i = 1: 8
    fprintf(file, 'Case %d: A1 B3 C1 D1\n\n', cnt);
    cnt = cnt + 1;
    init_XYZ = get_init_XYZ(f, cor_ABCD(1, 1), cor_ABCD(1, 2), cor_ABCD(1, 3), cor_ABCD(10, 1), cor_ABCD(10, 2), cor_ABCD(10, 3), cor_error(i*4-3, 1), cor_error(i*4, 1), cor_error(i*4, 2));
    P = diag([zeros(1, 8) + 1/sigma^2]);

    iteration = 0;
    while true
        iteration = iteration + 1;
        if iteration == 1
            Xp_ = init_XYZ(1, 1);
            Yp_ = init_XYZ(1, 2);
            Zp_ = init_XYZ(1, 3);
        end

        A = get_A_matrix(4, f, [1, 4, 7, 10], Xp_, Yp_, Zp_, [1, 6, 7, 10], rotation_matrix_ABCD, cor_ABCD);

        tmp1 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(01, 1), cor_ABCD(01, 2), cor_ABCD(01, 3), R_A));
        tmp2 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(06, 1), cor_ABCD(06, 2), cor_ABCD(06, 3), R_B));
        tmp3 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(07, 1), cor_ABCD(07, 2), cor_ABCD(07, 3), R_C));
        tmp4 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(10, 1), cor_ABCD(10, 2), cor_ABCD(10, 3), R_D));

        L = [cor_error(i*4 - 3, 1) - tmp1(1, 1);
             cor_error(i*4 - 3, 2) - tmp1(1, 2);
             cor_error(i*4 - 2, 1) - tmp2(1, 1);
             cor_error(i*4 - 2, 2) - tmp2(1, 2);
             cor_error(i*4 - 1, 1) - tmp3(1, 1);
             cor_error(i*4 - 1, 2) - tmp3(1, 2);
             cor_error(i*4 + 0, 1) - tmp4(1, 1);
             cor_error(i*4 + 0, 2) - tmp4(1, 2)];

        X_ = get_X_hat(A'*P*A, A'*P*L);

        print_iteration(iteration, X_, file);
        Xp_ = Xp_ + X_(1, 1);
        Yp_ = Yp_ + X_(2, 1);
        Zp_ = Zp_ + X_(3, 1);

        if max(abs(X_)) < door
            V = (A*X_-L);
            r = (2*4-3) / (2*4);
            sigma_naught = sqrt(V.'*P*V/(8-3));
            fprintf(file, '觀測數個數 n = 8, 未知數個數 u = 3, 自由度df = 5\n');
            fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);
            for tmp_case = 1: 4
                if tmp_case == 1
                    obs_cor = cor_error(i*4 - 3, 1: 2);
                    str_case = 'A1';
                    tmp_cor_ture = 1;
                    vi = V(1 + 2*(tmp_case-1) + ceil(i/4)-1, 1);
                elseif tmp_case == 2
                    obs_cor = cor_error(i*4 - 2, 1: 2);
                    str_case = 'B3';
                    tmp_cor_ture = 6;
                elseif tmp_case == 3
                    obs_cor = cor_error(i*4 - 1, 1: 2);
                    str_case = 'C1';
                    tmp_cor_ture = 7;
                elseif tmp_case == 4
                    obs_cor = cor_error(i*4 - 0, 1: 2);
                    str_case = 'D1';
                    tmp_cor_ture = 10;
                end
                fprintf(file, '片號 %s\n', str_case);
                fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', obs_cor(1, 1), obs_cor(1, 2), ...
                        V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_cor_ture, 1) - obs_cor(1, 1), cor_ture(tmp_cor_ture, 2) - obs_cor(1, 2));
            end
            fprintf(file, '加錯的觀測值之 v / ε = %6.3f(mm)\n\n', vi / list_error(1, i));

            sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
            fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
            fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
            fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
            fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
            fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);

            fprintf(file, '\n\n');

            precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
            error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
            ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];
            break
        end
    end
end

%%% Twelve %%%
cor_twelve = [cor_ture(1: 12, 1: 2)];
cor_error = get_cor_add_error(12, cor_twelve, error);
for i = 1: 8
    fprintf(file, 'Case %d: A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3\n\n', cnt);
    cnt = cnt + 1;
    init_XYZ = get_init_XYZ(f, cor_ABCD(1, 1), cor_ABCD(1, 2), cor_ABCD(1, 3), cor_ABCD(2, 1), cor_ABCD(2, 2), cor_ABCD(2, 3), cor_error(i*12-11, 1), cor_error(i*12-10, 1), cor_error(i*12-10, 2));
    P = diag([zeros(1, 24) + 1/sigma^2]);

    iteration = 0;
    while true
        iteration = iteration + 1;
        if iteration == 1
            Xp_ = init_XYZ(1, 1);
            Yp_ = init_XYZ(1, 2);
            Zp_ = init_XYZ(1, 3);
        end

        A = get_A_matrix(12, f, [1, 1, 1, 4, 4, 4, 7, 7, 7, 10, 10, 10], Xp_, Yp_, Zp_, [1: 12], rotation_matrix_ABCD, cor_ABCD);

        tmp01 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(01, 1), cor_ABCD(01, 2), cor_ABCD(01, 3), R_A));
        tmp02 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(02, 1), cor_ABCD(02, 2), cor_ABCD(02, 3), R_A));
        tmp03 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(03, 1), cor_ABCD(03, 2), cor_ABCD(03, 3), R_A));
        tmp04 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(04, 1), cor_ABCD(04, 2), cor_ABCD(04, 3), R_B));
        tmp05 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(05, 1), cor_ABCD(05, 2), cor_ABCD(05, 3), R_B));
        tmp06 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(06, 1), cor_ABCD(06, 2), cor_ABCD(06, 3), R_B));
        tmp07 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(07, 1), cor_ABCD(07, 2), cor_ABCD(07, 3), R_C));
        tmp08 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(08, 1), cor_ABCD(08, 2), cor_ABCD(08, 3), R_C));
        tmp09 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(09, 1), cor_ABCD(09, 2), cor_ABCD(09, 3), R_C));
        tmp10 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(10, 1), cor_ABCD(10, 2), cor_ABCD(10, 3), R_D));
        tmp11 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(11, 1), cor_ABCD(11, 2), cor_ABCD(11, 3), R_D));
        tmp12 = vpa(collinearity(x0, y0, f, Xp_, Yp_, Zp_, cor_ABCD(12, 1), cor_ABCD(12, 2), cor_ABCD(12, 3), R_D));

        L = [cor_error(i*12 - 11) - tmp01(1, 1); 
             cor_error(i*12 - 11) - tmp01(1, 2);
             cor_error(i*12 - 10) - tmp02(1, 1); 
             cor_error(i*12 - 10) - tmp02(1, 2);
             cor_error(i*12 - 09) - tmp03(1, 1); 
             cor_error(i*12 - 09) - tmp03(1, 2);
             cor_error(i*12 - 08) - tmp04(1, 1); 
             cor_error(i*12 - 08) - tmp04(1, 2);
             cor_error(i*12 - 07) - tmp05(1, 1); 
             cor_error(i*12 - 07) - tmp05(1, 2);
             cor_error(i*12 - 06) - tmp06(1, 1); 
             cor_error(i*12 - 06) - tmp06(1, 2);
             cor_error(i*12 - 05) - tmp07(1, 1); 
             cor_error(i*12 - 05) - tmp07(1, 2);
             cor_error(i*12 - 04) - tmp08(1, 1); 
             cor_error(i*12 - 04) - tmp08(1, 2);
             cor_error(i*12 - 03) - tmp09(1, 1); 
             cor_error(i*12 - 03) - tmp09(1, 2);
             cor_error(i*12 - 02) - tmp10(1, 1); 
             cor_error(i*12 - 02) - tmp10(1, 2);
             cor_error(i*12 - 01) - tmp11(1, 1); 
             cor_error(i*12 - 01) - tmp11(1, 2);
             cor_error(i*12 - 00) - tmp12(1, 1); 
             cor_error(i*12 - 00) - tmp12(1, 2)];

        X_ = get_X_hat(A'*P*A, A'*P*L);

        print_iteration(iteration, X_, file);
        Xp_ = Xp_ + X_(1, 1);
        Yp_ = Yp_ + X_(2, 1);
        Zp_ = Zp_ + X_(3, 1);

        if max(abs(X_)) < door
            V = (A*X_-L);
            r = (2*12-3) / (2*12);
            sigma_naught = sqrt(V.'*P*V/(24-3));
            fprintf(file, '觀測數個數 n = 24, 未知數個數 u = 3, 自由度df = 21\n');
            fprintf(file, '平均多餘觀測數 r = ( n - u ) / n = %.3f\n\n', r);
            for tmp_case = 1: 12

                if tmp_case == 1
                    vi = V(1 + 2*(tmp_case-1) + ceil(i/4)-1, 1);
                end
                if mod(tmp_case, 3) == 0
                    tmp_case_num2 = 3;
                else
                    tmp_case_num2 = mod(tmp_case, 3);
                end

                fprintf(file, '片號 %s%d\n', list(1, ceil(tmp_case/3)), tmp_case_num2);
                fprintf(file, '點號 像座標xp(mm) 像座標yp(mm) 改正數vx(mm) 改正數vy(mm) 真誤差εx(mm) 真誤差εy(mm)\n');
                fprintf(file, '==== ===========  ============ ============ ============ ============ ============\n');
                fprintf(file, '  p    %7.3f      %7.3f      %7.3f      %7.3f      %7.3f      %7.3f\n\n', cor_error(i*12 - (12-tmp_case), 1), cor_error(i*12 - (12-tmp_case), 2), ...
                        V(1 + 2*(tmp_case-1), 1), V(1 + 2*(tmp_case-1) + 1, 1), cor_ture(tmp_case, 1) - cor_error(i*12 - (12-tmp_case), 1), cor_ture(tmp_case, 2) - cor_error(i*12 - (12-tmp_case), 2));
            end
            fprintf(file, '加錯的觀測值之 v / ε = %6.3f(mm)\n\n', vi / list_error(1, i));

            sigma_xx = (sigma_naught*10^(-3))^2*inv(A.'*P*A);
            fprintf(file, '後驗單位權中誤差 sigma naught = %6.3f(mm)\n\n', sigma_naught);
            fprintf(file, 'P點地面坐標最或是值與後驗中誤差及其真誤差(true error)ε:\n');
            fprintf(file, 'Xp = %11.3f +/- %5.3f (m)\tεXp = %6.3f (m)\n', Xp_, sqrt(sigma_xx(1, 1)), Xp-Xp_);
            fprintf(file, 'Yp = %11.3f +/- %5.3f (m)\tεYp = %6.3f (m)\n', Yp_, sqrt(sigma_xx(2, 2)), Yp-Yp_);
            fprintf(file, 'Zp = %11.3f +/- %5.3f (m)\tεZp = %6.3f (m)\n', Zp_, sqrt(sigma_xx(3, 3)), Zp-Zp_);

            fprintf(file, '\n\n');

            precision_max_min(cnt, 2: 3) = [max(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)])), min(abs([sigma_xx(1, 1), sigma_xx(2, 2), sigma_xx(3, 3)]))];
            error_max_min(cnt, 2: 3) = [max(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_])), min(abs([Xp-Xp_, Yp-Yp_, Zp-Zp_]))];     
            ratio_X_Y_Z(cnt, 2: 4) = [sqrt(sigma_xx(1, 1))/(Xp-Xp_),  sqrt(sigma_xx(2, 2))/(Yp-Yp_), sqrt(sigma_xx(3, 3))/(Zp-Zp_)];
            break
        end
    end
end

tmp_ratio = [min(abs(ratio_X_Y_Z(:, 2: 4))); max(abs(ratio_X_Y_Z(:, 2: 4))); mean(ratio_X_Y_Z(:, 2: 4)); std(ratio_X_Y_Z(:, 2: 4))];

xlswrite("output.xlsx", {'Case NO.', 'pre_max', 'pre_min'}, 1, "J1: L1");
xlswrite("output.xlsx", precision_max_min, 1, "J2: L123");
xlswrite("output.xlsx", {'Case NO.', 'err_max', 'err_min'}, 1, "N1: P1");
xlswrite("output.xlsx", error_max_min, 1, "N2: P123");
xlswrite("output.xlsx", {'Case NO.', 'ratio_X', 'ratio_Y', 'ratio_Z'}, 1, "R1: U1");
xlswrite("output.xlsx", ratio_X_Y_Z, 1, "R2: U123");
xlswrite("output.xlsx", {'min'; 'max'; 'mean'; 'rms'}, 1, "R125: R128");
xlswrite("output.xlsx", tmp_ratio, 1, "S125: U128");

%%% Function %%%
function output = rotation_matrix(R, data_ang, omega, psi, kappa)
    T = zeros(1, 3);
    for i = 1: 3
        T(i) = dms2rad([data_ang(i, 1), data_ang(i, 2), data_ang(i, 3)]);
    end
    output = subs(R,[omega, psi, kappa], T);
end

function output = collinearity(x0, y0, f, Xp, Yp, Zp, XL, YL, ZL, R)
    fun1 = R(1, 1)*(Xp - XL) + R(1, 2)*(Yp - YL) + R(1, 3)*(Zp - ZL);
    fun2 = R(2, 1)*(Xp - XL) + R(2, 2)*(Yp - YL) + R(2, 3)*(Zp - ZL);
    fun3 = R(3, 1)*(Xp - XL) + R(3, 2)*(Yp - YL) + R(3, 3)*(Zp - ZL);

    output = [x0 - f*fun1/fun3, y0 - f*fun2/fun3];
end

function output = get_qrs(R, Xp, Yp, Zp, XL, YL, ZL)
    q = R(3, 1)*(Xp - XL) + R(3, 2)*(Yp - YL) + R(3, 3)*(Zp - ZL);
    r = R(1, 1)*(Xp - XL) + R(1, 2)*(Yp - YL) + R(1, 3)*(Zp - ZL);
    s = R(2, 1)*(Xp - XL) + R(2, 2)*(Yp - YL) + R(2, 3)*(Zp - ZL);

    output = [q, r, s];
end

function output = get_b_matrix(f, R, Xp, Yp, Zp, XL, YL, ZL)
    T = get_qrs(R, Xp, Yp, Zp, XL, YL, ZL);

    q = T(1, 1);
    r = T(1, 2);
    s = T(1, 3);

    b14 = f/(q^2) * (r*R(3, 1) - q*R(1, 1));
    b15 = f/(q^2) * (r*R(3, 2) - q*R(1, 2));
    b16 = f/(q^2) * (r*R(3, 3) - q*R(1, 3));
    b24 = f/(q^2) * (s*R(3, 1) - q*R(2, 1));
    b25 = f/(q^2) * (s*R(3, 2) - q*R(2, 2));
    b26 = f/(q^2) * (s*R(3, 3) - q*R(2, 3));

    output = [b14, b15, b16; b24, b25, b26];
end

function output = get_init_XYZ(f, XL1, YL1, ZL1, XL2, YL2, ZL2, xpL, xpR, ypR)
    H = 0.5 * (ZL1 + ZL2);
    B = sqrt((XL1 - XL2)^2 + (YL1 - YL2)^2);
    pp = xpL - xpR;
    
    Xp0 = (XL2 - XL1)/B*xpR - (YL2 - YL1)/B*ypR + XL1;
    Yp0 = (XL2 - XL1)/B*ypR + (YL2 - YL1)/B*xpR + YL1;
    Zp0 = H - B*f/pp;

    output = [Xp0, Yp0, Zp0];
end

function output = get_3D_ellipsoid(sigma_xx, cnt_case_num, file)
    [EV, DV] = eig(sigma_xx * 10^(6));
    EV = double(EV);
    DV = double(DV);
    
    [ell_x, ell_y, ell_z] = ellipsoid(0, 0, 0, sqrt(DV(1, 1)), sqrt(DV(2, 2)), sqrt(DV(3, 3)));
    elliposid = surf(ell_x, ell_y, ell_z);  
    angle_x = rad2deg(atan2(norm(cross([1, 0, 0],EV(1, 1:3))), dot([1, 0, 0],EV(1, 1:3))));
    angle_y = rad2deg(atan2(norm(cross([0, 1, 0],EV(1, 1:3))), dot([0, 1, 0],EV(1, 1:3))));
    angle_z = rad2deg(atan2(norm(cross([0, 0, 1],EV(1, 1:3))), dot([0, 0, 1],EV(1, 1:3))));
    rotate(elliposid, [1, 0, 0], angle_x);
    rotate(elliposid, [0, 1, 0], angle_y);
    rotate(elliposid, [0, 0, 1], angle_z);

    tmp_str = sprintf('Case %02d', cnt_case_num);
    title(tmp_str)
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    tmp_str = sprintf("./picture//Case_%02d.png", cnt_case_num);
    saveas(gcf, tmp_str);
    fprintf(file, '\n');
    fprintf(file, 'λ1 = %6.3f, λ2 = %6.3f, λ3 = %6.3f\n', sqrt(DV(1, 1)), sqrt(DV(2, 2)), sqrt(DV(3, 3)));
    fprintf(file, 'v1 = [%6.3f, %6.3f, %6.3f]\n', EV(1, 1), EV(1, 2), EV(1, 3));
    fprintf(file, 'v2 = [%6.3f, %6.3f, %6.3f]\n', EV(2, 1), EV(2, 2), EV(2, 3));
    fprintf(file, 'v3 = [%6.3f, %6.3f, %6.3f]\n', EV(3, 1), EV(3, 2), EV(3, 3));

    output = [];
end

function output = print_iteration(iteration, X_, file)
    fprintf(file, 'iteration %d\n', iteration);
    fprintf(file, 'dXp = %9.6f(m), dYp = %9.6f(m), dZp = %9.6f(m)\n', X_(1, 1), X_(2, 1), X_(3, 1));
    fprintf(file, 'max(|dXp|, |dYp|, |dZp|) = %9.6f(m)\n\n', max(abs(X_)));
    
    output = [];
end

function output = get_A_matrix(n, f, index_rotation_matrix, Xp_, Yp_, Zp_, index_cor_ABCD, rotation_matrix_ABCD, cor_ABCD)
    A = zeros(n*2, 3);
    for i = 1: n
        A(i*2-1: i*2, 1: 3) = get_b_matrix(f, rotation_matrix_ABCD(index_rotation_matrix(1, i): index_rotation_matrix(1, i)+2, 1:3), Xp_, Yp_, Zp_, cor_ABCD(index_cor_ABCD(1, i), 1), cor_ABCD(index_cor_ABCD(1, i), 2), cor_ABCD(index_cor_ABCD(1, i), 3));
    end
    
    output = vpa(A);
end

function output = get_X_hat(LHS, RHS)
    G = chol(LHS, 'nocheck');
    T = G';
    T(:, 4) = RHS;
    T = rref(T);
    X = G;
    X(:, 4) = T(:, end);
    X = rref(X);

    output = X(:, end);
end

function output = get_cor_add_error(n, cor_true, error)
    cor_output = zeros(n*8, 2);
    cnt = 1;
    for i = 1: 8
        for j = 1: n
            if j == 1
                cor_output(cnt, 1) = cor_true(j, 1) + error(i, 1);
                cor_output(cnt, 2) = cor_true(j, 2) + error(i, 2);
            else 
                cor_output(cnt, 1: 2) = [cor_true(j, 1), cor_true(j, 2)];
            end
            cnt = cnt + 1;
        end    
    end
    
    output = cor_output;
end
