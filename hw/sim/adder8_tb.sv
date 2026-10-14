// SPDX-License-Identifier: CERN-OHL-P-2.0
// Exhaustive testbench for adder8: every a, b, cin (2 * 256 * 256 cases)

module adder8_tb;

  logic [7:0] a, b, sum;
  logic cin, cout;
  int errors = 0;

  adder8 dut (
      .a(a),
      .b(b),
      .cin(cin),
      .sum(sum),
      .cout(cout)
  );

  initial begin
    $dumpfile("adder8.vcd");
    $dumpvars(0, adder8_tb);

    for (int c = 0; c < 2; c++) begin
      for (int i = 0; i < 256; i++) begin
        for (int j = 0; j < 256; j++) begin
          a   = 8'(i);
          b   = 8'(j);
          cin = 1'(c);
          #1;
          if ({cout, sum} !== 9'(i + j + c)) begin
            $display("FAIL: %0d + %0d + %0d = %0d (cout=%0b)", i, j, c, sum, cout);
            errors++;
          end
        end
      end
    end

    if (errors == 0) $display("PASS: adder8 (131072 cases)");
    else $display("FAIL: adder8 (%0d errors)", errors);
    $finish;
  end

endmodule
