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
    output [1:0] status_out,
    input [3:0] keyboard,
    input keyboard_en,
    input [2:0] channel,
    output [2:0] channel_out,
    input [2:0] goods,
    input warning_cancel,
    output [2:0] goods_out,
    output [3:0] warning,//第0比特位传爆警使能信号
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
    output select_out
);

    always @(negedge reset)
        begin
            if (reset == 0) begin
                //全部初始化
            end
        end

    always @(posedge clk)
        begin
            case (status)
                2'b00: //todo初始状态

                2'b01: //todo购买状态
                //2'b10: //todo补货状态
            default:
            endcase
        end

endmodule : controller
