module final_fsm#(
    WIDTH = 8,
    OPRAND_LENGTH = 8,
    //uart frame is 20 bits   4,           8,            8
    //                        ^            ^             ^
    //                      opcode     operand a     operand b
)(
    input wire clk,
    input wire RST_N,

    input wire fifo_empty,
    input wire [19:0] fifo_data,
    input wire [WIDTH-1:0] alu_result,
    input wire alu_done,
    input wire tx_busy,

    output reg [OPRAND_LENGTH-1:0] oprand_a,
    output reg [OPRAND_LENGTH-1:0] oprand_b,
    output reg [3:0] opcode,

    output reg fifo_read_en,
    output reg alu_start,
    output reg uart_tx_start,
    output reg [WIDTH-1:0] uart_tx_data
);

reg [1:0] STATE;

localparam IDLE =  2'b00;
localparam FETCH = 2'b01;
localparam EXECUTE = 2'b10;
localparam SEND_RESULT = 2'b11;

always@(posedge clk or negedge RST_N) begin
    if(!RST_N) begin
        STATE <= IDLE;
        opcode <= 0;
        oprand_a <= 0;
        oprand_b <= 0;
        uart_tx_data <= 0;
    end else begin
        fifo_read_en <= 0;
        alu_start <= 0;
        uart_tx_start <= 0;
        case(STATE)
        IDLE: begin
            if (!fifo_empty) begin
                STATE <= FETCH;
                fifo_read_en <= 1;
            end
        end
        FETCH:begin
            opcode <= fifo_data[19:16];
            oprand_a <= fifo_data[15:8];
            oprand_b <= fifo_data[7:0];
            STATE <= EXECUTE;
            alu_start <= 1;
        end
        EXECUTE:begin
            if(alu_done) begin
                STATE <= SEND_RESULT;
            end
        end
        SEND_RESULT:begin
            if(!tx_busy)begin
                uart_tx_data <= alu_result;
                uart_tx_start <= 1;
                STATE <= IDLE;
            end
        end
        endcase
    end

end

endmodule