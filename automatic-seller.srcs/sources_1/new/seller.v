`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 23:19:05
// Design Name: 
// Module Name: firstTest
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


module seller(
input[2:0]state
    );

    reg [4:0]price1,price2,price3,price4,price5,price6;
    reg [2:0]cur_num1,cur_num2,cur_num3,cur_num4,cur_num5,cur_num6;//商品当前数量
    reg [4:0]sold_num1,sold_num2,sold_num3,sold_num4,sold_num5,sold_num6;//商品已售数量

    always @(state)
    begin
        case(state):
            2'b001: Search search();
            2'b010: Pay pay();
            2'b100: Add_goods add_goods();
    end

endmodule
