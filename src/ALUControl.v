module ALUControl (
    input  wire [1:0] ALUOp,        // From Control Unit
    input  wire [5:0] funct,        // For R-type instructions
    output reg  [3:0] ALUControl    // Control signal to ALU
);

// Funct field encodings
localparam ADD  = 6'b100000;   // 20 hex
localparam SUB  = 6'b100010;   // 22 hex
localparam AND_ = 6'b100100;   // 24 hex
localparam OR_  = 6'b100101;   // 25 hex
localparam SLT  = 6'b101010;   // 2A hex
localparam NOR_ = 6'b100111;   // 27 hex

always @(*) begin
    case (ALUOp)
        2'b00: begin
            // LW, SW, ADDI → ADD
            ALUControl = 4'b0010;
        end

        2'b01: begin
            // BEQ / BNE → SUB
            ALUControl = 4'b0110;
        end

        2'b10: begin 
            // R-type: decode funct field
            case (funct)
                ADD:  ALUControl = 4'b0010;
                SUB:  ALUControl = 4'b0110;
                AND_: ALUControl = 4'b0000;
                OR_:  ALUControl = 4'b0001;
                SLT:  ALUControl = 4'b0111;
                NOR_: ALUControl = 4'b1100;
                default: ALUControl = 4'b1111; // undefined
            endcase
        end

        2'b11: begin
            // For ANDI, ORI, SLTI, XORI (handled by main control)
            // You may expand as needed. For now treat as ADDI-like or default logic.
            ALUControl = 4'b0010;  
        end

        default: ALUControl = 4'b1111;
    endcase
end

endmodule
