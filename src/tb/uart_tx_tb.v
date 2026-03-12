`timescale 1ps/1ps
module uart_tx_tb;
parameter WIDTH = 8;
parameter FREQUENCY = 50000000;
parameter BAUD_RATE = 9600;

reg CLK;
reg RST_N;
reg TX_START;
reg [WIDTH-1:0] DATA;
wire D_OUT;
wire BUSY;

uart_tx#(
    .WIDTH(WIDTH),
    .FREQUENCY(FREQUENCY),
    .BAUD_RATE(BAUD_RATE)
)dut(
    .CLK(CLK),
    .RST_N(RST_N),
    .TX_START(TX_START),
    .DATA(DATA),
    .D_OUT(D_OUT),
    .BUSY(BUSY)
);
always #5 CLK = ~CLK;

initial begin
    $dumpfile("waveform/uart_tx_op.vcd");
    $dumpvars(0,uart_tx_tb);
    //initialize
    CLK = 0;
    RST_N = 0;
    TX_START = 0;
    DATA = 0;

    //loading data
    #10
    TX_START = 0;
    RST_N = 1;
    DATA = {WIDTH{1'b1}};

    #10
    RST_N = 0;

    #10
    TX_START = 1;
    RST_N = 1;
    DATA = {WIDTH/2{2'b10}};

    #10
    TX_START = 0;
    RST_N = 1;
    DATA = {WIDTH/2{2'b11}};

    #2083800
    RST_N = 1;
    TX_START = 0;

    #10
    TX_START = 1;
    RST_N = 1;
    DATA = {WIDTH/2{2'b01}};

    #10
    TX_START = 0;
    
    #2083800
    RST_N = 1;



    $finish;


end
endmodule