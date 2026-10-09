{
  description = "Open-Source AI SoC Hardware-Software Co-Design Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Hardware Simulation & EDA
          verilator
          gtkwave
          yosys
          yosys-ghdl
          
          # Software & Compiler Infrastructure
          rustc
          cargo
          llvmPackages_18.llvm
          llvmPackages_18.mlir
          clang-tools
          cmake
          
          # Kernel Dev
          flex
          bison
          elfutils
        ];

        shellHook = ''
          echo "=== Open-Source AI SoC Dev Environment Loaded ==="
          echo "Verilator Version: $(verilator --version)"
          echo "Rust Version: $(rustc --version)"
        '';
      };
    };
}