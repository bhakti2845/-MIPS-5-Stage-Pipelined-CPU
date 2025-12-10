module ImmGen (
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);

wire [5:0] opcode = instr[31:26];
wire [15:0] imm16 = instr[15:0];

// Opcode constants
localparam ANDI = 6'b001100;
localparam ORI  = 6'b001101;
localparam XORI = 6'b001110;
localparam LUI  = 6'b001111;

always @(*) begin
    case (opcode)

        // Zero-extended immediates
        ANDI, ORI, XORI: begin
            imm_out = {16'b0, imm16};
        end

        // Load Upper Immediate
        LUI: begin
            imm_out = {imm16, 16'b0};
        end

        // Default: Sign-extended immediates
        default: begin
            imm_out = {{16{imm16[15]}}, imm16};
        end
    endcase
end

endmodule
