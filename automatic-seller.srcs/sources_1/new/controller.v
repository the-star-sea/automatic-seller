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
    input reset,
    input [1:0] status,
    output [1:0] status_out,
    input [3:0] keyboard,
    input [2:0] channel,
    output [2:0] channel_out,
    input [2:0] goods,
    input warning_cancel,
    output [2:0] goods_out,
    output reg [4:0] warning,//第0比特位传爆警使能信号
    output reg [9:0] income,//总收益
    output reg [44:0] current_numbers,//一个商品5个位宽，共9个商品,
    //[4:0]:货道001的第001个商品
    //[9:5]:货道001的第010个商品
    //[14:10]:货道001的第100个商品
    //[44:40]:货道100的第100个商品
    output reg [44:0] sold_numbers,
    output reg [44:0] max_supplement,
    output reg [4:0] waiting_time,
    input reg [3:0] select_number,//选多少商品
    output reg [3:0]select_out
    reg [5:0]paid;//已付
    reg [5:0]inneedpaid;//要付
);
    reg [0:0] keyboard_enable;
    reg [4:0] money_in_all;
    assign channel_out = channel;
    assign goods_out = goods;
    assign status_out = status;
assign select_out=select_number;

    always @(posedge clk, posedge reset)
        if (reset == 1'b1) begin
            keyboard_enable <= 1'b0;
            warning <= 4'b0;
            income <= 10'b0;
            current_numbers <= 45'b0;
            sold_numbers <= 45'b0;
            max_supplement <= 45'b100;
            waiting_time <= 5'b0;
            select_out <= 0;
            paid<=0;
        end

        else begin

            case (status)
                2'b00: //todo初始状态
                    begin
                    end
                2'b01: //todo购买状态
                    begin
                        case (goods)
                            3'b000:
                                warning <= 4'b0001;//没选商品
                            3'b001:
                                warning <= 4'b0000;
                            3'b010:
                                warning <= 4'b0000;
                            3'b100:
                                warning <= 4'b0000;
                            default:
                                warning <= 4'b0010;//商品选多了
                        endcase

                        if (waiting_time<5'd30||paid<=)
                            begin

                            end

                    end

                //2'b10: //todo补货状态
                default:
                    begin

                    end
            endcase

        end

endmodule: controller