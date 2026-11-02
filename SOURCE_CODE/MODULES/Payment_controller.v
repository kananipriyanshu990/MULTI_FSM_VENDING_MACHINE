module Payment_controller(output reg [4:0]BALANCE,
                          output wire ZERO_BALANCE,
                          output reg DISPENSE,
                          output reg DISPENSE_BUSY,
                          output reg TRANSACTION_DONE,
                          input [4:0]DRINK_COST,
                          input DRINK_LOCK,
                          input DISPENSE_DONE,
                          input COIN_5,
                          input COIN_10,
                          input clk,
                          input rst);

    localparam WAITING = 1'b0;
    localparam VENDING = 1'b1;
    reg state;

    assign ZERO_BALANCE = (BALANCE == 5'd0) && (state == WAITING);

    always @ (posedge clk)begin
        if(!rst)begin
            BALANCE <= 5'd0;
            DISPENSE <= 1'b0;
            DISPENSE_BUSY <= 1'b0;
            TRANSACTION_DONE <= 1'b0;
            state <= WAITING;
        end 
        else begin
            DISPENSE <= 1'b0;
            TRANSACTION_DONE <= 1'b0;

            case (state)
                WAITING: begin
                    DISPENSE_BUSY <= 1'b0;
                    if(DRINK_LOCK && (COIN_5 ^ COIN_10))begin
                        if(COIN_5)begin
                            BALANCE <= BALANCE + 5'd5;
                        end
                        else begin
                            BALANCE <= BALANCE + 5'd10;
                        end
                    end

                    if(DRINK_LOCK && (DRINK_COST != 0) && (BALANCE >= DRINK_COST))begin
                        BALANCE <= BALANCE - DRINK_COST;
                        DISPENSE <= 1'b1;
                        DISPENSE_BUSY <= 1'b1;
                        state <= VENDING;
                    end
                end
                VENDING: begin
                    DISPENSE_BUSY <= 1'b1;
                    if(DISPENSE_DONE)begin
                        DISPENSE_BUSY <= 1'b0;
                        state <= WAITING;
                        if(BALANCE == 0)begin
                            TRANSACTION_DONE <= 1'b1;
                        end
                    end
                end
                default: begin
                    state <= WAITING;
                    DISPENSE <= 1'b0;
                    DISPENSE_BUSY <= 1'b0;
                    TRANSACTION_DONE <= 1'b0;
                end
            endcase
        end
    end
endmodule