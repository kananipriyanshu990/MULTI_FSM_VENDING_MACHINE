`timescale 1ns/1ps

module Vending_machine_TB;
    reg clk = 1'b0;
    reg rst = 1'b0;
    reg DRINK_1 = 1'b0, DRINK_2 = 1'b0, DRINK_3 = 1'b0;
    reg COIN_5 = 1'b0, COIN_10 = 1'b0;

    wire DISP_DRINK_1, DISP_DRINK_2, DISP_DRINK_3;
    wire [4:0]BALANCE;
    wire DRINK_LOCK;

    Top #(.DISPENSE_DURATION_CYCLES(4)) 
    VENDING_MACHINE (.DISP_DRINK_1(DISP_DRINK_1),
       	             .DISP_DRINK_2(DISP_DRINK_2),
                     .DISP_DRINK_3(DISP_DRINK_3),
                     .BALANCE(BALANCE),
                     .DRINK_LOCK(DRINK_LOCK),
                     .DRINK_1(DRINK_1),
                     .DRINK_2(DRINK_2),
                     .DRINK_3(DRINK_3),
                     .COIN_5(COIN_5),
                     .COIN_10(COIN_10),
                     .clk(clk),
                     .rst(rst));

    always #10 clk = ~clk;

    task insert5;
        begin
            @(negedge clk); COIN_5 = 1'b1;
            @(negedge clk); COIN_5 = 1'b0;
            repeat (2) @(negedge clk);
        end
    endtask

    task insert10;
        begin
            @(negedge clk); COIN_10 = 1'b1;
            @(negedge clk); COIN_10 = 1'b0;
            repeat (2) @(negedge clk);
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        rst = 1'b1;

        @(negedge clk); DRINK_1 = 1'b1;
        @(negedge clk); DRINK_1 = 1'b0;
        insert10();
        insert10();
        wait(DISP_DRINK_1);
        wait(!DISP_DRINK_1);

        if(BALANCE !== 5)begin
            $error("Expected retained balance 5; got %0d", BALANCE);
        end

        insert10();
        wait(DISP_DRINK_1);
        wait(!DISP_DRINK_1);
        repeat (2) @(negedge clk);

        if(BALANCE !== 0)begin
            $error("Expected balance 0; got %0d", BALANCE);
        end
        if(DRINK_LOCK !== 0)begin
            $error("Expected selection unlocked at zero balance");
        end

        @(negedge clk); DRINK_3 = 1'b1;
        @(negedge clk); DRINK_3 = 1'b0;
        insert5(); 
        insert10(); 
        insert10();
        wait(DISP_DRINK_3);
        wait(!DISP_DRINK_3);
        repeat (2) @(negedge clk);

        if(BALANCE !== 0)begin
            $error("Expected balance 0 after Drink C");
        end

        $display("PASS: vending machine basic transactions and retained balance.");
        $finish;
    end
endmodule