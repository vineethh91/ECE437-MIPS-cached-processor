library ieee;
use ieee.std_logic_1164.all;

entity pipelineRegister_IF_ID is
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
    
    IF_instruction : in STD_LOGIC_VECTOR(31 downto 0);
    IF_programCounter : in STD_LOGIC_VECTOR(31 downto 0);
    
    ID_instruction : out STD_LOGIC_VECTOR(31 downto 0);
    ID_programCounter : out STD_LOGIC_VECTOR(31 downto 0)
    );

end ;

architecture arch_pipelineRegister_IF_ID of pipelineRegister_IF_ID is
  signal present_val_instruction, present_val_programCounter: std_logic_vector(31 downto 0);
  signal next_val_instruction, next_val_programCounter: std_logic_vector(31 downto 0);
begin
  reg: process(clk, rst_n, regWriteEnable)
  begin
    if(rst_n = '0') then
      present_val_instruction <= x"00000000";
      present_val_programCounter <= x"00000000";
    elsif(rising_edge(clk)) then
      if(regWriteEnable = '1') then
        if(next_val_instruction = x"BAD1BAD1") then
          present_val_instruction <= x"00000000";
        else
          present_val_instruction <= next_val_instruction;
        end if;
        present_val_programCounter <= next_val_programCounter;
      end if;
    end if;
  end process;
  
  next_val_instruction <= IF_instruction;
  ID_instruction <= present_val_instruction;
  
  next_val_programCounter <= IF_programCounter;
  ID_programCounter <= present_val_programCounter;
  

end arch_pipelineRegister_IF_ID;