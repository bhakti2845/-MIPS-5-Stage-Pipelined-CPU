module DataMemory(
    input  wire        clk,
    input  wire        MemRead,
    input  wire        MemWrite,
    input  wire [31:0] addr,
    input  wire [31:0] writeData,
    output reg  [31:0] readData
);

reg [31:0] dmem [0:255];

always @(negedge clk) begin
    if (MemWrite) begin
        dmem[addr[9:2]] <= writeData;
        $display("MEM WRITE: addr=%h data=%h", addr, writeData);
    end
end

always @(*) begin
    if (MemRead)
        readData = dmem[addr[9:2]];
    else
        readData = 32'b0;
end

endmodule
