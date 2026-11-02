module Selection_controller(output reg [4:0]DRINK_COST,
                            output reg DRINK_LOCK,
                            input DRINK_1,
                            input DRINK_2,
                            input DRINK_3,
                            input TRANSACTION_DONE,
                            input clk,
                            input rst);

    always @ (posedge clk)begin
        if(!rst)begin
            DRINK_COST <= 5'd0;
            DRINK_LOCK <= 1'b0;
        end
        else if(TRANSACTION_DONE)begin
            DRINK_COST <= 5'd0;
            DRINK_LOCK <= 1'b0;
        end
        else if(!DRINK_LOCK)begin
            case ({DRINK_3, DRINK_2, DRINK_1})
                3'b001: begin
                    DRINK_COST <= 5'd15;
                    DRINK_LOCK <= 1'b1;
                end
                3'b010: begin
                    DRINK_COST <= 5'd20;
                    DRINK_LOCK <= 1'b1;
                end
                3'b100: begin
                    DRINK_COST <= 5'd25;
                    DRINK_LOCK <= 1'b1;
                end
                default: begin
                    DRINK_COST <= 5'd0;
                    DRINK_LOCK <= 1'b0;
                end
            endcase
        end
    end
endmodule