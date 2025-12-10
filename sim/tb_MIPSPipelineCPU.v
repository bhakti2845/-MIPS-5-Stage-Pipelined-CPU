`timescale 1ns/1ps

module tb_MIPSPipelineCPU;

    reg clk;
    reg reset;

    // Instantiate DUT
    MIPSPipelineCPU dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        reset = 1;
        #20;
        reset = 0;
    end

    integer i;   // ✅ DECLARED OUTSIDE initial begin!

    // Dump contents at end of simulation
    initial begin
        #1000;

        $display("\n=============== REGISTER FILE DUMP ===============");
        for (i = 0; i < 32; i = i + 1)
            $display("R[%0d] = %h", i, dut.rf.regfile[i]);

        $display("\n================ DATA MEMORY DUMP =================");
        for (i = 0; i < 8; i = i + 1)
            $display("MEM[%0d] = %h", i, dut.dmem.dmem[i]);

        $display("====================================================");
        $finish;
    end

endmodule
