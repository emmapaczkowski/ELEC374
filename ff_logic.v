module ff_logic(input wire clk, input wire D, output reg Q, output reg Q_not);	
	initial begin
		Q <= 0;
		Q_not <= 1;
	end
	always@(clk) 
	begin
		Q <= D;
		Q_not <= !D;
	end
endmodule

