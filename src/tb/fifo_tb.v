`timescale 1ns/1ps

module fifo_tb;
reg clk;
reg reset;
reg write_en;
reg read_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire full;
wire empty;

fifo uut(
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

initial clk = 0;
always #5 clk = ~clk;

initial
begin 
$dumpfile("fifo_tb.vcd");
$dumpvars(0, fifo_tb);

reset = 1;
write_en = 0;
read_en = 0;
data_in = 0;

@(posedge clk);
reset = 0;

@(posedge clk); write_en = 1; data_in = 8'hA1;
@(posedge clk); data_in = 8'hB2;
@(posedge clk); data_in = 8'hC3;
@(posedge clk); data_in = 8'hD4; 

@(posedge clk); write_en = 0; 
@(posedge clk); read_en  = 1;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);

read_en = 0;
#20 $finish;

end
endmodule