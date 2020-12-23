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

    output wire beep, //蜂鸣器接�?

    input keyboard_en,
    input [3:0] keyboard_value,
    input warning1,
    input warning2,
    input [7:0] status //00000001响音乐
);

    reg buzeer_en;//让蜂鸣器�?
    reg [5:0] cnt;//调整蜂鸣器音�?


    // wire clk_1HZ;
    // frequency_divider#(.period(100000000)) frequency_divider(.clk(clk), .rst(reset), .clkout(clk_1HZ));

    reg [31:0] count;
    reg start;

    always @(posedge clk) begin
        if (rst_n == 0) count <= 32'b0;
        if (start == 1)
            begin
                count <= count+1;
            end
        if (count == 10000000)
            count <= 32'b0;
    end

    always @(posedge clk)
        begin
            if (rst_n == 0) start <= 1'b0;
            // else
            //     case (status)
            //         8'b00000001: start <= 1'b1;
            //         default:
            //             begin
            //                 if (keyboard_en == 1) start <= 1;
            //                 else if (count == 9999999) start <= 0;
            //             end
            //     endcase
            if (status == 8'b00000001) start <= 1'b1;
            else begin
                if (keyboard_en == 1) begin
                    start <= 1;
                end
                else if (count == 9999999)
                    start <= 0;
                else if (rst_n == 0) start <= 1'b0;
            end
            if (status != 8'b00000001 && count == 9999999) start = 1'b0;
        end


    always @(*) begin
        if (start == 1'b0)
            buzeer_en = 1'b0;
        else
            buzeer_en = 1'b1;
    end

    always @(posedge clk) begin
        if (keyboard_en == 1)
            case (keyboard_value)
                0: cnt = 6'b000001;
                1: cnt = 6'b000010;
                2: cnt = 6'b000100;
                3: cnt = 6'b001000;
                4: cnt = 6'b010000;
                5: cnt = 6'b100000;
                6: cnt = 6'b000011;
                7: cnt = 6'b000110;
                8: cnt = 6'b001100;
                9: cnt = 6'b011000;
                10: cnt = 6'b110000;
                11: cnt = 6'b000111;
                12: cnt = 6'b001110;
                13: cnt = 6'b011100;
                14: cnt = 6'b111000;
                15: cnt = 6'b001111;
                default: cnt = 6'b000000;
            endcase

        else if (status == 8'b00000001) begin

            if (rst_n == 1'b0)
                count_ <= 26'd0;
            else
                if (count_ < T_250ms-1'b1)
                count_ <= count_+1'b1;
            else
                count_ <= 26'd0;
            if (rst_n == 1'b0)
                cnt <= 6'd0;
            else
                if (flag_250ms == 1'b1)
                cnt <= cnt+1'b1;
            else
                cnt <= cnt;
        end
    end

//////////////////////////
    parameter T_250ms=12_500_000;
    reg [25:0] count_;
    wire flag_250ms;
    assign flag_250ms = (count_ == T_250ms-1'b1) ? 1'b1:1'b0;

    buzzer buzzer(clk, rst_n, cnt, buzeer_en, beep);
endmodule: buzzer_top
