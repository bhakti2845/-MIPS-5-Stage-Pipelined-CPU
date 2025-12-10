module HazardDetectionUnit (
    input  wire        ID_EX_MemRead,   // Load in EX stage
    input  wire [4:0]  ID_EX_rt,        // Load destination register
    input  wire [4:0]  IF_ID_rs,        // Source registers of next instruction
    input  wire [4:0]  IF_ID_rt,

    output reg         PCWrite,         // Freeze PC
    output reg         IF_ID_Write,     // Freeze IF/ID
    output reg         ID_EX_Flush      // Insert bubble into ID/EX
);

always @(*) begin
    // Default: no hazard, normal pipeline flow
    PCWrite     = 1;
    IF_ID_Write = 1;
    ID_EX_Flush = 0;

    // LOAD-USE HAZARD:
    if (ID_EX_MemRead &&
       ((ID_EX_rt == IF_ID_rs) || (ID_EX_rt == IF_ID_rt))) begin
        
        PCWrite     = 0;   // Hold PC
        IF_ID_Write = 0;   // Hold IF/ID pipeline register
        ID_EX_Flush = 1;   // Insert bubble into EX stage
    end
end

endmodule
