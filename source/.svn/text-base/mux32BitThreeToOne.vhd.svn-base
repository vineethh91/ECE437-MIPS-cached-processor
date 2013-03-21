library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32BitThreeToOne is
    port ( 
        val0, val1, val2: IN STD_LOGIC_VECTOR (31 downto 0);
        muxEnable: IN STD_LOGIC_VECTOR(1 downto 0);
        muxOutput: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
end mux32BitThreeToOne;

architecture arch_mux32BitThreeToOne of mux32BitThreeToOne is
    
begin
  with muxEnable select
    muxOutput <= val0 when "00",
                 val1 when "01",
                 val2 when others;

end arch_mux32BitThreeToOne;