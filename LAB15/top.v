module top (
  input wire clk,        
  input wire reset,      
  input wire run,        
  input wire [15:0] instruction, 
  output done
);
	wire [15:0] d_out_i;
   	wire [15:0] mux_out_rx;
   	wire [2:0] alu_sel;
   	wire [2:0] mux_sel;
 	wire [15:0] d_out_s, d_out_c;
	wire [15:0] alu_out;
	
  	wire [15:0] d_out_0; 
  	wire ctrl_enable_0, ctrl_enable_7;
   	wire ctrl_enable_i, ctrl_enable_s, ctrl_enable_c;
	wire ctrl_enable_1, ctrl_enable_2, ctrl_enable_3, ctrl_enable_4, ctrl_enable_5, ctrl_enable_6;
	
	
   	wire [15:0] d_out_1; 
   	wire [15:0] d_out_2; 
   	wire [15:0] d_out_3; 
   	wire [15:0] d_out_4; 
   	wire [15:0] d_out_5; 
   	wire [15:0] d_out_6; 
  	wire [15:0] d_out_7;
   
Control_Unit control_unit (
    .clk(clk),
    .rst(reset),
    .run(run),
    
    .ctrl_done_out(done),
    
    .instruction(instruction),
    .mux_sel(mux_sel),
    .alu_sel(alu_sel),
    .ctrl_enable_0(ctrl_enable_0),
    .ctrl_enable_1(ctrl_enable_1),
    .ctrl_enable_2(ctrl_enable_2),
    .ctrl_enable_3(ctrl_enable_3),
    .ctrl_enable_4(ctrl_enable_4),
    .ctrl_enable_5(ctrl_enable_5),
    .ctrl_enable_6(ctrl_enable_6),
    .ctrl_enable_7(ctrl_enable_7),   
  
    .ctrl_enable_i(ctrl_enable_i),
    .ctrl_enable_s(ctrl_enable_s),
    .ctrl_enable_c(ctrl_enable_c)
);

  Reg_0 reg0 (.clk(clk), .rst(reset), .en_0(ctrl_enable_0), .d_in(d_out_c), .d_out(d_out_0));
  Reg_0 reg1 (.clk(clk), .rst(reset), .en_0(ctrl_enable_1), .d_in(d_out_c), .d_out(d_out_1));
  Reg_0 reg2 (.clk(clk), .rst(reset), .en_0(ctrl_enable_2), .d_in(d_out_c), .d_out(d_out_2));
  Reg_0 reg3 (.clk(clk), .rst(reset), .en_0(ctrl_enable_3), .d_in(d_out_c), .d_out(d_out_3));
  Reg_0 reg4 (.clk(clk), .rst(reset), .en_0(ctrl_enable_4), .d_in(d_out_c), .d_out(d_out_4));
  Reg_0 reg5 (.clk(clk), .rst(reset), .en_0(ctrl_enable_5), .d_in(d_out_c), .d_out(d_out_5));
  Reg_0 reg6 (.clk(clk), .rst(reset), .en_0(ctrl_enable_6), .d_in(d_out_c), .d_out(d_out_6));
  Reg_0 reg7 (.clk(clk), .rst(reset), .en_0(ctrl_enable_7), .d_in(d_out_c), .d_out(d_out_7));
  
  Reg_0 regS (.clk(clk), .rst(reset), .en_0(ctrl_enable_s), .d_in(mux_out_rx), .d_out(d_out_s));
  
  Reg_0 regC (.clk(clk), .rst(reset), .en_0(ctrl_enable_c), .d_in(alu_out), .d_out(d_out_c));
  
  Reg_0 regi (.clk(clk), .rst(reset), .en_0(ctrl_enable_i), .d_in(instruction), .d_out(d_out_i));

  mux my_mux_rx (
    .sel(mux_sel),
    .d_out_0(d_out_0),
    .d_out_1(d_out_1),
    .d_out_2(d_out_2),
    .d_out_3(d_out_3),
    .d_out_4(d_out_4),
    .d_out_5(d_out_5),
    .d_out_6(d_out_6),
    .d_out_7(d_out_7),
    .out(mux_out_rx)
);

ARITHM my_alu (
    .in_a(d_out_s),      
    .in_b(mux_out_rx),       
    .select(alu_sel),     
    .alu_out(alu_out)
);

endmodule
