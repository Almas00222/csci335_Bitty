module branch_logic (
    input branch_done,
    input [15:0] memory_out,
    input [15:0] branch_alu,
    input [7:0] in_pc,
    output reg [7:0] new_pc
);

    always @(*) begin
    if (memory_out[1:0] == 2'b10) begin
        case (memory_out[3:2])
            2'b00: begin
                if (branch_alu == 16'd0) begin
                    new_pc = memory_out[11:4];
                end else begin
                    new_pc = in_pc + 1;
                end
            end
            2'b01: begin
                if (branch_alu == 16'd1) begin
                    new_pc = memory_out[11:4];
                end else begin
                    new_pc = in_pc + 1;
                end
            end
            2'b10: begin
                if (branch_alu == 16'd2) begin
                    new_pc = memory_out[11:4];
                end else begin
                    new_pc = in_pc + 1;
                end
            end
            default: begin
                new_pc = in_pc + 1;
            end
        endcase
        end else begin new_pc = in_pc + 1;
        end
    end

endmodule
