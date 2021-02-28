module mul_32_bit(input signed [31:0] a, b, output[32*2-1:0] z);
	reg [2:0] cc[(32 / 2) - 1:0];
	reg [32:0] pp[(32 / 2) - 1:0];
	reg[32*2-1:0] spp[(32 / 2) - 1:0];
	
	reg [32*2-1:0] product;
	
	integer j,i;
	
	wire [32:0] inv_a;
	assign inv_a = {~a[31], ~a} +1;
	
	always @ (a or b or inv_a) 
	begin
		cc[0] = {b[1], b[0], 1'b0};
		
		for (j=1; j < (32/2); j = j+1)
			cc[j] = {b[2*j+1], b[2*j], b[2*j-1]};
			
		for (j=0; j < (32/2); j = j+1) 
		begin	
			case(cc[j])
				3'b001 : pp[j] = {a[32-1], a}; 
				3'b010 : pp[j] = {a[32-1], a};
				3'b011 : pp[j] = {a, 1'b0};
				3'b100 : pp[j] = {inv_a[32-1:0], 1'b0};
				3'b101 : pp[j] = inv_a; 
				3'b110 : pp[j] = inv_a;
				default : pp[j] = 0;
			endcase
			spp[j] = $signed(pp[j]);
			
			for (i=0 ; i<j ; i = i + 1)
				spp[j] = {spp[j], 2'b00};
		end
	
		product = spp[0];
	
		for (j=1; j < (32/2); j = j+1)
			product = product + spp[j];
	end
	assign z = product;	
endmodule
