`timescale 1ns/1ps

module data_processor_tb;

reg clk;
reg RST_N;
reg uart_rx;
wire uart_tx;

// Clock generation (50 MHz)
initial clk = 0;
always #10 clk = ~clk; // 20ns period

// DUT
data_processor_top uut(
    .clk(clk),
    .RST_N(RST_N),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx)
);

// UART timing
parameter BIT_PERIOD = 8680; // ns for 115200 baud

// -----------------------------
// TASK: SEND UART FRAME
// -----------------------------
task uart_send_frame;
    input [19:0] data;
    integer i;
    begin
        // Idle state
        uart_rx = 1;
        #(BIT_PERIOD);

        // START BIT
        uart_rx = 0;
        #(BIT_PERIOD);

        // DATA BITS (LSB FIRST)
        for(i = 0; i < 20; i = i + 1) begin
            uart_rx = data[i];
            #(BIT_PERIOD);
        end

        // STOP BIT
        uart_rx = 1;
        #(BIT_PERIOD);

        // small gap
        #(BIT_PERIOD);
    end
endtask

// -----------------------------
// TEST SEQUENCE
// -----------------------------
initial begin

    $dumpfile("waveform/data_processor.vcd");
    $dumpvars(0, data_processor_tb);

    uart_rx = 1;
    RST_N = 0;

    #100;
    RST_N = 1;

    // =========================
    // TEST 1: ADD (5 + 3 = 8)
    // =========================
    uart_send_frame({4'b0000, 8'd5, 8'd3});

    #100000;

    // =========================
    // TEST 2: SUB (10 - 4 = 6)
    // =========================
    uart_send_frame({4'b0001, 8'd10, 8'd4});

    #100000;

    // =========================
    // TEST 3: AND
    // =========================
    uart_send_frame({4'b0010, 8'hF0, 8'h0F});

    #100000;

    // =========================
    // TEST 4: OR
    // =========================
    uart_send_frame({4'b0011, 8'hF0, 8'h0F});

    #100000;

    // =========================
    // TEST 5: XOR
    // =========================
    uart_send_frame({4'b0100, 8'hAA, 8'h55});

    #100000;

    // =========================
    // TEST 6: SHIFT LEFT
    // =========================
    uart_send_frame({4'b0110, 8'd2, 8'd1});

    #100000;

    // =========================
    // TEST 7: PASS A
    // =========================
    uart_send_frame({4'b1010, 8'd25, 8'd0});

    #100000;

    $finish;

end

endmodule