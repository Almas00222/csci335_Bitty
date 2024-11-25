module mux (
    input [2:0] sel,         // Selection signal
    input [15:0] d_out_0,    // Data output from Register 0
    input [15:0] d_out_1,    // Data output from Register 1
    input [15:0] d_out_2,    // Data output from Register 2
    input [15:0] d_out_3,    // Data output from Register 3
    input [15:0] d_out_4,    // Data output from Register 4
    input [15:0] d_out_5,    // Data output from Register 5
    input [15:0] d_out_6,    // Data output from Register 6
    input [15:0] d_out_7,    // Data output from Register 7
    output reg [15:0] out    // Selected output
);

  always @(*) begin
    case (sel)
        3'b000: out = d_out_0;
        3'b001: out = d_out_1;
        3'b010: out = d_out_2;
        3'b011: out = d_out_3;
        3'b100: out = d_out_4;
        3'b101: out = d_out_5;
        3'b110: out = d_out_6;
        3'b111: out = d_out_7;
        default: out = 16'hFFFF;
    endcase
  end
endmodule
