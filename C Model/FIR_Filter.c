#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
// Hàm lọc FIR sau khi chuyển sang fixed-point 8bit
void Loc_FIR_fixed(int8_t *x, int8_t *h, int L, int N, int16_t *y) {
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
void write_data(const char *filename, int8_t *data, int data_len) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Không thể tạo hoặc mở file %s.\n", filename);
        return;
    }

    // Ghi dữ liệu vào file
    for (int i = 0; i < data_len; i++) {
        fprintf(file, "%.d\n", data[i]);
    }

    fclose(file);
    printf("Kết quả đã được ghi vào file %s.\n", filename);
}

int8_t float_to_fixed_8bit(float x, int frac_bits) {
    // Tính toán hệ số tỷ lệ
    float scale = (float)pow(2, frac_bits) ; //(1 << frac_bits);
    
    // Chuyển đổi giá trị floating point sang giá trị fixed point
    int16_t fixed_point = (int16_t)round(x * scale);
    
    // Giới hạn giá trị trong phạm vi của fixed point 8-bit
   // Kiểu dữ liệu int8_t trong stdint.h, INT8_MAX = 127, INT8_MIN = -128;
    if (fixed_point > INT8_MAX) {
        fixed_point = INT8_MAX;
    } else if (fixed_point < INT8_MIN) {
        fixed_point = INT8_MIN;
    }
    return (int8_t)fixed_point;
}

int8_t fixed16_to_fixed8(int16_t value, int frac_bits) {
    // Dịch bit để điều chỉnh phần phân số
    int16_t adjusted_value = round(value >> frac_bits) ;

    // Giới hạn giá trị trong phạm vi của int8_t (-128 đến 127)
    if (adjusted_value > 127) {
        adjusted_value = 127;
    } else if (adjusted_value < -128) {
        adjusted_value = -128;
    }

    return (int8_t)adjusted_value;
}

int main() {
    float *x, *h;  //Các giá trị mẫu và hệ số lọc floating-point ban đầu 
    int8_t *x_fixed, *h_fixed, *y_result ;  //Các giá trị mẫu, hệ số lọc và kết quả lọc 8 bit
    int16_t *y_generate ;   //Giá trị tạo ra tức thời khi nhân 8bit với 8bit
    int L, N ;
 
    // Đọc dữ liệu từ file x và h
    L = read_data("D:\\KLTN\\Code\\filter_data.txt", &x);
    if (L == -1) {
        return 1; // Đã có lỗi xảy ra
    }

    N = read_data("D:\\KLTN\\Code\\filter_coeff.txt", &h);
    if (N == -1) {
        free(x);
        return 1; // Đã có lỗi xảy ra
    }
 // Cấp phát bộ nhớ cho mảng x_fixed và h_fixed
    x_fixed = (int8_t *)malloc(L * sizeof(int8_t));
    if (x_fixed == NULL) {
        printf("Không thể cấp phát bộ nhớ cho x_fixed.\n");
        free(x);
        free(h);
        return 1;
    }

    h_fixed = (int8_t *)malloc(N * sizeof(int8_t));
    if (h_fixed == NULL) {
        printf("Không thể cấp phát bộ nhớ cho h_fixed.\n");
        free(x);
        free(h);
        free(x_fixed);
        return 1;
    }

    // Chuyển đổi dữ liệu từ floating point sang fixed point
    for (int i = 0; i < L; i++) {
        x_fixed[i] = float_to_fixed_8bit(x[i], 7);
        printf("x[%d] = %d\n", i, x_fixed[i]);
    }
    for (int i = 0; i < N; i++) {
        h_fixed[i] = float_to_fixed_8bit(h[i], 8);
         printf("h[%d] = %d\n", i, h_fixed[i]);
    }

    // Cấp phát bộ nhớ cho mảng kết quả cuối cùng  và các giá trị 16bit được tạo ra
    y_result = (int8_t *)malloc(L * sizeof(int8_t));
    if (y_result == NULL) {
        printf("Không thể cấp phát bộ nhớ cho y_fixed.\n");
        free(x);
        free(h);
        free(x_fixed);
        free(h_fixed);
        return 1;
    }

    y_generate = (int16_t *)malloc(L * sizeof(int16_t));
    if (y_generate == NULL) {
        printf("Không thể cấp phát bộ nhớ cho y_intermediate.\n");
        free(x);
        free(h);
        free(x_fixed);
        free(h_fixed);
        free(y_result);
        return 1;
    }

    // Thực hiện lọc FIR với x_fixed và h_fixed
    Loc_FIR_fixed(x_fixed, h_fixed, L, N, y_generate);

    // Chuyển đổi kết quả trung gian về lại 8-bit fixed point
    for (int i = 0; i < L; i++) {
        y_result[i] = fixed16_to_fixed8(y_generate[i], 8);
        }
    write_data("D:\\KLTN\\Code\\Result.txt", y_result, L);
    // Giải phóng bộ nhớ
    free(x);
    free(h);
    free(x_fixed);
    free(h_fixed);
    free(y_result);
    free(y_generate);

    return 0;

}
//Run command in Terminal : gcc FIR_filter.c -o main