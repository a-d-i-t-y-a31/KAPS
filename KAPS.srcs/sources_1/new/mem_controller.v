`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2026 10:01:58 PM
// Design Name: 
// Module Name: mem_controller
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


module mem_controller(
    input             clk,
    input             clk_bar,
    input             rst,
    input             cs_bar,  // remove as input keep as output
    input      [1:0]  r_w_bar,        
    input      [23:0] address,        
    input      [7:0]  data,    // input data to be written       
    inout      [7:0]  in_out_line,   // either read data or data to be written to ram
    output reg        read_write_ram // serialised r_w_bar
);

    reg [2:0] state, next_state;
    
    
    reg [7:0] in_out_driver;
    

    
    assign in_out_line = ~read_write_ram ? in_out_driver : 8'bZZZZZZZZ;

    
    always @(*) begin
        case(state)
            3'd0: next_state = 3'd1;
            3'd1: next_state = 3'd2;
            3'd2: next_state = 3'd3;
            3'd3: next_state = 3'd4;
            3'd4: next_state = 3'd5;
            3'd5: next_state = 3'd0;
            default: next_state = 3'd0;
        endcase
    end

    

    always @(posedge clk) begin
        if (rst)
            state <= 3'd0;
        else if (!cs_bar)
            state <= next_state;
        else
            state <= 3'd6; //?
    end 

    // 3. Output Logic (Combinational)
    always @(*) begin
        // Default values to prevent unwanted latches
        read_write_ram = 1'b0;
        in_out_driver  = 8'b0;
        

        case(state)
            3'd0: begin
                in_out_driver  = address[23:16];
                read_write_ram = 1'b0;
            end
            3'd1: begin
                in_out_driver  = address[15:8];
                read_write_ram = 1'b0;
            end
            3'd2: begin
                in_out_driver  = address[7:0];
                read_write_ram = 1'b0;
            end
            3'd3: begin
                in_out_driver  = 8'b0;
                read_write_ram = 1'b0;
            end
            3'd4: begin
                if (r_w_bar[1]) begin
                    read_write_ram = 1'b1;
                    
                end else begin
                    in_out_driver  = data;
                    read_write_ram = 1'b0;
                    
                end
            end
            3'd5: begin
                if (r_w_bar[0]) begin
                    read_write_ram = 1'b1;
                    
                end else begin
                    in_out_driver  = data;
                    read_write_ram = 1'b0;
                    
                end
            end
            default: begin
                read_write_ram = 1'b0;
                in_out_driver  = 8'b0;
                
            end
        endcase
    end

endmodule
