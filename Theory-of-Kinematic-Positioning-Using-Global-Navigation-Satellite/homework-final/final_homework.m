%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Initial Value ========== %%
ABMF = [2919785.7178, -5383745.0532, 1774604.7152];
final = [10003,2919791.55179,-5383745.23999,1774605.01829,5149,5675;
         10004,2919788.87064,-5383745.94988,1774604.51937,5284,5813;
         10005,2919793.26868,-5383741.19686,1774604.08608,5051,5561;
         10006,2919790.01531,-5383742.51442,1774603.20265,5210,5788;
         10007,2919789.65181,-5383740.95275,1774602.68520,5005,5583;
         10008,2919790.14020,-5383744.22405,1774602.89505,4934,5539;
         10009,2919794.87503,-5383741.85842,1774605.13703,4947,5564;];

%% ========== Select .KIN Folder ========== %%
% PathNameInput = uigetdir(addpath(genpath(pwd)), 'Please Select Input .KIN Folder.');
PathNameInput = 'C:\Users\chin\Desktop\seminar\GNSS\homework-final\data-KIN';
FileList_KIN = dir(fullfile(PathNameInput, '*.KIN'));

%% ========== Select .OUT Folder ========== %%
% PathNameInput = uigetdir(addpath(genpath(pwd)), 'Please Select Input .OUT Folder.');
PathNameInput = 'C:\Users\chin\Desktop\seminar\GNSS\homework-final\data-OUT';
FileList_OUT = dir(fullfile(PathNameInput, '*.OUT'));

%% ========== Select Output Folder ========== %%
% PathNameOutput = uigetdir(addpath(genpath(pwd)), 'Please Select Output Folder.');
PathNameOutput = 'C:\Users\chin\Desktop\seminar\GNSS\homework-final\output';

%% ========== Load .KIN Data ========== %%
FilePara = fopen([PathNameOutput, '\', 'Parameter.txt'], 'w');
fprintf(FilePara,'%%%% ========== Parameter ========== %%%%\n');

RawData_KIN = [];
for i = 1: numel(FileList_KIN)
    file_KIN = readmatrix([FileList_KIN(i).folder,'\',FileList_KIN(i).name],'FileType','text','ConsecutiveDelimitersRule','join','Range',7);
    fprintf(FilePara,'X = %.4f Y = %.4f Z = %.4f\n', mean(file_KIN(:, 5)), mean(file_KIN(:, 6)), mean(file_KIN(:, 7)));
    RawData_KIN(size(RawData_KIN,1)+1: size(RawData_KIN,1)+size(file_KIN,1), :) = file_KIN;
end

%% ========== Analysis Data ========== %%
res = final(:, 2:4) - ABMF;

subplot(3, 1, 1);
scatter(final(:, 1), res(:,1), '.', 'b');
title('Residual of Direction X');
xlabel('Time');
ylabel('Residual (m)');
grid;

subplot(3, 1, 2);
scatter(final(:, 1), res(:,2), '.', 'r');
title('Residual of Direction Y');
xlabel('Time');
ylabel('Residual (m)');
grid;

subplot(3, 1, 3);
scatter(final(:, 1), res(:,3), '.', 'k');
title('Residual of Direction Z');
xlabel('Time');
ylabel('Residual (m)');
grid;

saveas(gcf, [PathNameOutput, '\residual.png']);

%% ========== Load .OUT Data ========== %%
RawData_OUT = [];
for i = 1: numel(FileList_OUT)
    file_OUT = readmatrix([FileList_OUT(i).folder,'\',FileList_OUT(i).name],'FileType','text','ConsecutiveDelimitersRule','join','Range',[num2str(final(i,5)),':',num2str(final(i,6))]);
    subplot(1, 1, 1);
    scatter(file_OUT(:,3),file_OUT(:,5));
    title(['Correlation of ', num2str(final(i,1))]);
    xlabel('Time');
    ylabel('Correlation (m)');
    grid;

    saveas(gcf, [PathNameOutput,'\correlation_',num2str(final(i,1)),'.png']);
end

%% ========== Station Clock ========== %%





