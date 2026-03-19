module data_processor_top(
    input wire RST_N,
    input wire clk,
    input wire uart_tx,
    input wire uart_rx
);

//alu khaoge :)

alu alu_inst(
    .CLK(clk),
    .EN(alu_start),
    .SEL(opcode),
    .A(oprand_a),
    .B(oprand_b),
    .DONE(alu_done),
    .Y(alu_result),
    .RST_N(RST_N)
);

uart_rx uart_rx_inst(
    .CLK(clk),
    .RST_N(RST_N),
    .DATA(fifo_data),
    .BUSY(rx_busy),
    .RX_DONE(rx_done)
);

uart_tx uart_tx_inst(
    .CLK(CLK),
    .RST_N(RST_N),
    .TX_START(uart_tx_start),
    .DATA(uart_tx_data)
);

fifo fifo_inst(
    .clk(clk),
    .reset(RST_N),
    .read_en(fifo_read_en),
    .data_in(DATA),
    .read_en(READ_EN)
);

final_fsm final_fsm_inst(
    .clk(clk),
    .RST_N(RST_N),
    .fifo_empty(empty),
    .fifo_data(data_out),
    .alu_result(Y),
    .alu_done(ALU_DONE),
    .tx_busy(TX_BUSY),
    .rx_busy(RX_BUSY),
    .rx_done(RX_DONE)
)
endmodule