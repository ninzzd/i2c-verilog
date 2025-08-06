`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 05:10:27 PM
// Design Name: 
// Module Name: i2c_smss_tb
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

`timescale 1 ns / 1 ps
module i2c_smss_tb(

    );
    wire [7:0] s_received_data;
    reg [6:0] m_slave_addr;
    reg [7:0] m_data_to_send;
    reg m_rw;
    reg m_start;
    reg m_clk;
    wire [8:0] m_received_data;
    tri1 SCL;
    tri1 SDA;
    i2c_master uut_m(.SCL(SCL),.SDA(SDA),.slave_addr(m_slave_addr),.data_to_send(m_data_to_send),.rw(m_rw),.clk(m_clk),.start(m_start));
    i2c_slave uut_s(.SCL(SCL),.SDA(SDA),.received_data(s_received_data));
    
    assign SCL = 1'bz;
    assign SDA = 1'bz;
    always #5 m_clk <= ~m_clk;
    initial
    begin
        m_clk <= 0;
        
        // Master to Slave Data Transfer
//        #10
//        m_slave_addr <= 7'b0000001;
//        m_rw <= 0;
//        m_data_to_send <= 8'b01001110;

        //Slave to Master Data Transfer
        #10
        m_slave_addr <= 7'b0000001;
        m_rw <= 1;
        
        // Common start signal pulse to master
        m_start <= 1;
        #5
        m_start <= 0;
    end
endmodule
