`timescale 1ns/100ps
module SignalTable_TB();
   //-----------Memory Parameters--------------------//
	localparam data_width = 8;
	localparam addr_width = 7;
	localparam data_range = 100;
	//--------------Input Ports-----------------------//
	reg [addr_width-1:0] address ;
	reg we ;
	reg Clk;
	reg [data_width-1:0] dataIn ;
	//--------------Output Ports----------------------//
	wire [data_width-1:0] dataOut;
	
	integer k = 0;
	SignalTable #(.data_width(data_width),.addr_width(addr_width),.data_range(data_range)) DUT (
	.Clk(Clk),
	.WR(we),
	.address(address),
	.dataIn(dataIn),
	.dataOut(dataOut)
	);
	
	initial begin
		Clk = 0;
		we = 0;
		address = 8'b0;
		dataIn = 8'b0;
		we = 1;
		
		for (k=0; k < 10; k = k + 1) begin
			#70 address = k;
			dataIn = k;
		end
		
		we = 0;
		
		for (k=0; k < 10; k = k + 1) begin
			#70 address = k;
		end
	end
	
	always #50 Clk = ~Clk;
	
	initial #2300 $stop;
endmodule 
