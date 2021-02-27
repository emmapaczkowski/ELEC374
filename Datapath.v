`timescale 1ns/10ps

module Datapath(

	input		clk,
	input		clr,
			
	//input		RAM_read,
	input wire [2:0] MDR_read,
   input wire [31:0]	Mdatain, // MDR controls
	//input    RAM_write,
	
	input    IncPC,
	
			
	input    R_enable,
	input    Rout,
	input wire [15:0]R0_R15_enable_in, 
	input wire [15:0]R0_R15_out_in,
	
	input    Gra,
	input    Grb,
	input    Grc,
	
	input		MDR_enable, 
	input    MAR_enable,	
   input    HI_enable,
   input    LO_enable,
   input    Z_enable,
	input    Y_enable,
   input    PC_enable,
   input    InPort_enable,
   input    OutPort_enable,
	input    IR_enable,
	input    CON_enable,
	
	input		MDRout,		
	input		InPortout,
	input 	OutPortout,
	input		PCout,
	input    Yout,
	input		ZLowout,
	input		ZHighout,
	input		LOout,
	input		HIout,
	input    Cout,
	input    BAout,
	
	//InPort and OutPort data wires
	input wire[31:0] InPort_input,
	output wire[31:0] OutPort_output,
	
	output wire [31:0] bus_contents,
	output wire [4:0] opcode

	/*input		PCout,
	input		ZLowout,
	input		MDRout,
	input		Raout,
	input		Rbout,
	input 	MARin,
	input		Zin,
	input		PCin,
	input		MDRin,
	input		IRin,
	input		Yin,
	input		IncPC,
	input		Read,
	input		operation,
	input		Rcin,
	input		Rain,
	input		Rbin,
	input		clk,
	input		Mdatain*/
); 

	wire [15:0]R0_R15_enable_IR; 
	wire [15:0]R0_R15_out_IR;
	reg [15:0]R0_R15_enable; 
	reg [15:0]R0_R15_out;
	
	
	wire [3:0] decoder_in;

	wire [31:0] R0_data_out_to_AND;
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
	wire [31:0] Y_data_out;
	wire [31:0] ZHigh_data_out;
	wire [31:0] ZLow_data_out;
	wire [31:0] PC_data_out;
	wire [31:0] InPort_data_out;
	wire [63:0] C_data_out;
	wire [31:0] C_sign_extended;   
	wire [31:0] IR_data_out;
	
	
	wire [31:0] MDR_mux_data_out;
	wire [31:0] MDR_data_out;
	wire [31:0] MAR_data_out;
	
	wire [4:0] bus_encoder_signal;
	wire [31:0] RAM_data_out;
	
	wire CON_out;
	
	always@(*)begin
		
		if (R0_R15_enable_IR)R0_R15_enable<=R0_R15_enable_IR; 
		else R0_R15_enable<=R0_R15_enable_in;
		
		if (R0_R15_out_IR)R0_R15_out<=R0_R15_out_IR; 
		else R0_R15_out<=R0_R15_out_in;
	
	
	end 
	
	// R0 Register 
	Reg_32bit R0(clk, clr, R0_R15_enable[0], bus_contents, R0_data_out_to_AND);
	assign R0_data_out = {32{!BAout}} & R0_data_out_to_AND;

	//Registers
	Reg_32bit R1(clk, clr, R0_R15_enable[1], bus_contents, R1_data_out);
	Reg_32bit R2(clk, clr, R0_R15_enable[2], bus_contents, R2_data_out);
	Reg_32bit R3(clk, clr, R0_R15_enable[3], bus_contents, R3_data_out);
	Reg_32bit R4(clk, clr, R0_R15_enable[4], bus_contents, R4_data_out);
	Reg_32bit R5(clk, clr, R0_R15_enable[5], bus_contents, R5_data_out);
	Reg_32bit R6(clk, clr, R0_R15_enable[6], bus_contents, R6_data_out);
	Reg_32bit R7(clk, clr, R0_R15_enable[7], bus_contents, R7_data_out);
	Reg_32bit R8(clk, clr, R0_R15_enable[8], bus_contents, R8_data_out);
	Reg_32bit R9(clk, clr, R0_R15_enable[9], bus_contents, R9_data_out);
	Reg_32bit R10(clk, clr, R0_R15_enable[10], bus_contents, R10_data_out);
	Reg_32bit R11(clk, clr, R0_R15_enable[11], bus_contents, R11_data_out);
	Reg_32bit R12(clk, clr, R0_R15_enable[12], bus_contents, R12_data_out);
	Reg_32bit R13(clk, clr, R0_R15_enable[13], bus_contents, R13_data_out);
	Reg_32bit R14(clk, clr, R0_R15_enable[14], bus_contents, R14_data_out);
	Reg_32bit R15(clk, clr, R0_R15_enable[15], bus_contents, R15_data_out);
		
	//Y and Z Registers
	Reg_32bit ZHigh(clk, clr, Z_enable, C_data_out[63:32], ZHigh_data_out);
	Reg_32bit ZLow(clk, clr, Z_enable, C_data_out[31:0], ZLow_data_out);
	Reg_32bit Yreg(clk, clr, Y_enable, bus_contents, Y_data_out);
	
	//High and Low Registers
	Reg_32bit HIreg(clk, clr, HI_enable, bus_contents, HI_data_out);
	Reg_32bit LOreg(clk, clr, LO_enable, bus_contents, LO_data_out);
	
	//In Out Port Registers
	Reg_32bit In_port(clk,clr,InPort_enable,InPort_input, InPort_data_out);
	Reg_32bit Out_port(clk,clr,OutPort_enable,bus_contents, OutPort_output);

	//CON FF
	CONFF CON_FF(IR_data_out[20:19], bus_contents, CON_enable, CON_out);

	//PC
	Reg_32bit PC_reg(clk, clr, PC_enable, bus_contents, PC_data_out);
	
	//MDR
	mux_3to1 MDR_mux(bus_contents,RAM_data_out,Mdatain,MDR_read, MDR_mux_data_out);
	Reg_32bit MDR(clk, clr, MDR_enable, MDR_mux_data_out, MDR_data_out);

	//Bus
	encoder_32to5 busEncoder({{8{1'b0}},Cout,InPortout,MDRout,PCout,ZLowout,ZHighout,LOout,HIout,R0_R15_out}, bus_encoder_signal);
	
	mux_32to1 busMux(
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
		.C_sign_extended(C_sign_extended),
		.select_signal(bus_encoder_signal),
		.BusMuxOut(bus_contents)
	);
	
	//ALU
	//TODO: We need some sort of multiplexer to choose whether to feed ALU from bus directly or from Y reg(if we're using both A and B regesters)
	ALU alu(
		.clk(clk),
		.clear(clr),
		.A_reg(bus_contents), //from bus directly
		.B_reg(bus_contents), 
		.Y_reg(Y_data_out),   //previous bus contents now stored in y
		.opcode(opcode),
		.C_reg(C_data_out),
		.branch_flag(CON_out),
		.IncPC(IncPC)
	);	
endmodule
