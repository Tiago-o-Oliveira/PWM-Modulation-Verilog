`timescale 1ns/100ps
module Comparator_TB();

	wire OutPwm;
	reg[7:0] Saw,Signal;
	localparam databits = 8;
	
	Comparator #(
	.databits(databits)
	) DUT (
	.Saw(Saw),
	.Signal(Signal),
	.OutPwm(OutPwm)
	);

	initial begin
		Saw <= 8'b0;
		Signal <= 8'b0;
		#200 $stop;
	end
	
	always begin
		#1 Saw = ($unsigned($random)%255);
		Signal= ($unsigned($random)%255);
	end
endmodule 