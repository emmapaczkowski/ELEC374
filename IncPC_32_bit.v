`timescale 1ns / 1ps

module IncPC_32_bit(
	input [31:0] PCin,
	input  IncPC,
	output wire[31:0] PCnew
	);
	
	assign PCnew = PCin + 1;
				
endmodule
