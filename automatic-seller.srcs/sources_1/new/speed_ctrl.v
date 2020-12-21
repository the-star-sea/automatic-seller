`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 08:50:59
// Design Name: 
// Module Name: speed_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module speed_ctrl(
    input wire clk,
    input wire rst_n,

    output reg [5:0] cnt
);
    parameter T_250ms=12_500_000;

    reg [25:0] count;
    wire flag_250ms;

    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0)
            count <= 26'd0;
        else
            if (count < T_250ms-1'b1)
            count <= count+1'b1;
        else
            count <= 26'd0;
    end
    assign flag_250ms = (count == T_250ms-1'b1) ? 1'b1:1'b0;
    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0)
            cnt <= 6'd0;
        else
            if (flag_250ms == 1'b1)
            cnt <= cnt+1'b1;
        else
            cnt <= cnt;
    end

endmodule
