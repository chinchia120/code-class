function [] = LSE(A, W, var, init, file)
x = var(1);
y = var(2);

it = 1;
while 1
    if it == 1
        x_ = init(1);
        y_ = init(2);
    end
    
    d = vpa(subs((A'*A)\A'*W, [x y], [x_ y_]));
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;

    if abs(d(1)) < 10^-6 && abs(d(2)) < 10^-6; break; end
end

end

