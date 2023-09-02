`timescale 1ns/100ps
module Register_TB();

	wire[7:0] Out;
	reg[7:0] In;
	reg Clk,Rst;
	localparam databits = 8;
	
	Register #(.databits(databits)) DUT (
	.Out(Out),
	.In(In),
	.Clk(Clk),
	.Rst(Rst)
	);
	
	initial begin
		Rst <= 1'b1;
		Clk <= 1'b0;
		In <= 8'b0;
		#2 Rst <= 1'b0;
		#2 Rst <= 1'b1;
		#200 $stop;
	end
	
	always begin
		#1 Clk = ~Clk;
		In <= In + 1'b1;
	end
	
endmodule	