module FSM_Controller_RX #(parameter DATA_W = 8) (
input logic i_clk, i_rst_n, i_par_en, i_valid, i_rx,
output logic SIPO_EN, o_busy, Par_old, o_frame_err, o_valid
);

logic [$clog2(DATA_W):0] counter;
logic Parity_bit, end_state, stop_bit;

typedef enum logic [1:0] { Idle, Load, Parity_Check, Stop } states;

states current, next;
			
always_ff @(posedge i_clk or negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		current <= Idle;
		counter <= 4'd0;
		Parity_bit <= 0;
		end_state <= 0;
		stop_bit <= 1;
	end
	
	else
	begin
		current <= next;
		
		if (current == Load)
		begin
			counter <= counter + 4'd1;
		end
		
		else
		begin
			counter <= 0;
		end
		
		if (current == Parity_Check)
		begin
			Parity_bit <= i_rx;
		end
		
		end_state <= (current == Stop);
		
		if (current == Stop)
		begin
			stop_bit <= (i_rx != 1);
		end
	end
end

// start(0) b0 b1 b2 b3 b4 b5 b6 b7 stop(1)

always_comb
begin
next = current;
SIPO_EN = 0;
o_busy = 0;
o_frame_err = 0;
o_valid = 0;
Par_old = Parity_bit;

	case (current)
	Idle : begin
				if (i_valid)
				begin
					next = Load;
					o_busy = 1;
				end
				
				else
				begin
					next = Idle;
					o_busy = 0;
				end
				
				if (end_state)
				begin
					o_frame_err = (i_rx != 1'b1);
					o_valid = 1;
				end
			end
		
	Load : begin
				if (counter == DATA_W - 1)
				begin
					if (i_par_en)
					begin
						next = Parity_Check;
					end
					
					else 
					begin
						next = Stop;
					end
				end
				
				else 
				begin
					next = Load;
				end
				o_busy = 1;
				SIPO_EN = 1;
			end
			
	Parity_Check : begin
						o_busy = 1;
						next = Stop;
					end
		
	Stop : begin
				next = Idle;
				o_busy = 1;
		    end	
		
	default : begin
				next = Idle;
			  end
	endcase
end
endmodule