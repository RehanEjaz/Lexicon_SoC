RTL_PATH = /home/hshabbir/Vector_Extension/Netlist_verification/
GCC_PREFIX?=riscv32-unknown-elf
PDK_PATH?=/home/merl-tools/openlane-rc5/sky130A


.SUFFIXES:

PATTERN = test_2

all:  clean ${PATTERN:=.vcd}

hex:  ${PATTERN:=.hex}

%.vvp: %_tb.v
	iverilog -DFUNCTIONAL -DSIM \
	-I $(PDK_PATH) -I $(RTL_PATH) \
	-o $@ $<

%.vcd: %.vvp
	vvp $<

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.log

.PHONY: clean hex all
