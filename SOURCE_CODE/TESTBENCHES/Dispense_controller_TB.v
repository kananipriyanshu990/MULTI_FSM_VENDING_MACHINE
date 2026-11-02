`timescale 1ns/1ps

module Dispense_controller_TB;
    reg clk = 0, rst = 0, DISPENSE = 0;
    reg [4:0]DRINK_COST = 0;
    wire DISPENSE_1, DISPENSE_2, DISPENSE_3, DISPENSE_DONE;

    Dispense_controller #(.DURATION_CYCLES(4)) DUT (
        .DISPENSE_1(DISPENSE_1),
        .DISPENSE_2(DISPENSE_2),
        .DISPENSE_3(DISPENSE_3),
        .DISPENSE_DONE(DISPENSE_DONE),
        .DRINK_COST(DRINK_COST),
        .DISPENSE(DISPENSE),
        .clk(clk),
        .rst(rst)
    );

    always #10 clk = ~clk;

    initial begin
        repeat (2) @(negedge clk);
        rst = 1;
        @(negedge clk);
        DRINK_COST = 25;
        DISPENSE = 1;
        @(negedge clk);
        DISPENSE = 0;

        if({DISPENSE_3, DISPENSE_2, DISPENSE_1} !== 3'b100)begin
            $error("Wrong drink output for cost 25");
        end

        wait(DISPENSE_DONE);
        @(negedge clk);

        if({DISPENSE_3, DISPENSE_2, DISPENSE_1} !== 3'b000)begin
            $error("Drink output did not turn off");
        end

        $display("PASS: Dispense_controller_TB");
        $finish;
    end
endmodule