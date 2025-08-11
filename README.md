# RISC-V 32-bit Pipelined CPU

## Inspiration
I decided to design this project because I wanted to try to test my newly acquired Verilog skills that I learned from HDLBits. 
In addition to this, I had been reading a book called "Digital Design and Computer Architecture | RISC-V Edition" by Sarah L. Harris 
and David Money Harris, which gave me the guidance to design the CPU, and also the advice to switch to a pipelined CPU.

## What is RISC-V?
RISC-V is a computer architecture developed by a few students at UC Berkeley. It is open source, and aims to provide a
higher performance and open source alternative (to x86 and ARM) for embedded devices and microcontollers, things which
students often find themselves building.

## How does this CPU work? 
As I stated earlier, this CPU was designed based off of the information in "Digital Design and Computer Architecture | RISC-V Edition" by Sarah L. Harris 
and David Money Harris. Here is an image of the pipelined CPU from the book <br />


<img width="887" height="608" alt="image" src="https://github.com/user-attachments/assets/21b26a99-6376-4991-b288-9b631929377e" />

I will outline the steps which the processor goes through in these next sections. All of the relevant source code for each section is under the
"Source Files" directory.

## The "Instruction Fetch" Cycle

The first portion of the CPU is the instruction fetch pipeline stage. As the name suggests, this stage is responsible for fetching the instruction out of the instruction memory. 
The instruction memory takes one input, PCF, which is the program counter. This program counter is 32-bits, and counts incrementally in steps of 4 bytes (32'b000000...00001 -> 32'b000000...00100 -> 32'b000000...01000).
This is because an instruction memory consists of *n* 8-bit registers, while an instruction occupies 32-bits. I did not implement 8-bit registers for the instruction memory in my CPU, as it is not necessary for simulation
or for porting to my FPGA, but it is worth noting that this is the standard convention of the RISC-V architecture. The instruction that the program counter points to is then fed into the first pipeline register (on the right
of the image), which 


