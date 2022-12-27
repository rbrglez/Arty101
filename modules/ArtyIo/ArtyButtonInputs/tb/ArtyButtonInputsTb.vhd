--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : ArtyButtonInputsTb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Tue Dec 27 11:26:36 2022
-- Last update : Tue Dec 27 11:40:41 2022
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2022 User Company Name
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

-----------------------------------------------------------

entity ArtyButtonInputsTb is

end entity ArtyButtonInputsTb;

-----------------------------------------------------------

architecture testbench of ArtyButtonInputsTb is

   -- Constants
   constant TPD_C : time := 1 ns;
   constant T_C   : time := 10 ns; -- NS

   constant CLK_FREQ_C           : real    := 100.0E6;
   constant INPUTS_SYNC_STAGES_C : natural := 3;
   constant DEBOUNCE_PERIOD_C    : real    := 1.0E-6;

   -- Testbench DUT ports
   signal clk_i    : sl;
   signal rst_i    : sl;
   signal hwBtns_i : slv(4 - 1 downto 0);
   signal fwBtns_o : slv(4 - 1 downto 0);

begin
   -----------------------------------------------------------
   -- Clocks and Reset
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
      hwBtns_i <= (others => '0');

      wait until rst_i = '0';
      wait for TPD_C;

      wait for 100 * T_C;

      hwBtns_i <= (others => '1');
      wait for 200 * T_C;

      hwBtns_i <= (others => '0');
      wait for 200 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;
   -----------------------------------------------------------
   -- Entity Under Test
   -----------------------------------------------------------
   DUT : entity work.ArtyButtonInputs
      generic map (
         TPD_G                => TPD_C,
         CLK_FREQ_G           => CLK_FREQ_C,
         INPUTS_SYNC_STAGES_G => INPUTS_SYNC_STAGES_C,
         DEBOUNCE_PERIOD_G    => DEBOUNCE_PERIOD_C
      )
      port map (
         clk_i    => clk_i,
         rst_i    => rst_i,
         hwBtns_i => hwBtns_i,
         fwBtns_o => fwBtns_o
      );

end architecture testbench;