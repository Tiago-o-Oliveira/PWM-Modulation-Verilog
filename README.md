# PWM-Modulation-Verilog
This project aims to implement PWM modulation in Verilog, strongly based on [DDS](https://www.wikiwand.com/en/Direct_digital_synthesis). Originally created for a college course, it has been decoupled from the rest of the project for further development. As a secondary objective, this repository will be as didactic as possible.

The Topology utilized on the project will be as it follows: 
![image](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/7d2d46e2-ad1a-41cd-aeaf-3151d9f2a201)

>[!NOTE]
>Please Note that this will change as the project evolves

We will divide this Explanation is steps, so any signal (in a given frequency range) can be modulated.

# 1st Step: Initial Assumptions and Definitions.

For this project, we are going to take an arbitrary periodic sinusoidal signal, take as example the signal: $\sin{(2\pi t)}+2.5*\sin{(2\pi 4t+\pi/7)}$
We can now take some information of this signal: $Max-Frequency = 4 [Hz] $, $Period = 1 [s]$.

Using [Nyquist-Shannon Sampling Theorem](https://www.wikiwand.com/en/Nyquist%E2%80%93Shannon_sampling_theorem) we now that the sampling frequency of our signal must be at least $8 [Hz]$, but we are going to take it a little higher, just to make sure that our results look better. In this case i'm going to take $Sampling-Frequency = 100 [Hz]$ but feel free to choose for yourself, once our circuit is set, it will be easier to change this value and see the differences.

In addition, we must define the amount of bits that we are going to use to represent this signal, this process may seem a little arbitrary at first, but its one of those things that you get the feel by doing it, for now, trust me that 8 bits are a reasonable choice for this signal.

# 2nd Step: Obtaining the signal in Matlab

Now that we have everithing defined, it is time to obtain our signal and proceed with the magic, i will be using Matlab, but the same code can be used in Octave without any modifications,in project files you will find a python version as well.
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
>If you pay a little more attention to details, you may see that the figure is kinda edgy, this surely means that the sampling frequency is not adequate, raising it to 200 [Hz] would be better, but im keeping 100 for proof of concept

Now that we have our signal sampled, in order to load it in to memory, there are two more steps we need to take:quantization and codification.
While you may find several different ways to do it, im choosing a method that i think is more intuitive. Taking a closer look to our signal, you may see that it has both negative and positve values,in a modulation like this one, we are intressed on this kind of oscilation, so we simply get rid of it applying an offset to our signal.
```Matlab
%Previous code...
%...
  m = m + abs(min(m))
```
Having done that,we now have the same signal shape, but with a positive offset.Now you may notice that our signal varies from 0 to 6.75, we now must discretize this amplitude and assign a binary code to every amplitude step, im going to do that firstly normalizing the signal (making it ranges from 0 to 1) and then multiplying it by our max binary representation.
```Matlab
%Previous code
%...
Bits = 8;
Out = (m/max(m))*((2^bits)-1)
```
By simply doing that, our signal now ranges from 0 to 255, wich means we are using the maximum we can of our binary range.Once all this signal conditioning is done, it is time to export every signal value in a binary form,so it can be later loaded on the FPGA memory.We will be loading one cycle of the signal in the memory, in the example case, since our signal have 100 samples per second(100Hz) and a period of 1 [s],100 entries will be loaded.
```Matlab
%Previous Code
%...
    Outbin = dec2bin(Out); %Convert All values to a matrix of binary values string
    fid = fopen('signal.txt','wt'); %Opens or Creates the file 'signal.txt' in write mode
    fprintf(fid,'%s\n',string(Outbin));%Print in our file one string per line
    fclose(fid);%Save the file,close the file,brings peace to our world
```
>[!NOTE]
>In Octave, you must convert your 'out' variable to integer before using dec2bin command, it can be done this way 'dec2bin(round(Out))', also there is no 'string' command on octave,so use a for loop instead(see project files for reference).

# 3rd Step: Describing individual modules
## Memory module
The memory module used in this project will be a dualport synchronous ram, this type of memory is a suitable choice, since it has a simple implementation and fullfil all project needs (we only need to read the data btw).
Two parameters will be included in this block:

data width = 8 *wich represents the number of bits used to represent our signal, must be coheren with the value choose in the previous step.*
addr width = 7 *this value means that our memory will have 2^N addresses,this value must be greater than: * $SamplingFrequency*SignalPeriod$.

The memory block description can be found on *Quartus-Prime (or Quartusii)* templates, also, we need to load our data on memory start, this can be done by adding the folowing code to the memory block:
```Verilog
    initial begin
	$readmemb("signal.txt",memory);
    end
```
>[!NOTE]
>In order for this to work, the 'signal.txt' file must be in the project directory^[example](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/c6c2945c-c4c6-43e1-980f-546215357ed0)



