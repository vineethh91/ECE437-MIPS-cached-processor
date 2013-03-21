library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32Bit is
    port ( 
        val0, val1: IN STD_LOGIC_VECTOR (31 downto 0);
        muxEnable: IN STD_LOGIC;
        muxOutput: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
end mux32Bit;

architecture arch_mux32Bit of mux32Bit is

    
begin
  with muxEnable select
    muxOutput <= val0 when '0',
                 val1 when others;


end arch_mux32Bit;