--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : VgaSyncCtrlTb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Mon Jan  2 12:45:42 2023
-- Last update : Mon Jan  2 15:13:09 2023
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2023 User Company Name
-------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
-- Revisions:  Revisions and documentation are controlled by
-- the revision control system (RCS).  The RCS should be consulted
-- on revision history.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
library surf;
use surf.StdRtlPkg.all;
use work.VgaPkg.all;

-----------------------------------------------------------

entity VgaSyncCtrlTb is

end entity VgaSyncCtrlTb;

-----------------------------------------------------------

architecture testbench of VgaSyncCtrlTb is

   -- Constants
   constant VGA_SETTINGS_C : VgaSettingsType := VESA_640x480_AT_75HZ_C;

   constant T_C   : time := real((1 / (VGA_SETTINGS_C.generalTiming.pixelFreq))) * sec;
   constant TPD_C : time := 1 ns;

   -- Testbench DUT ports
   signal clk_i : sl;
   signal rst_i : sl;
   signal en_i  : sl;

   signal hsync_o    : sl;
   signal hvisible_o : sl;
   signal hcnt_o     : slv(32 - 1 downto 0);

   signal vsync_o    : sl;
   signal vvisible_o : sl;
   signal vcnt_o     : slv(32 - 1 downto 0);

begin

   -----------------------------------------------------------
   -- Device Under Test
   -----------------------------------------------------------
   dut_VgaSyncCtrl : entity work.VgaSyncCtrl
      generic map (
         TPD_G                   => TPD_C,
         VGA_HORIZONTAL_TIMING_G => VGA_SETTINGS_C.horizontalTiming,
         VGA_VERTICAL_TIMING_G   => VGA_SETTINGS_C.verticalTiming
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,
         en_i  => en_i,

         hsync_o    => hsync_o,
         hvisible_o => hvisible_o,
         hcnt_o     => hcnt_o,

         vsync_o    => vsync_o,
         vvisible_o => vvisible_o,
         vcnt_o     => vcnt_o
      );

   -----------------------------------------------------------
   -- Clock and Reset
   -----------------------------------------------------------
   p_ClkGen : process
   begin
      clk_i <= '1';
      wait for T_C / 2;
      clk_i <= '0';
      wait for T_C / 2;
   end process p_ClkGen;

   p_RstGen : process
   begin
      rst_i <= '1',
         '0' after 10 * T_C;
      wait;
   end process p_RstGen;

   -----------------------------------------------------------
   -- Testbench Stimulus
   -----------------------------------------------------------
   p_Sim : process
   begin
      -- initialize inputs
      en_i <= '0';

      wait until rst_i = '0';
      wait for TPD_C;
      wait for 100 * T_C;

      -- Enable en_i
      en_i <= '1';

      for J in 0 to 4 - 1 loop
         for I in 0 to VGA_SETTINGS_C.verticalTiming.whole - 1 loop
            wait for VGA_SETTINGS_C.horizontalTiming.whole * T_C;
         end loop;
      end loop;

      wait for 100 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;

end architecture testbench;