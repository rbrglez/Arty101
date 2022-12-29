--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : KeypadDecoderTb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Thu Dec 29 09:47:53 2022
-- Last update : Thu Dec 29 12:54:45 2022
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

entity KeypadDecoderTb is

end entity KeypadDecoderTb;

-----------------------------------------------------------

architecture testbench of KeypadDecoderTb is

   -- Constants
   constant T_C         : time     := 10 ns;
   constant TPD_C       : time     := 1 ns;
   constant ROW_WIDTH_C : positive := 4;
   constant COL_WIDTH_C : positive := 4;

   -- dut ports
   signal clk_i : sl;
   signal rst_i : sl;

   signal en_i  : sl;
   signal row_o : slv(ROW_WIDTH_C - 1 downto 0);
   signal col_i : slv(COL_WIDTH_C - 1 downto 0);
   signal actKeysUpd_o : sl;
   signal actKeys_o    : slv(ROW_WIDTH_C * COL_WIDTH_C - 1 downto 0);

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
      en_i  <= '0';
      col_i <= (others => '0');

      wait until rst_i = '0';
      wait for TPD_C;

      wait for 100 * T_C;

      en_i <= '1';
      wait for 200 * T_C;

      col_i <= x"1";
      wait for 200 * T_C;

      col_i <= x"8";
      wait for 200 * T_C;


      wait for 1_000 * T_C;
      wait for 1_000 * T_C;
      wait for 1_000 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;

   -----------------------------------------------------------
   -- Entity Under Test
   -----------------------------------------------------------
   dut_KeypadDecoder : entity work.KeypadDecoder
      generic map (
         TPD_G       => TPD_C,
         ROW_WIDTH_G => ROW_WIDTH_C,
         COL_WIDTH_G => COL_WIDTH_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         en_i => en_i,

         row_o => row_o,
         col_i => col_i,

         actKeysUpd_o => actKeysUpd_o,
         actKeys_o    => actKeys_o

      );

end architecture testbench;