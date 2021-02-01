`timescale 1ns/10ps

module cpu(
	input wire clk, 
	input wire clr,
	input wire Mdatain,
	input wire [31:0] inPort,
	output wire [31:0] outPort
);

	// Wires being used as inputs to the bus's encoder. Originally they are all initialized to 0.
	wire R0out = 0;
	wire R1out = 0;
	wire R2out = 0;
	wire R3out = 0;
	wire R4out = 0;
	wire R5out = 0;
	wire R6out = 0;
	wire R7out = 0;
	wire R8out = 0;
	wire R9out = 0;
	wire R10out = 0;
	wire R11out = 0;
	wire R12out = 0;
	wire R13out = 0;
	wire R14out = 0;
	wire R15out = 0;
	wire HIout = 0;
	wire LOout = 0;
	wire ZHighout = 0;
	wire ZLowout = 0;
	wire PCout = 0;
	wire MDRout = 0;
	wire InPortout = 0;
	wire Cout = 0;
	
	// Encoder input and output wires
	wire [31:0]	encoder_in;
	wire [4:0] encoder_out;
	
	// Connecting the register output signals to the encoder's input wire
	assign encoder_in = {
								{8{1'b0}},
								Cout,
								InPortout,
								MDRout,
								PCout,
								ZLowout,
								ZHighout,
								LOout,
								HIout,
								R15out,
								R14out,
								R13out,
								R12out,
								R11out,
								R10out,
								R9out,
								R8out,
								R7out,
								R6out,
								R5out,
								R4out,
								R3out,
								R2out,
								R1out,
								R0out
								};
	

    // Instatiating 32-to-5 encoder for the bus
    encoder_32_to_5 encoder(encoder_in, encoder_out);
	
    // Enable signals for the registers
    wire R1_enable;
    wire R2_enable;
    wire R3_enable;
    wire R4_enable;
    wire R5_enable;
    wire R6_enable;
    wire R7_enable;
    wire R8_enable;
    wire R9_enable;
    wire R10_enable;
    wire R11_enable;
    wire R12_enable;
    wire R13_enable;
    wire R14_enable;
    wire R15_enable;
    wire HI_enable;
    wire LO_enable;
    wire ZHigh_enable;
    wire ZLow_enable;
    wire PC_enable;
    wire MDR_enable;
    wire InPort_enable;
    wire C_enable; 
	 
	 wire [31:0] bus_contents;
	 
	 //Inputs to the bus's 32-to_1 multiplexer
	 wire [31:0] R0_data_out;
	wire [31:0] R1_data_out;
	wire [31:0] R2_data_out;
	wire [31:0] R3_data_out;
	wire [31:0] R4_data_out;
	wire [31:0] R5_data_out;
	wire [31:0] R6_data_out;
	wire [31:0] R7_data_out;
	wire [31:0] R8_data_out;
	wire [31:0] R9_data_out;
	wire [31:0] R10_data_out;
	wire [31:0] R11_data_out;
	wire [31:0] R12_data_out;
	wire [31:0] R13_data_out;
	wire [31:0] R14_data_out;
	wire [31:0] R15_data_out;
	wire [31:0] HI_data_out;
	wire [31:0] LO_data_out;
	wire [31:0] ZHigh_data_out;
	wire [31:0] ZLow_data_out;
	wire [31:0] PC_data_out;
	wire [31:0] MDR_data_out;
	wire [31:0] InPort_data_out;
	wire [31:0] C_data_out;
 
   // Creating all 32-bit registers
	reg_32_bits R0(clk, clr, 1'd0 , bus_contents, R0_data_out); 
	reg_32_bits R1(clk, clr, R1_enable, bus_contents, R1_data_out);
	reg_32_bits R2(clk, clr, R2_enable, bus_contents, R2_data_out);
	reg_32_bits R3(clk, clr, R3_enable, bus_contents, R3_data_out);
	reg_32_bits R4(clk, clr, R4_enable, bus_contents, R4_data_out);
	reg_32_bits R5(clk, clr, R5_enable, bus_contents, R5_data_out);
	reg_32_bits R6(clk, clr, R6_enable, bus_contents, R6_data_out);
	reg_32_bits R7(clk, clr, R7_enable, bus_contents, R7_data_out);
	reg_32_bits R8(clk, clr, R8_enable, bus_contents, R8_data_out);
	reg_32_bits R9(clk, clr, R9_enable, bus_contents, R9_data_out);
	reg_32_bits R10(clk, clr, R10_enable, bus_contents, R10_data_out);
	reg_32_bits R11(clk, clr, R11_enable, bus_contents, R11_data_out);
	reg_32_bits R12(clk, clr, R12_enable, bus_contents, R12_data_out);
	reg_32_bits R13(clk, clr, R13_enable, bus_contents, R13_data_out);
	reg_32_bits R14(clk, clr, R14_enable, bus_contents, R14_data_out);
	reg_32_bits R15(clk, clr, R15_enable, bus_contents, R15_data_out);
	
	reg_32_bits HI_reg(clk, clr, HI_enable, bus_contents, HI_data_out);
	reg_32_bits LO_reg(clk, clr, LO_enable, bus_contents, LO_data_out);
	reg_32_bits ZHigh_reg(clk, clr, ZHigh_enable, bus_contents, ZHigh_data_out);	
	reg_32_bits ZLow_reg(clk, clr, ZLow_enable, bus_contents, ZLow_data_out);
	reg_32_bits PC_reg(clk, clr, PC_enable, bus_contents, PC_data_out);
	reg_32_bits InPort_reg(clk, clr, InPort_enable, bus_contents, InPort_data_out);
	reg_32_bits C_reg(clk, clr, C_enable, bus_contents, C_data_out);
	
	
	// Creating the MDR
	// Select signal for the MDR's multiplexer
	wire read_sig;
	// Multiplexer used to select an input for the MDR
	mux_2_to_1 MDMux(MDatain, BusMuxOut, read_sig, MDR_mux_out);
	// Instatiating the MDR register
	reg_32_bits MDR_reg(clk, clr, MDR_enable, MDR_mux_out, MDR_data_out);
	
	// Multiplexer to select which data to send out on the bus
	mux_32_to_1 BusMux(
		.BusMuxIn_R0(R0_data_out),
		.BusMuxIn_R1(R1_data_out), 
		.BusMuxIn_R2(R2_data_out),
		.BusMuxIn_R3(R3_data_out),
		.BusMuxIn_R4(R4_data_out),
		.BusMuxIn_R5(R5_data_out),
		.BusMuxIn_R6(R6_data_out),
		.BusMuxIn_R7(R7_data_out),
		.BusMuxIn_R8(R8_data_out),
		.BusMuxIn_R9(R9_data_out),
		.BusMuxIn_R10(R10_data_out),
		.BusMuxIn_R11(R11_data_out),
		.BusMuxIn_R12(R12_data_out),
		.BusMuxIn_R13(R13_data_out),
		.BusMuxIn_R14(R14_data_out),
		.BusMuxIn_R15(R15_data_out),
		.BusMuxIn_HI(HI_data_out),
		.BusMuxIn_LO(LO_data_out),
		.BusMuxIn_Zhigh(ZHigh_data_out),
		.BusMuxIn_Zlow(ZLow_data_out),
		.BusMuxIn_PC(PC_data_out),
		.BusMuxIn_MDR(MDR_data_out),	
		.BusMuxIn_InPort(InPort_data_out),
		.C_sign_extended(C_data_out),
		.BusMuxOut(bus_contents),
		.select_signal(encoder_out)
		);
	
	endmodule
	
