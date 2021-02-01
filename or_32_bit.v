`timescale 1ns / 1ps

module or_32_bit(
	input wire [31:0] RegA,
	input wire [31:0] RegB,
	output wire [31:0] RegZ
	);
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin : loop
			assign RegZ[i] = ((RegA[i])|(RegB[i]));
		end
	endgenerate
endmodule
