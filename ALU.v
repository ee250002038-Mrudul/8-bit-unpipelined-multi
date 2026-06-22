`timescale 1ns / 1ps

module alu (
   
    input  wire [7:0] input_A,      
    input  wire [7:0] input_B,      
    input  wire [2:0] alu_control,   
    output reg  [7:0] alu_result,   
    output reg        zero_flag,    
    output reg        sign_flag
);

    always @(*)
     begin
     
        alu_result = 8'b00000000;
        zero_flag  = 1'b0;
        sign_flag  = 1'b0;

        
        case(alu_control)
            3'b000: alu_result = input_A + input_B;         
            3'b001: alu_result = input_A - input_B;         
            3'b010: alu_result = input_A & input_B;         
            3'b011: alu_result = input_A | input_B;         
            3'b100: alu_result = input_A ^ input_B;         
            3'b101: alu_result = input_A << input_B[2:0];   
            
            default: alu_result = 8'b00000000;              
        endcase
        
        if (alu_result == 8'b00000000)
         begin
            zero_flag = 1'b1;
        end
               
        sign_flag = alu_result[7];
    end

endmodule