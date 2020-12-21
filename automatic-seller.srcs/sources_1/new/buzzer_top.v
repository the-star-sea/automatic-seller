`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/22 01:33:53
// Design Name: 
// Module Name: buzzer_top
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


module buzzer_top(
    input wire clk,
    input wire rst_n,
    input wire [5:0] cnt,
    input buzeer_en,
    output wire beep
);

    buzzer buzzer(clk, rst_n, cnt, buzeer_en, beep);
endmodule: buzzer_top
