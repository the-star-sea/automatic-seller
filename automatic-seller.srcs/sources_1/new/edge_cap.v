`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 18:32:00
// Design Name: 
// Module Name: edge_cap
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


module edge_cap
    (
        input clk, rst_n,
        input pulse,
        output pos_edge,
        output neg_edge
    );
    reg pulse_r1, pulse_r2, pulse_r3;

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                pulse_r1 <= 1'b0;
                pulse_r2 <= 1'b0;
                pulse_r3 <= 1'b0;
            end
        else
            begin
                pulse_r1 <= pulse;
                pulse_r2 <= pulse_r1;
                pulse_r3 <= pulse_r2;
            end

    assign pos_edge = (pulse_r2 && ~pulse_r3) ? 1:0;
    assign neg_edge = (~pulse_r2 && pulse_r3) ? 1:0;
endmodule