module MAC8FIR(
    input clk,
    input RstN,                      
    input signed [7:0] X,                   
    output signed [15:0] Yn                                  
);
    reg signed [7:0] Xn [0:14]; 
    reg signed [15:0] yn;
    assign Yn = yn;
	 
	 localparam signed C0 = -8'd1;
	 localparam signed C1 = -8'd1;
	 localparam signed C2 = 8'd0;
	 localparam signed C3 = 8'd4;
	 localparam signed C4 = 8'd13;
	 localparam signed C5 = 8'd25;
	 localparam signed C6 = 8'd37;
	 localparam signed C7 = 8'd45;
	 
    always @(posedge clk or negedge RstN) begin
        if (!RstN) begin
				Xn[0] <= 8'b0; Xn[1] <= 8'b0; 
				Xn[2] <= 8'b0; Xn[3] <= 8'b0; 
				Xn[4] <= 8'b0; Xn[5] <= 8'b0; 
				Xn[6] <= 8'b0; Xn[7] <= 8'b0; 
				Xn[8] <= 8'b0; Xn[9] <= 8'b0; 
				Xn[10] <= 8'b0; Xn[11] <= 8'b0; 
				Xn[12] <= 8'b0; Xn[13] <= 8'b0; 
				Xn[14] <= 8'b0;  
				yn <= 16'b0;         
        end else begin
				yn = (Xn[6] + Xn[7]) * C7 + (Xn[5] + Xn[8]) * C6 + (Xn[4] + Xn[9]) * C5 +
					  (Xn[3] + Xn[10]) * C4 +(Xn[2] + Xn[11]) * C3 + (Xn[1] + Xn[12]) * C2 +
					  (Xn[0] + Xn[13]) * C1 + (X + Xn[14]) * C0 ;
				Xn[14] = Xn[13]; 
				Xn[13] = Xn[12]; 
				Xn[12] = Xn[11]; 
				Xn[11] = Xn[10]; 
				Xn[10] = Xn[9]; 
				Xn[9] = Xn[8]; 
				Xn[8] = Xn[7]; 
				Xn[7] = Xn[6];
				Xn[6] = Xn[5]; 	
				Xn[5] = Xn[4]; 
				Xn[4] = Xn[3]; 
				Xn[3] = Xn[2];  
				Xn[2] = Xn[1]; 
				Xn[1] = Xn[0]; 
				Xn[0] = X;	
		end        
	end
endmodule

