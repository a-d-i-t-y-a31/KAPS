`timescale 1ns / 1ps

module tb_addr_controller();
    
    reg clk;
    reg start;
    reg [23:0] X_start;
    reg [23:0] W_start;
    reg [10:0] size;
    
    wire [23:0] X_addr;
    wire [23:0] W_addr;
    wire done;

    Addr_controller u_addr_controller (
        .clk(clk),
        .start(start),
        .X_start(X_start),
        .W_start(W_start),
        .size(size),
        .X_addr(X_addr),
        .W_addr(W_addr),
        .done(done)
    );


    initial begin
        $dumpfile("dump.vcd"); // Specifies the output VCD file name
        $dumpvars(0, tb_addr_controller); // 0 means dump ALL signals & submodules inside tb_addr_controller
    end

    initial begin
        // Initialize signals
        clk = 0;
        start = 0;
        X_start = 24'h000000; // Example starting address for X
        W_start = 24'h000100; // Example starting address for W
        size = 11'd10; // Example size

        // Wait for a few clock cycles before starting
        #5 start = 1; // Start the address controller
        #10 start = 0; // Wait for one whole cycle to make sure working is set to 1 and the controller starts counting

        // Wait for the controller to finish
        wait(done);
        #10; // Wait for a few more clock cycles to observe the final addresses
        
        // Finish simulation


        X_start = 24'h000200; 
        W_start = 24'h000300; 
        size = 11'd15; 
        
        #5 start = 1; 
        #10 start = 0; 

        wait(done);
        #20;

        $finish;
    end

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock


endmodule