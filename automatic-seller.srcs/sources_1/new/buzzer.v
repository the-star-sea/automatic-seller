`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 08:31:06
// Design Name: 
// Module Name: buzzer
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


module buzzer(
    input wire clk,
    input wire rst_n,
    input wire [5:0] cnt,
    input buzeer_en,
    output wire beep
);

    wire [4:0] music;
    wire [31:0] divnum;

    music_mem music_mem_inst(
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt),
        .music(music)
    );

    cal_divnum cal_divnum_inst(

        .clk(clk),
        .rst_n(rst_n),
        .music(music),
        .divnum(divnum)
    );
    wave_gen wave_gen_inst(
        .buzzer_en(buzeer_en),
        .clk(clk),
        .rst_n(rst_n),
        .divnum(divnum),
        .beep(beep)
    );
endmodule
