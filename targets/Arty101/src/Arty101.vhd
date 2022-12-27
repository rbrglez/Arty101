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

end rtl;
---------------------------------------------------------------------------------------------------