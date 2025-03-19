%% Newton's method
function [point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient, f_hessian, point, epsilon, max_iter,up,low)

tic;
loss = [];
points_array = [];
values_array = [];
points_array = cat(1, points_array, point);

%plot_point = zeros(0, 2); % for plot result
p = num2cell(point);
before = f(p{:}); % initial function value
values_array = cat(1, values_array, double(before));

for iter=1:max_iter
    if (iter == max_iter)
        % when reach to end of loop, evoke error
        error('Newton''s method failed!');
    end
    p = num2cell(point);
    hessian_mat = double(f_hessian(p{:}));
    gradient_mat = double(f_gradient(p{:}))';
    
    % check Hessian matrix is positive definite
    [col, eig_diagnol] = eig(double(hessian_mat)); % compute eigenvalue

    % if all eigenvalue > 0 
    if (isempty(find(diag(eig_diagnol) <= 0, 1)) == 1)
        hessian_gradient = (inv(hessian_mat) * gradient_mat')';
        point = point - hessian_gradient; % Newton's method update
        point = clip(point,up,low);
    else
        % inexact line search for the given search direction (-gradient)
        step_size = inexact_search(f, point, 0.001, gradient_mat, transpose(-gradient_mat), max_iter,up,low);
        
        hessian_mat = eye(size(hessian_mat, 1), size(hessian_mat, 2));
        hessian_gradient = (inv(hessian_mat) * gradient_mat')';
        point = point - (step_size * hessian_gradient); % Gradient descent update
        point = clip(point,up,low);
    end;
    
    % terminate condition
    p = num2cell(point);
    
    % Point Store
    points_array = cat(1, points_array, point);
    
    current = f(p{:});
    values_array = cat(1, values_array, double(current));
    
    % loss
    loss(iter) = eval(abs(current - before));
    
    if(abs(current - before) <= epsilon)
        break;
    end
    before = current;
end

output = double(current);
time = toc;