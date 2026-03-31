module data_processor_top#(
    parameter integer WIDTH = 8,
    parameter integer FRAME_WIDTH = 20
)(
    input wire RST_N,
    input wire clk,
    output wire uart_tx,
    input wire uart_rx
);

//alu khaoge :)


//decleration of necessary wires
wire [WIDTH-1:0] oprand_a;
wire [WIDTH-1:0] oprand_b;
wire [3:0] opcode;
wire alu_start;
wire alu_done;
wire [WIDTH-1:0] alu_result;

alu alu_inst(
    .CLK(clk),
    .EN(alu_start),
    .SEL(opcode),
    .A(oprand_a),
    .B(oprand_b),
    .ALU_DONE(alu_done),
    .Y(alu_result),
    .RST_N(RST_N)
);

wire rx_done;
wire rx_busy;
wire [FRAME_WIDTH-1:0] rx_data;

uart_rx uart_rx_inst(
    .CLK(clk),
    .RST_N(RST_N),
    .DATA(rx_data),
    .RX_BUSY(rx_busy),
    .RX_DONE(rx_done),
    .D_IN(uart_rx)
);

wire uart_tx_start;
wire [FRAME_WIDTH-1:0] uart_tx_data;
wire tx_busy;

uart_tx uart_tx_inst(
    .CLK(clk),
    .RST_N(RST_N),
    .TX_START(uart_tx_start),
    .DATA(uart_tx_data),
    .TX_BUSY(tx_busy),
    .D_OUT(uart_tx)
);

wire fifo_read_en;
wire fifo_empty;
wire [FRAME_WIDTH-1:0] fifo_data;
wire fifo_full;

fifo fifo_inst(
    .clk(clk),
    .reset(RST_N),
    .write_en(rx_done && !fifo_full),
    .read_en(fifo_read_en),
    .data_in(rx_data),
    .data_out(fifo_data),
    .empty(fifo_empty),
    .full(fifo_full)
);

wire read_add1;
wire read_add2;
wire write_add;
wire write_data;
wire write_en;
wire read_data1;
wire read_data2;
register_file register_file_inst(
    .READ_ADDR1(read_add1),
    .READ_ADDR2(read_add2),
    .WRITE_ADDR(write_add),
    .WRITE_DATA(write_data),
    .RST_N(RST_N),
    .CLK(clk),
    .WRITE_EN(write_en),
    .READ_DATA1(read_data1),
    .READ_DATA2(read_data2)
);

final_fsm final_fsm_inst(
    .clk(clk),
    .RST_N(RST_N),
    .fifo_empty(fifo_empty),
    .fifo_data(fifo_data),
    .alu_result(alu_result),
    .alu_done(alu_done),
    .tx_busy(tx_busy),
    .rx_busy(rx_busy),
    .rx_done(rx_done),
    .oprand_a(oprand_a),
    .oprand_b(oprand_b),
    .opcode(opcode),
    .fifo_read_en(fifo_read_en),
    .alu_start(alu_start),
    .uart_tx_start(uart_tx_start),
    .uart_tx_data(uart_tx_data),
    .address1(read_add1),
    .address2(read_add2),
    .wb_address(write_add),
    .read_data1(read_data1),
    .read_data2(read_data2)
    .reg_write_en(write_en),
    .reg_write_data(write_data)
);
endmodule