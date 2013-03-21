library ieee;
use ieee.std_logic_1164.all;

entity pcWriteEnableControl is
  port(
    clk : in std_logic;
    rst_n : in std_logic;
    iMemWait: in std_logic;
    dMemWait : in std_logic;
    halt_flag : in std_logic;
    arbiterPCWE : in std_logic;
    dMemRead : in std_logic;
    dMemWrite : in std_logic;
    
    iMemRead : out std_logic;
    halt_output_flag : out std_logic;
    pcWriteEnable: out std_logic
    );

end pcWriteEnableControl;

architecture arch_pcWriteEnableControl of pcWriteEnableControl is
  signal output : std_logic;  
   type state_type is (START_MACHINE, START_MACHINE_2, IDLE, IFETCH, DFETCH, HALT, WAIT_FOR_LOAD_STORE);
  signal state, nextState : state_type;
  signal internalPCWriteEnable : std_logic;
begin

  pcWriteEnableReg: process(clk, rst_n, iMemWait, halt_flag)
  begin
    if(rst_n = '0') then
      state <= IDLE;
    elsif(rising_edge(clk)) then
      case state is
        
        when START_MACHINE =>
          if(iMemWait = '0') then
            state <= START_MACHINE_2;
          end if;
          
        when START_MACHINE_2 =>
          if(iMemWait = '1') then
            state <= IDLE;
          end if;
          
        when IDLE => 
--          pcWriteEnable <= '0';
          if(iMemWait = '1' and dMemRead /= '1' and dMemWrite /= '1') then
--            pcWriteEnable <= '0';
            state <= IFETCH;
          elsif(halt_flag = '1') then
--            pcWriteEnable <= '0';
            state <= HALT;
          elsif(dMemRead = '1' or dMemWrite = '1') then
            state <= WAIT_FOR_LOAD_STORE;
         -- else
         --   state <= IFETCH;
          end if;
      
        when IFETCH =>
--          pcWriteEnable <= '0';
          if(halt_flag = '1') then
            state <= HALT;
          elsif(iMemWait = '0') then
--            pcWriteEnable <= '1';
            state <= IDLE;
          end if;
          
        when WAIT_FOR_LOAD_STORE =>
          if(halt_flag = '1') then
            state <= HALT;
          elsif(iMemWait = '0') then
            state <= IDLE;
          end if;
          
        when HALT =>
--          pcWriteEnable <= '0';
          state <= HALT;
          
        when OTHERS =>
          state <= IDLE;
          
      end case; 
    end if;
end process;
  
  halt_output_flag <= '1' when (state = HALT) else '0';
  
  internalPCWriteEnable <= '1' when (((state = IDLE) and ((iMemWait = '0')  and (dMemWait = '0'))) or ((state = IFETCH) and ((iMemWait = '0')  and (dMemWait = '0'))) or ((state = WAIT_FOR_LOAD_STORE) and ((iMemWait = '0') and (dMemWait = '0')))) else '0';
--  internalPCWriteEnable <= '1' when (((state = IDLE) and (iMemWait = '0')) or ((state = IFETCH) and (iMemWait = '0'))) else '0';
  pcWriteEnable <= internalPCWriteEnable and arbiterPCWE;
  
  iMemRead <= '1' when (iMemWait = '0') else '0';
  
end arch_pcWriteEnableControl;