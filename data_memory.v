`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  data_memory.v 
// Description:	Memory that handles read and writes
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module data_memory

(
	clk,		//clock
	addr,
	rdata,
	wdata,
	wren
);

    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input				clk;
    input 		[31:0]	addr;
	input		[31:0]	wdata;
	input 		[3:0]	wren;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 		[31:0] 	rdata;
		
   
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
    reg	[7:0] memory_lane0	[65535:0];
	reg	[7:0] memory_lane1	[65535:0];
	reg	[7:0] memory_lane2	[65535:0];
	reg	[7:0] memory_lane3	[65535:0];
   
	assign rdata = {
						memory_lane3[addr[17:2]],
						memory_lane2[addr[17:2]],
						memory_lane1[addr[17:2]],
						memory_lane0[addr[17:2]]
					};
						
    always @(posedge clk)
	begin
		if (wren[0])
			memory_lane0[addr[17:2]] <= wdata[7:0];
			
		if (wren[1])
			memory_lane1[addr[17:2]] <= wdata[15:8];
			
		if (wren[2])
			memory_lane2[addr[17:2]] <= wdata[23:16];
			
		if (wren[3])
			memory_lane3[addr[17:2]] <= wdata[31:24];
	end
	
 endmodule  



