module decoder_2_to_4(input wire [1:0] decoderInput, output reg [3:0] decoderOutput);
	always@(*) begin
		case(decoderInput)
         		4'b00 : decoderOutput <= 4'b0001;    
       		 	4'b01 : decoderOutput <= 4'b0010;    
         		4'b10 : decoderOutput <= 4'b0100;    
         		4'b11 : decoderOutput <= 4'b1000;    
      		endcase
   	end
endmodule
