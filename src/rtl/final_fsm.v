module final_fsm#(
    parameter integer FRAME_WIDTH = 21,
    parameter integer ADDR_WIDTH = 4,
    parameter integer OPRAND_LENGTH = 8
    //uart frame is 20 bits   5         4            4         8  
    //                        ^         ^            ^         ^
    //                      opcode   wb_address   address1  address2/imm_value
)(
    input wire clk,
    input wire RST_N,

    input wire fifo_empty,
    input wire [FRAME_WIDTH-1:0] fifo_data,
    input wire [OPRAND_LENGTH-1:0] alu_result,
    input wire [OPRAND_LENGTH-1:0] read_data1,
    input wire [OPRAND_LENGTH-1:0] read_data2,
    input wire alu_done,
    input wire tx_busy,
    input wire rx_busy,
    input wire rx_done,

    output reg [ADDR_WIDTH-1:0] address1,
    output reg [ADDR_WIDTH-1:0] address2,
    output reg [ADDR_WIDTH-1:0] wb_address,
    output reg [OPRAND_LENGTH-1:0] imm_value,
    output reg [OPRAND_LENGTH-1:0] oprand_a,
    output reg [OPRAND_LENGTH-1:0] oprand_b,
    output reg [3:0] opcode,

    output reg fifo_read_en,
    output reg alu_start,
    output reg uart_tx_start,
    output reg use_imm,
    output reg bypass_alu,
    output reg reg_write_en,
    output reg [FRAME_WIDTH-1:0] uart_tx_data,
    output reg [OPRAND_LENGTH-1] reg_write_data
);

reg [2:0] STATE;

localparam IDLE =  3'b000;
localparam FETCH = 3'b001;
localparam EXECUTE = 3'b010;
localparam WRITE_BACK = 3'b011;
localparam SEND_RESULT = 3'b100;

localparam LOAD = 5'b11111;


always@(posedge clk or negedge RST_N) begin
    if(!RST_N) begin
        STATE <= IDLE;
        opcode <= 0;
        oprand_a <= 0;
        oprand_b <= 0;
        uart_tx_data <= 0;
        reg_write_en <= 0;
        imm_value <= 0;
        reg_write_data <= 0;
        bypass_alu <= 0;
        use_imm <= 0;
    end else begin
        fifo_read_en <= 0;
        alu_start <= 0;
        uart_tx_start <= 0;
        reg_write_en <= 0;
        case(STATE)
        IDLE: begin
            if (!fifo_empty && !rx_busy) begin
                STATE <= FETCH;
                fifo_read_en <= 1;
            end
        end
        FETCH:begin
            use_imm <= fifo_data[20];
            opcode <= fifo_data[19:16];
            wb_address <= fifo_data[15:12];
            address1 <= fifo_data[11:8];
            address2 <= fifo_data[3:0];
            imm_value <= fifo_data[7:0];
            alu_start <= 1;
            STATE <= EXECUTE;
        end
        EXECUTE:begin
            if(opcode == LOAD) begin
                bypass_alu <= 1;
                STATE <= WRITE_BACK;
            end else begin
                bypass_alu <= 0;
            end
            oprand_a <= read_data1;
            if(use_imm) begin
                oprand_b <= imm_value;
            end else begin
                oprand_b <= read_data2;
            end
            if(alu_done) begin
                STATE <= WRITE_BACK;
            end
        end
        WRITE_BACK:begin
            reg_write_en <= 1;
            if(bypass_alu)begin
                reg_write_data <= imm_value;
            end else begin
                reg_write_data <= alu_result;
            end
            STATE <= SEND_RESULT;
        end
        SEND_RESULT:begin
            if(!tx_busy)begin
                uart_tx_data <= {12'b0,reg_write_data};
                uart_tx_start <= 1;
                STATE <= IDLE;
            end
        end
        default:begin
            STATE <= IDLE;
        end
        endcase
    end
end
endmodule