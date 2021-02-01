`timescale 1ns/10ps

module 2_to_1_mux (input wire [31:0] input0, input wire [31:0] input1, input wire sig, output reg [31:0] out);

always@(*)begin
		if (sig) begin
			out[31:0] <= input1[31:0];
		end
		else begin
			out[31:0] <= input0[31:0];
		end
	end
 
endmodule
