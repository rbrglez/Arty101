---------------------------------------------------------------------------------------------------
--! @brief 
--! @details 
--!
--! @author Rene Brglez (rene.brglez@cosylab.com)
--!
--! @date November 2022
--! 
--! @version v0.1
--!
--! @file SegmentDisplay.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library surf;
use surf.StdRtlPkg.all;

---------------------------------------------------------------------------------------------------
entity SegmentDisplay is
   generic (
      TPD_G : time := 1 ns
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      en_i : in sl;

      data_i     : in  slv(4 - 1 downto 0);
      segments_o : out slv(8 - 1 downto 0)
   );
end SegmentDisplay;
---------------------------------------------------------------------------------------------------    
architecture rtl of SegmentDisplay is

   --! Record containing all FSM outputs and states
   type RegType is record
      segments : slv(segments_o'range);
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
         segments => (others => '0')
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

      if (en_i = '1') then
         case data_i is
            when x"0"   => v.segments := x"11";
            when x"1"   => v.segments := x"12";
            when x"2"   => v.segments := x"24";
            when x"3"   => v.segments := x"28";
            when x"4"   => v.segments := x"41";
            when x"5"   => v.segments := x"42";
            when x"6"   => v.segments := x"84";
            when x"7"   => v.segments := x"88";
            when x"8"   => v.segments := x"07";
            when x"9"   => v.segments := x"70";
            when others => v.segments := x"00";
         end case;

      else
         v.segments := x"00";
      end if;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      segments_o <= r.segments;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------