//Clock Divider Module
//This module takes as an input the clock of 50MHz on the board and divides the frequency (400 Hz)
module ClockDivider #(
	parameter InputClkFreq = 50e6,
	parameter OutputClkFreq = 100
)(
	input ClkOsc, Rst,
	output reg ClkDiv
);
	integer i;
	integer factor = (((InputClkFreq/OutputClkFreq)/2)-1);
	
	always @(posedge ClkOsc or negedge Rst)begin
		if(~Rst)begin
			ClkDiv <= 1'b0;
			i <= 1'b0;
		end
		else begin
			if(i > (factor))begin
				ClkDiv = ~ClkDiv;
				i <= 1'b0;
			end
			else begin
				i = i + 1'b1;
			end
		end
	end
endmodule
//