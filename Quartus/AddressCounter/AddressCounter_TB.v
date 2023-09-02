`timescale 1ns/100ps
module AddressCounter_TB();
	
	localparam addr_width = 7;
	localparam sampling_frequency = 100;
	
	reg Clk,Rst;
	wire[(addr_width-1):0] address;
	
	initial begin
		Clk <= 1'b0;
		Rst <= 1'b0;
		#5 Rst <= 1'b1;
		#5 Rst <= 1'b0;
		#200 $stop;
	end
	
	always begin 
		#1 Clk <= ~Clk;
	end

endmodule	