# PWM-Modulation-Verilog
This project aims to implement PWM modulation in Verilog, strongly based on [DDS](https://www.wikiwand.com/en/Direct_digital_synthesis). Originally created for a college course, it has been decoupled from the rest of the project for further development. As a secondary objective, this repository will be as didactic as possible.

The Topology utilized on the project will be as it follows: 
![image](https://github.com/Tiago-o-Oliveira/PWM-Modulation-Verilog/assets/116642713/7d2d46e2-ad1a-41cd-aeaf-3151d9f2a201)

>[!NOTE]
>Please Note that this will change as the project evolves

We will divide this Explanation is steps, so any signal (in a given frequency range) can be modulated.

# 1º Step: Initial Assumptions and Definitions.

For this project, we are going to take an arbitrary periodic signal, take as example the signal: $m(t) = 3*sin(2\pi*t + \pi/7)+2.5*sin(2*\pi*4*t)$

