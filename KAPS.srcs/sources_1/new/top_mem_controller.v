`timescale 1ns / 1ps


module top_mem_controller(
    input             clk,
    input             clk_bar,
    input             rst,
    input      [1:0]  r_w_bar_1,
    input      [23:0] address_1,
    input      [7:0]  data_1,
    inout      [7:0]  in_out_line_1,

    input      [1:0]  r_w_bar_2,
    input      [23:0] address_2,
    input      [7:0]  data_2,
    inout      [7:0]  in_out_line_2,

    input      [1:0]  r_w_bar_3,
    input      [23:0] address_3,
    input      [7:0]  data_3,
    inout      [7:0]  in_out_line_3,

    output reg        read_write_ram
);

    wire cs_bar_1, cs_bar_2, cs_bar_3;
    wire read_write_1, read_write_2, read_write_3;
    reg  [1:0] ram_select;
    reg  [1:0] access_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ram_select  <= 2'd0;
            access_count <= 3'd0;
        end else if (access_count == 3'd2) begin
            access_count <= 3'd0;
            ram_select  <= (ram_select == 2'd2) ? 2'd0 : ram_select + 1'b1;
        end else begin
            access_count <= access_count + 1'b1;
        end
    end

    assign cs_bar_1 = (ram_select == 2'd0) ? 1'b0 : 1'b1;
    assign cs_bar_2 = (ram_select == 2'd1) ? 1'b0 : 1'b1;
    assign cs_bar_3 = (ram_select == 2'd2) ? 1'b0 : 1'b1;

    mem_controller ram1_controller (
        .clk            (clk),
        .clk_bar        (clk_bar),
        .rst            (rst),
        .cs_bar         (cs_bar_1),
        .r_w_bar        (r_w_bar_1),
        .address        (address_1),
        .data           (data_1),
        .in_out_line    (in_out_line_1),
        .read_write_ram (read_write_1)
    );

    mem_controller ram2_controller (
        .clk            (clk),
        .clk_bar        (clk_bar),
        .rst            (rst),
        .cs_bar         (cs_bar_2),
        .r_w_bar        (r_w_bar_2),
        .address        (address_2),
        .data           (data_2),
        .in_out_line    (in_out_line_2),
        .read_write_ram (read_write_2)
    );

    mem_controller ram3_controller (
        .clk            (clk),
        .clk_bar        (clk_bar),
        .rst            (rst),
        .cs_bar         (cs_bar_3),
        .r_w_bar        (r_w_bar_3),
        .address        (address_3),
        .data           (data_3),
        .in_out_line    (in_out_line_3),
        .read_write_ram (read_write_3)
    );

    always @(*) begin
        case (ram_select)
            2'd0: read_write_ram = read_write_1;
            2'd1: read_write_ram = read_write_2;
            default: read_write_ram = read_write_3;
        endcase
    end

endmodule

