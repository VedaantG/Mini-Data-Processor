module fifo #(parameter DATA_WIDTH = 20, parameter DEPTH = 256) (
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

reg [$clog2(DEPTH)-1:0] wr_ptr;
reg [$clog2(DEPTH)-1:0] rd_ptr;

/* NEW REGISTER */
reg [$clog2(DEPTH):0] count;

/* STATUS FLAGS */
assign empty = (count == 0);
assign full  = (count == DEPTH);

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
        data_out <= 0;
    end
    else
    begin

        if(write_en && !full)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        if(read_en && !empty)
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        case ({write_en && !full, read_en && !empty})

            2'b10: count <= count + 1;  // write only
            2'b01: count <= count - 1;  // read only
            2'b11: count <= count;      // read and write same cycle
            default: count <= count;

        endcase
    end
end
endmodule