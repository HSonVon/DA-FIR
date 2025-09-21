`timescale 1ns/1ps

module MAC8FIR_tb;

    reg clk;
    reg RstN;
    reg signed [7:0] X;
    wire signed [15:0] Yn;
	 wire signed [8:0] Sn;

    integer file, scan, i;
    reg signed [7:0] input_data [0:175]; 

    MAC8FIR uut (
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
            #20; 
        end

        $stop;
    end
/*
    initial begin
        $monitor($time, " clk=%b, RstN=%b, X=%d, Yn=%d", clk, RstN, X, Yn);
    end
*/
endmodule
