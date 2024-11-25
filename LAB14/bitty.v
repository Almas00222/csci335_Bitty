module bitty (
    input wire clk,
    input wire reset,
    input wire run,
    input wire [15:0] instruction,
    output wire done,

    output wire [15:0] d_out_0,
    output wire [15:0] d_out_1,
    output wire [15:0] d_out_2,
    output wire [15:0] d_out_3,
    output wire [15:0] d_out_4,
    output wire [15:0] d_out_5,
    output wire [15:0] d_out_6,
    output wire [15:0] d_out_7
);

    // Internal signals to connect to the top module instance
    wire [15:0] d_out_i;
    wire [15:0] mux_out_rx;
    wire [2:0] alu_sel;
    wire [2:0] mux_sel;
    wire [15:0] d_out_s;
    wire [15:0] d_out_c;
    wire [15:0] alu_out;

    wire ctrl_enable_0, ctrl_enable_7;
    wire ctrl_enable_i, ctrl_enable_s, ctrl_enable_c;
    wire ctrl_enable_1, ctrl_enable_2, ctrl_enable_3;
    wire ctrl_enable_4, ctrl_enable_5, ctrl_enable_6;

    // Instantiate the top module
    top top_instance (
        .clk(clk),
        .reset(reset),
        .run(run),
        .instruction(instruction),
        .done(done),

        .d_out_i(d_out_i),
        .mux_out_rx(mux_out_rx),
        .alu_sel(alu_sel),
        .mux_sel(mux_sel),
        .d_out_s(d_out_s),
        .d_out_c(d_out_c),
        .alu_out(alu_out),

        .d_out_0(d_out_0),
        .d_out_1(d_out_1),
        .d_out_2(d_out_2),
        .d_out_3(d_out_3),
        .d_out_4(d_out_4),
        .d_out_5(d_out_5),
        .d_out_6(d_out_6),
        .d_out_7(d_out_7),

        .ctrl_enable_0(ctrl_enable_0),
        .ctrl_enable_7(ctrl_enable_7),
        .ctrl_enable_i(ctrl_enable_i),
        .ctrl_enable_s(ctrl_enable_s),
        .ctrl_enable_c(ctrl_enable_c),
        .ctrl_enable_1(ctrl_enable_1),
        .ctrl_enable_2(ctrl_enable_2),
        .ctrl_enable_3(ctrl_enable_3),
        .ctrl_enable_4(ctrl_enable_4),
        .ctrl_enable_5(ctrl_enable_5),
        .ctrl_enable_6(ctrl_enable_6)
    );

endmodule
