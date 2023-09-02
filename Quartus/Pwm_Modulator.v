module Pwm_Modulator(
	input ClkOsc,//External Clock Source
	input Rst,//Reset Signal
	output Out_Pwm //Output PWM Signal
);
	
	localparam FpgaClk = 50e6;
	localparam SamplingFrequency = 100;
	localparam databits = 8;
	localparam SawFreq = (SamplingFrequency*(2^^databits));
	localparam addr_width = 7;
	
	wire slowclock,fastclock;
	wire [(addr_width-1):0] address;
	wire [(databits-1):0] sawtooth;
	wire [(databits-1):0] regsawout;
	wire [(databits-1):0] dataOut;
	
	//Clock Divider Modules
		//Slow Clock
		ClockDivider #(
		.InputClkFreq(FpgaClk),
		.OutputClkFreq(SamplingFrequency)
		)CLDV1(
		.ClkOsc(ClkOsc),
		.Rst(Rst),
		.ClkDiv(slowclock)
		);
		
		//Fast Clock
		ClockDivider #(
		.InputClkFreq(FpgaClk),
		.OutputClkFreq(SawFreq)
		)CLDV2(
		.ClkOsc(ClkOsc),
		.Rst(Rst),
		.ClkDiv(fastclock)
		);
	//
	//Counter Modules
		//Memory Address Counter
		Counter #(
		.count_width(addr_width),
		.max_value(SamplingFrequency)
		)CNT1(
		.Clk(slowclock),
		.Rst(Rst),
		.address(address)
		);
		
		//Sawtooth Counter
		Counter #(
		.count_width(databits),
		.max_value((2^^databits))
		)CNT2(
		.Clk(fastclock),
		.Rst(Rst),
		.address(sawtooth)
		);
	//
	//Memory Module
		SignalTable #(
		.data_width(databits),
		.addr_width(addr_width)
		)MEM1(
		.Clk(slowclock),
		.WR(1'b0),
		.address(address),
		.dataIn(8'b0),
		.dataOut(dataOut)		
		);
	//
	//Register Module
		Register #(
		.databits(databits)
		)REG1(
		.Clk(fastclock),
		.Rst(Rst),
		.In(sawtooth),
		.Out(regsawout)
		);
	//
	//Comparator Module
		Comparator #(
		.databits(databits)
		)COMP1(
		.Signal(dataOut),
		.Saw(regsawout),
		.Clk(fastclock),
		.Rst(Rst),
		.OutPwm(Out_Pwm)
		);
	//
endmodule	