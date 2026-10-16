#!/usr/bin/env bash
# รันจากรากของ repo:  ./hw/sim/run.sh
set -euo pipefail
cd "$(dirname "$0")"
verilator --binary --timing --trace -Wall -Wno-fatal -Wno-fatal -Wno-fatal -Wno-UNUSEDSIGNAL \
    --top-module tb_mac -Mdir build \
    ../rtl/mac.v tb_mac.sv
./build/Vtb_mac
echo "เปิดคลื่นด้วย: gtkwave hw/sim/mac.vcd"
