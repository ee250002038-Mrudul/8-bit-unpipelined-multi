`timescale 1ns / 1ps

module datapath(
    input clk, reset, pc_write_enable, reg_write_enable,mem_to_reg,mem_write_enable,alu_src,
    input ir_write_1,ir_write_2,ir_write_3,
    input [1:0] pc_src, 
    input [2:0] alu_control,
    output sign_flag, zero_flag,
    output [23:0] instruction
    );
    
        wire [7:0] pc_instmem;
        wire [7:0] write_data, rs1_data, rs2_data;
        wire [2:0] rs1_addr, rs2_addr, rd_addr;
        wire [7:0] alu_result;
        wire [7:0] mem_read_data;
        wire [7:0] rom_data;
        wire [7:0] pc_in;
        wire [7:0] imm;
        wire [7:0] actual_alu_input_b;
        wire [7:0] branch_target;
        
        assign write_data = (mem_to_reg == 1'b1) ? mem_read_data : alu_result;
        assign branch_target = pc_instmem + imm;
        
        assign pc_in = (pc_src == 2'b11) ? imm :
                       (pc_src == 2'b10) ? rs1_data :       
                       (pc_src == 2'b01) ? branch_target :        
                       (pc_instmem + 8'd1);                 
                       
        reg [2:0] decoded_rs1;
reg [2:0] decoded_rs2;


always @(*) begin

    decoded_rs1 = instruction[15:13]; 
    decoded_rs2 = instruction[12:10];

    case(instruction[23:19]) 
        5'b00100, 
        5'b00110, 
        5'b01110: decoded_rs1 = instruction[18:16];
         
        5'b00010,
        5'b10000, 
        5'b10001, 
        5'b10010: 
        begin
            decoded_rs1 = instruction[18:16];
            decoded_rs2 = instruction[15:13];
        end
    endcase
end

assign rs1_addr = decoded_rs1;
assign rs2_addr = decoded_rs2;

assign rd_addr  = instruction[18:16];
assign imm = instruction[7:0];
assign actual_alu_input_b = alu_src ? imm : rs2_data; 

    pc pcount(
    .clk(clk), .reset(reset), .pc_write_enable(pc_write_enable), .pc_in(pc_in), .pc_out(pc_instmem)
    );
    
    instr_mem imem(
    .pc_address(pc_instmem), .instruction(rom_data)
    );
    
   reg_file regi(
    .clk(clk), .reg_write_enable(reg_write_enable), .write_data(write_data),
     .rs1_data(rs1_data), .rs2_data(rs2_data), .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr)
    );
    
    alu aloo(
        .input_A(rs1_data), .input_B(actual_alu_input_b), .alu_result(alu_result),
         .sign_flag(sign_flag), .zero_flag(zero_flag), .alu_control(alu_control)
    );
    
    data_mem RAM(
        .clk(clk), .mem_write_enable(mem_write_enable), .address(alu_result), .write_data(rs2_data), .read_data(mem_read_data)
    );
    
    inst_reg IR(
    .clk(clk),
    .ir_write_1(ir_write_1), .ir_write_2(ir_write_2), .ir_write_3(ir_write_3),
    .rom_data(rom_data), 
    .full_instruction(instruction)
);
endmodule
