`timescale 10ns/100ps
module ClockDivider_TB();
	
	localparam InputClkFreq = 50e6;
	localparam OutputClkFreq = 100;
	
	reg Rst, ClkOsc;
	wire ClkDiv;
	
	ClockDivider #(.InputClkFreq(InputClkFreq),.OutputClkFreq(OutputClkFreq)) DUT(
	.Rst(Rst),
	.ClkDiv(ClkDiv),
	.ClkOsc(ClkOsc)
	);
	
	initial begin
		Rst <= 1'b1;
		ClkOsc <= 1'b0;
		#5 Rst <= 1'b0;
		
		#500000 $stop;
	end
	
	always begin
		#1 ClkOsc = ~ClkOsc;
	end

endmodule 