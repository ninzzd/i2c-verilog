`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2025 05:31:13 PM
// Design Name: 
// Module Name: i2c_master
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


module i2c_master(
    input [6:0] slave_addr,
    input [7:0] data_to_send,
    input rw,
    input start,
    input clk,
    output reg [7:0] received_data,
    inout SDA,
    inout SCL
    );
    reg[4:0] state;
    reg[7:0] data;
    reg[6:0] slave_address;
    reg counter;
    reg dl;
    reg cl;
    reg on;
    reg r_w;
    initial
    begin
        state = 0;
        cl = 1;
        dl = 1;
        counter = 0;
    end  
    always @(negedge clk)
    begin
        case(state)
            4'b0000:
            begin
                if(start == 1)
                begin
                    state <= 4'b0001;
                    if(rw == 0)
                        data[7:0] <= data_to_send;
                    r_w <= rw;
                    slave_address[6:0] <= slave_addr;
                    on <= 1;
                end 
            end
            4'b0001:
            begin
                // Start of Address Bit 6
                state <= 4'b0010;
                dl <= slave_address[6];
            end
            4'b0010:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 6
                    // Start of Address Bit 5
                    state <= 4'b0011;
                    dl <= slave_address[5];
                end
                counter <= ~counter;
            end
            4'b0011:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 5
                    // Start of Address Bit 4
                    state <= 4'b0100;
                    dl <= slave_address[4];
                end
                counter <= ~counter;
            end
            4'b0100:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 4
                    // Start of Address Bit 3
                    state <= 4'b0101;
                    dl <= slave_address[3];
                end
                counter <= ~counter;
            end
            4'b0101:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 3
                    // Start of Address Bit 2
                    state <= 4'b0110;
                    dl <= slave_address[2];
                end
                counter <= ~counter;
            end
            4'b0110:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 2
                    // Start of Address Bit 1
                    state <= 4'b0111;
                    dl <= slave_address[1];
                end
                counter <= ~counter;
            end
            4'b0111:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 1
                    // Start of Address Bit 0
                    state <= 4'b1000;
                    dl <= slave_address[0];
                end
                counter <= ~counter;
            end
            4'b1000:
            begin
                if(counter == 1)
                begin
                    // End of Address Bit 0
                    // Start of R/W Bit
                    state <= 4'b1001;
                    dl <= r_w;
                end
                counter <= ~counter;
            end 
            4'b1001:
            begin
                if(counter == 1)
                begin
                    // End of R/W Bit
                    // Waiting for ACK/NACK
                    state <= 4'b1010;
                    dl <= 1;
                end
                counter <= ~counter;
            end
            4'b1010:
            begin
                if(counter == 1 & SDA == 0)
                begin
                    // End of wait for ACK/NACK
                    // Start of Data Bit 7
                    state <= 4'b1011;
                    if(r_w == 0)
                        dl <= data[7];
                    else 
                        data[7] <= SDA;
                end
                counter <= ~counter;
            end
            4'b1011:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 7
                    // Start of Data Bit 6
                    state <= 4'b1100;
                    if(r_w == 0)
                        dl <= data[6];
                    else 
                        data[6] <= SDA;
                end
                counter <= ~counter;
            end
            4'b1100:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 6
                    // Start of Data Bit 5
                    state <= 4'b1101;
                    if(r_w == 0)
                        dl <= data[5];
                    else 
                        data[5] <= SDA;
                end
                counter <= ~counter;
            end
            4'b1101:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 5
                    // Start of Data Bit 4
                    state <= 4'b1110;
                    if(r_w == 0)
                        dl <= data[4];
                    else 
                        data[4] <= SDA;
                end
                counter <= ~counter;
            end
            4'b1110:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 4
                    // Start of Data Bit 3
                    state <= 4'b1111;
                    if(r_w == 0)
                        dl <= data[3];
                    else 
                        data[3] <= SDA;
                end
                counter <= ~counter;
            end
            4'b1111:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 3
                    // Start of Data Bit 2
                    state <= 5'b10000;
                    if(r_w == 0)
                        dl <= data[2];
                    else 
                        data[2] <= SDA;
                end
                counter <= ~counter;
            end
            5'b10000:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 2
                    // Start of Data Bit 1
                    state <= 5'b10001;
                    if(r_w == 0)
                        dl <= data[1];
                    else 
                        data[1] <= SDA;
                end
                counter <= ~counter;
            end
            5'b10001:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 1
                    // Start of Data Bit 0
                    state <= 5'b10010;
                    if(r_w == 0)
                        dl <= data[0];
                    else 
                        data[0] <= SDA;
                end
                counter <= ~counter;
            end
            5'b10010:
            begin
                if(counter == 1)
                begin
                    // End of Data Bit 0
                    // Waiting/Sending for ACK/NACK
                    state <= 5'b10011;
                    if(r_w == 0)
                        dl <= 1;
                    else 
                        dl <= 0;
                end
                counter <= ~counter;
            end
            5'b10011:
            begin
                if(counter == 1 && SDA == 0)
                begin
                    // End of Wait for ACK/NACK
                    // Start of Stop Bit Sequence
                    state <= 5'b10100;
                    dl <= 0;
                end
                counter <= ~counter;
            end
            5'b10100:
            begin
                state <= 5'b00000;
                on <= 0;
            end
        endcase
    end
    always @(posedge clk)
    begin
        if(on)
            cl <= ~cl;
    end
    assign SCL = (on == 1?(dl == 0?1'b0:1'bz):1'bz); 
    assign SDA = (on == 1?(cl == 0?1'b0:1'bz):1'bz); 
    
endmodule