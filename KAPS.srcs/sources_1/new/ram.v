module ram(
    input clk,
    input clk_bar,
    input rset,
    input cs_bar,
    input rw_bar,
    inout [7:0] data
);
    reg [7:0] ram_data [0:33554431]; // 32MB RAM
    reg [24:0] addr;
    reg [2:0] state_ram;
    // reg [9:0] addr_temp;

    localparam ADDR_BYTE2 = 3'd0,
               ADDR_BYTE1 = 3'd1,
               ADDR_BYTE0 = 3'd2,
               BLANK      = 3'd3,
               DATA_1     = 3'd4,
               DATA_2     = 3'd5,
               IDLE       = 3'd6;

    assign data = (cs_bar == 0 && rw_bar == 1) ? (state_ram == DATA_1 ? ram_data[addr] : (state_ram == DATA_2 ? ram_data[addr+1] : 8'bz)) : 8'bz;

    always @(posedge clk) begin
        if (cs_bar == 0) begin
//            if (rset == 1) begin
//                integer i;
                
//                for (i = 0; i < 33554432; i = i + 1) begin          // FIND A BETTER WAY TO RESET THE RAM
//                    ram_data[i] = 8'b0;
//                end

//            end 
          
                case (state_ram)

                    IDLE: begin                       //state_ram FOR CLK CYCLE 0
                        state_ram <= ADDR_BYTE2;
                    end

                    ADDR_BYTE2: begin               //state_ram FOR CLK CYCLE 1
                        addr[24:17] <= data;
                        state_ram <= ADDR_BYTE1;
                    end
                    ADDR_BYTE1: begin               //state_ram FOR CLK CYCLE 2
                        addr[16:9] <= data;
                        state_ram <= ADDR_BYTE0;
                    end
                    ADDR_BYTE0: begin               //state_ram FOR CLK CYCLE 3
                        addr[8:1] <= data;
                        addr[0] <= 0;
                        state_ram <= BLANK;
                    end

                    BLANK: begin                    //state_ram FOR CLK CYCLE 4     
                        state_ram <= DATA_1;
                        // addr_temp <= addr[9:0];
                    end

                    DATA_1: begin                   //state_ram FOR CLK CYCLE 5
                        if (rw_bar == 0) begin
                            ram_data[addr] <= data;
                        end 
                        
                        state_ram <= DATA_2;
                    end

                    DATA_2: begin                   //state_ram FOR CLK CYCLE 6
                        if (rw_bar == 0) begin
                            ram_data[addr + 1] <= data;
                        end 
                        state_ram <= IDLE;
                    end

                    default: begin                  //DEFAULT state_ram
                        state_ram <= IDLE;
                    end
                endcase
            end
            
          else begin
            state_ram <= IDLE;
          end
        end
endmodule