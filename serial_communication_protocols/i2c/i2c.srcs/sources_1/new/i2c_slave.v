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
    reg on;
    reg dl;
    reg rw;
    reg counter;
//    reg counter;
    assign self_addr = 7'b0000001;
    initial
    begin
        counter <= 0;
        rw <= 0;
        data <= 0;
        addr <= 0;
        state <= 0;
        dl <= 1;
        on <= 0;
    end
    always @(negedge SDA)
    begin
        if(on == 0 && SCL == 1)
            on <= 1;
    end
    always @(posedge SCL)
    begin
        if(on)
        begin
            case(state)
            4'b1001:
            begin
                dl <= 0;
                state <= 4'b1010;
            end
            5'b10001:
            begin
                
            end
            endcase
        end
    end
    always @(negedge SCL)
    begin  
        if(on)
        begin
            case(state)
            4'b0000:
            begin
                addr[6] <= SDA;
                state <= 4'b0001;
            end
            4'b0001:
            begin
                addr[5] <= SDA;
                state <= 4'b0010;
            end
            4'b0010:
            begin
                addr[4] <= SDA;
                state <= 4'b0011;
            end
            4'b0011:
            begin
                addr[3] <= SDA;
                state <= 4'b0100;
            end
            4'b0100:
            begin
                addr[2] <= SDA;
                state <= 4'b0101;
            end
            4'b0101:
            begin
                addr[1] <= SDA;
                state <= 4'b0110;
            end
            4'b0110:
            begin
                addr[0] <= SDA;
                state <= 4'b0111;
            end
            4'b1000:
            begin
                if(addr == self_addr)
                begin
                    rw <= SDA;
                    state <= 4'b1001;
                end
                else
                begin
                    on <= 0;
                    state <= 0;
                    addr <= 0;
                end
            end
            
            endcase
        end
    end
    assign SDA = (on == 0?1'bz:(dl == 0?1'b0:1'bz));
endmodule
