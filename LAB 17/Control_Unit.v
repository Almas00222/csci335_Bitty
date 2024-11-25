module Control_Unit(
    input clk,
    input rst,

    input [15:0] instruction,

    output reg [2:0] alu_sel,
    output reg [3:0] mux_sel,

    output reg ctrl_enable_0,
    output reg ctrl_enable_1,
    output reg ctrl_enable_2,
    output reg ctrl_enable_3,
    output reg ctrl_enable_4,
    output reg ctrl_enable_5,
    output reg ctrl_enable_6,
    output reg ctrl_enable_7,
    output reg ctrl_enable_i,
    output reg ctrl_enable_s,
    output reg ctrl_enable_c,
    output reg [15:0] immediate_value,
    output reg ctrl_done_out
);
	reg run;
    // State parameters
    parameter STATE_0 = 2'b00;
    parameter STATE_1 = 2'b01;
    parameter STATE_2 = 2'b10;
    parameter STATE_3 = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] mux_sel_rx; // Fixed bit-width mismatch
    
    assign run = instruction[1:0]!=2'b10;
    
    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
    case (current_state)
        STATE_0: begin
            if (run)
                next_state = STATE_1;
            else
                next_state = STATE_0; // Stay in STATE_0 if run is 0
        end
        STATE_1: next_state = STATE_2;
        STATE_2: next_state = STATE_3;
        STATE_3: next_state = STATE_0;
        default: next_state = STATE_0;
    endcase
end

	
    // Output logic
    always @(*) begin
        // Reset control signals
        ctrl_done_out = 1'b0;
        ctrl_enable_0 = 1'b0;
        ctrl_enable_1 = 1'b0;
        ctrl_enable_2 = 1'b0;
        ctrl_enable_3 = 1'b0;
        ctrl_enable_4 = 1'b0;
        ctrl_enable_5 = 1'b0;
        ctrl_enable_6 = 1'b0;
        ctrl_enable_7 = 1'b0;
        ctrl_enable_s = 1'b0;
        ctrl_enable_c = 1'b0;
        ctrl_enable_i = 1'b0;

        immediate_value = 16'b0;
        mux_sel = 4'b0000;
        alu_sel = 3'b000;

        // Control outputs based on state
        case (current_state)
            STATE_0: begin
            if (run) begin
                ctrl_enable_i = 1'b1;
                ctrl_enable_s = 1'b1;
                mux_sel = {1'b0, instruction[15:13]};
                end
            end
            STATE_1: begin
                ctrl_enable_c = 1'b1;
                alu_sel = instruction[4:2];
                if (instruction[1:0] == 2'b01) begin
                    immediate_value[15:0] = {{8{1'b0}}, instruction[12:5]};
                    mux_sel = 4'b1000;
                end else begin
                    mux_sel = {1'b0, instruction[12:10]};
                end
            end
            STATE_2: begin
                mux_sel_rx = {1'b0, instruction[15:13]};
                case (mux_sel_rx)
                    4'b0000: ctrl_enable_0 = 1'b1;
                    4'b0001: ctrl_enable_1 = 1'b1;
                    4'b0010: ctrl_enable_2 = 1'b1;
                    4'b0011: ctrl_enable_3 = 1'b1;
                    4'b0100: ctrl_enable_4 = 1'b1;
                    4'b0101: ctrl_enable_5 = 1'b1;
                    4'b0110: ctrl_enable_6 = 1'b1;
                    4'b0111: ctrl_enable_7 = 1'b1;
                endcase
            end
            STATE_3: begin
                ctrl_done_out = 1'b1;
            end
            default: begin
                ctrl_done_out = 1'b0; // Reset control signals in default case
            end
        endcase
    end

endmodule
