`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module keyboard(
    clk,             // 寮?鍙戞澘涓婅緭鍏ユ椂閽?: 50Mhz
    rst_n,           // 寮?鍙戞澘涓婂浣嶆寜閿?
    key_out_y,       // 杈撳叆鐭╅樀閿洏鐨勫垪淇″彿(KEY0~KEY3)
    key_in_x,        // 杈撳嚭鐭╅樀閿洏鐨勮淇″彿(KEY4~KEY7)
    key_value,
    key_flag
);

//========================================================
// PORT declarations
//========================================================
    input clk;
    input rst_n;
    output reg [3:0] key_out_y;
    input [3:0] key_in_x;
    output reg [3:0] key_value;
    output reg key_flag;

//瀵勫瓨鍣ㄥ畾涔?
    reg [19:0] count;

//==============================================
// 杈撳嚭鐭╅樀閿洏鐨勮淇″彿锛?20ms鎵弿鐭╅樀閿洏涓?娆?,閲囨牱棰戠巼灏忎簬鎸夐敭姣涘埡棰戠巼锛岀浉褰撲簬婊ら櫎鎺変簡楂橀姣涘埡淇″彿銆?
//==============================================
    always @(posedge clk or negedge rst_n) begin//妫?娴嬫椂閽熺殑涓婂崌娌垮拰澶嶄綅鐨勪笅闄嶆部
        if (!rst_n) begin               //澶嶄綅淇″彿浣庢湁鏁?
            count <= 20'd0;        //璁℃暟鍣ㄦ竻0
            key_out_y <= 4'b1111;
        end
        else begin
            if (count == 20'd0) begin          //0ms鎵弿绗竴鍒楃煩闃甸敭鐩?
                key_out_y <= 4'b1110;      //寮?濮嬫壂鎻忕涓?鍒楃煩闃甸敭鐩?,绗竴鍒楄緭鍑?0
                count <= count+20'b1; //璁℃暟鍣ㄥ姞1
            end
            else if (count == 20'd249_999) begin //5ms鎵弿绗簩鍒楃煩闃甸敭鐩?,5ms璁℃暟(50M/200-1=249_999)
                key_out_y <= 4'b1101;   //寮?濮嬫壂鎻忕浜屽垪鐭╅樀閿洏,绗簩鍒楄緭鍑?0
                count <= count+20'b1; //璁℃暟鍣ㄥ姞1
            end
            else if (count == 20'd499_999) begin   //10ms鎵弿绗笁鍒楃煩闃甸敭鐩?,10ms璁℃暟(50M/100-1=499_999)
                key_out_y <= 4'b1011;   //鎵弿绗笁鍒楃煩闃甸敭鐩?,绗笁鍒楄緭鍑?0
                count <= count+20'b1; //璁℃暟鍣ㄥ姞1
            end
            else if (count == 20'd749_999) begin   //15ms鎵弿绗洓鍒楃煩闃甸敭鐩?,15ms璁℃暟(50M/67.7-1=749_999)
                key_out_y <= 4'b0111;   //鎵弿绗洓鍒楃煩闃甸敭鐩?,绗洓鍒楄緭鍑?0
                count <= count+20'b1; //璁℃暟鍣ㄥ姞1
            end
            else if (count == 20'd999_999) begin  //20ms璁℃暟(50M/50-1=999_999)
                count <= 0;             //璁℃暟鍣ㄤ负0
            end
            else
                count <= count+20'b1;    //璁℃暟鍣ㄥ姞1

        end
    end
//====================================================
// 閲囨牱琛岀殑鎸夐敭淇″彿
//====================================================
    reg [3:0] key_h1_scan;    //绗竴琛屾寜閿壂鎻忓?糑EY
    reg [3:0] key_h1_scan_r;  //绗竴琛屾寜閿壂鎻忓?煎瘎瀛樺櫒KEY
    reg [3:0] key_h2_scan;    //绗簩琛屾寜閿壂鎻忓?糑EY
    reg [3:0] key_h2_scan_r;  //绗簩琛屾寜閿壂鎻忓?煎瘎瀛樺櫒KEY
    reg [3:0] key_h3_scan;    //绗笁琛屾寜閿壂鎻忓?糑EY
    reg [3:0] key_h3_scan_r;  //绗笁琛屾寜閿壂鎻忓?煎瘎瀛樺櫒KEY
    reg [3:0] key_h4_scan;    //绗洓琛屾寜閿壂鎻忓?糑EY
    reg [3:0] key_h4_scan_r;  //绗洓琛屾寜閿壂鎻忓?煎瘎瀛樺櫒KEY
    always @(posedge clk)
        begin
            if (!rst_n) begin               //澶嶄綅淇″彿浣庢湁鏁?
                key_h1_scan <= 4'b1111;
                key_h2_scan <= 4'b1111;
                key_h3_scan <= 4'b1111;
                key_h4_scan <= 4'b1111;
            end
            else begin
                if (count == 20'd124_999)           //2.5ms鎵弿绗竴琛岀煩闃甸敭鐩樺??
                    key_h1_scan <= key_in_x;         //鎵弿绗竴琛岀殑鐭╅樀閿洏鍊?
                else if (count == 20'd374_999)      //7.5ms鎵弿绗簩琛岀煩闃甸敭鐩樺??
                    key_h2_scan <= key_in_x;         //鎵弿绗簩琛岀殑鐭╅樀閿洏鍊?
                else if (count == 20'd624_999)      //12.5ms鎵弿绗笁琛岀煩闃甸敭鐩樺??
                    key_h3_scan <= key_in_x;         //鎵弿绗笁琛岀殑鐭╅樀閿洏鍊?
                else if (count == 20'd874_999)      //17.5ms鎵弿绗洓琛岀煩闃甸敭鐩樺??
                    key_h4_scan <= key_in_x;         //鎵弿绗洓琛岀殑鐭╅樀閿洏鍊?
            end
        end

//====================================================
// 鎸夐敭淇″彿閿佸瓨涓?涓椂閽熻妭鎷?
//====================================================
    always @(posedge clk)
        begin
            key_h1_scan_r <= key_h1_scan;
            key_h2_scan_r <= key_h2_scan;
            key_h3_scan_r <= key_h3_scan;
            key_h4_scan_r <= key_h4_scan;
        end

    wire [3:0] flag_h1_key = key_h1_scan_r[3:0] & (~key_h1_scan[3:0]);  //褰撴娴嬪埌鎸夐敭鏈変笅闄嶆部鍙樺寲鏃讹紝浠ｈ〃璇ユ寜閿鎸変笅锛屾寜閿湁鏁?
    wire [3:0] flag_h2_key = key_h2_scan_r[3:0] & (~key_h2_scan[3:0]);  //褰撴娴嬪埌鎸夐敭鏈変笅闄嶆部鍙樺寲鏃讹紝浠ｈ〃璇ユ寜閿鎸変笅锛屾寜閿湁鏁?
    wire [3:0] flag_h3_key = key_h3_scan_r[3:0] & (~key_h3_scan[3:0]);  //褰撴娴嬪埌鎸夐敭鏈変笅闄嶆部鍙樺寲鏃讹紝浠ｈ〃璇ユ寜閿鎸変笅锛屾寜閿湁鏁?
    wire [3:0] flag_h4_key = key_h4_scan_r[3:0] & (~key_h4_scan[3:0]);  //褰撴娴嬪埌鎸夐敭鏈変笅闄嶆部鍙樺寲鏃讹紝浠ｈ〃璇ユ寜閿鎸変笅锛屾寜閿湁鏁?

//=====================================================
// LED鐏帶鍒?,鎸夐敭鎸変笅鏃?,鐩稿叧鐨凩ED杈撳嚭缈昏浆
//=====================================================
    reg [15:0] temp_led;
    always @(posedge clk or negedge rst_n)      //妫?娴嬫椂閽熺殑涓婂崌娌垮拰澶嶄綅鐨勪笅闄嶆部
        begin
            if (!rst_n) begin                 //澶嶄綅淇″彿浣庢湁鏁?
                key_value <= 4'd0;     //LED鐏帶鍒朵俊鍙疯緭鍑轰负浣?, LED鐏叏鐏?
                key_flag <= 1'b0;
            end
            else
                begin
                    if (flag_h1_key[0]) begin key_value <= 4'hA; key_flag <= 1'b1; end//
                    else if (flag_h1_key[1]) begin key_value <= 4'h5; key_flag <= 1'b1; end//
                    else if (flag_h1_key[2]) begin key_value <= 4'h2; key_flag <= 1'b1; end//
                    else if (flag_h1_key[3]) begin key_value <= 4'h1; key_flag <= 1'b1; end//

                    else if (flag_h2_key[0]) begin key_value <= 4'hF; key_flag <= 1'b1; end//
                    else if (flag_h2_key[1]) begin key_value <= 4'h9; key_flag <= 1'b1; end//
                    else if (flag_h2_key[2]) begin key_value <= 4'h6; key_flag <= 1'b1; end//
                    else if (flag_h2_key[3]) begin key_value <= 4'h3; key_flag <= 1'b1; end//

                    else if (flag_h3_key[0]) begin key_value <= 4'h0; key_flag <= 1'b1; end//
                    else if (flag_h3_key[1]) begin key_value <= 4'h8; key_flag <= 1'b1; end//
                    else if (flag_h3_key[2]) begin key_value <= 4'h5; key_flag <= 1'b1; end//
                    else if (flag_h3_key[3]) begin key_value <= 4'h2; key_flag <= 1'b1; end//

                    else if (flag_h4_key[0]) begin key_value <= 4'hE; key_flag <= 1'b1; end//
                    else if (flag_h4_key[1]) begin key_value <= 4'h7; key_flag <= 1'b1; end//
                    else if (flag_h4_key[2]) begin key_value <= 4'h4; key_flag <= 1'b1; end//
                    else if (flag_h4_key[3]) begin key_value <= 4'h1; key_flag <= 1'b1; end//
                    else begin key_value <= 4'd0; key_flag <= 1'b0; end
                end
        end

endmodule

/*module keyboard(
    input clk,
    input reset,
    input [3:0] keyboard_in, //keyboard_row
    output reg [3:0] keyboard_col, //keyboard_column
    output reg [3:0] keyboard_out, //keyboard_value
    output keyboard_en//闃叉姈涓婂崌娌?
);

    //闃叉姈
    reg pre_keyboard_en;
    wire clk_temp;
    frequency_divider #(.period(5000000)) frequency_divider_keyboard_shake(.clk(clk),.rst(reset),
        .clkout(clk_temp));
    edge_cap edge_cap(.clk(clk_temp), .rst_n(reset), .pulse(pre_keyboard_en),
        .pos_edge(keyboard_en));

//
    //frequency divider
    reg [19:0] cnt;
    always @(posedge clk, negedge reset)
        if (~reset) cnt <= 0;
        else cnt <= cnt+1'b1;
    wire key_clk = cnt[19];  // (2^20/50M = 21)ms


    //FSA one hot code
    parameter NO_KEY_PRESSED=6'b000_001;  // 娌℃湁鎸夐敭鎸変笅
    parameter SCAN_COL0=6'b000_010;  // 鎵弿绗?0鍒?
    parameter SCAN_COL1=6'b000_100;  // 鎵弿绗?1鍒?
    parameter SCAN_COL2=6'b001_000;  // 鎵弿绗?2鍒?
    parameter SCAN_COL3=6'b010_000;  // 鎵弿绗?3鍒?
    parameter KEY_PRESSED=6'b100_000;  // 鏈夋寜閿寜涓?

    reg [5:0] current_state, next_state; //鐜版?併?佹鎬?

    always @(posedge key_clk, negedge reset)
        if (~reset) current_state <= NO_KEY_PRESSED;
        else current_state <= next_state;
    //鏍规嵁鏉′欢杞Щ鐘舵??
    always @*
        case (current_state)
            NO_KEY_PRESSED:                    // 娌℃湁鎸夐敭鎸変笅
                if (keyboard_in != 4'hF)
                    next_state = SCAN_COL0;
                else
                    next_state = NO_KEY_PRESSED;
            SCAN_COL0:                         // 鎵弿绗?0鍒?
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL1;
            SCAN_COL1:                         // 鎵弿绗?1鍒?
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL2;
            SCAN_COL2:                         // 鎵弿绗?2鍒?
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = SCAN_COL3;
            SCAN_COL3:                         // 鎵弿绗?3鍒?
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = NO_KEY_PRESSED;
            KEY_PRESSED:                       // 鏈夋寜閿寜涓?
                if (keyboard_in != 4'hF)
                    next_state = KEY_PRESSED;
                else
                    next_state = NO_KEY_PRESSED;
        endcase

    reg key_pressed_flag;             // 閿洏鎸変笅鏍囧織
    reg [3:0] col_val, row_val;             // 鍒楀?笺?佽鍊?

    // 鏍规嵁娆℃?侊紝缁欑浉搴斿瘎瀛樺櫒璧嬪??
    always @(posedge key_clk, negedge reset)
        if (!reset)
            begin
                keyboard_col <= 4'h0;
                key_pressed_flag <= 0;
            end
        else
            case (next_state)
                NO_KEY_PRESSED:                  // 娌℃湁鎸夐敭鎸変笅
                    begin
                        pre_keyboard_en <= 0;
                        keyboard_col <= 4'h0;
                        key_pressed_flag <= 0;       // 娓呴敭鐩樻寜涓嬫爣蹇?
                    end
                SCAN_COL0:                       // 鎵弿绗?0鍒?
                    keyboard_col <= 4'b1110;
                SCAN_COL1:                       // 鎵弿绗?1鍒?
                    keyboard_col <= 4'b1101;
                SCAN_COL2:                       // 鎵弿绗?2鍒?
                    keyboard_col <= 4'b1011;
                SCAN_COL3:                       // 鎵弿绗?3鍒?
                    keyboard_col <= 4'b0111;
                KEY_PRESSED:                     // 鏈夋寜閿寜涓?
                    begin
                        pre_keyboard_en <= 1;
                        col_val <= keyboard_col;        // 閿佸瓨鍒楀??
                        row_val <= keyboard_in;        // 閿佸瓨琛屽??
                        key_pressed_flag <= 1;          // 缃敭鐩樻寜涓嬫爣蹇?
                    end
            endcase

    //鎵弿琛屽垪鍊?
    always @(posedge key_clk, negedge reset)
        if (!reset)
            keyboard_out <= 4'h0;
        else
            if (key_pressed_flag)
            case ({col_val, row_val})
                8'b1110_1110: keyboard_out <= 4'hD;//D
                8'b1110_1101: keyboard_out <= 4'hC;//C
                8'b1110_1011: keyboard_out <= 4'hB;//B
                8'b1110_0111: keyboard_out <= 4'hA;//A

                8'b1101_1110: keyboard_out <= 4'hF;//#
                8'b1101_1101: keyboard_out <= 4'h9;//9
                8'b1101_1011: keyboard_out <= 4'h6;//6
                8'b1101_0111: keyboard_out <= 4'h3;//3

                8'b1011_1110: keyboard_out <= 4'h0;//0
                8'b1011_1101: keyboard_out <= 4'h8;//8
                8'b1011_1011: keyboard_out <= 4'h5;//5
                8'b1011_0111: keyboard_out <= 4'h2;//2

                8'b0111_1110: keyboard_out <= 4'hE;//*
                8'b0111_1101: keyboard_out <= 4'h7;//7
                8'b0111_1011: keyboard_out <= 4'h4;//4
                8'b0111_0111: keyboard_out <= 4'h1;//1
            endcase
endmodule : keyboard*/
