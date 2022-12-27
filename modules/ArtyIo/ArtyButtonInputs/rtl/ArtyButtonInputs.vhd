----------------------------------------------------------------------------------------------------
-- @brief ArtyButtonInputs
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file ArtyButtonInputs.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

----------------------------------------------------------------------------------------------------
entity ArtyButtonInputs is
   generic (
      TPD_G                : time    := 1 ns; -- simulated propagation delay
      CLK_FREQ_G           : real    := 100.0E6;
      INPUTS_SYNC_STAGES_G : natural := 3;
      DEBOUNCE_PERIOD_G    : real    := 20.0E-3
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      hwBtns_i : in  slv(4 - 1 downto 0); -- Inputs from hardware
      fwBtns_o : out slv(4 - 1 downto 0)  -- Outputs to firmware (sync + debounce)
   );
end ArtyButtonInputs;
----------------------------------------------------------------------------------------------------   
architecture rtl of ArtyButtonInputs is

   signal btnsSync : slv(hwBtns_i'range);

---------------------------------------------------------------------------------------------------
begin

   -- btns sync
   u_BtnsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => INPUTS_SYNC_STAGES_G,
         WIDTH_G  => hwBtns_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => hwBtns_i,
         dataOut => btnsSync
      );

   -- debounce btns
   GEN_DEBOUNCE_BTN : for I in hwBtns_i'range generate
      u_Debouncer : entity surf.Debouncer
         generic map (
            TPD_G             => TPD_G,
            CLK_FREQ_G        => CLK_FREQ_G,
            DEBOUNCE_PERIOD_G => DEBOUNCE_PERIOD_G,
            INPUT_POLARITY_G  => '1',
            OUTPUT_POLARITY_G => '1',
            SYNCHRONIZE_G     => false
         )
         port map (
            clk => clk_i,
            rst => rst_i,
            i   => btnsSync(I),
            o   => fwBtns_o(I)
         );
   end generate GEN_DEBOUNCE_BTN;

end rtl;
----------------------------------------------------------------------------------------------------