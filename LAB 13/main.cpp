#include <iostream>
#include <cassert>
#include "BittyEmulator.h"

using namespace std;

int main() {
    BittyEmulator emulator;

    // Test 1: Load immediate value
    uint16_t loadInstruction = 0x1123; // Example instruction: opcode=0x1, reg=0x1, value=0x23
//    registers_[0] = 7;
  //  registers_[5] = 3;
    emulator.Evaluate(loadInstruction);
	for (int i  = 0; i < 8; i++) { 
   cout << emulator.GetRegisterValue(i) << "\n";
}

uint16_t lInstruction = 0x1AE5;
emulator.Evaluate(lInstruction);

for (int i  = 0; i < 8; i++) { 
   cout << emulator.GetRegisterValue(i) << "\n";
}




    // assert(emulator.GetRegisterValue(1) == 0x23);
    // cout << "Test 1 passed.\n";
    // 1000100100011 000 100 01001 000 11
    // Test 2: Addition
    // uint16_t addInstruction = 0x2101; // Example instruction: opcode=0x2, reg=1 += reg 0
    // emulator.Evaluate(addInstruction);
    // uint16_t expectedValue = emulator.GetRegisterValue(1); // Replace with actual expected value
    // assert(emulator.GetRegisterValue(1) == expectedValue);
    // cout << emulator.GetRegisterValue(1);
    // cout << "Test 2 passed.\n";

    // Add more tests as needed...

    return 0;
}
