module Register #(//Simple as it looks
	parameter databits = 8
	)(
	input Clk,Rst,
	input[(databits-1):0] In,
	output reg[(databits-1):0] Out
	);
	
	always @(posedge Clk or negedge Rst)begin
		if(~Rst)begin
			Out <= 1'b0;
		end
		else begin
			Out <= In;
		end
	end

endmodule 