module IF_ID (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,            // Hold IF/ID state
    input  wire        flush,            // Insert NOP
    input  wire [31:0] instr_in,         // From InstructionMemory
    input  wire [31:0] PCplus4_in,       // From PCAdder

    output reg [31:0] instr_out,         // To ID stage
    output reg [31:0] PCplus4_out        // To ID stage
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        instr_out    <= 32'b0;
        PCplus4_out  <= 32'b0;
    end 
    else if (flush) begin
        instr_out    <= 32'b0;          // NOP
        PCplus4_out  <= 32'b0;
    end
    else if (!stall) begin
        instr_out    <= instr_in;
        PCplus4_out  <= PCplus4_in;
    end
    // if stall=1 → hold previous value
end

endmodule
