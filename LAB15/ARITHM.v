module ARITHM(
  input wire [15:0] in_a,
  input wire [15:0] in_b,
  input wire [2:0] select,
  output reg [15:0] alu_out
);

  reg [15:0] temp_result;

always @(*) begin      
    temp_result = 16'b0;
    
case (select)
    3'b000: temp_result = (in_a) + (in_b);
    3'b001: temp_result = (in_a) - (in_b);
    3'b010: temp_result = (in_a) & (in_b);
    3'b011: temp_result = (in_a) | (in_b);
    3'b100: temp_result = (in_a) ^ (in_b);
    3'b101: temp_result = (in_a) << (in_b);
    3'b110: temp_result = (in_a) >> (in_b);
    3'b111: begin
    if (in_a == in_b) temp_result = 16'b0;
    else if (in_a > in_b) temp_result = 16'b1;
    else if (in_a < in_b) temp_result = 16'b10;
    end
    default: temp_result = 16'b0;
    endcase
    alu_out = temp_result;
end
    
  endmodule
