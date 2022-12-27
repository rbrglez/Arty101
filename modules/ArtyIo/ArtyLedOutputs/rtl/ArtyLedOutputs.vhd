----------------------------------------------------------------------------------------------------
-- @brief ArtyLedOutputs
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file ArtyLedOutputs.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity ArtyLedOutputs is
   generic (
      TPD_G         : time    := 1 ns; -- simulated propagation delay
      SYNC_STAGES_G : natural := 2
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      fwLeds_i : in  slv(4 - 1 downto 0); -- Inputs from firmware
      hwLeds_o : out slv(4 - 1 downto 0)  -- Outputs to hardware (sync)
   );
end ArtyLedOutputs;
----------------------------------------------------------------------------------------------------   
architecture rtl of ArtyLedOutputs is

---------------------------------------------------------------------------------------------------
begin

   -- leds sync
   u_LedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => SYNC_STAGES_G,
         WIDTH_G  => fwLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwLeds_i,
         dataOut => hwLeds_o
      );

end rtl;
----------------------------------------------------------------------------------------------------