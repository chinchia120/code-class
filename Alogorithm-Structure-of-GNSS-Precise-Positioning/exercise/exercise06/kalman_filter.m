function [estimated_X] = kalman_filter(A, L, R, X0, Q0, Qw, Phi)

for i = 1: size(L, 1)
    if i == 1
        predict_X(i, 1) = X0;
        predict_Qx(i, 1) = Q0;
    else
        [predict_X(i, 1) predict_Qx(i, 1)] = prediction(estimated_X(i-1, 1), estimated_Qx(i-1, 1), Phi, Qw);        
    end
        [estimated_X(i, 1) estimated_Qx(i, 1)] = updation(predict_X(i, 1), predict_Qx(i, 1), A, L(i), R);
end

end