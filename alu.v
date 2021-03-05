`timescale 1ns/10ps

module alu(
	input clk, clear, IncPC, branch_flag,
	
	input wire [31:0] A_reg,
	input wire [31:0] B_reg,
	input wire [31:0] Y_reg,

	input wire [4:0] opcode,

	output reg [63:0] C_reg 
);
	parameter Addition = 5'b00011, Subtraction = 5'b00100, Multiplication = 5'b01110, Division = 5'b01111, Shift_right = 5'b00101, Shift_left = 5'b00110, Rotate_right = 5'b00111, Rotate_left = 5'b01000, 
				 Logical_AND = 5'b01001, Logical_OR = 5'b01010, Negate = 5'b10000, _Not = 5'b10001, load = 5'b00000, loadi = 5'b00001, store = 5'b00010,
				 addi = 5'b01011, andi = 5'b01100, ori = 5'b01101, branch = 5'b10010, jr = 5'b10011, jal = 5'b10100, mfhi = 5'b10111, mflo = 5'b11000,
				 in = 5'b10101, out = 5'b10110;
	
	wire [31:0] IncPC_out, shr_out, shl_out, lor_out, land_out, neg_out, not_out, adder_sum, adder_cout, sub_sum, sub_cout, rol_out, ror_out;
	wire [63:0] mul_out, div_out;

	
	always @(*)
		begin
			case (opcode)
				
				Addition: begin
					C_reg[31:0] <= adder_sum[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Subtraction: begin
					C_reg[31:0] <= sub_sum[31:0];	
					C_reg[63:32] <= 32'd0;
				end
				
				Logical_OR, ori: begin
					C_reg[31:0] <= lor_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Logical_AND, andi: begin
					C_reg[31:0] <= land_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Negate: begin
					C_reg[31:0] <= neg_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				_Not: begin
					C_reg[31:0] <= not_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Shift_right: begin
					C_reg[31:0] <= shr_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Shift_left: begin
					C_reg[31:0] <= shl_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Rotate_right: begin
					C_reg[31:0] <= ror_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Rotate_left: begin
					C_reg[31:0] <= rol_out[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				Multiplication: begin
					C_reg[63:32] <= ~mul_out[63:32];
					C_reg[31:0] <= mul_out[31:0];
				end
				
				Division: begin
					C_reg[63:0] <= div_out[63:0];
				end
				
				load, loadi, store, addi: begin
					C_reg[31:0] <= adder_sum[31:0];
					C_reg[63:32] <= 32'd0;
				end
				
				branch: begin
					if(branch_flag==1) begin
						C_reg[31:0] <= adder_sum[31:0];
						C_reg[63:32] <= 32'd0;
					end 
					else begin
						C_reg[31:0] <= Y_reg[31:0];
						C_reg[63:32] <= 32'd0;
					end
				end
				
				default: begin
					C_reg[63:0] <= 64'd0;
				end

			endcase
	end
	
	//ALU Operations
	or_32_bit lor(Y_reg,B_reg,lor_out);
	and_32_bit land(Y_reg,B_reg,land_out);
	negate_32_bit neg(B_reg,neg_out);
	not_32_bit not_module(B_reg,not_out);
	add_32_bit adder(.Ra(Y_reg), .Rb(B_reg),.cin({1'd0}),.sum(adder_sum),.cout(adder_cout));
	sub_32_bit subtractor(.Ra(Y_reg), .Rb(B_reg),.cin({1'd0}),.sum(sub_sum),.cout(sub_cout));
	ror_32_bit ror_op(Y_reg,B_reg,ror_out);
	rol_32_bit rol_op(Y_reg,B_reg,rol_out);
	shl_32_bit shl(Y_reg,B_reg,shl_out);
	shr_32_bit shr(Y_reg,B_reg,shr_out);
	div_32_bit div(Y_reg,B_reg, div_out);
	mul_32_bit mul(Y_reg,B_reg,mul_out);
	IncPC_32_bit pc_inc(A_reg, IncPC, IncPC_out);

endmodule
