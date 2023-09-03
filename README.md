# <h1 align="center">PWM-Modulation-Verilog</h1> 
This project aims to implement [PWM modulation](https://www.wikiwand.com/en/Pulse-width_modulation) in Verilog, strongly based on [DDS](https://www.wikiwand.com/en/Direct_digital_synthesis). 

<p align="center">
  <img width="300" height="300" src="https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/96dabed6-1cb9-4972-9781-0b79f6d574e8">
</p>

<p align="center">
<em>Original Signal/PWM Modulation</em>
</p>
Originally created for a college course, it has been decoupled from the rest of the project for further development. As a secondary objective, this repository will be as didactic as possible.

This project doesn't use any IP block because: Open Source plz

The Topology utilized on the project will be as follows: 
![image](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/7d2d46e2-ad1a-41cd-aeaf-3151d9f2a201)

>[!NOTE]
>Please Note that this will change as the project evolves

We will divide this Explanation into steps, so any signal (in a given frequency range) can be modulated.

# 1st Step: Initial Assumptions and Definitions.

For this project, we are going to take an arbitrary periodic sinusoidal signal, as an  example,take the signal: $\sin{(2\pi t)}+2.5*\sin{(2\pi 4t+\pi/7)}$
We can now take some information from this signal: $Max Frequency = 4 [Hz] $, $Period = 1 [s]$.

Using the [Nyquist-Shannon Sampling Theorem](https://www.wikiwand.com/en/Nyquist%E2%80%93Shannon_sampling_theorem) we know that the sampling frequency of our signal must be at least $8 [Hz]$, but we are going to take it a little higher, just to make sure that our results look better. In this case, I'm going to take $Sampling Frequency = 100 [Hz]$ but feel free to choose for yourself. Once our circuit is set, it will be easier to change this value and see the differences.

In addition, we must define the number of bits that we are going to use to represent this signal. This process may seem a little arbitrary at first, but it's one of those things that you get the feel in practice, for now, trust me that 8 bits are a reasonable choice for this signal.

# 2nd Step: Obtaining the signal in Matlab

Now that we have everything defined, it is time to obtain our signal and proceed with the magic. I'm going to use Matlab, but the same code can be used in Octave without any modifications. In the project files, you will find a Python version as well.

```Matlab
%Pre-code 
    clc,clear all,close all;
%
%Sampling frequency
    Fs = 100;
    Ts = 1/Fs;
%Time Vector
    t = 0:Ts:1-Ts;
%Signal
    m = sin(2*pi*t)+2.5*cos(2*pi*t*4 + pi/7);
    figure(),plot(t,m),grid,title("Signal"),xlabel("Time [s]"),ylabel("Amplitute [V]");
%

```
Code Output:

![imagel](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/287f49dd-c151-48b3-b41d-c5d3dfd6df42)
>[!NOTE]
>If you pay a little more attention to details, you may see that the figure is kinda edgy, this surely means that the sampling frequency is not adequate, rising it to 200 [Hz] would be better, but im keeping 100 for proof of concept.

Now that we have our signal sampled, in order to load it into memory, there are two more steps we need to take:quantization and codification.
While you may find several different ways to do it, I've chosen a method that feels more intuitive to me. Taking a closer look at our signal, you may see that it has both negative and positive values. In a modulation like this one, we are interested in this kind of oscillation, so we simply get rid of it by applying an offset to our signal.

```Matlab
%Previous code...
%...
  m = m + abs(min(m))
```
Having done that,we now have the same signal shape, but with a positive offset. We can see that our signal varies from 0 to 6.75, we now must discretize this amplitude and assign a binary code to every amplitude step. I'm going to do that by first normalizing the signal (making it range from 0 to 1) and then multiplying it by our maximum binary representation.

```Matlab
%Previous code
%...
Bits = 8;
Out = (m/max(m))*((2^bits)-1)
```
By simply doing that, our signal now ranges from 0 to 255, which means we are using the maximum of our binary range. Once all this signal conditioning is done, it is time to export every signal value in binary form so it can be later loaded on the FPGA memory. In the example case, since our signal has 100 samples per second(100Hz) and a period of 1 [s],100 entries will be loaded.

```Matlab
%Previous Code
%...
    Outbin = dec2bin(Out); %Convert All values to a matrix of binary values string
    fid = fopen('signal.txt','wt'); %Opens or Creates the file 'signal.txt' in write mode
    fprintf(fid,'%s\n',string(Outbin));%Print in our file one string per line
    fclose(fid);%Save the file,close the file,bring peace to our world
```

>[!NOTE]
>In Octave, you must convert your 'out' variable to an integer before using the dec2bin command; it can be done this way:'dec2bin(round(Out))'. Also there is no 'string' command on octave,so use a for loop instead (see project files for reference).

# 3rd Step: Describing individual modules
## Memory module
The memory module used in this project will be a dualport synchronous ram. This type of memory is a suitable choice since it has a simple implementation and fullfills all project needs (we only need to read the data btw).
Two parameters will be included in this block:

data width = 8 *which represents the number of bits used to represent our signal, must be coherent with the value chosen in the previous step.*
addr width = 7 *this value means that our memory will have 2^N addresses. This value must be greater than: * $SamplingFrequency*SignalPeriod$.

The memory block description can be found on *Quartus-Prime (or Quartusii)* templates. We need to load our data on memory start, which can be done by adding the following code to the memory block:

```Verilog
initial begin
    $readmemb("signal.txt",memory);//Where memory is the name of the memory array,Quartus usually calls it 'ram'
end
```

>[!NOTE]
>In order for this to work, the 'signal.txt' file must be in the project directory.^[example](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/c6c2945c-c4c6-43e1-980f-546215357ed0)

## Memory address Module and Sawtooth Counter Module
One instance of this block is responsible for changing the address on the memory address bus following the signal sample rate, in this case, that means that our block must have a 100 [Hz] Clock in it.

Another instance is responsible for 'generating' the sawtooth wave used in DDS.

Two parameters will be used in this module, the *count width*, which is the same as the *addr width* used in memory block and the *max value*. For the rest of the module, it's just a simple counter that resets when the count value reaches (max value-1) (which means 'max value' iterations).

Also an assynchronous Reset logic is going to be added, just because most boards I have natively use assynchronous reset. Still talking about reset, in the code below the reset is triggered on falling edges. I've made that choice because the reset will be implemented later as a push button on the board, and most of these buttons have pull-up resistors, which means they go to 0('low') when pressed. 

```Verilog
always @(posedge Clk or negedge Rst)begin//Assynchronous Reset on negative border
	if(~Rst)begin
		address <= 1'b0;
	end
	else begin
		if(address==(max_value-1))begin//Restart condition = SamplingFrequency-1
			address <= 1'b0;
		end
		else begin
			address <= address + 1'b1;
		end
	end 
end
```
## Clock Divider Module
As seen in the topology of the circuit, our design needs two different clock sources. We will see that this can be easily achieved with some counter modules,but as always, since there is no free lunch, this 'simple' implementation is quite bad when taking synchronism into account and can lead to a serious hazard: [Metastability](https://www.wikiwand.com/en/Metastability_(electronics)).

While many solutions to metastability are available and can be implemented, this topic is a little bit above our current project, so, just for now, we are going to put this thing aside, but be aware that this exists and will come for you one day.

This module will use two parameters, *InputClkFrequency*,which will be our reference clock; usually on fpga boards, this value is 50 [MHz]. In my case  50M is my choice. The other parameter is *OutputClkFrequency*, that is, our desired output clock frequency.

For the memory address and memory modules, the clock must have the same value of the signal sampling frequency; for the sawtooth counter,the register, and the comparator, this value must be a value greater than the sampling frequency; most references recommend using one complete cycle of sawtooth for every signal sample.

```Verilog
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
```

For example, if we want to go from a clock of 50e6 to 100 [Hz], this gives us a division factor of 500e3. To match our logic , we need to divide our value by two since we invert the clock every half period, leading to 250e3 since it is a counter and starts on 0, subtracting one gives us the final value of 249999. The equation is:
$$factor = (((InClkFreq/OutClkFreq)/2)-1)$$

>[!NOTE]
>While this formula generalizes the factor obtained, this value is always an integer, so if the clock frequencies are not an integer multiple of each other, you will get a rounding error.

## Register Module
Synchronization is a beauty, isn't she? To keep things working like a charm, we are going to need a register module, the simplest, just to make sure our data arrive in the comparator module at the right time.

This module uses one parameter, *databits* and this parameter should have the same value as *count width* and the bits used in your signal.

```Verilog
always @(posedge Clk or negedge Rst)begin
	if(~Rst)begin
		Out <= 1'b0;
	end
	else begin
		Out <= In;
	end
end
```

## Comparator Module
This last piece of hardware (finally) generates the PWM signal by simply comparing the memory data and the sawtooth counter values,and really, that's it.

```Verilog
always @(posedge Clk or negedge Rst)begin
	if(~Rst)begin
		OutPwm <= 1'b0;
	end
	else begin
		if(Signal > Saw)begin
			OutPwm <= 1'b1;
		end
		else begin
			OutPwm <= 1'b0;
		end
	end
end
```
# 4th Step: Tie Everything Together

Once we have all the modules described, it is time to put them all together. Following the topology proposed earlier, the result is:

![image](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/a213bf9d-3512-4c80-84a3-649b8267d5f1)

The parametrization of all modules we've done so far has helped us easily change signal characteristics by just tweaking some parameters.

![image](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/509da046-387b-45e5-a607-619c6bdaff73)

>[!NOTE]
>For now, almost all parameters are derived directly from the decisions we've made in the signal obtaining part, with the exception of the *addr width*, this value must be an integer that satisfy: $2^(addr witdth) = SamplingFrequency$. I still haven't figured out how to dynamically calculate it.

--- 
I've written all the code and text in this repo, while the grammar was revised using AI tools.
