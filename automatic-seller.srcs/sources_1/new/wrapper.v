`timescale 1ns/1ps


//外壳，最外层模块
//负责组织所有的输入输出接口，以及内部各模块之间的连接
//输入输出直接对应开发板的引脚
//外壳，最外层模块
//负责组织所有的输入输出接口，以及内部各模块之间的连接
//输入输出直接对应开发板的引脚
module wrapper(
    input    [0:0]   clk,                   //时钟信号
    input    [0:0]   reset,                 //复位信号
    input    [3:0]   keyboard_in,           //小键盘的行信号
    input    [2:0]   status,                //状态
    input    [2:0]   channel,               //货道号
    input    [2:0]   goods,                 //商品号
    input    [1:0]   chooseroot,            //选择补货或查看销售信息
    output   [2:0]   channel_led,           //货道号显示灯
    output   [2:0]   good_led,              //商品号显示灯
    output   [3:0]   keyboard_col,          //小键盘的列信号
    output   [0:0]   warning1_led,          //补货补多了
    output   [0:0]   warning2_led,          //购买时选多了
    output   [0:0]   warning3_led,          //提示顾客继续付款
    output   [7:0]   DIG_tube,              //选择数码管
    output   [7:0]   Y_tube,                //选择数码管的显示
    output   [7:0]   status_LED,            //状态显示灯
    input    [3:0]   select_numbers,        //选择数量
    output   [3:0]   select_outs,           //选择数量的指示灯
    output   [0:0]   beep                   //蜂鸣器
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
    keyboard keyboard(.clk(clk), .rst_n(reset), .key_in_x(keyboard_in),
        .key_out_y(keyboard_col),
        .key_value(keyboard_out),
        .key_flag(keyboard_en));

    //控制信息
    wire [2:0] channel_out;
    wire [2:0] goods_out;
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
    wire [3:0] select_out;
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
        .warning_cancel(warning_cancel), .income(income),
        .current_numbers(current_numbers), .sold_numbers(sold_numbers), .max_supplement(max_supplement),
        .waiting_time(waiting_time), .select_number(select_number), .select_out(select_out),
        .paid(paid), .paidinneed(inneedpaid), .charge(charge), .chooseroot(chooseroot),
        .warning1(warning1), .warning2(warning2), .warning3(warning3), .warning4(warning4),
        .warning5(warning5), .warning6(warning6));


    //数码显示管
    tube_display tube_display(.rst(reset), .clk(clk), .channel(channel_out),
        .goods_in(goods_out), .current_numbers(current_numbers), .waiting_time(waiting_time),
        .inneedpaid(inneedpaid),
        .max_supplement(max_supplement), .sold_numbers(sold_numbers), .current_mode(status_led),
        .income(income), .charge(charge), .paid(paid), .DIG(DIG_tube), .Y(Y_tube));


    //蜂鸣器
    buzzer_top buzzer_top(.clk(clk), .rst_n(reset), .beep(beep), .keyboard_en(keyboard_en),
        .keyboard_value(keyboard_out), .status(status_led));
endmodule : wrapper
