----------------------------------------------------------------------------------------------------
-- @brief GeneralInputsTb
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file GeneralInputsTb.vhd
--
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.StdRtlPkg.all;

-----------------------------------------------------------
entity GeneralInputsTb is
end entity GeneralInputsTb;
-----------------------------------------------------------

architecture testbench of GeneralInputsTb is

   -- Constants
   constant TPD_C : time := 1 ns;
   constant T_C   : time := 10 ns; -- NS

   constant WIDTH_C    : natural := 4;
   constant STAGES_C   : natural := 3;
   constant DEBOUNCE_C : natural := 100;

   -- dut ports
   signal clk_i      : sl;
   signal rst_i      : sl;
   signal hwInputs_i : slv(WIDTH_C - 1 downto 0);
   signal fwInputs_o : slv(WIDTH_C - 1 downto 0);

begin
   -----------------------------------------------------------
   -- Device Under Test
   -----------------------------------------------------------
   dut_GeneralInputs : entity work.GeneralInputs
      generic map (
         TPD_G         => TPD_C,
         WIDTH_G       => WIDTH_C,
         STAGES_G      => STAGES_C,
         DEBOUNCE_CC_G => DEBOUNCE_CC_C
      )
      port map (
         clk_i      => clk_i,
         rst_i      => rst_i,
         hwInputs_i => hwInputs_i,
         fwInputs_o => fwInputs_o
      );

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
      hwInputs_i <= (others => '0');

      wait until rst_i = '0';
      wait for TPD_C;

      wait for 100 * T_C;

      hwInputs_i <= (others => '1');
      wait for 200 * T_C;

      hwInputs_i <= (others => '0');
      wait for 200 * T_C;

      assert false report "Simulation completed" severity failure;

   end process p_Sim;

end architecture testbench;