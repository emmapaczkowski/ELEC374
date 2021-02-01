module mul_32_bit(
	input [31:0]  Q,
	input [31:0]  M,
	output reg [63:0] prod
	);
	
   integer i;
   reg carry_in_bit;
	reg [63:0] prod_calc;
	reg [1:0] mb;  // Multiplier Bits
   reg [33:0] prod_curr;
   reg [33:0] prod_prev;

	initial begin
		carry_in_bit = 0;
		prod_calc = 0;
		prod = 0;
	end
	
   // Pre-compute products of Q for +1,+2,-1,-2
   wire [33:0]   Q_pos_1 = { Q[31], Q[31], Q };   	//sign extended multiplicand
   wire [33:0]   Q_pos_2 = { Q[31], Q, 1'b0 };     //sign extended multiplicand shifted left to multiply by 2 
   wire [33:0]   Q_neg_1 = -Q_pos_1;                       
   wire [33:0]   Q_neg_2 = -Q_pos_2;                       

   always @(*) begin
		for (i = 0; i <16; i = i +1 ) begin
			if (i==0)
				prod_calc = {32'd0, M};

		
        prod_prev = {prod_calc[63], prod_calc[63], prod_calc[63:32]}; //sign extend product

        mb = prod_calc[1:0];  // use the lowest 2 bits from M to calculate the booth bit pair values
   
        case ( {mb,carry_in_bit} )
          3'b000: prod_curr = prod_prev;
          3'b001: prod_curr = prod_prev + Q_pos_1;
          3'b010: prod_curr = prod_prev + Q_pos_1;
          3'b011: prod_curr = prod_prev + Q_pos_2;
          3'b100: prod_curr = prod_prev + Q_neg_2;
          3'b101: prod_curr = prod_prev + Q_neg_1;
          3'b110: prod_curr = prod_prev + Q_neg_1;
          3'b111: prod_curr = prod_prev;
        endcase

        carry_in_bit = prod_calc[1];

        prod_calc = {prod_curr, prod_calc[31:2]};
		end
		prod = prod_calc;
	end
endmodule
