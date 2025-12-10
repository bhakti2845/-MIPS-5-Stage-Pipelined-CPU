module InstructionMemory(
    input  wire [31:0] addr,
    output wire [31:0] instr
);

reg [31:0] mem [0:255];

initial begin
    $display("Loading program.mem ...");

    // Load file (NO IF CHECK)
    $readmemh("program.mem", mem);

    $display("Instruction memory loaded successfully.");
end

assign instr = mem[addr[9:2]];

endmodule
