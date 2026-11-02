module Dispense_controller #(parameter integer DURATION_CYCLES = 150_000_000)
    (output reg DISPENSE_1,
     output reg DISPENSE_2,
     output reg DISPENSE_3,
     output reg DISPENSE_DONE,
     input [4:0]DRINK_COST,
     input DISPENSE,
     input clk,
     input rst);

    reg [27:0]counter;
    reg active;

    always @ (posedge clk)begin
        if(!rst)begin
            counter <= 28'd0;
            active <= 1'b0;
            DISPENSE_1 <= 1'b0;
            DISPENSE_2 <= 1'b0;
            DISPENSE_3 <= 1'b0;
            DISPENSE_DONE <= 1'b0;
        end
        else begin
            DISPENSE_DONE <= 1'b0;

            if(!active && DISPENSE)begin
                active <= 1'b1;
                counter <= 28'd0;

                case (DRINK_COST)
                    5'd15: begin
                        DISPENSE_1 <= 1'b1;
                        DISPENSE_2 <= 1'b0;
                        DISPENSE_3 <= 1'b0;
                    end
                    5'd20: begin
                        DISPENSE_1 <= 1'b0;
                        DISPENSE_2 <= 1'b1;
                        DISPENSE_3 <= 1'b0;
                    end
                    5'd25: begin
                        DISPENSE_1 <= 1'b0;
                        DISPENSE_2 <= 1'b0;
                        DISPENSE_3 <= 1'b1;
                    end
                    default: begin
                        active <= 1'b0;
                        DISPENSE_1 <= 1'b0;
                        DISPENSE_2 <= 1'b0;
                        DISPENSE_3 <= 1'b0;
                    end
                endcase
            end
            else if(active)begin
                if(counter == DURATION_CYCLES - 1)begin
                    counter <= 28'd0;
                    active <= 1'b0;
                    DISPENSE_1 <= 1'b0;
                    DISPENSE_2 <= 1'b0;
                    DISPENSE_3 <= 1'b0;
                    DISPENSE_DONE <= 1'b1;
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end
endmodule