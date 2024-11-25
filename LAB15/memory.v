module memory (
    input clk,
    input wire [7:0] address,     // Address input
    output reg [15:0] instruction // Instruction output
);
    reg [15:0] instrmemory [0:255];    // Memory storage (256 instructions max)

    initial begin
        $readmemh("instructions.hex", instrmemory); // Preload instructions from a file
    end

    always @(posedge clk) begin
        instruction <= instrmemory[address];
    end
endmodule
