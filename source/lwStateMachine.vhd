library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lwStateMachine is
    port(
    clk: in std_logic;
    rst_n: in std_logic;
    opcode : in STD_LOGIC_VECTOR(5 downto 0);
    pcWriteEnable: out std_logic;
    haltFlag : out std_logic
  );
end lwStateMachine;

architecture arch_lwStateMachine of lwStateMachine is
  type state_type is (IDLE, LW_HOLD, LW_HOLD_2, HALT);
  signal state, nextState : state_type;
begin

  pcWriteEnableReg: process(clk, rst_n, opcode)
  begin
    if(rst_n = '0') then
      state <= IDLE;
    elsif(rising_edge(clk)) then
      case state is
        
        when IDLE => 
          if(opcode="111111") then
            state <= HALT;
          elsif(opcode="100011") then
            state <= LW_HOLD;
          end if;
      
        when LW_HOLD =>
          state <= IDLE;
          
        when HALT =>
          state <= HALT;
          
        when OTHERS =>
          state <= IDLE;
          
      end case; 
    end if;
  end process;
          
  haltFlag <= '1' when state = HALT else '0';
  pcWriteEnable <= '0' when (((state = IDLE) and opcode="100011")) or (state = HALT) else '1';
--    elsif(rising_edge(clk)) then
--      state <= nextState;
--    end if;
--  end process;
--    
--  FSM: process(state, opcode)
--  begin
--    nextState <= state;
--    pcWriteEnable <= '1';
--    haltFlag <= '0';
--    case state is
--      when IDLE => 
--        if(opcode="111111") then
--          nextState <= HALT;
--        elsif(opcode="100011") then
--          nextState <= LW_HOLD;
--        end if;
--      
--      when LW_HOLD =>
--        nextState <= IDLE;
--        haltFlag <= '0';
--        pcWriteEnable <= '0';
--            
--      when HALT =>
--        nextState <= HALT;
--        haltFlag <= '1';
--        pcWriteEnable <= '0';
--          
--      when OTHERS =>
--        nextState <= IDLE;
--    end case;
--  end process;
 
end architecture;
