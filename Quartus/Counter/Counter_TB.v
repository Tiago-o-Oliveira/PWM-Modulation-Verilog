`timescale 1ns/100ps
module Counter_TB();
	
	localparam count_width = 7;
	localparam max_value = 100;
	
	reg Clk,Rst;
	wire[(count_width-1):0] address;
	
	Counter #(.count_width(count_width),.max_value(max_value)) DUT (
	.Clk(Clk),
	.Rst(Rst),
	.address(address)
	);
	
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