module fetch (
    input wire clk,
    input wire reset,
    input wire done,            // Indicates instruction execution completion
    output wire [15:0] instruction,
    output wire [15:0] d_out_c
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
	
    branch_logic branch_logic (
    	.in_pc(pcout),
    	.branch_done(done),
	.memory_out(instruction),
	.branch_alu(d_out_c),
	.new_pc(pcin)
	);
    
    memory memory (
	.clk(clk),
        .address(pcout),
        .instruction(instruction)
    );
endmodule
