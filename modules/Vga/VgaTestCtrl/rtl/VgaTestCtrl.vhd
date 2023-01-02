---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaTestCtrl.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;
use work.VgaPkg.all;

entity VgaTestCtrl is
   generic (
      TPD_G                   : time := 1 ns;
      VGA_HORIZONTAL_TIMING_G : VgaTimingType;
      VGA_VERTICAL_TIMING_G   : VgaTimingType
   );
   port (
      clk_i : in sl;
      rst_i : in sl;
      en_i  : in sl;

      hvisible_i : in sl;
      vvisible_i : in sl;

      hcnt_i : in slv(32 - 1 downto 0);
      vcnt_i : in slv(32 - 1 downto 0);

      -- 
      red_o   : out slv(4 - 1 downto 0);
      green_o : out slv(4 - 1 downto 0);
      blue_o  : out slv(4 - 1 downto 0)
   );
end VgaTestCtrl;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaTestCtrl is

   signal active : sl;

---------------------------------------------------------------------------------------------------
begin

   active <= hvisible_i and vvisible_i;

   -----------------------------------------------------------------------------
   -- TEST PATTERN LOGIC           
   -----------------------------------------------------------------------------
   red_o <=
      hcnt_i((4 + 2) - 1 downto 2) when (active = '1' and ((unsigned(hcnt_i) < VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      hcnt_i((4 + 3) - 1 downto 3) when (active = '1' and ((unsigned(hcnt_i) > VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      (others => '0');

   blue_o <=
      hcnt_i((4 + 2) - 1 downto 2) when (active = '1' and ((unsigned(hcnt_i) < VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      hcnt_i((4 + 4) - 1 downto 4) when (active = '1' and ((unsigned(hcnt_i) > VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      (others => '0');

   green_o <=
      hcnt_i((4 + 2) - 1 downto 2) when (active = '1' and ((unsigned(hcnt_i) < VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      hcnt_i((4 + 1) - 1 downto 1) when (active = '1' and ((unsigned(hcnt_i) > VGA_HORIZONTAL_TIMING_G.visibleArea / 2 and unsigned(vcnt_i) < VGA_VERTICAL_TIMING_G.visibleArea - 100))) else
      (others => '0');


end rtl;
---------------------------------------------------------------------------------------------------