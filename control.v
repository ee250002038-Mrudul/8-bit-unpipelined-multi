`timescale 1ns / 1ps

module control(
input clk, reset,
input [23:0] instruction,
input zero_flag, sign_flag,
output reg pc_write_enable, reg_write_enable, mem_write_enable, mem_to_reg, alu_src,
output reg [1:0] pc_src, 
output reg ir_write_1,ir_write_2,ir_write_3,
output reg [2:0] alu_control
    );
    
    reg [3:0] next_state, current_state;
    
    localparam FETCH1   = 4'b0000;
    localparam DECODE   = 4'b0001;
    localparam FETCH2   = 4'b0010;
    localparam FETCH3   = 4'b0011;
    localparam EXECUTE  = 4'b0100;
    localparam MEMORY   = 4'b0101;
    localparam WRITEBACK = 4'b0110;
    
    localparam LOAD  = 5'b00001;
    localparam STORE = 5'b00010;
    localparam ADDI = 5'b00011;
    localparam NOP = 5'b00000;
    localparam PUSH = 5'b00100;
    localparam POP = 5'b00101;
    localparam CALL = 5'b00110;
    localparam RET = 5'b00111;
    localparam ADD = 5'b01000;
    localparam SUB = 5'b01001;
    localparam AND = 5'b01010;
    localparam OR = 5'b01011;
    localparam XOR = 5'b01100;
    localparam SLL = 5'b01101;
    localparam JMP = 5'b01110;
    localparam HLT = 5'b11111;
    localparam JMPI = 5'b01111;
    localparam BEQ = 5'b10000;
    localparam BNE = 5'b10001;
    localparam BLT = 5'b10010;
    
    always @(posedge clk)
        begin
         if (reset ==1) 
            current_state <= FETCH1;
         else 
            current_state <= next_state;   
        end 
    
        always @(*)
            begin
                if(instruction[23:19] == ADDI || instruction[23:19] == LOAD || instruction[23:19] == STORE)
                    alu_src = 1'b1;
                else
                    alu_src = 1'b0;
                    
                 pc_write_enable = 0;
                 reg_write_enable = 0;
                 mem_write_enable = 0;
                 ir_write_1 = 0;
                 ir_write_2 = 0;
                 ir_write_3 = 0;
                 mem_to_reg = 0;
                 
                 pc_src = 2'b00; 
                
                case(current_state)
                    FETCH1: begin
                                pc_write_enable = 1;
                                ir_write_1 = 1;
                                next_state = DECODE;
                            end
                            
                    DECODE: begin
                                case(instruction[23:19])
                                  NOP,PUSH,POP,CALL,RET,JMP,HLT: next_state = EXECUTE;
                                  default: next_state = FETCH2;
                                  endcase
                            end
                            
                    FETCH2:begin
                            ir_write_2 = 1;
                            pc_write_enable = 1;
                                case(instruction[23:19])
                                    ADD,SUB,AND,OR,XOR,SLL: next_state = EXECUTE;
                                    default: next_state = FETCH3;
                                    endcase
                            end 
                            
                    FETCH3: begin
                                ir_write_3 = 1;
                                 pc_write_enable = 1;
                                next_state = EXECUTE;
                            end
                            
                    EXECUTE: begin
                                case (instruction [23:19])
                                    ADD: alu_control = 3'b000;
                                    ADDI: alu_control = 3'b000;
                                    LOAD: alu_control = 3'b000;
                                    STORE: alu_control = 3'b000;
                                    SUB: alu_control = 3'b001;
                                    BEQ: alu_control = 3'b001;
                                    BNE: alu_control = 3'b001;
                                    BLT: alu_control = 3'b001;
                                    AND: alu_control = 3'b010;
                                    OR: alu_control = 3'b011;
                                    XOR: alu_control = 3'b100;
                                    SLL: alu_control = 3'b101;
                       
                                     default: alu_control = 3'b000;
                                endcase
                                next_state = MEMORY; 
                             end
                             
                    MEMORY: begin
                                case(instruction[23:19])
                                    STORE: begin  
                                                mem_write_enable = 1;
                                                next_state = FETCH1;
                                            end 
                                            
                                    JMP: begin 
                                            pc_src = 2'b10;       
                                            pc_write_enable = 1;  
                                            next_state = FETCH1;
                                         end
                                         
                                    JMPI: begin
                                            pc_src = 2'b11;       
                                            pc_write_enable = 1;  
                                            next_state = FETCH1;
                                          end
                                          
                                    BEQ: begin
                                            if (zero_flag == 1'b1) begin
                                                pc_src = 2'b01;       
                                                pc_write_enable = 1;  
                                            end
                                            next_state = FETCH1;
                                         end   
                                         
                                    BNE: begin
                                            if (zero_flag == 1'b0) begin
                                                pc_src = 2'b01;
                                                pc_write_enable = 1;
                                            end
                                            next_state = FETCH1;
                                         end
                                         
                                    BLT: begin
                                            if (sign_flag == 1'b1) begin 
                                                pc_src = 2'b01;
                                                pc_write_enable = 1;
                                            end
                                            next_state = FETCH1;
                                         end
                                         
                                     default: next_state = WRITEBACK;       
                                 endcase
                            end
                            
                    WRITEBACK: begin
                                  reg_write_enable = 1;
                                  if (instruction[23:19] == LOAD) begin
                                       mem_to_reg = 1;
                                   end
                                  next_state = FETCH1;
                                end   
                     default: begin
                                next_state = FETCH1;
                                end
                                
                   endcase
                    
            end 
endmodule
