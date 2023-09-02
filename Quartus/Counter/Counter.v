/*Module used to address the memory block*/
module Counter #(
	//----------------------------------------Parameters--------------------------------------------------//
	parameter count_width = 7,
	parameter max_value = 100)(
	//------------------------------------------Inputs----------------------------------------------------//
	input Clk,
	input Rst,
	//-----------------------------------------Outputs----------------------------------------------------//
	output reg[(count_width-1):0] address);
	
	//-----------------------------------------Counter----------------------------------------------------//
	always @(posedge Clk or negedge Rst)begin//Assynchronous Reset on negative border
		if(~Rst)begin
			address <= 7'b0;
		end
		else begin
			if(address==(max_value-1))begin//Restart condition = SamplingFrequency-1
				address <= 7'b0;
			end
			else begin
				address <= address + 7'b1;
			end
		end 
	end
	
endmodule	
