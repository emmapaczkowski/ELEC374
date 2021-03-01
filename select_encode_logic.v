`timescale 1ns/10ps

module select_encode_logic(input [31:0] instruction, input Gra, input Grb, input Grc, input Rin, input Rout, input BAout, output [4:0] opcode, output [31:0] C_sign_extended, output [15:0] RegIn, output [15:0] RegOut, output wire [3:0] decoderInput);
	wire [15:0] decoderOutput;
	
	assign decoderInput = (instruction[26:23]&{4{Gra}}) | (instruction[22:19]&{4{Grb}}) | (instruction[18:15]&{4{Grc}});
	decoder	decoded(decoderInput, decoderOutput);
	
	assign opcode = instruction[31:27];
	assign C_sign_extended = {{13{instruction[18]}},instruction[18:0]};
	assign RegIn = {16{Rin}} & decoderOutput;
	assign RegOut = ({16{Rout}} | {16{BAout}}) & decoderOutput;
endmodule

module decoder(input wire [3:0] decoderInput, output reg [15:0] decoderOutput);
	always@(*) begin
		case(decoderInput)
         		4'b0000 : decoderOutput <= 16'h0001;     
         		4'b0001 : decoderOutput <= 16'h0002;   
					4'b0010 : decoderOutput <= 16'h0004; 
         		4'b0011 : decoderOutput <= 16'h0008;  
         		4'b0100 : decoderOutput <= 16'h0010;    
         		4'b0101 : decoderOutput <= 16'h0020;   
         		4'b0110 : decoderOutput <= 16'h0040;
         		4'b0111 : decoderOutput <= 16'h0080;    
         		4'b1000 : decoderOutput <= 16'h0100;    
         		4'b1001 : decoderOutput <= 16'h0200;    
         		4'b1010 : decoderOutput <= 16'h0400;   
         		4'b1011 : decoderOutput <= 16'h0800;  
         		4'b1100 : decoderOutput <= 16'h1000;  
         		4'b1101 : decoderOutput <= 16'h2000;    
         		4'b1110 : decoderOutput <= 16'h4000;   
         		4'b1111 : decoderOutput <= 16'h8000;   
      		endcase
   	end
endmodule

