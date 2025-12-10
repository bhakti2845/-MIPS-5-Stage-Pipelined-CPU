module RegisterFile (
    input  wire        clk,
    input  wire        RegWrite,       // Write enable
    input  wire [4:0]  readReg1,       // rs
    input  wire [4:0]  readReg2,       // rt
    input  wire [4:0]  writeReg,       // destination register
    input  wire [31:0] writeData,      // data to write (from WB stage)
    output wire [31:0] readData1,      // data1 output
    output wire [31:0] readData2       // data2 output
);

reg [31:0] regfile [0:31];

// WRITE (synchronous)
always @(posedge clk) begin
    if (RegWrite && (writeReg != 5'd0)) begin
        regfile[writeReg] <= writeData;
    end
end

// READ (asynchronous)
assign readData1 = (readReg1 == 5'd0) ? 32'd0 : regfile[readReg1];
assign readData2 = (readReg2 == 5'd0) ? 32'd0 : regfile[readReg2];

endmodule
