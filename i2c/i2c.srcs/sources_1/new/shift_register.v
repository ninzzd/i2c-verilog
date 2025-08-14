`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2025 05:25:00 AM
// Design Name: Ninaad Desai
// Module Name: shift_register
// Project Name: i2c-verilog
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_register(
    input clk,
    input clk_inh,
    input [7:0] parallel_in,
    input l_r,
    input s_p,
    input serial_in,
    output [7:0] Q
    );
    wire clk_;
    reg [7:0] dff;
    assign clk_ = clk & clk_inh;
    always @(posedge clk_)
    begin
        if(s_p)
            dff <= parallel_in;
        else
        begin
            if(l_r)
            begin
                dff[7] <= serial_in;
                dff[6] <= dff[7];
                dff[5] <= dff[6];
                dff[4] <= dff[5];
                dff[3] <= dff[4];
                dff[2] <= dff[3];
                dff[1] <= dff[2];
                dff[0] <= dff[1];
            end
            else
            begin
                dff[0] <= serial_in;
                dff[1] <= dff[0];
                dff[2] <= dff[1];
                dff[3] <= dff[2];
                dff[4] <= dff[3];
                dff[5] <= dff[4];
                dff[6] <= dff[5];
                dff[7] <= dff[6];
            end
        end
    end
endmodule
