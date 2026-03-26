module register_file #(
    parameter integer DATA_WIDTH = 8,
    parameter integer ADDR_WIDTH = 3,
    parameter integer NUM_REG = 2 ** ADDR_WIDTH
)(
    input wire [ADDR_WIDTH-1:0] WRITE_ADDR,
    input wire [ADDR_WIDTH-1:0] READ_ADDR1,
    input wire [ADDR_WIDTH-1:0] READ_ADDR2,
    input wire CLK,
    input wire WRITE_EN,
    input wire RST_N,
    input wire [DATA_WIDTH-1:0] WRITE_DATA,

    output reg [DATA_WIDTH-1:0] READ_DATA1,
    output reg [DATA_WIDTH-1:0] READ_DATA2

);

reg [DATA_WIDTH-1:0] register [0:NUM_REG-1];
wire [NUM_REG-1:0] one_hot;
integer i;
integer k;
assign one_hot = (1 << WRITE_ADDR);

always @(*) begin
    if(WRITE_EN && (WRITE_ADDR == READ_ADDR1)) begin
        READ_DATA1 = WRITE_DATA;
    end else begin
        READ_DATA1 = register[READ_ADDR1];
    end
    if(WRITE_EN && (WRITE_ADDR == READ_ADDR2)) begin
        READ_DATA2 = WRITE_DATA;
    end else begin
        READ_DATA2 = register[READ_ADDR2];
    end
end

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        for(k=0;k<NUM_REG;k=k+1) begin
            register[k] <= {DATA_WIDTH{1'b0}};
        end
    end
    else begin
        register[0] <= 0;
        if(WRITE_EN && WRITE_ADDR != 0) begin
            for(i=0;i<NUM_REG;i=i+1) begin
                if (one_hot[i] == 1'b1) begin
                    register[i] <= WRITE_DATA;
                end
            end
        end
    end

end
endmodule