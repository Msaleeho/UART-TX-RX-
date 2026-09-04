module mux (
input logic start, inbits, parity, stop,
input logic [1:0] sel,
output logic out
);

always_comb
begin
	case (sel)
	2'b00 : out = start;
	2'b01 : out = inbits;
	2'b10 : out = parity;
	2'b11 : out = stop;
	endcase
end
endmodule 