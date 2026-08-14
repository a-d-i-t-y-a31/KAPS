module ram(
    input clk,
    input clk_bar,
    input rset,
    input cs_bar,
    input rw_bar,
    inout [7:0] data
);
    reg [7:0] ram_data [0:1024];
    reg [24:0] addr;
    reg [2:0] state;


    localparam ADDR_BYTE2 = 3'd0,
               ADDR_BYTE1 = 3'd1,
               ADDR_BYTE0 = 3'd2,
               BLANK      = 3'd3,
               DATA_1   = 3'd4,
               DATA_2  = 3'd5;

    assign data = (cs_bar == 0 && rw_bar == 1) ? (state == DATA_1 ? ram_data[addr] : (state == DATA_2 ? ram_data[addr+1] : 8'bz)) : 8'bz;

    always @(posedge clk) begin
        if (cs_bar == 1) begin
//            if (rset == 1) begin
//                integer i;
                
//                for (i = 0; i < 33554432; i = i + 1) begin          // FIND A BETTER WAY TO RESET THE RAM
//                    ram_data[i] = 8'b0;
//                end

//            end 
          
                case (state)

                    ADDR_BYTE2: begin               //STATE FOR CLK CYCLE 1
                        addr[24:17] <= data;
                        state <= ADDR_BYTE1;
                    end
                    ADDR_BYTE1: begin               //STATE FOR CLK CYCLE 2
                        addr[16:9] <= data;
                        state <= ADDR_BYTE0;
                    end
                    ADDR_BYTE0: begin               //STATE FOR CLK CYCLE 3
                        addr[8:1] <= data;
                        addr[0] <= 0;
                        state <= BLANK;
                    end

                    BLANK: begin                    //STATE FOR CLK CYCLE 4     
                        state <= DATA_1;
                    end

                    DATA_1: begin                   //STATE FOR CLK CYCLE 5
                        if (rw_bar == 0) begin
                            ram_data[addr] <= data;
                        end 
                        state <= DATA_2;
                    end

                    DATA_2: begin                   //STATE FOR CLK CYCLE 6
                        if (rw_bar == 0) begin
                            ram_data[addr+1] <= data;
                        end 
                        state <= ADDR_BYTE2;
                    end

                    default: begin                  //DEFAULT STATE
                        state <= ADDR_BYTE2;
                    end
                endcase
            end
        end
endmodule