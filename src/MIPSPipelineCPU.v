//========================================================
//                MIPS 5-STAGE PIPELINED CPU
//                    FINAL FIXED VERSION
//========================================================

module MIPSPipelineCPU(
    input wire clk,
    input wire reset
);

//========================================================
// IF WIRES
//========================================================
wire [31:0] PC, nextPC, instr, PCplus4;

//========================================================
// ID WIRES
//========================================================
wire [31:0] IF_ID_instr, IF_ID_PCplus4;
wire        IF_ID_Write, PCWrite, ID_EX_Flush;

wire [5:0] opcode = IF_ID_instr[31:26];
wire [4:0] rs     = IF_ID_instr[25:21];
wire [4:0] rt     = IF_ID_instr[20:16];
wire [4:0] rd     = IF_ID_instr[15:11];
wire [5:0] funct  = IF_ID_instr[5:0];

wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite;
wire Branch, Jump;
wire [1:0] ALUOp;

wire [31:0] readData1, readData2, imm;

//========================================================
// ID/EX WIRES
//========================================================
wire [31:0] ID_EX_PCplus4, ID_EX_readData1, ID_EX_readData2;
wire [31:0] ID_EX_imm;
wire [4:0]  ID_EX_rs, ID_EX_rt, ID_EX_rd;
wire [5:0]  ID_EX_funct;

wire        ID_EX_RegDst, ID_EX_ALUSrc, ID_EX_MemtoReg, ID_EX_RegWrite;
wire        ID_EX_MemRead, ID_EX_MemWrite, ID_EX_Branch, ID_EX_Jump;
wire [1:0]  ID_EX_ALUOp;

//========================================================
// EX WIRES
//========================================================
wire [3:0]  ALUControl;
wire [1:0]  ForwardA, ForwardB;

wire [31:0] ALU_in1, ALU_op2, ALU_in2, ALUResult;
wire        Zero;

wire [31:0] BranchTarget;
wire [4:0]  WriteReg_EX;

//========================================================
// EX/MEM WIRES
//========================================================
wire [31:0] EX_MEM_ALUResult, EX_MEM_readData2, EX_MEM_BranchTarget;
wire        EX_MEM_Zero;
wire [4:0]  EX_MEM_WriteReg;

wire        EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_MemtoReg;
wire        EX_MEM_RegWrite, EX_MEM_Branch, EX_MEM_Jump;

//========================================================
// MEM/WB WIRES
//========================================================
wire [31:0] MEM_WB_ReadData, MEM_WB_ALUResult;
wire [4:0]  MEM_WB_WriteReg;
wire        MEM_WB_RegWrite, MEM_WB_MemtoReg;

wire [31:0] WB_WriteData;

// *** MISSING EARLIER - FIXED NOW ***
wire [31:0] ReadData_MEM;

//========================================================
// IF STAGE
//========================================================
ProgramCounter PCreg (
    .clk(clk),
    .reset(reset),
    .PCWrite(PCWrite),
    .nextPC(nextPC),
    .PC(PC)
);

PCAdder adder (
    .PC(PC),
    .PCplus4(PCplus4)
);

InstructionMemory imem (
    .addr(PC),
    .instr(instr)
);

//========================================================
// BRANCH & JUMP DECISION
//========================================================

// Branch resolved in EX stage
wire BranchTaken = ID_EX_Branch & Zero;

// Jump target from ID stage
wire [31:0] JumpTarget =
    {IF_ID_PCplus4[31:28], IF_ID_instr[25:0], 2'b00};

// Flush rules
wire Flush_IF_ID = Jump | BranchTaken;
wire Flush_ID_EX = BranchTaken;

//========================================================
// IF/ID PIPELINE REGISTER
//========================================================
IF_ID if_id (
    .clk(clk),
    .reset(reset),
    .stall(!IF_ID_Write),
    .flush(Flush_IF_ID),
    .instr_in(instr),
    .PCplus4_in(PCplus4),
    .instr_out(IF_ID_instr),
    .PCplus4_out(IF_ID_PCplus4)
);

//========================================================
// ID STAGE
//========================================================
ControlUnit ctrl (
    .opcode(opcode),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)
);

RegisterFile rf (
    .clk(clk),
    .RegWrite(MEM_WB_RegWrite),
    .readReg1(rs),
    .readReg2(rt),
    .writeReg(MEM_WB_WriteReg),
    .writeData(WB_WriteData),
    .readData1(readData1),
    .readData2(readData2)
);

ImmGen immgen (
    .instr(IF_ID_instr),
    .imm_out(imm)
);

//========================================================
// HAZARD DETECTION UNIT
//========================================================
HazardDetectionUnit hazard (
    .ID_EX_MemRead(ID_EX_MemRead),
    .ID_EX_rt(ID_EX_rt),
    .IF_ID_rs(rs),
    .IF_ID_rt(rt),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ID_EX_Flush(ID_EX_Flush)
);

