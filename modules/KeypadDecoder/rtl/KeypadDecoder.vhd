---------------------------------------------------------------------------------------------------
--! @brief Keypad Decoder
--! @details The unit controls rows of keypad and reads columns of keypad. 
--! If one button on keypad is pressed, then only one bit will be active on port actKeys_o
--!
--! @author Rene Brglez (rene.brglez@cosylab.com)
--!
--! @date November 2022
--! 
--! @version v0.1
--!
--! @file KeypadDecoder.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.StdRtlPkg.all;

---------------------------------------------------------------------------------------------------
entity KeypadDecoder is
   generic (
      TPD_G       : time     := 1 ns;
      ROW_WIDTH_G : positive := 4;
      COL_WIDTH_G : positive := 4;

      COL_SAMPLE_DELAY_G : natural := 100 -- delay before sampling
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      en_i : in sl;

      row_o : out slv(ROW_WIDTH_G - 1 downto 0);
      col_i : in  slv(COL_WIDTH_G - 1 downto 0);

      actKeysUpd_o : out sl;
      actKeys_o    : out slv(ROW_WIDTH_G * COL_WIDTH_G - 1 downto 0)
   );
end KeypadDecoder;
---------------------------------------------------------------------------------------------------    
architecture rtl of KeypadDecoder is

   --! FSM state record
   type StateType is (
         IDLE_S,
         RD_COL_S,
         WR_ROW_S,
         DECODE_S
      );

   --! Record containing all FSM outputs and states
   type RegType is record
      row    : slv(row_o'range);
      cntRow : natural;
      --
      cntSampleDelay : natural;
      --
      actKeysUpd     : sl;
      actKeys        : slv(ROW_WIDTH_G * COL_WIDTH_G - 1 downto 0);
      actKeysLatched : slv(ROW_WIDTH_G * COL_WIDTH_G - 1 downto 0);
      --
      state : StateType;
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
         row    => (others => '0'),
         cntRow => 0,
         --
         cntSampleDelay => 0,
         --
         actKeysUpd     => '0',
         actKeys        => (others => '0'),
         actKeysLatched => (others => '0'),
         --
         state => IDLE_S
      );

   --! Output of registers
   signal r : RegType;

   --! Combinatorial input to registers
   signal rin : RegType;

---------------------------------------------------------------------------------------------------
begin

   p_Comb : process (all) is
      variable v : RegType;
   begin
      -- Latch the current value
      v := r;

      -- Strobe
      v.actKeysUpd := '0';

      -- State Machine
      case r.state is
         ----------------------------------------------------------------------
         when IDLE_S =>
            --
            v.row            := (others => '0');
            v.cntSampleDelay := 0;

            if (en_i = '1') then
               v.state := WR_ROW_S;
            end if;
         ----------------------------------------------------------------------
         when WR_ROW_S =>
            v.row           := (others => '0');
            v.row(r.cntRow) := '1';

            v.state := RD_COL_S;

         -----------------------------------------------------------------------
         when RD_COL_S =>

            if (r.cntSampleDelay = COL_SAMPLE_DELAY_G) then

               v.actKeys((r.cntRow + 1) * ROW_WIDTH_G - 1 downto r.cntRow * ROW_WIDTH_G) := col_i;
               --
               v.cntSampleDelay := 0;

               v.state := DECODE_S;

            else
               v.cntSampleDelay := r.cntSampleDelay + 1;
            end if;

         ----------------------------------------------------------------------
         when DECODE_S =>

            if (r.cntRow = ROW_WIDTH_G - 1) then
               v.cntRow         := 0;
               v.actKeysUpd     := '1';
               v.actKeys        := (others => '0');
               v.actKeysLatched := r.actKeys;
            else
               v.cntRow := r.cntRow + 1;
            end if;

            v.state := WR_ROW_S;

         ----------------------------------------------------------------------
         when others =>
            v := REG_INIT_C;
      ----------------------------------------------------------------------
      end case;

      if (en_i = '0') then
         v.state := IDLE_S;
      end if;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      row_o <= r.row;

      actKeysUpd_o <= r.actKeysUpd;
      actKeys_o    <= r.actKeysLatched;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------