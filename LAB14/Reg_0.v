module Reg_0 (
    input wire clk,
    input wire rst,
    input wire en_0,
    input wire [15:0] d_in,
    output reg [15:0] d_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d_out <= 16'b0;
        end else if (en_0) begin
            d_out <= d_in;
        end
    end

endmodule

