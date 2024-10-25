function [predict_X, predict_Qx] = prediction(estimated_X, estimated_Qx, Phi, Qw)
% estimated_X:更新後推估參數向量(此題目為一維情況)
% estimated_Qx: 更新後參數方差矩陣or協因子矩陣(此題目為一維情況)
% Phi: 轉移矩陣(此題目為一維情況)
% Qw: 推估雜訊矩陣(此題目為一維情況)

predict_X = Phi*estimated_X + 0;              %推估後參數向量(此題目為一維情況)
predict_Qx = Phi*estimated_Qx*Phi' + Qw;     %推估後參數方差矩陣or協因子矩陣(此題目為一維情況)

end