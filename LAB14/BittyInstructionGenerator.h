#ifndef BITTY_INSTRUCTION_GENERATOR_H
#define BITTY_INSTRUCTION_GENERATOR_H

#include <cstdint>
#include <random>

class BittyInstructionGenerator {
public:
    BittyInstructionGenerator();
    uint16_t Generate();  // Generates a random 16-bit instruction

private:
    std::mt19937 rng;
    std::uniform_int_distribution<uint16_t> dist;
};

#endif // BITTY_INSTRUCTION_GENERATOR_H
