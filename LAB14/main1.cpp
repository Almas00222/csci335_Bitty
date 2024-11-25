#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>  // Include VCD header for GTKWave
#include "Vtop.h"
#include "BittyEmulator.h"
#include "BittyInstructionGenerator.h"
#include <vector>

using namespace std;

uint16_t g_hw_result = 0;

// Extracts the register index for RX from the instruction
int hwR(uint16_t instruction) {
    int rx_index = (instruction >> 13) & 0x7;
    return rx_index;
}

void execute_instruction(Vtop* top, VerilatedVcdC* tfp, vluint64_t& sim_time, vluint64_t max_sim_time, bool& clk, uint16_t instruction) {
    // Your existing code here, no change needed
    // Decode Rx, Ry, and ALU select from the instruction
    uint16_t rx = (instruction >> 13) & 0x7;    // Extract bits 15-13 for Rx
    uint16_t ry = (instruction >> 10) & 0x7;    // Extract bits 12-10 for Ry
    uint16_t alu_sel = (instruction >> 2) & 0x7; // Extract bits 4-2 for ALU select
    std::cout << "The instruction: " << std::hex << instruction << '\n';
    vector<uint16_t> d_out_{top->d_out_0, top->d_out_1, top->d_out_2, top->d_out_3, top->d_out_4, top->d_out_5, top->d_out_6, top->d_out_7};
    uint16_t a = d_out_[rx];  // Use d_out_[rx] as the input 'a' for the ALU
    uint16_t b = d_out_[ry];
    std::cout << "First register: " << std::hex << d_out_[rx] << ", Register number: " << rx << "\n";
    std::cout << "Second register: " << std::hex << d_out_[ry] << ", Register number: " << ry << "\n";
    uint16_t expected_result;
    std::string operation;
    switch (alu_sel) {
        case 0: 
            expected_result = d_out_[rx] + d_out_[ry]; 
            operation = "Addition";
            break;
        case 1: 
            expected_result = d_out_[rx] - d_out_[ry]; 
            operation = "Subtraction";
            break;
        case 2: 
            expected_result = d_out_[rx] & d_out_[ry]; 
            operation = "AND";
            break;
        case 3: 
            expected_result = d_out_[rx] | d_out_[ry]; 
            operation = "OR";
            break;
        case 4: 
            expected_result = d_out_[rx] ^ d_out_[ry]; 
            operation = "XOR";
            break;
        case 5: 
            expected_result = d_out_[rx] << (d_out_[ry] & 0xF);
            operation = "Shift Left";
            break;
        case 6: 
            expected_result = d_out_[rx] >> (d_out_[ry] & 0xF);
            operation = "Shift Right";
            break;
        case 7:
            if (d_out_[rx] == d_out_[ry]) expected_result = 0;
            else if (d_out_[rx] > d_out_[ry]) expected_result = 1;
            else expected_result = 2;
            operation = "Comparison";
            break;
        default: 
            expected_result = 0;
            operation = "Unknown";
            break;
    }

    // Issue the instruction to the ALU
    top->instruction = instruction;
    std::cout << "Executing instruction: " << operation << " (Rx = " << rx << ", Ry = " << ry << ")" << std::endl;
    
    // Dump to VCD file in each clock cycle
    while (!top->done && sim_time < max_sim_time) {
        sim_time++;
        top->clk = clk;
        top->eval();
        tfp->dump(sim_time);  // Dump state to VCD
        clk = !clk;
    }
    // Continue with the rest of the function as in your existing code
}

void tick(Vtop* dut, VerilatedVcdC* tfp, vluint64_t& sim_time) {
    dut->clk = 1;
    dut->eval();
    tfp->dump(sim_time++);  // Dumping state for rising edge
    dut->clk = 0;
    dut->eval();
    tfp->dump(sim_time++);  // Dumping state for falling edge
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;
    // Create VCD trace object
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Verilated::traceEverOn(true);  // Enable trace generation
    top->trace(tfp, 5);  // Trace with depth of 5 (changeable as needed)
    tfp->open("trace.vcd");  // Open VCD file for output

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
        //top->eval();
        tfp->dump(sim_time);  // Dump to VCD
        clk = !clk;
        sim_time++;
    }

    // De-assert reset
    top->reset = 0;
    top->run = 1;
    
    
    
    // Main simulation loop
       

    BittyEmulator emulator;
    BittyInstructionGenerator generator;

    const int num_tests = 5;
    bool all_tests_passed = true;

    for (int i = 0; i < num_tests; i++) {
        uint16_t instruction = generator.Generate();
        top->d_out_0 = emulator.GetRegisterValue(0);
        top->d_out_1 = emulator.GetRegisterValue(1);
        top->d_out_2 = emulator.GetRegisterValue(2);
        top->d_out_3 = emulator.GetRegisterValue(3);
        top->d_out_4 = emulator.GetRegisterValue(4);
        top->d_out_5 = emulator.GetRegisterValue(5);
        top->d_out_6 = emulator.GetRegisterValue(6);
        top->d_out_7 = emulator.GetRegisterValue(7);
        vector<uint16_t> vec{top->d_out_0, top->d_out_1, top->d_out_2, top->d_out_3, top->d_out_4, top->d_out_5, top->d_out_6, top->d_out_7};
        
        uint16_t emu_res = emulator.Evaluate(instruction);
        top->instruction = instruction;
        
        if (sim_time >= 20) {
        execute_instruction(top, tfp, sim_time, max_sim_time, clk, instruction);
        // Wait for done to go low again before finishing
        while (top->done && sim_time < max_sim_time) {
            sim_time++;
            top->clk = clk;
            top->eval();
            clk = !clk;
        }
    }
        
    }


    // Close the VCD file and cleanup
    tfp->close();
    delete tfp;
    delete top;

    return all_tests_passed ? 0 : 1;
