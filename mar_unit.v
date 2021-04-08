`timescale 1ns / 1ps

module mar_unit(
	input wire clk, 
	input wire rst,
	input wire MARin,
	input wire [31:0] bus_contents,
	output [8:0] q
);
		
	wire [31:0] MAR_data_out;
	
	reg_32_bits MAR(clk, rst, MARin, bus_contents, MAR_data_out);
	
	assign q = MAR_data_out[8:0];
	
endmodule

