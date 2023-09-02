/*Module used to address the memory block*/
module AddressCounter #(
	//----------------------------------------Parameters--------------------------------------------------//
	parameter addr_width = 7,
	parameter sampling_frequency = 100)(
	//------------------------------------------Inputs----------------------------------------------------//
	input Clk,
	input Rst,
	//-----------------------------------------Outputs----------------------------------------------------//
	output reg[(addr_width-1):0] address);
	
	//-----------------------------------------Counter----------------------------------------------------//
	always @(posedge Clk or negedge Rst)begin//Assynchronous Reset on negative border
		if(~Rst)begin
			address <= 1'b0;
		end
		else begin
			if(address==(sampling_frequency-1))begin//Restart condition = SamplingFrequency-1
				address <= 1'b0;
			end
			else begin
				address <= address + 1'b1;
			end
		end 
	end
	
endmodule	