//alu
//opcodes
//0000:add , 0001:sub, 0010:and, 0011:or, 0100:xor,0101:nor
//0110:sll, 0111:srl, 1000sra, 1001:slt, 1010:pass_a, 1011:pass_b
`timescale 1ps/1ns
module alu#(
    parameter integer WIDTH = 8
)(
    input wire [WIDTH-1:0] A,
    input wire [WIDTH-1:0] B,
    input wire [3:0] SEL,
    input wire EN,
    input wire CLK,
    output reg Z,
    output reg O,
    output reg C,
    output reg N,
    output reg [WIDTH-1:0] Y
);
wire do_add = (SEL == 4'b0000);
wire do_sub = (SEL == 4'b0001);
wire do_and = (SEL == 4'b0010);
wire do_or = (SEl == 4'b0011);
wire do_xor = (SEL == 4'b0100);
wire do_nor = (SEL == 4'b0101);
wire do_sll = (SEL == 4'b0110);
wire do_srl = (SEL == 4'b0111);
wire do_sra = (SEL == 4'b1000);
wire do_slt = (SEL == 4'b1001);
wire do_a = (SEL == 4'b1010);
wire do_b = (SEL == 4'b1011);
endmodule