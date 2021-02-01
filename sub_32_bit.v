`timescale 1ns / 1ps

module sub_32_bit(input wire [31:0] Ra, input wire [31:0] Rb, input wire cin, output wire [31:0] sum, output wire cout);
	wire [31:0] tempValue; 
	negate_32_bit negate(.Ra(Rb),.Rz(tempValue));
	add_32_bit add(.Ra(Ra), .Rb(tempValue),.cin(cin),.sum(sum),.cout(cout));
endmodule
