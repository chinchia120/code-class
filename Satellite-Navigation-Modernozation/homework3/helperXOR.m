function numxor = helperXOR(num)

% ===== Initial Value
numxor = num(1);

% ===== XOR Operator
for i = 2: length(num)
    numxor = xor(numxor, num(i));
end

end

