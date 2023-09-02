//Comparator module generates the PWM signal based on the two input waves
module Comparator #(
	parameter databits = 8
	)(
	input[(databits-1):0] Signal,Saw,
	input Clk,Rst,
	output reg OutPwm
	);

	always @(posedge Clk or negedge Rst)begin
		if(~Rst)begin
			OutPwm <= 1'b0;
		end
		else begin
			if(Signal > Saw)begin
				OutPwm <= 1'b1;
			end
			else begin
				OutPwm <= 1'b0;
			end
		end
	end
	

endmodule 