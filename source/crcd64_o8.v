`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sudhee
//
// Create Date: 16.05.2023 12:40:27
// Design Name: CRC8 Module
// Module Name: crcd64_o8
// Project Name: CRC for LIN Protocol
// Target Devices: Zynq 7020
// Tool Versions: Vivado
// Description: CRC for LIN Protocol
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module crcd64_o8 (
    input  [7:0] crc_in  ,//8'hFF
    input  [63:0] data_in,//input data to CRC
    output [7:0] crc_out
);
    assign crc_out[0] = crc_in[0] ^ crc_in[4] ^ crc_in[7] ^ data_in[0] ^ data_in[6] ^ data_in[7] ^
        data_in[8] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^
        data_in[21] ^ data_in[23] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^
        data_in[35] ^ data_in[39] ^ data_in[40] ^ data_in[43] ^ data_in[45] ^ data_in[48] ^
        data_in[49] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[56] ^
        data_in[60] ^ data_in[63];
    assign crc_out[1] = crc_in[0] ^ crc_in[1] ^ crc_in[4] ^ crc_in[5] ^ crc_in[7] ^ data_in[0] ^
        data_in[1] ^ data_in[6] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^
        data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^
        data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^
        data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[39] ^ data_in[41] ^ data_in[43] ^
        data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[51] ^ data_in[52] ^
        data_in[55] ^ data_in[56] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63];
    assign crc_out[2] = crc_in[1] ^ crc_in[2] ^ crc_in[4] ^ crc_in[5] ^ crc_in[6] ^ crc_in[7] ^
        data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^
        data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[22] ^ data_in[24] ^
        data_in[25] ^ data_in[28] ^ data_in[29] ^ data_in[33] ^ data_in[34] ^ data_in[37] ^
        data_in[39] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[46] ^ data_in[47] ^
        data_in[48] ^ data_in[50] ^ data_in[54] ^ data_in[57] ^ data_in[58] ^ data_in[60] ^
        data_in[61] ^ data_in[62] ^ data_in[63];
    assign crc_out[3] = crc_in[2] ^ crc_in[3] ^ crc_in[5] ^ crc_in[6] ^ crc_in[7] ^ data_in[1] ^
        data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^
        data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^
        data_in[29] ^ data_in[30] ^ data_in[34] ^ data_in[35] ^ data_in[38] ^ data_in[40] ^
        data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^
        data_in[51] ^ data_in[55] ^ data_in[58] ^ data_in[59] ^
        data_in[61] ^ data_in[62] ^ data_in[63];
    assign crc_out[4] = crc_in[0] ^ crc_in[3] ^ crc_in[4] ^ crc_in[6] ^ crc_in[7] ^ data_in[2] ^
        data_in[3] ^ data_in[4] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^
        data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^
        data_in[30] ^ data_in[31] ^ data_in[35] ^ data_in[36] ^ data_in[39] ^ data_in[41] ^
        data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^
        data_in[52] ^ data_in[56] ^ data_in[59] ^ data_in[60] ^ data_in[62] ^ data_in[63];
    assign crc_out[5] = crc_in[1] ^ crc_in[4] ^ crc_in[5] ^ crc_in[7] ^ data_in[3] ^ data_in[4] ^
        data_in[5] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^
        data_in[18] ^ data_in[20] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[31] ^
        data_in[32] ^ data_in[36] ^ data_in[37] ^ data_in[40] ^ data_in[42] ^ data_in[45] ^
        data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^
        data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63];
    assign crc_out[6] = crc_in[2] ^ crc_in[5] ^ crc_in[6] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^
        data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^
        data_in[21] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^
        data_in[37] ^ data_in[38] ^ data_in[41] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^
        data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[54] ^ data_in[58] ^
        data_in[61] ^ data_in[62];
    assign crc_out[7] = crc_in[3] ^ crc_in[6] ^ crc_in[7] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^
        data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^
        data_in[22] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^
        data_in[38] ^ data_in[39] ^ data_in[42] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^
        data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[55] ^ data_in[59] ^
        data_in[62] ^ data_in[63];

endmodule
