`timescale 1ns/10ps

module phase3_tb;
	reg clk, rst, stop;
	wire[31:0] InPort_input, OutPort_output, bus_contents;
	wire [4:0] operation;

CPUproject DUT(
	.clk(clk),
	.rst(rst),
	.stop(stop),
	.InPort_input(InPort_input), 
	.OutPort_output(OutPort_output),
	.bus_contents(bus_contents),
	.operation(operation)
);

initial
	begin
		clk = 0;
		rst = 0;
end

always
		#10 clk <= ~clk;

endmodule



