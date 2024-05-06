%% ========== Setup ========== %%
clc;
clear all;

%% ========== GPU Information ========== %%
d = gpuDeviceCount;
g = gpuDevice;

%% ========== GPU Step ========== %%
a=rand(100, 10000);
b=rand(100, 10000)';
tic
c=a*b;
fprintf('CPU time = %g sec\n', toc);
A=gpuArray(a);		% Put a to GPU's memory
B=gpuArray(b);		% Put b to GPU's memory
tic
C=A*B;				% Multiplication via GPU
fprintf('GPU time = %g sec\n', toc);
c2=gather(C);		% Put C to MATLAB's workspace
fprintf('isequal(c, c2) = %g\n', isequal(c, c2));
fprintf('Mean deviation = %g\n', mean(mean(abs(c-c2))));

%% ========== GPU Speedup ========== %%
fprintf('computer = %s\n', computer);
fprintf('version = %s\n', version);
% Speed test
step=10000;
colCounts=step*(1:1:20);
for i=1:length(colCounts)
	fprintf('%d/%d\n', i, length(colCounts));
	n=colCounts(i);
	a=rand(100, n);
	b=rand(100, n)';
	myTic=tic; c=a*b; cpuTime(i)=toc(myTic);
	A=gpuArray(a);
	B=gpuArray(b);
	myTic=tic; C=A*B; gpuTime(i)=toc(myTic);
end
subplot(211); plot(colCounts, cpuTime, '.-', colCounts, gpuTime, '.-');
legend('CPU time', 'GPU time', 'location', 'northwest');
title('CPU & GPU time');
ylabel('Time (sec)');
subplot(212); plot(colCounts, cpuTime./gpuTime, 'o-');
title('GPU speedup ratio');
ylabel('Ratios');
xlabel('No. of columns');