`timescale 1ns/10ps

module CPUproject(
	input PCout,
	input ZHighout,
	input ZLowout,
	input MDRout,
	input R2out,
	input R4out,
	input MARin,
	input PCin,
	input MDRin,
	input IRin,
	input Yin,
	input IncPC,
	input Read,		
	input R5in,
	input R2in,
	input R4in,
	input clk, 
	input [31:0] MDatain,
	
	input clr, 
	input HIin, LOin, ZHighIn, ZLowIn, Cin, RAM_write_en, GRA, GRB, GRC, R_in, R_out, Baout, enableCon,
	input [15:0] R_enableIn, Rout_in,
	input enableInputPort, enableOutputPort, 
	input wire[31:0] InPort_input, 
	output wire[31:0] OutPort_output,		//OUTPUT OR INPUT
	output [31:0] bus_contents,
	output [4:0] operation
);

	// Wires being used as inputs to the bus's encoder. Originally they are all initialized to 0.
	// R4out and R2out are given as ports to the module.
	wire R0out = 0;
	wire R1out = 0;
	wire R3out = 0;
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
	wire InPortout = 0;
	wire Cout = 0;
	
	wire [31:0] BusMuxInR0_to_AND;
	
	wire [15:0] enableR_IR; 
	wire [15:0] Rout_IR;
	reg  [15:0]  enableR; 
	reg  [15:0]  Rout;
	wire [3:0]  decoder_in;
	
	// Encoder input and output wires
	wire [31:0]	encoder_in;
	wire [4:0] encoder_out;
	
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
	 
	 //wire [31:0] bus_contents;
	 
	 
		always@(*)begin		
			if (enableR_IR)enableR<=enableR_IR; 
			else enableR<=R_enableIn;
			if (Rout_IR)Rout<=Rout_IR; 
			else Rout<=Rout_in;
		end 
	 
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
	wire [31:0] Y_data_out;
	wire [31:0] RAM_data_out;
	wire [31:0] MAR_data_out;
	wire [31:0] IR_data_out;
	wire [31:0] C_sign_extended;
	wire [63:0] C_data_out;
	wire [31:0] Input_Port_dataout;
	wire Con_out;
 
   // Creating all 32-bit registers
	assign R0_data_out = {32{!Baout}} & BusMuxInR0_to_AND;
	reg_32_bits R0(clk, clr, enableR[0], bus_contents, BusMuxInR0_to_AND); 
	reg_32_bits R1(clk, clr, enableR[1], bus_contents, R1_data_out);
	reg_32_bits R2(clk, clr, enableR[2], bus_contents, R2_data_out);
	reg_32_bits R3(clk, clr, enableR[3], bus_contents, R3_data_out);
	reg_32_bits R4(clk, clr, enableR[4], bus_contents, R4_data_out);
	reg_32_bits R5(clk, clr, enableR[5], bus_contents, R5_data_out);
	reg_32_bits R6(clk, clr, enableR[6], bus_contents, R6_data_out);
	reg_32_bits R7(clk, clr, enableR[7], bus_contents, R7_data_out);
	reg_32_bits R8(clk, clr, enableR[8], bus_contents, R8_data_out);
	reg_32_bits R9(clk, clr, enableR[9], bus_contents, R9_data_out);
	reg_32_bits R10(clk, clr, enableR[10], bus_contents, R10_data_out);
	reg_32_bits R11(clk, clr, enableR[11], bus_contents, R11_data_out);
	reg_32_bits R12(clk, clr, enableR[12], bus_contents, R12_data_out);
	reg_32_bits R13(clk, clr, enableR[13], bus_contents, R13_data_out);
	reg_32_bits R14(clk, clr, enableR[14], bus_contents, R14_data_out);
	reg_32_bits R15(clk, clr, enableR[15], bus_contents, R15_data_out);
	
	reg_32_bits Y(clk, clr, Yin, bus_contents, Y_data_out);
	reg_32_bits HI_reg(clk, clr, HIin, bus_contents, HI_data_out);
	reg_32_bits LO_reg(clk, clr, LOin, bus_contents, LO_data_out);
	reg_32_bits ZHigh_reg(clk, clr, ZHighIn, C_data_out[63:32], ZHigh_data_out);	
	reg_32_bits ZLow_reg(clk, clr, ZLowIn, C_data_out[31:0], ZLow_data_out);
	
	reg_32_bits input_port(clk,clr,enableInputPort,InPort_input, Input_Port_dataout);
	reg_32_bits output_port(clk,clr,enableOutputPort, bus_contents, OutPort_output);
	
	IncPC_32_bit PC_reg(clk, IncPC, PCin, bus_contents, PC_data_out);
	
	reg_32_bits IR(clk, clr, IRin, bus_contents, IR_data_out);
	select_encode_logic IRlogic(IR_data_out, GRA, GRB, GRC, R_in, R_out, Baout, operation, C_sign_extended, enableR_IR, Rout_IR, decoder_in);
	
	conff_logic conff1(IR_data_out[20:19], bus_contents, enableCon, con_out);
	
	ram ram1(MDR_data_out, MAR_data_out, RAM_write_en, clk, RAM_data_out);
	
	
	// Creating the MDR
	// Select signal for the MDR's multiplexer
	reg read_sig;
	initial read_sig = 0;
	wire [31:0] MDR_mux_out;	
	// Multiplexer used to select an input for the MDR
	mux_2_to_1 MDMux(RAM_data_out, bus_contents, read_sig, MDR_mux_out);		// CHANGED 1ST INPUT FROM MDATAIN TO RAMDATAOUT
	// Instatiating the MDR register
	reg_32_bits MDR_reg(clk, clr, MDRin, MDR_mux_out, MDR_data_out);
	
	// Instatiating the MAR register
	reg_32_bits MAR(clk, clr, MARin, bus_contents, MAR_data_out);
	
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
		.BusMuxIn_Z_high(ZHigh_data_out),
		.BusMuxIn_Z_low(ZLow_data_out),
		.BusMuxIn_PC(PC_data_out),
		.BusMuxIn_MDR(MDR_data_out),	
		.BusMuxIn_InPort(InPort_data_out),
		.BusMuxOut(bus_contents),
		.select_signal(encoder_out)
		);

	//instantiate alu
	alu the_alu(
	.clk(clk),
	.clear(clr), 
	.A_reg(Y_data_out),
	.B_reg(bus_contents),
	.opcode(operation),
	.C_reg(C_data_out)
	);
	
endmodule

	
