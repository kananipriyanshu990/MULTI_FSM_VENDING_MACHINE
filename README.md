# VENDING MACHINE FSM

Design files:
  Selection_controller.v
  Payment_controller.v
  Dispense_controller.v
  Top.v

Four independent testbenches:
  Selection_controller_TB.v
  Payment_controller_TB.v
  Dispense_controller_TB.v
  Vending_machine_TB.v  

Clock/reset:
  50 MHz clock (20 ns period in testbenches)
  rst is synchronous active-low: rst=0 resets the design.

Dispense duration:
  Hardware default: 150,000,000 cycles = 3 seconds at 50 MHz.
