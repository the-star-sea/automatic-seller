`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module keyboard(
    clk,             // 系统时钟
    rst_n,           // 系统复位信号
    key_out_y,       // 键盘输出管脚
    key_in_x,        // 键盘输入管脚
    key_value,       // 键盘输出按键值
    key_flag         // 键盘输出使能信号
);


    input clk;
    input rst_n;
    output reg [3:0] key_out_y;
    input [3:0] key_in_x;
    output reg [3:0] key_value;
    output reg key_flag;

    reg [19:0] count;

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