`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  program_counter.v 
// Description:	PC of the CPU
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module program_counter
(
	clk,	//clock
	rst,
	pc_control,
	jump_address,
	branch_offset,
	reg_address,
	pc
);

    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input						clk;
	input						rst;
	input				[2:0]	pc_control;
	input				[25:0]	jump_address;
	input				[15:0]	branch_offset;
	input				[31:0] 	reg_address;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	reg	[31:0] 	pc;
	
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
	wire	[31:0]	pc_plus_4;	

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	assign pc_plus_4 = pc + 4;
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			pc <= 32'd0;
		end
		else
		begin
			case (pc_control)
				3'b000 : pc <= pc_plus_4;
				3'b001 : pc <= {pc_plus_4[31:28],jump_address,2'b00};
				3'b010 : pc <= reg_address;
				3'b100 : pc <= (pc_plus_4) + {branch_offset[15:0], 16'd0};
				default : pc <= pc_plus_4;
			endcase
		end
	end
	
 endmodule  



