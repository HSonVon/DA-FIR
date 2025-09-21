function w_hamming = Hamming(N)
    n = (0:N);
    w_hamming = 0.54 - 0.46 * cos(2 * pi * n / N);
end