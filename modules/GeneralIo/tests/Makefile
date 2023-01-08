# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

TOPLEVEL_LANG ?= vhdl
SIM ?= ghdl

PWD=$(shell pwd)

VHDL_LIB_DIR=$(PWD)/../../../submodules/vhdlLib

VHDL_SOURCES += $(PWD)/../rtl/GeneralOutputs.vhd 
VHDL_SOURCES += $(VHDL_LIB_DIR)/general/rtl/StdRtlPkg.vhd
VHDL_SOURCES += $(VHDL_LIB_DIR)/general/rtl/Sync.vhd
VHDL_SOURCES += $(VHDL_LIB_DIR)/general/rtl/SyncVec.vhd

EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

TOPLEVEL    := generaloutputs
MODULE      := generalOutputsTest

include $(shell cocotb-config --makefiles)/Makefile.sim
