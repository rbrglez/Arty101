################################################################################
## This file generates ILAs. 
## Each design can have several ILAs. 
## The only limitation is that each ILA must be connected to a single clock.
##
## Each ILA is configured by:
##  -On/Off toggle  "enable", 
##  -Sample length  "size", 
##  -Source clock   "clock",
##  -Reference name "name"
##
################################################################################

################################################################################
# Get variables and procedures
################################################################################
source -quiet $::env(RUCKUS_DIR)/vivado/env_var.tcl
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

################################################################################
## Open the synthesis design
################################################################################
open_run synth_1

################################################################################
## Insert ILAs
################################################################################

################################################################################
# Random_ILA_Template
set ILA(enable) 0
set ILA(size)   1024
set ILA(name)   "thisIlaName"
set ILA(clock)  "thisIlaClock"

if {$ILA(enable) == 1} {
   set ILA(unit) "u_ila_$ILA(name)"
   CreateDebugCore ${ILA(unit)}
   set_property C_DATA_DEPTH $ILA(size) [get_debug_cores ${ILA(unit)}]
   SetDebugCoreClk ${ILA(unit)} ${ILA(clock)}

   # Define probes
   ConfigProbe ${ILA(unit)} {simLate}
   ConfigProbe ${ILA(unit)} {u_CoreLogicSim/////u_EthRxPktParse/r[resp][*]}

   WriteDebugProbes ${ILA(unit)} ${PROJ_DIR}/images/debug_probes.ltx
}
################################################################################

################################################################################
# Keypad chipscope
set ILA(enable) 0
set ILA(size)   1024
set ILA(name)   "keypad"
set ILA(clock)  "clk"

if {$ILA(enable) == 1} {
   set ILA(unit) "u_ila_$ILA(name)"
   CreateDebugCore ${ILA(unit)}
   set_property C_DATA_DEPTH $ILA(size) [get_debug_cores ${ILA(unit)}]
   SetDebugCoreClk ${ILA(unit)} ${ILA(clock)}

   # Outputs
   ConfigProbe ${ILA(unit)} {fwCol[*]}
   ConfigProbe ${ILA(unit)} {hwCol[*]}

   # Inputs
   ConfigProbe ${ILA(unit)} {fwRow[*]}
   ConfigProbe ${ILA(unit)} {hwRow[*]}

   # KeypadDecoder
   ConfigProbe ${ILA(unit)} {actKeysUpd}
   ConfigProbe ${ILA(unit)} {actKeys[*]}

   ConfigProbe ${ILA(unit)} {decRow0[*]}
   ConfigProbe ${ILA(unit)} {decRow1[*]}
   ConfigProbe ${ILA(unit)} {decRow2[*]}
   ConfigProbe ${ILA(unit)} {decRow3[*]}


   WriteDebugProbes ${ILA(unit)} ${PROJ_DIR}/images/debug_probes.ltx
}
################################################################################
