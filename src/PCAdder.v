module PCAdder (
    input  wire [31:0] PC,
    output wire [31:0] PCplus4
);

assign PCplus4 = PC + 32'd4;

endmodule
