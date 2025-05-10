function [f_gradient,f_hessian,f_approx,f_gradient_cg] = funcs_2d(f)
    syms x1 x2 a b
    f_gradient = gradient(f); %gradient_descent, newton, quasi_bfgs
    f_hessian = hessian(f, [x1,x2]); %newton method
    f_approx = taylor(f, [x1,x2],[a b],'Order', 2); % taylor expansion of f for quadratic behavior
    f_approx = symfun(f_approx, [x1 x2 a b]);
    f_gradient_cg = gradient(f_approx, [x1 x2]); % nonlinear CG parameter
end