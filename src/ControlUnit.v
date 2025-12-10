module ControlUnit (
    input  wire [5:0] opcode,
    output reg        RegDst,
    output reg        ALUSrc,
    output reg        MemtoReg,
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,
    output reg        Jump,
    output reg [1:0]  ALUOp
);

// Opcode constants
localparam R_TYPE = 6'b000000;
localparam LW     = 6'b100011;  // 0x23
localparam SW     = 6'b101011;  // 0x2B
localparam BEQ    = 6'b000100;
localparam BNE    = 6'b000101;
localparam ADDI   = 6'b001000;
localparam ORI    = 6'b001101;
localparam ANDI   = 6'b001100;
localparam SLTI   = 6'b001010;
localparam JUMP   = 6'b000010;
localparam JAL    = 6'b000011;

always @(*) begin
    // Default values
    RegDst   = 0;
    ALUSrc   = 0;
    MemtoReg = 0;
    RegWrite = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    Jump     = 0;
    ALUOp    = 2'b00;

    case (opcode)

        R_TYPE: begin
            RegDst   = 1;
            RegWrite = 1;
            ALUOp    = 2'b10;   // Use funct field
        end

        LW: begin
            ALUSrc   = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead  = 1;
            ALUOp    = 2'b00;
        end

        SW: begin
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        BEQ: begin
            Branch   = 1;
            ALUOp    = 2'b01;   // SUB
        end

        BNE: begin
            Branch   = 1;       // Special handling later
            ALUOp    = 2'b01;
        end

        ADDI: begin
            ALUSrc   = 1;
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        ANDI: begin
            ALUSrc   = 1;
            RegWrite = 1;
            ALUOp    = 2'b11;   // we define in ALU Control later
        end

        ORI: begin
            ALUSrc   = 1;
            RegWrite = 1;
            ALUOp    = 2'b11;
        end

        SLTI: begin
            ALUSrc   = 1;
            RegWrite = 1;
            ALUOp    = 2'b11;
        end

        JUMP: begin
            Jump = 1;
        end

        JAL: begin
            Jump     = 1;
            RegWrite = 1;
            // $ra = 31 is handled in WB multiplexer
        end

        default: begin
            // All signals remain 0
        end
    endcase
end

endmodule
