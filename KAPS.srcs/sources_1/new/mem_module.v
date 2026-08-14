`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2026 11:55:13 PM
// Design Name: 
// Module Name: mem_module
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


module mem_module(
        input clk,
        input clk_bar,
        input rst,
        input cs_bar,
        input [1:0] r_w_bar,
        input [23:0] address,
        inout [7:0] data
    );
    
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
    
endmodule
