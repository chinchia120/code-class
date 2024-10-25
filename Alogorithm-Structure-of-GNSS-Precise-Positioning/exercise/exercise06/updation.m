function [estimated_X, estimated_Qx] = updation(predicted_X, predicted_Qx, A, L, R)
% predicted_X:推估後推估參數向量(此題目為一維情況)
% predicted_Qx:推估後參數方差矩陣or協因子矩陣(此題目為一維情況)
% A: observatoin model之設計矩陣更新後參數方差矩陣or協因子矩陣(此題目為一維情況)
% L:此時刻之觀測向量
% R:此時刻之觀測向量之方差矩陣or協因子矩陣

T = (R+A*predicted_Qx*A')^-1;
K = predicted_Qx*A'*T;                          %kalman gain
estimated_X = predicted_X - K*(A*predicted_X-L);
estimated_Qx = predicted_Qx - K*A*predicted_Qx;

end