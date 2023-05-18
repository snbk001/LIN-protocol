`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sudhee
//
// Create Date: 26.04.2023 17:57:41
// Design Name: LIN Commander Module
// Module Name: lin_comm
// Project Name: LIN Protocol
// Target Devices: Zynq 7020
// Tool Versions: Vivado
// Description: LIN Commander module to initiates the data communication using PID.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module lin_comm(
    input  logic sys_clk        ,//system clock
    input  logic rstn           ,//reset
    input  logic start          ,//start commander
    input  logic [5:0] pid      ,//id or address
    input  logic inter_tx_delay ,//inter transmission delay
    input  logic resp_busy      ,//responder busy
    output logic sdo_comm       ,//serial data out
    output logic lin_busy       ,//commander busy
    output logic comm_tx_done   ,//tx complete from commander
    output logic [33:0] frame_header_out //frame header
    );

    logic [3:0] break_count    ;//count for break field
    logic [3:0] sync_count     ;//count for sync field
    logic [5:0] pid_adrs_reg   ;//PID
    logic [3:0] pid_count      ;//count for PID
    logic [1:0] parity_count   ;//count for parity
    logic parity0              ;//for parity
    logic parity1              ;//for parity
    logic [33:0] frame_header  ;//frame header reg

    //states declaration
    typedef enum {IDLE,
        SYNC_BREAK,
        SYNC_FIELD,
        PID,
        PARITY,
        STOP,
        WAIT
    } state_type_e;

    state_type_e state;

    //FSM to synchronize and send PID data to responder
    always_ff @ (posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            sdo_comm <= 0;
            break_count <= 0;
            sync_count <= 0;
            pid_count <= 0;
            pid_adrs_reg <= 0;
            parity_count <= 0;
            parity0 <= 0;
            parity1 <= 0;
            comm_tx_done <= 0;
            frame_header <= 0;
            state <= IDLE;
        end else begin
            case(state)
            IDLE: begin
                break_count <= 0;
                sync_count <= 0;
                pid_count <= 0;
                frame_header <= 0;
                parity_count <= 0;
                parity0 <= 0;
                parity1 <= 0;
                sdo_comm <= 0;
                comm_tx_done <= 0;
                pid_adrs_reg <= pid;
                if (start && !inter_tx_delay && !resp_busy) begin
                    state <= SYNC_BREAK;
                end else begin
                    state <= IDLE;
                end
            end
            SYNC_BREAK: begin
                frame_header <= {frame_header[33:0], sdo_comm};
                if (break_count < 13) begin
                    sdo_comm <= 0;//sync break
                    break_count <= break_count + 1;
                    state <= SYNC_BREAK;
                end else begin
                    sdo_comm <= 1;//delimeter
                    break_count <= 0;
                    state <= SYNC_FIELD;
                end
            end
            SYNC_FIELD: begin
                frame_header <= {frame_header[33:0], sdo_comm};
                sync_count <= sync_count + 1;
                if (sync_count < 1) begin
                    sdo_comm <= 0;//start bit
                    state <= SYNC_FIELD;
                end else if (sync_count >= 1 && sync_count < 9) begin
                    sdo_comm <= ~sdo_comm;
                    state <= SYNC_FIELD;
                end else begin
                    sdo_comm <= 1;//stop bit
                    sync_count <= 0;
                    state <= PID;
                end
            end
            PID: begin
                frame_header <= {frame_header[33:0], sdo_comm};
                pid_count <= pid_count + 1;
                if (pid_count < 1) begin
                    sdo_comm <= 0;//start bit
                    state <= PID;
                end else if (pid_count >= 1 && pid_count < 7) begin
                    pid_adrs_reg <= {1'b0, pid_adrs_reg[5:1]};
                    sdo_comm <= pid_adrs_reg[0];
                    state <= PID;
                end else begin
                    parity0 <= pid[0] ^ pid[1] ^ pid[2] ^ pid[4];//parity generation
                    parity1 <= pid[1] ^ pid[3] ^ pid[4] ^ pid[5];//parity generation
                    pid_count <= 0;
                    state <= PARITY;
                end
            end
            PARITY: begin
                parity_count <= parity_count + 1;
                frame_header <= {frame_header[33:0], sdo_comm};
                if (parity_count == 0) begin
                    sdo_comm <= parity0;
                    state <= PARITY;
                end else if (parity_count == 1) begin
                    sdo_comm <= parity1;
                    state <= PARITY;
                end else begin
                    parity_count <= 0;
                    sdo_comm <= 1;//stop bit
                    state <= STOP;
                end
            end
            STOP: begin
                comm_tx_done <= 1;
                sdo_comm <= 0;
                frame_header <= {frame_header[33:0], sdo_comm};
                state <= WAIT;
            end
            WAIT: begin
                if (resp_busy) begin
                    state <= WAIT;//wait till responder finishes tx
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
            endcase
        end
    end

    assign lin_busy = state >= SYNC_BREAK && state <= STOP;//commander busy
    assign frame_header_out = comm_tx_done ? frame_header : 0;//frame header

endmodule
