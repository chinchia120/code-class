function caCode = generateCACode(PRN)
    % GPS C/A code generation based on the PRN number
    % Initialize the shift registers
    G1 = ones(1, 10);
    G2 = ones(1, 10);

    % Number of chips in the C/A code
    numChips = 1023;

    % Tap selection for G2 based on PRN number (lookup table)
    G2_taps = [
        2,  6; 3,  7; 4,  8; 5,  9; 1,  9; 2, 10; 1,  8; 2,  9; 3, 10; 2,  3;
        3,  4; 5,  6; 6,  7; 7,  8; 8,  9; 9, 10; 1,  4; 2,  5; 3,  6; 4,  7;
        5,  8; 6,  9; 1,  3; 4,  6; 5,  7; 6,  8; 7,  9; 8, 10; 1,  6; 2,  7;
        3,  8; 4,  9];

    % Pre-allocate the C/A code array
    caCode = zeros(1, numChips);

    for i = 1:numChips
        % Output of G1
        caCode(i) = G1(end);

        % Feedback for G1 (XOR of bits 3 and 10)
        feedback1 = xor(G1(3), G1(10));

        % Shift G1
        G1 = [feedback1, G1(1:end-1)];

        % Feedback for G2 (XOR of taps specified by PRN)
        feedback2 = xor(G2(G2_taps(PRN, 1)), G2(G2_taps(PRN, 2)));

        % Shift G2
        G2 = [feedback2, G2(1:end-1)];

        % Combine G1 and G2 to form the C/A code
        caCode(i) = xor(caCode(i), G2(end));
    end

    % Convert to bipolar (+1, -1)
    caCode = 2 * caCode - 1;
end