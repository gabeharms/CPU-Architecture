`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  instruction_memory.v 
// Description:	Memory containing all of the instructions
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module instruction_memory

(
	address,
	instruction
);
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input		[31:0]	address;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	reg [31:0] 	instruction;
		
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
    reg	[31:0] instruction_memory	[255:0];
	
	initial
	begin
		$readmemh("program.mips",instruction_memory);
	end
	
	always @ ( * )
	begin
	instruction = instruction_memory[address[9:2]];
	end
	
 endmodule  



