% Homework 4 - GNSS Signal Acquisition and Tracking
clc; clear; close all;
% Define your student ID
student_id = 66134111;
reversed_id = str2num(fliplr(num2str(student_id)));

% Calculate PRN numbers
PRN1 = mod(student_id, 32) + 1;
PRN2 = mod(reversed_id, 32) + 1;

% Generate GNSS waveform and record I and Q samples
[waveform, I_samples, Q_samples] = generateGNSSWaveform(PRN1, PRN2);

% Plot I and Q samples
figure;
subplot(2,1,1);
plot(I_samples);
title('I Samples');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2,1,2);
plot(Q_samples);
title('Q Samples');
xlabel('Sample Index');
ylabel('Amplitude');

% Acquire PRN#1 and PRN#2
[acquisition_PRN1, acquisition_PRN2] = acquirePRNs(waveform, PRN1, PRN2);

% Plot acquisition results
figure;
subplot(2,1,1);
plot(acquisition_PRN1);
title(['Acquisition PRN#', num2str(PRN1)]);
xlabel('Sample Index');
ylabel('Correlation');

subplot(2,1,2);
plot(acquisition_PRN2);
title(['Acquisition PRN#', num2str(PRN2)]);
xlabel('Sample Index');
ylabel('Correlation');

% Track PRN#1 and PRN#2
[tracking_PRN1, tracking_PRN2] = trackPRNs(waveform, PRN1, PRN2);

% Plot tracking results
figure;
subplot(2,1,1);
plot(tracking_PRN1.codePhaseError);
title(['Code Phase Tracking Error PRN#', num2str(PRN1)]);
xlabel('Sample Index');
ylabel('Error');

subplot(2,1,2);
plot(tracking_PRN1.carrierPhaseError);
title(['Carrier Phase Tracking Error PRN#', num2str(PRN1)]);
xlabel('Sample Index');
ylabel('Error');

figure;
subplot(2,1,1);
plot(tracking_PRN2.codePhaseError);
title(['Code Phase Tracking Error PRN#', num2str(PRN2)]);
xlabel('Sample Index');
ylabel('Error');

subplot(2,1,2);
plot(tracking_PRN2.carrierPhaseError);
title(['Carrier Phase Tracking Error PRN#', num2str(PRN2)]);
xlabel('Sample Index');
ylabel('Error');
