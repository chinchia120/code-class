function CA = helperCAGenerator(PRN, G1, G2)

% ===== Initial Value
CA = zeros(1, 1023);

% ===== C/A Code Generate
for i = 1: 1023
    CA(i) = helperXOR([G1(10) G2(PRN(1)) G2(PRN(2))]);

    G1 = [helperXOR([G1(3) G1(10)]) G1(1: 9)];
    G2 = [helperXOR([G2(2) G2(3) G2(6) G2(8) G2(9) G2(10)]) G2(1: 9)];
end

end

