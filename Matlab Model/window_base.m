clc ; clear; close all;
% Thông số tín hiệu 
Fs = 50000; % Tần số lấy mẫu 50 kHz
t = 0:1/Fs:3.5e-3;  
x1 =  sin(2 * pi * 1000 * t) ;
x2 =  sin(2 * pi * 10000 * t);
Xn = x1 + x2 ;
f_c = 4500;  % Tần số cắt 5 kHz
N = 16;  % Số lượng mẫu của bộ lọc
hn = Bandpass(3000,6000,Fs,N);
wn = Hamming(N-1) ;
bn = hn .* wn ;
Yn = Loc_FIR(Xn, bn) ;
% Vẽ đáp ứng tần số của bộ lọc
[H, W] = freqz(bn, 1, 8000, Fs);

figure(1);
subplot(3, 1, 1);
plot(t, x1);
title('Tín hiệu 1kHz');
xlabel('Thời gian (s)');
ylabel('Biên độ');

subplot(3, 1, 2);
plot(t, x2, 'r');
title('Tín hiệu 10kHz');
xlabel('Thời gian (s)');
ylabel('Biên độ');

subplot(3, 1, 3);
plot(t, Xn, 'c');
title('Tín hiệu tổng');
xlabel('Thời gian (s)');
ylabel('Biên độ');

% Vẽ tín hiệu trước và sau khi lọc
figure(2);
subplot(2, 1, 1);
plot(t, x1);
title('Tín hiệu gốc');
xlabel('Thời gian (s)');
ylabel('Biên độ');

subplot(2, 1, 2);
plot(t, Yn, 'r');
title('Tín hiệu sau khi lọc');
xlabel('Thời gian (s)');
ylabel('Biên độ');

figure(3);
plot(W, 20*log10(abs(H)), 'b');
title('Đáp ứng tần số của bộ lọc FIR thông thấp');
xlabel('Tần số (Hz)');
ylabel('Độ lợi (dB)');
grid on;

dlmwrite('D:\KLTN\Code\filter_data.txt', Xn, 'delimiter', '\n');
dlmwrite('D:\KLTN\Code\filter_coeff32.txt', bn, 'delimiter', '\n');
fclose(fopen('D:\KLTN\Code\Result.txt', 'w'));