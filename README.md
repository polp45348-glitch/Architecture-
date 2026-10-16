# Lamp-AI

**An open-source AI chip, as small and ordinary as a desk lamp, so everyone can have AI of their own.**

Lamp-AI is a hardware–software co-design lab: a small NPU (neural processing unit) built from scratch, controlled by a RISC-V CPU, using only open-source tools. Everything is open, from the RTL to the compiler, so anyone can study it, modify it, and make it better.

> ⚠️ Early stage. The first hardware blocks are working in simulation.

## Status

| Block | File | Status |
|---|---|---|
| 8-bit adder | `hw/rtl/adder8.sv` | ✅ passes exhaustive test (131,072 cases) |
| int8 MAC unit (multiply-accumulate) | `hw/rtl/mac.sv` | ✅ passes edge-case, dot-product and 1,000 random tests |
| 2×2 systolic array | | 🔜 next |

## Layout

```
hw/rtl/        SystemVerilog RTL                (CERN-OHL-P-2.0)
hw/sim/        testbenches, build output, waveforms
sw/compiler/   compiler (Rust, LLVM/MLIR)       (Apache-2.0)
sw/driver/     driver
docs/          documentation
```

## Getting started

You only need [Nix](https://nixos.org/download) with flakes enabled.

```sh
git clone https://github.com/polp45348-glitch/Lamp-AI
cd Lamp-AI

nix develop              # hardware: verilator, iverilog, yosys, verible, gtkwave, surfer, cocotb, riscv32 gcc
nix develop .#fpga       # + nextpnr, icestorm, trellis, apycula, openFPGALoader
nix develop .#compiler   # rust, llvm 18, mlir, cmake
```

## Run the tests

```sh
make sim  TOP=mac        # build + simulate -> PASS: all tests passed
make wave TOP=mac        # open the waveform
make sim  TOP=adder8     # -> PASS: adder8 (131072 cases)
make lint
make clean
```

To add a new block: create `hw/rtl/<name>.sv` and `hw/sim/<name>_tb.sv`, then run `make sim TOP=<name>`.

## Roadmap

1. Digital logic: gates, mux, adder, flip-flop, FSM (Nand2Tetris, HDLBits)
2. SystemVerilog, testbenches, reading waveforms
3. AI accelerator: ~~MAC~~ ✅, int8 datapath, systolic array
4. RISC-V CPU (RV32I) to control the NPU over MMIO, or an existing open-source core
5. Memory, bus, UART; run C programs on the SoC
6. Real FPGA (Tang Nano, iCESugar, ULX3S)
7. Driver and compiler; run a tiny model end to end (e.g. handwritten digits)

## Learning resources

- Harris & Harris, *Digital Design and Computer Architecture: RISC-V Edition*
- Patterson & Hennessy, *Computer Organization and Design: RISC-V Edition*
- Onur Mutlu, *Digital Design and Computer Architecture* lectures (YouTube)

## License

Hardware (`hw/`) is licensed under CERN-OHL-P-2.0; everything else is under Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

## Contributing

Ideas, issues and pull requests are welcome, whether you know hardware, compilers, or just want to learn alongside.
