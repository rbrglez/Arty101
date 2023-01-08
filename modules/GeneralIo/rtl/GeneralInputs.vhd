----------------------------------------------------------------------------------------------------
-- @brief GeneralInputs
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file GeneralInputs.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity GeneralInputs is
   generic (
      TPD_G         : time    := 1 ns; -- simulated propagation delay
      WIDTH_G       : natural := 4;
      STAGES_G      : natural := 3;
      DEBOUNCE_CC_G : natural := 2_000_000 -- 20ms @ 100MHz
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      hwInputs_i : in  slv(WIDTH_G - 1 downto 0); -- Physical inputs (from hardware)
      fwInputs_o : out slv(WIDTH_G - 1 downto 0)  -- Synced and Debounced Inputs (to firmware)
   );
end GeneralInputs;
----------------------------------------------------------------------------------------------------   
architecture rtl of GeneralInputs is

   signal hwSync : slv(WIDTH_G - 1 downto 0);

---------------------------------------------------------------------------------------------------
begin

   -- synchronize inputs
   u_SyncVec : entity work.SyncVec
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => WIDTH_G,
         STAGES_G => STAGES_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,
         sig_i => hwInputs_i,
         sig_o => hwSync
      );

   -- debounce inputs
   GEN_DEBOUNCE : for I in WIDTH_G - 1 downto 0 generate
      ux_Debouncer : entity work.Debouncer
         generic map (
            TPD_G         => TPD_G,
            DEBOUNCE_CC_G => DEBOUNCE_CC_G
         )
         port map (
            clk_i => clk_i,
            rst_i => rst_i,
            sig_i => hwSync(I),
            sig_o => fwInputs_o(I)
         );
   end generate GEN_DEBOUNCE;

end rtl;
----------------------------------------------------------------------------------------------------