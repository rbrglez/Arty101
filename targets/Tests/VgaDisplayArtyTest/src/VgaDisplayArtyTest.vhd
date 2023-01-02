----------------------------------------------------------------------------------------------------
-- @brief VgaDisplayArtyTest
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date December 2022
-- 
-- @version v0.1
--
-- @file VgaDisplayArtyTest.vhd
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;
use work.VgaDisplayArtyTestPkg.all;
use work.VgaPkg.all;
use work.MarkDebugPkg.all;

entity VgaDisplayArtyTest is
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
      --
      --------------------------------------------------------------------------
      -- PMOD VGA
      ja : out slv(8 - 1 downto 0);
      jb : out slv(8 - 1 downto 0)

   );
end VgaDisplayArtyTest;
---------------------------------------------------------------------------------------------------    
architecture rtl of VgaDisplayArtyTest is


   constant BORDER_WIDTH_C : natural := 8;

   constant PADDLE_LEFT_C   : natural := 28;
   constant PADDLE_RIGHT_C  : natural := PADDLE_LEFT_C + 8;
   constant PADDLE_TOP_C    : natural := 100;
   constant PADDLE_BOTTOM_C : natural := PADDLE_TOP_C + 64;

   constant BALL_LEFT_C   : natural := 300;
   constant BALL_RIGHT_C  : natural := BALL_LEFT_C + 8;
   constant BALL_TOP_C    : natural := 300;
   constant BALL_BOTTOM_C : natural := BALL_TOP_C + 8;


   constant PADDLE_V_POS_C : natural := 100;

   constant BALL_H_POS_C : natural := 300;
   constant BALL_V_POS_C : natural := 300;


   signal clk : sl;
   signal rst : sl;

   -- Peripheral Inputs
   signal fwBtn    : slv(4 - 1 downto 0);
   signal fwSwitch : slv(4 - 1 downto 0);

   -- Peripheral Outputs
   signal fwLeds    : slv(4 - 1 downto 0);
   signal fwRgbLeds : slv(12 -1 downto 0);
   signal hwRgbLeds : slv(12 - 1 downto 0);

   signal vgaClk : sl;
   --
   signal red   : slv(4 - 1 downto 0);
   signal green : slv(4 - 1 downto 0);
   signal blue  : slv(4 - 1 downto 0);
   --
   signal hcnt : slv(32 - 1 downto 0);
   signal vcnt : slv(32 - 1 downto 0);
   --
   signal hsync : sl;
   signal vsync : sl;
   --
   signal hvisible : sl;
   signal vvisible : sl;

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
   fwLeds <= fwBtn;

   fwRgbLeds((0 + 1) * 3 - 1 downto 0 * 3) <= (others => fwSwitch(0));
   fwRgbLeds((1 + 1) * 3 - 1 downto 1 * 3) <= (others => fwSwitch(1));
   fwRgbLeds((2 + 1) * 3 - 1 downto 2 * 3) <= (others => fwSwitch(2));
   fwRgbLeds((3 + 1) * 3 - 1 downto 3 * 3) <= (others => fwSwitch(3));

   u_VgaSync : entity work.VgaSync
      generic map (
         TPD_G                   => TPD_G,
         VGA_HORIZONTAL_TIMING_G => VESA_640x480_AT_75HZ_C.horizontalTiming,
         VGA_VERTICAL_TIMING_G   => VESA_640x480_AT_75HZ_C.verticalTiming
      )
      port map (
         clk_i => vgaClk,
         rst_i => rst,
         en_i  => '1',

         hsync_o    => hsync,
         hvisible_o => hvisible,
         hcnt_o     => hcnt,

         vsync_o    => vsync,
         vvisible_o => vvisible,
         vcnt_o     => vcnt
      );

   u_VgaTestCtrl : entity work.VgaTestCtrl
      generic map (
         TPD_G                   => TPD_G,
         VGA_HORIZONTAL_TIMING_G => VESA_640x480_AT_75HZ_C.horizontalTiming,
         VGA_VERTICAL_TIMING_G   => VESA_640x480_AT_75HZ_C.verticalTiming
      )
      port map (
         clk_i => vgaClk,
         rst_i => rst,
         en_i  => '1',

         hvisible_i => hvisible,
         vvisible_i => vvisible,

         hcnt_i => hcnt,
         vcnt_i => vcnt,

         red_o   => red,
         green_o => green,
         blue_o  => blue
      );

   -----------------------------------------------------------------------------
   -- IOs
   -----------------------------------------------------------------------------
   -- Peripheral Io
   u_ArtyPeripheralIo : entity work.ArtyPeripheralIo
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

   u_VgaClk : entity work.clk31_5MHz
      port map (
         clk_out1 => vgaClk,
         reset    => rst,
         locked   => open,
         clk_in1  => clk
      );

   ja(3 downto 0) <= red;
   ja(7 downto 4) <= blue;
   jb(3 downto 0) <= green;
   jb(4)          <= hsync;
   jb(5)          <= vsync;
   jb(7 downto 6) <= (others => '0'); -- unconnected

end rtl;
---------------------------------------------------------------------------------------------------