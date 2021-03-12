`timescale 1ns / 1ps

module IncPC_32_bit #(parameter qInitial = 0)(
	input clk, IncPC, enable,
	input [31:0] inputPC,
	output reg[31:0] newPC
	);
	
initial newPC = qInitial;
	
always @ (posedge clk)
	begin
		if(IncPC == 1 && enable ==1)
			newPC <= newPC + 1;
		else if (enable == 1)
			newPC <= inputPC;
	end
				
endmodule
