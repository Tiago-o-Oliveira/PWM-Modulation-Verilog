/*Module Responsible for storing the signal table obtained on Matlab(Octave,Python,etc), its basically a single port
synchronous memory module.
*/
module SignalTable #(
	//----------------------------------------Parameters--------------------------------------------------//
	parameter data_width = 8,//Number of Data bits used in representation
	parameter addr_width = 7//2^N = Number of avaliable addresses, it must be greater than signal frequency
	)(
	//----------------------------------------Inputs------------------------------------------------------//
	input Clk,
	input WR,//0 for Read and 1 for Write
	input[(addr_width-1):0] address,//Address bus
	input[(data_width-1):0] dataIn,//Bus to read the data
	//----------------------------------------Outputs-----------------------------------------------------//
	output reg[(data_width-1):0] dataOut //Bus to getting data out
	);
	//----------------------------------------Memory------------------------------------------------------//
	reg[(data_width-1):0] memory [0:(1<<(addr_width))-1];
	//----------------------------------------Pre-Load----------------------------------------------------//
	initial begin
		$readmemb("signal.txt",memory);
	end
	//----------------------------------------Control-----------------------------------------------------//
	always @(posedge Clk)begin
	   //---------------------------------------Write-----------------------------------------------------//
		if(WR)begin
			memory[address] <= dataIn;
		end
		//---------------------------------------Read------------------------------------------------------//
		else begin
			dataOut <= memory[address];
		end
	end
	
endmodule	
//