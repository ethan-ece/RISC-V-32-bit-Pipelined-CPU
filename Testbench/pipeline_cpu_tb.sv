`timescale 1ns / 1ps

module pipeline_cpu_tb;

    // --- Signals for the Testbench ---
    logic clk;
    logic reset;

    // --- Instantiate the CPU (Device Under Test) ---
    // We don't connect any outputs, we will view them inside the simulator
    pipeline_cpu_top DUT (
        .clk(clk),
        .reset(reset)
    );

    // --- Clock Generator ---
    // Creates a 100 MHz clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Flips every 5ns
    end

    // --- Test Sequence and Simulation Control ---
    initial begin
        // The `$dumpfile` and `$dumpvars` commands are special Verilog tasks
        // that tell the simulator to record all the signal activity
        // so we can view it in the waveform.
        $dumpfile("waveform.vcd");
        $dumpvars(0, DUT);

        // --- Reset Sequence ---
        $display("T=%0t: Asserting Reset", $time);
        reset = 1;
        #20; // Hold reset for 20ns to ensure all registers initialize

        $display("T=%0t: De-asserting Reset. Starting Program.", $time);
        reset = 0;
        
        // --- Run the Simulation ---
        // Let the simulation run for a good amount of time to see the whole program
        #1000;

        // --- End the Simulation ---
        $display("T=%0t: Test finished. Halting simulation.", $time);
        $finish;
    end

endmodule
