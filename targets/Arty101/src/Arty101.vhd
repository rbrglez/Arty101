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

      btn    : in  slv(4 - 1 downto 0);
      sw     : in  slv(4 - 1 downto 0);
      led    : out slv(4 - 1 downto 0);
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

   );
end Arty101;
---------------------------------------------------------------------------------------------------    
architecture rtl of Arty101 is

   -- constants
   constant CLK_FREQ_C : real := 100.0E6;

   signal clk  : sl;
   signal rst  : sl;

   -- inputs
   signal fwBtn    : slv(4 - 1 downto 0);
   signal fwSwitch : slv(4 - 1 downto 0);

   -- outputs
   signal fwLeds    : slv(4 - 1 downto 0);
   signal fwRgbLeds : slv(12 -1 downto 0);
   signal hwRgbLeds : slv(12 - 1 downto 0);

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- "Core"
   -----------------------------------------------------------------------------
   -- Control LEDs
   fwLeds <= fwBtn;

   -- Control Rcb LEDs
   fwRgbLeds((0 + 1) * 3 - 1 downto 0 * 3) <= (others => fwSwitch(0));
   fwRgbLeds((1 + 1) * 3 - 1 downto 1 * 3) <= (others => fwSwitch(1));
   fwRgbLeds((2 + 1) * 3 - 1 downto 2 * 3) <= (others => fwSwitch(2));
   fwRgbLeds((3 + 1) * 3 - 1 downto 3 * 3) <= (others => fwSwitch(3));

   -----------------------------------------------------------------------------
   -- IOs
   -----------------------------------------------------------------------------
   u_Arty101Io : entity work.Arty101Io
      generic map (
         TPD_G             => TPD_G,
         CLK_FREQ_G        => CLK_FREQ_C,
         DEBOUNCE_PERIOD_G => 20.0E-3
      )
      port map (
         hwClk_i => CLK100MHZ,
         fwClk_o => clk,

         hwRst_i => ck_rst,
         fwRst_o => rst,

         hwBtns_i => btn,
         fwBtns_o => fwBtn,

         hwSwitch_i => sw,
         fwSwitch_o => fwSwitch,

         fwLeds_i => fwLeds,
         hwLeds_o => led,

         fwRgbLeds_i => fwRgbLeds,
         hwRgbLeds_o => hwRgbLeds
      );

   led0_r <= hwRgbLeds(0 + (0 * 3));
   led0_g <= hwRgbLeds(1 + (0 * 3));
   led0_b <= hwRgbLeds(2 + (0 * 3));

   led1_r <= hwRgbLeds(0 + (1 * 3));
   led1_g <= hwRgbLeds(1 + (1 * 3));
   led1_b <= hwRgbLeds(2 + (1 * 3));

   led2_r <= hwRgbLeds(0 + (2 * 3));
   led2_g <= hwRgbLeds(1 + (2 * 3));
   led2_b <= hwRgbLeds(2 + (2 * 3));

   led3_r <= hwRgbLeds(0 + (3 * 3));
   led3_g <= hwRgbLeds(1 + (3 * 3));
   led3_b <= hwRgbLeds(2 + (3 * 3));

end rtl;
---------------------------------------------------------------------------------------------------