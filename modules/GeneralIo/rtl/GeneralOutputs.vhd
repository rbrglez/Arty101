----------------------------------------------------------------------------------------------------
-- @brief GeneralOutputs
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file GeneralOutputs.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity GeneralOutputs is
   generic (
      TPD_G    : time    := 1 ns; -- simulated propagation delay
      WIDTH_G  : natural := 4;
      STAGES_G : natural := 2
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      fwOutputs_i : in  slv(WIDTH_G - 1 downto 0); -- Outputs (from firmware)
      hwOutputs_o : out slv(WIDTH_G - 1 downto 0)  -- Synced Physical Outputs (to hardware)
   );
end GeneralOutputs;
----------------------------------------------------------------------------------------------------   
architecture rtl of GeneralOutputs is

---------------------------------------------------------------------------------------------------
begin
   -- synchronize outputs
   u_OutputsSync : entity work.SyncVec
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => WIDTH_G,
         STAGES_G => STAGES_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,
         sig_i => fwOutputs_i,
         sig_o => hwOutputs_o
      );

end rtl;
----------------------------------------------------------------------------------------------------