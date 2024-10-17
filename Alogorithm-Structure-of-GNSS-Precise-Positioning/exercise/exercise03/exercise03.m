%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Create File
file = fopen('exercise03_output.txt', 'w');
fprintf(file, '%%%% ========== Exercise 3 ========== %%%%\n');

% ===== Initial Value
syms x y;

F1 = [x + y;        % 0
      x - y;        % 0
      3*x;          % 2.5
      10*x + y;     % 13
      x - 2*y];     % -0.5

F2 = [4*y;          % 3.5
      9*x - 2*y];   % 6

F3 = [5*x + 0.5*y;  % 5
      -x - y];      % -2

A1 = [diff(F1(1), x, 1) diff(F1(1), y, 1);
      diff(F1(2), x, 1) diff(F1(2), y, 1);
      diff(F1(3), x, 1) diff(F1(3), y, 1);
      diff(F1(4), x, 1) diff(F1(4), y, 1);
      diff(F1(5), x, 1) diff(F1(5), y, 1)];

A2 = [diff(F2(1), x, 1) diff(F2(1), y, 1);
      diff(F2(2), x, 1) diff(F2(2), y, 1)];

A3 = [diff(F3(1), x, 1) diff(F3(1), y, 1);
      diff(F3(2), x, 1) diff(F3(2), y, 1)];

L1 = [0.0; 0.0; 2.5; 13; -0.5];
L2 = [3.5; 6];
L3 = [5.0; -2];

P1 = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2]);
P2 = diag([1/0.5^2, 1/1.0^2]);
P3 = diag([1/0.5^2, 1/0.3^2]);

Fcond1 = [x; y];
Acond1 = [diff(Fcond1(1), x, 1) diff(Fcond1(1), y, 1)
          diff(Fcond1(2), x, 1) diff(Fcond1(2), y, 1)];
Lcond1 = [0; 0];
Pcond1 = diag([1/0.00001^2, 1/0.00001^2]);

Fcond2 = [x; y];
Acond2 = [diff(Fcond2(1), x, 1) diff(Fcond2(1), y, 1)
          diff(Fcond2(2), x, 1) diff(Fcond2(2), y, 1)];
Lcond2 = [10; 0];
Pcond2 = diag([1/0.00001^2, 1/0.00001^2]);

%% ========== Question 1 ========== %%
N1 = A1'*P1*A1;
N2 = A2'*P2*A2;
N3 = A3'*P3*A3;

X = vpa((N1+N2+N3)\(A1'*P1*L1 + A2'*P2*L2 + A3'*P3*L3));

A = [A1; A2; A3];
L = [L1; L2; L3];
P = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2, 1/0.5^2, 1/1.0^2, 1/0.5^2, 1/0.3^2]);
V = L-A*X;
var1 = V'*P*V;

fprintf(file, '%% ===== Question 1 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', X(1));
fprintf(file, 'y = %.10f (m)\n', X(2));
fprintf(file, 'var = %.10f (m)\n\n', var1);

%% ========== Question 2 ========== %%
Ncond1 = Acond1'*Pcond1*Acond1;
Xcond1 = vpa((N1+N2+N3+Ncond1)\(A1'*P1*L1 + A2'*P2*L2 + A3'*P3*L3 + Acond1'*Pcond1*Lcond1));

L = [L1; L2; L3; Lcond1];
A = [A1; A2; A3; Acond1];
P = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2, 1/0.5^2, 1/1.0^2, 1/0.5^2, 1/0.3^2, 1/0.00001^2, 1/0.00001^2]);
Vcond1 = L-A*Xcond1;

var2 = Vcond1'*P*Vcond1;

fprintf(file, '%% ===== Question 2 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', Xcond1(1));
fprintf(file, 'y = %.10f (m)\n', Xcond1(2));
fprintf(file, 'var = %.10f (m)\n\n', var2);

%% ========== Question 3 ========== %%
Ncond2 = Acond2'*Pcond2*Acond2;
Xcond2 = vpa((N1+N2+N3+Ncond2)\(A1'*P1*L1 + A2'*P2*L2 + A3'*P3*L3 + Acond2'*Pcond2*Lcond2));

L = [L1; L2; L3; Lcond2];
A = [A1; A2; A3; Acond2];
P = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2, 1/0.5^2, 1/1.0^2, 1/0.5^2, 1/0.3^2, 1/0.00001^2, 1/0.00001^2]);
Vcond2 = L-A*Xcond2;

var3 = Vcond2'*P*Vcond2;

fprintf(file, '%% ===== Question 3 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', Xcond2(1));
fprintf(file, 'y = %.10f (m)\n', Xcond2(2));
fprintf(file, 'var = %.10f (m)\n\n', var3);

fprintf(file, '%% ===== Analysis ===== %%\n');
fprintf(file, ['In the Question 2 and Question 3, they have constrain conditions in x and y. Both of\n' ...
               'the conditions have very large weighted. Thus, the variable x and y are almost equal\n' ...
               'to the condition, as the answer shown in Question 2 and 3. In the variances, Question 3\n' ...
               'is many times bigger than Question 2, because constrain condition isn''t reasonable in\n' ...
               'Question 3. If fixed the variables, the equation will present large error in this case.']);

fclose(file);