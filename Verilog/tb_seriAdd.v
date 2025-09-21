`timescale 1ns / 1ps

module tb_seriAdd;

    // Khai báo tín hiệu đầu vào và đầu ra
    reg clk;
    reg RstN;
    reg Ci;
    reg A;
    reg B;
    wire S;
    wire Co;

    // Khai báo các tín hiệu trong testbench
    reg [10:0] stimulus; // Lưu giá trị tín hiệu test cho A, B, Ci

    // Cấu trúc của module seriAdd
    seriAdd uut (
        .clk(clk),
        .RstN(RstN),
        .Ci(Ci),
        .A(A),
        .B(B),
        .S(S),
        .Co(Co)
    );

    // Tạo xung clock
    always begin
        #5 clk = ~clk;  // Tạo xung đồng hồ 100MHz (5ns cho 1 chu kỳ)
    end

    // Khởi tạo tín hiệu đầu vào
    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        RstN = 0;   // Reset ban đầu
        Ci = 0;     // Carry in ban đầu
        A = 0;
        B = 0;
        
        #10 RstN = 0; 
        #5 RstN = 1;
        
        // Thử nghiệm cộng dồn
        stimulus = 11'b000_000_00001; // A = 0, B = 1, Ci = 0
        {A, B, Ci} = stimulus[2:0];
        #10; // Chờ 10ns
        
        stimulus = 11'b000_000_00011; // A = 1, B = 1, Ci = 0
        {A, B, Ci} = stimulus[2:0];
        #10; // Chờ 10ns
        
        stimulus = 11'b000_000_00101; // A = 1, B = 0, Ci = 1
        {A, B, Ci} = stimulus[2:0];
        #10; // Chờ 10ns
        
        stimulus = 11'b000_000_01101; // A = 1, B = 1, Ci = 1
        {A, B, Ci} = stimulus[2:0];
        #10; // Chờ 10ns

        stimulus = 11'b000_000_11111; // Test hết khả năng (max input)
        {A, B, Ci} = stimulus[2:0];
        #10; // Chờ 10ns

        // Kết thúc testbench
        $stop;
    end

    // Quan sát các tín hiệu đầu ra
    initial begin
        $monitor("At time %t, A = %b, B = %b, Ci = %b, S = %b, Co = %b", $time, A, B, Ci, S, Co);
    end

endmodule
