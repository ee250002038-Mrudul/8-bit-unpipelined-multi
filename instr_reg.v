`timescale 1ns / 1ps

module inst_reg(
    input clk,
    input ir_write_1, ir_write_2, ir_write_3,
    input [7:0] rom_data,
    output reg [23:0] full_instruction
);

    always @(posedge clk) begin
        if (ir_write_1 == 1'b1)
            full_instruction[23:16] <= rom_data;
            
        if (ir_write_2 == 1'b1)
            full_instruction[15:8] <= rom_data;
            
        if (ir_write_3 == 1'b1)
            full_instruction[7:0] <= rom_data;
    end

endmodule