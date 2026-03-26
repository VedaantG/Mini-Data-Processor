`timescale 1ns/1ps

module register_file_tb;
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 3;

reg [ADDR_WIDTH-1:0] WRITE_ADDR;
reg [ADDR_WIDTH-1:0] READ_ADDR1;
reg [ADDR_WIDTH-1:0] READ_ADDR2;
reg CLK;
reg WRITE_EN;
reg RST_N;
reg [DATA_WIDTH-1:0] WRITE_DATA;

wire [DATA_WIDTH-1:0] READ_DATA1;
wire [DATA_WIDTH-1:0] READ_DATA2;

register_file#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)dut(
    .WRITE_ADDR(WRITE_ADDR),
    .READ_ADDR1(READ_ADDR1),
    .READ_ADDR2(READ_ADDR2),
    .CLK(CLK),
    .WRITE_EN(WRITE_EN),
    .RST_N(RST_N),
    .WRITE_DATA(WRITE_DATA),
    .READ_DATA1(READ_DATA1),
    .READ_DATA2(READ_DATA2)
);

initial CLK = 0;
always #5 CLK = ~CLK;
initial begin
    $dumpfile("waveform/register_file_op.vcd");
    $dumpvars(0,register_file_tb);
    #10
    RST_N = 0;
    READ_ADDR1 = 0;
    READ_ADDR2 = 0;
    WRITE_DATA = 0;
    WRITE_EN = 0;
    WRITE_ADDR = 0;

    #10
    RST_N = 1;
    #10
    WRITE_ADDR = 4'h1;
    WRITE_DATA = 8'hFF;
    WRITE_EN = 0;

    #10
    WRITE_EN = 1;

    #10
    WRITE_ADDR = 4'h2;
    WRITE_DATA = 8'hFE;

    #10
    WRITE_EN = 0;

    #10
    READ_ADDR1 = 4'h1;
    READ_ADDR2 = 4'h2;

    #10
    WRITE_ADDR = 4'h0;
    WRITE_DATA = 8'hFE;

    #10
    WRITE_ADDR = 4'h0;
    WRITE_DATA = 8'hAA;
    WRITE_EN = 1;

    #100
    $finish;
end

endmodule