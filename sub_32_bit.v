`timescale 1ns / 1ps

module SUB(input wire [31:0] Ra, input wire [31:0] Rb, input wire cin, output wire [31:0] sum, output wire cout);
	wire [31:0] temp; 
	negate_32_bit neg(.Ra(Rb),.Rz(temp));
	add_32_bit add(.Ra(Ra), .Rb(temp),.cin(cin),.sum(sum),.cout(cout));
endmodule
