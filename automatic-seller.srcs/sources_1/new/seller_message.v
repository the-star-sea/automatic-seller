`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/04 20:47:30
// Design Name: 
// Module Name: seller_message
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


module seller_message(
input add1_sell0,
input goodsN,
input numbers,
output [4:0]price1,
output [4:0]price2,
output [4:0]price3,
output [4:0]price4,
output [4:0]price5,
output [4:0]price6,
output [2:0]cur_num1,
output [2:0]cur_num2,
output [2:0]cur_num3,
output [2:0]cur_num4,
output [2:0]cur_num5,
output [2:0]cur_num6,
output [4:0]sold_num1,
output [4:0]sold_num2,
output [4:0]sold_num3,
output [4:0]sold_num4,
output [4:0]sold_num5,
output [4:0]sold_num6
    );

    reg [4:0]price1,price2,price3,price4,price5,price6;
    reg [2:0]cur_num1,cur_num2,cur_num3,cur_num4,cur_num5,cur_num6;//商品当前数量
    reg [4:0]sold_num1,sold_num2,sold_num3,sold_num4,sold_num5,sold_num6;//商品已售数量



endmodule
