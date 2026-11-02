`timescale 1ns/1ps

module Selection_controller_TB;
    reg clk = 0, rst = 0;
    reg DRINK_1 = 0, DRINK_2 = 0, DRINK_3 = 0, TRANSACTION_DONE = 0;
    wire [4:0]DRINK_COST;
    wire DRINK_LOCK;

    Selection_controller DUT (
        .DRINK_COST(DRINK_COST),
        .DRINK_LOCK(DRINK_LOCK),
        .DRINK_1(DRINK_1),
        .DRINK_2(DRINK_2),
        .DRINK_3(DRINK_3),
        .TRANSACTION_DONE(TRANSACTION_DONE),
        .clk(clk),
        .rst(rst)
    );

    always #10 clk = ~clk;

    initial begin
        repeat (2) @(negedge clk);
        rst = 1;
        @(negedge clk); DRINK_2 = 1;
        @(negedge clk); DRINK_2 = 0;
        repeat (2) @(negedge clk);

        if(DRINK_COST !== 20 || DRINK_LOCK !== 1)begin
            $error("Drink B selection did not latch");
        end

        @(negedge clk); DRINK_3 = 1;
        @(negedge clk); DRINK_3 = 0;

        if(DRINK_COST !== 20 || DRINK_LOCK !== 1)begin
            $error("Selection changed while locked");
        end

        @(negedge clk); TRANSACTION_DONE = 1;
        @(negedge clk); TRANSACTION_DONE = 0;

        if(DRINK_COST !== 0 || DRINK_LOCK !== 0)begin
            $error("Selection did not clear on transaction done");
        end

        $display("PASS: Selection_controller_TB");
        $finish;
    end
endmodule