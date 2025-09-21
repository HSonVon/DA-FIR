module seriAdd(
    input clk, RstN, Ci, A, B,
    output reg S, Co
);

    always @(negedge clk) begin  
        if (!RstN) begin
            {Co, S} = 2'b0;  
        end else begin
            {Co, S} = Ci + A + B; 
        end
    end

endmodule
