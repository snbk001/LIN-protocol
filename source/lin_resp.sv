`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sudhee
//
// Create Date: 11.05.2023 17:23:41
// Design Name: LIN Responder Design
// Module Name: lin_resp
// Project Name: LIN Protocol
// Target Devices: Zynq 7020
// Tool Versions: Vivado
// Description: LIN Responder sends data to Commander using serial communication.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module lin_resp(
    input  logic sys_clk       ,//system clock
    input  logic rstn          ,//reset
    input  logic lin_busy      ,//commander busy
    input  logic comm_tx_done  ,//tx complete from commander
    input  logic [33:0] frame_header_out,//header from commander
    input  logic [63:0] data   ,//input data to responder
    output logic [89:0] response_out,//response from responder
    output logic [7:0] checksum,//checksum/crc out
    output logic sdo_resp      ,//serial data out from responder
    output logic resp_tx_done  ,//tx complete from responder
    output logic resp_busy      //responder busy
    );

    //states declaration
    typedef enum {IDLE,
        DATA,
        STOP,
        CHECKSUM
    } state_type_e;

    state_type_e state;

    logic [63:0] data_reg ;
    logic [3:0] byte_count;
    logic [3:0] check_count;
    logic [3:0] data_count ;
    logic [7:0] crc_in = 8'hFF;
    logic [7:0] checksum_reg  ;
    logic [7:0] sync_data  ;

    assign sync_data = frame_header_out[22:15];//sync data = 0x55

    //CRC instantiation
    crcd64_o8 CRCD64_O8(
            .crc_in  (crc_in ),
            .data_in (data),
            .crc_out (checksum)
            );

    //FSM for responder data tx to commander and checksum generation
    always_ff @ (posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            response_out <= 0;
            sdo_resp  <= 0;
            resp_busy <= 0;
            byte_count  <= 0;
            check_count <= 0;
            data_count <= 0;
            data_reg   <= 0;
            resp_busy  <= 0;
            checksum_reg <= 0;
            resp_tx_done <= 0;
            state <= IDLE;
        end else begin
            case (state)
            IDLE: begin
                response_out <= 0;
                resp_busy <= 0;
                byte_count  <= 0;
                check_count <= 0;
                data_count <= 0;
                checksum_reg <= checksum;
                data_reg <= data;
                resp_tx_done <= 0;
                if (!lin_busy && comm_tx_done && sync_data == 8'h55) begin
                    sdo_resp <= 0;
                    resp_busy <= 1;
                    state <= DATA;
                end else begin
                    state <= IDLE;
                end
            end
            DATA: begin
                response_out <= {response_out[88:0], sdo_resp};
                if (data_count < 8) begin
                    data_reg <= {1'b0, data_reg[63:1]};
                    sdo_resp <= data_reg[0];
                    data_count <= data_count + 1;
                    state <= DATA;
                end else begin
                    sdo_resp <= 1;
                    data_count <= 0;
                    state <= STOP;
                end
            end
            STOP: begin
                response_out <= {response_out[88:0], sdo_resp};
                if (byte_count < 8) begin
                    sdo_resp <= 0;
                    byte_count <= byte_count + 1;
                    state <= DATA;
                end else begin
                    sdo_resp <= 0;
                    byte_count <= 0;
                    state <= CHECKSUM;
                end
            end
            CHECKSUM: begin
                response_out <= {response_out[88:0], sdo_resp};
                if (check_count <= 7) begin
                checksum_reg <= {1'b0, checksum_reg[7:1]};
                    sdo_resp <= checksum_reg[0];
                    check_count <= check_count + 1;
                    state <= CHECKSUM;
                end else begin
                    sdo_resp <= 1;
                    resp_tx_done <= 1;
                    check_count <= 0;
                    resp_busy <= 0;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
            endcase
        end
    end
    endmodule
