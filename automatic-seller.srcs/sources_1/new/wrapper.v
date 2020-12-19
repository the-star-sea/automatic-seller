`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/12 01:35:27
// Design Name: 
// Module Name: wrapper
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

//外壳，最外层模块
//负责组织所有的输入输出接口，以及内部各模块之间的连接
//输入输出直接对应开发板的引脚
module wrapper(
    input clk,
    input reset,
    input [3:0] keyboard_in,
    input [2:0] status,
    input [2:0] channel,
    input [2:0] goods,
    input warning_cancel,
    input [1:0] chooseroot,
    output [2:0] channel_led,//没绑定
    output [5:0] status_led,//没绑定
    output [2:0] good_led,//没绑定
    output select_led,//没绑定
    output [3:0] keyboard_col,
output [0:0]warning1,
output [0:0]warning2,
output [0:0]warning3,
output [0:0]warning4,
output [0:0]warning5,
output [0:0]warning6
);
parameter price1=2'd1;
parameter price2=2'd2;
parameter price3=2'd3;
parameter price4=2'd5;
parameter price5=2'd7;
parameter price6=2'd8;
parameter price7=2'd13;
parameter price8=2'd14;
parameter price9=2'd15;
    //keyboard 处理信息
    wire keyboard_en;
    wire [3:0] keyboard_col;
    wire [3:0] keyboard_out;
    keyboard keyboard(.clk(clk), .reset(reset), .keyboard_in(keyboard_in),
        .keyboard_col(keyboard_col),
        .keyboard_out(keyboard_out),
        .keyboard_en(keyboard_en));

    //控制信息
    wire [2:0] status_out;//todo 传给led模块
    wire [2:0] channel_out;//todo 传给led模块
    wire [2:0] goods_out;//todo 传给led模块
    wire [3:0] warning;
    wire [9:0] income;
    wire [44:0] current_numbers;//一个商品5个位宽，共9个商品,
    //[4:0]:货道001的第001个商品
    //[9:5]:货道001的第010个商品
    //[14:10]:货道001的第100个商品
    //[44:40]:货道100的第100个商品
    wire [44:0] sold_numbers;
    wire [44:0] max_supplement;
    wire [4:0] waiting_time;
    wire [3:0] select_number;
    wire select_out;//todo 传给led模块
    wire [5:0] paid;
    wire [5:0] inneedpaid;
    wire [5:0] charge;
    controller controller(
        .clk(clk),
        .reset(reset),
        .status(status),
        .status_out(status_led),
        .keyboard(keyboard_out),
        .keyboard_en(keyboard_en),
        .channel(channel), .channel_out(channel_out), .goods(goods), .goods_out(goods_out), .warning_cancel(warning_cancel), .warning(warning), .income(income),
        .current_numbers(current_numbers), .sold_numbers(sold_numbers), .max_supplement(max_supplement),
        .waiting_time(waiting_time), .select_number(select_number), .select_out(select_out),
        .paid(paid), .inneedpaid(inneedpaid), .charge(charge), .chooseroot(chooseroot));//todo

endmodule : wrapper
