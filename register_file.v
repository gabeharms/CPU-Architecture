`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  register_file.v 
// Description: Dual port memory that contains the contents of our registers
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module register_file
(
	clk,	//clock
	raddr0,
	rdata0,
	raddr1,
	rdata1,
	waddr,
	wdata,
	wren
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input					clk;
    input 		[4:0]		raddr0;
	input 		[4:0]		raddr1;
	input 		[4:0]		waddr;
	input		[31:0]		wdata;
	input 					wren;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 		[31:0] 	rdata0;
	output		[31:0]	rdata1;
		
    //--------------------------
    // Bidirectional Ports
    //--------------------------
    // < Enter Bidirectional Ports in Alphabetical Order >
    // None
      
    ///////////////////////////////////////////////////////////////////
    // Begin Design
    ///////////////////////////////////////////////////////////////////
    //-------------------------------------------------
    // Signal Declarations: local params
    //-------------------------------------------------
   
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
    reg	[31:0] reg_file	[31:0];
	
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	assign rdata0 = reg_file[raddr0];
	assign rdata1 = reg_file[raddr1];
	
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    always @(posedge clk)
	begin
		if (wren)
			reg_file[waddr] <= wdata;
	end
	
 endmodule  



