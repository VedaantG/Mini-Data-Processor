//alu
//opcodes
//0000:add , 0001:sub, 0010:and, 0011:or, 0100:xor,0101:nor
//0110:sll, 0111:srl, 1000sra, 1001:slt, 1010:pass_a, 1011:pass_b
`timescale 1ns/1ps
module alu#(
    parameter integer WIDTH = 8
)(
    input wire [WIDTH-1:0] A,
    input wire [WIDTH-1:0] B,
    input wire [3:0] SEL,
    input wire EN,
    input wire RST,
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
wire do_or = (SEL == 4'b0011);
wire do_xor = (SEL == 4'b0100);
wire do_nor = (SEL == 4'b0101);
wire do_sll = (SEL == 4'b0110);
wire do_srl = (SEL == 4'b0111);
wire do_sra = (SEL == 4'b1000);
wire do_slt = (SEL == 4'b1001);
wire do_a = (SEL == 4'b1010);
wire do_b = (SEL == 4'b1011);

wire [WIDTH-1:0] a_arith = (do_add | do_sub) ? A : {WIDTH{1'b0}};
wire [WIDTH-1:0] b_arith = (do_add | do_sub) ? (do_sub ? ~B : B) : {WIDTH{1'b0}};
wire [WIDTH-1:0] a_log = (do_and | do_or | do_nor | do_xor) ? A : {WIDTH{1'b0}};
wire [WIDTH-1:0] b_log = (do_and | do_or | do_nor | do_xor) ? B : {WIDTH{1'b0}};
wire [WIDTH-1:0] a_sh = (do_sll | do_srl | do_sra) ? A : {WIDTH{1'b0}};
wire [WIDTH-1:0] b_sh = (do_sll | do_srl | do_sra) ? B : {WIDTH{1'b0}};
wire cin = do_sub ? 1'b1 : 1'b0;
reg cout;
wire [$clog2(WIDTH)-1:0] shamt = b_sh[$clog2(WIDTH)-1:0];

reg [WIDTH-1:0] y_next;
reg z;
reg o;
reg c;
reg n;
always @(*) begin
    cout = 1'b0;
    y_next = {WIDTH{1'b0}};
    if (do_add || do_sub) begin 
         {cout,y_next} = a_arith + b_arith + cin;
    end
    else if (do_and) begin
         y_next = a_log & b_log;
    end
    else if (do_or) begin
         y_next = a_log | b_log;
    end
    else if (do_xor) begin
         y_next = a_log ^ b_log;
    end
    else if (do_nor) begin
         y_next = ~(a_log | b_log);
    end
    else if (do_sll) begin
         y_next = a_sh << shamt;
    end
    else if (do_srl) begin
         y_next = a_sh >> shamt;
    end
    else if (do_sra) begin
         y_next = $signed(a_sh) >>> shamt;
    end
    else if (do_slt) begin
         y_next = ($signed(A) < $signed(B)) ? {{(WIDTH-1){1'b0}},1'b1} : {WIDTH{1'b0}};
    end
    else if (do_a) begin
         y_next = A;
    end
    else begin
         y_next = B;
    end
    z = (y_next == {WIDTH{1'b0}});
    n = y_next[WIDTH-1];
    c = cout;
    o = (a_arith[WIDTH-1] ^ y_next[WIDTH-1]) & (b_arith[WIDTH-1] ^ y_next[WIDTH-1]);
end 

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        Y <= {WIDTH{1'b0}};
        Z <= 1'b0;
        O <= 1'b0;
        C <= 1'b0;
        N <= 1'b0;
    end
    else if(EN) begin
        Y <= y_next;
        Z <= z;
        C <= c;
        N <= n;
        if (do_add || do_sub) begin
        o <= (a_arith[WIDTH-1] ^ y_next[WIDTH-1]) & (b_arith[WIDTH-1] ^ y_next[WIDTH-1]);
        end
        else begin
        o <= 1'b0;
        end
    end
end
endmodule