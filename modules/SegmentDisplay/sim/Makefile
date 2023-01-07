
ifndef SIM_DIR
export SIM_DIR = $(abspath $(PWD))
endif

ifndef VHDL_VER
export VHDL_VER = "08"
endif

ifndef WORK_DIR
export WORK_DIR = "tbBuild"
endif

all:
	@ ghdl -i --std=$(VHDL_VER) --workdir=$(WORK_DIR) ../rtl/*.vhd ../tb/*.vhd
	@ ghdl -i --std=$(VHDL_VER) --workdir=$(WORK_DIR) ../../../submodules/surf/base/general/rtl/StdRtlPkg.vhd
	@ ghdl -m --std=$(VHDL_VER) --workdir=$(WORK_DIR) SegmentDisplayTb
	@ ghdl -r --std=$(VHDL_VER) --workdir=$(WORK_DIR) SegmentDisplayTb --wave=SegmentDisplayWave.ghw

clean:
	@ rm *.ghw tbBuild/*

test:
	@ echo VHDL_VER: $(VHDL_VER)
	@ echo WORK_DIR: $(WORK_DIR)
	@ echo SIM_DIR:  $(SIM_DIR)

wave:
	@ gtkwave SegmentDisplayWave.ghw