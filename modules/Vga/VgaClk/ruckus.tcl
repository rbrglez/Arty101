# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

loadIpCore -dir "$::DIR_PATH/cores/"
