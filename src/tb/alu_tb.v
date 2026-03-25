`timescale 1ns/1ps
module alu_tb;
parameter WIDTH = 8;
reg signed [WIDTH-1:0] A;
reg signed [WIDTH-1:0] B;
reg [3:0] SEL;
reg EN;
reg RST_N;
reg CLK;
wire Z;
wire O;
wire C;
wire N;
wire [WIDTH-1:0] Y;

alu#(
    .WIDTH(WIDTH)
)dut(
    .A(A),
    .B(B),
    .SEL(SEL),
    .EN(EN),
    .RST_N(RST_N),
    .CLK(CLK),
    .Z(Z),
    .O(O),
    .C(C),
    .N(N),
    .Y(Y)
);
initial begin
    CLK = 0;
end
always #5 CLK = ~CLK;
initial begin 
    $dumpfile("waveform/alu_op.vcd");
    $dumpvars(0,alu_tb);
    //initialize
    RST_N = 0;
    EN  = 0;
    A = 0;
    B = 0;
    SEL = 0;

    //rst
    #10
    RST_N = 1;
    EN  = 1;

    //add
    #10
    A = 8'd10;
    B = 8'd5;
    SEL = 4'b0000;

    //signed add
    #10
    A = $signed(-5);
    B = 8'd5;
    SEL = 4'b0000;

    //sub
    #10
    A = 8'd10;
    B = 8'd3;
    SEL = 4'b0001;

    //&
    #10
    A = 8'b10101010;
    B = 8'b11001100;
    SEL = 4'b0010;

    //or
    #10
    SEL = 4'b0011;

    //^
    #10
    SEL = 4'b0100;

    //nor
    #10
    SEL = 4'b0101;

    //sll
    #10
    A = 8'b00001111;
    B = 8'd2;
    SEL = 4'b0110;

    //srl
    #10
    SEL = 4'b0111;

    //sra
    #10
    A = 8'b10000000;
    B = 8'd2;
    SEL = 4'b1000;

    //slt
    #10
    A = $signed(-5);
    B = 3;
    SEL = 4'b1001;

    //pass a
    #10
    A = 8'd55;
    SEL = 4'b1010;

    //pass b
    #10
    B = 8'd77;
    SEL = 4'b1011;

    #10
    A = 8'h07;
    B = 8'h02;
    SEL = 4'b1100;

    #10
    A = 8'h08;
    B = 8'h02;
    SEL = 4'b1101;

    #10
    SEL = 4'b1111;

    #100

    $finish;
end
endmodule