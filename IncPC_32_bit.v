`timescale 1ns / 1ps

module IncPC_32_bit(
	input [31:0] inputPC,
	input  IncPC,
	output wire[31:0] newPC
	);
	
	assign newPC = inputPC + 1;
				
endmodule
