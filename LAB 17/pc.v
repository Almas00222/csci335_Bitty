module pc (
    input wire [7:0] pcin,
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] pcout
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pcout <= 8'd0;  // Reset to the start address
        else if (enable)
            pcout <= pcin + 1; // Increment to the next instruction
    end
endmodule
