module MEM_WB (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,
    input  wire        flush,

    // Inputs from MEM stage
    input  wire [31:0] ReadData_in,        // Data from memory (LW)
    input  wire [31:0] ALUResult_in,       // ALU output
    input  wire [4:0]  WriteReg_in,        // Destination register

    // Control signals
    input  wire        RegWrite_in,
    input  wire        MemtoReg_in,

    // Outputs to WB stage
    output reg [31:0] ReadData_out,
    output reg [31:0] ALUResult_out,
    output reg [4:0]  WriteReg_out,
    output reg        RegWrite_out,
    output reg        MemtoReg_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ReadData_out   <= 32'b0;
        ALUResult_out  <= 32'b0;
        WriteReg_out   <= 5'b0;
        RegWrite_out   <= 0;
        MemtoReg_out   <= 0;
    end
    else if (flush) begin
        // Insert bubble
        ReadData_out   <= 32'b0;
        ALUResult_out  <= 32'b0;
        WriteReg_out   <= 5'b0;
        RegWrite_out   <= 0;
        MemtoReg_out   <= 0;
    end
    else if (!stall) begin
        ReadData_out   <= ReadData_in;
        ALUResult_out  <= ALUResult_in;
        WriteReg_out   <= WriteReg_in;
        RegWrite_out   <= RegWrite_in;
        MemtoReg_out   <= MemtoReg_in;
    end
    // If stall = 1 → hold previous values
end

endmodule
