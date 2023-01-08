----------------------------------------------------------------------------------------------------
-- @brief SegmentDisplayPkg
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date January 2023
-- 
-- @version v0.1
--
-- @file SegmentDisplayPkg.vhd
--
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.StdRtlPkg.all;

package SegmentDisplayPkg is

   -----------------------------------------------------------------------------
   -- Definition of Segments
   -----------------------------------------------------------------------------
   --    _______ 
   --   |   A   |
   --  F|       |B
   --   |_______|
   --   |   G   |
   --  E|       |C  _  
   --   |_______|  |_| DP
   --       D  

   constant SEGMENT_A_C  : natural := 0;
   constant SEGMENT_B_C  : natural := 1;
   constant SEGMENT_C_C  : natural := 2;
   constant SEGMENT_D_C  : natural := 3;
   constant SEGMENT_E_C  : natural := 4;
   constant SEGMENT_F_C  : natural := 5;
   constant SEGMENT_G_C  : natural := 6;
   constant SEGMENT_DP_C : natural := 7;

   -----------------------------------------------------------------------------
   -- Numbers
   -----------------------------------------------------------------------------
   -- 1
   constant SEG_DIS_ONE_C : slv(8 - 1 downto 0) := (
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         others      => '0'
      );

   -- 2
   constant SEG_DIS_TWO_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_G_C => '1',
         SEGMENT_E_C => '1',
         SEGMENT_D_C => '1',
         others      => '0'
      );

   -- 3
   constant SEG_DIS_THREE_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_D_C => '1',
         SEGMENT_G_C => '1',
         others      => '0'
      );

   -- 4
   constant SEG_DIS_FOUR_C : slv(8 - 1 downto 0) := (
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_G_C => '1',
         SEGMENT_F_C => '1',
         others      => '0'
      );

   -- 5
   constant SEG_DIS_FIVE_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_F_C => '1',
         SEGMENT_G_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_D_C => '1',
         others      => '0'
      );

   -- 6
   constant SEG_DIS_SIX_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_F_C => '1',
         SEGMENT_E_C => '1',
         SEGMENT_D_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_G_C => '1',
         others      => '0'
      );

   -- 7
   constant SEG_DIS_SEVEN_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         others      => '0'
      );

   -- 8
   constant SEG_DIS_EIGHT_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_D_C => '1',
         SEGMENT_E_C => '1',
         SEGMENT_F_C => '1',
         SEGMENT_G_C => '1',
         others      => '0'
      );

   -- 9
   constant SEG_DIS_NINE_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_D_C => '1',
         SEGMENT_F_C => '1',
         SEGMENT_G_C => '1',
         others      => '0'
      );

   -- 0
   constant SEG_DIS_ZERO_C : slv(8 - 1 downto 0) := (
         SEGMENT_A_C => '1',
         SEGMENT_B_C => '1',
         SEGMENT_C_C => '1',
         SEGMENT_D_C => '1',
         SEGMENT_E_C => '1',
         SEGMENT_F_C => '1',
         others      => '0'
      );

   -----------------------------------------------------------------------------
   -- Special characters
   -----------------------------------------------------------------------------
   constant SEG_DIS_POINT_C : slv(8 - 1 downto 0) := (
         SEGMENT_DP_C => '1',
         others       => '0'
      );

end SegmentDisplayPkg;

package body SegmentDisplayPkg is

end package body SegmentDisplayPkg;
