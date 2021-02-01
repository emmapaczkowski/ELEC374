`timescale 1ns / 1ps

module negate_32_bit(
	input wire [31:0] Ra,
	output wire [31:0] Rz
	);
	
	wire [31:0] temp; 
	wire cout;
	not_32_bit not_op(.Ra(Ra),.Rz(temp));
	add_32_bit add_op(.Ra(temp), .Rb(32'd1), .cin(1'd0),.sum(Rz), .cout(cout));
	
endmodule
