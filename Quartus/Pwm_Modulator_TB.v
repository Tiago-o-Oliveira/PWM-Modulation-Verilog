`timescale 10ns/10ns
module Pwm_Modulator_TB();

	reg ClkOsc,Rst;
	wire Out_Pwm;
	
	Pwm_Modulator DUT(
	.ClkOsc(ClkOsc),
	.Rst(Rst),
	.Out_Pwm(Out_Pwm)
	);
	
	initial begin
		Rst <= 1'b1;
		ClkOsc <= 1'b0;
		Rst <= 1'b0;
		#2 Rst <= 1'b1;
		#1000000000 $stop;
	end
	
	always begin 
		#100 ClkOsc <= ~ClkOsc;
	end
	

endmodule	