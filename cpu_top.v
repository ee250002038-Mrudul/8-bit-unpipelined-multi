`timescale 1ns / 1ps

module cpu(
    input clk, 
    input reset
);

    wire [23:0] instruction;
    wire pc_write_enable, reg_write_enable, mem_write_enable, mem_to_reg, alu_src;
    wire [1:0] pc_src;
    wire ir_write_1, ir_write_2, ir_write_3;
    wire [2:0] alu_control;
    wire zero_flag, sign_flag;
    wire sp_enable_add, sp_enable_sub;
    
    datapath DP (
        .clk(clk), .reset(reset),
        .pc_write_enable(pc_write_enable), .reg_write_enable(reg_write_enable),.alu_src(alu_src),
        .mem_write_enable(mem_write_enable), .mem_to_reg(mem_to_reg),
        .pc_src(pc_src),
        .ir_write_1(ir_write_1), .ir_write_2(ir_write_2), .ir_write_3(ir_write_3),
        .alu_control(alu_control),
        .zero_flag(zero_flag), .sign_flag(sign_flag),
        .instruction(instruction),
        .sp_enable_add(sp_enable_add), .sp_enable_sub(sp_enable_sub)
    );

    control CU (
        .clk(clk), .reset(reset),
        .instruction(instruction),
        .zero_flag(zero_flag), .sign_flag(sign_flag),
        .pc_write_enable(pc_write_enable), .reg_write_enable(reg_write_enable),.alu_src(alu_src),
        .mem_write_enable(mem_write_enable), .mem_to_reg(mem_to_reg),
        .pc_src(pc_src),
        .ir_write_1(ir_write_1), .ir_write_2(ir_write_2), .ir_write_3(ir_write_3),
        .alu_control(alu_control), .sp_enable_add(sp_enable_add), .sp_enable_sub(sp_enable_sub)
    );

endmodule
