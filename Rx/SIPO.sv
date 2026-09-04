module SIPO #(parameter DATA_W = 8) (
input logic in, clk, rst, en,
output logic [DATA_W - 1:0] parallel
);

logic [$clog2(DATA_W):0] count;
logic [DATA_W - 1:0] extra;

always_ff @(posedge clk or negedge rst)
begin
	if (!rst)
	begin
		extra <= 0;
		count <= 0;
	end
	
	else if (en) 
	begin
		extra[count] <= in;
		count <= count + 1;		
	end	
	
	else
	begin
		count <= 0;
	end
end

assign parallel = extra;

endmodule