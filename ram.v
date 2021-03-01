`timescale 1ns/10ps

module ram(input [31:0] data_in, input [7:0] address, input we, clk, output [31:0] data_out);
	reg [31:0] ram[511:0];
	reg [31:0] addressReg;
	
	initial begin : INIT
		$readmemh("init.mif", ram); 
	end
	
	always @(posedge clk)
	begin
		if (we)
			ram[address] <= data_in;
		addressReg <= address;
	end
	assign data_out = ram[addressReg];
endmodule
