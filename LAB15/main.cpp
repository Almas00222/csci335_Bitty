#include <iostream>
#include <fstream>
#include <cstdlib>  // For std::atoi
#include "BittyInstructionGenerator.h"

int main(int argc, char* argv[]) {
    // Ensure correct usage
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <N> <output_file>\n";
        std::cerr << "  N: Number of instructions to generate\n";
        std::cerr << "  output_file: File to save the instructions\n";
        return 1;
    }

    // Parse arguments
    int instructionCount = std::atoi(argv[1]);
    if (instructionCount <= 0) {
        std::cerr << "Error: N must be a positive integer.\n";
        return 1;
    }

    std::string filename = argv[2];

    // Open output file
    std::ofstream fileStream(filename);
    if (!fileStream.is_open()) {
        std::cerr << "Error: Cannot open file " << filename << " for writing.\n";
        return 1;
    }

    // Generate instructions
    BittyInstructionGenerator instructionGenerator;
    for (int i = 0; i < instructionCount; ++i) {
        uint16_t instruction = instructionGenerator.Generate();
        fileStream << std::hex << instruction << std::endl;  // Write in hex format
    }

    std::cout << "Generated " << instructionCount << " instructions to " << filename << "\n";

    fileStream.close();
    return 0;
}
