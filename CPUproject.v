`timescale 1ns/10ps

module CPUproject(
			
	input clk, rst, stop,
	input wire[31:0] InPort_input, 
	output wire[31:0] OutPort_output,		
	output [31:0] bus_contents,
	output [4:0] operation
);

	wire PCout, ZHighout, ZLowout, MDRout, MARin, PCin, MDRin, IRin, Yin, IncPC, Read, 
			HIin, LOin, HIout, LOout, ZHighIn, ZLowIn, Cout, RAM_write_en, GRA, GRB, GRC, 
			R_in, R_out, Baout, enableCon, enableInputPort, enableOutputPort, InPortout, Run;
		
	wire [15:0] R_enableIn; 
	wire [31:0] BusMuxInR0_to_AND;
	
	wire [15:0] enableR_IR; 
	wire [15:0] Rout_IR;
	reg  [15:0] enableR; 
	reg  [15:0] Rout;
	wire [3:0]  decoder_in;
	 
		always@(*)begin		
			if (enableR_IR)enableR<=enableR_IR; 
			else enableR<=R_enableIn;
			if (Rout_IR)Rout<=Rout_IR; 
			else Rout<=16'b0;	
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
	wire [8:0] MAR_data_out;
	wire [31:0] IR_data_out;
	wire [31:0] C_sign_extended;
	wire [63:0] C_data_out;
	wire [31:0] Input_Port_dataout;
	wire [4:0]  bus_encoder_signal;
	wire con_out;
	
	encoder_32_to_5 busEncoder({{8{1'b0}},Cout,InPortout,MDRout,PCout,ZLowout,ZHighout,LOout,HIout,Rout}, bus_encoder_signal);
 
   // Creating all 32-bit registers
	assign R0_data_out = {32{!Baout}} & BusMuxInR0_to_AND;
	reg_32_bits R0(clk, rst, enableR[0], bus_contents, BusMuxInR0_to_AND); 
	reg_32_bits R1(clk, rst, enableR[1], bus_contents, R1_data_out);
	reg_32_bits R2(clk, rst, enableR[2], bus_contents, R2_data_out);
	reg_32_bits R3(clk, rst, enableR[3], bus_contents, R3_data_out);
	reg_32_bits R4(clk, rst, enableR[4], bus_contents, R4_data_out);
	reg_32_bits R5(clk, rst, enableR[5], bus_contents, R5_data_out);
	reg_32_bits R6(clk, rst, enableR[6], bus_contents, R6_data_out);
	reg_32_bits R7(clk, rst, enableR[7], bus_contents, R7_data_out);
	reg_32_bits R8(clk, rst, enableR[8], bus_contents, R8_data_out);
	reg_32_bits R9(clk, rst, enableR[9], bus_contents, R9_data_out);
	reg_32_bits R10(clk, rst, enableR[10], bus_contents, R10_data_out);
	reg_32_bits R11(clk, rst, enableR[11], bus_contents, R11_data_out);
	reg_32_bits R12(clk, rst, enableR[12], bus_contents, R12_data_out);
	reg_32_bits R13(clk, rst, enableR[13], bus_contents, R13_data_out);
	reg_32_bits R14(clk, rst, enableR[14], bus_contents, R14_data_out);
	reg_32_bits R15(clk, rst, enableR[15], bus_contents, R15_data_out);
	
	reg_32_bits Y(clk, rst, Yin, bus_contents, Y_data_out);
	reg_32_bits HI_reg(clk, rst, HIin, bus_contents, HI_data_out);
	reg_32_bits LO_reg(clk, rst, LOin, bus_contents, LO_data_out);
	reg_32_bits ZHigh_reg(clk, rst, ZHighIn, C_data_out[63:32], ZHigh_data_out);	
	reg_32_bits ZLow_reg(clk, rst, ZLowIn, C_data_out[31:0], ZLow_data_out);
	
	reg_32_bits input_port(clk,rst,1'd1,InPort_input, Input_Port_dataout);
	reg_32_bits output_port(clk,rst,enableOutputPort, bus_contents, OutPort_output);
	
	IncPC_32_bit PC_reg(clk, IncPC, PCin, bus_contents, PC_data_out);
	
	reg_32_bits IR(clk, rst, IRin, bus_contents, IR_data_out);
	select_encode_logic IRlogic(IR_data_out, GRA, GRB, GRC, R_in, R_out, Baout, operation, C_sign_extended, enableR_IR, Rout_IR, decoder_in);
	
	conff_logic conff1(IR_data_out[20:19], bus_contents, enableCon, con_out);
	
	wire [31:0] MDR_mux_out;	
	// Multiplexer used to select an input for the MDR
	mux_2_to_1 MDMux(bus_contents, RAM_data_out, Read, MDR_mux_out);			
	// Instatiating the MDR register
	reg_32_bits MDR_reg(clk, rst, MDRin, MDR_mux_out, MDR_data_out);
	
	// Instatiating the MAR register
	mar_unit MAR(clk, rst, MARin, bus_contents, MAR_data_out);
	
	memoryRam	memoryRam_inst (
	.address ( MAR_data_out ),
	.clock ( clk ),
	.data ( MDR_data_out ),
	.wren ( RAM_write_en ),
	.q ( RAM_data_out )
	);
	
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
		.BusMuxIn_InPort(Input_Port_dataout),
		.C_sign_extended(C_sign_extended),
		.BusMuxOut(bus_contents),
		.select_signal(bus_encoder_signal)
		);

	//instantiate alu
	alu the_alu(
	.clk(clk),
	.clear(rst), 
	.A_reg(bus_contents),
	.B_reg(bus_contents),
	.Y_reg(Y_data_out),
	.opcode(operation),
	.branch_flag(con_out),
	.IncPC(IncPC),
	.C_reg(C_data_out)
	);
	
	//instantiate the control unit
	control_unit the_control_unit(
		.PCout(PCout),
		.ZHighout(ZHighout),
		.ZLowout(ZLowout),
		.MDRout(MDRout),
		.MAR_enable(MARin),
		.PC_enable(PCin),
		.MDR_enable(MDRin),
		.IR_enable(IRin),
		.Y_enable(Yin),
		.IncPC(IncPC),
		.MDR_read(Read),
		.HIin(HIin),
		.LOin(LOin),
		.HIout(HIout),
		.LOout(LOout),
		.ZHighIn(ZHighIn),
		.ZLowIn(ZLowIn),
		.Cout(Cout),
		.RAM_write(RAM_write_en),
		.Gra(GRA),
		.Grb(GRB),
		.Grc(GRC),
		.R_enable(R_in),
		.Rout(R_out),
		.BAout(Baout),
		.CON_enable(enableCon),
		.enableInputPort(enableInputPort),
		.OutPort_enable(enableOutputPort),
		.InPortout(InPortout),
		.Run(Run),
		.R_enableIn(R_enableIn),
		.IR(IR_data_out),
		.Clock(clk),
		.Reset(rst),
		.Stop(stop)
	);
endmodule
