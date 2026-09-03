module Neg_edge_detect (
input logic clk, rst, in,
output logic neg_edge_A
);

logic in_old;

always_ff @(posedge clk or negedge rst)
begin
	if (!rst)
	begin
		in_old <= 0;
	end
	
	else 
	begin
		in_old <= in;
	end
end

assign neg_edge_A = !in && in_old;

endmodule