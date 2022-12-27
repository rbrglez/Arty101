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

      -- RGB LEDs
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

      -- white LEDs
      led : out slv(3 downto 0);

      -- buttons
      btn : in slv(3 downto 0);

      -- switches
      sw : in slv(3 downto 0)

   );
end Arty101;
---------------------------------------------------------------------------------------------------    
architecture rtl of Arty101 is

   signal clk  : sl;
   signal rst  : sl;
   signal rstn : sl;

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

   led3_r <= '1';
   led3_g <= '1';
   led3_b <= '1';

   led2_r <= '1';
   led2_g <= '1';
   led2_b <= '1';

   led1_r <= '1';
   led1_g <= '1';
   led1_b <= '1';

   led0_r <= '1';
   led0_g <= '1';
   led0_b <= '1';

end rtl;
---------------------------------------------------------------------------------------------------