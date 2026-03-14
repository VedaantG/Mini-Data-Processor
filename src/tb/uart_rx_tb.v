`timescale 1ns/1ps
module uart_rx_tb;

parameter WIDTH = 8;
parameter FREQUENCY = 50_000_000;
parameter BAUD_RATE = 115200;
parameter SAMPLING_FACTOR = 16;


localparam integer CLK_PER_SAMPLE = FREQUENCY / (BAUD_RATE * SAMPLING_FACTOR);
localparam integer BIT_CYCLES = SAMPLING_FACTOR * CLK_PER_SAMPLE;

reg CLK;
reg RST_N;
reg D_IN;
wire BUSY;
wire [WIDTH-1:0] DATA;
wire RX_DONE;

uart_rx #(
    .WIDTH(WIDTH),
    .FREQUENCY(FREQUENCY),
    .BAUD_RATE(BAUD_RATE)
) DUT (
    .CLK(CLK),
    .RST_N(RST_N),
    .D_IN(D_IN),
    .BUSY(BUSY),
    .DATA(DATA),
    .RX_DONE(RX_DONE)
);

initial CLK = 0;
always #10 CLK = ~CLK; 


task send_byte(input [7:0] byte);
    integer i, j;
    begin
  
        D_IN = 0;
        for (j = 0; j < BIT_CYCLES; j = j + 1) @(posedge CLK);

     
        for (i = 0; i < 8; i = i + 1) begin
            D_IN = byte[i];
            for (j = 0; j < BIT_CYCLES; j = j + 1) @(posedge CLK);
        end

      
        D_IN = 1;
        for (j = 0; j < BIT_CYCLES; j = j + 1) @(posedge CLK);
    end
endtask

initial begin
    $dumpfile("waveform/uart_rx_op.vcd");
    $dumpvars(0, uart_rx_tb);


    RST_N = 0;
    D_IN = 1;
    repeat(10) @(posedge CLK);
    RST_N = 1;
    repeat(10) @(posedge CLK);

    
    send_byte(8'h55); 
    send_byte(8'hA3); 
    send_byte(8'h46); 

    repeat(1000) @(posedge CLK); 
    $finish;
end


always @(posedge CLK) begin
    if (RX_DONE) $display("Time=%0t CLK, Received DATA=0x%0h", $time, DATA);
end

endmodule