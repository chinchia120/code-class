function [estimated_X, estimated_Qx] = kalman_filter(A, L, R, X0, Q0, Qw, Phi)
%% ========== Initial Value ========== %%
predict_X = cell(length(L), 1);
predict_Qx = cell(length(L), 1);
estimated_X = cell(length(L), 1);
estimated_Qx = cell(length(L), 1);

%% ========== Kalman Filter ========== %%
for i = 1: length(L)
    if i == 1
        predict_X{i} = X0;
        predict_Qx{i} = Q0;
    else
        [predict_X{i}, predict_Qx{i}] = prediction(estimated_X{i-1}, estimated_Qx{i-1}, Phi, Qw);        
    end
        [estimated_X{i}, estimated_Qx{i}] = updation(predict_X{i}, predict_Qx{i}, A, L, R);
end

end
% T = R+A*predicted_Qx*A' = 18 * 18 
% R = 18 * 18
% A = 18 * 81
% Q = 81 * 81
% 
% K = predicted_Qx*A'*T = 81 * 18
% Q = 81 * 81
% A = 18 * 81
% T = 18 * 18
% 
% estimated_X = predicted_X - K*(A*predicted_X-L);
% X = 18 * 01
% K = 81 * 18
% A = 18 * 81
% L = 18 * 01
