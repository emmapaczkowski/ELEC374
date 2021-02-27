/*module mul_32_bit(
   input [31:0]  Q, 
   input [31:0]  M,
   output reg [63:0] prod
	);
		
   integer i;
   reg carry_in_bit;
   reg [63:0] prod_calc;
   reg [1:0] mb;  // to keep track of multiplier bits
   reg [33:0] prod_cur;
   reg [33:0] prod_pre;

	initial 	
		carry_in_bit = 0;
		prod_calc = 0;
		prod = 0;
	end
	
   // Pre-compute products of Q for +1,+2,-1,-2
	wire [33:0]   Q1_positive = { Q[31], Q[31], Q };     // the sign extended multiplicand
	wire [33:0]   Q2_positive = { Q[31], Q, 1'b0 };      // the sign extended multiplicand shifted left to be multplies by two
	wire [33:0]   Q1_negative = -Q1_positive;                       
	wire [33:0]   Q2_negative = -Q2_positive;                       

   always @(*) 	
		for (i = 0; i <16; i = i+1 ) 	
			if (i==0)
				prod_calc = {32'd0, M};

		
        prod_pre = {prod_calc[63], prod_calc[63], prod_calc[63:32]}; //sign extend product

        mb = prod_calc[1:0];  // use the lowest 2 bits from M to calculate the booth bit pair values
   
        case ( {mb,carry_in_bit} )
          3'b000: prod_cur = prod_pre;
          3'b001: prod_cur = prod_pre + Q1_positive;
          3'b010: prod_cur = prod_pre + Q1_positive;
          3'b011: prod_cur = prod_pre + Q2_positive;
          3'b100: prod_cur = prod_pre + Q2_negative;
          3'b101: prod_cur = prod_pre + Q1_negative;
          3'b110: prod_cur = prod_pre + Q1_negative;
          3'b111: prod_cur = prod_pre;
        endcase

        carry_in_bit = prod_calc[1];

        prod_calc = {prod_cur, prod_calc[31:2]};
		end
		prod = prod_calc;
		
	end
endmodule*/

module mul_32_bit(input signed [31:0] x, y, output[32*2-1:0] p);
	reg [2:0] cc[(32 / 2) - 1:0];
	reg [32:0] pp[(32 / 2) - 1:0];
	reg[32*2-1:0] spp[(32 / 2) - 1:0];
	reg [32*2-1:0] prod;
	
	wire [32:0] inv_x;
	integer kk,ii;
	
	assign inv_x = {~x[31], ~x} +1;
	
	always @ (x or y or inv_x) 
	begin
		cc[0] = {y[1], y[0], 1'b0};
		
		for (kk=1; kk < (32/2); kk = kk+1)
			cc[kk] = {y[2*kk+1], y[2*kk], y[2*kk-1]};
			
		for (kk=0; kk < (32/2); kk = kk+1) 
		begin	
			case(cc[kk])
				3'b001 , 3'b010 : pp[kk] = {x[32-1], x};
				3'b011 : pp[kk] = {x, 1'b0};
				3'b100 : pp[kk] = {inv_x[32-1:0], 1'b0};
				3'b101, 3'b110 : pp[kk] = inv_x;
				default : pp[kk] = 0;
			endcase
			spp[kk] = $signed(pp[kk]);
			
			for (ii=0 ; ii<kk ; ii = ii + 1)
				spp[kk] = {spp[kk], 2'b00};
		end
	
		prod = spp[0];
	
		for (kk=1; kk < (32/2); kk = kk+1)
			prod = prod + spp[kk];
	end
	assign p = prod;
	
endmodule


/*
module mul_32_bit(X, Y, Z);
	input signed [31:0] X, Y;
	output signed [63:0] Z;
	reg signed [63:0] Z;
	reg [1:0] temp;
	integer i;
	reg E1;
	reg [31:0] Y1;
	always @ (X, Y) begin
		Z = 63'd0;
		E1 = 1'd0;
		Y1 = - Y;
		Z[31:0]=X;
		for (i = 0; i < 32; i = i + 1)
		begin
			temp = {X[i], E1};
			case (temp)
			2'd2 : Z [63 : 32] = Z [63 : 32] + Y1;
			2'd1 : Z [63 : 32] = Z [63 : 32] + Y;
			default : begin end
			endcase
			Z = Z >> 1;
			Z[63] = Z[62];
			E1 = X[i];
		end
	end
	endmodule

*/

