module EX_MEM (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,
    input  wire        stall,

    // Inputs from EX stage
    input  wire [31:0] ALUResult_in,
    input  wire [31:0] readData2_in,      // for SW
    input  wire [31:0] BranchTarget_in,
    input  wire        Zero_in,
    input  wire [4:0]  WriteReg_in,

    // Control signals
    input  wire        MemRead_in,
    input  wire        MemWrite_in,
    input  wire        MemtoReg_in,
    input  wire        RegWrite_in,
    input  wire        Branch_in,
    input  wire        Jump_in,

    // Outputs to MEM stage
    output reg [31:0] ALUResult_out,
    output reg [31:0] readData2_out,
    output reg [31:0] BranchTarget_out,
    output reg        Zero_out,
    output reg [4:0]  WriteReg_out,

    // Control signals out
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        MemtoReg_out,
    output reg        RegWrite_out,
    output reg        Branch_out,
    output reg        Jump_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ALUResult_out     <= 32'b0;
        readData2_out     <= 32'b0;
        BranchTarget_out  <= 32'b0;
        Zero_out          <= 1'b0;
        WriteReg_out      <= 5'b0;

        MemRead_out       <= 0;
        MemWrite_out      <= 0;
        MemtoReg_out      <= 0;
        RegWrite_out      <= 0;
        Branch_out        <= 0;
        Jump_out          <= 0;
    end
    else if (flush) begin
        // Convert this stage into a bubble
        ALUResult_out     <= 32'b0;
        readData2_out     <= 32'b0;
        BranchTarget_out  <= 32'b0;
        Zero_out          <= 1'b0;
        WriteReg_out      <= 5'b0;

        MemRead_out       <= 0;
        MemWrite_out      <= 0;
        MemtoReg_out      <= 0;
        RegWrite_out      <= 0;
        Branch_out        <= 0;
        Jump_out          <= 0;
    end
    else if (!stall) begin
        ALUResult_out     <= ALUResult_in;
        readData2_out     <= readData2_in;
        BranchTarget_out  <= BranchTarget_in;
        Zero_out          <= Zero_in;
        WriteReg_out      <= WriteReg_in;

        MemRead_out       <= MemRead_in;
        MemWrite_out      <= MemWrite_in;
        MemtoReg_out      <= MemtoReg_in;
        RegWrite_out      <= RegWrite_in;
        Branch_out        <= Branch_in;
        Jump_out          <= Jump_in;
    end
    // If stall = 1: hold previous values
end

endmodule
