function h_ideal = Lowpass(f_c, f_s, N)
    % Tần số cắt chuẩn hóa
    wc = 2 * pi * f_c / f_s;
    % Tạo chỉ số mẫu
    n = 0:N-1;
    n_center = (N-1) / 2;
    % Tính toán các hệ số lý tưởng (sử dụng hàm sinc)
    h_ideal = wc / pi * sinc((n - n_center) * wc / pi);
end