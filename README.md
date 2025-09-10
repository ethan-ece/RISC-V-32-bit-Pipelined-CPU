# RISC-V 32-bit Pipelined CPU

## Inspiration
I decided to design this project because I wanted to try to test my newly acquired Verilog skills that I learned from HDLBits. 
In addition to this, I had been reading a book called "Digital Design and Computer Architecture | RISC-V Edition" by Sarah L. Harris 
and David Money Harris, which gave me the guidance to design the CPU, and also the advice to switch to a pipelined CPU. Anyone is welcome
to critique my design, and I expect there to be issues with either my explanation or my code/design as this is my first attempt at doing
anything like this. Your input is appreciated and will accelerate my learning process. 

## What is RISC-V?
RISC-V is a computer architecture developed by a few students at UC Berkeley. It is open source, and aims to provide a
higher performance and open source alternative (to x86 and ARM) for embedded devices and microcontollers, things which
students often find themselves building.

## How does this CPU work? 
As I stated earlier, this CPU was designed based off of the information in "Digital Design and Computer Architecture | RISC-V Edition" by Sarah L. Harris 
and David Money Harris. Here is an image of the pipelined CPU from the book <br />

<p align="center">
  <img width="887" height="608" alt="image" src="https://github.com/user-attachments/assets/21b26a99-6376-4991-b288-9b631929377e" /><br>
  <em>Figure 1: The 5-stage pipelined CPU</em>
</p>




I will outline the steps which the processor goes through in these next sections. All of the relevant source code for each section is under the
"Source Files" directory.

## The "Instruction Fetch" Cycle

