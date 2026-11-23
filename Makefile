# make lint | make bit | make clean
#
#
# vars
VIVADO := /opt/Xilinx/2026.1/Vivado/bin/vivado
PART   := xc7a35tcpg236-1
TOP    := Top_Module
BUILD  := build
RTL    := $(wildcard rtl/*.v)
XDC    := constraints/con.xdc
SCRIPT := scripts/build_artix_7.tcl

.PHONY: all lint test bit clean

all: bit

lint:
	verilator --lint-only -Wall -Irtl --top-module $(TOP) $(RTL)

test:
	cd tb && uv run pytest

bit: $(BUILD)/artix7/dds.bit

$(BUILD)/artix7/dds.bit: $(RTL) $(XDC) $(SCRIPT)
	mkdir -p $(BUILD) && cd $(BUILD) && $(VIVADO) -mode batch -source ../$(SCRIPT) -tclargs $(PART) $(TOP) $(CURDIR)/$(BUILD)/artix7

clean:
	rm -rf $(BUILD)
