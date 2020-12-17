`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/12 18:19:51
// Design Name:
// Module Name: keyboard
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


module keyboard(
    input clk,
    input reset,
    input [3:0]keyboard_in, //keyboard_row
    output reg [3:0] keyboard_col, //keyboard_column
    output reg [3:0] keyboard_out, //keyboard_value
    output reg keyboard_en
);

//
    //frequency divider
    reg [19:0] cnt;
    always @ (posedge clk, negedge reset)
        if (~reset) cnt <= 0;
        else cnt <= cnt + 1'b1;
    wire key_clk = cnt[19];  // (2^20/50M = 21)ms


    //FSA one hot code
    parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下
    parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列
    parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列
    parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列
    parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列
    parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下

    reg [5:0] current_state, next_state; //现态、次态

    always @ (posedge key_clk, negedge reset)
        if (~reset) current_state <= NO_KEY_PRESSED;
        else current_state <= next_state;
    //根据条件转移状态
    always @ *
        case (current_state)
            NO_KEY_PRESSED :                    // 没有按键按下
                if (keyboard_in != 4'hF)
                    next_state = SCAN_COL0;
                else
                    next_state = NO_KEY_PRESSED;
            SCAN_COL0 :                         // 扫描第0列
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL1;
            SCAN_COL1 :                         // 扫描第1列
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL2;
            SCAN_COL2 :                         // 扫描第2列
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL3;
            SCAN_COL3 :                         // 扫描第3列
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = NO_KEY_PRESSED;
            KEY_PRESSED :                       // 有按键按下
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = NO_KEY_PRESSED;
        endcase

    reg       key_pressed_flag;             // 键盘按下标志
    reg [3:0] col_val, row_val;             // 列值、行值

    // 根据次态，给相应寄存器赋值
    always @ (posedge key_clk, negedge reset)
        if (!reset)
            begin
                keyboard_col              <= 4'h0;
                key_pressed_flag <=    0;
            end
        else
            case (next_state)
                NO_KEY_PRESSED :                  // 没有按键按下
                    begin
                        keyboard_en <= 0;
                        keyboard_col              <= 4'h0;
                        key_pressed_flag <=    0;       // 清键盘按下标志
                    end
                SCAN_COL0 :                       // 扫描第0列
                    keyboard_col <= 4'b1110;
                SCAN_COL1 :                       // 扫描第1列
                    keyboard_col <= 4'b1101;
                SCAN_COL2 :                       // 扫描第2列
                    keyboard_col <= 4'b1011;
                SCAN_COL3 :                       // 扫描第3列
                    keyboard_col <= 4'b0111;
                KEY_PRESSED :                     // 有按键按下
                    begin
                        keyboard_en <= 1;
                        col_val          <= keyboard_col;        // 锁存列值
                        row_val          <= keyboard_in;        // 锁存行值
                        key_pressed_flag <= 1;          // 置键盘按下标志
                    end
            endcase

    //扫描行列值
    always @ (posedge key_clk, negedge reset)
        if (!reset)
            keyboard_out <= 4'h0;
        else
            if (key_pressed_flag)
            case ({col_val, row_val})
                8'b1110_1110 : keyboard_out <= 4'hD;//D
                8'b1110_1101 : keyboard_out <= 4'hC;//C
                8'b1110_1011 : keyboard_out <= 4'hB;//B
                8'b1110_0111 : keyboard_out <= 4'hA;//A

                8'b1101_1110 : keyboard_out <= 4'hF;//#
                8'b1101_1101 : keyboard_out <= 4'h9;//9
                8'b1101_1011 : keyboard_out <= 4'h6;//6
                8'b1101_0111 : keyboard_out <= 4'h3;//3

                8'b1011_1110 : keyboard_out <= 4'h0;//0
                8'b1011_1101 : keyboard_out <= 4'h8;//8
                8'b1011_1011 : keyboard_out <= 4'h5;//5
                8'b1011_0111 : keyboard_out <= 4'h2;//2

                8'b0111_1110 : keyboard_out <= 4'hE;//*
                8'b0111_1101 : keyboard_out <= 4'h7;//7
                8'b0111_1011 : keyboard_out <= 4'h4;//4
                8'b0111_0111 : keyboard_out <= 4'h1;//1
            endcase
endmodule : keyboard
