----------------------------------------------------------------------------------------------------
-- @brief SegmentDisplayArtyTest
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file SegmentDisplayArtyTest.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;
use work.SegmentDisplayArtyTestPkg.all;
use work.SegmentDisplayPkg.all;
use work.MarkDebugPkg.all;

entity SegmentDisplayArtyTest is
   generic (
      TPD_G : time := 1 ns
   );
   port (
      -- clock
      CLK100MHZ : in sl;
      -- reset
      ck_rst : in sl;

      --------------------------------------------------------------------------
      -- Arty Peripherals on development board
      --------------------------------------------------------------------------
      -- buttons
      btn : in slv(4 - 1 downto 0);
      -- switches
      sw : in slv(4 - 1 downto 0);
      -- leds
      led : out slv(4 - 1 downto 0);
      -- rgb leds
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

      --------------------------------------------------------------------------
      -- ChipKit Inner Digital Header
      --------------------------------------------------------------------------
      -- Outputs 
      ck_io30 : out sl;
      ck_io31 : out sl;
      ck_io32 : out sl;
      ck_io33 : out sl;
      --
      ck_io38 : out sl;
      ck_io39 : out sl;
      ck_io40 : out sl;
      ck_io41 : out sl
   );
end SegmentDisplayArtyTest;
---------------------------------------------------------------------------------------------------    
architecture rtl of SegmentDisplayArtyTest is

   signal clk : sl;
   signal rst : sl;

   -- Peripheral Inputs
   signal fwBtn    : slv(4 - 1 downto 0);
   signal fwSwitch : slv(4 - 1 downto 0);

   -- Peripheral Outputs
   signal fwLeds    : slv(4 - 1 downto 0);
   signal fwRgbLeds : slv(12 -1 downto 0);
   signal hwRgbLeds : slv(12 - 1 downto 0);

   -- Seven Segment Display Outputs
   signal fwSegmentDisplay : slv(8 - 1 downto 0);
   signal hwSegmentDisplay : slv(8 - 1 downto 0);

   -----------------------------------------------------------------------------
   -- Debug declarations
   -----------------------------------------------------------------------------
   attribute mark_debug        : string;
   attribute mark_debug of clk : signal is TOP_DEBUG_C;

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Core
   -----------------------------------------------------------------------------
   u_SegmentDisplay : entity work.SegmentDisplay
      generic map (
         TPD_G => TPD_G
      )
      port map (
         clk_i => clk,
         rst_i => rst,

         en_i => '1',

         data_i     => fwSwitch,
         segments_o => fwSegmentDisplay
      );

   -----------------------------------------------------------------------------
   -- IOs
   -----------------------------------------------------------------------------
   -- Peripheral Io
   u_ArtyPeripheralIo : entity work.ArtyPeripheralIo
      generic map (
         TPD_G         => TPD_G,
         DEBOUNCE_CC_G => 20_000_000
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

   -- 7 Segment display IOs
   u_SegmentDisplayOutputs : entity work.GeneralOutputs
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => 8,
         STAGES_G => 2
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwOutputs_i => fwSegmentDisplay,
         hwOutputs_o => hwSegmentDisplay
      );

   ck_io41 <= hwSegmentDisplay(SEGMENT_E_C);
   ck_io40 <= hwSegmentDisplay(SEGMENT_D_C);
   ck_io39 <= hwSegmentDisplay(SEGMENT_C_C);
   ck_io38 <= hwSegmentDisplay(SEGMENT_DP_C);
   --
   ck_io33 <= hwSegmentDisplay(SEGMENT_G_C);
   ck_io32 <= hwSegmentDisplay(SEGMENT_F_C);
   ck_io31 <= hwSegmentDisplay(SEGMENT_A_C);
   ck_io30 <= hwSegmentDisplay(SEGMENT_B_C);

end rtl;
---------------------------------------------------------------------------------------------------