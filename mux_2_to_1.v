// 2-to-1 Multiplexer to be used by the ALU
`timescale 1ns/10ps

module mux_2_to_1 (input wire [31:0] input1, input wire [31:0] input2, input wire signal, output reg [31:0] out);
 
always@(*)begin
		if (signal) begin
			out[31:0] <= input2[31:0];
		end
		else begin
			out[31:0] <= input1[31:0];
		end
	end
 
endmodule
