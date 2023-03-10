
# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load submodules' code and constraints
loadRuckusTcl $::env(TOP_DIR)/submodules/

# Load target's source code and constraints
loadSource      -dir  "$::DIR_PATH/src/"
loadConstraints  -dir  "$::DIR_PATH/src/"

# Load modules
loadRuckusTcl "$::env(TOP_DIR)/modules/GeneralIo"
loadRuckusTcl "$::env(TOP_DIR)/modules/ArtyPeripheralIo"
loadRuckusTcl "$::env(TOP_DIR)/modules/KeypadDecoder"
loadRuckusTcl "$::env(TOP_DIR)/modules/SegmentDisplay"