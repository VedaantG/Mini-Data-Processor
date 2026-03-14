module uart_rx #(
    parameter WIDTH = 8,
    parameter FREQUENCY = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input wire CLK,
    input wire RST_N,
    input wire D_IN,
    output reg BUSY,
    output reg [WIDTH-1:0] DATA,
    output reg RX_DONE
);

localparam integer CLK_PER_BIT = FREQUENCY / BAUD_RATE;

reg [$clog2(CLK_PER_BIT)-1:0] clk_count;
reg [$clog2(WIDTH)-1:0] bit_index;
reg [WIDTH-1:0] data_shift;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA_STATE = 2'b10;
localparam STOP = 2'b11;

reg d_sync1, d_sync2;

always @(posedge CLK) begin
    d_sync1 <= D_IN;
    d_sync2 <= d_sync1;
end

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
        data_shift <= 0;
        RX_DONE <= 0;
        BUSY <= 0;
    end else begin
        RX_DONE <= 0;
        case(state)
        IDLE: begin
            BUSY <= 0;
            clk_count <= 0;
            bit_index <= 0;
            if(d_sync2 == 0) begin
                state <= START;
                BUSY <= 1;
            end
        end
        START: begin
            clk_count <= clk_count + 1;
            if(clk_count == CLK_PER_BIT/2) begin
                if(d_sync2 == 0) begin
                    state <= DATA_STATE;
                    clk_count <= 0;
                    bit_index <= 0;
                end else begin
                    state <= IDLE;
                end
            end
        end
        DATA_STATE: begin
            clk_count <= clk_count + 1;
            if(clk_count == CLK_PER_BIT/2) begin
                data_shift[bit_index] <= d_sync2;
            end
            if(clk_count == CLK_PER_BIT-1) begin
                clk_count <= 0;
                if(bit_index == WIDTH-1) state <= STOP;
                else bit_index <= bit_index + 1;
            end
        end
        STOP: begin
            clk_count <= clk_count + 1;
            if(clk_count == CLK_PER_BIT/2) begin
                if(d_sync2 == 1) begin
                    DATA <= data_shift;
                    RX_DONE <= 1;
                end
            end
            if(clk_count == CLK_PER_BIT-1) begin
                clk_count <= 0;
                state <= IDLE;
            end
        end
        endcase
    end
end

always @(*) BUSY = (state != IDLE);

endmodule
//hell yeah