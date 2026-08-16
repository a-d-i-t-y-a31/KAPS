
//                          8-bit Activation (X)     8-bit Weight (W)
//                                   │                      │
//                                   └──────────┬───────────┘
//                                              │
//                                              ▼
//                                   ┌──────────────────────┐
//                                   │ 8x8 Hardware         │
//                                   │ Multiplier           │
//                                   └──────────┬───────────┘
//                                              │
//                                          16-bit Product
//                                              │
//                                              ▼
//                                   ┌──────────────────────┐
//                                   │ Sign-Extension       │ (Pads to 32 bits)
//                                   └──────────┬───────────┘
//                                              │
//   32-bit Current Accumulator ────────────────┼──────────┐
//   (Feedback Loop)                            │          │
//                                              ▼          ▼
//                                   ┌──────────────────────┐
//                                   │ 32-bit Adder         │
//                                   └──────────┬───────────┘
//                                              │
//                                          32-bit Sum
//                                              │
//                                              ▼
//                                   ┌──────────────────────┐
//     Reset / Clear (rst) ─────────►│ 32-bit Accumulator   │◄── Clock Signal (clk)
//                                   │ Register             │
//                                   └──────────┬───────────┘
//                                              │
//                                              ▼
//                                    32-bit MAC Result

//                        ┌─────────────────────────┐
// clk ──────────────────►│                         │
// reset ────────────────►│                         │
// enable ───────────────►│      INT8 MAC UNIT      ├──────► acc [31:0]
// x [7:0] ──────────────►│                         │
// w [7:0] ──────────────►│                         │
//                        └─────────────────────────┘



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


module mac_unit(
    input signed [7:0]  x,
    input signed [7:0]  w,
    input             rst,
    input             en, 
    input             clk,        
    output reg signed [31:0] acc       
);

wire signed [15:0] prod;
wire signed [31:0] se_prod;

assign prod  =  x * w;
assign se_prod = { {16{prod[15]}}, prod};

always @(posedge clk) begin
    if(rst) acc <= 32'b0;
    else if(en) acc <= acc + se_prod;
    else acc <= acc;
end

endmodule