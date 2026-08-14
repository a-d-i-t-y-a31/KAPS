`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 03:24:29 PM
// Design Name: 
// Module Name: tb_memcontroller_ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_memcontroller_ram(

    );
    
    // 1. Testbench Signal Declarations
    reg        clk;
    wire       clk_bar;          // Driven combinational or via assign
    reg        rst;
    reg        cs_bar;
    reg  [1:0] r_w_bar;
    reg  [23:0] address;
    reg  [7:0] data;
    
    wire [7:0] in_out_line;      // MUST be wire for bidirectional port
    wire       read_write_ram;  // MUST be wire because it's driven by DUT output

       
    
      
    // Generate inverse clock continuously
    assign clk_bar = ~clk;
    
    // 2. Instantiate DUT (Device Under Test)
    mem_controller u_mem_controller (
        .clk            (clk),
        .clk_bar        (clk_bar),
        .rst            (rst),
        .cs_bar         (cs_bar),
        .r_w_bar        (r_w_bar),
        .address        (address),
        .data           (data),
        .in_out_line    (in_out_line),
        .read_write_ram (read_write_ram)
    );
    
    ram mem_store(
        .clk            (clk),
        .clk_bar        (clk_bar),
        .rset            (rst),
        .cs_bar         (cs_bar),
        .rw_bar        (read_write_ram),
        .data           (in_out_line)
    );
    
    always #5 clk = ~clk;
    initial begin
        // --- Initialize Signals ---
        clk              = 1'b0;
        rst              = 1'b1;     // Assert reset active
        cs_bar           = 1'b1;     // Chip Select inactive (High)
        r_w_bar          = 2'b00;
        address          = 24'h000000;
        data             = 8'h00;
        
        

        // --- Release Reset ---
        #20;
        rst = 1'b0;
        #10;

        // =========================================================================
        // TEST CASE 1: WRITE Cycle (r_w_bar = 2'b00)
        // Expected behavior: Cycles through states 0->1->2->3->4->5 driving
        // Address bytes, then Write Data on the bus.
        // =========================================================================
        $display("[%0t ns] --- Starting WRITE Cycle ---", $time);
        address = 24'hABCDEF;
        data    = 8'hA5;
        r_w_bar = 2'b00; // Write mode for both state 4 and 5
        cs_bar  = 1'b0;  // Enable Controller

        // Wait 6 clock cycles to traverse states 0 to 5
        repeat (7) @(posedge clk);

        cs_bar = 1'b1; // Disable Controller
        #20;

        // =========================================================================
        // TEST CASE 2: READ Cycle (r_w_bar = 2'b11)
        // Expected behavior: States 0-2 drive address. States 4-5 set DUT oe=0,
        // allowing testbench/RAM to drive mock data back on in_out_line.
        // =========================================================================
        $display("[%0t ns] --- Starting READ Cycle ---", $time);
        address = 24'hABCDEF;
        r_w_bar = 2'b11; // Read mode for both state 4 and 5
        cs_bar  = 1'b0;  // Enable Controller

        // States 0, 1, 2, 3
        repeat (5) @(posedge clk);

        // Entering State 4 (DUT releases bus, testbench simulates RAM response)

        
        @(posedge clk); // State 5
        

        @(posedge clk); // Done cycling
        cs_bar           = 1'b1;

        #40;
        $display("[%0t ns] --- Simulation Completed Successfully ---", $time);
        $finish;
    end
    
endmodule
