// 2-to-1 Multiplexer to be used by the ALU
`timescale 1ns/10ps

module 2_to_1_mux (input wire [31:0] input1, input wire [31:0] input2, input wire signal, output reg [31:0] output);

always@(*)begin
		if (signal) begin
			output[31:0] <= input2[31:0];
		end
		else begin
			output[31:0] <= input1[31:0];
		end
	end
 
endmodule
