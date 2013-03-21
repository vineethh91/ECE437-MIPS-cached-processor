library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux1Bit is
    port ( 
        val0, val1: IN STD_LOGIC;
        muxEnable: IN STD_LOGIC;
        muxOutput: OUT STD_LOGIC
        );
end mux1Bit;

architecture arch_mux1Bit of mux1Bit is

    
begin
  with muxEnable select
    muxOutput <= val0 when '0',
                 val1 when others;

end arch_mux1Bit;