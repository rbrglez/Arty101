---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaPkg.vhd
--!
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

package VgaPkg is

   -- http://tinyvga.com/vga-timing

   -----------------------------------------------------------------------------

   type VgaGeneralTimingType is record
      screenRefreshRate : real;
      verticalRefresh   : real;
      pixelFreq         : real;
   end record VgaGeneralTimingType;

   type VgaTimingType is record
      visibleArea : natural;
      frontPorch  : natural;
      syncPulse   : natural;
      backPorch   : natural;
      whole       : natural;
   end record VgaTimingType;

   type VgaSettingsType is record
      generalTiming    : VgaGeneralTimingType;
      horizontalTiming : VgaTimingType;
      verticalTiming   : VgaTimingType;
   end record VgaSettingsType;

   -----------------------------------------------------------------------------

   constant VESA_640x480_AT_75HZ_C : VgaSettingsType := (

         generalTiming => (
         screenRefreshRate => 75.0,
         verticalRefresh   => 37.5E3,
         pixelFreq         => 31.5E6),

         horizontalTiming => (
         visibleArea => 640,
         frontPorch  => 16,
         syncPulse   => 64,
         backPorch   => 120,
         whole       => 840),

         verticalTiming => (
         visibleArea => 480,
         frontPorch  => 1,
         syncPulse   => 3,
         backPorch   => 16,
         whole       => 500)
      );

   constant VESA_640x350_AT_85HZ_C : VgaSettingsType := (

         generalTiming => (
         screenRefreshRate => 85.0,
         verticalRefresh   => 37.861E3,
         pixelFreq         => 31.5E6),

         horizontalTiming => (
         visibleArea => 640,
         frontPorch  => 32,
         syncPulse   => 64,
         backPorch   => 96,
         whole       => 832),

         verticalTiming => (
         visibleArea => 350,
         frontPorch  => 32,
         syncPulse   => 3,
         backPorch   => 60,
         whole       => 445)
      );

   constant VGA_TIMING_INIT_C : VgaTimingType := (
         visibleArea => 0,
         frontPorch  => 0,
         syncPulse   => 0,
         backPorch   => 0,
         whole       => 0
      );

end VgaPkg;

package body VgaPkg is
end package body VgaPkg;
