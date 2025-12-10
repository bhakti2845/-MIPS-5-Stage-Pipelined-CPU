# MIPS 5-Stage Pipelined Processor

This repository contains a modular implementation of a **32-bit MIPS 5-stage pipelined processor** in **Verilog HDL**.  
The design follows the standard pipeline structure used in computer architecture: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execute (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**.

The processor includes forwarding, hazard detection, branch control, and separate pipeline registers for each stage.  
A complete testbench and simulation scripts are provided.

---

## 1. Overview

This project provides a clear, modular RTL implementation of a pipelined MIPS processor.  
It is intended for:

- Instruction-level pipeline understanding  
- RTL design practice  
- Architecture education  
- Simulation and waveform debugging  

The design emphasizes correctness and readability.

---

## 2. Pipeline Architecture

The processor implements the classical 5-stage pipeline:

```
IF → ID → EX → MEM → WB
```

Pipeline registers maintain stage separation:

- `IF_ID`
- `ID_EX`
- `EX_MEM`
- `MEM_WB`

Control signals propagate through these registers to maintain precise pipeline behavior.

---

## 3. Key Features

- Standard 5-stage pipelined datapath  
- Load-use hazard detection and pipeline stalls  
- Forwarding logic for ALU dependencies  
- Branch/jump handling with flush  
- Instruction memory loading from external file  
- Modular Verilog structure for easy extension  
- Testbench for simulation and register/memory observation  

---

## 4. Project Structure

```text
MIPS-Pipeline-CPU/
│
├── src/                   
│   ├── ALU.v
│   ├── ALUControl.v
│   ├── ControlUnit.v
│   ├── DataMemory.v
│   ├── ForwardingUnit.v
│   ├── HazardDetectionUnit.v
│   ├── IF_ID.v
│   ├── ID_EX.v
│   ├── EX_MEM.v
│   ├── MEM_WB.v
│   ├── ImmGen.v
│   ├── InstructionMemory.v
│   ├── ProgramCounter.v
│   ├── RegisterFile.v
│   └── MIPSPipelineCPU.v
│
├── sim/                    
│   ├── tb_MIPSPipelineCPU.v
│   └── program.mem
│
└── doc/
    ├── block_diagram.png
    └── MIPS_Green_Sheet.pdf
```

---

## 5. Instruction Subset

### **R-type**
- `add`, `sub`, `and`, `or`, `slt`, `mul`

### **I-type**
- `addi`, `andi`, `ori`  
- `lw`, `sw`  
- `beq`, `bne`

### **J-type**
- `j`, `jal` (optional)

---

## 6. Simulation Instructions (Vivado)

### GUI Simulation
1. Create a new **RTL project**  
2. Add all files in `src/`  
3. Add `tb_MIPSPipelineCPU.v`  
4. Ensure `program.mem` is accessible to the simulator  
5. Run **Behavioral Simulation**

Waveforms can be used to inspect:

- PC progression  
- Pipeline stages  
- Forwarding paths  
- Hazard stalls  
- Memory operations  

---

## 7. Tcl Commands

```bash
launch_simulation
add_wave -recursive /
run 500ns
```

---

## 8. Core Modules

| Module Name              | Description |
|--------------------------|-------------|
| **ProgramCounter**       | Maintains PC; handles next-PC logic, stalls, and branch/jump updates. |
| **InstructionMemory**    | Read-only memory initialized via `$readmemh`. |
| **ControlUnit**          | Decodes opcode/funct fields to generate control signals. |
| **RegisterFile**         | 32×32 register array with synchronous write and two read ports. |
| **ImmGen**               | Generates sign/zero-extended immediates. |
| **ALU**                  | Performs arithmetic/logical operations; outputs result and zero flag. |
| **ALUControl**           | Maps ALUOp and funct fields to specific ALU operations. |
| **HazardDetectionUnit**  | Detects load-use hazards and issues stall/flush signals. |
| **ForwardingUnit**       | Resolves EX data hazards using forwarding paths. |
| **DataMemory**           | Implements memory read/write for load/store instructions. |
| **IF_ID**                | Pipeline register between IF and ID. |
| **ID_EX**                | Pipeline register between ID and EX. |
| **EX_MEM**               | Pipeline register between EX and MEM. |
| **MEM_WB**               | Pipeline register between MEM and WB. |
| **MIPSPipelineCPU**      | Top-level integration; connects datapath, control, forwarding, and hazard logic. |

---

## 9. Block Diagram

![Block Diagram](https://github.com/bhakti2845/-MIPS-5-Stage-Pipelined-CPU/blob/main/doc/block%20diagram.png)

---

## 10. Future Extensions

- Additional MIPS instructions  
- Branch prediction support  
- Exception and interrupt handling  
- FPGA mapping (switches/LEDs for visualization)  
- SystemVerilog/UVM verification environment  

---

## 11. References

- David A. Patterson, John L. Hennessy — *Computer Organization and Design: The Hardware/Software Interface*  
- MIPS Architecture Reference — *MIPS Green Sheet*  
