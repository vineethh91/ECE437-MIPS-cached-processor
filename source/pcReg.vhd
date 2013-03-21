library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcReg is
    port(
    clk: in std_logic;
    rst_n: in std_logic;
    pcWriteEnable: in std_logic;
    nextPC: in std_logic_vector(31 downto 0);
    programCounter: out std_logic_vector(31 downto 0)
    );
end pcReg;

architecture arch_pcReg of pcReg is
  --signal present_val: std_logic_vector(31 downto 0);
  --signal next_val: std_logic_vector(31 downto 0);
begin
  reg: process(clk, rst_n, pcWriteEnable)
  begin
    if(rst_n = '0') then
      --present_val <= x"00000000";
      programCounter <= (others => '0');
    elsif(rising_edge(clk)) then
      if(pcWriteEnable = '1') then
        --present_val <= next_val;
        programCounter <= nextPC;
      end if;
    end if;
  end process;
  
  --next_val <= nextPC;
  --programCounter <= present_val;
  
end arch_pcReg;
