module controller(
    input clk,
    input reset,
    input [2:0] status,
    output [7:0] status_out,
    input [3:0] keyboard,
    input keyboard_en,
    input [2:0] channel,
    output [2:0] channel_out,
    input [2:0] goods,
    input warning_cancel,
    output [2:0] goods_out,

    output reg [9:0] income,//总收益
    output reg [44:0] current_numbers,//一个商品5个位宽，共9个商品,现在多少商品
    //[4:0]:货道001的第001个商品
    //[9:5]:货道001的第010个商品
    //[14:10]:货道001的第100个商品
    //[44:40]:货道100的第100个商品
    output reg [44:0] sold_numbers,//卖了多少商品
    output [44:0] max_supplement,//还可以添加的数量
    output reg [4:0] waiting_time,//付款计时器，一进入付款状态立即开始计时，处于其他状态保持为0
    input [3:0] select_number,//选多少商品
    output [3:0] select_out,
    output reg [5:0] paid,//已付
    output reg [5:0] paidinneed,//要付
    output reg [5:0] charge,//找零
    input [1:0] chooseroot,
    output reg [0:0] warning1,
    output reg [0:0] warning2,
    output reg [0:0] warning3,
    output reg [0:0] warning4,
    output reg [0:0] warning5,
    output reg [0:0] warning6
);
    assign max_supplement = maxnum-current_numbers;
    assign channel_out = channel;
    assign goods_out = goods;
    assign select_out = select_number;
    assign status_out = current_mode;
    reg [7:0] current_mode, next_mode;
    parameter resetmode=8'b00000000;
    parameter purchasemode=8'b00000001;
    parameter managermode=8'b00000010;
    parameter browsemode=8'b00000100;
    parameter failpurchase=8'b00001000;
    parameter completepurchase=8'b00010000;
    parameter rootbrowse=8'b00100000;
    parameter rootadd=8'b01000000;
    parameter allinall=8'b10000000;
    parameter maxnum=4'b1000;
    parameter price1=2'd1;
    parameter price2=2'd2;
    parameter price3=2'd3;
    parameter price4=2'd5;
    parameter price5=2'd7;
    parameter price6=2'd8;
    parameter price7=2'd13;
    parameter price8=2'd14;
    parameter price9=2'd15;
    // parameter searchMode=6'b000001;

    always @(posedge clk, negedge reset)
        if (~reset && status == 3'b100) current_mode <= resetmode;
        else current_mode <= next_mode;

    //30秒计时器
    reg clockstart;
    wire clk_1HZ;
    frequency_divider#(.period(100000000)) frequency_divider(.clk(clk), .rst(clockstart), .clkout(clk_1HZ));
    always @(posedge clk_1HZ) begin
        if (clockstart == 1'b1) begin
            waiting_time = waiting_time+1;
        end
        if (clockstart == 1'b0) begin
            waiting_time = 5'b00000;
        end
    end

    always @*
        case (current_mode)
            resetmode: //100
                begin
                    clockstart = 1'b0;
                    case (status)
                        3'b001: next_mode = browsemode;
                        3'b010: next_mode = purchasemode;
                        3'b100: next_mode = managermode; //todo 可能有bug
                        default: next_mode = current_mode;

                    endcase
                end
            browsemode: begin
                clockstart = 1'b0;
                case (status)
                    3'b010: next_mode = purchasemode;
                    3'b100: next_mode = managermode;
                    default: next_mode = current_mode;
                endcase
            end
            purchasemode:
                begin
                    clockstart = 1'b1;
                    if (waiting_time < 30 && paid < paidinneed)
                        next_mode = current_mode;
                    else if (waiting_time >= 30)
                        next_mode = failpurchase;
                    else next_mode = completepurchase;
                end
            failpurchase:
                begin
                    clockstart = 1'b0;
                    case (status)
                        3'b001: next_mode = browsemode;//010
                        3'b100: next_mode = managermode;
                        default: next_mode = current_mode;
                    endcase
                end
            completepurchase: //010
                begin
                    clockstart = 1'b0;
                    case (status)
                        3'b001: next_mode = browsemode;
                        3'b100: next_mode = managermode;
                        default: next_mode = current_mode;
                    endcase
                end
            managermode: //100
                if (chooseroot == 2'b01)

                    next_mode = rootbrowse;
                else if (chooseroot == 2'b10)
                    next_mode = rootadd;
                else if (chooseroot == 2'b00)
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
                else if (chooseroot == 2'b11)
                    next_mode = allinall;
                else if (chooseroot == 2'b01)
                    begin
                        next_mode = current_mode;
                    end
            allinall:
                if (chooseroot == 2'b00)
                    next_mode = managermode;
                else if (chooseroot == 2'b10)
                    next_mode = rootadd;
                else if (chooseroot == 2'b01)
                    next_mode = rootbrowse;
                else if (chooseroot == 2'b11)
                    begin
                        next_mode = current_mode;

                    end
            rootadd:
                if (chooseroot == 2'b01)

                    next_mode = rootbrowse;
                else if (chooseroot == 2'b00)
                    next_mode = managermode;
                else if (chooseroot == 2'b10)
                    begin
                        next_mode = current_mode;

                    end

        endcase
    always @* begin //todo
        case (current_mode)
            resetmode:
                begin
                    charge = 5'b0;
                    income = 10'b0;
                    sold_numbers = 45'b0;
                end

            browsemode:
                case ({channel, goods})

                    6'b001001:
                        paidinneed = select_number*price1;

                    6'b001010:
                        paidinneed = select_number*price2;

                    6'b001100:
                        paidinneed = select_number*price3;

                    6'b010001:
                        paidinneed = select_number*price4;

                    6'b010010:
                        paidinneed = select_number*price5;

                    6'b010100:
                        paidinneed = select_number*price6;

                    6'b100001:
                        paidinneed = select_number*price7;

                    6'b100010:
                        paidinneed = select_number*price8;

                    6'b100100:
                        paidinneed = select_number*price9;

                endcase
            failpurchase:

                    charge = paid;

        endcase

    end
    //

    always @(posedge keyboard_en, negedge reset, posedge current_mode[3:3])
        if (current_mode[3:3] == 1'b1) paid = 0;
        else begin
            if (keyboard_en == 1'b1)
                begin
                    if (current_mode == rootadd)

                        case ({channel, goods})
                            6'b001001:

                                if (current_numbers[4:0]+keyboard < maxnum) warning1 = 1'b1;//todo 判断warning何时消失
                                else current_numbers[4:0] = current_numbers[4:0]+keyboard;

                            6'b001010:

                                if (current_numbers[9:5]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[9:5] = current_numbers[9:5]+keyboard;
                            6'b001100:
                                if (current_numbers[14:10]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[14:10] = current_numbers[14:10]+keyboard;

                            6'b010001:
                                if (current_numbers[19:15]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[19:15] = current_numbers[19:15]+keyboard;

                            6'b010010:
                                if (current_numbers[24:20]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[24:20] = current_numbers[24:20]+keyboard;

                            6'b010100:
                                if (current_numbers[29:25]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[29:25] = current_numbers[29:25]+keyboard;

                            6'b100001:
                                if (current_numbers[34:30]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[34:30] = current_numbers[34:30]+keyboard;

                            6'b100010:
                                if (current_numbers[39:35]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[39:35] = current_numbers[39:35]+keyboard;

                            6'b100100:
                                if (current_numbers[44:40]+keyboard < maxnum) warning1 = 1'b1;//补多了
                                else current_numbers[44:40] = current_numbers[44:40]+keyboard;

                        endcase

                    else if (current_mode == purchasemode)

                            paid = paid+keyboard;

                end
            else if (current_mode == resetmode)
                begin
                    if (current_mode == rootadd)
                        begin
                            current_numbers = 45'b0;
                            warning1 = 1'b0;
                        end
                    else if (current_mode == purchasemode) paid = 6'b0;
                end
        end

endmodule
