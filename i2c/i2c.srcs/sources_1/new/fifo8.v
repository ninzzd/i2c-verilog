`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2025 11:36:50 PM
// Design Name: 
// Module Name: fifo8
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

parameter N = 1024;
parameter Clen = $clog2(N);
module fifo8( // Circular FIFO
        input wr_en,
        input rd_en,
        input wr_clk,
        input rd_clk,
        input [7:0] wr,
        output reg [7:0] rd,
        output reg empty,
        output reg full
    );
    reg [7:0] RAM [0:N-1];
    reg [Clen-1:0] wr_ptr;
    reg [Clen-1:0] rd_ptr;
    initial 
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        empty <= 1'b1;
        full <= 1'b0;
    end
    always @(posedge wr_clk)
    begin
        if(wr_en & ~full)
        begin
            RAM[wr_ptr] <= wr;
            wr_ptr = wr_ptr + 1;
            if(rd_ptr - wr_ptr == 1 || (wr_ptr == N-1 && rd_ptr == 0))
                full <= 1'b1;
            if(empty)
                empty <= 1'b0;
        end
    end
    always @(posedge rd_clk)
    begin
        if(rd_en & ~empty)
        begin
            rd <= RAM[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            if(wr_ptr - rd_ptr == 1 || (rd_ptr == N-1 && wr_ptr == 0))
                empty <= 1'b1;
            if(full)
                full <= 1'b0; 
        end
    end
endmodule
