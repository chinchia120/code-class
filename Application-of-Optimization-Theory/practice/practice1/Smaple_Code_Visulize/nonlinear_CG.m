%% Nonlinear Conjugate Gradient Method
function [best_point, best_value, time, iter, loss, points_array, values_array] = nonlinear_CG(f, f_exact, f_gradient, point, epsilon, max_iter,up,low)

tic;
loss = [];
points_array = [];
values_array = [];
points_array = cat(1, points_array, point);

v = 0.1; % for orthogonality test
po = num2cell(point);
before = f(po{:}, po{:}); % initial function value
best_value = double(before);
values_array = cat(1, values_array, double(before));

% initial setting
r = zeros(2, length(point));

r(1, :) = double(f_gradient(po{:}, po{:}))';
p = -r(1, :);

for iter=1:max_iter
    if (iter == max_iter)
        % when reach to end of loop, evoke error
        %error('Conjugate gradinet method failed!');
    end
    p1 = num2cell(point);
    gradient = double(f_gradient(p1{:}, p1{:}));
    % inexact line search for the given search direction (-gradient)
    %step_size = 5 * rand(1); % step_size initialization
    %step_size = strong_wolfe_search(f, f_gradient, point, step_size, r(1, :), -r(1, :), max_iter,up,low);
    step_size = inexact_search(f_exact, point, 1/norm(r(1, :))*0.01, gradient, -r(1, :)', max_iter,up,low);
    
    
    % update
    point = point + (step_size * p);
    point = clip(point,up,low);
    
    % terminate condition
    po = num2cell(point);

    % Point Store
    points_array = cat(1, points_array, point);

    current = double(f_exact(po{:}));
    values_array = cat(1, values_array, double(current));

    if (best_value > double(current))
        best_value = double(current);
        best_point = point;
    end

    % loss
    if (strlength(string(abs(current - before)))) > 30
        loss(iter) = eval(abs(current - before));
    else
        loss(iter) = abs(current - before);
    end
    
    if(abs(current - before) <= epsilon)
        break;
    end
    before = current;
    

    % gradient residual
    r(2, :) = double(f_gradient(po{:}, po{:}))';
    
    % orthogonality check and beta update
    if ((r(2, :) * r(1, :)') / (r(2, :) * r(2, :)')) >= v
        b = (r(2, :) * r(2, :)') / (r(1, :) * r(1, :)');
    else
        b = 0;
    end

    % next conjugate direction
    p = -r(2, :) + (b * p);

    % swap
    r(1, :) = r(2, :);
end;

time = toc;