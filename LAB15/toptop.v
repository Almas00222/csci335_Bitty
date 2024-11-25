module toptop (
    input wire clk,            // Clock signal
    input wire reset,          // Reset signal
    input wire run,            // Signal to start execution
    output wire done,          // Indicates instruction execution completion
    output wire [15:0] instruction   // Instruction fetched by the fetch module
);

    // Fetch Unit
    fetch fetch_unit (
        .clk(clk),
        .reset(reset),
        .done(done),           // Indicates the processor completed the instruction
        .instruction(instruction) // Outputs the fetched instruction
    );

    // Processor (Top Module)
    top processor (
        .clk(clk),
        .reset(reset),
        .run(run),             // Signal to run the processor
        .instruction(instruction), // Instruction provided by the fetch module
        .done(done)            // Completion signal from the processor
    );
endmodule

