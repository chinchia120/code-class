function [estimated_X, estimated_Qx] = KalmanFilter(A, L, R, X0, Q0, Qw, Phi)
% ACOM{time}, LCOM{time}, WeightMatrix{time}, InitialVector, InitialVCMatrix, VCMatrix, TransitionMatrix
% ACOM{time} = A = 18 * 81
% LCOM{time} = L = 18 * 01
% WeightMatrix{time} = R = 18 * 18
% InitialVector = X0 = 81 * 01
% InitialVCMatrix = Q0 = 81 * 81
% VCMatrix = Qw = 81 * 81
% TransitionMatrix = Phi = 18 * 18

%% ========== Initial Value ========== %%
predict_X = cell(length(L), 1);
predict_Qx = cell(length(L), 1);
estimated_X = cell(length(L), 1);
estimated_Qx = cell(length(L), 1);

%% ========== Kalman Filter ========== %%
for time = 1: length(L)
    if time == 1
        predict_X{time} = X0;
        predict_Qx{time} = Q0;
    else
        [predict_X{time}, predict_Qx{time}] = prediction(estimated_X{time-1}, estimated_Qx{time-1}, Phi, Qw);        
    end
        [estimated_X{time}, estimated_Qx{time}] = updation(predict_X{time}, predict_Qx{time}, A{time}, L{time}, R{time});
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
% estimated_X = predicted_X - K*(A*predicted_X-L) = 81 * 01
% X = 81 * 01
% K = 81 * 18
% A = 18 * 81
% L = 18 * 01
%
% estimated_Qx = predicted_Qx - K*A*predicted_Qx = 81 * 81
%
% predict_X = Phi*estimated_X + 0;
% 
