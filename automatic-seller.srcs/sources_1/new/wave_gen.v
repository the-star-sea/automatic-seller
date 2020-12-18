`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 08:56:40
// Design Name: 
// Module Name: wave_gen
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


module wave_gen(
  input  buzzer_en,
  input   wire            clk,
  input   wire            rst_n,
  input   wire  [31:0]    divnum,
  output  reg             beep
    );
    reg           [31:0]    cnt;
      
      always @ (posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0 | buzzer_en == 1'b0)
          cnt <= 32'd0;
        else
          if (cnt < divnum - 1'b1)
            cnt <= cnt + 1'b1;
          else
            cnt <= 32'd0;
      end
      
      always @ (posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0 | buzzer_en == 1'b0)
          beep <= 1'b0;
        else
          if (cnt < divnum[31:1])
            beep <= 1'b0;
          else
            beep <= 1'b1;
        end
endmodule
