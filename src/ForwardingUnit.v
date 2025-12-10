module ForwardingUnit (
    input  wire        EX_MEM_RegWrite,
    input  wire [4:0]  EX_MEM_WriteReg,
    input  wire        MEM_WB_RegWrite,
    input  wire [4:0]  MEM_WB_WriteReg,
    input  wire [4:0]  ID_EX_rs,
    input  wire [4:0]  ID_EX_rt,

    output reg [1:0]   ForwardA,
    output reg [1:0]   ForwardB
);

always @(*) begin
    // Default: no forwarding
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // -------- FORWARD A (ALU operand 1) --------
    // EX hazard
    if (EX_MEM_RegWrite && (EX_MEM_WriteReg != 0) &&
        (ID_EX_rs != 0) &&                          // <<< NEW
        (EX_MEM_WriteReg == ID_EX_rs)) begin
        ForwardA = 2'b10;
    end
    // MEM hazard
    else if (MEM_WB_RegWrite && (MEM_WB_WriteReg != 0) &&
             (ID_EX_rs != 0) &&                     // <<< NEW
             (MEM_WB_WriteReg == ID_EX_rs)) begin
        ForwardA = 2'b01;
    end

    // -------- FORWARD B (ALU operand 2) --------
    if (EX_MEM_RegWrite && (EX_MEM_WriteReg != 0) &&
        (ID_EX_rt != 0) &&                          // <<< NEW
        (EX_MEM_WriteReg == ID_EX_rt)) begin
        ForwardB = 2'b10;
    end
    else if (MEM_WB_RegWrite && (MEM_WB_WriteReg != 0) &&
             (ID_EX_rt != 0) &&                     // <<< NEW
             (MEM_WB_WriteReg == ID_EX_rt)) begin
        ForwardB = 2'b01;
    end
end

endmodule
