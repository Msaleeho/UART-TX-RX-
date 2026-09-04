module Parity_Bit_Calculator_RX #(parameter DATA_W = 8) ( 
input logic [DATA_W - 1:0] i_data,
input logic i_par_odd, i_par_en, par_old,
output logic o_parity_err
);

logic compare, P_out;

always_comb
begin
	compare = ^i_data;
	if (i_par_en)
	begin
		if (i_par_odd)
		begin
			P_out = compare;
		end
		
		else
		begin
			P_out = !compare;
		end
		
		o_parity_err = P_out ^ par_old;
	end
	
	else 
	begin
		o_parity_err = 0;
		P_out = 0;
	end
end
endmodule