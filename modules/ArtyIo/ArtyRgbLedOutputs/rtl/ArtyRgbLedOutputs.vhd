----------------------------------------------------------------------------------------------------
-- @brief ArtyRgbLedOutputs
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file ArtyRgbLedOutputs.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity ArtyRgbLedOutputs is
   generic (
      TPD_G         : time    := 1 ns; -- simulated propagation delay
      SYNC_STAGES_G : natural := 2
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      fwRgbLeds_i : in  slv(12 - 1 downto 0); -- Inputs from firmware
      hwRgbLeds_o : out slv(12 - 1 downto 0)  -- Outputs to hardware (sync)
   );
end ArtyRgbLedOutputs;
----------------------------------------------------------------------------------------------------   
architecture rtl of ArtyRgbLedOutputs is

---------------------------------------------------------------------------------------------------
begin

   -- leds sync
   u_LedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => SYNC_STAGES_G,
         WIDTH_G  => fwRgbLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwRgbLeds_i,
         dataOut => hwRgbLeds_o
      );

end rtl;
----------------------------------------------------------------------------------------------------