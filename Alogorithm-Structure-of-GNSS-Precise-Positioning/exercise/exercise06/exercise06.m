%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Initial Value
R = 0.1;                               %觀測量精度(sigma)
r = random('normal', 0, R, 1000, 1);    %第一時刻至最後一時刻資料產生 
A = 1;                                  %設計矩陣
Phi = 1;                                %轉移矩陣(transition matrix)
Qw = 0^2;                               %推估雜訊(sigma of the system process noise)

% [predict_X,predict_Qx] = Prediction(estimated_X,estimated_Qx,Phi,Qw) %推估function
% [estimated_X,estimated_Qx] = Updation(predicted_X,predicted_Qx,A,L,R) %更新function

%% ========== Question 1 ========== %%
% ===== Case 1
X0_1 = 100;
Q0_1 = 10000^2;

for i = 1: size(r, 1)
    L = r(i);
    if i == 1
        predict_X(i, 1) = X0_1;
        predict_Qx(i, 1) = Q0_1;
    else
        [predict_X(i, 1) predict_Qx(i, 1)] = prediction(estimated_X(i-1, 1), estimated_Qx(i-1, 1), Phi, Qw);
        
    end
    [estimated_X(i, 1) estimated_Qx(i, 1)] = updation(predict_X(i, 1), predict_Qx(i, 1), A, L, R);
end
scatter_plot(1: size(r, 1), estimated_X(:, 1));


