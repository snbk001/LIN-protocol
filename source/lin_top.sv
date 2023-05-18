`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sudhee
//
// Create Date: 16.05.2023 17:19:36
// Design Name: LIN Top Module
// Module Name: lin_top
// Project Name: LIN Protocol
// Target Devices: Zynq 7020
// Tool Versions: Vivado
// Description: Top and control module for LIN protocol
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module lin_top(
    input  logic sys_clk        ,//system clock
    input  logic rstn           ,//reset
    input  logic [5:0] pid      ,//id or address
    input  logic [63:0] data    ,//input data to responder
    output logic sdo_comm       ,//serial data out from commander
    output logic sdo_resp       ,//serial data out from responder
    output logic [33:0] frame_header_out,//header from commander
    output logic [89:0] response_out    ,//response from responder
    output logic comm_tx_done   ,//tx complete from commander
    output logic resp_tx_done    //tx complete from responder
    );

    logic inter_tx_delay    ;//inter transmission delay
    logic [4:0] delay_count ;//inter transmission delay count
    logic start             ;//start commander
    logic resp_busy         ;//responder busy
    logic lin_busy          ;//commander busy
    logic lin_sof           ;//commander start of frame
    logic [7:0] checksum    ;//responder checksum
    logic [123:0] frame_out ;//total frame from commander and responder

    //LIN Commander instantiation
    lin_comm LIN_COMM(
        .sys_clk        (sys_clk       ),
        .rstn           (rstn          ),
        .start          (start         ),
        .pid            (pid           ),
        .inter_tx_delay (inter_tx_delay),
        .resp_busy      (resp_busy     ),
        .sdo_comm       (sdo_comm      ),
        .lin_busy       (lin_busy      ),
        .comm_tx_done   (comm_tx_done  ),
        .frame_header_out (frame_header_out  )
    );

    //LIN Responder instantiation
    lin_resp LIN_RESP(
        .sys_clk          (sys_clk         ),
        .rstn             (rstn            ),
        .lin_busy         (lin_busy        ),
        .comm_tx_done     (comm_tx_done    ),
        .frame_header_out (frame_header_out),
        .data             (data            ),
        .response_out     (response_out    ),
        .checksum         (checksum        ),
        .sdo_resp         (sdo_resp        ),
        .resp_tx_done     (resp_tx_done    ),
        .resp_busy        (resp_busy       )
    );

    //states declaration
    typedef enum {IDLE,
        DELAY
    } state_type_e;

    state_type_e state;

    assign frame_out = resp_tx_done ? {frame_header_out, response_out} : 0;/*frame output after the
                                                                            responder tx is done*/

    //start condition for commander
    always_ff @ (posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            start <= 0;
        end else if (!resp_tx_done && !resp_busy) begin
            start <= 1;
        end else begin
            start <= 0;
        end
    end

    //delay generation after the responder tx is done
    always_ff @ (posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            inter_tx_delay <= 0;
            delay_count <= 0;
            state <= IDLE;
        end else begin
            case (state)
            IDLE: begin
                inter_tx_delay <= 0;
                delay_count <= 0;
                if (resp_tx_done) begin
                    state <= DELAY;
                end else begin
                    state <= IDLE;
                end
            end
            DELAY: begin
                if (delay_count < 20) begin
                    delay_count <= delay_count + 1;
                    inter_tx_delay <= 1;//tx delay for 20ns
                    state <= DELAY;
                end else begin
                    delay_count <= 0;
                    inter_tx_delay <= 0;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
            endcase
        end
    end
endmodule
