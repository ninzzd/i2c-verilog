`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2025 06:21:30 AM
// Design Name: 
// Module Name: sda_driver
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


module sda_driver(
        input en,
        input clk,
        input data,
        output SDA
    );
    wire en_;
    wire sel;
    assign sel = en & clk;
    assign en_ = (sel == 1'b1 ? data : 1'b1);
    bufif0 buff(SDA,data,en_); // Vivado implements an extra 2:1 mux to implement a NOT gate to complement the enable signal of the buffer. 
                               // Reason: The netlist tool is only able to use an active-high tristate buffer  
endmodule
