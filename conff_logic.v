`timescale 1ns/10ps

module conff_logic(input [1:0] IR_bits, input signed [31:0] bus, input CON_input, output CON_output);
	wire [3:0] decoderOutput;
	wire equal;
	wire notEqual;
	wire positive;
	wire negative;
	wire branchFlag;
	
	assign equal 		= (bus == 32'd0) ? 1'b1 : 1'b0;
	assign notEqual		= (bus != 32'd0) ? 1'b1 : 1'b0;
	assign positive		= (bus[31] == 0) ? 1'b1 : 1'b0;
	assign negative 	= (bus[31] == 1) ? 1'b1 : 1'b0;
	
	decoder	dec(IR_bits, decoderOutput);
	assign branchFlag=(decoderOutput[0]&equal|decoderOutput[1]&notEqual|decoderOutput[2]&positive|decoderOutput[3]&negative);
	ff_logic CONff(.clk(CON_input), .D(branchFlag), .Q(CON_output));
endmodule
