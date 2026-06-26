`timescale 1ns / 1ps

module instr_mem(
        input wire [7:0] pc_address,
        output wire [7:0] instruction
    );
        reg [7:0] ROM [0:255];
        assign instruction = ROM[pc_address];
        
        initial
         begin
            $readmemh ("program_out.hex", ROM);
         end
endmodule
