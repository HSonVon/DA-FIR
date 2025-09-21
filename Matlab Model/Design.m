clc ; clear; close all;
% Thông số tín hiệu 
Fs = 80000; % Tần số lấy mẫu 80 kHz
t = 0:1/Fs:150/Fs;  
x1 =  sin(2 * pi * 1000 * t) ;
x2 =  sin(2 * pi * 10000 * t);
Xn = x1 + x2 ;
bn = ones(1,16)/16 ;
Yn = Loc_FIR(Xn, bn) ; 
% Vẽ đáp ứng tần số của bộ lọc
[H, W] = freqz(bn, 1, 8000, Fs);
figure(1);
plot(W, 20*log10(abs(H)), 'b');
title('Đáp ứng tần số của bộ lọc FIR thông thấp');
xlabel('Tần số (Hz)');
ylabel('Độ lợi (dB)');
grid on;

% Vẽ tín hiệu trước và sau khi lọc
figure(2);
subplot(2, 1, 1);
plot(t, Xn);
title('Tín hiệu gốc');
xlabel('Thời gian (s)');
ylabel('Biên độ');

subplot(2, 1, 2);
plot(t, Yn, 'r');
title('Tín hiệu sau khi lọc');
xlabel('Thời gian (s)');
ylabel('Biên độ');
dlmwrite('D:\KLTN\Code\filter_data.txt', Xn, 'delimiter', '\n');
dlmwrite('D:\KLTN\Code\filter_coeff.txt', bn, 'delimiter', '\n');
fclose(fopen('G:\KLTN\Code\Result.txt', 'w'));
