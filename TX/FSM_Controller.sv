module FSM_Controller (
input logic i_clk, i_rst_n, i_par_en, i_valid,
output logic Start_Bit, Serial_start, Serial_load, Stop_Bit, o_busy, Enable,
output logic [1:0] sel
);

logic [3:0] counter;

typedef enum logic [3:0] { Idle, Start, Serialize, Parity_check, Stop } states;

states current, next;
			
always_ff @(posedge i_clk or negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		current <= Idle;
		counter <= 4'd0;
	end
	
	else
	begin
		current <= next;
		
		if (current == Serialize)
		begin
			counter <= counter + 4'd1;
		end
		
		else
		begin
			counter <= 4'd0;
		end

	end
end

// start(0) b0 b1 b2 b3 b4 b5 b6 b7 stop(1)

always_comb
begin
next = current;
Serial_load = 0;
Serial_start = 0;
Start_Bit = 0;
o_busy = 0;
Enable = 0;
Stop_Bit = 1;
sel = 2'b11;

	case (current)
	Idle : begin
			if (i_valid)
			begin
				next = Start;
				Serial_load = 1;
				o_busy = 1;
			end
			else
			begin
				sel = 2'b11;
				next = Idle;
				Serial_load = 0;
				o_busy = 0;
			end
		end
		
	Start : begin
			sel = 2'b00;
			next = Serialize;
			Serial_start = 1;
			o_busy = 1;
		end	
		
	Serialize : begin
			sel = 2'b01;
			if (counter >= 4'd7)
			begin
				if (i_par_en)
				begin
					next = Parity_check;
					Enable = 1;
				end
				
				else 
				begin
					next = Stop;
				end
			end
			
			else 
			begin
				next = Serialize;
			end
			o_busy = 1;
		end
	Parity_check : begin
			sel = 2'b10;
			Enable = 1;
			o_busy = 1;
			next = Stop;
		end
		
	Stop : begin
			sel = 2'b11;
			next = Idle;
			o_busy = 1'b1;
		end	
		
	default : begin
				next = Idle;
			end
	endcase
end
endmodule