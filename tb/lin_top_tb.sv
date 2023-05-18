`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sudhee
//
// Create Date: 16.05.2023 18:44:26
// Design Name: LIN Testbench
// Module Name: lin_top_tb
// Project Name: LIN Protocol
// Target Devices: Zynq 7020
// Tool Versions: Vivado
// Description: Testbench to simulate LIN Protocol.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module lin_top_tb();
    logic sys_clk        ;
    logic rstn           ;
    logic [5:0] pid      ;
    logic [63:0] data    ;
    logic sdo_comm       ;
    logic sdo_resp       ;
    logic [33:0] frame_header_out  ;
    logic [89:0] response_out      ;
    logic comm_tx_done             ;
    logic resp_tx_done             ;

    lin_top LIN_TOP(
        .sys_clk          (sys_clk         ),
        .rstn             (rstn            ),
        .pid              (pid             ),
        .data             (data            ),
        .sdo_comm         (sdo_comm        ),
        .sdo_resp         (sdo_resp        ),
        .frame_header_out (frame_header_out),
        .response_out     (response_out    ),
        .comm_tx_done     (comm_tx_done    ),
        .resp_tx_done     (resp_tx_done    )
    );

    initial begin
        sys_clk = 0;
        rstn    = 0;
        pid     = 0;
        data    = 0;
        #500;
        rstn    = 1;
        pid     = 10'h2d;
        data    = 32639;
    end

    always #5 sys_clk = ~sys_clk;

endmodule
