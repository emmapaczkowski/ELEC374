`timescale 1ns/10ps

module ldi_tb;
	reg clk, clr;
	reg IncPC, CON_enable;
	reg [31:0] Mdatain;
	wire [31:0] bus_contents;
	reg RAM_write, MDR_enable, MDRout, MAR_enable, IR_enable;
	reg MDR_read;
	reg R_enable, Rout;
	reg [15:0] R0_R15_enable, R0_R15_out;
	reg Gra, Grb, Grc;
	reg HI_enable, LO_enable, ZHighIn, ZLowIn, Y_enable, PC_enable, InPort_enable, OutPort_enable;
	reg InPortout, PCout, Yout, ZLowout, ZHighout, LOout, HIout, BAout, Cout;
	wire [4:0] opcode;
	wire[31:0] OutPort_output;
	reg [31:0] InPort_input;
	
	parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011, Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
	reg [3:0] Present_state = Default;

CPUproject DUT(	
	.PCout(PCout),          	
	.ZHighout(ZHighout),
	.ZLowout(ZLowout),  
	.MDRout(MDRout), 
	.MARin(MAR_enable), 
	.MDRin(MDR_enable),   	
	.PCin(PC_enable), 
	.IRin(IR_enable),
	.Yin(Y_enable), 
	.IncPC(IncPC),
	.Read(MDR_read),
   .clk(clk),
	.MDatain(Mdatain), 	
	.clr(clr),                       
	.HIin(HI_enable),                                
	.LOin(LO_enable),
	.HIout(HIout), 
	.LOout(LOout),                		
	.ZHighIn(ZHighIn),
	.ZLowIn(ZLowIn),
	.Cout(Cout),
	.RAM_write_en(RAM_write),
	.GRA(Gra),								
	.GRB(Grb),                       
	.GRC(Grc), 
	.R_in(R_enable),
	.R_out(Rout),	
	.Baout(BAout),
	.enableCon(CON_enable),
	.R_enableIn(R0_R15_enable), 
	.Rout_in(R0_R15_out),
	.enableInputPort(InPort_enable),
	.enableOutputPort(OutPort_enable),
	.InPortout(InPortout), 
	.InPort_input(InPort_input),
	.OutPort_output(OutPort_output),
	.bus_contents(bus_contents),
	.operation(opcode)                  	
);


initial
	begin
		clk = 0;
		clr = 0;
end

always
		#10 clk <= ~clk;

always @(posedge clk) 
	begin
		case (Present_state)
			Default			:	#40 Present_state = Reg_load1a;
			Reg_load1a		:	#40 Present_state = Reg_load1b;
			Reg_load1b		:	#40 Present_state = Reg_load2a;
			Reg_load2a		:	#40 Present_state = Reg_load2b;
			Reg_load2b		:	#40 Present_state = Reg_load3a;
			Reg_load3a		:	#40 Present_state = Reg_load3b;
			Reg_load3b		:	#40 Present_state = T0;
			T0					:	#40 Present_state = T1;
			T1					:	#40 Present_state = T2;
			T2					:	#40 Present_state = T3;
			T3					:	#40 Present_state = T4;
			T4					:	#40 Present_state = T5;
		endcase
end

always @(Present_state) 
	begin
	#10
		ccase (Present_state)
			Default			:	#40 Present_state = T0;
			T0					:	#40 Present_state = T1;
			T1					:	#40 Present_state = T2;
			T2					:	#20 Present_state = T3;
			T3					:	#40 Present_state = T4;
		endcase						
			//first test: (ldi r1, 7). Instruction is 08800007
			//second test: ldi r1, 2(r2), where r2 is 2 and address 4 has 15. Instruction is 08900002.
T0: begin 
	PCout <= 1; MAR_enable <= 1; 
end

T1: begin //Loads MDR from RAM output
		PCout <= 0; MAR_enable <= 0;  
		MDR_enable <= 1; MDR_read<=1; ZLowout <= 1; 
end

T2: begin
	MDR_enable <= 0; MDR_read<=0;ZLowout <= 0; 
	MDRout <= 1; IR_enable <= 1; PC_enable <= 1; IncPC <= 1;			
end

T3: begin
	MDRout <= 0; IR_enable <= 0;			
	Grb<=1;BAout<=1;Y_enable<=1;
end

T4: begin
	Grb<=0;BAout<=0;Y_enable<=0;
	Cout<=1;ZHighIn <= 1;  ZLowIn <= 1;
end

T5: begin
	Cout<=0; ZHighIn <= 0;  ZLowIn <= 0;
	ZLowout <= 1;Gra<=1;R_enable<=1;
	#40 ZLowout <= 0;Gra<=1;Rout<=1;R_enable<=0;
end

endcase

end

endmodule
