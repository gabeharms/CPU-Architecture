`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  control_unit.v 
// Description:	Sends out control signals to other modules, based on the input instruction
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit
(
	instruction_in,
	alu_zero,
	reg_file_wren,
	reg_file_dmux_select,
	reg_file_rmux_select,
	alu_mux_select,
	alu_control,
	data_mem_wren,
	pc_control
);
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 		[31:0]		instruction_in;
	input 					alu_zero; 
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	reg	[3:0]		data_mem_wren;
	output	reg				reg_file_wren;
	output	reg				reg_file_dmux_select;
	output	reg				reg_file_rmux_select;
	output	reg				alu_mux_select;
	output	reg	[3:0]		alu_control;
	output	reg	[2:0]		pc_control;
    
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
	wire     [  2:0]    type;
	wire     [ 25:0]	address;	
    wire     [ 15:0]	immediate;	
	wire     [  5:0]    op;         	
    wire     [  4:0]    rs;   		
    wire     [  4:0]    rt;   		
    wire     [  4:0]    rd;   		
    wire     [  4:0]    shamt;		
    wire     [  5:0]    funct;		

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
		assign    type = (instruction_in[31:26] ==  0) ? 3'b001 : //R
					 (instruction_in[31:26] ==  2) ? 3'b100 : //J
					 (instruction_in[31:26] ==  3) ? 3'b100 : //J
					 (instruction_in[31:26] ==  4) ? 3'b010 : //I
					 (instruction_in[31:26] ==  5) ? 3'b010 : //I
					 (instruction_in[31:26] ==  8) ? 3'b010 : //I
					 (instruction_in[31:26] ==  9) ? 3'b010 : //I
					 (instruction_in[31:26] == 10) ? 3'b010 : //I 0xA
					 (instruction_in[31:26] == 12) ? 3'b010 : //I 0xC
					 (instruction_in[31:26] == 13) ? 3'b010 : //I 0xD
					 (instruction_in[31:26] == 15) ? 3'b010 : //I 0xF
					 (instruction_in[31:26] == 32) ? 3'b010 : //I 0x20
					 (instruction_in[31:26] == 33) ? 3'b010 : //I 0x21
					 (instruction_in[31:26] == 35) ? 3'b010 : //I 0x23
					 (instruction_in[31:26] == 36) ? 3'b010 : //I 0x24
					 (instruction_in[31:26] == 37) ? 3'b010 : //I 0x25
					 (instruction_in[31:26] == 40) ? 3'b010 : //I 0x28
					 (instruction_in[31:26] == 41) ? 3'b010 : //I 0x29
					 (instruction_in[31:26] == 43) ? 3'b010 : //I 0x2B
					                                 3'b000 ; //Undefined
											
	
	assign address		= (type == 3'b100) ? instruction_in[25: 0] : 26'b0;
	assign immediate	= (type == 3'b010) ? instruction_in[15: 0] : 16'b0;    
	assign op          	= (type >  3'b000) ? instruction_in[31:26] :  6'b0;		
	assign rs   		= (type <  3'b100) ? instruction_in[25:21] :  5'b0;
	assign rt   		= (type <  3'b100) ? instruction_in[20:16] :  5'b0;
	assign rd   		= (type == 3'b001) ? instruction_in[15:11] :  5'b0;
	assign shamt		= (type == 3'b001) ? instruction_in[10: 6] :  5'b0;
	assign funct		= (type == 3'b001) ? instruction_in[ 5: 0] :  6'b0;	
	
    always @(instruction_in)
    begin
	
	    case(op)
		
		    0:
		    begin
    		    
				case(funct)
				
				0:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Sll ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b1001;
				end
				
				2:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Srl ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b1000;
				end
				
				3:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Sra ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b1010;
				end
				
				8:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Jr  ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0010; //WARNING: SET TO ADD. DON'T UNDERSTAND WHAT TO DO WITH THIS
				end
				
				16:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Mfhi ", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				18:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Mflo ", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				24:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Mult ", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				25:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Multu", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				26:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Div ", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				27:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Divu ", op, rs, rt, rd, shamt, funct);
					//INSTRUCTION NOT SUPPORTED
				end
				
				32:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Add ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0010; 
				end
				
				33:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Addu ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0010;
				end
				
				34:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Sub ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0110;
				end
				
				35:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, "Subu ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0110;
				end
				
				36:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " And ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0000;
				end
				
				37:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Or  ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0001;
				end
				
				38:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Xor ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0011;
				end
				
				39:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Nor ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0100;
				end
				
				42:
				begin
				    $display("TIME = <%d> : TYPE = R : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : RD = <%d> : SHAMT = <%d> : FUNCT = <%d>", $time, " Slt ", op, rs, rt, rd, shamt, funct);
					alu_control = 4'b0111;
				end
			
				//default :
			    //begin
			        //$display("Undefined");
			    //end
				
				endcase
				
				if (funct == 8)								//as long as not JR instruction set PC+4 and reg_file_wren to true
				begin
				    pc_control 		= 3'b010;
					reg_file_wren	=  0;
				end
				else
				begin
					pc_control 		= 3'b000;				//all r types except for jr instruction set PC to PC+4
					reg_file_wren	=   1;				//all r types except for jr instuction write the to the register file
				end
				
				reg_file_rmux_select =  1;				//r type uses rd register to write to so choose 1 from mux
				alu_mux_select 	 	 =  0;				//all r types use the register file as the second operand to the alu								
				
				
			end
			
			2:
		    begin
    		    $display("TIME = <%d> : TYPE = J : INSTRUCTION = <%s> :OPCODE = <%d> : Address = <%d>", $time, "  J  ", op, address);
				pc_control 			 = 3'b001;
				reg_file_wren 		 =  1;	
				alu_control = 4'b0010; //WARNING: SET TO ADD	
	    	end
			
			3:
		    begin
    		    $display("TIME = <%d> : TYPE = J : INSTRUCTION = <%s> :OPCODE = <%d> : Address = <%d>", $time, " Jal ", op, address);
				pc_control 			= 3'b001;
				reg_file_wren 		=   1;	
				alu_control = 4'b0010; //WARNING: SET TO ADD
	    	end
			
			4:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Beq ", op, rs, rt, immediate);
				pc_control 			 = 3'b011;
				reg_file_wren 		 =  0;	
				alu_control = 4'b0110; //subtract right?
	    	end
			
			5:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Bne ", op, rs, rt, immediate);
				pc_control 			 = 3'b011;
				reg_file_wren 		 =  0;	
				alu_control = 4'b0110; //subtract right?
	    	end
			
			8:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, "Addi ", op, rs, rt, immediate);
				pc_control			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0010;
	    	end
			
			9:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, "Addiu", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0010;
	    	end
			
			10:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, "Slti ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0111;
	    	end
			
			12:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, "Andi ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0000;
	    	end
			
			13:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Ori ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0001;
	    	end
			
			15:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lui ", op, rs, rt, immediate);
				//INSTRUCTION NOT SUPPORTED
	    	end
			
			32:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lb  ", op, rs, rt, immediate);
				//INSTRUCTION NOT SUPPORTED
	    	end
			
			33:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lh  ", op, rs, rt, immediate);
				//INSTRUCTION NOT SUPPORTED
	    	end
			
			35:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lw  ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =   1;	
				alu_control = 4'b0010; //DFAULT: DOESN'T USE ALU
				
	    	end
			
			36:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lbu ", op, rs, rt, immediate);
				//INSTRUCTION NOT SUPPORTED
	    	end
			
			37:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Lhu ", op, rs, rt, immediate);
				//INSTRUCTION NOT SUPPORTED
			end
			40:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Sb  ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =  0;	
				alu_control = 4'b0010; //DEFAULT: DOESN'T USE ALU
				data_mem_wren 		 = 4'b0001;
	    	end
			
			41:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Sh  ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =  0;	
				alu_control = 4'b0010; //DEFAULT: DOESN'T USE ALU
				data_mem_wren 		 = 4'b0011;
	    	end
			
			43:
		    begin
    		    $display("TIME = <%d> : TYPE = I : INSTRUCTION = <%s> :OPCODE = <%d> : RS = <%d> : RT = <%d> : Immediate = <%d>", $time, " Sw  ", op, rs, rt, immediate);
				pc_control 			 = 3'b000;
				reg_file_wren 		 =  0;	
				alu_control = 4'b0010; //DEFAULT: DOESN'T USE ALU
				data_mem_wren 		 = 4'b1111;
	    	end
			
			//default :
			//begin
			    
			//end
			
			
			
		endcase
			
		reg_file_rmux_select = 0;					//immediate type uses rt register for address so choose 0 from mux
		alu_mux_select = 1; 							//all j and r types have an immediate field which it uses as the second operand in the alu
	
	
    
		if (funct < 40)
			data_mem_wren 		 = 4'b0000;			  //only store functions write to memory everything else does not
		
		if (funct == 35)
			reg_file_dmux_select = 0;
		else
			reg_file_dmux_select = 1; 			//only reads from data memory on lw else it uses result of alu
			
	end	
	
endmodule  
  
	




