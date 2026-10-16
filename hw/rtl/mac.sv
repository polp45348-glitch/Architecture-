// SPDX-License-Identifier: CERN-OHL-P-2.0
// MAC unit: multiply-accumulate, int8 x int8 -> int32
// หัวใจของ NPU: ทุกจังหวะนาฬิกา เอา a*b ไปบวกสะสมใน acc
module mac (
    input  wire               clk,
    input  wire               rst,   // รีเซ็ต acc เป็น 0
    input  wire               en,    // 1 = สะสมค่ารอบนี้
    input  wire signed [7:0]  a,     // int8
    input  wire signed [7:0]  b,     // int8
    output reg  signed [31:0] acc    // ผลรวมสะสม
);
    always @(posedge clk) begin
        if (rst)
            acc <= 32'sd0;
        else if (en)
            acc <= acc + a * b;
    end
endmodule
