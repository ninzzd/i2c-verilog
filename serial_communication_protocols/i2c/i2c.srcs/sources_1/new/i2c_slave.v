`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 02:58:48 PM
// Design Name: 
// Module Name: i2c_slave
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


module i2c_slave(
        output reg[7:0] received_data,
        inout SDA,
        inout SCL
    );
    wire [6:0] self_addr;
    reg [3:0] state;
    assign self_addr = 7'b0000001;
    initial
    begin
        state <= 0;
    end
    always @(*)
    begin
    
    end 
    
endmodule
