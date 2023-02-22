//////////////////////////////////////////////////////////////////////////////////
// Company:        
// Engineer:       
// Create Date:    
// Design Name:    
// Module Name:    cutoff
// Project Name:   
// Target Devices: 
// Tool versions:  
// Description: 
//
// Dependencies:   
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module cutoff#(
    parameter input_width        = 20,
    parameter output_width       = 8,
    parameter radix_point_right  = 8
    )( 
    input wire  clk,        // clock signal
    input wire  rst_n,      // reset signal 
    input wire  [input_width  - 1 : 0] data_in, 
    output reg  [output_width - 1 : 0] data_out
    );

// tmp[12:1] = data_in[19:8], integer part
// tmp[0] = round(data_in[8]), fractional part
reg[11:0] tmp = 12'b0;
reg carry = 1'b0;
integer i;
reg sum = 1'b0;
//reg transfer = 1'b0;

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		data_out[7:0] <= 8'b0;
	else
		data_out[7:0] <= tmp[7:0];
end

always @(*)
begin
	tmp[11:0] = data_in[19:8];
	// round if data_in[7] == 1
	if (data_in[7] == 1'b1)
	begin	
		carry = 1'b1;
		for (i = 0; i < 11; i = i + 1)
		begin
			sum = tmp[i] ^ carry;
			carry = tmp[i] & carry;
			tmp[i] = sum;
		end
	end
	// negative overflow
	if (tmp[11] == 1'b1 && carry == 1'b1)
		tmp[7:0] = 8'b11111111;
	// positive saturation
	if (tmp[11] == 1'b0 && tmp[11:9] != 3'b000)
		tmp[7:0] = 8'b01111111;
	// negative saturation
	if (tmp[11] == 1'b1 && tmp[11:9] != 3'b111)
		tmp[7:0] = 8'b11111111;
end
endmodule