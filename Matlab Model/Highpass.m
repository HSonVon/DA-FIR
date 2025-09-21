function h_ideal = Highpass(f_c, f_s, N)
    wc = 2 * pi * f_c / f_s;
    n = 0:N-1;
    n_center = (N-1) / 2;

    h_ideal = zeros(1, N); % Khởi tạo mảng h_ideal
    for i = 1:N
        if n(i) == n_center
            h_ideal(i) = 1 - wc / pi; 
        else
            h_ideal(i) = -sin(wc * (n(i) - n_center)) / (pi * (n(i) - n_center)); 
        end
    end
end
