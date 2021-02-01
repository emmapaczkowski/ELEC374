`timescale 1ns / 1ps

module add_32_bit(input [31:0] Ra, input [31:0] Rb, input wire cin, output wire[31:0] sum, output wire cout);
wire cout1;

CLA16 CLA1(.Ra(Ra[15:0]), .Rb(Rb[15:0]), .cin(cin), .sum(sum[15:0]), .cout(cout1));
CLA16 CLA2(.Ra(Ra[31:16]), .Rb(Rb[31:16]), .cin(cout1), .sum(sum[31:16]), .cout(cout));

endmodule

module CLA16(input wire [15:0] Ra, input wire [15:0] Rb, input wire cin, output wire [15:0] sum, output wire cout);
wire cout1,cout2,cout3;

CLA4 CLA1(.Ra(Ra[3:0]), .Rb(Rb[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout1));
CLA4 CLA2(.Ra(Ra[7:4]), .Rb(Rb[7:4]), .cin(cout1), .sum(sum[7:4]), .cout(cout2));				
CLA4 CLA3(.Ra(Ra[11:8]), .Rb(Rb[11:8]), .cin(co==ut2), .sum(sum[11:8]), .cout(cout3));
CLA4 CLA4(.Ra(Ra[15:12]), .Rb(Rb[15:12]), .cin(cout3), .sum(sum[15:12]), .cout(cout));

endmodule
 
module CLA4(input wire [3:0] Ra, input wire [3:0] Rb, input wire cin, output wire[3:0] sum, output wire cout);
wire [3:0] P,G,c;

	assign P=Ra^Rb;	
	assign G=Ra&Rb;
	assign c[0]= cin;
	assign c[1]= G[0] | (P[0]&c[0]);
	assign c[2]= G[1] | (P[1]&G[0]) | P[1]&P[0]&c[0];
	assign c[3]= G[2] | (P[2]&G[1]) | P[2]&P[1]&G[0] | P[2]&P[1]&P[0]&c[0];
	assign cout = G[3] | (P[3]&G[2]) | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0] | P[3]&P[2]&P[1]&P[0]&c[0];
	assign sum[3:0] =P^c;
	
endmodule
  