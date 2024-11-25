module mux (
    input [3:0] sel,         // Selection signal
    input [15:0] d_out_0,    // Data output from Register 0
    input [15:0] d_out_1,    // Data output from Register 1
    input [15:0] d_out_2,    // Data output from Register 2
    input [15:0] d_out_3,    // Data output from Register 3
    input [15:0] d_out_4,    // Data output from Register 4
    input [15:0] d_out_5,    // Data output from Register 5
    input [15:0] d_out_6,    // Data output from Register 6
    input [15:0] d_out_7,    // Data output from Register 7
    input [15:0] immediate_value,
    output reg [15:0] out    // Selected output
);

  always @(*) begin
    case (sel)
        4'b0000: out = d_out_0;
        4'b0001: out = d_out_1;
        4'b0010: out = d_out_2;
        4'b0011: out = d_out_3;
        4'b0100: out = d_out_4;
        4'b0101: out = d_out_5;
        4'b0110: out = d_out_6;
        4'b0111: out = d_out_7;
        4'b1000: out = immediate_value;
        default: out = 16'hFFFF;
    endcase
  end
endmodule
