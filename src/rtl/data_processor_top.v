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
endmodule