The first portion of the CPU is the instruction fetch pipeline stage. As the name suggests, this stage is responsible for fetching the instruction out of the instruction memory. 
The instruction memory takes one input, PCF, which is the program counter. This program counter is 32-bits, and increments by 4 (32'b000000...00100 -> 32'b000000...01000 -> 32'b000000...01100).
RISC-V is byte-addressed, meaning every byte has a unique address. Since our instructions are 32-bits (4-bytes), the address of sequential instructions is always four greater than the last (Note: my implementation stores all information in blocks of 32-bit words, so I access the instruction registers with A[9:2] instead of A[7:0] in order to account for this difference while still incrementing the PC by 4 to prevent confusion and further problems). The instruction that the program counter points to is then fed into the first pipeline register (on the right of the image), which will (on the next positive clock edge) transfer this instruction into the next stage, the instruction decode pipeline stage. Every clock cycle, the PC register (the very tiny module taking in PCF' and containing an enable) will take in a 32 bit value, PCF', which comes from either PCPlus4, or PCTarget. PCPlus4 is the small adder which is responsible for incrementing the program counter every cycle. PCTarget is used when the CPU encounters a jump or branch instruction.



<p align="center">
  <img width="183" height="256" alt="image" src="https://github.com/user-attachments/assets/feddbfe3-faf5-4e9f-8744-c50413d8c592" /><br>
  <em>Figure 1a: The Instruction Fetch Pipeline Stage</em>
</p>


## The "Instruction Decode" Cycle

This pipeline stage uses a control unit in order to send all of the information contained in the instruction to the other parts of the CPU. The "RegWrite" signal corresponds to the write enable which controls whether or not the Register File unit will write when a given instruction reaches that cycle. The "ResultSrc" signal tells the multiplexer in the writeback pipeline stage whether it will output the result of the ALU, the read data from the Data Memory, or the "PCPlus4" signal. The "MemWrite" signal corresponds to the write enable which controls whether or not the Data Memory unit (from the memory pipeline stage) will write when a given instruction reaches that cycle. The "Jump" signal is one of the variables which tells the program counter to use the "PCTarget" signal instead of the "PCPlus4" signal. The "Branch" signal has a similar function, but for branch instructions. The "ALUControl" signal tells the ALU what type of instruction it is performing. This can be an: add operation (3'b000), sub operation (3'b001), AND operation (3'b010'), OR operation (3'b011), or a less than operation (3'b101) (when SrcA < SrcB). It is important to note that the sub operation subtracts SrcB from SrcA, not the other way around. The "ALUSrc" signal assigns a value to "SrcB," the second input to the ALU. It will select between an output of the register file, RD2, or data from the sign extension unit Finally the "ImmSrc" signal tells the "Extend" unit (responsible for extending the "immediate" part of the RISC-V instruction into a usable 32-bit form, even though most of the bits are zeroes) what to append to the bits that it recieves depending on which instruction is being performed. An "I" type instruction is broken down in a different way than a "B" or "S" type instruction. The instruction formats are listed below. 



<p align="center">
  <img width="868" height="367" alt="image" src="https://github.com/user-attachments/assets/866d13a5-4d0f-43ec-ba44-50d3a8e636ad" /><br>
  <em>Figure 2: The Types of RISC-V Instructions and their Formats</em>
</p>



<p align="center">
  <img width="1075" height="726" alt="image" src="https://github.com/user-attachments/assets/4fc29b93-f873-457c-aa7b-5e82910b80f2" /><br>
  <em>Figure 1b: The Instruction Decode Pipeline Stage</em>
</p>


## The "Execute" Cycle

This pipeline stage is responsible for performing arithmetic and logical operations. The Arithmetic Logic Unit, or "ALU", steals the show here. I have already explained its functions in the decode stage. Another important unit in the execute stage is the PCTarget increment unit. This unit adds the "PC" signal to the "Immediate" and feeds this value back into the PC register in order to jump to a later instruction in the instruction memory. You will also notice two multiplexers (the small units with "00," "01," and "10"). These units are responsible for the forwarding logic of the pipeline. "Forwarding" in a pipelined CPU is necessary because some instructions will need information from later stages which are probably on their way to being written back to one of the registers in the register file. The thing is that the ALU doesn't want to wait for this information to make it to the register file and back through the pipeline
(this would take many cycles), so it instead bypasses the pipeline and uses the readily available information from the later pipeline stages. This logic is controlled by the "Hazard Unit," explained in further detail with its own section at the end.



<p align="center">
  <img width="767" height="826" alt="image" src="https://github.com/user-attachments/assets/d90eaf6a-f65e-4c6a-ba7e-b88be32a7e1d" /><br>
  <em>Figure 1c: The Execute Pipeline Stage</em>
</p>

## The "Memory" Cycle

This pipeline stage is responsible for storing long term information in the Data Memory cycle. Reads and writes to this unit take quite a while, as the instruction needs to first go through the first 3 stages of the pipeline. This memory is usually bigger than the register file as it is built with a slower, more inexpensive type of memory, as it doesn't need to be accessed as frequently. This unit is accessed primarily through sw ("store word"--essentially a write) instructions, and lw ("load word"--essentially a read) instructions. These sw instruction takes information from the register file and places it into data memory, while the lw instruction does the opposite. The write enable signal here was explained in the control unit stage, but it is explicitly written here as "MemWriteM."



<p align="center">
  <img width="171" height="608" alt="image" src="https://github.com/user-attachments/assets/f2d0374f-553a-42b0-b2a3-118fdce370dd" /><br>
  <em>Figure 1d: The Memory Pipeline Stage</em>
</p>


## The "Writeback" Cycle

The writeback pipeline stage is primarily responsible for forwarding relevant information back to the register file for a write. The "ResultW" output skips the pipeline, and goes straight into the WD3 portion of the register file. "ResultW" is chosen via a 3 way multiplexer, which selects between the output from the data memory unit, the ALU, and PCPlus4. 



<p align="center">
  <img width="152" height="656" alt="image" src="https://github.com/user-attachments/assets/9adf9def-20ac-4ee5-be5c-cc9060fe4362" /><br>
  <em>Figure 1e: The Writeback Pipeline Stage</em>
</p>

## The Hazard Unit

The hazard unit is arguably the most important portion of a pipeline based CPU. This unit is responsible for two things: "stalling" and "forwarding." We already explained forwarding in the execute and writeback stages, but stalling has not been discussed yet. You might have noticed the signals "StallF," "StallD," "FlushD," and "FlushE" stringing from the hazard unit. These signals are responsible for stalling and flushing the pipeline registers. A "stall" is necessary when a function needs to access data from a register which doesn't hold the correct value yet. An example of this would be a lw instruction, say lw a0 0(x0) followed by an add instruction, say add a2, a0, a0. When the lw instruction is in the execute stage, the add instruction is in the decode stage. At this stage, the control unit is preparing the two registers which the add instruction asks for, in this case the same register, a0. The issue with this is that the relevant information stored in these registers won't be available from the lw instruction until it is in the writeback stage, where it can write to the register file the correct value (in this case a value stored in the 0th register of the data memory with an offset of 0). The hazard unit sees this conflict, and decides to halt the CPU. It does this by pausing the IF/ID pipeline (the one separating the fetch and decode pipeline stages), flushing the execute pipeline stage (this is effectively a NOP instruction, and can be thought of as creating a "bubble" for the future add instruction to enter), and also pausing the PC register. The PC register needs to be paused because we do not want the next instruction to try to enter the stalled IF/ID pipeline, as this would effectively get rid of that instruction. The lw instruction continues down the pipeline for one cycle while the fetch, decode, and execute stages are "paused." The lw instruction is now in the memory stage, obtaining its value from the data memory. Then on the next cycle the add instruction can continue down the pipeline, into the execute stage. By this point, the lw instruction is in the writeback stage, and can write the value which the ALU will eventually use. This clever technique of "stalling" is used in most modern CPU's today, and although it may seem inefficient, it completes the job to the best of it's abilities for this specific CPU architecture.



<p align="center">
  <img width="887" height="608" alt="image" src="https://github.com/user-attachments/assets/21b26a99-6376-4991-b288-9b631929377e" /><br>
  <em>Figure 1: The Writeback Pipeline Stage (repeated for convenience)</em>
</p>


## Sources & Acknowledgements

This project would not have been possible without the foundational knowledge provided by the following resources:

* The pipelined datapath and single cycle architecture's I made reference to are based on the designs from **"Digital Design and Computer Architecture | RISC-V Edition"** by Sarah L. Harris 
and David Money Harris. The primary information used for this project is sourced from chapter 7 of this textbook.

* The RISC-V instruction formats are sourced from a StackOverflow thread (https://stackoverflow.com/questions/39427092/risc-v-immediate-encoding-variants) (https://i.sstatic.net/Gkjuc.png). Thank you to Ammar Kurd (https://stackoverflow.com/users/6720357/ammar-kurd) of StackOverflow for providing these diagrams, although they likely originated from a textbook.

* Additional diagrams used for conceptual illustration were sourced from various public educational materials.







