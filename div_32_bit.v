module div_32_bit(
		input [31:0] Q,
		input [31:0] M,
		input start,
		input clk,		
		output reg [31:0] quotient,
		output wire [31:0] remainder,
		output wire ready
);

	reg [63:0]   copyQ, copyM, difference;
	assign remainder = copyQ[31:0];

   reg [5:0] bit;
   assign ready = !bit;

   initial bit = 0;

   always @( posedge clk )

     if ( ready && start ) begin
        bit = 32;
        quotient = 0;
        copyQ = {32'd0,Q};
        copyM = {1'b0,M,31'd0};

     end else begin
        difference = copyQ - copyM;
	     quotient = { quotient[30:0], ~difference[63] };
	     copyM = { 1'b0, copyM[63:1] };
	     if ( !difference[63] ) copyQ = difference;
        bit = bit - 1;
     end

endmodule
