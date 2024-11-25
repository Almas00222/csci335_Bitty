module Control_Unit(
input clk,
input rst,
input run,

input [15:0] instruction,

output reg [2:0] alu_sel,
output reg [2:0] mux_sel,

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

output reg ctrl_done_out
);
    parameter STATE_0 = 2'b00;
    parameter STATE_1 = 2'b01;
    parameter STATE_2 = 2'b10;
    parameter STATE_3 = 2'b11;

    reg [1:0] current_state, next_state;
    
    reg [2:0] mux_sel_rx;
   
/* verilator lint_off UNUSEDSIGNAL */ 
wire [4:0] unused_signal_1 = instruction[9:5]; // Unused bits
wire [1:0] unused_signal_2 = instruction[1:0]; // Unused bits
/* verilator lint_on UNUSEDSIGNAL */ 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
        end
    end
    
    
    always @(*) begin
	case (current_state)
	
	STATE_0: begin
	next_state = STATE_1;
	end
	STATE_1: begin
	next_state = STATE_2;
	end
	STATE_2: begin
	next_state = STATE_3;
	end
	STATE_3: begin
	next_state = STATE_0;
	end
	default: begin
	next_state = STATE_0;
	end
	endcase
	end
	
	
	
    always @(*) begin
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
        ctrl_done_out = 1'b0;
        
        mux_sel_rx = 3'b000;
        alu_sel = 3'b000;
        mux_sel = 3'b000;

        case (current_state)
            STATE_0: begin
                if (run) begin
                    ctrl_enable_i = 1'b1;
                    ctrl_enable_s = 1'b1;
                    mux_sel = instruction [15:13];
                end
            end
            STATE_1: begin
                ctrl_enable_c = 1'b1;
                alu_sel = instruction [4:2];
                mux_sel = instruction [12:10];
            end
            STATE_2: begin
            mux_sel_rx = instruction [15:13];
          case (mux_sel_rx)
            3'b000: begin
            ctrl_enable_0 = 1'b1;
            end
            3'b001: begin
            ctrl_enable_1 = 1'b1;
            end
            3'b010: begin
            ctrl_enable_2 = 1'b1;
            end
            3'b011: begin
            ctrl_enable_3 = 1'b1;
            end
            3'b100: begin
            ctrl_enable_4 = 1'b1;
            end
            3'b101: begin
            ctrl_enable_5 = 1'b1;
            end
            3'b110: begin
            ctrl_enable_6 = 1'b1;
            end
            3'b111: begin
            ctrl_enable_7 = 1'b1;
            end
            endcase
          end
          STATE_3: begin

          ctrl_done_out = 1'b1;
          
            end
        endcase
    end
endmodule

