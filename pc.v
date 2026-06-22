`timescale 1ns / 1ps

module pc(
    input wire clk, reset, pc_write_enable,
    input wire [7:0] pc_in,
    output reg [7:0] pc_out
    );
        always @(posedge clk)
            begin
                if (reset == 1)
                    pc_out <= 8'b00000000;
                else if (pc_write_enable == 1)
                    pc_out <= pc_in;                                        
            end
    
endmodule
