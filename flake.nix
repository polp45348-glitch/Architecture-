{
  description = "Open-Source AI SoC Hardware-Software Co-Design Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs:
        let
          riscv = pkgs.pkgsCross.riscv32-embedded.buildPackages;
        in
        {
          # Hardware: RTL, simulation, lint, RISC-V toolchain
          # nix develop
          default = pkgs.mkShell {
            packages = with pkgs; [
              verilator
              iverilog
              yosys
              verible
              gtkwave
              surfer
              gnumake

              (python313.withPackages (ps: with ps; [ cocotb pytest ]))

              riscv.gcc
              riscv.binutils
            ];

            shellHook = ''
              echo "=== AI SoC: hardware shell ==="
              echo "$(verilator --version)"
            '';
          };

          # FPGA: synthesis -> place & route -> flash
          # nix develop .#fpga
          fpga = pkgs.mkShell {
            inputsFrom = [ self.devShells.${pkgs.stdenv.hostPlatform.system}.default ];
            packages = with pkgs; [
              nextpnr
              icestorm             # Lattice iCE40 (iCESugar, iCEBreaker)
              trellis              # Lattice ECP5 (ULX3S)
              python313Packages.apycula # Gowin (Tang Nano)
              openfpgaloader
            ];
          };

          # Software: compiler (Rust + LLVM/MLIR) and driver
          # nix develop .#compiler
          compiler = pkgs.mkShell {
            packages = with pkgs; [
              rustc
              cargo
              rustfmt
              clippy
              rust-analyzer

              llvmPackages_18.llvm
              llvmPackages_18.mlir
              llvmPackages_18.clang-tools
              cmake

              flex
              bison
              elfutils
            ];
          };
        });
    };
}
