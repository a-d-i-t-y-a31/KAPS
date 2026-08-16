`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 01:01:18 PM
// Design Name: 
// Module Name: tb_mac_unit
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


module tb_mac_unit(

    );
    
    reg clk;
    reg rst;
    reg en;
    reg signed [7:0] x;
    reg signed [7:0] w;
    wire signed [31:0] acc;
    
    mac_unit dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x(x),
        .w(w),
        .acc(acc)
    );
    
    always #10 clk = ~clk;
    
    initial begin
        // Initialize 
        clk = 0;
        rst = 1;
        en = 0;
        x = 0;
        w = 0;

        // reset 
        #20;
        rst = 0;
        #10;
        
        // --- Both Positive (5 * 4 = 20) ---
        $display("[TIME %0t] Test 1: Positive * Positive", $time);
        en = 1;
        x = 8'sd5;   
        w = 8'sd4;   
        #20;
        
        $display("[TIME %0t] Test 2: Positive * Negative", $time);
        x = 8'sd10;  
        w = -8'sd3;  
        #20;
        
        $display("[TIME %0t] Test 3: Negative * Negative", $time);
        x = -8'sd4;  
        w = -8'sd5;  
        #20;
        
        
        $display("[TIME %0t] Test 4: no Enable ", $time);
        en = 0;
        x = 8'sd2;
        w = 8'sd2;
        #20;
        
        $display("[TIME %0t] Test 5: Verify Reset Action", $time);
        rst = 1;
        #20;
        rst = 0;
        en = 1;
        
         $finish;
    end
    
endmodule
