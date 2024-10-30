function [x_, y_] = LSE_ra(A, X, L, var, init, file)

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

    X_ = double(subs(X, [x y], [x_ y_]));
    if X_(2) < 0; X_(2) = X_(2) + 2*pi; end
    
    W = L - X_;
    A_ = double(subs(A, [x y], [x_ y_]));
    d = (A_'*A_)\A_'*W;
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;

    if max(abs(d)) < 10^-6; break; end
end

x_ = double(x_);
y_ = double(y_);

end

