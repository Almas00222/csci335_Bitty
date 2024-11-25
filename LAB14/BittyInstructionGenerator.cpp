#include "BittyInstructionGenerator.h"

BittyInstructionGenerator::BittyInstructionGenerator() : dist(0, 0xFFFF) {
    rng.seed(std::random_device{}());
}

uint16_t BittyInstructionGenerator::Generate() {
    return dist(rng);
}
