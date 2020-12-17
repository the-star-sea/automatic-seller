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
    input reset,//���ز���
    input [1:0] status,
    output reg[1:0] status_out,
    input [3:0] keyboard,
    input keyboard_en,
    input [2:0] channel,
    output reg [2:0] channel_out,
    input [2:0] goods,
    input warning_cancel,
    output reg  [2:0]  goods_out,
    output reg [3:0] warning,//??0����λ������ʹ���ź�
    output reg[9:0] income,
    output reg [44:0] current_numbers,//??����??5��λ��??9����??,
    //[4:0]:����001�ĵ�001����??
    //[9:5]:����001�ĵ�010����??
    //[14:10]:����001�ĵ�100����??
    //[44:40]:����100�ĵ�100����??
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
                2'b00: //todo��ʼ״???
                begin
                channel_out=channel;
                goods_out=goods;
                 select=select_out

                    end
                2'b01: //todo����״???

            default:
            endcase
        end

endmodule : controller
