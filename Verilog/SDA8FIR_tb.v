`timescale 1us/1us

module SDA8FIR_tb;

    reg clk;
    reg RstN;
    reg signed [7:0] X;
    wire signed [15:0] Yn;
    integer file, scan, i;
    reg signed [7:0] input_data [0:175]; 
    reg [31:0] timestamp [0:175];
    reg signed [15:0] out_val [0:175];

    SDA8FIR uut (
        .clk(clk),
        .RstN(RstN),
        .X(X),
        .Yn(Yn)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    initial begin
        file = $fopen("D:/KLTN/Code/filter_int8.txt", "r");
        if (file == 0) begin
            $display("Error: Cannot open file\n");
            $stop;
        end

        i = 0;
        while (!$feof(file)) begin
            scan = $fscanf(file, "%d\n", input_data[i]);
            i = i + 1;
        end
        $fclose(file);
    end

    initial begin
        RstN = 0;
        X = 0;
        #50; 
        RstN = 1;
        for (i = 0; i < 176; i = i + 1) begin
            X = input_data[i];
            #180;
            out_val[i] = Yn;
            timestamp[i] = $time;
        end

        $stop;
    end

endmodule

