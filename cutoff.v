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
// Revision: |1|4|7|8|
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
    reg signed [11:0] temp = 8'h0;
    
    always @(*) begin
        if (data_in[7]==1) begin
            temp = data_in[19:8]+1;
        end
        else begin
            temp = data_in[19:8];
        end 
    end

    always @(posedge clk) begin
        if (temp[11]==0) begin
            if (temp[10:7]!=4'h0)begin
                data_out <= 8'h7f;
            end
            else begin
                data_out[6:0] <= temp[6:0];
                data_out[7] <= temp[11];
            end
        end else begin
            if (temp[10:7]!=4'hf)begin
                data_out <= 8'h80;
            end
            else begin
                data_out[6:0] <= temp[6:0];
                data_out[7] <= temp[11];
            end
        end
        end
    end

endmodule

//这部分代码得到了和助教原来给出的答案一样的错误结果
// always @(*) begin
    //     if (data_in[19]==1'b0) begin
    //         if (!(data_in[15]==1'b0) || !(data_in[16]==1'b0) || !(data_in[17]==1'b0)|| !(data_in[18]==1'b0)) begin
    //             temp <= 8'h7f;
    //         end
    //         else 
    //         begin
    //             if (data_in[7] == 1'b0) 
    //             begin
    //                 temp[6:0] <= data_in[14:8];
    //                 temp[7] <= 1'b0;
    //             end
    //             else 
    //             begin
    //                 temp[6:0] <= data_in[14:8] + 1;
    //                 temp[7] <= 1'b0;
    //             end
    //         end
    //     end 
    //     else begin
    //         if (!(data_in[15]==1) || !(data_in[16]==1)|| !(data_in[17]==1)|| !(data_in[18]==1)) begin
    //             temp <= 8'hff;
    //         end
    //         else begin
    //             if (data_in[7] == 0) begin
    //                 temp[6:0] <= data_in[14:8];
    //                 temp[7] <= 1'b1;
    //             end
    //             else begin
    //                 temp[6:0] <= data_in[14:8] + 1;
    //                 temp[7] <= 1'b1;
    //             end
    //         end
    //     end
    // end