module shr_32_bit(
	input wire [31:0] data_in,
	input wire [31:0] num_shifts,
	output wire [31:0] out
);
	assign out[31:0] = data_in>>num_shifts;

endmodule 