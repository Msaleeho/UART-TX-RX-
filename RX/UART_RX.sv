module uart_rx #(parameter DATA_W = 8) (
input logic i_rx, i_clk, i_rst_n, i_par_en, i_par_odd,
output logic [DATA_W - 1 : 0] o_data,
output logic o_valid, o_busy, o_parity_err, o_frame_err
);

logic valid_zero, SIPO_EN, Par_old;
logic [DATA_W - 1 : 0] Data;

Neg_edge_detect STOP_BIT_DETECT ( .clk(i_clk), .rst(i_rst_n), .in(i_rx), .neg_edge_A(valid_zero) );

FSM_Controller_RX #(.DATA_W(DATA_W)) FSMC_RX ( .i_clk(i_clk), .i_rst_n(i_rst_n), .i_par_en(i_par_en), .i_valid(valid_zero), .i_rx(i_rx), .SIPO_EN(SIPO_EN), 
												.o_busy(o_busy), .Par_old(Par_old), .o_frame_err(o_frame_err), .o_valid(o_valid) );

Parity_Bit_Calculator_RX #(.DATA_W(DATA_W)) PC ( .i_data(Data), .i_par_odd(i_par_odd), .i_par_en(i_par_en), .par_old(Par_old), .o_parity_err(o_parity_err) );

SIPO #(.DATA_W(DATA_W)) Sipo ( .in(i_rx), .clk(i_clk), .rst(i_rst_n), .en(SIPO_EN), .parallel(Data) );

assign o_data = Data;

endmodule