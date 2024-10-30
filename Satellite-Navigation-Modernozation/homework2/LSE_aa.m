function [x_, y_] = LSE_aa(A, X, L, var, init, file)

% ===== Innitial Value
x = var(1);
y = var(2);

% ===== LSE Iteration
it = 1;
while 1
    if it == 1
        x_ = init(1);
        y_ = init(2);
    end

    X = double(subs(X, [x y], [x_ y_]));
    if X(1) < 0; X(1) = X(1) + 2*pi; end
    if X(2) < 0; X(2) = X(2) + 2*pi; end
    
    W = L - X;
    A = double(subs(A, [x y], [x_ y_]));
    d = (A'*A)\A'*W;
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;

    if abs(d(1)) < 10^-6 && abs(d(2)) < 10^-6; break; end
    if it > 30; break; end
end

x_ = double(x_);
y_ = double(y_);

end

