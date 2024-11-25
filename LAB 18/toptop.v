module toptop (
    input wire clk,            // Clock signal
    input wire reset,          // Reset signal
    output wire done,          // Indicates instruction execution completion
    output wire [15:0] instruction,   // Instruction fetched by the fetch module
    output reg [15:0] d_out_0,
   	 output reg [15:0] d_out_1,
   	 output reg [15:0] d_out_2,
   	 output reg [15:0] d_out_3,
   	 output reg [15:0] d_out_4,
   	 output reg [15:0] d_out_5,
   	 output reg [15:0] d_out_6,
  	 output reg [15:0] d_out_7,
  	 output reg [15:0] d_out_c
);

    // Fetch Unit
    fetch fetch_unit (
    	.d_out_c(d_out_c),
        .clk(clk),
        .reset(reset),
        .done(done),           // Indicates the processor completed the instruction
        .instruction(instruction) // Outputs the fetched instruction
    );

    // Processor (Top Module)
    top processor (
    	.d_out_c(d_out_c),
    	.d_out_0(d_out_0),
   	 .d_out_1(d_out_1),
   	 .d_out_2(d_out_2),
   	 .d_out_3(d_out_3),
   	 .d_out_4(d_out_4),
   	 .d_out_5(d_out_5),
   	 .d_out_6(d_out_6),
  	 .d_out_7(d_out_7),
        .clk(clk),
        .reset(reset),
        .instruction(instruction), // Instruction provided by the fetch module
        .done(done)            // Completion signal from the processor
    );
endmodule
