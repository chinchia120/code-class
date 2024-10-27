function A = Setup_A(Func, var)

for i = 1: size(Func, 1)
    for j = 1: size(var, 1)
        A(i, j) = diff(Func(i), var(j), 1);
    end
end

end

