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
      --------------------------------------------------------------------------
      -- ChipKit Outer Digital Header
      --------------------------------------------------------------------------
      -- Inputs (H5 - H8)
      ck_io0 : in sl; -- H8
      ck_io1 : in sl; -- H7
      ck_io2 : in sl; -- H6
      ck_io3 : in sl; -- H5

      -- Outputs (H1 - H4)
      ck_io8  : out sl; -- H4
      ck_io9  : out sl; -- H3
      ck_io10 : out sl; -- H2
      ck_io11 : out sl  -- H1
   );
end Arty101;
---------------------------------------------------------------------------------------------------    
architecture rtl of Arty101 is

   -- constants
   constant CLK_FREQ_C : real := 100.0E6;


   constant COL0_C : natural := 0;
   constant COL1_C : natural := 1;
   constant COL2_C : natural := 2;
   constant COL3_C : natural := 3;

   constant ROW0_C : natural := 0;
   constant ROW1_C : natural := 1;
   constant ROW2_C : natural := 2;
   constant ROW3_C : natural := 3;

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

   -----------------------------------------------------------------------------
   -- Debug declarations
   -----------------------------------------------------------------------------
   attribute mark_debug : string;

   attribute mark_debug of fwCol : signal is KEYPAD_DEBUG_C;
   attribute mark_debug of hwCol : signal is KEYPAD_DEBUG_C;

   attribute mark_debug of fwRow : signal is KEYPAD_DEBUG_C;
   attribute mark_debug of hwRow : signal is KEYPAD_DEBUG_C;

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- "Core"
   -----------------------------------------------------------------------------
   -- Control LEDs
   fwLeds <= fwBtn;

   -- Control RGB LEDs
   fwRgbLeds((0 + 1) * 3 - 1 downto 0 * 3) <= (others => fwSwitch(0));
   fwRgbLeds((1 + 1) * 3 - 1 downto 1 * 3) <= (others => fwSwitch(1));
   fwRgbLeds((2 + 1) * 3 - 1 downto 2 * 3) <= (others => fwSwitch(2));
   fwRgbLeds((3 + 1) * 3 - 1 downto 3 * 3) <= (others => fwSwitch(3));

   fwCol <= fwSwitch;

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

   -----------------------------------------------------------------------------
   --
   -----------------------------------------------------------------------------
   u_RowInputs : entity work.GeneralInputs
      generic map (
         TPD_G             => TPD_G,
         INPUT_WIDTH_G     => 4,
         CLK_FREQ_G        => CLK_FREQ_C,
         SYNC_STAGES_G     => 3,
         DEBOUNCE_PERIOD_G => 20.0E-3,
         HW_POLARITY_G     => '1',
         FW_POLARITY_G     => '1'
      )
      port map (
         clk_i      => clk,
         rst_i      => rst,
         hwInputs_i => hwRow,
         fwInputs_o => fwRow
      );

   hwRow(ROW0_C) <= ck_io3; -- Header 5
   hwRow(ROW1_C) <= ck_io2; -- Header 6
   hwRow(ROW2_C) <= ck_io1; -- Header 7
   hwRow(ROW3_C) <= ck_io0; -- Header 8

   u_ColumnOutputs : entity work.GeneralOutputs
      generic map (
         TPD_G          => TPD_G,
         OUTPUT_WIDTH_G => 4,
         SYNC_STAGES_G  => 2,
         HW_POLARITY_G  => '1'
      )
      port map (
         clk_i       => clk,
         rst_i       => rst,
         fwOutputs_i => fwCol,
         hwOutputs_o => hwCol
      );

   ck_io11 <= hwCol(COL0_C); -- Header 1
   ck_io10 <= hwCol(COL1_C); -- Header 2
   ck_io9  <= hwCol(COL2_C); -- Header 3
   ck_io8  <= hwCol(COL3_C); -- Header 4

end rtl;
---------------------------------------------------------------------------------------------------