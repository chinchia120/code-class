%% ========== Setup ========== %%
clc;
clear;
close all;
openExample('shared_tracking_fusion/ConstantVelocityLinearKalmanFilterExample')
openExample('shared_tracking_fusion/UseCustomTrackingKFWithControlInputsExample')
%% ========== Reference ========== %%
% Define sensor locations
sensor_locations = [-1000, -1000; 
                    -1000, 1000; 
                    1000, 1000; 
                    1000, -1000];

% Define target movement trajectories for both cases
% Case 1: Target moves from (-2000, 0) to (2000, 0) straightly with speed 50 m/s
target_positions_case1_x = linspace(-2000, 2000, 100);
target_positions_case1_y = linspace(0, 0, 100);
target_positions_case1 = [target_positions_case1_x; target_positions_case1_y];

% Case 2: Target moves from (-2000, -2000) to (2000, 2000) with speed 40 m/s
target_positions_case2_x = linspace(-2000, 2000, 100);
target_positions_case2_y = linspace(-2000, 2000, 100);
target_positions_case2 = [target_positions_case2_x; target_positions_case2_y];

% Define variance of TDOA measurement noise
variance = 16; % m^2

% Simulate TDOA measurements for both cases
tdoa_measurements_case1 = generate_tdoa_measurements(target_positions_case1, sensor_locations, variance);
tdoa_measurements_case2 = generate_tdoa_measurements(target_positions_case2, sensor_locations, variance);

% Apply weighted least squares method to estimate position and provide covariance for both cases
[estimated_positions_wls_case1, covariances_wls_case1] = apply_weighted_least_squares(sensor_locations, tdoa_measurements_case1, variance);
[estimated_positions_wls_case2, covariances_wls_case2] = apply_weighted_least_squares(sensor_locations, tdoa_measurements_case2, variance);

% Apply Kalman filter to estimate position and provide covariance for both cases
[estimated_positions_kalman_case1, covariances_kalman_case1] = apply_kalman_filter(sensor_locations, tdoa_measurements_case1, variance);
[estimated_positions_kalman_case2, covariances_kalman_case2] = apply_kalman_filter(sensor_locations, tdoa_measurements_case2, variance);

% Plot TDOA measurements for Case 1
figure;
plot_tdoa_measurements(tdoa_measurements_case1, 'TDOA Measurements for Case 1');

% Plot TDOA measurements for Case 2
figure;
plot_tdoa_measurements(tdoa_measurements_case2, 'TDOA Measurements for Case 2');

% Plot estimated positions and covariance for Case 1 (Weighted Least Squares)
plot_estimated_positions_and_covariances(estimated_positions_wls_case1, covariances_wls_case1, 'Estimated Position and Covariance for Case 1 (WLS)');

% Plot estimated positions and covariance for Case 2 (Weighted Least Squares)
plot_estimated_positions_and_covariances(estimated_positions_wls_case2, covariances_wls_case2, 'Estimated Position and Covariance for Case 2 (WLS)');

% Plot estimated positions and covariance for Case 1 (Kalman Filter)
plot_estimated_positions_and_covariances(estimated_positions_kalman_case1, covariances_kalman_case1, 'Estimated Position and Covariance for Case 1 (Kalman Filter)');

% Plot estimated positions and covariance for Case 2 (Kalman Filter)
plot_estimated_positions_and_covariances(estimated_positions_kalman_case2, covariances_kalman_case2, 'Estimated Position and Covariance for Case 2 (Kalman Filter)');

function tdoa_measurements = generate_tdoa_measurements(target_positions, sensor_locations, variance)
    num_targets = size(target_positions, 2);
    num_sensors = size(sensor_locations, 1);
    tdoa_measurements = zeros(num_targets, num_sensors - 1);
    for i = 1:num_targets
        target_position = target_positions(:, i);
        tdoa = zeros(1, num_sensors - 1);
        for j = 2:num_sensors
            tdoa(j - 1) = norm(target_position' - sensor_locations(j, :)) - norm(target_position' - sensor_locations(1, :));
        end
        noise = sqrt(variance) * randn(1, num_sensors - 1);
        tdoa_measurements(i, :) = tdoa + noise;
    end
end

function [estimated_positions, covariances] = apply_weighted_least_squares(sensor_locations, tdoa_measurements, variance)
    num_targets = size(tdoa_measurements, 1);
    num_sensors = size(sensor_locations, 1);
    estimated_positions = zeros(num_targets, 2);
    covariances = zeros(num_targets, 2, 2);
    for i = 1:num_targets
        target_position_guess = [0, 0];
        A = zeros(num_sensors - 1, 2);
        b = zeros(num_sensors - 1, 1);
        for j = 2:num_sensors
            A(j - 1, 1) = (target_position_guess(1) - sensor_locations(1, 1)) / norm(target_position_guess - sensor_locations(j, :));
            A(j - 1, 2) = (target_position_guess(2) - sensor_locations(1, 2)) / norm(target_position_guess - sensor_locations(j, :));
            b(j - 1) = tdoa_measurements(i, j - 1) - norm(sensor_locations(j, :) - target_position_guess) + norm(sensor_locations(1, :) - target_position_guess);
        end
        W = eye(num_sensors - 1) / variance;
        x = (A' * W * A) \ (A' * W * b);
        estimated_positions(i, :) = target_position_guess + x';
        covariances(i, :, :) = inv(A' * W * A);
    end
end

function [estimated_positions, covariances] = apply_kalman_filter(sensor_locations, tdoa_measurements, variance)
    num_targets = size(tdoa_measurements, 1);
    num_sensors = size(sensor_locations, 1);
    estimated_positions = zeros(num_targets, 2);
    covariances = zeros(num_targets, 2, 2);
    for i = 1:num_targets
        % Initialize Kalman filter
        kf = KalmanFilter(sensor_locations(1, :)', eye(2), zeros(2), eye(num_sensors - 1) * variance);

        % Apply Kalman filter
        for j = 1:size(tdoa_measurements, 2)
            kf.predict();
            kf.update(tdoa_measurements(i, j));
        end

        % Store estimated position and covariance
        estimated_positions(i, :) = kf.x_hat';
        covariances(i, :, :) = kf.P;
    end
end

function plot_tdoa_measurements(tdoa_measurements, title_str)
    figure;
    plot(tdoa_measurements(:, 1), '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'TDOA Sensor 1');
    hold on;
    plot(tdoa_measurements(:, 2), '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'TDOA Sensor 2');
    plot(tdoa_measurements(:, 3), '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'TDOA Sensor 3');
    xlabel('Time Step');
    ylabel('TDOA Measurement (m)');
    title(title_str);
    legend('Location', 'northwest');
    grid on;
    hold off;
end

function plot_estimated_positions_and_covariances(estimated_positions, covariances, title_str)
    figure;
    plot(estimated_positions(:, 1), estimated_positions(:, 2), '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Estimated Position');
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    title(title_str);
    hold on;
    for i = 1:size(estimated_positions, 1)
        error_ellipse(squeeze(covariances(i, :, :)), estimated_positions(i, :), 'conf', 0.95);
    end
    legend('Location', 'northwest');
    grid on;
    hold off;
end