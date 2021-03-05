`timescale 1ns/10ps

module mux_3_to_1 (
	input wire [31:0] input0,
	input wire [31:0] input1,
	input wire [31:0] input2,
	
	input wire [2:0] sig,
	output reg [31:0] out
);

always@(*)begin
		if (sig==0) 
			out[31:0] <= input0[31:0];
		
		else if (sig==1)
			out[31:0] <= input1[31:0];
		else if (sig==2)
			out[31:0] <= input2[31:0];	
	end

endmodule