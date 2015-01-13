`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//					
// Engineer: Gabe Harms
// Module Name:  arithmetic_logic_unit.v 
// Description:	ALU which handles ANDs, ORs, XORs, NORs, addition, subtraction and shifting operations with overflow detections
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module arithmetic_logic_unit

(
    control,	//specifies the alu operation
    operand0, 	//first operand
    operand1, 	//second operand
    result, 	//alu result
	overflow,	//overflow flag (underflow as well)
    zero 		//zero flag
);

    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 		[3:0]	control;
	input 		[31:0] 	operand0; 
	input		[31:0]	operand1;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output reg	[31:0] 	result; 
	output reg			overflow;
	output reg			zero;
	
	always @( * )
	begin
	case (control)
		4'b0000 : result <= operand0 & operand1; 						//AND
		4'b0001 : result <= operand0 | operand1; 						//OR
		4'b0010 : result <= operand0 + operand1;							//add
		4'b0011 : result <= operand0 ^ operand1; 						//XOR
		4'b0100 : result <= operand0 |~ operand1;							//NOR
		4'b0110 : result <= operand0 - operand1; 						//subtract
		4'b0111 : result <= (operand0 <= operand1) ? 31'd1 : 31'b0; 		//slt
		4'b1000 : result <= operand0 << operand1;						//shift left
		4'b1001 : result <= operand0 >> operand1;						//shift right
		4'b0010 : result <= operand0 >>>operand1;						//shift right arithmatic
	endcase
		if (result >= 4294967295) 										// take care of overflow bit
			overflow = 1;
		else
			overflow = 0;
			
		if (result == 0)												// take care of zero bit
			zero = 1;
		else 
			zero = 0;
	end
 endmodule  



