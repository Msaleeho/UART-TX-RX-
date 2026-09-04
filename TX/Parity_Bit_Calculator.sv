module Parity_Bit_Calculator #(parameter DATA_W = 8) (
input logic [DATA_W - 1:0] i_data,
input logic Enable, i_par_odd,
output logic P_out	
);

logic compare;

always_comb
begin
	compare = ^i_data;
	if (Enable)
	begin
		if (i_par_odd)
		begin
			P_out = compare;
		end
		
		else
		begin
			P_out = !compare;
		end
	end
	
	else 
	begin
		P_out = 0;
	end
	
end
endmodule