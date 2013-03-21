library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcUpdate is
    port ( 
        programCounter: IN STD_LOGIC_VECTOR (31 downto 0);
        jlabel: IN STD_LOGIC_VECTOR (25 downto 0);
        updatedPC: OUT STD_LOGIC_VECTOR(31 downto 0)
        );
end pcUpdate;

architecture arch_pcUpdate of pcUpdate is
    
begin

    updatedPC <= programCounter(31 downto 28) & jlabel & "00";

end arch_pcUpdate;