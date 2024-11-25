#include <verilated.h>
#include <verilated_vcd_c.h>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <vector>
#include "Vtoptop.h" // Include the generated header for toptop

int main(int argc, char** argv, char** env) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);

    // Instantiate the toptop module
    Vtoptop* toptop = new Vtoptop;

    // Enable waveform tracing
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    toptop->trace(tfp, 99); // Trace 99 levels of hierarchy
    tfp->open("toptop.vcd"); // Output VCD file

    // Open instructions.hex to read the instructions
    std::ifstream instruction_file("instructions.hex");
    if (!instruction_file.is_open()) {
        std::cerr << "Error: Could not open instructions.hex\n";
        return 1;
    }

    // Read instructions into a vector
    std::vector<uint16_t> instructions;
    std::string line;
    while (std::getline(instruction_file, line)) {
        uint16_t instruction = std::stoul(line, nullptr, 16); // Convert hex string to integer
        instructions.push_back(instruction);
    }
    instruction_file.close();

    // Simulation variables
    vluint64_t sim_time = 0;
    const vluint64_t max_sim_time = 100; // Adjust based on expected simulation duration
    bool clk = false;

    // Initialize simulation state
    size_t instruction_index = 0;
    bool fetch_instruction = true;
    
    // Simulation loop
    while (sim_time < max_sim_time) {
        // Toggle clock
        clk = !clk;
        toptop->clk = clk;

        // Apply reset for the first 10 cycles
        if (sim_time < 10) {
            toptop->reset = 1;
        } else {
            toptop->reset = 0;
        }

        // Before `done` is high: System executes the current instruction
        if (!toptop->done) {
            if (clk && fetch_instruction && instruction_index < instructions.size()) {
                // Feed the current instruction
                toptop->instruction = instructions[instruction_index];
                // toptop->run = 1; // Start processing the instruction
                fetch_instruction = false; // Wait for execution
            }
        }
          
        
          // Set initial register values
        toptop->d_out_0 = 0x1EFD;
    toptop->d_out_1 = 0xF541;
    toptop->d_out_2 = 0x568A;
    toptop->d_out_3 = 0xBD23;
    toptop->d_out_4 = 0xAE87;
    toptop->d_out_5 = 0xBFFA;
    toptop->d_out_6 = 0xC060;
    toptop->d_out_7 = 0xF1A;
        // After `done` is high: Fetch the next instruction and apply branch logic
        if (clk && toptop->done) {
            std::cout << "Cycle: " << sim_time
                      << " | Instruction Executed: 0x" << std::hex << instructions[instruction_index] << std::endl;

            // Print register outputs
            std::cout << "Registers: " << std::endl
                      << "  d_out_c: 0x" << std::hex << toptop->d_out_c << std::endl
                      << "  d_out_0: 0x" << std::hex << toptop->d_out_0 << std::endl
                      << "  d_out_1: 0x" << std::hex << toptop->d_out_1 << std::endl
                      << "  d_out_2: 0x" << std::hex << toptop->d_out_2 << std::endl
                      << "  d_out_3: 0x" << std::hex << toptop->d_out_3 << std::endl
                      << "  d_out_4: 0x" << std::hex << toptop->d_out_4 << std::endl
                      << "  d_out_5: 0x" << std::hex << toptop->d_out_5 << std::endl
                      << "  d_out_6: 0x" << std::hex << toptop->d_out_6 << std::endl
                      << "  d_out_7: 0x" << std::hex << toptop->d_out_7 << std::endl;
  
            // Move to the next instruction
            instruction_index++;
            fetch_instruction = true; // Ready to fetch the next instruction
        }

        // Evaluate the design and dump the waveform
        
        tfp->dump(sim_time);
        toptop->eval();
         // Dump the current simulation time to the VCD file

        // Stop simulation when all instructions are processed
        if (instruction_index >= instructions.size()) {
            std::cout << "All instructions executed successfully.\n";
            break;
        }

        // Increment simulation time
        sim_time++;
    }

    // Cleanup
    tfp->close(); // Close the trace file
    toptop->final();
    delete toptop;
    delete tfp;

    return 0;
}
