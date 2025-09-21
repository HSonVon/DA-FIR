#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <limits.h>
// Hàm lọc FIR
void Loc_FIR(float *x, float *h, int L, int N, float *y) {
    for (int n = 0; n < L; n++) {
        y[n] = 0.0;
        for (int k = 0; k < N; k++) {
            if ((n - k + 1) >= 0 && (n - k + 1) < L) {
                y[n] += h[k] * x[n - k];
            }
        }
    }
}

// Hàm để đọc dữ liệu từ file và trả về số lượng dữ liệu đã đọc
int read_data(const char *filename, float **data) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Không thể mở file %s.\n", filename);
        return -1;
    }

    // Đếm số lượng dữ liệu trong file để cấp phát bộ nhớ động
    int data_len = 0;
    while (fscanf(file, "%f", &(float){0}) != EOF) {
        data_len++;
    }
    fseek(file, 0, SEEK_SET); // Đưa con trỏ file về đầu file
    *data = (float *)malloc(data_len * sizeof(float)); // Cấp phát bộ nhớ động
    if (*data == NULL) {
        printf("Không thể cấp phát bộ nhớ cho dữ liệu.\n");
        fclose(file);
        return -1;
    }

    // Đọc dữ liệu từ file vào mảng
    for (int i = 0; i < data_len; i++) {
        fscanf(file, "%f", &(*data)[i]);
    }
    fclose(file);

    return data_len; // Trả về số lượng dữ liệu đã đọc
}
void write_data(const char *filename, float *data, int data_len) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Không thể tạo hoặc mở file %s.\n", filename);
        return;
    }

    // Ghi dữ liệu vào file
    for (int i = 0; i < data_len; i++) {
        fprintf(file, "%.4f\n", data[i]);
    }

    fclose(file);
    printf("Kết quả đã được ghi vào file %s.\n", filename);
}

int main() {
    float *x, *h, *y;
    int L, N;

    // Đọc dữ liệu từ file x và h
    L = read_data("G:\\KLTN\\Code\\filter_data.txt", &x);
    if (L == -1) {
        return 1; // Đã có lỗi xảy ra
    }

    N = read_data("G:\\KLTN\\Code\\filter_coeff.txt", &h);
    if (N == -1) {
        free(x);
        return 1; // Đã có lỗi xảy ra
    }

    // Tính toán độ dài của kết quả y
    int y_len = L;

    // Cấp phát bộ nhớ cho mảng y
    y = (float *)malloc(y_len * sizeof(float));
    if (y == NULL) {
        printf("Không thể cấp phát bộ nhớ cho kết quả.\n");
        free(x);
        free(h);
        return 1;
    }

    // Gọi hàm Loc_FIR để thực hiện lọc FIR
    Loc_FIR(x, h, L, N, y);

    // Ghi kết quả vào file
    write_data("G:\\KLTN\\Code\\Result.txt", y, y_len);

    // Giải phóng bộ nhớ đã cấp phát
    free(x);
    free(h);
    free(y);

    return 0;
}
//Run command in Terminal : gcc FIR_filter.c -o main#include <stdio.h>
