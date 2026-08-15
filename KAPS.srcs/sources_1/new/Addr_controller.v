module Addr_controller(
    input clk,
    input start,
    input   [23:0] X_start,
    input   [23:0] W_start,
    input   [10:0] size,
    output  [23:0] X_addr,
    output  [23:0] W_addr,
    output  done
);

// The start of x and w arrays are to be handled by the controller.

    reg [10:0] counter;
    reg [23:0] X_addr_reg;
    reg [23:0] W_addr_reg;
    reg [10:0] size_reg;
    reg done_reg;
    reg working;                //So that we don't start counting until the start is high

    assign X_addr = X_addr_reg;
    assign W_addr = W_addr_reg;
    assign done = done_reg;

    initial begin
        counter <= 0;
        X_addr_reg <= 0;
        W_addr_reg <= 0;
        done_reg <= 0;
        working <= 0;
        size_reg <= 0;
    end
    
    always @(posedge start) begin
            counter <= 0;
            X_addr_reg <= X_start;
            W_addr_reg <= W_start;
            done_reg <= 0;
            size_reg <= size;
    end

    always @(posedge clk) begin
        if(start) begin
            working <= 1;
        end
        if (working) begin
            if (counter < size_reg) begin
                counter <= counter + 1;
                X_addr_reg <= X_addr_reg + 1;
                W_addr_reg <= W_addr_reg + 1;
            end else begin
                done_reg <= 1;
                working <= 0;
            end
            if (done_reg) begin
                done_reg <= 0;
            end
        end
    end

endmodule