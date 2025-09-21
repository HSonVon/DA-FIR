module SDA8FIR(
    input clk,
    input RstN,
    input signed [7:0] X,
    output reg signed [15:0] Yn
);

    wire [7:0] s, Co;
    reg [7:0] Ci;
    reg [3:0] b;
    reg signed [7:0] lut1 [0:15];
    reg signed [7:0] lut2 [0:15];
    reg signed [15:0] y_tmp;
    reg signed [7:0] val;
    reg [143:0] ram;
    reg rst_done;

    seriAdd add0 (.clk(clk), .RstN(RstN), .Ci(Ci[0]), .A(ram[143 - b]), .B(ram[8 - b]), .S(s[0]), .Co(Co[0]));
    seriAdd add1 (.clk(clk), .RstN(RstN), .Ci(Ci[1]), .A(ram[134 - b]), .B(ram[17 - b]), .S(s[1]), .Co(Co[1]));
    seriAdd add2 (.clk(clk), .RstN(RstN), .Ci(Ci[2]), .A(ram[125 - b]), .B(ram[26 - b]), .S(s[2]), .Co(Co[2]));
    seriAdd add3 (.clk(clk), .RstN(RstN), .Ci(Ci[3]), .A(ram[116 - b]), .B(ram[35 - b]), .S(s[3]), .Co(Co[3]));
    seriAdd add4 (.clk(clk), .RstN(RstN), .Ci(Ci[4]), .A(ram[107 - b]), .B(ram[44 - b]), .S(s[4]), .Co(Co[4]));
    seriAdd add5 (.clk(clk), .RstN(RstN), .Ci(Ci[5]), .A(ram[98 - b]), .B(ram[53 - b]), .S(s[5]), .Co(Co[5]));
    seriAdd add6 (.clk(clk), .RstN(RstN), .Ci(Ci[6]), .A(ram[89 - b]), .B(ram[62 - b]), .S(s[6]), .Co(Co[6]));
    seriAdd add7 (.clk(clk), .RstN(RstN), .Ci(Ci[7]), .A(ram[80 - b]), .B(ram[71 - b]), .S(s[7]), .Co(Co[7]));

    //assign Yn = yn;

    // Tính toán giá trị `val` ngay khi `sum` thay đổi
    always @* begin
        val = lut1[s[3:0]] + lut2[s[7:4]];
    end

    always @(posedge clk or negedge RstN) begin
        if (!RstN) begin
            lut1[0] <= 8'd0;   lut1[1] <= -8'd1;  lut1[2] <= -8'd1;  lut1[3] <= -8'd2;
            lut1[4] <= 8'd0;   lut1[5] <= -8'd1;  lut1[6] <= -8'd1;  lut1[7] <= -8'd2;
            lut1[8] <= 8'd4;   lut1[9] <= 8'd3;   lut1[10] <= 8'd3;  lut1[11] <= 8'd2;
            lut1[12] <= 8'd4;  lut1[13] <= 8'd3;  lut1[14] <= 8'd3;  lut1[15] <= 8'd2;

            lut2[0] <= 8'd0;   lut2[1] <= 8'd13;  lut2[2] <= 8'd25;  lut2[3] <= 8'd38;
            lut2[4] <= 8'd37;  lut2[5] <= 8'd50;  lut2[6] <= 8'd62;  lut2[7] <= 8'd75;
            lut2[8] <= 8'd45;  lut2[9] <= 8'd58;  lut2[10] <= 8'd70; lut2[11] <= 8'd83;
            lut2[12] <= 8'd82; lut2[13] <= 8'd95; lut2[14] <= 8'd107;lut2[15] <= 8'd120;

            Yn <= 16'b0;
				y_tmp <= 16'b0;
            b <= 4'b0;
            ram <= 144'b0;
            Ci <= 8'b0;
            rst_done <= 1'b0;
        end else if (!rst_done) begin
            b <= 4'b0;
            rst_done <= 1'b1;
        end else begin
            ram[143:135] <= {X[0], X[1], X[2], X[3], X[4], X[5], X[6], X[7], X[7]};
            if (b == 1'b0) begin
                y_tmp <= y_tmp + val;
                b <= b + 1'b1;
            end else if (b == 4'd8) begin
                y_tmp = y_tmp - (val << b);
                b <= 4'b0;
                ram[134:0] <= ram[143:9];
                Ci <= 8'b0;
                Yn = y_tmp;
					 y_tmp <= 16'b0;
            end else begin
                y_tmp <= y_tmp + (val << b);
                b <= b + 1'b1;
                Ci <= Co;
            end
        end
    end
endmodule
