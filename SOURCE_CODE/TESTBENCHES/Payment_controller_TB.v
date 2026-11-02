`timescale 1ns/1ps

module Payment_controller_TB;
    reg clk = 0, rst = 0, DRINK_LOCK = 0, DISPENSE_DONE = 0, COIN_5 = 0, COIN_10 = 0;
    reg [4:0]DRINK_COST = 0;
    wire [4:0]BALANCE;
    wire ZERO_BALANCE, DISPENSE, DISPENSE_BUSY, TRANSACTION_DONE;

    Payment_controller DUT (
        .BALANCE(BALANCE),
        .ZERO_BALANCE(ZERO_BALANCE),
        .DISPENSE(DISPENSE),
        .DISPENSE_BUSY(DISPENSE_BUSY),
        .TRANSACTION_DONE(TRANSACTION_DONE),
        .DRINK_COST(DRINK_COST),
        .DRINK_LOCK(DRINK_LOCK),
        .DISPENSE_DONE(DISPENSE_DONE),
        .COIN_5(COIN_5),
        .COIN_10(COIN_10),
        .clk(clk),
        .rst(rst)
    );

    always #10 clk = ~clk;

    task coin5;
        begin
            @(negedge clk); COIN_5 = 1;
            @(negedge clk); COIN_5 = 0;
            @(negedge clk);
        end
    endtask

    task coin10;
        begin
            @(negedge clk); COIN_10 = 1;
            @(negedge clk); COIN_10 = 0;
            @(negedge clk);
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        rst = 1;
        DRINK_COST = 15;
        DRINK_LOCK = 1;
        coin5();
        coin10();

        wait(DISPENSE);

        if(BALANCE !== 0)begin
            $error("Expected zero balance after 15; got %0d", BALANCE);
        end
        if(!DISPENSE_BUSY)begin
            $error("Expected busy during dispense");
        end

        @(negedge clk);
        DISPENSE_DONE = 1;
        @(negedge clk);
        DISPENSE_DONE = 0;

        wait(TRANSACTION_DONE);

        if(!ZERO_BALANCE)begin
            $error("Expected ZERO_BALANCE");
        end

        $display("PASS: Payment_controller_TB");
        $finish;
    end
endmodule