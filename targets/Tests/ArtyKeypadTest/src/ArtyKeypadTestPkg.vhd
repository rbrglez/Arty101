---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file ArtyKeypadTestPkg.vhd
--!
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

package ArtyKeypadTestPkg is

   constant CLK_FREQ_C : real := 100.0E6;

   constant COL0_C : natural := 0;
   constant COL1_C : natural := 1;
   constant COL2_C : natural := 2;
   constant COL3_C : natural := 3;

   constant ROW0_C : natural := 0;
   constant ROW1_C : natural := 1;
   constant ROW2_C : natural := 2;
   constant ROW3_C : natural := 3;

end ArtyKeypadTestPkg;

package body ArtyKeypadTestPkg is

end package body ArtyKeypadTestPkg;
