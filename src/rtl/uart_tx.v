module uart_tx#(
    parameter integer WIDTH = 8,
    parameter integer FREQUENCY = 50000000,
    parameter integer BAUD_RATE = 9600,
    parameter integer CLK_PER_BIT = ((FREQUENCY + BAUD_RATE)/2)/BAUD_RATE
)(
    input wire CLK,
    input wire RST_N,
    input wire TX_START,
    input wire [WIDTH-1:0] DATA,
    output reg D_OUT,
    output reg BUSY
);
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

reg [16:0] CLK_COUNT;
reg [WIDTH-1:0] TX_SHIFT_REG;
reg [$clog2(WIDTH)-1:0] BIT_INDEX;
reg [1:0] STATE;

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        CLK_COUNT <= 0;
    end else if (CLK_COUNT < CLK_PER_BIT-1) begin
        CLK_COUNT <= CLK_COUNT + 1;
    end else begin
        CLK_COUNT <= 0;
    end
end


endmodule