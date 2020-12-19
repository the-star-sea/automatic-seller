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
    input [2:0] status,
    output [5:0] status_out,
    input [3:0] keyboard,
    input keyboard_en,
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
    output reg [44:0] max_supplement,//还可以添加的数量
    output reg [4:0] waiting_time,
    input [3:0] select_number,//选多少商品
    output [3:0] select_out,
    output reg [5:0] paid,//已付
    output reg [5:0] inneedpaid,//要付
    output reg[5:0]charge,//找零
    input [1:0] chooseroot

);
    assign channel_out = channel;
    assign goods_out = goods;
    assign select_out = select_number;
    assign status_out = current_mode;
    reg [5:0] current_mode, next_mode;
    parameter resetmode=6'b000000;
    parameter purchasemode=6'b000001;
    parameter managermode=6'b000010;
    parameter browsemode=6'b000100;
    parameter failpurchase=6'b001000;
    parameter completepurchase=6'b010000;
    parameter rootbrowse=6'b100000;
    parameter rootadd=6'b000011;
    parameter maxnum=4'b1000;
    // parameter searchMode=6'b000001;

    always @(posedge clk, negedge reset)
        if (~reset && status == 3'b100) current_mode <= resetmode;
        else current_mode <= next_mode;

    always @*
        case (current_mode)
            resetmode: //100
                case (status)
                    3'b001: next_mode = browsemode;
                    3'b010: next_mode = purchasemode;
                    3'b100: next_mode = managermode; //todo 可能有bug
                    default: next_mode = current_mode;

                endcase
            browsemode:
                case (status)
                    3'b010: next_mode = purchasemode;
                    3'b100: next_mode = managermode;
                    default: next_mode = current_mode;
                endcase
            purchasemode:
                begin
                    if (waiting_time < 30 && paid < inneedpaid)
                        next_mode = current_mode;
                    else if (waiting_time >= 30)
                        next_mode = failpurchase;
                    else next_mode = completepurchase;
                end
            failpurchase:
                case (status)
                    3'b001: next_mode = browsemode;//010
                    3'b100: next_mode = managermode;
                    default: next_mode = current_mode;
                endcase
            completepurchase: //010
                case (status)
                    3'b001: next_mode = browsemode;
                    3'b100: next_mode = managermode;
                    default: next_mode = current_mode;
                endcase
            managermode: //100
                if (chooseroot == 2'b01)

                    next_mode = rootbrowse;
                else if (chooseroot == 2'b10)
                    next_mode = rootadd;
                else
                    begin
                        case (status)
                            3'b001: next_mode = browsemode;
                            default: next_mode = current_mode;
                        endcase
                    end
            rootbrowse:
                if (chooseroot == 2'b00)

                    next_mode = managermode;
                else if (chooseroot == 2'b10)
                    next_mode = rootadd;
                else
                    begin
                        case (status)
                            3'b001: next_mode = browsemode;
                            default: next_mode = current_mode;
                        endcase
                    end
            rootadd:
                if (chooseroot == 2'b01)

                    next_mode = rootbrowse;
                else if (chooseroot == 2'b00)
                    next_mode = managermode;
                else
                    begin
                        case (status)
                            3'b001: next_mode = browsemode;
                            default: next_mode = current_mode;
                        endcase
                    end
            // if (reset == 1'b0) mode <= resetmode;

            // else begin
            //     case (status)
            //         2'b00: mode <= searchMode;
            //
            //     endcase


            // if(mode==searchMode )begin
            //     case(channel)
            //         3'b001:
            //         3'b010:
            //         3'b100:
            //         default : mode <=searchMode;
            //     endcase
            //
            // end

            // end
        endcase
    always @* begin //todo
        case (current_mode)
            resetmode:
                begin
                    warning = 4'b0;
                    income = 10'b0;
                    current_numbers <= 45'b0;
                    sold_numbers <= 45'b0;
                end

        endcase

    end


    always @(posedge keyboard_enable,negedge reset)
   if(keyboard_enable==1'b1)
   if(mode==rootadd)
        begin
case({channel,goods})
6'b001001:

if(max_supplement[4:0]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[4:0]+=keyboard;

6'b001010:

if(max_supplement[9:5]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[9:5]+=keyboard;
6'b001100:
if(max_supplement[14:10]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[14:10]+=keyboard;

6'b010001:
if(max_supplement[19:15]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[19:15]+=keyboard;

6'b010010:
if(max_supplement[24:20]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[24:20]+=keyboard;

6'b010100:
if(max_supplement[29:25]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[29:25]+=keyboard;

6'b100001:
if(max_supplement[34:30]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[34:30]+=keyboard;

6'b100010:
if(max_supplement[39:35]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[39:35]+=keyboard;

6'b100100:
if(max_supplement[44:40]+keyboard<maxnum)warning=4'b0001;//补多了
else max_supplement[44:40]+=keyboard;

endcase
else if(current_mode==purchasemod)
begin
paid+=keyboard;
end
 end
 else if(keyboard_enable==1'b0)
 begin
 if(mode==rootadd) max_supplement = 45'b010000100001000010000100001000010000100001000;
 else paid=6'b0;
 end

    // reg [0:0] keyboard_enable;
    // reg [4:0] money_in_all;
    // assign channel_out = channel;
    // assign goods_out = goods;
    // assign status_out = status;
    // assign select_out = select_number;

    // always @(posedge clk, posedge reset)
    //     if (reset == 1'b1) begin
    //         keyboard_enable <= 1'b0;
    //         warning <= 4'b0;
    //         income <= 10'b0;
    //         current_numbers <= 45'b0;
    //         sold_numbers <= 45'b0;
    //         max_supplement <= 45'b100;
    //         waiting_time <= 5'b0;
    //         select_out <= 0;
    //         paid <= 0;
    //     end
    //
    //     else begin
    //
    //         case (status)
    //             2'b00: //todo初始状态
    //                 begin
    //                 end
    //             2'b01: //todo购买状态
    //                 begin
    //                     case (goods)
    //                         3'b000:
    //                             warning <= 4'b0001;//没选商品
    //                         3'b001:
    //                             warning <= 4'b0000;
    //                         3'b010:
    //                             warning <= 4'b0000;
    //                         3'b100:
    //                             warning <= 4'b0000;
    //                         default:
    //                             warning <= 4'b0010;//商品选多了
    //                     endcase
    //
    //                     if (waiting_time < 5'd30 || paid <=)
    //                         begin
    //
    //                         end
    //
    //                 end
    //
    //             //2'b10: //todo补货状态
    //             default:
    //                 begin
    //
    //                 end
    //         endcase
    //
    //     end

endmodule: controller
