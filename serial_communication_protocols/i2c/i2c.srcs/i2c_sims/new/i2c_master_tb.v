`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ninaad Desai
// 
// Create Date: 07/21/2025 02:09:38 AM
// Design Name: 
// Module Name: i2c_master_tb
// Project Name: i2c
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

`timescale 1 ns / 1 ps
module i2c_master_tb(

    );
    reg dl;
    wire SDA;
    wire SCL;
    reg [6:0] slave_addr;
    reg [7:0] data_to_send;
    reg rw;
    reg start;
    reg clk;
    wire [8:0] received_data;
    /*
        input [6:0] slave_addr,
        input [7:0] data_to_send,
        input rw,
        input start,
        input clk,
        output reg [7:0] received_data,
        inout SDA,
        inout SCL
    */
    always #5 clk <= ~clk;
    assign SDA = (dl == 0? 1'b0 : 1'bz);
    assign SCL = 1'bz;
    i2c_master uut(.SDA(SDA),.SCL(SCL),.slave_addr(slave_addr),.data_to_send(data_to_send),.rw(rw),.clk(clk),.start(start));
    initial
    begin
        dl <= 1;
        clk <= 0;
        start <= 0;
        
        #10
        slave_addr <= 7'b0000001;
        rw <= 1'b0;
        data_to_send <= 8'b01000110;
        #10
        start <= 1;
        #10
        start <= 0;
    end
    initial
    begin
        // Simulating the address ACK bit from the slave
        #190
        dl <= 0;
        #20
        dl <= 1;
        
        // Simulating the data ACK bit from the slave
        #160
        dl <= 0;
        #20
        dl <= 1;
    end
endmodule
