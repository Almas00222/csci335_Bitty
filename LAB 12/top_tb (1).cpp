#include "Vtop.h" 
#include "verilated.h" 
#include "verilated_vcd_c.h" 
#include <iostream> 
#include <iomanip> 

void check_d_out_7(Vtop* top, vluint64_t sim_time, uint32_t expected, const std::string& operation) {
    std::cout << "Checking d_out_7 for " << operation << " at time: " << sim_time << " ps" << std::endl;
    
    if (top->d_out_7 == expected) {
        std::cout << "Time: " << sim_time << " ps" << std::endl;
        std::cout << "d_out_7: " << std::hex << top->d_out_7 << std::endl;
        std::cout << operation << " result is correct at time: " << sim_time << " ps" << std::endl;
    } else {
        std::cout << "Time: " << sim_time << " ps" << std::endl;
        std::cout << "d_out_7: " << std::hex << top->d_out_7 << std::endl;
        std::cout << operation << " result is incorrect at time: " << sim_time << " ps" << std::endl;
    }
}

void execute_instruction(Vtop* top, VerilatedVcdC* tfp, vluint64_t& sim_time, vluint64_t max_sim_time, bool& clk, uint16_t d_out_7, uint16_t d_out_0, uint16_t instruction, uint32_t expected_d_out_7, const std::string& operation) {
    // Issue instruction
    top->instruction = instruction;
    top->d_out_7 = d_out_7;
    top->d_out_0 = d_out_0;
    std::cout << "Instruction: " << operation << " written at time " << sim_time << " ps" << std::endl;

    // Wait for done to go high
    while (!top->done && sim_time < max_sim_time) {
        sim_time++;
        top->clk = clk;
        top->eval();
        tfp->dump(sim_time);
        clk = !clk;
    }

    // Check d_out_7 after done signal is high
    check_d_out_7(top, sim_time, expected_d_out_7, operation);

    // Wait for done to go low again before issuing the next instruction
    while (top->done && sim_time < max_sim_time) {
        sim_time++;
        top->clk = clk;
        top->eval();
        tfp->dump(sim_time);
        clk = !clk;
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    // Enable waveform dumping for GTKWave
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("waveform.vcd");

    vluint64_t sim_time = 0;
    vluint64_t max_sim_time = 300; // Maximum simulation time
    bool clk = false;

    // Initial global reset
    top->clk = 0;
    top->reset = 1;
    top->run = 0;
    top->instruction = 0x0000;
    top->d_out_7 = 0x0000;

    // First 20 cycles to stabilize reset
    while (sim_time < 20) {
        top->clk = clk;
        top->eval();
        tfp->dump(sim_time);
        clk = !clk;
        sim_time++;
    }

    // De-assert reset
    top->reset = 0;
    top->run = 1;

    // Main simulation loop
    if (sim_time >= 20) {
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0xFFFF, 0xFFFF, 0xE000, 0xFFFE, "addition");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0xFFFF, 0xFFFF, 0xE004, 0x0000, "subtraction");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0xFFFF, 0xFFFF, 0xE008, 0xFFFF, "AND");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0xFFFF, 0xFFFF, 0xE00C, 0xFFFF, "OR");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0xFFFF, 0xFFFF, 0xE010, 0x0000, "XOR");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0x000F, 0x0001, 0xE014, 0x001E, "Shift_Left");
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, 0x00F0, 0x0001, 0xE018, 0x0078, "Shift_Right");
        
        // Special case: Comparison, as it compares `d_out_7` with `d_out_0`
        top->instruction = 0xE01C;
	top->d_out_7 = 0xFFFF;
	top->d_out_0 = 0xFFFF;
        std::cout << "Instruction: COMPARISON written at time " << sim_time << " ps" << std::endl;
        if (top->d_out_7 == top->d_out_0) {
            std::cout << "cmp rx = 0 at time " << sim_time << " ps" << std::endl;
        } else if (top->d_out_7 > top->d_out_0) {
            std::cout << "cmp rx = 1 at time " << sim_time << " ps" << std::endl;
        } else {
            std::cout << "cmp rx = 2 at time " << sim_time << " ps" << std::endl;
        }

        // Wait for done to go low again before finishing
        while (top->done && sim_time < max_sim_time) {
            sim_time++;
            top->clk = clk;
            top->eval();
            tfp->dump(sim_time);
            clk = !clk;
        }
    }

    // Close tracing file
    tfp->close();

    // Cleanup
    delete top;
    delete tfp;

    return 0;
}

