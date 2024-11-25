module fetch (
    input wire clk,
    input wire reset,
    input wire done,            // Indicates instruction execution completion
    output wire [15:0] instruction
);
    wire [7:0] pc;

    pc pc_unit (
	.pcin(pc),
        .clk(clk),
        .reset(reset),
        .enable(done),
        .pcout(pc)
    );

    memory memory (
	.clk(clk),
        .address(pc),
        .instruction(instruction)
    );
endmodule
