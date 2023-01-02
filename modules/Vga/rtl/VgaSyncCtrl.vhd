---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncCtrl.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaSyncCtrl is
   generic (
      TPD_G                   : time := 1 ns;
      VGA_HORIZONTAL_TIMING_G : VgaTimingType;
      VGA_VERTICAL_TIMING_G   : VgaTimingType
   );
   port (
      clk_i : in sl;
      rst_i : in sl;
      en_i  : in sl;
      -- horizontal
      hsync_o    : out sl;
      hvisible_o : out sl;
      hcnt_o     : out slv(32 - 1 downto 0);
      -- vertical
      vsync_o    : out sl;
      vvisible_o : out sl;
      vcnt_o     : out slv(32 - 1 downto 0)
   );
end VgaSyncCtrl;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncCtrl is

   signal hSyncEn : sl;

---------------------------------------------------------------------------------------------------
begin

   u_HorizontalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G        => TPD_G,
         VGA_TIMING_G => VGA_HORIZONTAL_TIMING_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         cntEn_i => en_i,
         cntEn_o => hSyncEn,

         cnt_o     => hcnt_o,
         visible_o => hvisible_o,
         sync_o    => hsync_o
      );

   u_VerticalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G        => TPD_G,
         VGA_TIMING_G => VGA_VERTICAL_TIMING_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         cntEn_i => hSyncEn,
         cntEn_o => open,

         cnt_o     => vcnt_o,
         visible_o => vvisible_o,
         sync_o    => vsync_o
      );

end rtl;
---------------------------------------------------------------------------------------------------