//========================================================
// ID/EX PIPELINE REGISTER
//========================================================
ID_EX id_ex (
    .clk(clk),
    .reset(reset),
    .stall(1'b0),                           // was 0
    .flush(ID_EX_Flush | Flush_ID_EX),

    .PCplus4_in(IF_ID_PCplus4),
    .readData1_in(readData1),
    .readData2_in(readData2),
    .imm_in(imm),
    .rs_in(rs),
    .rt_in(rt),
    .rd_in(rd),
    .funct_in(funct),

    .RegDst_in(RegDst),
    .ALUSrc_in(ALUSrc),
    .ALUOp_in(ALUOp),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .MemtoReg_in(MemtoReg),
    .RegWrite_in(RegWrite),
    .Branch_in(Branch),
    .Jump_in(Jump),

    .PCplus4_out(ID_EX_PCplus4),
    .readData1_out(ID_EX_readData1),
    .readData2_out(ID_EX_readData2),
    .imm_out(ID_EX_imm),
    .rs_out(ID_EX_rs),
    .rt_out(ID_EX_rt),
    .rd_out(ID_EX_rd),
    .funct_out(ID_EX_funct),

    .RegDst_out(ID_EX_RegDst),
    .ALUSrc_out(ID_EX_ALUSrc),
    .ALUOp_out(ID_EX_ALUOp),
    .MemRead_out(ID_EX_MemRead),
    .MemWrite_out(ID_EX_MemWrite),
    .MemtoReg_out(ID_EX_MemtoReg),
    .RegWrite_out(ID_EX_RegWrite),
    .Branch_out(ID_EX_Branch),
    .Jump_out(ID_EX_Jump)
);

//========================================================
// FORWARDING UNIT
//========================================================
ForwardingUnit fwd (
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_WriteReg(MEM_WB_WriteReg),
    .ID_EX_rs(ID_EX_rs),
    .ID_EX_rt(ID_EX_rt),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

//========================================================
// EX STAGE
//========================================================
assign ALU_in1 =
    (ForwardA == 2'b10) ? EX_MEM_ALUResult :
    (ForwardA == 2'b01) ? WB_WriteData :
                          ID_EX_readData1;

assign ALU_op2 =
    (ForwardB == 2'b10) ? EX_MEM_ALUResult :
    (ForwardB == 2'b01) ? WB_WriteData :
                          ID_EX_readData2;

assign ALU_in2 = (ID_EX_ALUSrc ? ID_EX_imm : ALU_op2);

ALUControl alu_ctl (
    .ALUOp(ID_EX_ALUOp),
    .funct(ID_EX_funct),
    .ALUControl(ALUControl)
);

ALU alu (
    .A(ALU_in1),
    .B(ALU_in2),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

assign BranchTarget = ID_EX_PCplus4 + (ID_EX_imm << 2);
assign WriteReg_EX  = (ID_EX_RegDst ? ID_EX_rd : ID_EX_rt);

//========================================================
// EX/MEM PIPELINE REGISTER
//========================================================
EX_MEM ex_mem (
    .clk(clk),
    .reset(reset),
    .flush(1'b0),                         // was 0
    .stall(1'b0),                         // was 0

    .ALUResult_in(ALUResult),
    .readData2_in(ALU_op2),
    .BranchTarget_in(BranchTarget),
    .Zero_in(Zero),
    .WriteReg_in(WriteReg_EX),

    .MemRead_in(ID_EX_MemRead),
    .MemWrite_in(ID_EX_MemWrite),
    .MemtoReg_in(ID_EX_MemtoReg),
    .RegWrite_in(ID_EX_RegWrite),
    .Branch_in(ID_EX_Branch),
    .Jump_in(ID_EX_Jump),

    .ALUResult_out(EX_MEM_ALUResult),
    .readData2_out(EX_MEM_readData2),
    .BranchTarget_out(EX_MEM_BranchTarget),
    .Zero_out(EX_MEM_Zero),
    .WriteReg_out(EX_MEM_WriteReg),

    .MemRead_out(EX_MEM_MemRead),
    .MemWrite_out(EX_MEM_MemWrite),
    .MemtoReg_out(EX_MEM_MemtoReg),
    .RegWrite_out(EX_MEM_RegWrite),
    .Branch_out(EX_MEM_Branch),
    .Jump_out(EX_MEM_Jump)
);

//========================================================
// MEM STAGE
//========================================================
DataMemory dmem (
    .clk(clk),
    .MemRead(EX_MEM_MemRead),
    .MemWrite(EX_MEM_MemWrite),
    .addr(EX_MEM_ALUResult),
    .writeData(EX_MEM_readData2),
    .readData(ReadData_MEM)
);

//========================================================
// MEM/WB PIPELINE REGISTER
//========================================================
MEM_WB mem_wb (
    .clk(clk),
    .reset(reset),
    .stall(1'b0),                         // was 0
    .flush(1'b0),                         // was 0

    .ReadData_in(ReadData_MEM),
    .ALUResult_in(EX_MEM_ALUResult),
    .WriteReg_in(EX_MEM_WriteReg),
    .RegWrite_in(EX_MEM_RegWrite),
    .MemtoReg_in(EX_MEM_MemtoReg),

    .ReadData_out(MEM_WB_ReadData),
    .ALUResult_out(MEM_WB_ALUResult),
    .WriteReg_out(MEM_WB_WriteReg),
    .RegWrite_out(MEM_WB_RegWrite),
    .MemtoReg_out(MEM_WB_MemtoReg)
);

//========================================================
// WRITEBACK
//========================================================
assign WB_WriteData =
    (MEM_WB_MemtoReg ? MEM_WB_ReadData : MEM_WB_ALUResult);

//========================================================
// FINAL PC UPDATE
//========================================================
assign nextPC =
    (!PCWrite)      ? PC :
    Jump            ? JumpTarget :
    BranchTaken     ? BranchTarget :
                      PCplus4;

endmodule
