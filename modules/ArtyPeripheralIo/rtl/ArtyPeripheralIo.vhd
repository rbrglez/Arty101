----------------------------------------------------------------------------------------------------
-- @brief ArtyPeripheralIo
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file ArtyPeripheralIo.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity ArtyPeripheralIo is
   generic (
      TPD_G         : time    := 1 ns;
      DEBOUNCE_CC_G : natural := 20_000_000
   );
   port (
      --------------------------------------------------------------------------
      -- Inputs
      --------------------------------------------------------------------------
      -- Clock
      hwClk_i : in  sl;
      fwClk_o : out sl;
      -- Reset
      hwRst_i : in  sl;
      fwRst_o : out sl;
      -- Buttons
      hwBtns_i : in  slv(4 - 1 downto 0);
      fwBtns_o : out slv(4 - 1 downto 0);
      -- Switches
      hwSwitch_i : in  slv(4 - 1 downto 0);
      fwSwitch_o : out slv(4 - 1 downto 0);

      --------------------------------------------------------------------------
      -- Outputs
      --------------------------------------------------------------------------
      -- Leds
      fwLeds_i : in  slv(4 - 1 downto 0);
      hwLeds_o : out slv(4 - 1 downto 0);
      -- Rgb Leds
      fwRgbLeds_i : in  slv(12 - 1 downto 0);
      hwRgbLeds_o : out slv(12 - 1 downto 0)
   );
end ArtyPeripheralIo;
----------------------------------------------------------------------------------------------------   
architecture rtl of ArtyPeripheralIo is

   signal clk  : sl;
   signal rstn : sl;
   signal rst  : sl;

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Inputs
   -----------------------------------------------------------------------------
   -- Clock
   clk     <= hwClk_i;
   fwClk_o <= clk;

   -- Reset
   fwRst_o <= rst;
   rst     <= not(rstn);
   u_RstInput : entity work.GeneralInputs
      generic map (
         TPD_G         => TPD_G,
         WIDTH_G       => 1,
         STAGES_G      => 3,
         DEBOUNCE_CC_G => DEBOUNCE_CC_G
      )
      port map (
         clk_i         => clk,
         rst_i         => '0',
         hwInputs_i(0) => hwRst_i,
         fwInputs_o(0) => rstn
      );

   -- Buttons
   u_ButtonInputs : entity work.GeneralInputs
      generic map (
         TPD_G         => TPD_G,
         WIDTH_G       => 4,
         STAGES_G      => 3,
         DEBOUNCE_CC_G => DEBOUNCE_CC_G
      )
      port map (
         clk_i      => clk,
         rst_i      => rst,
         hwInputs_i => hwBtns_i,
         fwInputs_o => fwBtns_o
      );

   -- Switches
   u_SwitchInputs : entity work.GeneralInputs
      generic map (
         TPD_G         => TPD_G,
         WIDTH_G       => 4,
         STAGES_G      => 3,
         DEBOUNCE_CC_G => DEBOUNCE_CC_G
      )
      port map (
         clk_i      => clk,
         rst_i      => rst,
         hwInputs_i => hwSwitch_i,
         fwInputs_o => fwSwitch_o
      );

   -----------------------------------------------------------------------------
   -- Outputs
   -----------------------------------------------------------------------------
   -- Leds
   u_LedOutputs : entity work.GeneralOutputs
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => 4,
         STAGES_G => 2
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwOutputs_i => fwLeds_i,
         hwOutputs_o => hwLeds_o
      );

   -- Rgb Leds
   u_RgbLedOutputs : entity work.GeneralOutputs
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => 12,
         STAGES_G => 2
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwOutputs_i => fwRgbLeds_i,
         hwOutputs_o => hwRgbLeds_o
      );

end rtl;
----------------------------------------------------------------------------------------------------