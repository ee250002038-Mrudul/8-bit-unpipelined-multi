`timescale 1ns / 1ps
   
module reg_file(
input clk, reg_write_enable,
input [2:0] rs1_addr,rs2_addr, rd_addr,
input [7:0] write_data,
output [7:0] rs1_data, rs2_data
    );
        reg [7:0] memory [0:7];
           
               assign rs1_data = memory[rs1_addr];
               assign rs2_data = memory[rs2_addr];
         
     always @(posedge clk)
        begin
        if(reg_write_enable == 1)
            begin
             memory[rd_addr] <= write_data; 
           end
        end 
    
endmodule
