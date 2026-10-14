# SPDX-License-Identifier: Apache-2.0
#
#   make sim  TOP=adder8   build + run hw/sim/$(TOP)_tb.sv with Verilator
#   make wave TOP=adder8   open the waveform in GTKWave
#   make lint              lint every file in hw/rtl
#   make clean

TOP      ?= adder8
RTL      := $(wildcard hw/rtl/*.sv)
TB       := hw/sim/$(TOP)_tb.sv
BUILD    := hw/sim/build/$(TOP)
VCD      := $(BUILD)/$(TOP).vcd

.PHONY: sim wave lint clean

sim: $(BUILD)/V$(TOP)_tb
	cd $(BUILD) && ./V$(TOP)_tb

$(BUILD)/V$(TOP)_tb: $(RTL) $(TB)
	mkdir -p $(BUILD)
	verilator --binary --timing --trace-vcd -Wall \
	  --top-module $(TOP)_tb --Mdir $(BUILD) \
	  $(RTL) $(TB)

wave: sim
	gtkwave $(VCD)

lint:
	verilator --lint-only -Wall $(RTL)
	verible-verilog-lint $(RTL) hw/sim/*.sv

clean:
	rm -rf hw/sim/build
