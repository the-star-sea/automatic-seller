`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/12 18:59:31
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input reset,//来回拨动
    input [1:0] status,
    output [1:0] status_led,
    input [3:0] keyboard,
    input [2:0] channel,
    output [2:0] channel_led,
    input [2:0] goods,
    output [2:0] goods_led,
    output [3:0] warning,
    output [9:0] income,
    output [44:0] current_numbers,//一个商品5个位宽，共9个商品,
    //[4:0]:货道001的第001个商品
    //[9:5]:货道001的第010个商品
    //[14:10]:货道001的第100个商品
    //[44:40]:货道100的第100个商品
    output [44:0] sold_numbers,
    output [44:0] max_supplement,
    output [4:0] waiting_time,
    output [3:0] select_number,
    output select_led

);


    parameter max_number=10;

    always @(posedge reset) begin

    end

endmodule : controller
