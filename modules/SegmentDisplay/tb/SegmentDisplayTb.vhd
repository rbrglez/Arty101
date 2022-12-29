--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : SegmentDisplayTb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Thu Dec 29 09:47:53 2022
-- Last update : Thu Dec 29 21:20:35 2022
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

entity SegmentDisplayTb is

end entity SegmentDisplayTb;

-----------------------------------------------------------

architecture testbench of SegmentDisplayTb is

   -- Constants
   constant T_C   : time := 10 ns;
   constant TPD_C : time := 1 ns;

   -- dut ports
   signal clk_i : sl;
   signal rst_i : sl;

   signal en_i       : sl;
   signal data_i     : slv(4 - 1 downto 0);
   signal segments_o : slv(8 - 1 downto 0);

begin
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
      en_i   <= '0';
      data_i <= (others => '0');

      wait until rst_i = '0';
      wait for TPD_C;
      wait for 100 * T_C;

      -- Enable 
      en_i <= '1';
      wait for 200 * T_C;

      for J in 0 to 4 - 1 loop
         for I in 0 to (2 ** data_i'length) - 1 loop
            data_i <= slv(to_unsigned(I, data_i'length));
            wait for 200 * T_C;
         end loop;
         wait for 500 * T_C;
      end loop;

      wait for 1_000 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;

   -----------------------------------------------------------
   -- Entity Under Test
   -----------------------------------------------------------
   dut_SegmentDisplay : entity work.SegmentDisplay
      generic map (
         TPD_G => TPD_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         en_i => en_i,

         data_i     => data_i,
         segments_o => segments_o
      );

end architecture testbench;