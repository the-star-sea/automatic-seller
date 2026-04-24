# FPGA Automatic Seller (Vending Machine)

This repository contains the Verilog/VHDL implementation of an Automatic Seller (Vending Machine) designed for FPGA deployment. 

## Key Features

- **Hardware Design:** Digital logic implementation for handling coin inputs, product selection, change calculation, and dispensing.
- **State Machine Architecture:** Uses Finite State Machines (FSM) to manage the vending process reliably.
- **I/O Integration:** Supports button inputs, switch configurations, and LED/Seven-Segment displays to communicate system state and transactions.

## Project Structure

- `automatic-seller.srcs/`: Hardware description source files (Verilog/VHDL) and constraints.
- `automatic-seller.ip_user_files/`: Generated IP core files.
- `automatic-seller.xpr`: Xilinx Vivado project file.

## Setup and Usage

1. **Prerequisites:** Ensure you have Xilinx Vivado installed to open and synthesize the project.
2. **Open the Project:**
   Open Vivado and load the `automatic-seller.xpr` file.
3. **Simulation and Synthesis:**
   - Run behavioral simulations to verify the vending machine logic.
   - Run Synthesis and Implementation to generate the bitstream.
4. **Deploy to FPGA:**
   Program your target FPGA board with the generated bitstream and use the configured I/O pins (buttons/switches) to simulate money insertion and item selection.

## Acknowledgments
Developed by Zhang Tong, Deng Xiangbo, and Zhang Kunlong.
