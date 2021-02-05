module mul_32_bit(
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

	initial begin
		carry_in_bit = 0;
		prod_calc = 0;
		prod = 0;
	end
	
   // Pre-compute products of Q for +1,+2,-1,-2
	wire [33:0]   Q1_positive = { Q[31], Q[31], Q };     // the sign extended multiplicand
	wire [33:0]   Q2_positive = { Q[31], Q, 1'b0 };      // the sign extended multiplicand shifted left to be multplies by two
	wire [33:0]   Q1_negative = -Q1_positive;                       
	wire [33:0]   Q2_negative = -Q2_positive;                       

   always @(*) begin
		for (i = 0; i <16; i = i+1 ) begin
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
endmodule
