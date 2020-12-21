`timescale 1ns/1ps


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
    input [0:0]okbutton,
    input [1:0] chooseroot,
    output [2:0] channel_led,
    output [2:0] good_led,
    //output select_led,//没绑定
    output [3:0] keyboard_col,
    output [0:0] warning1_led,
    output [0:0] warning2_led,
    output [0:0] warning3_led,
    output [0:0] warning4_led,
    output [0:0] warning5_led,
    output [0:0] warning6_led,
    output [7:0] DIG_tube,
    output [7:0] Y_tube,
    output [7:0] status_LED,

    input [3:0] select_numbers,
    output [3:0]select_outs
);


    assign select_outs = select_out;
    assign warning1_led = warning1;
    assign warning2_led = warning2;
    assign warning3_led = warning3;
    assign warning4_led = warning4;
    assign warning5_led = warning5;
    assign warning6_led = warning6;
    assign good_led = goods_out;
    assign channel_led = channel_out;
    assign status_LED = status_led;
    parameter price1=1;
    parameter price2=2;
    parameter price3=3;
    parameter price4=5;
    parameter price5=7;
    parameter price6=8;
    parameter price7=13;
    parameter price8=14;
    parameter price9=15;
    //keyboard 处理信息
    wire keyboard_en;
    wire [3:0] keyboard_col;
    wire [3:0] keyboard_out;
    keyboard keyboard(.clk(clk), .reset(reset), .keyboard_in(keyboard_in),
        .keyboard_col(keyboard_col),
        .keyboard_out(keyboard_out),
        .keyboard_en(keyboard_en));

    //控制信息
    // wire [2:0] status_out;//todo 传给led模块
    wire [2:0] channel_out;
    wire [2:0] goods_out;
    // wire [3:0] warning;
    wire [9:0] income;
    wire [44:0] current_numbers;//一个商品5个位宽，共9个商品,
    //[4:0]:货道001的第001个商品
    //[9:5]:货道001的第010个商品
    //[14:10]:货道001的第100个商品
    //[44:40]:货道100的第100个商品
    wire [44:0] sold_numbers;
    wire [44:0] max_supplement;
    wire [4:0] waiting_time;
    wire [3:0] select_number;//todo input
    wire [3:0]select_out;//todo output传给led模块 选择的数量
    wire [5:0] paid;
    wire [5:0] inneedpaid;
    wire [5:0] charge;
    wire [0:0] warning1;
    wire [0:0] warning2;
    wire [0:0] warning3;
    wire [0:0] warning4;
    wire [0:0] warning5;
    wire [0:0] warning6;
    wire [7:0] status_led;
    assign select_number = select_numbers;
    controller controller(
        .clk(clk),
        .reset(reset),
        .status(status),
        .status_out(status_led),
        .keyboard(keyboard_out),
        .keyboard_en(keyboard_en),
        .channel(channel), .channel_out(channel_out), .goods(goods), .goods_out(goods_out),
        .warning_cancel(warning_cancel),.okbutton(okbutton), .income(income),
        .current_numbers(current_numbers), .sold_numbers(sold_numbers), .max_supplement(max_supplement),
        .waiting_time(waiting_time), .select_number(select_number), .select_out(select_out),
        .paid(paid), .paidinneed(inneedpaid), .charge(charge), .chooseroot(chooseroot),
        .warning1(warning1), .warning2(warning2), .warning3(warning3), .warning4(warning4),
        .warning5(warning5), .warning6(warning6));//todo


    //数码显示管
    tube_display tube_display(.rst(reset), .clk(clk), .channel(channel_out),
        .goods_in(goods_out), .current_numbers(current_numbers), .waiting_time(waiting_time),
        .max_supplement(max_supplement), .sold_numbers(sold_numbers), .current_mode(status_led),
        .income(income), .charge(charge), .paid(paid), .DIG(DIG_tube), .Y(Y_tube));
endmodule : wrapper
