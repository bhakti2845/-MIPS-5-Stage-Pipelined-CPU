module ID_EX (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,
    input  wire        flush,

    // From ID stage
    input  wire [31:0] PCplus4_in,
    input  wire [31:0] readData1_in,
    input  wire [31:0] readData2_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rs_in,
    input  wire [4:0]  rt_in,
    input  wire [4:0]  rd_in,
    input  wire [5:0]  funct_in,     // <-- NEW

    // Control signals in
    input  wire        RegDst_in,
    input  wire        ALUSrc_in,
    input  wire [1:0]  ALUOp_in,
    input  wire        MemRead_in,
    input  wire        MemWrite_in,
    input  wire        MemtoReg_in,
    input  wire        RegWrite_in,
    input  wire        Branch_in,
    input  wire        Jump_in,

    // Outputs to EX stage
    output reg [31:0] PCplus4_out,
    output reg [31:0] readData1_out,
    output reg [31:0] readData2_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs_out,
    output reg [4:0]  rt_out,
    output reg [4:0]  rd_out,
    output reg [5:0]  funct_out,     // <-- NEW

    // Control signals out
    output reg        RegDst_out,
    output reg        ALUSrc_out,
    output reg [1:0]  ALUOp_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        MemtoReg_out,
    output reg        RegWrite_out,
    output reg        Branch_out,
    output reg        Jump_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PCplus4_out   <= 32'b0;
        readData1_out <= 32'b0;
        readData2_out <= 32'b0;
        imm_out       <= 32'b0;
        rs_out        <= 5'b0;
        rt_out        <= 5'b0;
        rd_out        <= 5'b0;
        funct_out     <= 6'b0;

        RegDst_out    <= 0;
        ALUSrc_out    <= 0;
        ALUOp_out     <= 2'b00;
        MemRead_out   <= 0;
        MemWrite_out  <= 0;
        MemtoReg_out  <= 0;
        RegWrite_out  <= 0;
        Branch_out    <= 0;
        Jump_out      <= 0;
    end
    else if (flush) begin
        PCplus4_out   <= 32'b0;
        readData1_out <= 32'b0;
        readData2_out <= 32'b0;
        imm_out       <= 32'b0;
        rs_out        <= 5'b0;
        rt_out        <= 5'b0;
        rd_out        <= 5'b0;
        funct_out     <= 6'b0;

        RegDst_out    <= 0;
        ALUSrc_out    <= 0;
        ALUOp_out     <= 2'b00;
        MemRead_out   <= 0;
        MemWrite_out  <= 0;
        MemtoReg_out  <= 0;
        RegWrite_out  <= 0;
        Branch_out    <= 0;
        Jump_out      <= 0;
    end
    else if (!stall) begin
        PCplus4_out   <= PCplus4_in;
        readData1_out <= readData1_in;
        readData2_out <= readData2_in;
        imm_out       <= imm_in;
        rs_out        <= rs_in;
        rt_out        <= rt_in;
        rd_out        <= rd_in;
        funct_out     <= funct_in;      // <-- NEW

        RegDst_out    <= RegDst_in;
        ALUSrc_out    <= ALUSrc_in;
        ALUOp_out     <= ALUOp_in;
        MemRead_out   <= MemRead_in;
        MemWrite_out  <= MemWrite_in;
        MemtoReg_out  <= MemtoReg_in;
        RegWrite_out  <= RegWrite_in;
        Branch_out    <= Branch_in;
        Jump_out      <= Jump_in;
    end
end

endmodule
