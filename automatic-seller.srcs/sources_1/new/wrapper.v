`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/12 01:35:27
// Design Name: 
// Module Name: wrapper
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

//外壳，最外层模块
//负责组织所有的输入输出接口，以及内部各模块之间的连接
//输入输出直接对应开发板的引脚
module wrapper(
    input test1,
    output test2
);
    assign test2 = ~test1;
endmodule : wrapper
