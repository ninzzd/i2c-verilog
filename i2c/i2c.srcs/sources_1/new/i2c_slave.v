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
    reg potential_on; // flag register to detect SDA:H->L during start sequence, and to confirm the stop sequence
    reg on; // second flag register to confirm the start sequence and to detect SDA:L->H during stop sequence
    reg dl;
    reg rw;
    reg counter;
    initial
    begin
        on <= 0;
        potential_on <= 0;
        counter <= 0;
        dl <= 1;
        data <= 8'b01000001;
    end
    always @(negedge SDA) // To detect SDA:H->L at the beginning of the start sequence
    begin
        if(SCL==1 && potential_on == 0)
            potential_on <= 1;
    end
    always @(posedge SDA) // To detect SDA:L->H at the end of the stop sequence
    begin
        if(potential_on == 1 && on == 0 && SCL == 1)
        begin
            potential_on <= 0;
            state <= 0;
        end
    end
    
    // Transmitting at Posedge
    always @(posedge SCL)
    begin
        if(on)
        begin
            case(state)
                // ----- START OF ADDRESS ACK/NACK BIT -----
                5'b01001:
                begin
                    dl <= 0;
                    state <= 5'b01010;
                end
                // ---------------------------------------
                
                // ----- DATA BITS (S2M) -----
                5'b01011:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[7];
                        state <= 5'b01100;
                    end
                end
                5'b01100:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[6];
                        state <= 5'b01101;
                    end
                end
                5'b01101:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[5];
                        state <= 5'b01110;
                    end
                end
                5'b01110:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[4];
                        state <= 5'b01111;
                    end
                end
                5'b01111:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[3];
                        state <= 5'b10000;
                    end
                end
                5'b10000:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[2];
                        state <= 5'b10001;
                    end
                end
                5'b10001:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[1];
                        state <= 5'b10010;
                    end
                end
                5'b10010:
                begin
                    if(rw == 1)
                    begin
                        dl <= data[0];
                        state <= 5'b10100;
                    end
                end
                // ---------------------------
                
                // ----- START of ACK/NACK BIT (S2M) -----
                5'b10011:
                begin
                        dl <= 0;
                        received_data <= data;
                end
                // ---------------------------------------
                
                // ----- START of STOP SEQUENCE -----
                5'b11111:
                begin
                    on <= 0;
                end
                // ----------------------------------
            endcase
        end
    end
    // Sample at Negedge 
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
                // End of Address Bit 6 (Sampling)
                addr[6] <= SDA;
                state <= 5'b00010;
            end
            5'b00010:
            begin
                // End of Address Bit 5 (Sampling)
                addr[5] <= SDA;
                state <= 5'b00011;
            end
            5'b00011:
            begin
                // End of Address Bit 4 (Sampling)
                addr[4] <= SDA;
                state <= 5'b00100;
            end
            5'b00100:
            begin
                // End of Address Bit 3 (Sampling)
                addr[3] <= SDA;
                state <= 5'b00101;
            end
            5'b00101:
            begin
                // End of Address Bit 2 (Sampling)
                addr[2] <= SDA;
                state <= 5'b00110;
            end
            5'b00110:
            begin
                // End of Address Bit 1 (Sampling)
                addr[1] <= SDA;
                state <= 5'b00111;
            end
            5'b00111:
            begin
                // End of Address Bit 0 (Sampling)
                addr[0] <= SDA;
                state <= 5'b01000;
            end
            5'b01000:
            begin
                // End of R/W Bit 0 and Comparison of Received Address with Self-Address (Sampling)
                if(addr == self_addr)
                begin
                    rw <= SDA;
                    state <= 5'b01001;
                end
                else
                begin
                    // Slave becomes inactive if received address doesn't match self-address
                    potential_on <= 0;
                    on <= 0;
                end
            end
            // ---------------------------------------
            
            // ----- END OF ADDRESS ACK/NACK BIT -----
            5'b01010:
            begin
                dl <= 1;
                state <= 5'b01011;
            end
            // ---------------------------------------
            
            //----- DATA BITS (M2S) -----
            5'b01011:
            begin
                if(rw == 0)
                begin
                    data[7] <= SDA;
                    state <= 5'b01100;
                end
            end
            5'b01100:
            begin
                if(rw == 0)
                begin
                    data[6] <= SDA;
                    state <= 5'b01101;
                end
            end
            5'b01101:
            begin
                if(rw == 0)
                begin
                    data[5] <= SDA;
                    state <= 5'b01110;
                end
            end
            5'b01110:
            begin
                if(rw == 0)
                begin
                    data[4] <= SDA;
                    state <= 5'b01111;
                end
            end
            5'b01111:
            begin
                if(rw == 0)
                begin
                    data[3] <= SDA;
                    state <= 5'b10000;
                end
            end
            5'b10000:
            begin
                if(rw == 0)
                begin
                    data[2] <= SDA;
                    state <= 5'b10001;
                end
            end
            5'b10001:
            begin
                if(rw == 0)
                begin
                    data[1] <= SDA;
                    state <= 5'b10010;
                end
            end
            5'b10010:
            begin
                if(rw == 0)
                begin
                    data[0] <= SDA;
                    state <= 5'b10011;
                end
            end
            // --------------------------
            
            // ----- END of ACK/NACK BIT (M2S)(Sampling) -----
            5'b10100:
            begin
                dl <= 1;
                if(counter == 1 && SDA == 1)
                    state <= 5'b11111;
                counter <= ~counter;
            end
            // -----------------------------------------------
            
            // ----- End of ACK/NACK BIT (S2M) -----
            5'b10011:
            begin
                dl <= 1;
                state <= 5'b11111;
            end
            // -------------------------------------
            
            //
            endcase
        end
    end
    assign self_addr = 7'b0000001;
    assign SDA = (on == 0?1'bz:(dl == 0?1'b0:1'bz));
endmodule
