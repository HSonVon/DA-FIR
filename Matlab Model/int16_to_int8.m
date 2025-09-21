function int8_val = int16_to_int8(int16_val, scale_bits)
    % Chuyển đổi số nguyên 16-bit có dấu sang số nguyên 8-bit có dấu với tỷ lệ
    % int16_val: giá trị 16-bit cần chuyển đổi
    % scale_factor: hệ số tỷ lệ để phù hợp với phạm vi 8-bit
    
    % Tính giá trị 8-bit bằng cách chia cho hệ số tỷ lệ và làm tròn
    int8_val = round(int16_val / 2^scale_bits);
    
    % Giới hạn giá trị trong phạm vi của số nguyên 8-bit có dấu
    max_val = 127;
    min_val = -128;
    int8_val = min(max(int8_val, min_val), max_val);
end
