// SPDX-License-Identifier: CERN-OHL-P-2.0
// Testbench สำหรับ mac.sv
// ป้อนค่าสุ่ม แล้วเทียบกับคำตอบที่คำนวณในซอฟต์แวร์
module mac_tb;
    logic               clk;
    logic               rst;
    logic               en;
    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [31:0] acc;

    mac dut (.clk(clk), .rst(rst), .en(en), .a(a), .b(b), .acc(acc));

    initial begin           // นาฬิกา: สลับทุก 5 หน่วยเวลา
        clk = 0;
        forever #5 clk = ~clk;
    end

    longint expected;
    int errors;

    task automatic step(input logic signed [7:0] x, input logic signed [7:0] y);
        a = x; b = y; en = 1;
        @(posedge clk); #1;
        expected += x * y;
        if (acc !== 32'(expected)) begin
            $display("FAIL: a=%0d b=%0d  acc=%0d  expected=%0d", x, y, acc, expected);
            errors++;
        end
    endtask

    initial begin
        $dumpfile("mac.vcd");   // ไฟล์คลื่นสำหรับเปิดใน GTKWave
        $dumpvars(0, mac_tb);
        rst = 1; en = 0; a = 0; b = 0; expected = 0; errors = 0;

        @(posedge clk); #1; rst = 0;

        // กรณีขอบ: ค่าสุดขั้วของ int8
        step(127, 127);
        step(-128, -128);
        step(-128, 127);
        step(0, 55);

        // ผลคูณจุดของเวกเตอร์ [1,2,3,4] . [5,6,7,8] = 70
        rst = 1; @(posedge clk); #1; rst = 0; expected = 0;
        step(1, 5); step(2, 6); step(3, 7); step(4, 8);
        $display("dot([1,2,3,4],[5,6,7,8]) = %0d", acc);

        // สุ่ม 1000 รอบ
        rst = 1; @(posedge clk); #1; rst = 0; expected = 0;
        repeat (1000) step(8'($urandom), 8'($urandom));

        // en = 0 ต้องไม่เปลี่ยนค่า
        en = 0; a = 99; b = 99;
        @(posedge clk); #1;
        if (acc !== 32'(expected)) begin $display("FAIL: en=0 changed acc"); errors++; end

        if (errors == 0) $display("PASS: all tests passed 🎉");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
