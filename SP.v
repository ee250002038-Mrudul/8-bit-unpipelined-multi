`timescale 1ns / 1ps

module SP(
    input clk, reset,sp_enable_add,sp_enable_sub,
    output reg [7:0] SP_address
    );
    
    always @(posedge clk)
    begin
    if (reset) begin
        SP_address <= 8'd255; // Start at the very top of memory
    end
    else if (sp_enable_add == 1) begin
        SP_address <= SP_address + 1'b1;
    end
     else if (sp_enable_sub ==1) begin
        SP_address <= SP_address - 1'b1;
     end

    end
endmodule
