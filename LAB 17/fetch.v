module fetch (
    input wire clk,
    input wire reset,
    input wire done,
    output wire [15:0] instruction
);
    wire [7:0] pcin;
    wire [7:0] pcout;
    
    pc pc_unit (
	.pcin(pcin),
        .clk(clk),
        .reset(reset),
        .enable(enable_pc),
        .pcout(pcout)
    );

    memory memory (
	.clk(clk),
        .address(pcout),
        .instruction(instruction)
    );
endmodule
