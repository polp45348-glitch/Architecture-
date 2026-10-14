# Architecture- : Open-Source AI SoC

Hardware-software co-design lab: ออกแบบ CPU (RISC-V) และตัวเร่ง AI ตั้งแต่ศูนย์ ด้วยเครื่องมือ open source ทั้งหมด

## โครงสร้าง

```
hw/rtl/        SystemVerilog ของวงจร        (CERN-OHL-P-2.0)
hw/sim/        testbench + ผล build/waveform
sw/compiler/   compiler (Rust, LLVM/MLIR)    (Apache-2.0)
sw/driver/     driver
docs/          เอกสาร
```

## เริ่มใช้งาน

ต้องมี [Nix](https://nixos.org/download) ที่เปิด flakes แล้ว

```sh
nix develop              # hardware: verilator, iverilog, yosys, verible, gtkwave, surfer, cocotb, riscv32 gcc
nix develop .#fpga       # + nextpnr, icestorm, trellis, apycula, openFPGALoader
nix develop .#compiler   # rust, llvm 18, mlir, cmake
```

## รันตัวอย่างแรก

```sh
make sim  TOP=adder8     # build + simulate -> PASS: adder8 (131072 cases)
make wave TOP=adder8     # เปิด waveform
make lint
make clean
```

เพิ่มวงจรใหม่: สร้าง `hw/rtl/<name>.sv` และ `hw/sim/<name>_tb.sv` แล้ว `make sim TOP=<name>`

## Roadmap

1. Digital logic — gate, mux, adder, flip-flop, FSM (Nand2Tetris, HDLBits)
2. SystemVerilog + testbench + อ่าน waveform
3. CPU RISC-V RV32I: single-cycle → multi-cycle → pipeline 5 stage
4. Memory / bus / UART → รันโปรแกรม C บน CPU ตัวเอง
5. AI accelerator: MAC, int8, systolic array ต่อกับ CPU แบบ MMIO
6. ลง FPGA จริง (Tang Nano, iCESugar, ULX3S)
7. Driver และ compiler

แหล่งเรียน: Harris & Harris *Digital Design and Computer Architecture: RISC-V Edition*,
Patterson & Hennessy *Computer Organization and Design: RISC-V Edition*,
Onur Mutlu *Digital Design and Computer Architecture* (YouTube)

## License

Hardware (`hw/`) ใช้ CERN-OHL-P-2.0 ส่วนที่เหลือใช้ Apache-2.0 ดูรายละเอียดใน [LICENSE](LICENSE)
