function [x_, y_] = LSE_rr(A, W, var, init, file)

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
    
    d = double(subs((A'*A)\A'*W, [x y], [x_ y_]));
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;

    if max(abs(d)) < 10^-6; break; end
    if it > 50; break; end
end

x_ = double(x_);
y_ = double(y_);

end

