function [estimated_X, estimated_Qx] = updation(predicted_X, predicted_Qx, A, L, R)
%% ========== Updation ========== %%
T = (R+A*predicted_Qx*A')^-1;
K = predicted_Qx*A'*T;
estimated_X = predicted_X - K*(A*predicted_X-L);
estimated_Qx = predicted_Qx - K*A*predicted_Qx;

end