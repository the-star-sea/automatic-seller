`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 22:29:06
// Design Name: 
// Module Name: frequency_divider
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


module frequency_divider
    #(parameter period)(
    input clk,//系统时钟
    input rst,//复位信号
    output reg clkout//输出频率
);

    reg[31:0]cnt;

    always @(posedge clk or negedge rst)
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
endmodule : frequency_divider
