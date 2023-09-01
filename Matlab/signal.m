%Pre-code 
    clc,clear all,close all;
%
%Sampling frequency
    Fs = 100;
    Ts = 1/Fs;
    Bits = 8;%Bits used in conversion
%Time Vector
    t = 0:Ts:1-Ts;
%Signal
    m = sin(2*pi*t)+2.5*cos(2*pi*t*4 + pi/7);
    figure(),plot(t,m),grid,title("Signal"),xlabel("Time [s]"),ylabel("Amplitute [V]");
%
%Conditioning
    m = m + abs(min(m));%Positive Offset 
    Out = (m/max(m))*((2^Bits)-1);%Normalization and Codification
%
%Exporting
    Outbin = dec2bin(Out); %Decimal to Binary conversion
    fid = fopen('signal.txt','wt');%Open or create 'signal.txt' file in write mode
    fprintf(fid,'%s\n',string(Outbin));%Print binary values 8 bits per line
    fclose(fid);%Save file,close file,brings peace to the world
%
  
