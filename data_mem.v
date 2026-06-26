`timescale 1ns / 1ps

module data_mem(
input clk, mem_write_enable,
input reset,
input [7:0] address, write_data,
output wire [7:0] read_data
 );
    
    reg [7:0] RAM [0:255];
    
    assign read_data = RAM[address];
        
    always @(posedge clk)
        begin
            if (mem_write_enable ==1)
                    RAM[address] <= write_data;
        end
endmodule
