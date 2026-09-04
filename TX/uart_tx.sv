module uart_tx #(parameter DATA_W = 8) (
input logic [DATA_W - 1:0] i_data,
input logic i_valid, i_clk, i_rst_n, i_par_en, i_par_odd,
output logic o_tx, o_busy
);

logic [1:0] sel;
logic Start_Bit, Serial_start, Serial_load, Stop_Bit, Enable, Out1, Pout;

FSM_Controller FSMC ( .i_valid(i_valid), .i_clk(i_clk), .i_rst_n(i_rst_n), .i_par_en(i_par_en), .Start_Bit(Start_Bit), .Serial_start(Serial_start),
					.Serial_load(Serial_load), .Stop_Bit(Stop_Bit), .Enable(Enable), .sel(sel), .o_busy(o_busy) );
					
Serializer Serial ( .i_data(i_data), .i_clk(i_clk), .i_rst_n(i_rst_n), .start(Serial_start), .load(Serial_load), .out(Out1) );

Parity_Bit_Calculator Parity ( .i_data(i_data), .Enable(Enable), .i_par_odd(i_par_odd), .P_out(Pout) );

mux mux42 ( .start(Start_Bit), .inbits(Out1), .parity(Pout), .stop(Stop_Bit), .sel(sel), .out(o_tx) );

endmodule