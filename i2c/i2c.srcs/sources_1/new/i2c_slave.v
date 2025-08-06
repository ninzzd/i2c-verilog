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
    reg [6:0] addr;
    reg [7:0] data;
    reg [4:0] state;
    reg potential_on;
    reg on;
    reg dl;
    reg rw;
    reg counter;
    initial
    begin
        on <= 0;
        potential_on <= 0;
        counter <= 0;
        dl <= 1;
        data <= 8'b01001111;
    end
    always @(negedge SDA)
    begin
        if(SCL==1 && potential_on == 0)
            potential_on <= 1;
    end
    always @(posedge SDA)
    begin
        if(potential_on == 1 && on == 0 && SCL == 1)
        begin
            potential_on <= 0;
            state <= 0;
        end
    end
    always @(posedge SCL)
    begin
        if(on)
        begin
            case(state)
            5'b10011:
            begin
                on <= 0;
            end
            endcase 
        end
    end
    always @(negedge SCL)
    begin
        if(potential_on==1 && on==0)
        begin
            on <= 1;
            state <= 1;
        end
        if(on)
        begin
            case(state)
            5'b00001:
            begin
                addr[6] <= SDA;
                state <= 5'b00010;
            end
            5'b00010:
            begin
                addr[5] <= SDA;
                state <= 5'b00011;
            end
            5'b00011:
            begin
                addr[4] <= SDA;
                state <= 5'b00100;
            end
            5'b00100:
            begin
                addr[3] <= SDA;
                state <= 5'b00101;
            end
            5'b00101:
            begin
                addr[2] <= SDA;
                state <= 5'b00110;
            end
            5'b00110:
            begin
                addr[1] <= SDA;
                state <= 5'b00111;
            end
            5'b00111:
            begin
                addr[0] <= SDA;
                state <= 5'b01000;
            end
            5'b01000:
            begin
                if(addr == self_addr)
                begin
                    rw <= SDA;
                    dl <= 0;
                    state <= 5'b01001;
                end
                else
                begin
                    potential_on <= 0;
                    on <= 0;
                end
            end
            5'b01001:
            begin
                dl <= 1;
                if(rw == 1)
                    dl <= data[7];
                state <= 5'b01010;
            end
            5'b01010:
            begin
                if(rw == 1)
                    dl <= data[6];
                else
                    data[7] <= SDA;
                state <= 5'b01011;
            end
            5'b01011:
            begin
                if(rw == 1)
                    dl <= data[5];
                else
                    data[6] <= SDA;
                state <= 5'b01100;
            end
            5'b01100:
            begin
                if(rw == 1)
                    dl <= data[4];
                else
                    data[5] <= SDA;
                state <= 5'b01101;
            end
            5'b01101:
            begin
                if(rw == 1)
                    dl <= data[3];
                else
                    data[4] <= SDA;
                state <= 5'b01110;
            end
            5'b01110:
            begin
                if(rw == 1)
                    dl <= data[2];
                else
                    data[3] <= SDA;
                state <= 5'b01111;
            end
            5'b01111:
            begin
                if(rw == 1)
                    dl <= data[1];
                else
                    data[2] <= SDA;
                state <= 5'b10000;
            end
            5'b10000:
            begin
                if(rw == 1)
                    dl <= data[0];
                else
                    data[1] <= SDA;
                state <= 5'b10001;
            end
            5'b10001:
            begin
                if(rw == 0)
                begin
                    data[0] <= SDA;
                    dl <= 0;
                end
                else    
                    dl <= 1;
                state <= 5'b10010;
            end
            5'b10010:
            begin
                if(rw == 0)
                begin
                    received_data <= data;
                    dl <= 1;
                    state <= 5'b10011;
                end
                if(rw == 1 && SDA == 1)
                begin
                    state <= 5'b10011;
                end
            end
            endcase
        end
    end
    assign self_addr = 7'b0000001;
    assign SDA = (on == 0?1'bz:(dl == 0?1'b0:1'bz));
endmodule
