#include <iostream>
#include "BittyEmulator.h"

extern "C" void notify_done(uint16_t instruction) {
    static BittyEmulator emulator;
    emulator.Evaluate(instruction);
    // Here, we could compare the emulator's register values with the Verilog model.
    std::cout << "Instruction " << instruction << " evaluated." << std::endl;
}
