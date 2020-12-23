`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/19 18:26:35
// Design Name:
// Module Name: tube_display
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


module tube_display(
    input rst,//reset
    input clk,
    input [2:0] channel,
    input [2:0] goods_in,
    input [44:0] current_numbers,
    input [4:0] waiting_time,
    input [44:0] max_supplement,
    input [44:0] sold_numbers,
    input [7:0] current_mode,
    input [9:0] income,
    input [5:0] charge,
    input [5:0] inneedpaid,
    input [5:0] paid,//2^6 = 128
    output [7:0] DIG,//bit selection
    output [7:0] Y //seg selection
);
    reg [2:0] goods;
    reg clkout;
    reg [31:0] cnt;
    parameter period=200000;//500HZ stable
    parameter roll_period=200000000; // 4s
    parameter twenkle_period=2500000;//twenkle
    always @(posedge clk or negedge rst) // frequency division : clk -> clkout
        begin
            if (!rst) begin
                cnt <= 0;
                clkout <= 0;
            end
            else begin
                if (cnt == (period >> 1)-1)
                    begin
                        clkout <= ~clkout;
                        cnt <= 0;
                    end
                else
                    cnt <= cnt+1;
            end
        end


    parameter resetmode=8'b00000000;
    parameter browsemode=8'b00000001;
    parameter purchasemode=8'b00000010;
    parameter completepurchase=8'b00000100;
    parameter failpurchase=8'b00001000;
    parameter managermode=8'b00010000;
    parameter rootbrowse=8'b00100000;
    parameter rootadd=8'b01000000;
    parameter allinall=8'b10000000;


    reg [6:0] Y_r;
    reg [7:0] DIG_r;
    assign Y = {1'b1, (~Y_r[6:0])};//dot never light
    assign DIG = ~DIG_r;

    reg [2:0] scan_cnt;
    reg [2:0] tube_cnt;

    always @(posedge clkout or negedge rst) // change scan_cnt based on clkout
        begin
            if (~rst) begin
                scan_cnt <= 0;
                tube_cnt <= 0;
            end
            else begin
                tube_cnt <= tube_cnt+1;
                scan_cnt <= scan_cnt+1;
                if (scan_cnt == 3'd7) begin
                    tube_cnt <= 0;
                    scan_cnt <= 0;
                end
            end
        end
    always @(scan_cnt)//select tube
        begin
            case (scan_cnt)
                0: DIG_r = 8'b0000_0001;
                1: DIG_r = 8'b0000_0010;
                2: DIG_r = 8'b0000_0100;
                3: DIG_r = 8'b0000_1000;
                4: DIG_r = 8'b0001_0000;
                5: DIG_r = 8'b0010_0000;
                6: DIG_r = 8'b0100_0000;
                7: DIG_r = 8'b1000_0000;
            endcase
        end

    parameter zero=7'b0111111;//0
    parameter one=7'b0000110;//1
    parameter two=7'b1011011;//2
    parameter three=7'b1001111;//3
    parameter four=7'b1100110;//4
    parameter five=7'b1101101;//5
    parameter six=7'b1111101;//6
    parameter seven=7'b0100111;//7
    parameter eight=7'b1111111;//8
    parameter nine=7'b1100111;//9
    parameter A=7'b1110111;//A
    parameter b=7'b1111100;//b
    parameter C=7'b0111001;//c
    parameter d=7'b1011110;//d
    parameter E=7'b1111001;//E
    parameter F=7'b1110001;//F
    parameter G=7'b0111101;//G
    parameter J=7'b0001110;//J
    parameter H=7'b0110110;//H
    parameter none=7'b0000000;//����
    parameter price1=1;
    parameter price2=2;
    parameter price3=3;
    parameter price4=5;
    parameter price5=7;
    parameter price6=8;
    parameter price7=13;
    parameter price8=14;
    parameter price9=15;


    reg [4:0] display_time;
    always @(waiting_time)
        display_time = 30-waiting_time;
    reg [3:0] price;
    always @(*)
        case ({channel, goods_in})
            6'b001_001: price = price1;
            6'b001_010: price = price2;
            6'b001_100: price = price3;
            6'b010_001: price = price4;
            6'b010_010: price = price5;
            6'b010_100: price = price6;
            6'b100_001: price = price7;
            6'b100_010: price = price8;
            6'b100_100: price = price9;
            default: price = 4;
        endcase
    reg [4:0] numbers;
    //ѡ���Ӧ����Ʒʣ����
    always @(*)
        case ({channel, goods_in})
            6'b001_001: numbers = current_numbers[4:0];
            6'b001_010: numbers = current_numbers[9:5];
            6'b001_100: numbers = current_numbers[14:10];
            6'b010_001: numbers = current_numbers[19:15];
            6'b010_010: numbers = current_numbers[24:20];
            6'b010_100: numbers = current_numbers[29:25];
            6'b100_001: numbers = current_numbers[34:30];
            6'b100_010: numbers = current_numbers[39:30];
            6'b100_100: numbers = current_numbers[44:40];
            default: numbers = 9;
        endcase
    reg [4:0] sold_num;
    always @(*)
        case ({channel, goods_in})
            6'b001_001: sold_num = sold_numbers[4:0];
            6'b001_010: sold_num = sold_numbers[9:5];
            6'b001_100: sold_num = sold_numbers[14:10];
            6'b010_001: sold_num = sold_numbers[19:15];
            6'b010_010: sold_num = sold_numbers[24:20];
            6'b010_100: sold_num = sold_numbers[29:25];
            6'b100_001: sold_num = sold_numbers[34:30];
            6'b100_010: sold_num = sold_numbers[39:30];
            6'b100_100: sold_num = sold_numbers[44:40];
            default: sold_num = 9;
        endcase
    wire roll_clk;
    frequency_divider#(.period(1000)) roll_clk_out(clkout, rst, roll_clk);
    wire twenkle;
    frequency_divider#(.period(twenkle_period)) twenkler(clk, rst, twenkle);
    always @(posedge roll_clk or negedge rst)
        if (!rst && current_mode == browsemode && goods_in == 3'b000) begin
            goods <= 3'b001;
        end
        else if (rst && current_mode == browsemode && goods_in == 3'b000) begin
            case (goods)
                3'b001: goods <= 3'b010;
                3'b010: goods <= 3'b100;
                3'b100: goods <= 3'b001;
                3'b000: goods <= 3'b001;
            endcase
        end
        else
            goods <= goods_in;

    reg [3:0] price_roll;
    always @(*)
        case ({channel, goods})
            6'b001_001: price_roll = price1;
            6'b001_010: price_roll = price2;
            6'b001_100: price_roll = price3;
            6'b010_001: price_roll = price4;
            6'b010_010: price_roll = price5;
            6'b010_100: price_roll = price6;
            6'b100_001: price_roll = price7;
            6'b100_010: price_roll = price8;
            6'b100_100: price_roll = price9;
            default: price_roll = 4;
        endcase
    reg [4:0] numbers_roll;
    //ѡ���Ӧ����Ʒʣ����
    always @(*)
        case ({channel, goods})
            6'b001_001: numbers_roll = current_numbers[4:0];
            6'b001_010: numbers_roll = current_numbers[9:5];
            6'b001_100: numbers_roll = current_numbers[14:10];
            6'b010_001: numbers_roll = current_numbers[19:15];
            6'b010_010: numbers_roll = current_numbers[24:20];
            6'b010_100: numbers_roll = current_numbers[29:25];
            6'b100_001: numbers_roll = current_numbers[34:30];
            6'b100_010: numbers_roll = current_numbers[39:30];
            6'b100_100: numbers_roll = current_numbers[44:40];
            default: numbers_roll = 9;
        endcase

    always @(tube_cnt)
        case (current_mode)
            browsemode: //��ʾ�����š���Ʒ���ơ���Ʒʣ��������Ʒ���
                if (goods_in == 3'b000) begin
                    case (tube_cnt)
                        7: case (channel)
                            3'b001: Y_r = one;//1
                            3'b010: Y_r = two;//2
                            3'b100: Y_r = three;//3
                            default: Y_r = none;
                        endcase
                        5: case ({channel, goods})
                            6'b001001: Y_r = A;//A
                            6'b001010: Y_r = b;//b
                            6'b001100: Y_r = C;//c
                            6'b010001: Y_r = d;//d
                            6'b010010: Y_r = E;//E
                            6'b010100: Y_r = F;//F
                            6'b100001: Y_r = G;//G
                            6'b100010: Y_r = H;//H
                            6'b100100: Y_r = J;//J
                            default: Y_r = none;
                        endcase
                        3: case (numbers_roll)
                            0: begin
                                if (twenkle == 0) Y_r = zero;//0
                                else Y_r = none;
                            end
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            default: Y_r = none;
                        endcase
                        1: case (price_roll)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            //4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                            10: Y_r = A;//A
                            11: Y_r = b;//b
                            12: Y_r = C;//c
                            13: Y_r = d;//d
                            14: Y_r = E;//E
                            15: Y_r = F;//F
                            default: Y_r = none;
                        endcase
                        default: Y_r = none;
                    endcase
                end
                else
                    case (tube_cnt)
                        7: case (channel)
                            3'b001: Y_r = one;//1
                            3'b010: Y_r = two;//2
                            3'b100: Y_r = three;//3
                            default: Y_r = none;
                        endcase
                        5: case ({channel, goods_in})
                            6'b001001: Y_r = A;//A
                            6'b001010: Y_r = b;//b
                            6'b001100: Y_r = C;//c
                            6'b010001: Y_r = d;//d
                            6'b010010: Y_r = E;//E
                            6'b010100: Y_r = F;//F
                            6'b100001: Y_r = G;//G
                            6'b100010: Y_r = H;//H
                            6'b100100: Y_r = J;//J
                            default: Y_r = none;
                        endcase
                        3: case (numbers)
                            0: begin
                                if (twenkle == 0) Y_r = zero;//0
                                else Y_r = none;
                            end
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            default: Y_r = none;
                        endcase
                        1: case (price)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            //4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                            10: Y_r = A;//A
                            11: Y_r = b;//b
                            12: Y_r = C;//c
                            13: Y_r = d;//d
                            14: Y_r = E;//E
                            15: Y_r = F;//F
                            default: Y_r = none;
                        endcase
                        default: Y_r = none;
                    endcase
            purchasemode:
                case (tube_cnt)
                    7:
                        begin
                            case (display_time/10)
                                0: Y_r = zero;//0
                                1: Y_r = one;//1
                                2: Y_r = two;//2
                                3: Y_r = three;//3
                            endcase
                        end
                    6:
                        begin
                            case (display_time%10)
                                0: Y_r = zero;//0
                                1: Y_r = one;//1
                                2: Y_r = two;//2
                                3: Y_r = three;//3
                                4: Y_r = four;//4
                                5: Y_r = five;//5
                                6: Y_r = six;//6
                                7: Y_r = seven;//7
                                8: Y_r = eight;//8
                                9: Y_r = nine;//9
                            endcase
                        end
                    4:
                        case (paid/10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    3:
                        case (paid%10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    1:
                        case (inneedpaid/10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            //4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                            10: Y_r = A;//A
                            11: Y_r = b;//b
                            12: Y_r = C;//c
                            13: Y_r = d;//d
                            14: Y_r = E;//E
                            15: Y_r = F;//F
                            default: Y_r = none;
                        endcase
                    0:
                        case (inneedpaid%10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            //4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                            10: Y_r = A;//A
                            11: Y_r = b;//b
                            12: Y_r = C;//c
                            13: Y_r = d;//d
                            14: Y_r = E;//E
                            15: Y_r = F;//F
                            default: Y_r = none;
                        endcase
                    default: Y_r = none;
                endcase
            failpurchase:
                case (tube_cnt)
                    7: Y_r = F;
                    1:
                        case (charge/10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    0:
                        case (charge%10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    default: Y_r = none;
                endcase
            completepurchase:
                case (tube_cnt)
                    7: Y_r = A;
                    1:
                        case (charge/10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    0:
                        case (charge%10)
                            0: Y_r = zero;//0
                            1: Y_r = one;//1
                            2: Y_r = two;//2
                            3: Y_r = three;//3
                            4: Y_r = four;//4
                            5: Y_r = five;//5
                            6: Y_r = six;//6
                            7: Y_r = seven;//7
                            8: Y_r = eight;//8
                            9: Y_r = nine;//9
                        endcase
                    default: Y_r = none;
                endcase
            rootadd: //显示最大可补数量
                case (tube_cnt)
                    7: case (channel)
                        3'b001: Y_r = one;//1
                        3'b010: Y_r = two;//2
                        3'b100: Y_r = three;//3
                        default: Y_r = none;
                    endcase
                    5: case ({channel, goods})
                        6'b001001: Y_r = A;//A
                        6'b001010: Y_r = b;//b
                        6'b001100: Y_r = C;//c
                        6'b010001: Y_r = d;//d
                        6'b010010: Y_r = E;//E
                        6'b010100: Y_r = F;//F
                        6'b100001: Y_r = G;//G
                        6'b100010: Y_r = H;//H
                        6'b100100: Y_r = J;//J
                        default: Y_r = none;
                    endcase
                    0: case (8-numbers)
                        0: Y_r = zero;//0
                        1: Y_r = one;//1
                        2: Y_r = two;//2
                        3: Y_r = three;//3
                        4: Y_r = four;//4
                        5: Y_r = five;//5
                        6: Y_r = six;//6
                        7: Y_r = seven;//7
                        8: Y_r = eight;//8
                        default: Y_r = none;
                    endcase
                    default: Y_r = none;
                endcase
            rootbrowse: //查看售出数量
                case (tube_cnt)
                    7: case (channel)
                        3'b001: Y_r = one;//1
                        3'b010: Y_r = two;//2
                        3'b100: Y_r = three;//3
                        default: Y_r = none;
                    endcase
                    5: case ({channel, goods})
                        6'b001001: Y_r = A;//A
                        6'b001010: Y_r = b;//b
                        6'b001100: Y_r = C;//c
                        6'b010001: Y_r = d;//d
                        6'b010010: Y_r = E;//E
                        6'b010100: Y_r = F;//F
                        6'b100001: Y_r = G;//G
                        6'b100010: Y_r = H;//H
                        6'b100100: Y_r = J;//J
                        default: Y_r = none;
                    endcase
                    3: case (sold_num/10)
                        1: Y_r = one;
                        default: Y_r = none;
                    endcase
                    2: case (sold_num%10)
                        0: Y_r = zero;//0
                        1: Y_r = one;//1
                        2: Y_r = two;//2
                        3: Y_r = three;//3
                        4: Y_r = four;//4
                        5: Y_r = five;//5
                        6: Y_r = six;//6
                        7: Y_r = seven;//7
                        8: Y_r = eight;//8
                        default: Y_r = none;
                    endcase
                    default: Y_r = none;
                endcase
            allinall:
                case (tube_cnt)
                    7: Y_r = 7'b1001001;
                    2: case (income/100)
                        0: Y_r = zero;//0
                        1: Y_r = one;//1
                        2: Y_r = two;//2
                        3: Y_r = three;//3
                        4: Y_r = four;//4
                        5: Y_r = five;//5
                        6: Y_r = six;//6
                        7: Y_r = seven;//7
                        8: Y_r = eight;//8
                        9: Y_r = nine;//9
                    endcase
                    1: case (((income-(income/100)*100))/10)
                        0: Y_r = zero;//0
                        1: Y_r = one;//1
                        2: Y_r = two;//2
                        3: Y_r = three;//3
                        4: Y_r = four;//4
                        5: Y_r = five;//5
                        6: Y_r = six;//6
                        7: Y_r = seven;//7
                        8: Y_r = eight;//8
                        9: Y_r = nine;//9
                    endcase
                    0: case (((income-(income/100)*100))%10)
                        0: Y_r = zero;//0
                        1: Y_r = one;//1
                        2: Y_r = two;//2
                        3: Y_r = three;//3
                        4: Y_r = four;//4
                        5: Y_r = five;//5
                        6: Y_r = six;//6
                        7: Y_r = seven;//7
                        8: Y_r = eight;//8
                        9: Y_r = nine;//9
                    endcase
                    default: Y_r = none;
                endcase
            default: Y_r = none;
        endcase

endmodule: tube_display
