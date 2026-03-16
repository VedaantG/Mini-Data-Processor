module uart_tx#(
    parameter integer WIDTH = 20,
    parameter integer FREQUENCY = 50000000,
    parameter integer BAUD_RATE = 10000000,
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
localparam DATA_STATE = 2'b10;
localparam STOP = 2'b11;

reg [$clog2(CLK_PER_BIT):0] CLK_COUNT;
reg [WIDTH-1:0] TX_DATA_REG;
reg [$clog2(WIDTH):0] BIT_INDEX;
reg [1:0] STATE;

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        CLK_COUNT <= 0;
    end else if ((CLK_COUNT < CLK_PER_BIT-1) && STATE != IDLE) begin
        CLK_COUNT <= CLK_COUNT + 1;
    end else begin
        CLK_COUNT <= 0;
    end
end

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        STATE <= IDLE;
        BIT_INDEX <= 0;
        TX_DATA_REG <= 0;
    end else begin
        case (STATE) 
        IDLE : begin
            if(TX_START && !BUSY) begin
                STATE <= START;
                TX_DATA_REG <= DATA;
                BIT_INDEX <= 0;
            end
        end
        START: begin
            if (CLK_COUNT == CLK_PER_BIT-1) begin
                STATE <= DATA_STATE;
            end
        end
        DATA_STATE : begin
            if (BIT_INDEX == WIDTH-1 && CLK_COUNT == CLK_PER_BIT-1) begin
                STATE <= STOP;
            end else if (CLK_COUNT == CLK_PER_BIT-1) begin
                BIT_INDEX <= BIT_INDEX + 1;
            end
        end
        STOP : begin
            if (CLK_COUNT == CLK_PER_BIT-1) begin
                STATE <= IDLE;
            end
        end
        default : begin
            STATE <= IDLE;
        end
        endcase
    end
end

always @(*) begin
    case(STATE)
    START: D_OUT = 0;
    DATA_STATE: D_OUT = TX_DATA_REG[BIT_INDEX];
    STOP: D_OUT = 1;
    default: D_OUT = 1;
    endcase
    BUSY = (STATE != IDLE);
end

endmodule