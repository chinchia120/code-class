clear all;
clc;
%% load data
A = load("A_matrix.mat");
L = load("L_Vector.mat");
W = load("WeightMatrix.mat");
A = struct2array(A);
L = struct2array(L);
W = struct2array(W);
CKSV = [-2956619.406; 5075902.161; 2476625.471];
%% stationary
Phi = eye(81); % transition matrix
staionary = [0*ones(1, 80) 0.00003^2]; % sigmax, y, z, N = 0
Q0 = diag(staionary);
Qw = diag(staionary);
initial_vector = zeros(81, 1);
for i = 1:length(L)
    A_epoch = A{i};
    L_epoch = L{i};
    W_epoch = W{i};
    if i == 1
        predict_X = initial_vector;
        predict_Qx = Q0;
        [estimated_X, estimated_Qx] = Updation(predict_X, predict_Qx, A_epoch, L_epoch, W_epoch);
        staionary_X(1, :) = estimated_X(1);
        staionary_Y(1, :) = estimated_X(2);
        staionary_Z(1, :) = estimated_X(3);
        staionary_ZTD(1, :) = estimated_X(81);
    else
        [predict_X, predict_Qx] = Prediction(estimated_X, estimated_Qx, Phi, Qw);
        [estimated_X, estimated_Qx] = Updation(predict_X, predict_Qx, A_epoch, L_epoch, W_epoch);
        staionary_X(i, :) = estimated_X(1);
        staionary_Y(i, :) = estimated_X(2);
        staionary_Z(i, :) = estimated_X(3);
        staionary_ZTD(i, :) = estimated_X(81);
    end
end

function [predict_X,predict_Qx] = Prediction(estimated_X,estimated_Qx,Phi,Qw)
    predict_X = Phi*estimated_X + 0;
    predict_Qx = Phi*estimated_Qx*Phi'+ Qw;
end

function [estimated_X,estimated_Qx] = Updation(predicted_X,predicted_Qx,A,L,W)
    T = (W + A*predicted_Qx*A')^-1;
    K = predicted_Qx*A'*T;
    estimated_X = predicted_X - K*(A*predicted_X - L);
    estimated_Qx = predicted_Qx - K*A*predicted_Qx;
end
t = 1: length(L);

%% plot
f = figure;

subplot(4, 1, 1)
plot(t, staionary_X)
title('estimated X');
ylabel('X');

subplot(4, 1, 2)
plot(t, staionary_Y)
title('estimated Y');
ylabel('Y');

subplot(4, 1, 3)
plot(t, staionary_Z)
title('estimated Z');
ylabel('Z');

subplot(4, 1, 4)
plot(t, staionary_ZTD)
title('estimated ZTD');
ylabel('ZTD');

saveas(f, 'stationary.png');

%{
%% kinematic
Phi = eye(81); % transition matrix
kinematic = [100^2, 100^2, 100^2, 0*ones(1, 77) 0.00003^2]; % sigmax, y, z = 100, N = 0
Q0 = diag(kinematic);
Qw = diag(kinematic);
initial_vector = zeros(81, 1);
for i = 1:81
    i
    A_epoch = A{i};
    L_epoch = L{i};
    W_epoch = W{i};
    if i == 1
        predict_X = initial_vector;
        predict_Qx = Q0;
        [estimated_X, estimated_Qx] = Updation(predict_X(i, 1), predict_Qx(i, 1), A_epoch, L_epoch, W_epoch);
        kinematic_X(1) = estimated_X(1, 1);
        kinematic_Y(1) = estimated_X(2, 2);
        kinematic_Z(1) = estimated_X(3, 3);
    else
        [predict_X, predict_Qx] = Prediction(estimated_X(i - 1, 1), estimated_Qx(i - 1, 1), Phi, Qw);
        [estimated_X, estimated_Qx] = Updation(predict_X(i, 1), predict_Qx(i, 1), A_epoch, L_epoch, W_epoch);
        kinematic_X(i) = estimated_X(1, 1);
        kinematic_Y(i) = estimated_X(2, 2);
        kinematic_Z(i) = estimated_X(3, 3);
    end
end
for i = 1 : 81
    t(i) = i;
end
%% plot
f = figure;
subplot(3, 1, 1)
plot(t, kinematic_X)
title('estimated X');
xlabel('epoch');
ylabel('X');
subplot(3, 1, 2)
plot(t, kinematic_Y)
title('estimated Y');
xlabel('epoch');
ylabel('Y');
subplot(3, 1, 3)
plot(t, kinematic_Z)
title('estimated Z');
xlabel('epoch');
ylabel('Z');
saveas(f, 'kinematic.png');
%}
