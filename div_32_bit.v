module div_32_bit(
		input [31:0] Q,
		input [31:0] M,
		input start,
		input clk,		
		output reg [31:0] quotient,
		output wire [31:0] remainder,
		output wire ready
);

   reg [63:0]   Q_copy, M_copy, diff;
	assign remainder = Q_copy[31:0];

   reg [5:0] bit;
   assign ready = !bit;

   initial bit = 0;

   always @( posedge clk )

     if ( ready && start ) begin
        bit = 32;
        quotient = 0;
        Q_copy = {32'd0,Q};
        M_copy = {1'b0,M,31'd0};

     end else begin
        diff = Q_copy - M_copy;
        quotient = { quotient[30:0], ~diff[63] };
        M_copy = { 1'b0, M_copy[63:1] };
        if ( !diff[63] ) Q_copy = diff;
        bit = bit - 1;
     end

endmodule
