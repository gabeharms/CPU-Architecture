`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  cpu.v 
// Description:	The top module of the entire CPU
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cpu
(
	clk,
	rst
);	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 					clk;
	input 					rst;
	
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
	//Program Counter
	reg				[31:0]					pc;
	//Instruction Memory
	reg				[31:0]	  	   instruction;
	//Control Unit
	reg  			[ 2:0]			pc_control;
	reg					  reg_file_rmux_select;
	reg				[ 3:0]			 reg_file_wren;
	reg							alu_mux_select;
	reg							   alu_control;
	reg				[ 3:0]		 data_mem_wren;
	reg					  reg_file_dmux_select;
	//Register File
	reg				[31:0]				rdata0;
	reg				[31:0]				rdata1;
	//ALU
	reg				[31:0] 				result;
	reg								  overflow;
	reg									  zero;
	//Data Memory
	reg				[31:0]				 rdata;
	//Mux 1
	reg				[ 4:0]				 waddr;
	//Mux 2
	reg				[31:0]				 wdata;
	//Mux 3
	reg				[31:0]			  operand1;
	//sign_extention
	reg				[31:0]				   out;
	

		
		program_counter 		PC 	(clk, rst, pc_control, instruction[25:0], instruction[15:0], rdata0, pc);
		
		instruction_memory		IM	(pc, instruction);
		
		control_unit			CU	(instruction, data_mem_wren, reg_file_wren, reg_file_dmux_select, reg_file_rmux_select,	alu_mux_select, alu_control, zero, pc_control);
				
		mux_2to1_5bits			M1	(instruction[20:16], instruction[15:11], waddr, reg_file_rmux_select);
		
		mux_2to1				M2  (rdata, result, wdata, reg_file_dmux_select);
		
		register_file			RF	(clk, instruction[25:21], instruction[20:16], waddr, wdata, reg_file_wren, rdata0, rdata1);
		
		sign_extension			SE	(instruction[15:0], out);
		
		mux_2to1				M3  (rdata1, out, operand1, alu_mux_select);
		
		arithmetic_logic_unit 	ALU (alu_control, rdata0, operand1, result, overflow, zero);
		
		data_memory				DM	(clk, result, rdata1, data_mem_wren, rdata);
		
endmodule
