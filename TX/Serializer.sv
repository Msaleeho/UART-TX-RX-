module Serializer #(parameter DATA_W = 8) (
input logic [DATA_W - 1:0] i_data,
input logic i_clk, i_rst_n, start, load, 
output logic out
);

logic [$clog2(DATA_W) - 1:0] counter;
logic [DATA_W - 1:0] temi_data;
logic busy;

always_ff @(posedge i_clk or negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		temi_data <= 0;
		busy <= 0;
		out <= 0;
		counter <= 3'd0;
	end
	
	else if (load && !busy)
	begin
		temi_data <= i_data;
		counter <= 3'd0;
	end
		
	else if (start && !busy)
	begin
		busy <= 1;
		counter <= 3'd1;
		out <= temi_data[0];
	end
	
	else if (busy)
	begin
		out <= temi_data[counter];
		counter <= counter + 3'd1;
		
		if (counter == DATA_W - 1)
		begin
			busy <= 0;
		end
	end
end
endmodule