module div_32_bit(input signed [31:0] dividend, divisor, output reg [32*2-1:0] z);
	reg [63:32] high, low;
	always @ (*)
	begin
		high = dividend % divisor;
		low = (dividend - high) / divisor;
		begin
			z = {high, low};
		end
	end
				
endmodule

