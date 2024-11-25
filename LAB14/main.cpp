#include <iostream>
#include <cassert>
#include "BittyEmulator.h"

using namespace std;

int main() {
    BittyEmulator emulator;

    // Test 1: Load immediate value
    uint16_t loadInstruction = 0x1123;
    emulator.Evaluate(loadInstruction);
	for (int i  = 0; i < 8; i++) { 
   cout << emulator.GetRegisterValue(i) << "\n";
}

uint16_t lInstruction = 0x1AE5;
emulator.Evaluate(lInstruction);

for (int i  = 0; i < 8; i++) { 
   cout << emulator.GetRegisterValue(i) << "\n";
}
    return 0;
}
