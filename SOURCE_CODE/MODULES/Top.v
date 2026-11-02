module Top #(parameter integer DISPENSE_DURATION_CYCLES = 150_000_000)
    (output wire DISP_DRINK_1,
     output wire DISP_DRINK_2,
     output wire DISP_DRINK_3,
     output wire [4:0]BALANCE,
     output wire DRINK_LOCK,
     input DRINK_1,
     input DRINK_2,
     input DRINK_3,
     input COIN_5,
     input COIN_10,
     input clk,
     input rst);

    wire [4:0]DRINK_COST;
    wire ZERO_BALANCE, DISPENSE, DISPENSE_BUSY, DISPENSE_DONE, TRANSACTION_DONE;

    Selection_controller SLC (.DRINK_COST(DRINK_COST),
                              .DRINK_LOCK(DRINK_LOCK),
                              .DRINK_1(DRINK_1),
                              .DRINK_2(DRINK_2),
                              .DRINK_3(DRINK_3),
                              .TRANSACTION_DONE(TRANSACTION_DONE),
                              .clk(clk),
                              .rst(rst));

    Payment_controller PYC (.BALANCE(BALANCE),
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
                            .rst(rst));

    Dispense_controller #(.DURATION_CYCLES(DISPENSE_DURATION_CYCLES)) 
    DPC (.DISPENSE_1(DISP_DRINK_1),
         .DISPENSE_2(DISP_DRINK_2),
         .DISPENSE_3(DISP_DRINK_3),
         .DISPENSE_DONE(DISPENSE_DONE),
         .DRINK_COST(DRINK_COST),
         .DISPENSE(DISPENSE),
         .clk(clk),
         .rst(rst));
endmodule