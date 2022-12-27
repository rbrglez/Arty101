---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file Arty101.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library unisim;
use unisim.VComponents.all;

library surf;
use surf.StdRtlPkg.all;

use work.MarkDebugPkg.all;

entity Arty101 is
   generic (
      TPD_G : time := 1 ns
   );
   port (
      CLK100MHZ : in sl;
      ck_rst    : in sl;

      sw : in slv(4 - 1 downto 0);

      led0_b : out sl;
      led0_g : out sl;
      led0_r : out sl;
      led1_b : out sl;
      led1_g : out sl;
      led1_r : out sl;
      led2_b : out sl;
      led2_g : out sl;
      led2_r : out sl;
      led3_b : out sl;
      led3_g : out sl;
      led3_r : out sl;

      led : out slv(4 - 1 downto 0); -- led physical outputs
      btn : in  slv(4 - 1 downto 0)  -- button physical inputs
   );
end Arty101;
---------------------------------------------------------------------------------------------------    
architecture rtl of Arty101 is

   signal clk  : sl;
   signal rst  : sl;
   signal rstn : sl;

   signal btn2led : slv(4 - 1 downto 0);

   signal rgbLeds : slv(12 - 1 downto 0);

   signal fwSwitch  : slv(4 - 1 downto 0);
   signal fwRgbLeds : slv(12 -1 downto 0);


---------------------------------------------------------------------------------------------------
begin

   -- clock and reset signals
   clk <= CLK100MHZ;
   rst <= not(rstn);

   -- if BUF isn't included there are errors
   u_BUF : entity work.BUF
      port map (
         O => rstn,
         I => ck_rst
      );

   -----------------------------------------------------------------------------
   -- IO
   -----------------------------------------------------------------------------
   u_Ledoutputs : entity work.ArtyLedOutputs
      generic map (
         TPD_G         => TPD_G,
         SYNC_STAGES_G => 2
      )
      port map (
         clk_i    => clk,
         rst_i    => rst,
         fwLeds_i => btn2led,
         hwLeds_o => led
      );

   led0_r <= rgbLeds(0 + 0);
   led0_g <= rgbLeds(0 + 1);
   led0_b <= rgbLeds(0 + 2);

   led1_r <= rgbLeds(1 + 0);
   led1_g <= rgbLeds(1 + 1);
   led1_b <= rgbLeds(1 + 2);

   led2_r <= rgbLeds(2 + 0);
   led2_g <= rgbLeds(2 + 1);
   led2_b <= rgbLeds(2 + 2);

   led3_r <= rgbLeds(3 + 0);
   led3_g <= rgbLeds(3 + 1);
   led3_b <= rgbLeds(3 + 2);

   fwRgbLeds((0 + 1) * 3 - 1 downto 0 * 3) <= (others => fwSwitch(0));
   fwRgbLeds((1 + 1) * 3 - 1 downto 1 * 3) <= (others => fwSwitch(1));
   fwRgbLeds((2 + 1) * 3 - 1 downto 2 * 3) <= (others => fwSwitch(2));
   fwRgbLeds((3 + 1) * 3 - 1 downto 3 * 3) <= (others => fwSwitch(3));

   u_RgbLedOutputs : entity work.ArtyRgbLedOutputs
      generic map (
         TPD_G         => TPD_G,
         SYNC_STAGES_G => 2
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwRgbLeds_i => fwRgbLeds,
         hwRgbLeds_o => rgbLeds
      );

   u_BtnInputs : entity work.ArtyButtonInputs
      generic map (
         TPD_G                => TPD_G,
         CLK_FREQ_G           => 100.0E6,
         INPUTS_SYNC_STAGES_G => 3,
         DEBOUNCE_PERIOD_G    => 20.0E-3
      )
      port map (
         clk_i    => clk,
         rst_i    => rst,
         hwBtns_i => btn,
         fwBtns_o => btn2led
      );

   u_SwitchInputs : entity work.ArtySwitchInputs
      generic map (
         TPD_G                => TPD_G,
         CLK_FREQ_G           => 100.0E6,
         INPUTS_SYNC_STAGES_G => 3,
         DEBOUNCE_PERIOD_G    => 20.0E-3
      )
      port map (
         clk_i      => clk,
         rst_i      => rst,
         hwSwitch_i => sw,
         fwSwitch_o => fwSwitch
      );

end rtl;
---------------------------------------------------------------------------------------------------