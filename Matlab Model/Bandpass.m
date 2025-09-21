function h_ideal = Bandpass(f_l, f_u, f_s, N)
    % f_l: Tần số cắt dưới
    % f_u: Tần số cắt trên
    % f_s: Tần số lấy mẫu
    % N: Số lượng hệ số bộ lọc

    % Tính toán tần số góc
    wc_l = 2 * pi * f_l / f_s; % Tần số góc dưới
    wc_u = 2 * pi * f_u / f_s; % Tần số góc trên

    % Xác định trung tâm
    n = 0:N-1;
    n_center = (N-1) / 2;

    % Khởi tạo mảng h_ideal
    h_ideal = zeros(1, N);

    % Tính toán hệ số
    for i = 1:N
        if n(i) == n_center
            % Trường hợp n = n_center
            h_ideal(i) = (wc_u - wc_l) / pi;
        else
            % Trường hợp n ≠ n_center
            h_ideal(i) = (sin(wc_u * (n(i) - n_center)) - sin(wc_l * (n(i) - n_center))) / ...
                          (pi * (n(i) - n_center));
        end
    end
end
