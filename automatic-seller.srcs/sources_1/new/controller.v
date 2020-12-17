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
    output reg[1:0] status_out,
    input [3:0] keyboard,
    input keyboard_en,
    input [2:0] channel,
    output reg [2:0] channel_out,
    input [2:0] goods,
    input warning_cancel,
    output reg  [2:0]  goods_out,
    output reg [3:0] warning,//??0比特位传爆警使能信号
    output reg[9:0] income,
    output reg [44:0] current_numbers,//??个商??5个位宽，??9个商??,
    //[4:0]:货道001的第001个商??
    //[9:5]:货道001的第010个商??
    //[14:10]:货道001的第100个商??
    //[44:40]:货道100的第100个商??
    output reg [44:0] sold_numbers,
    output reg [44:0] max_supplement,
    output reg [4:0] waiting_time,
    output reg [3:0] select_number,
    output reg select_out
);

    always @(negedge reset)
        begin
            if (reset == 0) begin
                 status_out=0;
                 channel_out=0;
                 goods_out=0;
                warning=0;
                 income=0;
                current_numbers=0;
                 sold_numbers=0;
               max_supplement=0;
                waiting_time=0;
                  select_number=0;
                 select_out=0;
            end


    always @(posedge clk)
        begin
            case (status)
                2'b00: //todo初始状???
                begin
                channel_out=channel;
                goods_out=goods;
                 select=select_out

                    end
                2'b01: //todo购买状???

            default:
            endcase
        end

endmodule : controller
