----------------------------------------------------------------------------------------------------
-- @brief KeypadArtyTest
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file KeypadArtyTest.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;
use work.KeypadArtyTestPkg.all;
use work.MarkDebugPkg.all;

entity KeypadArtyTest is
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
      -- ChipKit Outer Digital Header
      --------------------------------------------------------------------------
      -- Inputs 
      ck_io0 : in sl; -- Header 1
      ck_io1 : in sl; -- Header 2
      ck_io2 : in sl; -- Header 3
      ck_io3 : in sl; -- Header 4

      -- Outputs 
      ck_io8  : out sl; -- Header 8
      ck_io9  : out sl; -- Header 7
      ck_io10 : out sl; -- Header 6
      ck_io11 : out sl  -- Header 5
   );
end KeypadArtyTest;
---------------------------------------------------------------------------------------------------    
architecture rtl of KeypadArtyTest is

   signal clk : sl;
   signal rst : sl;

   -- inputs
   signal fwBtn    : slv(4 - 1 downto 0);
   signal fwSwitch : slv(4 - 1 downto 0);

   -- outputs
   signal fwLeds    : slv(4 - 1 downto 0);
   signal fwRgbLeds : slv(12 -1 downto 0);
   signal hwRgbLeds : slv(12 - 1 downto 0);

   -- Header 1 to 4
   signal fwCol : slv(4 - 1 downto 0);
   signal hwCol : slv(4 - 1 downto 0);

   -- Header 5 to 8
   signal fwRow : slv(4 - 1 downto 0);
   signal hwRow : slv(4 - 1 downto 0);

   signal actKeysUpd : sl;
   signal actKeys    : slv(16 - 1 downto 0);

   -----------------------------------------------------------------------------
   -- Debug declarations
   -----------------------------------------------------------------------------
   attribute mark_debug               : string;
   attribute mark_debug of clk        : signal is TOP_DEBUG_C;
   attribute mark_debug of fwCol      : signal is TOP_DEBUG_C;
   attribute mark_debug of hwCol      : signal is TOP_DEBUG_C;
   attribute mark_debug of fwRow      : signal is TOP_DEBUG_C;
   attribute mark_debug of hwRow      : signal is TOP_DEBUG_C;
   attribute mark_debug of actKeysUpd : signal is TOP_DEBUG_C;
   attribute mark_debug of actKeys    : signal is TOP_DEBUG_C;

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Core
   -----------------------------------------------------------------------------
   fwLeds <= actKeys((0 + 1) * 4 - 1 downto 0 * 4);

   fwRgbLeds(3 * 0 + 0) <= actKeys(1 * 4 + 0);
   fwRgbLeds(3 * 1 + 0) <= actKeys(1 * 4 + 1);
   fwRgbLeds(3 * 2 + 0) <= actKeys(1 * 4 + 2);
   fwRgbLeds(3 * 3 + 0) <= actKeys(1 * 4 + 3);

   fwRgbLeds(3 * 0 + 1) <= actKeys(2 * 4 + 0);
   fwRgbLeds(3 * 1 + 1) <= actKeys(2 * 4 + 1);
   fwRgbLeds(3 * 2 + 1) <= actKeys(2 * 4 + 2);
   fwRgbLeds(3 * 3 + 1) <= actKeys(2 * 4 + 3);

   fwRgbLeds(3 * 0 + 2) <= actKeys(3 * 4 + 0);
   fwRgbLeds(3 * 1 + 2) <= actKeys(3 * 4 + 1);
   fwRgbLeds(3 * 2 + 2) <= actKeys(3 * 4 + 2);
   fwRgbLeds(3 * 3 + 2) <= actKeys(3 * 4 + 3);

   u_KeypadDecoder : entity work.KeypadDecoder
      generic map (
         TPD_G => TPD_G,

         ROW_WIDTH_G => 4,
         COL_WIDTH_G => 4,

         COL_SAMPLE_DELAY_G => 500_000 -- This value must be larger than debounce period of col_i!
      )
      port map (
         clk_i => clk,
         rst_i => rst,
         en_i  => '1',

         row_o        => fwRow,
         col_i        => fwCol,
         actKeysUpd_o => actKeysUpd,
         actKeys_o    => actKeys
      );

   -----------------------------------------------------------------------------
   -- IO
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

   -- Keypad Column inputs
   u_ColInputs : entity work.GeneralInputs
      generic map (
         TPD_G         => TPD_G,
         WIDTH_G       => 4,
         STAGES_G      => 3,
         DEBOUNCE_CC_G => 1_000_000
      )
      port map (
         clk_i      => clk,
         rst_i      => rst,
         hwInputs_i => hwCol,
         fwInputs_o => fwCol
      );

   hwCol(COL0_C) <= ck_io3; -- Header 4
   hwCol(COL1_C) <= ck_io2; -- Header 3
   hwCol(COL2_C) <= ck_io1; -- Header 2
   hwCol(COL3_C) <= ck_io0; -- Header 1

   -- Keypad Row outputs
   u_RowOutputs : entity work.GeneralOutputs
      generic map (
         TPD_G    => TPD_G,
         WIDTH_G  => 4,
         STAGES_G => 2
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwOutputs_i => fwRow,
         hwOutputs_o => hwRow
      );

   ck_io11 <= hwRow(ROW0_C); -- Header 5
   ck_io10 <= hwRow(ROW1_C); -- Header 6
   ck_io9  <= hwRow(ROW2_C); -- Header 7
   ck_io8  <= hwRow(ROW3_C); -- Header 8

end rtl;
---------------------------------------------------------------------------------------------------