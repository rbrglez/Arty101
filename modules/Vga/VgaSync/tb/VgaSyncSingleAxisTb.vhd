--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : VgaSyncSingleAxisTb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Mon Jan  2 12:45:42 2023
-- Last update : Mon Jan  2 15:29:38 2023
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

entity VgaSyncSingleAxisTb is

end entity VgaSyncSingleAxisTb;

-----------------------------------------------------------

architecture testbench of VgaSyncSingleAxisTb is

   -- Constants
   constant T_C   : time := real((1 / (VESA_640x480_AT_75HZ_C.generalTiming.pixelFreq))) * sec;
   constant TPD_C : time := 1 ns;

   -- Testbench DUT ports
   signal clk_i : sl;
   signal rst_i : sl;

   signal cntEn_i : sl;
   signal cntEn_o : sl;

   signal cnt_o     : slv(32 - 1 downto 0);
   signal visible_o : sl;
   signal sync_o    : sl;

begin

   -----------------------------------------------------------
   -- Device Under Test
   -----------------------------------------------------------
   dut_VgaSyncSingleAxis : entity work.VgaSyncSingleAxis
      generic map (
         TPD_G        => TPD_C,
         VGA_TIMING_G => VESA_640x480_AT_75HZ_C.horizontalTiming
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         cntEn_i   => cntEn_i,
         cntEn_o   => cntEn_o,
         cnt_o     => cnt_o,
         visible_o => visible_o,
         sync_o    => sync_o
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
      cntEn_i <= '0';

      wait until rst_i = '0';
      wait for TPD_C;
      wait for 100 * T_C;

      -- Enable cntEn_i
      cntEn_i <= '1';

      wait for 10_000 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;

end architecture testbench;