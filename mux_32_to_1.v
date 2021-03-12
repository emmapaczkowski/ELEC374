// 32-to-1 MUX for the bus 

`timescale 1ns/10ps

module mux_32_to_1(
	// General purpose registers
	input [31:0] BusMuxIn_R0,
	input [31:0] BusMuxIn_R1,
	input [31:0] BusMuxIn_R2,
	input [31:0] BusMuxIn_R3, 
	input [31:0] BusMuxIn_R4,
	input [31:0] BusMuxIn_R5,
	input [31:0] BusMuxIn_R6,
	input [31:0] BusMuxIn_R7,
	input [31:0] BusMuxIn_R8,
	input [31:0] BusMuxIn_R9,
	input [31:0] BusMuxIn_R10,
	input [31:0] BusMuxIn_R11,
	input [31:0] BusMuxIn_R12,
	input [31:0] BusMuxIn_R13,
	input [31:0] BusMuxIn_R14,
	input [31:0] BusMuxIn_R15,
	
	input [31:0] BusMuxIn_HI,
	input [31:0] BusMuxIn_LO,
	input [31:0] BusMuxIn_Z_high,
	input [31:0] BusMuxIn_Z_low,
	input [31:0] BusMuxIn_PC,
	input [31:0] BusMuxIn_MDR,	
	input [31:0] BusMuxIn_InPort,
	input [31:0] C_sign_extended,
	
	// Multiplexer's output that feeds to the bus
	output reg [31:0] BusMuxOut,
	
	// Select signal for the multiplexer
	input wire [4:0] select_signal

);

always@(*) begin
	// Assign the appropriate input signal to the multiplexer's output
	case(select_signal)
         5'd0 : BusMuxOut <= BusMuxIn_R0[31:0];
         5'd1 : BusMuxOut <= BusMuxIn_R1[31:0];
         5'd2 : BusMuxOut <= BusMuxIn_R2[31:0];
         5'd3 : BusMuxOut <= BusMuxIn_R3[31:0];
	 5'd4 : BusMuxOut <= BusMuxIn_R4[31:0];
         5'd5 : BusMuxOut <= BusMuxIn_R5[31:0];
         5'd6 : BusMuxOut <= BusMuxIn_R6[31:0];
         5'd7 : BusMuxOut <= BusMuxIn_R7[31:0];
	 5'd8 : BusMuxOut <= BusMuxIn_R8[31:0];
         5'd9 : BusMuxOut <= BusMuxIn_R9[31:0];
         5'd10: BusMuxOut <= BusMuxIn_R10[31:0];
         5'd11: BusMuxOut <= BusMuxIn_R11[31:0];
	 5'd12: BusMuxOut <= BusMuxIn_R12[31:0];
         5'd13: BusMuxOut <= BusMuxIn_R13[31:0];
         5'd14: BusMuxOut <= BusMuxIn_R14[31:0];
         5'd15: BusMuxOut <= BusMuxIn_R15[31:0];
	 5'd16: BusMuxOut <= BusMuxIn_HI[31:0];
         5'd17: BusMuxOut <= BusMuxIn_LO[31:0];
         5'd18: BusMuxOut <= BusMuxIn_Z_high[31:0];
         5'd19: BusMuxOut <= BusMuxIn_Z_low[31:0];
	 5'd20: BusMuxOut <= BusMuxIn_PC[31:0];
         5'd21: BusMuxOut <= BusMuxIn_MDR[31:0];
         5'd22: BusMuxOut <= BusMuxIn_InPort[31:0];
         5'd23: BusMuxOut <= C_sign_extended[31:0];
	 default: BusMuxOut <= 32'd0;
      endcase
   end
	
endmodule
