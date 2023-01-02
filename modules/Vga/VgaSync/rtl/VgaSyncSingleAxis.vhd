---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncSingleAxis.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;
use work.VgaPkg.all;

entity VgaSyncSingleAxis is
   generic (
      TPD_G        : time := 1 ns;
      VGA_TIMING_G : VgaTimingType
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      cntEn_i : in  sl;
      cntEn_o : out sl;

      cnt_o     : out slv(32 - 1 downto 0);
      visible_o : out sl;
      sync_o    : out sl
   );
end VgaSyncSingleAxis;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncSingleAxis is
   
   -- Local constants
   constant VISIBLE_C     : natural := VGA_TIMING_G.visibleArea;
   constant FRONT_PORCH_C : natural := VISIBLE_C + VGA_TIMING_G.frontPorch;
   constant SYNC_C        : natural := FRONT_PORCH_C + VGA_TIMING_G.syncPulse;
   constant BACK_PORCH_C  : natural := SYNC_C + VGA_TIMING_G.backPorch;

   --! FSM state record
   type StateType is (
         VISIBLE_S,
         FRONT_PORCH_S,
         SYNC_S,
         BACK_PORCH_S
      );

   type RegType is record
      cnt     : natural;
      sync    : sl;
      cntEn   : sl;
      visible : sl;
      --
      state : StateType;
   end record RegType;

   constant REG_INIT_C : RegType := (
         cnt     => 0,
         sync    => '1',
         cntEn   => '0',
         visible => '0',
         --
         state => VISIBLE_S
      );

   --! Output of registers
   signal r : RegType;

   --! Combinatorial input to registers
   signal rin : RegType;

---------------------------------------------------------------------------------------------------
begin

   -- VGA_TIMING_G.whole check
   assert (
         VGA_TIMING_G.visibleArea +
         VGA_TIMING_G.frontPorch +
         VGA_TIMING_G.syncPulse +
         VGA_TIMING_G.backPorch =
         VGA_TIMING_G.whole
      )
      report "VGA_TIMING_G.whole check fails"
      severity failure;

   p_Comb : process (all) is
      variable v : RegType;
   begin
      -- Latch the current value
      v := r;

      -- strobe
      v.cntEn := '0';

      -- NOTE: state machine is active if cntEn_i port is high
      if (cntEn_i = '1') then

         v.cnt := r.cnt + 1;

         -- State Machine
         case r.state is
            --------------------------------------------------------------------
            when VISIBLE_S =>
               --
               v.visible := '1';

               if (r.cnt = VISIBLE_C - 1) then
                  v.visible := '0';
                  v.sync    := '1';
                  v.state   := FRONT_PORCH_S;
               end if;

            --------------------------------------------------------------------
            when FRONT_PORCH_S =>

               if (r.cnt = FRONT_PORCH_C - 1) then
                  v.visible := '0';
                  v.sync    := '0';
                  v.state   := SYNC_S;
               end if;

            --------------------------------------------------------------------
            when SYNC_S =>

               if (r.cnt = SYNC_C - 1) then
                  v.visible := '0';
                  v.sync    := '1';
                  v.state   := BACK_PORCH_S;
               end if;

            --------------------------------------------------------------------
            when BACK_PORCH_S =>

               if (r.cnt = BACK_PORCH_C - 1) then
                  v.visible := '1';
                  v.cnt     := 0;
                  v.sync    := '1';
                  v.state   := VISIBLE_S;
                  v.cntEn   := '1';

               end if;

            --------------------------------------------------------------------
            when others =>
               v := REG_INIT_C;
         --------------------------------------------------------------------
         end case;

      end if;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      sync_o    <= r.sync;
      cnt_o     <= toSlv(r.cnt, cnt_o'length);
      visible_o <= r.visible;
      cntEn_o   <= r.cntEn;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------