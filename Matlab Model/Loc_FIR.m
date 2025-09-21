function y = Loc_FIR(x, h)
    % Hàm lọc FIR
    % x: Tín hiệu đầu vào
    % h: Hệ số bộ lọc
    % L: Chiều dài tín hiệu đầu vào
    % N: Số hệ số bộ lọc
    % y: Tín hiệu đầu ra

    % Khởi tạo tín hiệu đầu ra y với các giá trị bằng 0
    N = length(h) ;
    L = length(x) ;
    y = zeros(1, L);
    
    % Thực hiện lọc FIR
    for n = 1:L
        for k = 1:N
            if (n - k + 1) > 0 && (n - k + 1) <= L
                y(n) = y(n) + h(k) * x(n - k + 1);
            end
        end
    end
end