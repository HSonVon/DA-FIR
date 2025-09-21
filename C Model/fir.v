parameter N = 16;
parameter W = 8;
parameter H = 8;

module fir_filter(input clock,
		  input signed [W:0] Xin,
		  output reg signed [W+N-1:0] Y);


	reg signed [H:0] h[N];
	reg signed [W+H+N-1:0] y[N];


	assign h[0] = 0;
	assign h[1] = 0;
	assign h[2] = 3;
	assign h[3] = 0;
	assign h[4] = -15;
	assign h[5] = 0;
	assign h[6] = 73;
	assign h[7] = 126;
	assign h[8] = 80;
	assign h[9] = 0;
	assign h[10] = -20;
	assign h[11] = 0;
	assign h[12] = 6;
	assign h[13] = 0;
	assign h[14] = -1;
	assign h[15] = 0;

	assign Y = y[N-1]>>H;

	always@ (posedge clock) begin
	  y[0] <= h[0]*Xin;
	  for(int i = 0; i < N; i++)
	    y[i] <= y[i-1]+h[N-i-1]*Xin;
	end

endmodule